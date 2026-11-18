# shellcheck shell=bash disable=SC2016 # jq's variables and GitHub's expressions stay unexpanded in single quotes.
# The tests of self-release.yml's step "Work out the version": which commits get a release of
# .github (R10, R33, R49). The step runs on a repository of the case's own, with git as it is,
# and with a stand-in for spec's toolchain.sh in it, which prints what release-version would.
# shellcheck source=tests/lib.sh
. "${BASH_SOURCE[0]%/*}/lib.sh"

# A repository in the workspace: a first commit, released as v0.1.0, then one more that changes
# the paths given, each a file created anew. The commit to release is the second.
release_repository() {
    local path
    git -C "$step_workspace" init -q
    git -C "$step_workspace" config user.email trial@example.invalid
    git -C "$step_workspace" config user.name trial
    mkdir -p "$step_workspace/spec/tools/toolchain"
    # spec's script, as the step calls it: build, which writes down the stage it is asked for, a dry
    # run of release-refusal, and release-version, which prints the version to come after v0.1.0.
    cat > "$step_workspace/spec/tools/toolchain/toolchain.sh" <<'SCRIPT'
#!/usr/bin/env bash
if [ "$1" = build ]; then
    printf '%s\n' "${TOOLCHAIN_STAGE-unset}" > "$RUNNER_TEMP/built-stage"
fi
if [ "$1 $2" = "spec release-version" ]; then
    echo version=v0.1.1
    echo previous=v0.1.0
    echo released=
    echo behind=
fi
SCRIPT
    chmod 755 "$step_workspace/spec/tools/toolchain/toolchain.sh"
    printf 'first\n' > "$step_workspace/README.md"
    git -C "$step_workspace" add -A
    git -C "$step_workspace" commit -q -m first
    git -C "$step_workspace" tag v0.1.0
    for path in "$@"; do
        mkdir -p "$(dirname "$step_workspace/$path")"
        printf 'changed\n' > "$step_workspace/$path"
    done
    git -C "$step_workspace" add -A
    git -C "$step_workspace" commit -q -m second
    release_target=$(git -C "$step_workspace" rev-parse HEAD)
}

run_version_step() {
    use_workflow self-release.yml
    select_step release id=version
    runner_env GITHUB_REPOSITORY altnovatrail/.github
    set_env TARGET "$release_target"
    ctx github.token a-stand-in-token
    stub gh
    run_step
}

assert_released() {
    assert_status 0
    assert_line "releasing v0.1.1 at $release_target"
    assert_output version v0.1.1
}

assert_not_released() {
    assert_status 0
    assert_line "::notice::No shared workflow or action, nor the tool tools/coderules, has changed since v0.1.0: nothing to release."
    assert_output version ""
}

test_self_release_releases_a_change_of_a_shared_workflow() {
    release_repository .github/workflows/go.yml
    run_version_step
    assert_released
    # The stage of spec's recipes is the core, all a release needs (R47).
    assert_eq "$(cat "$step_temp/built-stage")" toolchain-core "the stage spec's script builds"
}

test_self_release_releases_a_change_of_the_tool_of_the_rules_of_code() {
    release_repository tools/coderules/check.go
    run_version_step
    assert_released
}

# A shared action, which callers pin by the SHA of a release as they pin the workflows (R49).
test_self_release_releases_a_change_of_a_shared_action() {
    release_repository .github/actions/toolchain/action.yml
    run_version_step
    assert_released
}

test_self_release_releases_nothing_for_its_own_workflows_and_documents() {
    release_repository .github/workflows/self-ci.yml docs/architecture.md tools/other/tool.go justfile
    run_version_step
    assert_not_released
}
