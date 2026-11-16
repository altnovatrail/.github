# shellcheck shell=bash disable=SC2016 # jq's variables and GitHub's expressions stay unexpanded in single quotes.
# The tests of self-ci.yml's own steps for the composite actions (R28, R49): "Lint the actions",
# which hands shellcheck the run script of each step of each action of .github/actions/, and the job
# Toolchain action, which runs .github/actions/toolchain as a caller's own job does.
# shellcheck source=tests/lib.sh
. "${BASH_SOURCE[0]%/*}/lib.sh"

# Two composite actions in the workspace — a with two run steps round a step that uses an action,
# b with one —, the yq of the suite and a stand-in shellcheck in RUNNER_TEMP, where the job's are.
lint_actions_step() {
    mkdir -p "$step_workspace/.github/actions/a" "$step_workspace/.github/actions/b"
    cat > "$step_workspace/.github/actions/a/action.yml" <<'YAML'
runs:
  using: composite
  steps:
    - name: first
      shell: bash -e {0}
      run: echo first
    - uses: actions/cache/restore@0000000000000000000000000000000000000000
    - name: second
      shell: bash -e {0}
      run: |
        echo second
        echo more
YAML
    cat > "$step_workspace/.github/actions/b/action.yml" <<'YAML'
runs:
  using: composite
  steps:
    - name: only
      shell: bash -e {0}
      run: echo only
YAML
    cp -- "$YQ" "$step_temp/yq"
    stub_in_temp shellcheck
    use_workflow self-ci.yml
    select_step workflows 'name=Lint the actions'
}

test_self_ci_lints_the_script_of_every_run_step_of_every_composite_action() {
    lint_actions_step
    run_step
    assert_status 0
    assert_calls shellcheck 3
    assert_call shellcheck 1 --shell=bash "$step_temp/action-step.sh"
    assert_eq "$(cat "$(harness_call shellcheck 1).script")" "echo first" "the first script of a"
    assert_eq "$(cat "$(harness_call shellcheck 2).script")" "$(printf 'echo second\necho more')" "the second script of a"
    assert_eq "$(cat "$(harness_call shellcheck 3).script")" "echo only" "the script of b"
}

test_self_ci_names_each_step_whose_script_fails_and_reads_the_rest() {
    lint_actions_step
    printf 'echo first\necho only\n' > "$state/stub/shellcheck.fails"
    run_step
    assert_status 1
    assert_calls shellcheck 3
    assert_line "::error file=.github/actions/a/action.yml::The script of the step first fails shellcheck."
    assert_line "::error file=.github/actions/b/action.yml::The script of the step only fails shellcheck."
    refute_has "the step second fails"
}

# The job takes the action by the local path twice, with the check action, round a build in the
# image with the Go caches mounted, as a caller's job would by the SHA of a release.
test_self_ci_runs_the_composite_action_as_a_callers_own_job() {
    use_workflow self-ci.yml
    assert_eq "$(wf '.jobs["toolchain-action"] | {name, "runs-on", needs, if}')" \
        '{"name":"Toolchain action","runs-on":"ubuntu-24.04","needs":null,"if":null}' "the job"
    assert_eq "$(wf '[.jobs["toolchain-action"].steps[] | if .run then {name} else . end | if .uses then .uses |= sub("@[0-9a-f]{40}$"; "@<sha>") else . end]')" \
        '[{"uses":"actions/checkout@<sha>","with":{"persist-credentials":false}},{"name":"Toolchain image and Go caches","uses":"./.github/actions/toolchain","with":{"check":"action"}},{"name":"The tool of the rules of code"},{"name":"Go caches into the cache","uses":"./.github/actions/toolchain","with":{"check":"action","save":"true"}}]' \
        "its steps"
    select_step toolchain-action 'name=The tool of the rules of code'
    stub docker
    run_step
    assert_status 0
    assert_calls docker 1
    assert_call docker 1 run --rm --user "$(id -u):$(id -g)" --env HOME=/tmp \
        --env GOMODCACHE=/go-cache/mod --env GOCACHE=/go-cache/build --env GOLANGCI_LINT_CACHE=/go-cache/lint \
        --volume "$step_workspace:/work" --volume "$step_temp/go-cache:/go-cache" --workdir /work \
        novatrail-toolchain go -C tools/coderules build ./...
}
