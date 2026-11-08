# shellcheck shell=bash disable=SC2016 # jq's variables and GitHub's expressions stay unexpanded in single quotes.
# The tests of documents.yml's step "Documents" (R08 and its amendment of 2026-11-08): spec's check
# of the documents, run by spec's script toolchain.sh in the caller's spec submodule, which builds
# the toolchain stage and runs spec's recipe in it. The script is spec's own, from .github's
# submodule, and docker the stand-in, which writes down what the script asks of it.
# shellcheck source=tests/lib.sh
. "${BASH_SOURCE[0]%/*}/lib.sh"

# The caller's checkout, with its Dockerfile and spec's script in its submodule.
documents_workspace() {
    mkdir -p "$step_workspace/.devcontainer" "$step_workspace/spec/tools/toolchain"
    printf 'FROM scratch AS toolchain\n' > "$step_workspace/.devcontainer/Dockerfile"
    install -m 755 "$HARNESS_ROOT/spec/tools/toolchain/toolchain.sh" "$step_workspace/spec/tools/toolchain/toolchain.sh"
    : > "$step_workspace/spec/justfile"
}

run_documents() {
    use_workflow documents.yml
    select_step docs-check-repo name=Documents
    stub docker
    run_step
}

script_missing="::error::spec/ has no executable tools/toolchain/toolchain.sh, which spec ships from v0.2.17 (R31 in spec): move the spec submodule to v0.2.17 or newer, then run the check again."

test_documents_has_the_checkout_with_the_submodule_and_one_step_of_its_own() {
    use_workflow documents.yml
    assert_eq "$(wf '[.jobs["docs-check-repo"].steps[] | .uses // .name | sub("@[0-9a-f]{40}$"; "@<sha>")]')" \
        '["actions/checkout@<sha>","Documents"]' "the steps"
    assert_eq "$(wf '.jobs["docs-check-repo"].steps[0].with')" '{"submodules":true,"persist-credentials":false}' "the checkout"
}

test_documents_builds_the_stage_and_runs_specs_recipe_by_specs_script() {
    documents_workspace
    run_documents
    assert_status 0
    assert_calls docker 2
    assert_call docker 1 build --target toolchain --tag novatrail-toolchain -
    assert_call_stdin docker 1 "$step_workspace/.devcontainer/Dockerfile"
    assert_call docker 2 run --rm --user "$(id -u):$(id -g)" --env HOME=/tmp --volume "$step_workspace:/work" \
        --volume "$step_temp:$step_temp:ro" --workdir /work novatrail-toolchain just -f spec/justfile docs-check-repo
}

test_documents_stops_on_a_submodule_without_the_script() {
    documents_workspace
    rm "$step_workspace/spec/tools/toolchain/toolchain.sh"
    run_documents
    assert_status 1
    assert_line "$script_missing"
    assert_calls docker 0
}

test_documents_stops_on_a_script_that_cannot_run() {
    documents_workspace
    chmod 644 "$step_workspace/spec/tools/toolchain/toolchain.sh"
    run_documents
    assert_status 1
    assert_line "$script_missing"
    assert_calls docker 0
}

test_documents_fails_with_the_check() {
    documents_workspace
    run_documents
    assert_status 0
    stub_exit docker 1
    run_step
    assert_status 1
}
