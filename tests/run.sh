#!/usr/bin/env bash
# shellcheck disable=SC2016 # The script of each test, in single quotes, is the bash of the test's to expand.
# Runs the tests of the workflows' steps (R28 in docs/decisions.md): every test_ function of
# tests/*.test.sh, or of the files given, each as a bash process of its own. A function that set -e
# runs in an if or after || ignores set -e for every command in it, so a test run in a subshell
# of this script could fail and still pass; a process of its own cannot. Each test sources its
# file, which sources tests/lib.sh, and runs between harness_begin and harness_end.
#
# yq is the one self-ci.yml pins, by version and SHA-256 (R08): YQ names it, and its version has to
# be YQ_VERSION of self-ci.yml. The runner image has a yq of its own, at a version nobody here
# pins, so PATH is not asked. Locally, take the same file as the step Install yq does:
#
#   YQ=/path/to/yq bash tests/run.sh
#
# A test's output is printed only when it fails, each line behind "  | ", so that the ::error::
# lines the negative cases expect never reach the runner as commands of its own. For the same
# reason the files the runner reads commands from are not this script's to write.
set -euo pipefail
unset GITHUB_OUTPUT GITHUB_ENV GITHUB_PATH GITHUB_STEP_SUMMARY

tests=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
root=${tests%/*}

wanted=$(sed -n 's/^ *YQ_VERSION: "\([^"]*\)"$/\1/p' "$root/.github/workflows/self-ci.yml")
if [[ -z $wanted ]] || [[ "$(wc -l <<< "$wanted")" != 1 ]]; then
    echo "run.sh: .github/workflows/self-ci.yml pins no single YQ_VERSION." >&2
    exit 2
fi
if [[ -z ${YQ:-} ]] || [[ ! -x $YQ ]]; then
    echo "run.sh: YQ names no yq. Take yq ${wanted} as the step Install yq of self-ci.yml does, by its SHA-256, and name it: YQ=/path/to/yq bash tests/run.sh" >&2
    exit 2
fi
version=$("$YQ" --version)
if [[ $version != *" version v${wanted}" ]]; then
    echo "run.sh: ${YQ} is \"${version}\", and self-ci.yml pins yq ${wanted}." >&2
    exit 2
fi
export YQ

if [[ $# -gt 0 ]]; then
    files=("$@")
else
    files=("$tests"/*.test.sh)
fi

work=$(mktemp -d)
trap 'rm -rf -- "$work"' EXIT
count=0
failed=0

report() {
    local verdict=$1 file=$2 name=$3 log=${4:-}
    count=$((count + 1))
    printf '%s %d %s %s\n' "$verdict" "$count" "${file##*/}" "$name"
    if [[ $verdict == "not ok" ]]; then
        failed=$((failed + 1))
        if [[ -n $log && -s $log ]]; then
            sed 's/^/  | /' "$log"
        fi
    fi
}

for file in "${files[@]}"; do
    log="$work/file.log"
    if [[ ! -f $file ]]; then
        report "not ok" "$file" "(there is no such file)"
        continue
    fi
    file=$(cd -- "$(dirname -- "$file")" && pwd -P)/${file##*/}
    if ! bash -n "$file" > "$log" 2>&1; then
        report "not ok" "$file" "(it does not parse)" "$log"
        continue
    fi
    # The tests as the file writes them, test_name() at the start of a line, against the functions
    # bash has once the file is read: a name written twice, which bash takes as the last one, or a
    # test written another way, would otherwise pass unseen.
    declared=$(grep -oE '^test_[A-Za-z0-9_]+\(\)' "$file" | sed 's/()$//' | sort) || declared=""
    if ! defined=$(bash -c '. "$1" && { compgen -A function test_ || true; }' _ "$file" 2> "$log" | sort); then
        report "not ok" "$file" "(it cannot be read)" "$log"
        continue
    fi
    if [[ -z $declared ]]; then
        report "not ok" "$file" "(it has no test)"
        continue
    fi
    twice=$(uniq -d <<< "$declared")
    if [[ -n $twice ]]; then
        printf 'tests defined twice: %s\n' "$twice" > "$log"
        report "not ok" "$file" "(a test is defined twice)" "$log"
        continue
    fi
    if [[ $declared != "$defined" ]]; then
        diff <(echo "$declared") <(echo "$defined") > "$log" || true
        report "not ok" "$file" "(a test is not written as test_name() at the start of a line)" "$log"
        continue
    fi
    for name in $declared; do
        state=$(mktemp -d "$work/test.XXXXXX")
        state=$(cd -- "$state" && pwd -P)
        if HARNESS_STATE=$state timeout 120 bash -c '
            set -euo pipefail
            shopt -s inherit_errexit
            . "$1"
            harness_begin
            "$2"
            harness_end
        ' _ "$file" "$name" > "$state/log" 2>&1 < /dev/null && [[ ! -e $state/failed ]]; then
            report ok "$file" "$name"
        else
            report "not ok" "$file" "$name" "$state/log"
        fi
    done
done

echo "${count} tests, ${failed} failed"
[[ $count -gt 0 && $failed == 0 ]]
