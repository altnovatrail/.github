# shellcheck shell=bash disable=SC2016 # jq's variables and GitHub's expressions stay unexpanded in single quotes.
# The tests of typescript.yml (R19 and its amendments): the shape its callers' rulesets name —
# "TypeScript / lint", "/ test", "/ vuln", "/ licenses" — and its steps "Toolchain image" and
# ci-${{ matrix.check }}, each run with a stand-in docker that writes down what it was asked.
# The checkout, which takes the spec submodule for the licenses job alone, is an action, and the
# harness runs no action: its input is read as text.
# shellcheck source=tests/lib.sh
. "${BASH_SOURCE[0]%/*}/lib.sh"

test_typescript_is_called_with_no_inputs_no_secrets_and_read_permission_alone() {
    use_workflow typescript.yml
    assert_eq "$(wf '.on')" '{"workflow_call":null}' "on"
    assert_eq "$(wf '.permissions')" '{"contents":"read"}' "the workflow's permissions"
    assert_eq "$(wf '.jobs | keys')" '["check"]' "the jobs"
    assert_eq "$(wf '[.jobs[] | select(has("permissions"))] | length')" 0 "the jobs with permissions of their own"
}

test_typescript_runs_each_check_as_a_job_named_after_it() {
    use_workflow typescript.yml
    assert_eq "$(wf '.jobs.check.strategy')" '{"fail-fast":false,"matrix":{"check":["lint","test","vuln","licenses"]}}' "the strategy"
    assert_eq "$(wf '.jobs.check.name')" '"${{ matrix.check }}"' "the job's name"
}

test_typescript_checks_the_submodule_out_for_the_licenses_job_alone() {
    use_workflow typescript.yml
    assert_eq "$(wf '.jobs.check.steps[0].with')" \
        '{"submodules":"${{ matrix.check == '"'licenses'"' }}","persist-credentials":false}' "the checkout's inputs"
}

test_typescript_builds_the_toolchain_stage_from_the_dockerfile_alone() {
    use_workflow typescript.yml
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

test_typescript_runs_each_recipe_with_ci_and_the_test_job_alone_with_the_hosts_ipc() {
    use_workflow typescript.yml
    select_step check 'name=ci-${{ matrix.check }}'
    local checks check
    local -a ipc
    checks=$(matrix_values check check)
    assert_eq "$checks" $'lint\ntest\nvuln\nlicenses' "the checks"
    stub docker
    runner_env STRAY_TOKEN "a variable of the runner's the step does not name"
    for check in $checks; do
        ipc=()
        if [ "$check" = test ]; then ipc=(--ipc=host); fi
        ctx matrix.check "$check"
        run_step
        assert_status 0
        assert_calls docker 1
        assert_call docker 1 run --rm --init "${ipc[@]}" --user "$(id -u):$(id -g)" --env HOME=/tmp --env CI \
            --volume "$step_workspace:/work" --workdir /work toolchain just "ci-$check"
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
