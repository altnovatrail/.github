# shellcheck shell=bash disable=SC2016 # jq's variables and GitHub's expressions stay unexpanded in single quotes.
# The tests of documents.yml (R08 and its amendments): spec's check of the documents, run by spec's
# script toolchain.sh in the caller's spec submodule, which builds the toolchain stage, or loads it
# from the file of the cache that TOOLCHAIN_IMAGE_FILE names (R36), and runs spec's recipe in it.
# The script is spec's own, from .github's submodule, and docker the stand-in, which writes down
# what the script asks of it. The steps of actions/cache the harness does not run: they are read as
# text, against go.yml's, and the job Workflows of self-ci.yml has the same three.
# shellcheck source=tests/lib.sh
. "${BASH_SOURCE[0]%/*}/lib.sh"

# The caller's checkout, with its Dockerfile and spec's script in its submodule.
documents_workspace() {
    mkdir -p "$step_workspace/.devcontainer" "$step_workspace/spec/tools/toolchain"
    printf 'FROM scratch AS toolchain\n' > "$step_workspace/.devcontainer/Dockerfile"
    install -m 755 "$HARNESS_ROOT/spec/tools/toolchain/toolchain.sh" "$step_workspace/spec/tools/toolchain/toolchain.sh"
    : > "$step_workspace/spec/justfile"
}

# The step "Toolchain image", with the file the cache restored when the case gives one.
run_toolchain_image() {
    use_workflow documents.yml
    select_step docs-check-repo 'name=Toolchain image'
    ctx runner.temp "$step_temp"
    if [ "$#" -gt 0 ]; then
        printf '%s\n' "$1" > "$step_temp/novatrail-toolchain.tar"
    fi
    stub docker
    run_step
}

# What the file of the cache holds once the step is done, or none.
image_file() {
    if [ -e "$step_temp/novatrail-toolchain.tar" ]; then cat "$step_temp/novatrail-toolchain.tar"; else echo none; fi
}

run_documents() {
    use_workflow documents.yml
    select_step docs-check-repo name=Documents
    stub docker
    run_step
}

script_missing="::error::spec/ has no executable tools/toolchain/toolchain.sh, which spec ships from v0.2.17 (R31 in spec): move the spec submodule to v0.2.17 or newer, then run the check again."

test_documents_has_the_checkout_with_the_submodule_the_cache_of_the_stage_and_the_check() {
    use_workflow documents.yml
    assert_eq "$(wf '[.jobs["docs-check-repo"].steps[] | .uses // .name | sub("@[0-9a-f]{40}$"; "@<sha>")]')" \
        '["actions/checkout@<sha>","actions/cache/restore@<sha>","Toolchain image","actions/cache/save@<sha>","Documents"]' "the steps"
    assert_eq "$(wf '.jobs["docs-check-repo"].steps[0].with')" '{"submodules":true,"persist-credentials":false}' "the checkout"
}

# The three steps of the cache are go.yml's, with the action at the same SHA, but for the path of the
# file, which is spec's script's own; and the variable the script reads names that same file.
test_documents_caches_the_stage_as_go_does_in_a_file_of_its_own() {
    local go documents job file
    use_workflow go.yml
    go=$(wf '[.jobs.check.steps[] | select(.uses // "" | startswith("actions/cache/"))]
        | map(.with.path |= sub("/toolchain\\.tar$"; "/novatrail-toolchain.tar"))')
    for file in documents.yml self-ci.yml; do
        use_workflow "$file"
        case $file in
            documents.yml) job=docs-check-repo ;;
            *) job=workflows ;;
        esac
        documents=$(wf --arg j "$job" '[.jobs[$j].steps[] | select(.uses // "" | startswith("actions/cache/"))]')
        assert_eq "$documents" "$go" "the cache of $job in $file"
        assert_eq "$(wf --arg j "$job" '.jobs[$j].steps[] | select(.name == "Toolchain image") | .env')" \
            '{"TOOLCHAIN_IMAGE_FILE":"${{ runner.temp }}/novatrail-toolchain.tar"}' "the file the script of $job in $file reads"
        assert_eq "$(wf --arg j "$job" '[.jobs[$j].steps[] | select((.run // "") | test("toolchain\\.sh build"))] | length')" 1 "the builds of $job in $file"
    done
    use_workflow self-ci.yml
    assert_eq "$(wf_raw '.jobs.workflows.steps[] | select(.name == "Toolchain image") | .run')" \
        "spec/tools/toolchain/toolchain.sh build" "the build of the job Workflows"
}

test_documents_builds_the_stage_and_writes_the_file_of_the_cache_on_a_miss() {
    documents_workspace
    run_toolchain_image
    assert_status 0
    assert_calls docker 2
    assert_call docker 1 build --target toolchain --tag novatrail-toolchain -
    assert_call_stdin docker 1 "$step_workspace/.devcontainer/Dockerfile"
    assert_call docker 2 save --output "$step_temp/novatrail-toolchain.tar" novatrail-toolchain
    assert_eq "$(image_file)" "an image" "the file the cache saves"
}

test_documents_loads_the_stage_from_the_cache_without_building_it() {
    documents_workspace
    run_toolchain_image "a cached image"
    assert_status 0
    assert_calls docker 2
    assert_call docker 1 load --quiet --input "$step_temp/novatrail-toolchain.tar"
    assert_call docker 2 image inspect novatrail-toolchain
    assert_eq "$(image_file)" none "the file once loaded"
}

test_documents_builds_the_stage_when_the_file_of_the_cache_does_not_load() {
    documents_workspace
    stub_exit_on docker load 1
    run_toolchain_image "a broken image"
    assert_status 0
    assert_calls docker 2
    assert_call docker 2 build --target toolchain --tag novatrail-toolchain -
    assert_has "::warning::toolchain.sh: the file of TOOLCHAIN_IMAGE_FILE did not give the image novatrail-toolchain"
    assert_eq "$(image_file)" none "the file that did not load"
}

test_documents_builds_the_stage_when_the_file_of_the_cache_holds_another_image() {
    documents_workspace
    stub_exit_on docker image 1
    run_toolchain_image "an image of another name"
    assert_status 0
    assert_calls docker 3
    assert_call docker 2 image inspect novatrail-toolchain
    assert_call docker 3 build --target toolchain --tag novatrail-toolchain -
    assert_has "::warning::toolchain.sh: the file of TOOLCHAIN_IMAGE_FILE did not give the image novatrail-toolchain"
    assert_eq "$(image_file)" none "the file that held another image"
}

test_documents_fails_with_the_build_of_the_stage() {
    documents_workspace
    stub_exit_on docker build 1
    run_toolchain_image
    assert_status 1
    assert_calls docker 1
    assert_eq "$(image_file)" none "the file of the cache"
}

# A submodule at a tag before v0.13.0 has a script that builds the stage and knows no
# TOOLCHAIN_IMAGE_FILE: here a script of that shape, which builds as v0.12.0's did. The check goes on
# without the cache, and the save step finds no file and only warns.
test_documents_builds_the_stage_by_a_script_that_knows_no_cache() {
    documents_workspace
    printf '#!/bin/sh\nexec docker build --target toolchain --tag novatrail-toolchain - < .devcontainer/Dockerfile\n' \
        > "$step_workspace/spec/tools/toolchain/toolchain.sh"
    run_toolchain_image
    assert_status 0
    assert_calls docker 1
    assert_call docker 1 build --target toolchain --tag novatrail-toolchain -
    assert_eq "$(image_file)" none "the file of the cache"
}

test_documents_stops_on_a_submodule_without_the_script() {
    documents_workspace
    rm "$step_workspace/spec/tools/toolchain/toolchain.sh"
    run_toolchain_image
    assert_status 1
    assert_line "$script_missing"
    assert_calls docker 0
}

test_documents_stops_on_a_script_that_cannot_run() {
    documents_workspace
    chmod 644 "$step_workspace/spec/tools/toolchain/toolchain.sh"
    run_toolchain_image
    assert_status 1
    assert_line "$script_missing"
    assert_calls docker 0
}

test_documents_runs_specs_recipe_by_specs_script() {
    documents_workspace
    run_documents
    assert_status 0
    assert_calls docker 1
    assert_call docker 1 run --rm --user "$(id -u):$(id -g)" --env HOME=/tmp --volume "$step_workspace:/work" \
        --volume "$step_temp:$step_temp:ro" --workdir /work novatrail-toolchain just -f spec/justfile docs-check-repo
}

test_documents_fails_with_the_check() {
    documents_workspace
    run_documents
    assert_status 0
    stub_exit docker 1
    run_step
    assert_status 1
}
