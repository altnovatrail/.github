# shellcheck shell=bash disable=SC2016 # jq's variables and GitHub's expressions stay unexpanded in single quotes.
# The tests of the harness itself, tests/lib.sh and tests/run.sh, on a workflow of their own. What
# the harness runs, it runs here as the other tests do; what it has to refuse or fail, it is made
# to, in a test file of its own that tests/run.sh runs: the test has to come out not ok, and say
# why.
# shellcheck source=tests/lib.sh
. "${BASH_SOURCE[0]%/*}/lib.sh"

# A workflow with a step for each thing the harness runs, refuses or fails.
workflow() {
    mkdir -p "$state/fixtures"
    cat > "$state/fixtures/w.yml" <<'EOF'
on:
  workflow_call:
env:
  TOP: top
jobs:
  j:
    runs-on: ubuntu-24.04
    env:
      JOB: job
    steps:
      - name: plain
        run: printf '%s\n' "$TOP $JOB"
      - name: paths
        env:
          X: "a-${{ matrix.v }}-b ${{matrix.w}}"
        run: printf '%s\n' "$X"
      - name: expression
        env:
          Y: ${{ a || b }}
        run: printf '%s\n' "$Y"
      - name: environment
        run: |
          printf 'PWD=%s\n' "$PWD"
          printf 'RUNNER_TEMP=%s\n' "$RUNNER_TEMP"
          printf 'OUTER=%s\n' "${OUTER-unset}"
          printf 'stdin=%s\n' "$(cat)"
          env | cut -d= -f1 | grep -vxE 'PWD|OLDPWD|SHLVL|_|LANG|LC_ALL' | sort | tr '\n' ' '
      - name: errexit
        run: |
          false
          echo went on
      - name: no pipefail
        run: |
          false | true
          echo went on
      - name: pipefail
        shell: bash
        run: |
          false | true
          echo went on
      - name: outputs
        run: printf 'a=b==\nt=\nh=x<<y\n' >> "$GITHUB_OUTPUT"
      - name: home
        env:
          HOME: /elsewhere
          CI: "false"
        run: printf '%s\n' "$HOME $CI"
      - name: path
        env:
          PATH: /bin
        run: "true"
      - name: twice
        run: "true"
      - name: twice
        run: "true"
      - name: action
        uses: ./an-action
      - name: no run
        env:
          Z: z
      - name: expression in run
        run: echo "${{ github.sha }}"
      - name: number
        env:
          N: 0.10
        run: "true"
      - name: boolean
        env:
          B: true
        run: "true"
      - name: empty
        env:
          E:
        run: "true"
      - name: runner's
        env:
          GITHUB_SHA: x
        run: "true"
      - name: sh
        shell: sh
        run: "true"
      - name: working directory
        working-directory: sub
        run: "true"
      - name: github env
        run: echo X=1 >> "$GITHUB_ENV"
      - name: heredoc output
        run: printf 'a<<EOF\nb\nEOF\n' >> "$GITHUB_OUTPUT"
      - name: masked
        run: gh api x || true
      - name: masked wget
        run: wget -q https://example.invalid/ || true
      - name: curl -f
        run: curl -fsS https://example.invalid/ || true
      - name: error
        run: |
          echo "::error::boom"
          exit 1
  token:
    runs-on: ubuntu-24.04
    permissions:
      id-token: write
    steps:
      - name: oidc
        run: printf '%s\n' "${ACTIONS_ID_TOKEN_REQUEST_URL-unset}"
  matrix:
    runs-on: ubuntu-24.04
    strategy:
      matrix:
        v: [lint, 3.10]
    steps:
      - name: s
        run: "true"
  listless:
    runs-on: ubuntu-24.04
    strategy:
      matrix:
        v: ${{ fromJSON(inputs.v) }}
    steps:
      - name: s
        run: "true"
  container:
    runs-on: ubuntu-24.04
    container: ubuntu
    steps:
      - name: s
        run: "true"
  windows:
    runs-on: windows-latest
    steps:
      - name: s
        run: "true"
EOF
}

# A test file of a case's own, its text from stdin, indented by four spaces that come off: so no
# line of this file starts with a test that is not its own. The file starts with the lines every
# test file starts with, fixtures names the folder of workflow(), and tests/run.sh runs it.
suite() {
    local file="$state/fixtures/$1.test.sh"
    {
        printf '# shellcheck shell=bash\n'
        printf '. %q\n' "$HARNESS_TESTS/lib.sh"
        printf 'fixtures=%q\n' "$state/fixtures"
        sed 's/^    //'
    } > "$file"
    run_suite "$file"
}

# A test of a case's own, its body given, that the harness has to stop, saying why.
refused() {
    suite case <<EOF
    test_case() {
        use_workflow "\$fixtures/w.yml"
        $1
    }
EOF
    assert_status 1
    assert_line "not ok 1 case.test.sh test_case"
    assert_line "  | harness: $2"
}

# A test of a case's own, its body given, that has to fail, saying why.
failed() {
    suite case <<EOF
    test_case() {
        use_workflow "\$fixtures/w.yml"
        $1
    }
EOF
    assert_status 1
    assert_line "not ok 1 case.test.sh test_case"
    assert_has "  | not ok: $2"
}

test_harness_fills_every_path_of_a_value_in_from_the_ctx() {
    workflow
    use_workflow "$state/fixtures/w.yml"
    select_step j name=plain
    run_step
    assert_status 0
    assert_line "top job"
    select_step j name=paths
    ctx matrix.v q
    ctx matrix.w r
    run_step
    assert_status 0
    assert_line "a-q-b r"
    select_step j name=expression
    set_env Y "as the case gives it"
    run_step
    assert_status 0
    assert_line "as the case gives it"
}

test_harness_gives_a_step_the_runners_environment_and_nothing_else() {
    workflow
    use_workflow "$state/fixtures/w.yml"
    select_step j name=environment
    export OUTER="a variable of the harness's own"
    run_step
    assert_status 0
    assert_line "PWD=$step_workspace"
    assert_line "RUNNER_TEMP=$step_temp"
    assert_line "OUTER=unset"
    assert_line "stdin="
    assert_line "CI GITHUB_ACTIONS GITHUB_ENV GITHUB_OUTPUT GITHUB_PATH GITHUB_STEP_SUMMARY GITHUB_WORKSPACE HOME JOB PATH RUNNER_TEMP TOP "
}

test_harness_gives_the_oidc_variables_to_a_job_that_may_ask_for_a_token() {
    workflow
    use_workflow "$state/fixtures/w.yml"
    select_step token name=oidc
    run_step
    assert_status 0
    assert_line "https://token.actions.invalid/?api-version=2.0"
    select_step j name=environment
    run_step
    assert_status 0
    refute_has ACTIONS_ID_TOKEN
}

test_harness_runs_a_step_in_the_shell_github_would() {
    workflow
    use_workflow "$state/fixtures/w.yml"
    select_step j name=errexit
    run_step
    assert_status 1
    refute_has "went on"
    select_step j name='no pipefail'
    run_step
    assert_status 0
    assert_line "went on"
    select_step j name=pipefail
    run_step
    assert_status 1
    refute_has "went on"
}

test_harness_reads_an_output_up_to_its_first_equals_sign() {
    workflow
    use_workflow "$state/fixtures/w.yml"
    select_step j name=outputs
    run_step
    assert_status 0
    assert_output a "b=="
    assert_output t ""
    assert_output h "x<<y"
    refute_output missing
}

test_harness_lets_a_step_set_what_github_lets_it_set() {
    workflow
    use_workflow "$state/fixtures/w.yml"
    select_step j name=home
    run_step
    assert_status 0
    assert_line "/elsewhere false"
}

test_harness_refuses_a_step_it_cannot_take_as_it_is() {
    workflow
    refused 'select_step j name=missing' "job j has 0 steps with name missing, not one"
    refused 'select_step j name=twice' "job j has 2 steps with name twice, not one"
    refused 'select_step j label=plain' "select_step takes id=<id> or name=<name>, not label=plain"
    refused 'select_step j name=action' "the step with name action of job j uses an action: only run steps run here"
    refused "select_step j 'name=no run'" "the step with name no run of job j has no run script"
    refused "select_step j 'name=expression in run'" "the step with name expression in run of job j has an expression in its run script, which only the runner evaluates: hand the value in by env"
    refused "select_step j 'name=working directory'" "the step with name working directory of job j has a working-directory, which the harness does not set"
    refused 'select_step container name=s' "job container runs in a container or with services, which the harness does not start"
    refused 'select_step windows name=s' "job windows runs on another runner than ubuntu-24.04"
    refused 'run_step' "no step is selected: select_step first"
}

test_harness_refuses_an_env_it_cannot_hand_in_as_github_would() {
    workflow
    refused 'select_step j name=paths; ctx matrix.v q; run_step' 'X is a-${{ matrix.v }}-b ${{matrix.w}}: give ctx matrix.w'
    refused 'select_step j name=paths; ctx matrix.v q; ctx matrix.w r; ctx inputs.x s; run_step' "ctx inputs.x: no value of the step's env asks for it"
    refused 'select_step j name=paths; ctx matrix.v q; ctx matrix.w r; set_env X x; run_step' 'set_env X: its value, a-${{ matrix.v }}-b ${{matrix.w}}, comes from the ctx'
    refused 'select_step j name=expression; run_step' 'Y is ${{ a || b }}, an expression only the runner evaluates: give it whole with set_env Y'
    refused 'select_step j name=plain; set_env TOP x; run_step' "set_env TOP: its value is plain, top"
    refused 'select_step j name=plain; set_env NONE x; run_step' "set_env NONE: the step's env has no NONE with an expression of its own"
    refused 'select_step j name=number; run_step' "N is a number in YAML, not a string: GitHub would hand the step its own rendering of it"
    refused 'select_step j name=boolean; run_step' "B is a boolean in YAML, not a string: GitHub would hand the step its own rendering of it"
    refused 'select_step j name=empty; run_step' "E is a null in YAML, not a string: GitHub would hand the step its own rendering of it"
    refused "select_step j \"name=runner's\"; run_step" "env names GITHUB_SHA: GitHub lets no step overwrite GITHUB_* and RUNNER_*"
    refused 'select_step j name=path; run_step' "env names PATH, which the harness keeps for its stand-ins and its token"
    refused 'matrix_values listless v' "the matrix of job listless gives v no list of values"
    refused 'select_step j name=plain; runner_env TOP x; run_step' "runner_env TOP: the step's env names TOP, so give its expressions with ctx or set_env"
    refused 'runner_env PATH /bin' "runner_env PATH: the harness sets PATH itself"
    refused 'ctx "matrix v" q' "ctx takes a path such as matrix.check, not matrix v"
    refused 'matrix_values matrix v' "the matrix of job matrix has values of v that are no strings in YAML: number string"
    refused 'select_step j name=sh; run_step' "the step runs in the shell sh, which the harness does not run"
}

test_harness_refuses_what_a_step_writes_and_it_does_not_read() {
    workflow
    refused "select_step j 'name=github env'; run_step" "the step wrote GITHUB_ENV, which no case of the harness reads yet"
    refused "select_step j 'name=heredoc output'; run_step" "the step wrote GITHUB_OUTPUT in a form the harness does not read: name=value lines alone"
}

test_harness_fails_a_test_that_would_pass_for_no_reason() {
    workflow
    failed 'select_step j name=plain; run_step; assert_status 0; assert_line other' "no line of the output is: other"
    failed 'select_step j name=masked; run_step; assert_status 0' "the step ran what no case expected: gh api x"
    failed "select_step j 'name=masked wget'; run_step; assert_status 0" "the step ran what no case expected: wget -q https://example.invalid/"
    failed 'select_step j name=plain; run_step; run_step; assert_status 0' "the test never asserts the exit status of the run before this one"
    failed "stub curl; select_step j 'name=curl -f'; run_step; assert_status 0" "the step ran what no case expected: curl: knows no option -fsS"
    failed ':' "the test asserts nothing"
    failed 'select_step j name=plain; run_step; assert_line "top job"' "the test never asserts the exit status of what it ran"
    failed 'if x=$(assert_eq a b); then :; fi; assert_eq "$x" ""' "the value is a, not b"
}

test_harness_keeps_the_output_of_a_failed_test_from_the_runner() {
    workflow
    failed 'select_step j name=error; run_step; assert_status 0' "it exited with 1, not 0"
    assert_line "  | ::error::boom"
    refute_line "::error::boom"
}

test_harness_runs_a_test_that_passes_as_ok() {
    workflow
    suite case <<'EOF'
    test_case() {
        use_workflow "$fixtures/w.yml"
        select_step j name=plain
        run_step
        assert_status 0
        assert_eq "${GITHUB_OUTPUT-unset}" unset "the GITHUB_OUTPUT of the job that runs the tests"
    }
EOF
    assert_status 0
    assert_line "ok 1 case.test.sh test_case"
    assert_line "1 tests, 0 failed"
}

test_harness_keeps_the_jobs_own_output_file_from_a_test() {
    workflow
    suite case <<'EOF'
    test_case() {
        assert_eq "${GITHUB_OUTPUT-unset}" unset "the GITHUB_OUTPUT of the job that runs the tests"
    }
EOF
    assert_status 0
    : > "$state/github_output"
    GITHUB_OUTPUT="$state/github_output" run_suite "$state/fixtures/case.test.sh"
    assert_eq "$(cat "$state/github_output")" "" "the job's own GITHUB_OUTPUT"
    assert_status 0
    assert_line "ok 1 case.test.sh test_case"
}

test_harness_fails_a_file_whose_tests_it_cannot_tell() {
    workflow
    suite none <<< '# no test here'
    assert_status 1
    assert_line "not ok 1 none.test.sh (it has no test)"
    suite twice <<'EOF'
    test_x() { assert_eq a a; }
    test_x() { assert_eq b b; }
EOF
    assert_status 1
    assert_line "not ok 1 twice.test.sh (a test is defined twice)"
    suite indented <<'EOF'
    test_x() { assert_eq a a; }
        test_y() { assert_eq b b; }
    function test_z { assert_eq c c; }
EOF
    assert_status 1
    assert_line "not ok 1 indented.test.sh (a test is not written as test_name() at the start of a line)"
    run_suite "$state/fixtures/missing.test.sh"
    assert_status 1
    assert_line "not ok 1 missing.test.sh (there is no such file)"
    suite broken <<< 'test_x() {'
    assert_status 1
    assert_line "not ok 1 broken.test.sh (it does not parse)"
    suite exits <<'EOF'
    exit 3
    test_x() { assert_eq a a; }
EOF
    assert_status 1
    assert_line "not ok 1 exits.test.sh (it cannot be read)"
}

test_harness_takes_the_yq_that_self_ci_pins_and_no_other() {
    workflow
    suite case <<< 'test_case() { assert_eq a a; }'
    assert_status 0
    YQ="" run_suite "$state/fixtures/case.test.sh"
    assert_status 2
    assert_has "run.sh: YQ names no yq."
    printf '#!/bin/sh\necho "yq (https://github.com/mikefarah/yq/) version v0.0.1"\n' > "$state/yq"
    chmod +x "$state/yq"
    YQ="$state/yq" run_suite "$state/fixtures/case.test.sh"
    assert_status 2
    assert_has 'version v0.0.1", and self-ci.yml pins yq'
}
