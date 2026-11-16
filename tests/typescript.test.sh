# shellcheck shell=bash disable=SC2016 # jq's variables and GitHub's expressions stay unexpanded in single quotes.
# The tests of typescript.yml (R19 and its amendments): the shape its callers' rulesets name —
# "TypeScript / lint", "/ test", "/ vuln", "/ licenses", and with the input engines "/ engines" —
# and its steps "Toolchain image", with its cache, which go.yml's cases run, and
# ci-${{ matrix.check }}, each run with a stand-in docker that writes down what it was asked, and
# the upload of the coverage, which is go.yml's but for its artifact and its report: the cases of
# go.yml run its steps, and the one here holds the two alike.
# The checkout, which takes the spec submodule for the licenses job alone, is an action, and the
# harness runs no action: its input is read as text.
# shellcheck source=tests/lib.sh
. "${BASH_SOURCE[0]%/*}/lib.sh"

# The checks of the matrix, without the input engines and with it, one a line: the two lists the
# expression of the matrix chooses between, which must be the whole expression.
typescript_checks() {
    local expression lists with without
    local head="\${{ fromJSON(inputs.engines && '" between="' || '" tail="') }}"
    expression=$(wf_raw '.jobs.check.strategy.matrix.check')
    lists=${expression#"$head"}
    lists=${lists%"$tail"}
    with=${lists%%"$between"*}
    without=${lists#*"$between"}
    [ "$head$with$between$without$tail" = "$expression" ] && [[ $with$without != *"'"* ]] ||
        fail "the matrix of check chooses its checks otherwise than by inputs.engines: $expression"
    case $1 in
        with) jq -r '.[]' <<< "$with" ;;
        without) jq -r '.[]' <<< "$without" ;;
    esac
}

test_typescript_is_called_with_the_input_engines_alone_no_secrets_and_gives_the_token_to_the_coverage_job_alone() {
    use_workflow typescript.yml
    assert_eq "$(wf '.on.workflow_call | keys')" '["inputs"]' "on"
    assert_eq "$(wf '.on.workflow_call.inputs | map_values({type, default})')" '{"engines":{"type":"boolean","default":false}}' "the inputs"
    assert_eq "$(wf '.permissions')" '{"contents":"read"}' "the workflow's permissions"
    assert_eq "$(wf '.jobs | keys')" '["check","coverage","toolchain"]' "the jobs"
    assert_eq "$(wf '[.jobs | to_entries[] | select(.value | has("permissions")) | .key]')" '["coverage"]' "the jobs with permissions of their own"
    assert_eq "$(wf '.jobs.coverage.permissions')" '{"contents":"read","id-token":"write"}' "the coverage job's permissions"
}

test_typescript_hands_its_lcov_report_on_by_an_artifact_of_its_own() {
    use_workflow typescript.yml
    assert_eq "$(wf '.jobs.check.steps[-1].with')" \
        '{"name":"typescript-coverage","path":"coverage/lcov.info","retention-days":7,"if-no-files-found":"error"}' "the inputs of the step that uploads the report"
    assert_eq "$(wf '.jobs.coverage.steps[1].with.name')" '"typescript-coverage"' "the artifact the coverage job downloads"
    assert_eq "$(wf '.jobs.coverage.steps[3].with.files')" '"coverage/lcov.info"' "the report it uploads"
}

test_typescript_uploads_its_coverage_as_go_does_but_for_its_artifact_and_report() {
    local go="$state/go.json" typescript
    use_workflow go.yml
    # go.yml saves its Go caches after the report (R41), which typescript.yml has none of.
    wf '{report: [.jobs.check.steps[] | select(.name == "ci-${{ matrix.check }}" or .name == "Coverage report")], coverage: .jobs.coverage}' > "$go"
    use_workflow typescript.yml
    # The ci- step differs by --init and --ipc, which cases of their own hold; here only its name
    # stands, so that the report comes right after it in both.
    typescript=$(wf '{report: (.jobs.check.steps[-2:] | .[0] |= {name}), coverage: .jobs.coverage} | tojson
        | gsub("typescript-coverage"; "go-coverage") | gsub("coverage/lcov\\.info"; "coverage/go.out") | fromjson')
    assert_eq "$typescript" "$(jq -c '.report[0] |= {name}' "$go")" "the upload of typescript.yml, read as go.yml's"
}

test_typescript_runs_each_check_as_a_job_named_after_it() {
    use_workflow typescript.yml
    assert_eq "$(wf '.jobs.check.strategy | del(.matrix.check)')" '{"fail-fast":false,"matrix":{}}' "the strategy"
    assert_eq "$(wf '.jobs.check.name')" '"${{ matrix.check }}"' "the job's name"
}

# Without the input the callers' rulesets name the four checks they named before (R19); with it
# "TypeScript / engines" comes beside "TypeScript / test", and nothing else changes.
test_typescript_runs_the_check_engines_with_the_input_alone() {
    use_workflow typescript.yml
    assert_eq "$(typescript_checks without)" $'lint\ntest\nvuln\nlicenses' "the checks without engines"
    assert_eq "$(typescript_checks with)" $'lint\ntest\nengines\nvuln\nlicenses' "the checks with engines"
}

test_typescript_checks_the_submodule_out_for_the_licenses_job_alone() {
    use_workflow typescript.yml
    assert_eq "$(wf '.jobs.check.steps[0].with')" \
        '{"submodules":"${{ matrix.check == '"'licenses'"' }}","persist-credentials":false}' "the checkout's inputs"
}

# The stage, its cache and the job toolchain are go.yml's, step for step, but for the name of the
# artifact: the cases of go.yml run them, and the tests there hold the jobs of both files to the
# same steps (R36, R42).
test_typescript_builds_the_toolchain_stage_and_caches_it_as_go_does() {
    local go typescript
    use_workflow go.yml
    go=$(wf '{toolchain: .jobs.toolchain, check: (.jobs.check.steps | (map(.name) | index("Toolchain image")) as $i | .[$i - 2:$i + 1])}')
    use_workflow typescript.yml
    typescript=$(wf '{toolchain: .jobs.toolchain, check: (.jobs.check.steps | (map(.name) | index("Toolchain image")) as $i | .[$i - 2:$i + 1])}
        | .toolchain.steps[-1].with.name |= sub("^typescript-"; "go-")')
    assert_eq "$typescript" "$go" "the toolchain stage, its cache and the job toolchain"
}

test_typescript_runs_each_recipe_with_ci_and_the_jobs_test_and_engines_alone_with_the_hosts_ipc() {
    use_workflow typescript.yml
    local checks check
    local -a ipc
    checks=$(typescript_checks with)
    select_step check 'name=ci-${{ matrix.check }}'
    stub docker
    runner_env STRAY_TOKEN "a variable of the runner's the step does not name"
    for check in $checks; do
        ipc=()
        case $check in test | engines) ipc=(--ipc=host) ;; esac
        ctx matrix.check "$check"
        run_step
        assert_status 0
        assert_calls docker 1
        assert_call docker 1 run --rm --init "${ipc[@]}" --user "$(id -u):$(id -g)" --env HOME=/tmp --env CI \
            --volume "$step_workspace:/work" --workdir /work novatrail-toolchain just "ci-$check"
        assert_call_record docker 1 env CI=true
    done
}

test_typescript_fails_the_check_with_the_recipe() {
    use_workflow typescript.yml
    select_step check 'name=ci-${{ matrix.check }}'
    ctx matrix.check lint
    stub docker
    stub_exit docker 1
    run_step
    assert_status 1
}
