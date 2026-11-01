# shellcheck shell=bash disable=SC2016 # jq's variables and GitHub's expressions stay unexpanded in single quotes.
# The tests of go.yml (R16 and its amendments): the shape its callers' rulesets name — "Go / lint",
# "Go / test", "Go / vuln", "Go / licenses" — its steps "Toolchain image" and
# ci-${{ matrix.check }}, each run with a stand-in docker that writes down what it was asked, and
# the upload of the coverage: the report the test job hands on, the coverage job that alone gets
# the OIDC token, and its step "Codecov CLI", run with a stand-in curl. The steps that use an
# action the harness does not run: their inputs are read as text, and the actions are named
# without their SHAs, which Dependabot moves.
# shellcheck source=tests/lib.sh
. "${BASH_SOURCE[0]%/*}/lib.sh"

test_go_is_called_with_no_inputs_no_secrets_and_gives_the_token_to_the_coverage_job_alone() {
    use_workflow go.yml
    assert_eq "$(wf '.on')" '{"workflow_call":null}' "on"
    assert_eq "$(wf '.permissions')" '{"contents":"read"}' "the workflow's permissions"
    assert_eq "$(wf '.jobs | keys')" '["check","coverage"]' "the jobs"
    assert_eq "$(wf '[.jobs | to_entries[] | select(.value | has("permissions")) | .key]')" '["coverage"]' "the jobs with permissions of their own"
    assert_eq "$(wf '.jobs.coverage.permissions')" '{"contents":"read","id-token":"write"}' "the coverage job's permissions"
}

test_go_hands_the_report_of_the_test_job_alone_to_the_coverage_job() {
    use_workflow go.yml
    assert_eq "$(wf '[.jobs.check.steps[-2:][] | .name]')" '["ci-${{ matrix.check }}","Coverage report"]' "the last steps of the checks"
    assert_eq "$(wf '.jobs.check.steps[-1] | {if, uses: (.uses | sub("@[0-9a-f]{40}$"; "@<sha>"))}')" \
        '{"if":"matrix.check == '"'test'"'","uses":"actions/upload-artifact@<sha>"}' "the step that uploads the report"
    assert_eq "$(wf '.jobs.check.steps[-1].with')" \
        '{"name":"go-coverage","path":"coverage/go.out","retention-days":7,"if-no-files-found":"error"}' "its inputs"
    assert_eq "$(wf '[.jobs.check.steps[] | select(.uses // "" | startswith("actions/upload-artifact@"))] | length')" 1 "the steps that upload an artifact"
}

test_go_uploads_the_report_after_every_check_and_fails_only_a_pull_request_by_it() {
    use_workflow go.yml
    assert_eq "$(wf '.jobs.coverage | {name, needs, "runs-on", "timeout-minutes", "continue-on-error"}')" \
        '{"name":"coverage","needs":"check","runs-on":"ubuntu-24.04","timeout-minutes":10,"continue-on-error":"${{ github.event_name != '"'pull_request'"' }}"}' "the coverage job"
    assert_eq "$(wf '[.jobs.coverage.steps[] | .uses // .name | sub("@[0-9a-f]{40}$"; "@<sha>")]')" \
        '["actions/checkout@<sha>","actions/download-artifact@<sha>","Codecov CLI","codecov/codecov-action@<sha>"]' "its steps"
    assert_eq "$(wf '.jobs.coverage.steps[0].with')" '{"persist-credentials":false}' "the checkout's inputs"
    assert_eq "$(wf '.jobs.coverage.steps[1].with')" '{"name":"go-coverage","path":"coverage"}' "the download's inputs"
    assert_eq "$(wf '.jobs.coverage.steps[3].with')" \
        '{"binary":"${{ runner.temp }}/codecov","use_oidc":true,"files":"coverage/go.out","disable_search":true,"plugins":"noop","disable_telem":true,"fail_ci_if_error":true}' "the upload's inputs"
}

# The version and the sum of the Codecov CLI as the step pins them: an exact version, and a SHA-256.
cli_pins() {
    cli_version=$(wf_raw '.jobs.coverage.steps[] | select(.name == "Codecov CLI") | .env.CLI_VERSION')
    cli_sum=$(wf_raw '.jobs.coverage.steps[] | select(.name == "Codecov CLI") | .env.CLI_SHA256')
    [[ $cli_version =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || fail "CLI_VERSION is $cli_version, not an exact version"
    [[ $cli_sum =~ ^[0-9a-f]{64}$ ]] || fail "CLI_SHA256 is $cli_sum, not a SHA-256"
}

test_go_takes_the_codecov_cli_of_its_version_by_its_sum() {
    local real="$HARNESS_ROOT/.github/workflows/go.yml" copy="$state/go.yml" body="$state/codecov" sum
    use_workflow go.yml
    cli_pins
    # The step as go.yml has it, with the sum of a stand-in for the CLI in place of the real one's.
    printf 'a stand-in for the Codecov CLI\n' > "$body"
    sum=$(sha256sum < "$body")
    sed "s/^\( *CLI_SHA256: \)$cli_sum\$/\1${sum%% *}/" "$real" > "$copy"
    assert_eq "$(diff "$real" "$copy" | grep -c '^[<>]')" 2 "the lines the copy changes"
    use_workflow "$copy"
    select_step coverage 'name=Codecov CLI'
    stub curl
    curl_answer 200 < "$body"
    run_step
    assert_status 0
    assert_calls curl 1
    assert_call curl 1 -fsSL --proto =https --proto-redir =https --retry 3 --retry-all-errors \
        -o "$step_temp/codecov" "https://cli.codecov.io/$cli_version/linux/codecov"
    assert_eq "$(if [ -x "$step_temp/codecov" ] && cmp -s "$body" "$step_temp/codecov"; then echo ready; else echo not; fi)" ready "the CLI"
}

test_go_refuses_a_codecov_cli_of_another_sum() {
    use_workflow go.yml
    select_step coverage 'name=Codecov CLI'
    stub curl
    printf 'some other bytes\n' | curl_answer 200
    run_step
    assert_status 1
    assert_has "computed checksum did NOT match"
    assert_eq "$(if [ -x "$step_temp/codecov" ]; then echo executable; else echo not; fi)" not "the CLI"
}

test_go_fails_the_upload_without_the_codecov_cli() {
    use_workflow go.yml
    select_step coverage 'name=Codecov CLI'
    stub curl
    printf 'not found\n' | curl_answer 404
    run_step
    assert_status 22
    assert_eq "$(if [ -e "$step_temp/codecov" ]; then echo there; else echo none; fi)" none "the CLI"
    curl_offline
    run_step
    assert_status 7
    assert_eq "$(if [ -e "$step_temp/codecov" ]; then echo there; else echo none; fi)" none "the CLI"
}

test_go_runs_each_check_as_a_job_named_after_it() {
    use_workflow go.yml
    assert_eq "$(wf '.jobs.check.strategy')" '{"fail-fast":false,"matrix":{"check":["lint","test","vuln","licenses"]}}' "the strategy"
    assert_eq "$(wf '.jobs.check.name')" '"${{ matrix.check }}"' "the job's name"
}

test_go_builds_the_toolchain_stage_from_the_dockerfile_alone() {
    use_workflow go.yml
    select_step check 'name=Toolchain image'
    mkdir -p "$step_workspace/.devcontainer"
    printf 'FROM scratch AS toolchain\n' > "$step_workspace/.devcontainer/Dockerfile"
    stub docker
    run_step
    assert_status 0
    assert_calls docker 1
    assert_call docker 1 build --target toolchain --tag toolchain -
    assert_call_stdin docker 1 "$step_workspace/.devcontainer/Dockerfile"
}

test_go_runs_each_recipe_in_the_toolchain_stage_with_the_license_list_alone() {
    use_workflow go.yml
    select_step check 'name=ci-${{ matrix.check }}'
    local checks check allowed
    checks=$(matrix_values check check)
    assert_eq "$checks" $'lint\ntest\nvuln\nlicenses' "the checks"
    allowed=$(wf_raw '.jobs.check.steps[] | select(.name == "ci-${{ matrix.check }}") | .env.ALLOWED_LICENSES')
    stub docker
    runner_env STRAY_TOKEN "a variable of the runner's the step does not name"
    for check in $checks; do
        ctx matrix.check "$check"
        run_step
        assert_status 0
        assert_calls docker 1
        assert_call docker 1 run --rm --user "$(id -u):$(id -g)" --env HOME=/tmp --env ALLOWED_LICENSES \
            --volume "$step_workspace:/work" --workdir /work toolchain just "ci-$check"
        assert_call_record docker 1 env "ALLOWED_LICENSES=$allowed"
    done
}

test_go_fails_the_check_with_the_recipe() {
    use_workflow go.yml
    select_step check 'name=ci-${{ matrix.check }}'
    ctx matrix.check test
    stub docker
    stub_exit docker 3
    run_step
    assert_status 3
}
