# shellcheck shell=bash disable=SC2016 # jq's variables and GitHub's expressions stay unexpanded in single quotes.
# The tests of self-release.yml's step "Work out the version" (R10 and its amendments): which
# commits get a release of .github. A commit gets one only when a shared workflow — a file of
# .github/workflows/ without the self- prefix — or the tool a shared workflow reads from .github,
# tools/coderules/, has changed since the release before it (R33). The step runs on a repository
# of the case's own, with git as it is, and with a stand-in for spec's toolchain.sh in it, which
# prints what spec's recipe release-version would.
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
    # spec's script, as the step calls it: build, a dry run of release-refusal, and release-version,
    # which prints the version to come after v0.1.0.
    cat > "$step_workspace/spec/tools/toolchain/toolchain.sh" <<'SCRIPT'
#!/usr/bin/env bash
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
    assert_line "::notice::No shared workflow has changed since v0.1.0: nothing to release."
    assert_output version ""
}

test_self_release_releases_a_change_of_a_shared_workflow() {
    release_repository .github/workflows/go.yml
    run_version_step
    assert_released
}

test_self_release_releases_a_change_of_the_tool_of_the_rules_of_code() {
    release_repository tools/coderules/check.go
    run_version_step
    assert_released
}

test_self_release_releases_nothing_for_its_own_workflows_and_documents() {
    release_repository .github/workflows/self-ci.yml docs/architecture.md tools/other/tool.go justfile
    run_version_step
    assert_not_released
}
