# shellcheck shell=bash disable=SC2016 # jq's variables and GitHub's expressions stay unexpanded in single quotes.
# The harness of the tests of the workflows' steps (R28 in docs/decisions.md). A test takes a step
# of a workflow as its file has it, the run script byte for byte and the env as GitHub would hand
# it in. It runs that step with this machine's bash, in a directory of its own. In CI that machine
# is the runner, where the step runs in earnest, with the runner's own jq, tar, openssl and git.
# docker, gh, curl, wget, cosign and npm, which would reach the network or a container, are stand-ins,
# tests/stubs/, that fail until a case stands one of its own in. Neither a program a step calls by
# its absolute path nor git has one: a step that fetches by them gets its stand-ins with its cases. Each test is one bash process of its own (tests/run.sh), which sources its file,
# and its file sources this one.
#
# A step gets what a runner would give it and nothing else: env -i, then PATH with the stand-ins
# first, HOME, CI and GITHUB_ACTIONS, LANG and LC_ALL as they are here, fresh files for
# GITHUB_OUTPUT, GITHUB_ENV, GITHUB_PATH and GITHUB_STEP_SUMMARY, RUNNER_TEMP, GITHUB_WORKSPACE as
# its working directory, the OIDC variables when its job may ask for a token, what the case names
# with runner_env, and the step's env. RUNNER_TEMP and GITHUB_WORKSPACE hold characters a shell
# reads as syntax, so a step that leaves a path unquoted fails here.
#
# The env is the workflow's, then the job's, then the step's, as GitHub merges them. A value that is
# no string in YAML is refused: GitHub would hand the step a number, and 0.10 would come as 0.1.
# Every ${{ path }} in a value — matrix.check, inputs.publish, steps.npm-name.outputs.stem — is
# filled in from the case's ctx. A value with any other expression, as VERSION's ||, is the case's
# to give whole, by set_env. Whatever a value asks for and the case does not give, and whatever the
# case gives and no value asks for, stops the test. The harness never evaluates if: a case that
# cares reads its text, with wf.
#
# Helpers whose names start with harness_ are the harness's own; the rest are for the cases.

HARNESS_TESTS=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
HARNESS_ROOT=${HARNESS_TESTS%/*}
# Characters a shell reads as syntax, as spec's tests of its toolchain.sh put them in every path,
# but no colon: docker's --volume splits on it.
HARNESS_AWKWARD='a $HOME `id` "q" \ b'
HARNESS_PATH_RE='^[A-Za-z_][A-Za-z0-9_-]*(\.[A-Za-z_][A-Za-z0-9_-]*)*$'
# The names the harness sets itself, which no case may set again.
HARNESS_OWN=" PATH HOME CI GITHUB_ACTIONS LANG LC_ALL RUNNER_TEMP GITHUB_WORKSPACE GITHUB_OUTPUT GITHUB_ENV GITHUB_PATH GITHUB_STEP_SUMMARY ACTIONS_ID_TOKEN_REQUEST_URL ACTIONS_ID_TOKEN_REQUEST_TOKEN "

declare -gA HARNESS_CTX=() HARNESS_SET=() HARNESS_RUNNER=()

# Called by tests/run.sh before the test: the directories a step gets, and a stand-in that fails
# for each program no case expects yet.
harness_begin() {
    state=$HARNESS_STATE
    step_temp="$state/temp $HARNESS_AWKWARD"
    step_workspace="$state/workspace $HARNESS_AWKWARD"
    mkdir -p "$state/bin" "$state/stub" "$state/home" "$state/run/calls" "$step_temp" "$step_workspace"
    cp "$HARNESS_TESTS/stubs/record.sh" "$state/record.sh"
    local name
    for name in docker gh curl wget cosign npm; do
        install -m 755 "$HARNESS_TESTS/stubs/unexpected" "$state/bin/$name"
    done
    for name in cosign npm-isolated; do
        install -m 755 "$HARNESS_TESTS/stubs/unexpected" "$step_temp/$name"
    done
    : > "$state/asserts"
}

# Called by tests/run.sh after the test: what makes a test that passed pass for a reason.
harness_end() {
    if [ -s "$state/unexpected" ]; then
        fail "the step ran what no case expected: $(cat "$state/unexpected")"
    fi
    [ -s "$state/asserts" ] || fail "the test asserts nothing"
    [ ! -e "$state/run/status-unasserted" ] || fail "the test never asserts the exit status of what it ran"
}

# A failed assertion: the reason, then the step's output and calls. The marker file catches a
# failure inside $(...) or a pipeline, where exit leaves a subshell alone.
fail() {
    {
        printf 'not ok: %s\n' "$*"
        harness_show
    } >&2
    : > "$state/failed"
    exit 1
}

# A case the harness cannot run as asked: the case is wrong, not the step.
harness_refuse() {
    printf 'harness: %s\n' "$*" >&2
    : > "$state/failed"
    exit 2
}

harness_show() {
    local file
    if [ -f "$state/run/output" ]; then
        echo "output of what ran:"
        cat "$state/run/output"
    fi
    for file in "$state"/run/calls/*.argv; do
        [ -e "$file" ] || continue
        printf 'call %s:%s\n' "$(basename "$file" .argv)" "$(harness_argv "$file")"
    done
}

harness_argv() {
    local -a arguments
    mapfile -d '' -t arguments < "$1"
    if [ "${#arguments[@]}" -gt 0 ]; then
        printf ' %q' "${arguments[@]}"
    fi
}

harness_assert() {
    printf . >> "$state/asserts"
}

# The workflow the next steps and wf read: a file of .github/workflows/ by its name, or a path.
# yq reads the YAML into JSON once, and jq reads the JSON: so a step's run comes out byte for byte,
# and a value's type is JSON's.
use_workflow() {
    local file=$1
    [[ $file == /* ]] || file="$HARNESS_ROOT/.github/workflows/$file"
    [ -f "$file" ] || harness_refuse "there is no workflow $file"
    harness_json="$state/workflow.json"
    "$YQ" -o=json "$file" > "$harness_json" || harness_refuse "yq could not read $file"
    harness_job=""
    harness_index=""
}

# jq over the workflow, compact or raw: wf '.jobs.check.name'.
wf() {
    jq -c "$@" "$harness_json"
}

wf_raw() {
    jq -r "$@" "$harness_json"
}

harness_step() {
    jq "$@" --arg j "$harness_job" --argjson i "$harness_index" "$harness_json"
}

# The one step of the job with that id or that name: select_step release id=npm, or
# select_step check 'name=ci-${{ matrix.check }}'. A step that matches twice, or not at all, has no
# run of its own, or runs anywhere the harness does not, stops the test.
# It starts a step of its own: the ctx, set_env and runner_env given before it are dropped.
select_step() {
    local job=$1 selector=$2 key value count
    HARNESS_CTX=()
    HARNESS_SET=()
    HARNESS_RUNNER=()
    case $selector in
        id=*) key=id ;;
        name=*) key=name ;;
        *) harness_refuse "select_step takes id=<id> or name=<name>, not $selector" ;;
    esac
    value=${selector#*=}
    count=$(wf_raw --arg j "$job" --arg k "$key" --arg v "$value" '[.jobs[$j].steps // [] | .[] | select(.[$k] == $v)] | length')
    [ "$count" = 1 ] || harness_refuse "job $job has $count steps with $key $value, not one"
    harness_job=$job
    harness_index=$(wf_raw --arg j "$job" --arg k "$key" --arg v "$value" 'first(.jobs[$j].steps | to_entries[] | select(.value[$k] == $v) | .key)')
    local what="the step with $key $value of job $job"
    [ "$(harness_step -r '.jobs[$j].steps[$i] | has("uses")')" = false ] || harness_refuse "$what uses an action: only run steps run here"
    [ "$(harness_step -r '.jobs[$j].steps[$i].run | type')" = string ] || harness_refuse "$what has no run script"
    if harness_step -e '.jobs[$j].steps[$i].run | contains("${{")' > /dev/null; then
        harness_refuse "$what has an expression in its run script, which only the runner evaluates: hand the value in by env"
    fi
    if harness_step -e '[.jobs[$j].steps[$i]["working-directory"], .jobs[$j].defaults.run["working-directory"], .defaults.run["working-directory"]] | any(. != null)' > /dev/null; then
        harness_refuse "$what has a working-directory, which the harness does not set"
    fi
    if harness_step -e '.jobs[$j] | has("container") or has("services")' > /dev/null; then
        harness_refuse "job $job runs in a container or with services, which the harness does not start"
    fi
    [ "$(harness_step -r '.jobs[$j]["runs-on"]')" = ubuntu-24.04 ] || harness_refuse "job $job runs on another runner than ubuntu-24.04"
}

# The values of a key of a job's matrix, one a line; values that are no strings stop the test, as
# a value of env does.
matrix_values() {
    local types
    [ "$(wf_raw --arg j "$1" --arg k "$2" '.jobs[$j].strategy.matrix[$k] | type')" = array ] || harness_refuse "the matrix of job $1 gives $2 no list of values"
    types=$(wf_raw --arg j "$1" --arg k "$2" '.jobs[$j].strategy.matrix[$k] | map(type) | unique | join(" ")')
    [ -n "$types" ] || harness_refuse "the matrix of job $1 has no values of $2"
    [ "$types" = string ] || harness_refuse "the matrix of job $1 has values of $2 that are no strings in YAML: $types"
    wf_raw --arg j "$1" --arg k "$2" '.jobs[$j].strategy.matrix[$k][]'
}

# What ${{ path }} stands for: ctx matrix.check test.
ctx() {
    [[ $1 =~ $HARNESS_PATH_RE ]] || harness_refuse "ctx takes a path such as matrix.check, not $1"
    HARNESS_CTX[$1]=$2
}

# The whole value of a variable of env whose value holds an expression the harness does not fill
# in: set_env VERSION v0.1.9 for ${{ steps.version.outputs.version || steps.version.outputs.released }}.
set_env() {
    HARNESS_SET[$1]=$2
}

# A variable the runner, not the step's env, gives the step: runner_env GITHUB_REPOSITORY x/y.
runner_env() {
    [[ $1 =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || harness_refuse "runner_env takes a variable's name, not $1"
    [[ $HARNESS_OWN != *" $1 "* ]] || harness_refuse "runner_env $1: the harness sets $1 itself"
    HARNESS_RUNNER[$1]=$2
}

# The stand-in tests/stubs/<name> in place of the one that fails: stub docker. stub_in_temp puts it
# in RUNNER_TEMP, where release.yml runs npm-isolated and cosign from.
stub() {
    install -m 755 "$HARNESS_TESTS/stubs/$1" "$state/bin/$1"
}

stub_in_temp() {
    install -m 755 "$HARNESS_TESTS/stubs/$1" "$step_temp/$1"
}

stub_exit() {
    printf '%s\n' "$2" > "$state/stub/$1.exit"
}

# What the stand-in prints, from stdin.
stub_stdout() {
    cat > "$state/stub/$1.stdout"
}

# curl's answer: the code, and the body from stdin.
curl_answer() {
    printf '%s\n' "$1" > "$state/stub/curl.code"
    cat > "$state/stub/curl.body"
}

curl_offline() {
    : > "$state/stub/curl.offline"
}

# One variable of env, worked out into harness_value; notes in harness_used what it took.
harness_resolve() {
    local name=$1 rest=$2 out="" inner path plain=1
    local -a paths=()
    while [[ $rest == *'${{'* ]]; do
        out+=${rest%%'${{'*}
        rest=${rest#*'${{'}
        [[ $rest == *'}}'* ]] || harness_refuse "$name has a \${{ without its }}"
        inner=${rest%%'}}'*}
        rest=${rest#*'}}'}
        path=${inner#"${inner%%[![:space:]]*}"}
        path=${path%"${path##*[![:space:]]}"}
        if [[ $path =~ $HARNESS_PATH_RE ]]; then
            paths+=("$path")
            out+=${HARNESS_CTX[$path]-}
        else
            plain=0
        fi
    done
    out+=$rest
    if [ "${#paths[@]}" = 0 ] && [ "$plain" = 1 ]; then
        [ -z "${HARNESS_SET[$name]+x}" ] || harness_refuse "set_env $name: its value is plain, $2"
        harness_value=$2
    elif [ "$plain" = 1 ]; then
        [ -z "${HARNESS_SET[$name]+x}" ] || harness_refuse "set_env $name: its value, $2, comes from the ctx"
        for path in "${paths[@]}"; do
            [ -n "${HARNESS_CTX[$path]+x}" ] || harness_refuse "$name is $2: give ctx $path"
            harness_used[ctx:$path]=1
        done
        harness_value=$out
    else
        [ -n "${HARNESS_SET[$name]+x}" ] || harness_refuse "$name is $2, an expression only the runner evaluates: give it whole with set_env $name"
        harness_used[set:$name]=1
        harness_value=${HARNESS_SET[$name]}
    fi
}

# What a run leaves behind goes when the next one starts, the mark that its exit status is still to
# be asserted too: so a run whose status nobody asserted fails the test, whatever runs after it.
harness_fresh_run() {
    [ ! -e "$state/run/status-unasserted" ] || fail "the test never asserts the exit status of the run before this one"
    rm -rf -- "$state/run"
    mkdir -p "$state/run/calls"
}

# Run the selected step. Its exit status, output, calls and GITHUB_OUTPUT are what the assertions
# read, until the next run.
run_step() {
    [ -n "$harness_job" ] || harness_refuse "no step is selected: select_step first"
    local run="$state/run" name type value shell status=0
    local -a envs command
    local -A names=()
    declare -gA harness_used=()
    harness_fresh_run
    : > "$run/github_output"
    : > "$run/github_env"
    : > "$run/github_path"
    : > "$run/github_step_summary"
    envs=(
        "PATH=$state/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        "HOME=$state/home"
        CI=true
        GITHUB_ACTIONS=true
        "RUNNER_TEMP=$step_temp"
        "GITHUB_WORKSPACE=$step_workspace"
        "GITHUB_OUTPUT=$run/github_output"
        "GITHUB_ENV=$run/github_env"
        "GITHUB_PATH=$run/github_path"
        "GITHUB_STEP_SUMMARY=$run/github_step_summary"
    )
    if [ -n "${LANG+x}" ]; then envs+=("LANG=$LANG"); fi
    if [ -n "${LC_ALL+x}" ]; then envs+=("LC_ALL=$LC_ALL"); fi
    if harness_step -e '(.jobs[$j].permissions // .permissions) as $p | $p == "write-all" or ($p | type == "object" and .["id-token"] == "write")' > /dev/null; then
        envs+=(
            "ACTIONS_ID_TOKEN_REQUEST_URL=https://token.actions.invalid/?api-version=2.0"
            "ACTIONS_ID_TOKEN_REQUEST_TOKEN=a-stand-in-token"
        )
    fi
    harness_step -r '(.env // {}) + (.jobs[$j].env // {}) + (.jobs[$j].steps[$i].env // {}) | to_entries[] | [.key, (.value | type), (.value | tostring | @base64)] | @tsv' > "$run/env.tsv"
    while IFS=$'\t' read -r name type value; do
        [[ $name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || harness_refuse "env names $name, which is no variable's name"
        [[ $name != GITHUB_* && $name != RUNNER_* ]] || harness_refuse "env names $name: GitHub lets no step overwrite GITHUB_* and RUNNER_*"
        [[ $name != PATH && $name != ACTIONS_ID_TOKEN_* ]] || harness_refuse "env names $name, which the harness keeps for its stand-ins and its token"
        [ "$type" = string ] || harness_refuse "$name is a $type in YAML, not a string: GitHub would hand the step its own rendering of it"
        value=$(base64 -d <<< "$value"; printf x)
        harness_resolve "$name" "${value%x}"
        names[$name]=1
        envs+=("$name=$harness_value")
    done < "$run/env.tsv"
    for name in "${!HARNESS_CTX[@]}"; do
        [ -n "${harness_used[ctx:$name]+x}" ] || harness_refuse "ctx $name: no value of the step's env asks for it"
    done
    for name in "${!HARNESS_SET[@]}"; do
        [ -n "${harness_used[set:$name]+x}" ] || harness_refuse "set_env $name: the step's env has no $name with an expression of its own"
    done
    for name in "${!HARNESS_RUNNER[@]}"; do
        [ -z "${names[$name]+x}" ] || harness_refuse "runner_env $name: the step's env names $name, so give its expressions with ctx or set_env"
        envs+=("$name=${HARNESS_RUNNER[$name]}")
    done
    # GitHub's shells on Linux: bash -e {0} when the step names none, bash --noprofile --norc -eo
    # pipefail {0} for shell: bash (architecture 4).
    shell=$(harness_step -r '.jobs[$j].steps[$i].shell // .jobs[$j].defaults.run.shell // .defaults.run.shell // ""')
    case $shell in
        "") command=(/usr/bin/bash -e) ;;
        bash) command=(/usr/bin/bash --noprofile --norc -eo pipefail) ;;
        *) harness_refuse "the step runs in the shell $shell, which the harness does not run" ;;
    esac
    harness_step -j '.jobs[$j].steps[$i].run' > "$run/step.sh"
    : > "$run/status-unasserted"
    (cd -- "$step_workspace" && /usr/bin/env -i "${envs[@]}" /usr/bin/timeout 60 "${command[@]}" "$run/step.sh") \
        < /dev/null > "$run/output" 2>&1 || status=$?
    printf '%s\n' "$status" > "$run/status"
    for name in github_env github_path github_step_summary; do
        [ ! -s "$run/$name" ] || harness_refuse "the step wrote ${name^^}, which no case of the harness reads yet"
    done
    if grep -q '^[^=]*<<' "$run/github_output" || grep -qv '=' "$run/github_output"; then
        harness_refuse "the step wrote GITHUB_OUTPUT in a form the harness does not read: name=value lines alone"
    fi
}

# Run tests/run.sh on test files of a case's own, for the harness's own tests: its exit status and
# output are then what the assertions read.
run_suite() {
    local run="$state/run" status=0
    harness_fresh_run
    : > "$run/status-unasserted"
    bash "$HARNESS_TESTS/run.sh" "$@" < /dev/null > "$run/output" 2>&1 || status=$?
    printf '%s\n' "$status" > "$run/status"
}

assert_status() {
    harness_assert
    [ -f "$state/run/status" ] || harness_refuse "assert_status: nothing has run"
    rm -f "$state/run/status-unasserted"
    local status
    status=$(< "$state/run/status")
    [ "$status" = "$1" ] || fail "it exited with $status, not $1"
}

# A whole line of the output, as it is: assert_line "::error::...".
assert_line() {
    harness_assert
    grep -Fxq -- "$1" "$state/run/output" || fail "no line of the output is: $1"
}

refute_line() {
    harness_assert
    ! grep -Fxq -- "$1" "$state/run/output" || fail "a line of the output is: $1"
}

assert_has() {
    harness_assert
    grep -Fq -- "$1" "$state/run/output" || fail "the output does not hold: $1"
}

refute_has() {
    harness_assert
    ! grep -Fq -- "$1" "$state/run/output" || fail "the output holds: $1"
}

# A step output by its name, split at the first =, the last one written if there are several.
harness_output() {
    local line found=1
    harness_value=""
    while IFS= read -r line; do
        if [ "${line%%=*}" = "$1" ]; then
            harness_value=${line#*=}
            found=0
        fi
    done < "$state/run/github_output"
    return "$found"
}

assert_output() {
    harness_assert
    harness_output "$1" || fail "the step wrote no output $1"
    [ "$harness_value" = "$2" ] || fail "the output $1 is $(printf %q "$harness_value"), not $(printf %q "$2")"
}

refute_output() {
    harness_assert
    ! harness_output "$1" || fail "the step wrote the output $1: $(printf %q "$harness_value")"
}

assert_eq() {
    harness_assert
    [ "$1" = "$2" ] || fail "${3:-the value} is $(printf %q "$1"), not $(printf %q "$2")"
}

harness_calls() {
    local file
    for file in "$state"/run/calls/[0-9][0-9][0-9][0-9]-"$1".argv; do
        [ -e "$file" ] && printf '%s\n' "${file%.argv}"
    done
    return 0
}

# The index-th call of that stand-in, counted from 1, without its extension.
harness_call() {
    local -a calls
    mapfile -t calls < <(harness_calls "$1")
    [ "$2" -ge 1 ] && [ "$2" -le "${#calls[@]}" ] || fail "$1 was called ${#calls[@]} times, so it has no call $2"
    printf '%s\n' "${calls[$2 - 1]}"
}

assert_calls() {
    harness_assert
    local count
    count=$(harness_calls "$1" | wc -l)
    [ "$count" = "$2" ] || fail "$1 was called $count times, not $2"
}

# The arguments of a call, exactly: assert_call docker 1 build --target toolchain --tag toolchain -.
assert_call() {
    harness_assert
    local name=$1 index=$2 call
    shift 2
    call=$(harness_call "$name" "$index")
    cmp -s "$call.argv" <(printf '%s\0' "$@") || fail "call $index of $name was$(harness_argv "$call.argv"), not$(printf ' %q' "$@")"
}

# What a call read on stdin, against a file.
assert_call_stdin() {
    harness_assert
    local call
    call=$(harness_call "$1" "$2")
    [ -f "$call.stdin" ] || fail "call $2 of $1 read no stdin"
    cmp -s "$call.stdin" "$3" || fail "call $2 of $1 read $(printf %q "$(cat "$call.stdin")") on stdin, not what $3 holds"
}

# What else a stand-in wrote down of a call, line by line: docker's env, npm-isolated's oidc.
assert_call_record() {
    harness_assert
    local name=$1 index=$2 kind=$3 call
    shift 3
    call=$(harness_call "$name" "$index")
    local recorded=""
    if [ -f "$call.$kind" ]; then recorded=$(< "$call.$kind"); fi
    local expected=""
    if [ "$#" -gt 0 ]; then expected=$(printf '%s\n' "$@"); fi
    [ "$recorded" = "$expected" ] || fail "the $kind of call $index of $name is $(printf %q "$recorded"), not $(printf %q "$expected")"
}
