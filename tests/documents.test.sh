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

# The step "Toolchain image" of a run that saves, true on a push to main, and the file the cache
# restored when the case gives one, of the stage the step "Toolchain stages" named: STAGE, or
# toolchain.
run_toolchain_image() {
    local stage=${STAGE:-toolchain}
    use_workflow documents.yml
    select_step docs-check-repo 'name=Toolchain image'
    ctx runner.temp "$step_temp"
    ctx steps.stages.outputs.core "$stage"
    set_env SAVE "$1"
    if [ "$#" -gt 1 ]; then
        printf '%s\n' "$2" > "$step_temp/novatrail-$stage.tar"
    fi
    stub docker
    run_step
}

# What the file of the cache of a stage holds once the step is done, or none: image_file, or
# image_file core.
image_file() {
    local file=$step_temp/novatrail-toolchain${1:+-$1}.tar
    if [ -e "$file" ]; then cat "$file"; else echo none; fi
}

# The caller's Dockerfile with the stage toolchain-core, under a toolchain that adds to it.
core_dockerfile() {
    printf 'FROM scratch AS toolchain-core\nFROM toolchain-core AS toolchain\nRUN true\n' > "$step_workspace/.devcontainer/Dockerfile"
}

run_documents() {
    use_workflow documents.yml
    select_step docs-check-repo name=Documents
    stub docker
    run_step
}

script_missing="::error::spec/ has no executable tools/toolchain/toolchain.sh, which spec ships from v0.2.17 (R31 spec): move the spec submodule to v0.2.17 or newer, then run the check again."

test_documents_has_the_checkout_with_the_submodule_the_cache_of_the_stage_and_the_check() {
    use_workflow documents.yml
    assert_eq "$(wf '[.jobs["docs-check-repo"].steps[] | .uses // .name | sub("@[0-9a-f]{40}$"; "@<sha>")]')" \
        '["actions/checkout@<sha>","Toolchain stages","actions/cache/restore@<sha>","Toolchain image","actions/cache/save@<sha>","Documents"]' "the steps"
    assert_eq "$(wf '.jobs["docs-check-repo"].steps[0].with')" '{"submodules":true,"persist-credentials":false}' "the checkout"
}

# The restore and the save of the cache are those by which go.yml's job arm64 builds its own image
# too, the steps of the composite action without its input save: the same file, the same key, the
# action at the same SHA, and only a push to main saves (R42, R49). The variable the script reads
# names that same file. documents.yml takes them for the stage its step "Toolchain stages" names, by
# the file and the key that name it, as go.yml's job check does (R47); the job Workflows of
# .github, whose toolchain adds nothing to its core, for toolchain.
test_documents_caches_the_stage_as_go_does_in_the_same_file() {
    local go documents workflows job file stage env
    use_action toolchain
    go=$(wf '[.runs.steps[] | select(.uses // "" | startswith("actions/cache/")) | select(.with.path | endswith("/novatrail-toolchain.tar"))
        | .if |= sub("^inputs\\.save != '"'"'true'"'"'( && )?"; "") | if .if == "" then del(.if) else . end]')
    for file in documents.yml self-ci.yml; do
        use_workflow "$file"
        env='{"TOOLCHAIN_IMAGE_FILE":"${{ runner.temp }}/novatrail-toolchain.tar","SAVE":"${{ github.event_name == '"'"'push'"'"' && github.ref == '"'"'refs/heads/main'"'"' }}"}'
        case $file in
            documents.yml)
                job=docs-check-repo
                stage='${{ steps.stages.outputs.core }}'
                documents=$(wf --arg s "$stage" '[.jobs["docs-check-repo"].steps[] | select(.uses // "" | startswith("actions/cache/"))
                    | .with.path |= sub("/novatrail-\\$\\{\\{ steps\\.stages\\.outputs\\.core \\}\\}\\.tar$"; "/novatrail-toolchain.tar")
                    | if .with.key | startswith($s + "-") then .with.key |= "toolchain-" + ltrimstr($s + "-") else . end]')
                env=$(jq -c --arg s "$stage" '{TOOLCHAIN_STAGE: $s} + . | .TOOLCHAIN_IMAGE_FILE = "${{ runner.temp }}/novatrail-\($s).tar"' <<< "$env")
                ;;
            *)
                job=workflows
                documents=$(wf '[.jobs.workflows.steps[] | select(.uses // "" | startswith("actions/cache/"))]')
                ;;
        esac
        assert_eq "$documents" "$go" "the cache of $job in $file"
        assert_eq "$(wf --arg j "$job" '.jobs[$j].steps[] | select(.name == "Toolchain image") | .env')" "$env" "the file the script of $job in $file reads"
        assert_eq "$(wf --arg j "$job" '[.jobs[$j].steps[] | select((.run // "") | test("toolchain\\.sh build"))] | length')" 1 "the builds of $job in $file"
    done
    use_workflow documents.yml
    assert_eq "$(wf -r '[.jobs["docs-check-repo"].steps[] | select(.uses // "" | startswith("actions/cache/")) | .with.path, .with.key] | map(select(contains("steps.stages.outputs.core"))) | length')" 3 "the stage in the path of the restore and the save and in the key"
    use_workflow documents.yml
    documents=$(wf_raw '.jobs["docs-check-repo"].steps[] | select(.name == "Toolchain image") | .run')
    # The build of the job Workflows is the end of documents.yml's, after its check of the script,
    # which .github's own submodule has.
    use_workflow self-ci.yml
    workflows=$(wf_raw '.jobs.workflows.steps[] | select(.name == "Toolchain image") | .run')
    assert_eq "$(grep -c . <<< "$workflows")" 4 "the lines of the build of the job Workflows"
    assert_eq "${documents%"$workflows"}$workflows" "$documents" "the build of the job Workflows"
    assert_eq "$(grep -c "toolchain.sh build" <<< "$workflows")" 1 "the script the job Workflows builds by"
}

test_documents_builds_the_stage_and_writes_the_file_of_the_cache_on_a_miss() {
    documents_workspace
    run_toolchain_image true
    assert_status 0
    assert_calls docker 2
    assert_call docker 1 build --target toolchain --tag novatrail-toolchain -
    assert_call_stdin docker 1 "$step_workspace/.devcontainer/Dockerfile"
    assert_call docker 2 save --output "$step_temp/novatrail-toolchain.tar" novatrail-toolchain
    assert_eq "$(image_file)" "an image" "the file the cache saves"
}

# A run that saves nothing hands the script no variable without a file from the cache: the script
# builds the stage and writes no file.
test_documents_builds_the_stage_and_writes_no_file_on_a_miss_of_a_run_that_saves_nothing() {
    documents_workspace
    run_toolchain_image false
    assert_status 0
    assert_calls docker 1
    assert_call docker 1 build --target toolchain --tag novatrail-toolchain -
    assert_eq "$(image_file)" none "the file of the cache"
}

test_documents_loads_the_stage_from_the_cache_without_building_it() {
    documents_workspace
    run_toolchain_image false "a cached image"
    assert_status 0
    assert_calls docker 2
    assert_call docker 1 load --quiet --input "$step_temp/novatrail-toolchain.tar"
    assert_call docker 2 image inspect novatrail-toolchain
    assert_eq "$(image_file)" none "the file once loaded"
}

test_documents_builds_the_stage_when_the_file_of_the_cache_does_not_load() {
    documents_workspace
    stub_exit_on docker load 1
    run_toolchain_image false "a broken image"
    assert_status 0
    assert_calls docker 2
    assert_call docker 2 build --target toolchain --tag novatrail-toolchain -
    assert_has "::warning::toolchain.sh: the file of TOOLCHAIN_IMAGE_FILE did not give the image novatrail-toolchain"
    assert_eq "$(image_file)" none "the file that did not load"
}

test_documents_builds_the_stage_when_the_file_of_the_cache_holds_another_image() {
    documents_workspace
    stub_exit_on docker image 1
    run_toolchain_image false "an image of another name"
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
    run_toolchain_image true
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
    run_toolchain_image true
    assert_status 0
    assert_calls docker 1
    assert_call docker 1 build --target toolchain --tag novatrail-toolchain -
    assert_eq "$(image_file)" none "the file of the cache"
}

# The core, where the Dockerfile has one of its own: the real script builds that stage and writes
# its file, and loads it from there on a hit (R47).
test_documents_builds_the_core_and_writes_its_file_on_a_miss() {
    documents_workspace
    core_dockerfile
    STAGE=toolchain-core run_toolchain_image true
    assert_status 0
    assert_calls docker 2
    assert_call docker 1 build --target toolchain-core --tag novatrail-toolchain -
    assert_call docker 2 save --output "$step_temp/novatrail-toolchain-core.tar" novatrail-toolchain
    assert_eq "$(image_file core)" "an image" "the file of the core the cache saves"
    assert_eq "$(image_file)" none "the file of toolchain"
}

test_documents_loads_the_core_from_its_file_without_building_it() {
    documents_workspace
    core_dockerfile
    STAGE=toolchain-core run_toolchain_image false "a cached core"
    assert_status 0
    assert_calls docker 2
    assert_call docker 1 load --quiet --input "$step_temp/novatrail-toolchain-core.tar"
    assert_call docker 2 image inspect novatrail-toolchain
    assert_eq "$(image_file core)" none "the file once loaded"
}

# A submodule at a tag from v0.13.0 to before v0.18.4 has a script that writes the file and knows no
# TOOLCHAIN_STAGE: here a script of that shape. It builds toolchain, which holds all the core does,
# and the entry of the core holds it: the check passes, and the entry costs its size.
test_documents_builds_toolchain_into_the_file_of_the_core_by_a_script_that_knows_no_stage() {
    documents_workspace
    core_dockerfile
    printf '#!/bin/sh\ndocker build --target toolchain --tag novatrail-toolchain - < .devcontainer/Dockerfile\nexec docker save --output "$TOOLCHAIN_IMAGE_FILE" novatrail-toolchain\n' \
        > "$step_workspace/spec/tools/toolchain/toolchain.sh"
    STAGE=toolchain-core run_toolchain_image true
    assert_status 0
    assert_calls docker 2
    assert_call docker 1 build --target toolchain --tag novatrail-toolchain -
    assert_call docker 2 save --output "$step_temp/novatrail-toolchain-core.tar" novatrail-toolchain
    assert_eq "$(image_file core)" "an image" "the file of the core"
}

test_documents_stops_on_a_submodule_without_the_script() {
    documents_workspace
    rm "$step_workspace/spec/tools/toolchain/toolchain.sh"
    run_toolchain_image false
    assert_status 1
    assert_line "$script_missing"
    assert_calls docker 0
}

test_documents_stops_on_a_script_that_cannot_run() {
    documents_workspace
    chmod 644 "$step_workspace/spec/tools/toolchain/toolchain.sh"
    run_toolchain_image false
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
