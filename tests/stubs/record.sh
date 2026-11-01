# shellcheck shell=bash
# What every stand-in does first: it writes down its call, each argument followed by a NUL, in a
# file of its own, numbered in the order of the calls, as calls/0001-docker.argv. The stand-in has
# found the test's directory, state, by its own path, so the step's environment carries nothing
# for it; record leaves the path of the call without its extension in call, for the stand-in to
# write the rest of what it saw beside it.
# shellcheck disable=SC2154 # state is the stand-in's, which sources this file.
record() {
    local name=$1 count
    shift
    count=$(find "$state/run/calls" -maxdepth 1 -name '*.argv' | wc -l)
    call=$(printf '%s/run/calls/%04d-%s' "$state" "$((count + 1))" "$name")
    printf '%s\0' "$@" > "$call.argv"
}
