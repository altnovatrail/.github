# shellcheck shell=bash disable=SC2016 # jq's variables and GitHub's expressions stay unexpanded in single quotes.
# The tests of go.yml (R16): the shape its callers' rulesets name — "Go / lint", "Go / test",
# "Go / vuln", "Go / licenses" — and its steps "Toolchain image" and ci-${{ matrix.check }}, each
# run with a stand-in docker that writes down what it was asked.
# shellcheck source=tests/lib.sh
. "${BASH_SOURCE[0]%/*}/lib.sh"

test_go_is_called_with_no_inputs_no_secrets_and_read_permission_alone() {
    use_workflow go.yml
    assert_eq "$(wf '.on')" '{"workflow_call":null}' "on"
    assert_eq "$(wf '.permissions')" '{"contents":"read"}' "the workflow's permissions"
    assert_eq "$(wf '.jobs | keys')" '["check"]' "the jobs"
    assert_eq "$(wf '[.jobs[] | select(has("permissions"))] | length')" 0 "the jobs with permissions of their own"
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
