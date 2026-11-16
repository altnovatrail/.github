# shellcheck shell=bash disable=SC2016 # jq's variables and GitHub's expressions stay unexpanded in single quotes.
# The tests of go.yml (R16 and its amendments): the shape its callers' rulesets name — "Go / lint",
# "Go / test", "Go / vuln", "Go / licenses" — its steps "Toolchain image", with the cache of the
# toolchain stage around it in every job that builds the stage (R36), and
# ci-${{ matrix.check }}, each run with a stand-in docker that writes down what it was asked, and
# the upload of the coverage: the report the test job hands on, the coverage job that alone gets
# the OIDC token, and its step "Codecov CLI", run with a stand-in curl. The steps that use an
# action the harness does not run: their inputs are read as text, and the actions are named
# without their SHAs, which Dependabot moves.
# The tests of same-bits (T46 and T47, R107 in spec) come last, under their own headings: the jobs
# "Go / targets", "Go / fma-diff" and "Go / arm64", and the scripts they hand the toolchain
# container, run here with bash and the stand-in go.
# shellcheck source=tests/lib.sh
. "${BASH_SOURCE[0]%/*}/lib.sh"

test_go_is_called_with_same_bits_alone_no_secrets_and_gives_the_token_to_the_coverage_job_alone() {
    use_workflow go.yml
    assert_eq "$(wf '.on.workflow_call | keys')" '["inputs"]' "what the call takes"
    assert_eq "$(wf '.on.workflow_call.inputs | map_values({type, default})')" '{"same-bits":{"type":"boolean","default":false}}' "the inputs"
    assert_eq "$(wf '.permissions')" '{"contents":"read"}' "the workflow's permissions"
    assert_eq "$(wf '.jobs | keys')" '["arm64","check","coverage","fma-diff","rules","target","targets","toolchain"]' "the jobs"
    assert_eq "$(wf '[.jobs | to_entries[] | select(.value | has("permissions")) | .key]')" '["coverage"]' "the jobs with permissions of their own"
    assert_eq "$(wf '.jobs.coverage.permissions')" '{"contents":"read","id-token":"write"}' "the coverage job's permissions"
}

test_go_hands_the_report_of_the_test_job_alone_to_the_coverage_job() {
    use_workflow go.yml
    assert_eq "$(wf '[.jobs.check.steps[-3:][] | .name]')" '["ci-${{ matrix.check }}","Coverage report","Go caches into the cache"]' "the last steps of the checks"
    assert_eq "$(wf '.jobs.check.steps[-2] | {if, uses: (.uses | sub("@[0-9a-f]{40}$"; "@<sha>"))}')" \
        '{"if":"matrix.check == '"'test'"'","uses":"actions/upload-artifact@<sha>"}' "the step that uploads the report"
    assert_eq "$(wf '.jobs.check.steps[-2].with')" \
        '{"name":"go-coverage","path":"coverage/go.out","retention-days":7,"if-no-files-found":"error"}' "its inputs"
    assert_eq "$(wf '[.jobs.check.steps[] | select(.uses // "" | startswith("actions/upload-artifact@"))] | length')" 1 "the steps that upload an artifact"
}

test_go_uploads_the_report_after_every_check_and_fails_only_a_pull_request_by_it() {
    use_workflow go.yml
    assert_eq "$(wf '.jobs.coverage | {name, needs, "runs-on", "timeout-minutes", "continue-on-error"}')" \
        '{"name":"coverage","needs":"check","runs-on":"ubuntu-24.04","timeout-minutes":10,"continue-on-error":"${{ github.event_name != '"'pull_request'"' }}"}' "the coverage job"
    assert_eq "$(wf '[.jobs.coverage.steps[] | .uses // .name | sub("@[0-9a-f]{40}$"; "@<sha>")]')" \
        '["actions/checkout@<sha>","actions/download-artifact@<sha>","Codecov CLI","codecov/codecov-action@<sha>"]' "its steps"
    assert_eq "$(wf '.jobs.coverage.steps[0].with')" '{"persist-credentials":false}' "the checkout's inputs"
    assert_eq "$(wf '.jobs.coverage.steps[1].with')" '{"name":"go-coverage","path":"coverage"}' "the download's inputs"
    assert_eq "$(wf '.jobs.coverage.steps[3].with')" \
        '{"binary":"${{ runner.temp }}/codecov","use_oidc":true,"files":"coverage/go.out","disable_search":true,"plugins":"noop","disable_telem":true,"fail_ci_if_error":true}' "the upload's inputs"
}

# The version and the sum of the Codecov CLI as the step pins them: an exact version, and a SHA-256.
cli_pins() {
    cli_version=$(wf_raw '.jobs.coverage.steps[] | select(.name == "Codecov CLI") | .env.CLI_VERSION')
    cli_sum=$(wf_raw '.jobs.coverage.steps[] | select(.name == "Codecov CLI") | .env.CLI_SHA256')
    [[ $cli_version =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || fail "CLI_VERSION is $cli_version, not an exact version"
    [[ $cli_sum =~ ^[0-9a-f]{64}$ ]] || fail "CLI_SHA256 is $cli_sum, not a SHA-256"
}

test_go_takes_the_codecov_cli_of_its_version_by_its_sum() {
    local real="$HARNESS_ROOT/.github/workflows/go.yml" copy="$state/go.yml" body="$state/codecov" sum
    use_workflow go.yml
    cli_pins
    # The step as go.yml has it, with the sum of a stand-in for the CLI in place of the real one's.
    printf 'a stand-in for the Codecov CLI\n' > "$body"
    sum=$(sha256sum < "$body")
    sed "s/^\( *CLI_SHA256: \)$cli_sum\$/\1${sum%% *}/" "$real" > "$copy"
    assert_eq "$(diff "$real" "$copy" | grep -c '^[<>]')" 2 "the lines the copy changes"
    use_workflow "$copy"
    select_step coverage 'name=Codecov CLI'
    stub curl
    curl_answer 200 < "$body"
    run_step
    assert_status 0
    assert_calls curl 1
    assert_call curl 1 -fsSL --proto =https --proto-redir =https --retry 3 --retry-all-errors \
        -o "$step_temp/codecov" "https://cli.codecov.io/$cli_version/linux/codecov"
    assert_eq "$(if [ -x "$step_temp/codecov" ] && cmp -s "$body" "$step_temp/codecov"; then echo ready; else echo not; fi)" ready "the CLI"
}

test_go_refuses_a_codecov_cli_of_another_sum() {
    use_workflow go.yml
    select_step coverage 'name=Codecov CLI'
    stub curl
    printf 'some other bytes\n' | curl_answer 200
    run_step
    assert_status 1
    assert_has "computed checksum did NOT match"
    assert_eq "$(if [ -x "$step_temp/codecov" ]; then echo executable; else echo not; fi)" not "the CLI"
}

test_go_fails_the_upload_without_the_codecov_cli() {
    use_workflow go.yml
    select_step coverage 'name=Codecov CLI'
    stub curl
    printf 'not found\n' | curl_answer 404
    run_step
    assert_status 22
    assert_eq "$(if [ -e "$step_temp/codecov" ]; then echo there; else echo none; fi)" none "the CLI"
    curl_offline
    run_step
    assert_status 7
    assert_eq "$(if [ -e "$step_temp/codecov" ]; then echo there; else echo none; fi)" none "the CLI"
}

test_go_runs_each_check_as_a_job_named_after_it() {
    use_workflow go.yml
    assert_eq "$(wf '.jobs.check.strategy')" '{"fail-fast":false,"matrix":{"check":["lint","test","vuln","licenses"]}}' "the strategy"
    assert_eq "$(wf '.jobs.check.name')" '"${{ matrix.check }}"' "the job's name"
}

test_go_runs_each_recipe_in_the_toolchain_stage_with_the_license_list_alone() {
    use_workflow go.yml
    select_step check 'name=ci-${{ matrix.check }}'
    local checks check allowed
    checks=$(matrix_values check check)
    assert_eq "$checks" $'lint\ntest\nvuln\nlicenses' "the checks"
    allowed=$(wf_raw '.jobs.check.steps[] | select(.name == "ci-${{ matrix.check }}") | .env.ALLOWED_LICENSES')
    stub docker
    runner_env STRAY_TOKEN "a variable of the runner's the step does not name"
    for check in $checks; do
        ctx matrix.check "$check"
        run_step
        assert_status 0
        assert_calls docker 1
        assert_call docker 1 run --rm --user "$(id -u):$(id -g)" --env HOME=/tmp --env ALLOWED_LICENSES \
            "${go_cache_env[@]}" --volume "$step_workspace:/work" --volume "$step_temp/go-cache:/go-cache" \
            --workdir /work novatrail-toolchain just "ci-$check"
        assert_call_record docker 1 env "ALLOWED_LICENSES=$allowed"
    done
}

test_go_fails_the_check_with_the_recipe() {
    use_workflow go.yml
    select_step check 'name=ci-${{ matrix.check }}'
    ctx matrix.check test
    stub docker
    stub_exit docker 3
    run_step
    assert_status 3
}

# The tests of the image of the toolchain stage (T52, T61; R36, R42): the step "Toolchain image",
# one script in every job that builds the stage, with the file the steps before it restored or
# downloaded, or none, and with SAVE as its job gives it; and, read as text, the job toolchain that
# builds the image once for the jobs on amd64, the steps of the jobs after it, and the job arm64,
# which builds its own, in go.yml and typescript.yml alike.

# The step "Toolchain image" of a job of go.yml, a Dockerfile in the workspace, and, with a word,
# the file that came from the cache or from the job toolchain.
toolchain_step() {
    use_workflow go.yml
    select_step "$1" 'name=Toolchain image'
    mkdir -p "$step_workspace/.devcontainer"
    printf 'FROM scratch AS toolchain\n' > "$step_workspace/.devcontainer/Dockerfile"
    if [ "$#" -gt 1 ]; then
        printf '%s\n' "$2" > "$step_temp/novatrail-toolchain.tar"
    fi
    stub docker
}

# What the file holds once the step is done, or none.
toolchain_file() {
    if [ -e "$step_temp/novatrail-toolchain.tar" ]; then cat "$step_temp/novatrail-toolchain.tar"; else echo none; fi
}

toolchain_unloaded="::warning::The file of the toolchain stage does not load as the image novatrail-toolchain: the image is built from the Dockerfile. A file from the cache does so on every run until its entry is deleted (gh cache delete) or the Dockerfile changes."

test_go_toolchain_builds_the_stage_from_the_dockerfile_alone_and_writes_its_file_on_a_miss() {
    toolchain_step toolchain
    run_step
    assert_status 0
    assert_calls docker 2
    assert_call docker 1 build --target toolchain --tag novatrail-toolchain -
    assert_call_stdin docker 1 "$step_workspace/.devcontainer/Dockerfile"
    assert_call docker 2 save --output "$step_temp/novatrail-toolchain.tar" novatrail-toolchain
    assert_eq "$(toolchain_file)" "an image" "the file the job hands on and the cache saves"
}

test_go_toolchain_goes_on_without_a_file_when_the_image_cannot_be_saved() {
    toolchain_step toolchain
    stub_exit_on docker save 1
    run_step
    assert_status 0
    assert_calls docker 2
    assert_line "::warning::The image of the toolchain stage could not be saved: the jobs after this one and the next run build it again."
    assert_eq "$(toolchain_file)" none "the part docker save wrote"
}

test_go_loads_the_toolchain_stage_from_its_file_without_building_it() {
    toolchain_step check "a cached image"
    run_step
    assert_status 0
    assert_calls docker 2
    assert_call docker 1 load --quiet --input "$step_temp/novatrail-toolchain.tar"
    assert_call docker 2 image inspect novatrail-toolchain
    assert_line "Toolchain image: loaded from its file."
    assert_eq "$(toolchain_file)" none "the file once loaded"
}

# The job toolchain gave no file, or one that could not be downloaded: the job builds the image
# itself and writes no file, which no step of it saves.
test_go_builds_the_toolchain_stage_without_a_file_and_writes_none_in_a_job_after_the_job_toolchain() {
    toolchain_step check
    run_step
    assert_status 0
    assert_calls docker 1
    assert_call docker 1 build --target toolchain --tag novatrail-toolchain -
    assert_eq "$(toolchain_file)" none "the file of the job"
}

test_go_builds_the_toolchain_stage_when_its_file_does_not_load() {
    toolchain_step check "a broken image"
    stub_exit_on docker load 1
    run_step
    assert_status 0
    assert_calls docker 2
    assert_call docker 1 load --quiet --input "$step_temp/novatrail-toolchain.tar"
    assert_line "$toolchain_unloaded"
    assert_call docker 2 build --target toolchain --tag novatrail-toolchain -
    assert_eq "$(toolchain_file)" none "the file that did not load"
}

test_go_builds_the_toolchain_stage_when_its_file_holds_no_image_novatrail_toolchain() {
    toolchain_step check "an image of another name"
    stub_exit_on docker image 1
    run_step
    assert_status 0
    assert_calls docker 3
    assert_call docker 2 image inspect novatrail-toolchain
    assert_line "$toolchain_unloaded"
    assert_call docker 3 build --target toolchain --tag novatrail-toolchain -
    assert_eq "$(toolchain_file)" none "the file that did not load"
}

test_go_fails_with_the_build_of_the_toolchain_stage() {
    toolchain_step check
    stub_exit_on docker build 1
    run_step
    assert_status 1
    assert_calls docker 1
    assert_eq "$(toolchain_file)" none "the file of the job"
}

test_go_drops_the_file_that_does_not_load_even_when_the_build_fails() {
    toolchain_step check "a broken image"
    stub_exit_on docker load 1
    stub_exit_on docker build 1
    run_step
    assert_status 1
    assert_calls docker 2
    assert_eq "$(toolchain_file)" none "the file that did not load"
}

# arm64 builds its own image, and writes the file only where its job saves it, on a push to main.
test_go_arm64_writes_the_file_of_the_toolchain_stage_only_where_it_saves_it() {
    toolchain_step arm64
    set_env SAVE true
    run_step
    assert_status 0
    assert_calls docker 2
    assert_call docker 2 save --output "$step_temp/novatrail-toolchain.tar" novatrail-toolchain
    assert_eq "$(toolchain_file)" "an image" "the file of a push to main"
    rm -f -- "$step_temp/novatrail-toolchain.tar"
    set_env SAVE false
    run_step
    assert_status 0
    assert_calls docker 1
    assert_call docker 1 build --target toolchain --tag novatrail-toolchain -
    assert_eq "$(toolchain_file)" none "the file of a pull request"
}

# A file that came with a hit has its entry, which no save replaces: after it fails to load, the
# job that saves builds the image and writes no file.
test_go_writes_no_file_after_one_from_the_cache_that_does_not_load() {
    toolchain_step arm64 "a broken image"
    set_env SAVE true
    stub_exit_on docker load 1
    run_step
    assert_status 0
    assert_calls docker 2
    assert_call docker 2 build --target toolchain --tag novatrail-toolchain -
    assert_eq "$(toolchain_file)" none "the file that did not load"
}

# The steps, read as text with the SHAs of the actions as <sha>: Dependabot moves them, and every
# step of one action names the same SHA.
toolchain_restore='{"name":"Toolchain image from the cache","id":"toolchain","uses":"actions/cache/restore@<sha>","with":{"path":"${{ runner.temp }}/novatrail-toolchain.tar","key":"toolchain-${{ runner.os }}-${{ runner.arch }}-${{ hashFiles('"'"'.devcontainer/Dockerfile'"'"') }}"}}'
toolchain_save='{"name":"Toolchain image into the cache","if":"","uses":"actions/cache/save@<sha>","with":{"path":"${{ runner.temp }}/novatrail-toolchain.tar","key":"${{ steps.toolchain.outputs.cache-primary-key }}"}}'
on_main="github.event_name == 'push' && github.ref == 'refs/heads/main'"

# A job's steps with the SHAs of their actions as <sha>, and the run of "Toolchain image" left out:
# the case below holds it the same everywhere.
toolchain_steps_of() {
    wf --arg j "$1" '[.jobs[$j].steps[] | if .uses then .uses |= sub("@[0-9a-f]{40}$"; "@<sha>") else . end
        | if .name == "Toolchain image" then del(.run) else . end]'
}

test_go_and_typescript_build_the_toolchain_stage_in_the_job_toolchain_alone_and_hand_it_on() {
    local file artifact restore save image upload
    restore=$(jq -c '.with["lookup-only"] = true' <<< "$toolchain_restore")
    save=$(jq -c --arg if "steps.image.outcome == 'success' && $on_main" '.if = $if' <<< "$toolchain_save")
    image='{"name":"Toolchain image","id":"image","if":"steps.toolchain.outputs.cache-hit != '"'"'true'"'"'","continue-on-error":true,"env":{"SAVE":"true"}}'
    for file in go.yml typescript.yml; do
        use_workflow "$file"
        artifact=${file%.yml}-toolchain-image
        upload='{"name":"Toolchain image for the jobs after this one","id":"upload","if":"steps.image.outcome == '"'"'success'"'"'","continue-on-error":true,"uses":"actions/upload-artifact@<sha>","with":{"name":"'"$artifact"'","path":"${{ runner.temp }}/novatrail-toolchain.tar","retention-days":1,"compression-level":1,"overwrite":true,"if-no-files-found":"ignore"}}'
        assert_eq "$(wf '.jobs.toolchain | {name, "runs-on", needs, if, outputs}')" \
            '{"name":"toolchain","runs-on":"ubuntu-24.04","needs":null,"if":null,"outputs":{"artifact":"${{ steps.upload.outputs.artifact-id }}"}}' "the job toolchain of $file"
        assert_eq "$(toolchain_steps_of toolchain)" \
            "[{\"uses\":\"actions/checkout@<sha>\",\"with\":{\"sparse-checkout\":\".devcontainer/Dockerfile\",\"sparse-checkout-cone-mode\":false,\"persist-credentials\":false}},$restore,$image,$save,$upload]" "the steps of the job toolchain of $file"
    done
}

test_go_and_typescript_take_the_toolchain_stage_from_the_cache_or_the_job_toolchain_in_every_job_after_it() {
    local file job jobs download image
    download='{"name":"Toolchain image from the job toolchain","if":"steps.toolchain.outputs.cache-hit != '"'"'true'"'"' && needs.toolchain.outputs.artifact != '"'"''"'"'","continue-on-error":true,"uses":"actions/download-artifact@<sha>","with":{"artifact-ids":"${{ needs.toolchain.outputs.artifact }}","path":"${{ runner.temp }}"}}'
    image='{"name":"Toolchain image","env":{"SAVE":"false"}}'
    for file in go.yml typescript.yml; do
        use_workflow "$file"
        jobs=$(wf_raw '.jobs | to_entries[] | select(.value.needs == "toolchain") | .key' | tr '\n' ' ')
        case $file in
            go.yml) assert_eq "$jobs" "check target fma-diff rules " "the jobs of $file after the job toolchain" ;;
            *) assert_eq "$jobs" "check " "the jobs of $file after the job toolchain" ;;
        esac
        for job in $jobs; do
            # A job after a toolchain job that failed still runs: one skipped would pass as a
            # required check.
            assert_eq "$(wf_raw --arg j "$job" '.jobs[$j].if | test("^\\$\\{\\{ !cancelled\\(\\)( && inputs\\.same-bits)? \\}\\}$")')" true "the condition of $job in $file"
            assert_eq "$(toolchain_steps_of "$job" | jq -c '(map(.name) | index("Toolchain image")) as $i | .[$i - 2:$i + 1]')" \
                "[$toolchain_restore,$download,$image]" "the image of $job in $file"
            assert_eq "$(toolchain_steps_of "$job" | jq -c '[.[] | select(.name == "Toolchain image into the cache")] | length')" 0 "the saves of the image in $job of $file"
        done
    done
}

test_go_arm64_builds_the_toolchain_stage_of_its_own_and_saves_it_on_main_alone() {
    local save
    save=$(jq -c --arg if "steps.toolchain.outputs.cache-hit != 'true' && $on_main" '.if = $if' <<< "$toolchain_save")
    use_workflow go.yml
    assert_eq "$(wf '.jobs.arm64.needs')" null "what arm64 waits for"
    assert_eq "$(toolchain_steps_of arm64 | jq -c '(map(.name) | index("Toolchain image")) as $i | .[$i - 1:$i + 2]')" \
        "[$toolchain_restore,{\"name\":\"Toolchain image\",\"env\":{\"SAVE\":\"\${{ $on_main }}\"}},$save]" "the image of arm64"
}

test_go_and_typescript_build_the_toolchain_stage_by_one_script_and_run_in_its_image() {
    local file job jobs run sha
    use_workflow go.yml
    run=$(wf '.jobs.toolchain.steps[] | select(.name == "Toolchain image") | .run')
    sha=$(wf_raw '.jobs.toolchain.steps[] | select(.name == "Toolchain image from the cache") | .uses | sub("^[^@]*@"; "")')
    for file in go.yml typescript.yml; do
        use_workflow "$file"
        jobs=$(wf_raw '.jobs | to_entries[] | select(any(.value.steps[]; .name == "Toolchain image" or ((.run // "") | test("docker build")))) | .key' | tr '\n' ' ')
        case $file in
            go.yml) assert_eq "$jobs" "toolchain check target fma-diff arm64 rules " "the jobs of $file that build the stage" ;;
            *) assert_eq "$jobs" "toolchain check " "the jobs of $file that build the stage" ;;
        esac
        for job in $jobs; do
            assert_eq "$(wf --arg j "$job" '[.jobs[$j].steps[] | select(.name == "Toolchain image")] | length')" 1 "the builds of $job in $file"
            assert_eq "$(wf --arg j "$job" '.jobs[$j].steps[] | select(.name == "Toolchain image") | .run')" "$run" "the build of $job in $file"
            assert_eq "$(wf --arg j "$job" '[.jobs[$j].steps[] | select(.uses // "" | startswith("actions/cache/")) | .uses | sub("^[^@]*@"; "")] | unique')" \
                "[\"$sha\"]" "the one SHA of actions/cache in $job of $file"
        done
        # Every container runs the image the step builds, and no file of the former path is left.
        assert_eq "$(wf_raw '[.jobs[].steps[].run // empty] | join("\n")' | grep -c 'docker run' || true)" \
            "$(wf_raw '[.jobs[].steps[].run // empty] | join("\n")' | grep -Ec '^ *(.*--workdir /work )?novatrail-toolchain (just|bash) ' || true)" "the containers of $file in the image novatrail-toolchain"
        assert_eq "$(grep -c 'toolchain\.tar' "$HARNESS_ROOT/.github/workflows/$file")" \
            "$(grep -c 'novatrail-toolchain\.tar' "$HARNESS_ROOT/.github/workflows/$file")" "the files of the image in $file"
    done
}

# The tests of the Go caches (T60; R41): the three steps round the work of every job that runs Go,
# read as text, the step "Go caches" with what the cache restored, or nothing, and the flags of
# every docker run of the jobs' own work.

# The flags that point the container's Go at the caches, beside the volume that holds them.
go_cache_env=(--env GOMODCACHE=/go-cache/mod --env GOCACHE=/go-cache/build --env GOLANGCI_LINT_CACHE=/go-cache/lint)

# The restore and the save of the job check, with the SHA of the action as <sha>; the check in the
# key is the job's own, and there is no restore key.
go_cache_restore='{"name":"Go caches from the cache","id":"go-cache","uses":"actions/cache/restore@<sha>","with":{"path":"${{ runner.temp }}/go-cache","key":"go-${{ runner.os }}-${{ runner.arch }}-<check>-${{ hashFiles('"'"'.devcontainer/Dockerfile'"'"') }}-${{ hashFiles('"'"'**/go.sum'"'"') }}"}}'
go_cache_save='{"name":"Go caches into the cache","if":"steps.go-cache.outputs.cache-hit != '"'"'true'"'"' && github.event_name == '"'"'push'"'"' && github.ref == '"'"'refs/heads/main'"'"'","uses":"actions/cache/save@<sha>","with":{"path":"${{ runner.temp }}/go-cache","key":"${{ steps.go-cache.outputs.cache-primary-key }}"}}'

test_go_takes_the_go_caches_from_the_cache_in_every_job_that_runs_go() {
    local job check run sha runs mounts
    use_workflow go.yml
    run=$(wf '.jobs.check.steps[] | select(.name == "Go caches") | .run')
    sha=$(wf_raw '.jobs.check.steps[] | select(.name == "Toolchain image from the cache") | .uses | sub("^[^@]*@"; "")')
    assert_eq "$(wf_raw '.jobs | to_entries[] | select(any(.value.steps[]; .name == "Go caches")) | .key' | tr '\n' ' ')" \
        "check target fma-diff arm64 rules " "the jobs with the Go caches"
    for job in check target fma-diff arm64 rules; do
        check=$job
        if [ "$job" = check ]; then check='${{ matrix.check }}'; fi
        # An entry for each target of the matrix (R43).
        if [ "$job" = target ]; then check='target-${{ matrix.target }}'; fi
        # Right after the toolchain stage, ahead of the work, and the save last of all; in arm64 the
        # image is saved first.
        assert_eq "$(wf --arg j "$job" '.jobs[$j].steps | map(.name) as $n | ($n | index("Toolchain image")) as $b | ($b + if $n[$b + 1] == "Toolchain image into the cache" then 1 else 0 end) as $i | .[$i + 1:$i + 3]
            | .[0] |= (.uses |= sub("@[0-9a-f]{40}$"; "@<sha>")) | .[1] |= {name}')" \
            "[${go_cache_restore//<check>/$check},{\"name\":\"Go caches\"}]" "the restore of the Go caches in $job"
        assert_eq "$(wf --arg j "$job" '.jobs[$j].steps[-1] | .uses |= sub("@[0-9a-f]{40}$"; "@<sha>")')" "$go_cache_save" "the save of the Go caches in $job"
        assert_eq "$(wf --arg j "$job" '.jobs[$j].steps[] | select(.name == "Go caches") | .run')" "$run" "the step Go caches of $job"
        assert_eq "$(wf --arg j "$job" '[.jobs[$j].steps[] | select(.uses // "" | startswith("actions/cache/")) | .uses | sub("^[^@]*@"; "")] | unique')" \
            "[\"$sha\"]" "the one SHA of actions/cache in $job"
        # Every docker run of the job's own work, after the step Go caches, mounts them.
        runs=$(wf_raw --arg j "$job" '.jobs[$j].steps | (map(.name) | index("Go caches")) as $i | [.[$i + 1:][] | .run // empty] | join("\n")' | grep -c 'docker run' || true)
        mounts=$(wf_raw --arg j "$job" '.jobs[$j].steps | (map(.name) | index("Go caches")) as $i | [.[$i + 1:][] | .run // empty] | join("\n")' \
            | grep -Fxc "    --volume \"\$PWD:/work\" --volume \"\$RUNNER_TEMP/go-cache:/go-cache\" --workdir /work \\" || true)
        assert_eq "$mounts" "$runs" "the docker runs of $job that mount the Go caches"
        assert_eq "$(wf_raw --arg j "$job" '.jobs[$j].steps | (map(.name) | index("Go caches")) as $i | [.[$i + 1:][] | .run // empty] | join("\n")' \
            | grep -Fxc "    --env GOMODCACHE=/go-cache/mod --env GOCACHE=/go-cache/build --env GOLANGCI_LINT_CACHE=/go-cache/lint \\" || true)" \
            "$runs" "the docker runs of $job that point Go at the caches"
    done
}

go_cache_warning="::warning::The Go caches of go-Linux-X64-test-a-b did not pass go mod verify: they are deleted, and the job downloads and builds without them. An entry that fails on every run stays until it is deleted (gh cache delete) or go.sum or the Dockerfile changes."

# The step "Go caches" of the job check, in a workspace that git tracks, with the key the cache
# restored, or none.
go_caches_step() {
    use_workflow go.yml
    select_step check 'name=Go caches'
    ctx steps.go-cache.outputs.cache-matched-key "$1"
    stub docker
}

# A repository of modules: at the root and in tools/x, which go mod verify takes, and in testdata/,
# vendor/, .devcontainer/ and _old/, which ./... leaves out, and one git does not track.
go_modules_workspace() {
    local dir
    for dir in . tools/x testdata/y vendor/z .devcontainer/gopls _old untracked; do
        mkdir -p "$step_workspace/$dir"
        printf 'module m\n' > "$step_workspace/$dir/go.mod"
    done
    git -C "$step_workspace" init --quiet
    git -C "$step_workspace" add -- go.mod tools testdata vendor .devcontainer _old
}

# What the folder of the caches holds once the step is done.
go_cache_listing() {
    (cd -- "$step_temp/go-cache" && find . -mindepth 1 | sort | tr '\n' ' ')
}

test_go_caches_start_empty_on_a_miss_and_verify_nothing() {
    go_modules_workspace
    go_caches_step ""
    run_step
    assert_status 0
    assert_calls docker 0
    assert_line "Go caches: none in the cache; the job starts with empty ones."
    assert_eq "$(go_cache_listing)" "./build ./lint ./mod " "the folders of the caches"
}

test_go_caches_from_the_cache_are_verified_in_every_module_of_the_repository() {
    go_modules_workspace
    go_caches_step go-Linux-X64-test-a-b
    mkdir -p "$step_temp/go-cache/mod/example.com" "$step_temp/go-cache/build/00" "$step_temp/go-cache/lint/00"
    printf 'a build\n' > "$step_temp/go-cache/build/00/a-d"
    printf 'a lint\n' > "$step_temp/go-cache/lint/00/b-d"
    printf 'module example.com\n' > "$step_temp/go-cache/mod/example.com/go.mod"
    touch -d '10 days ago' "$step_temp/go-cache/build/00/a-d" "$step_temp/go-cache/lint/00/b-d" "$step_temp/go-cache/mod/example.com/go.mod"
    run_step
    assert_status 0
    assert_calls docker 1
    assert_call docker 1 run --rm --user "$(id -u):$(id -g)" --env HOME=/tmp \
        "${go_cache_env[@]}" --volume "$step_workspace:/work" --volume "$step_temp/go-cache:/go-cache" --workdir /work \
        novatrail-toolchain bash -c 'for module in "$@"; do go -C "$module" mod verify || exit; done' bash . tools/x
    assert_line "Go caches: go-Linux-X64-test-a-b, its modules verified."
    assert_eq "$(go_cache_listing)" "./build ./build/00 ./build/00/a-d ./lint ./lint/00 ./lint/00/b-d ./mod ./mod/example.com ./mod/example.com/go.mod " "the caches, kept"
    # go deletes a build not used for five days at the end of a command: the step touches the builds.
    assert_eq "$(find "$step_temp/go-cache/build" "$step_temp/go-cache/lint" -type f -mmin +60 | wc -l)" 0 "the builds older than an hour"
    assert_eq "$(find "$step_temp/go-cache/mod" -type f -mmin +60 | wc -l)" 1 "the modules older than an hour"
}

# The script the container runs verifies each module in turn and stops at the first that fails.
run_verify_script() {
    local -a argv
    local at
    mapfile -d '' -t argv < "$(harness_call docker 1).argv"
    for at in "${!argv[@]}"; do
        if [ "${argv[$at]}" = -c ]; then break; fi
    done
    at=$((at + 1))
    stub go
    script_status=0
    (cd -- "$step_workspace" && /usr/bin/env -i "PATH=$state/bin:/usr/bin:/bin" "$@" \
        /usr/bin/bash -c "${argv[$at]}" "${argv[@]:$at + 1}") > "$state/script.out" 2>&1 || script_status=$?
}

test_go_caches_verify_each_module_and_stop_at_the_first_that_fails() {
    go_modules_workspace
    go_caches_step go-Linux-X64-test-a-b
    run_step
    assert_status 0
    run_verify_script
    assert_eq "$script_status" 0 "the script's exit status"
    assert_calls go 2
    assert_call go 1 -C . mod verify
    assert_call go 2 -C tools/x mod verify
    printf 'GOOS=broken\n' > "$state/stub/go.fails"
    rm -f "$state"/run/calls/*-go.*
    run_verify_script GOOS=broken
    assert_eq "$script_status" 1 "the script's exit status when a module fails"
    assert_calls go 1
}

test_go_caches_that_do_not_verify_are_deleted_and_the_job_goes_on_without_them() {
    go_modules_workspace
    go_caches_step go-Linux-X64-test-a-b
    # The module cache as go leaves it: folders and files no one may write.
    mkdir -p "$step_temp/go-cache/mod/example.com/m@v1.0.0" "$step_temp/go-cache/build/00"
    printf 'package m\n' > "$step_temp/go-cache/mod/example.com/m@v1.0.0/m.go"
    chmod -R a-w "$step_temp/go-cache/mod/example.com"
    stub_exit docker 1
    run_step
    assert_status 0
    assert_calls docker 1
    assert_line "$go_cache_warning"
    refute_has "its modules verified"
    assert_eq "$(go_cache_listing)" "./build ./lint ./mod " "the caches once deleted"
}

test_go_caches_that_git_cannot_list_the_modules_for_are_deleted_and_the_job_goes_on() {
    go_caches_step go-Linux-X64-test-a-b
    mkdir -p "$step_temp/go-cache/build/00"
    run_step
    assert_status 0
    assert_calls docker 0
    assert_line "$go_cache_warning"
    assert_eq "$(go_cache_listing)" "./build ./lint ./mod " "the caches once deleted"
}

test_go_caches_without_a_module_to_verify_them_by_are_kept() {
    git -C "$step_workspace" init --quiet
    go_caches_step go-Linux-X64-test-a-b
    run_step
    assert_status 0
    assert_calls docker 0
    assert_line "Go caches: go-Linux-X64-test-a-b, with no module of the repository to verify them by."
}

# The tests of same-bits (T46; R107 in spec): learner-model's and engine's recipes test-targets
# and fma-diff, as jobs of go.yml. A step hands its script to one toolchain container on stdin; the
# cases run that script as the container would, with bash in the workspace, and with the stand-in
# go first on PATH, which answers as the case says and writes down every call with its build
# variables.

# The job's steps, as the jobs of the checks have them: the checkout without credentials, the
# toolchain stage from the cache, then one step of its own.
same_bits_steps='["actions/checkout@<sha>","actions/cache/restore@<sha>","actions/download-artifact@<sha>","Toolchain image"'

# Run the script that the first docker call of the step read on stdin, as the container would: with
# the variables the call handed it by --env NAME, as the stand-in docker wrote them down.
run_container_script() {
    local call
    local -a passed=()
    call=$(harness_call docker 1)
    [ -f "$call.stdin" ] || fail "the docker run read no script on stdin"
    if [ -f "$call.env" ]; then mapfile -t passed < <(grep -F = "$call.env"); fi
    stub go
    script_status=0
    mkdir -p "$state/tmp"
    (cd -- "$step_workspace" && /usr/bin/env -i "PATH=$state/bin:/usr/bin:/bin" "HOME=$state/home" "TMPDIR=$state/tmp" "${passed[@]}" \
        /usr/bin/bash "$call.stdin") > "$state/script.out" 2>&1 || script_status=$?
}

assert_script_status() {
    assert_eq "$script_status" "$1" "the script's exit status"
}

assert_script_line() {
    harness_assert
    grep -Fxq -- "$1" "$state/script.out" || fail "no line of the script's output is: $1; it was: $(cat "$state/script.out")"
}

refute_script_has() {
    harness_assert
    ! grep -Fq -- "$1" "$state/script.out" || fail "the script's output holds: $1"
}

# The step with its toolchain container as a stand-in: the call it makes, and the script it hands.
# The steps of the targets hand the container TARGETS too; a third argument is the target of the
# matrix, matrix.target: run_same_bits_step target 'Tests on the targets' 386.
run_same_bits_step() {
    local -a targets=()
    use_workflow go.yml
    select_step "$1" "name=$2"
    if [ "$#" -gt 2 ]; then ctx matrix.target "$3"; fi
    if [ "$2" = 'Tests on the targets' ]; then targets=(--env TARGETS); fi
    stub docker
    run_step
    assert_status 0
    assert_calls docker 1
    assert_call docker 1 run --rm -i --user "$(id -u):$(id -g)" --env HOME=/tmp "${targets[@]}" \
        "${go_cache_env[@]}" --volume "$step_workspace:/work" --volume "$step_temp/go-cache:/go-cache" \
        --workdir /work novatrail-toolchain bash -s -
}

test_go_runs_targets_and_fma_diff_with_same_bits_alone() {
    use_workflow go.yml
    local job name
    for job in target fma-diff; do
        name=$job
        if [ "$job" = target ]; then name='target ${{ matrix.target }}'; fi
        assert_eq "$(wf --arg j "$job" '.jobs[$j] | {name, needs, if, "runs-on", "timeout-minutes", permissions}')" \
            "{\"name\":\"$name\",\"needs\":\"toolchain\",\"if\":\"\${{ !cancelled() && inputs.same-bits }}\",\"runs-on\":\"ubuntu-24.04\",\"timeout-minutes\":30,\"permissions\":null}" "the job $job"
        assert_eq "$(wf --arg j "$job" '[.jobs[$j].steps[:4][] | .uses // .name | sub("@[0-9a-f]{40}$"; "@<sha>")] | tostring')" \
            "\"${same_bits_steps//\"/\\\"}]\"" "the first steps of $job"
        assert_eq "$(wf --arg j "$job" '.jobs[$j].steps[0].with')" '{"persist-credentials":false}' "the checkout of $job"
        assert_eq "$(wf --arg j "$job" '[.jobs[$j].steps[4:][] | .uses // .name | sub("@[0-9a-f]{40}$"; "@<sha>")] | del(.[2])')" \
            '["actions/cache/restore@<sha>","Go caches","actions/cache/save@<sha>"]' "the Go caches round the step of $job"
        assert_eq "$(wf --arg j "$job" '.jobs[$j].steps | length')" 8 "the steps of $job"
    done
    # A job for each target, every one to its end (R43); fma-diff is one job.
    assert_eq "$(wf '.jobs.target.strategy')" '{"fail-fast":false,"matrix":{"target":["amd64-v3","cpu-off","386","js-wasm","wasip1"]}}' "the matrix of target"
    assert_eq "$(wf '.jobs["fma-diff"].strategy')" null "the matrix of fma-diff"
    assert_eq "$(wf '.jobs.target.steps[] | select(.name == "Tests on the targets") | .env')" '{"TARGETS":"${{ matrix.target }}"}' "the targets of a job of target"
}

# "Go / targets", the one check of the targets, reads what the matrix came to (R43).
test_go_holds_the_targets_in_one_check_that_is_red_unless_every_target_passed() {
    use_workflow go.yml
    assert_eq "$(wf '.jobs.targets | {name, needs, if, "runs-on", "timeout-minutes", permissions, strategy}')" \
        '{"name":"targets","needs":"target","if":"${{ always() && inputs.same-bits }}","runs-on":"ubuntu-24.04","timeout-minutes":5,"permissions":null,"strategy":null}' "the job targets"
    assert_eq "$(wf '[.jobs.targets.steps[] | .uses // .name]')" '["Every target"]' "the steps of targets"
    select_step targets 'name=Every target'
    ctx needs.target.result success
    run_step
    assert_status 0
    assert_line "targets: every target passed."
    local result
    for result in failure cancelled skipped ""; do
        select_step targets 'name=Every target'
        ctx needs.target.result "$result"
        run_step
        assert_status 1
        assert_line "::error::The targets are ${result:-of no result}, not success: the jobs \"target …\" of this run say which and why."
    done
}

# Each job of the matrix runs its own target alone, after go env GOHOSTARCH.
test_go_target_runs_the_tests_of_its_own_target_alone() {
    local target
    use_workflow go.yml
    for target in $(matrix_values target target); do
        run_same_bits_step target 'Tests on the targets' "$target"
        run_container_script
        assert_script_status 0
        assert_call go 1 env GOHOSTARCH
        case $target in
            amd64-v3)
                assert_calls go 2
                assert_call go 2 test -count=1 ./...
                assert_call_record go 2 env "GOOS unset" "GOARCH unset" "GOAMD64=v3" "GODEBUG unset"
                ;;
            cpu-off)
                assert_calls go 2
                assert_call go 2 test -count=1 ./...
                assert_call_record go 2 env "GOOS unset" "GOARCH unset" "GOAMD64=v1" "GODEBUG=cpu.all=off"
                ;;
            386)
                assert_calls go 2
                assert_call go 2 test -count=1 ./...
                assert_call_record go 2 env "GOOS unset" "GOARCH=386" "GOAMD64 unset" "GODEBUG unset"
                assert_script_line "== GOARCH=386 go test -count=1 ./..."
                ;;
            js-wasm)
                assert_calls go 3
                assert_call go 2 env GOROOT
                assert_call go 3 test -count=1 -exec=/usr/local/go/lib/wasm/go_js_wasm_exec ./...
                assert_call_record go 3 env "GOOS=js" "GOARCH=wasm" "GOAMD64 unset" "GODEBUG unset"
                ;;
            wasip1)
                assert_calls go 3
                wasi_executor 2
                assert_call go 2 test -count=1 "-exec=node --stack-size=8192 --disable-warning=ExperimentalWarning $executor" ./...
                assert_call_record go 2 env "GOOS=wasip1" "GOARCH=wasm" "GOAMD64 unset" "GODEBUG unset"
                assert_call go 3 vet ./...
                assert_call_record go 3 env "GOOS=wasip1" "GOARCH=wasm" "GOAMD64 unset" "GODEBUG unset"
                ;;
            *) fail "the matrix has a target no case knows: $target" ;;
        esac
    done
}

# arm64 runs the same script on the targets of its host, one after the other.
test_go_arm64_runs_its_own_build_with_cpu_all_off_js_wasm_and_wasip1() {
    run_same_bits_step arm64 'Tests on the targets'
    echo arm64 > "$state/stub/go.hostarch"
    assert_call_record docker 1 env "TARGETS=cpu-off js-wasm wasip1"
    run_container_script
    assert_script_status 0
    assert_calls go 6
    assert_call go 1 env GOHOSTARCH
    assert_call go 2 test -count=1 ./...
    assert_call_record go 2 env "GOOS unset" "GOARCH unset" "GOAMD64 unset" "GODEBUG=cpu.all=off"
    assert_call go 3 env GOROOT
    assert_call go 4 test -count=1 -exec=/usr/local/go/lib/wasm/go_js_wasm_exec ./...
    wasi_executor 5
    assert_call go 5 test -count=1 "-exec=node --stack-size=8192 --disable-warning=ExperimentalWarning $executor" ./...
    assert_call_record go 5 env "GOOS=wasip1" "GOARCH=wasm" "GOAMD64 unset" "GODEBUG unset"
    assert_call go 6 vet ./...
    refute_script_has "GOAMD64="
    refute_script_has "GOARCH=386"
}

test_go_targets_refuses_an_amd64_target_on_another_host() {
    local target
    for target in amd64-v3 386; do
        run_same_bits_step target 'Tests on the targets' "$target"
        echo arm64 > "$state/stub/go.hostarch"
        run_container_script
        assert_script_status 1
        assert_calls go 1
        assert_script_line "targets: $target runs on an amd64 host, not on arm64"
    done
}

test_go_targets_stops_without_a_target_it_knows() {
    run_same_bits_step target 'Tests on the targets' ""
    run_container_script
    assert_script_status 1
    assert_calls go 0
    assert_script_line "targets: TARGETS names no target"
    run_same_bits_step target 'Tests on the targets' wasm
    run_container_script
    assert_script_status 1
    assert_calls go 1
    assert_script_line "targets: no target wasm"
}

test_go_targets_fails_with_its_target_and_stops_at_the_first_that_fails() {
    run_same_bits_step target 'Tests on the targets' 386
    echo GOARCH=386 > "$state/stub/go.fails"
    run_container_script
    assert_script_status 1
    assert_script_line "go: a stand-in failure under GOARCH=386"
    run_same_bits_step arm64 'Tests on the targets'
    echo arm64 > "$state/stub/go.hostarch"
    echo GODEBUG=cpu.all=off > "$state/stub/go.fails"
    run_container_script
    assert_script_status 1
    assert_calls go 2
    refute_script_has "GOOS=js"
}

# The tests on wasip1 (T58; R39): go test by an executor of the script's own in node:wasi, as
# js/wasm runs go_js_wasm_exec.

# The executor that the go test of the index-th call of go runs, by its -exec. It sets two
# variables for the case: executor, the file, and words, the command go splits the flag into.
wasi_executor() {
    local -a argv
    mapfile -d '' -t argv < "$(harness_call go "$1").argv"
    [[ ${argv[2]-} == -exec=* ]] || fail "call $1 of go has no -exec as its third argument:$(harness_argv "$(harness_call go "$1").argv")"
    read -r -a words <<< "${argv[2]#-exec=}"
    executor=${words[-1]}
}

# A WASI command written by hand: its _start calls proc_exit with the code given, below 64, and it
# exports its memory, as node:wasi requires.
wasi_command() {
    local code
    code=$(printf '\\x%02x' "$1")
    # shellcheck disable=SC2059 # The format is the module, with the code's byte in it.
    printf "\x00asm\x01\x00\x00\x00\x01\x08\x02\x60\x01\x7f\x00\x60\x00\x00\x02\x24\x01\x16wasi_snapshot_preview1\x09proc_exit\x00\x00\x03\x02\x01\x01\x05\x03\x01\x00\x01\x07\x13\x02\x06memory\x02\x00\x06_start\x00\x01\x0a\x08\x01\x06\x00\x41${code}\x10\x00\x0b" > "$2"
}

test_go_targets_runs_wasip1_in_node_wasi_by_an_executor_outside_the_checkout() {
    run_same_bits_step target 'Tests on the targets' wasip1
    run_container_script
    assert_script_status 0
    wasi_executor 2
    assert_eq "$(if [ -f "$executor" ]; then echo written; else echo none; fi)" written "the executor"
    assert_eq "$(case $executor in "$step_workspace"/*) echo in the checkout ;; "$state/tmp"/*) echo in a temporary folder ;; *) echo elsewhere ;; esac)" \
        "in a temporary folder" "where the executor is"
    local fragment
    for fragment in 'import { WASI } from "node:wasi";' 'const args = process.argv.slice(2);' 'version: "preview1"' 'args,' 'env: process.env' \
        'preopens: { "/": "/" }' 'returnOnExit: true' 'await readFile(args[0])' 'process.exitCode = wasi.start(instance);'; do
        assert_eq "$(grep -cF -- "$fragment" "$executor")" 1 "the lines of the executor with $fragment"
    done
    # The executor in the Node of the runner, as go test runs it: the code of the command's
    # proc_exit is the code of the process, and Node warns of nothing.
    local code status
    for code in 0 3; do
        wasi_command "$code" "$state/exit.wasm"
        status=0
        "${words[@]}" "$state/exit.wasm" > "$state/node.out" 2>&1 || status=$?
        assert_eq "$status" "$code" "the exit status of a command that exits with $code"
        assert_eq "$(cat "$state/node.out")" "" "what Node printed"
    done
}

test_go_targets_fails_with_a_test_on_wasip1() {
    run_same_bits_step target 'Tests on the targets' wasip1
    echo GOOS=wasip1 > "$state/stub/go.fails"
    run_container_script
    assert_script_status 1
    assert_calls go 2
    assert_script_line "go: a stand-in failure under GOOS=wasip1"
    refute_script_has "go vet"
}

# Two packages with code, as go list prints them for the caller's module.
two_packages() {
    printf '%s\n' example.com/m example.com/m/sub > "$state/stub/go.packages"
}

fma_targets=(arm64 ppc64le s390x riscv64 loong64 amd64/v3)

# The calls of go under one target of fma-diff, by their indices, one a line: the targets run at
# once, so their calls interleave, but each target's own come one after the other.
fma_calls() {
    local goarch=${1%%/*} goamd64=v1 call index=0
    if [ "$1" = amd64/v3 ]; then goamd64=v3; fi
    while IFS= read -r call; do
        index=$((index + 1))
        if grep -Fxq "GOARCH=$goarch" "$call.env" && grep -Fxq "GOAMD64=$goamd64" "$call.env"; then
            echo "$index"
        fi
    done < <(harness_calls go)
}

# The n-th call of go under a target: fma_call arm64 1.
fma_call() {
    fma_calls "$1" | sed -n "$2p"
}

# The output of a script where every target is ok: one line a target, in their order.
fma_all_ok=$(printf 'fma-diff: %s: ok\n' "${fma_targets[@]}")

test_go_fma_diff_passes_when_no_package_fuses_and_the_control_does() {
    run_same_bits_step fma-diff 'The assembler with fusion and without it'
    two_packages
    run_container_script
    assert_script_status 0
    assert_eq "$(cat "$state/script.out")" "$fma_all_ok" "the script's output"
    # For each target: go list, each package and the control, with fusion and without it.
    assert_calls go 42
    local target control
    for target in "${fma_targets[@]}"; do
        assert_eq "$(fma_calls "$target" | wc -l)" 7 "the calls of go under $target"
        assert_call go "$(fma_call "$target" 1)" list -f '{{if .GoFiles}}{{.ImportPath}}{{end}}' ./...
        assert_call go "$(fma_call "$target" 2)" build -o /dev/null "-gcflags=-S " example.com/m
        assert_call go "$(fma_call "$target" 3)" build -o /dev/null "-gcflags=-S -d=fmahash=n" example.com/m
        assert_call go "$(fma_call "$target" 4)" build -o /dev/null "-gcflags=-S " example.com/m/sub
        assert_call go "$(fma_call "$target" 5)" build -o /dev/null "-gcflags=-S -d=fmahash=n" example.com/m/sub
        control=$(harness_argv "$(harness_call go "$(fma_call "$target" 6)").argv" | awk '{print $2}')
        assert_call go "$(fma_call "$target" 6)" -C "$control" build -o /dev/null "-gcflags=-S " .
        assert_call go "$(fma_call "$target" 7)" -C "$control" build -o /dev/null "-gcflags=-S -d=fmahash=n" .
    done
    assert_call_record go "$(fma_call arm64 1)" env "GOOS=linux" "GOARCH=arm64" "GOAMD64=v1" "GODEBUG unset"
    assert_call_record go "$(fma_call amd64/v3 1)" env "GOOS=linux" "GOARCH=amd64" "GOAMD64=v3" "GODEBUG unset"
}

# The targets run at once (R43): the go list of the first waits for the go list of the last, which a
# loop of one target after the other would never reach. The output keeps the order of the targets.
test_go_fma_diff_runs_its_targets_at_once_and_prints_them_in_their_order() {
    run_same_bits_step fma-diff 'The assembler with fusion and without it'
    two_packages
    echo "arm64 amd64" > "$state/stub/go.waits"
    run_container_script
    assert_script_status 0
    assert_eq "$(cat "$state/script.out")" "$fma_all_ok" "the script's output"
}

# A target whose command fails stops alone; the others are still checked, and the script fails.
test_go_fma_diff_fails_with_a_target_that_stops_and_checks_the_others() {
    run_same_bits_step fma-diff 'The assembler with fusion and without it'
    two_packages
    echo "ppc64le none" > "$state/stub/go.waits"
    run_container_script
    assert_script_status 1
    assert_eq "$(cat "$state/script.out")" "$(printf '%s\n' "fma-diff: arm64: ok" \
        "go: go list under GOARCH=ppc64le waited in vain for GOARCH=none" \
        "fma-diff: s390x: ok" "fma-diff: riscv64: ok" "fma-diff: loong64: ok" "fma-diff: amd64/v3: ok")" "the script's output"
}

test_go_fma_diff_writes_its_own_control_and_builds_it_as_a_module_of_its_own() {
    run_same_bits_step fma-diff 'The assembler with fusion and without it'
    run_container_script
    assert_script_status 0
    local control
    control=$(harness_argv "$(harness_call go "$(fma_call arm64 2)").argv" | awk '{print $2}')
    assert_call go "$(fma_call arm64 2)" -C "$control" build -o /dev/null "-gcflags=-S " .
    assert_eq "$(cat "$control/go.mod")" $'module fmacontrol\n\ngo 1.21' "the control's go.mod"
    assert_eq "$(grep -c '^func ' "$control/control.go")" 3 "the control's functions"
    assert_eq "$(grep -cF 'return a*b + c' "$control/control.go")" 1 "the multiply-add of the control"
    assert_eq "$(sed -n 's/^package //p' "$control/control.go")" fma "the control's package"
}

# The output of a target that fails is whole, its diff right after its line.
test_go_fma_diff_fails_on_a_target_where_a_package_fuses() {
    run_same_bits_step fma-diff 'The assembler with fusion and without it'
    two_packages
    echo "example.com/m/sub ppc64le/v1" > "$state/stub/go.fuses"
    run_container_script
    assert_script_status 1
    assert_eq "$(cat "$state/script.out")" "$(printf '%s\n' "fma-diff: arm64: ok" \
        "fma-diff: ppc64le: the compiler fuses in example.com/m/sub; put float64() round the * or / (R107 in spec):" \
        "1c1" "< TEXT example.com/m/sub fused" "---" "> TEXT example.com/m/sub plain" \
        "fma-diff: s390x: ok" "fma-diff: riscv64: ok" "fma-diff: loong64: ok" "fma-diff: amd64/v3: ok")" "the script's output"
}

test_go_fma_diff_fails_where_a_rule_would_have_fired() {
    run_same_bits_step fma-diff 'The assembler with fusion and without it'
    two_packages
    echo example.com/m > "$state/stub/go.triggered"
    run_container_script
    assert_script_status 1
    local target
    for target in "${fma_targets[@]}"; do
        assert_script_line "fma-diff: $target: the compiler fuses in example.com/m; put float64() round the * or / (R107 in spec):"
    done
}

test_go_fma_diff_fails_when_the_control_is_not_caught() {
    run_same_bits_step fma-diff 'The assembler with fusion and without it'
    two_packages
    : > "$state/stub/go.control-unfused"
    run_container_script
    assert_script_status 1
    local target
    for target in "${fma_targets[@]}"; do
        assert_script_line "fma-diff: $target: the control was not caught: the check sees no fusion"
    done
}

test_go_fma_diff_says_which_package_does_not_build() {
    run_same_bits_step fma-diff 'The assembler with fusion and without it'
    two_packages
    echo example.com/m/sub > "$state/stub/go.broken"
    run_container_script
    assert_script_status 1
    assert_script_line "example.com/m/sub: a stand-in build error"
    # The other package and the other targets are still checked.
    local target
    for target in "${fma_targets[@]}"; do
        assert_script_line "fma-diff: $target: example.com/m/sub does not build:"
        refute_script_has "fma-diff: $target: ok"
    done
    assert_calls go 36
}

# A package that build constraints leave out of a target is not built for it: go list is asked
# again for every target.
test_go_fma_diff_builds_each_target_s_own_packages() {
    run_same_bits_step fma-diff 'The assembler with fusion and without it'
    two_packages
    echo example.com/m > "$state/stub/go.packages.arm64"
    run_container_script
    assert_script_status 0
    # arm64: one package; the five others: two. Each with the control, twice, and a go list.
    assert_calls go $((1 + 2 + 2 + 5 * (1 + 4 + 2)))
    refute_script_has "does not build"
}

# The tests of the job T47 adds to same-bits: "Go / arm64", ci-test and the targets of its host on
# an arm64 runner (R107 in spec).

test_go_runs_arm64_with_same_bits_alone_on_an_arm64_runner() {
    use_workflow go.yml
    assert_eq "$(wf '.jobs.arm64 | {name, if, "runs-on", "timeout-minutes", permissions}')" \
        '{"name":"arm64","if":"inputs.same-bits","runs-on":"ubuntu-24.04-arm","timeout-minutes":45,"permissions":null}' "the job arm64"
    assert_eq "$(wf '[.jobs.arm64.steps[] | .uses // .name | sub("@[0-9a-f]{40}$"; "@<sha>")]')" \
        '["actions/checkout@<sha>","actions/cache/restore@<sha>","Toolchain image","actions/cache/save@<sha>","actions/cache/restore@<sha>","Go caches","ci-test","Tests on the targets","actions/cache/save@<sha>"]' "its steps"
    assert_eq "$(wf '.jobs.arm64.steps[0].with')" '{"persist-credentials":false}' "its checkout"
    # The targets as the jobs of target have them, word for word: one script for both hosts, with
    # the targets of its host (R43).
    assert_eq "$(wf '.jobs.arm64.steps[] | select(.name == "Tests on the targets") | .run')" "$(wf '.jobs.target.steps[] | select(.name == "Tests on the targets") | .run')" "its tests on the targets"
    assert_eq "$(wf '.jobs.arm64.steps[] | select(.name == "Tests on the targets") | .env')" '{"TARGETS":"cpu-off js-wasm wasip1"}' "its targets"
}

test_go_arm64_runs_ci_test_in_the_toolchain_stage_without_the_license_list() {
    use_workflow go.yml
    select_step arm64 name=ci-test
    stub docker
    run_step
    assert_status 0
    assert_calls docker 1
    assert_call docker 1 run --rm --user "$(id -u):$(id -g)" --env HOME=/tmp \
        "${go_cache_env[@]}" --volume "$step_workspace:/work" --volume "$step_temp/go-cache:/go-cache" \
        --workdir /work novatrail-toolchain just ci-test
}

test_go_arm64_fails_with_ci_test() {
    use_workflow go.yml
    select_step arm64 name=ci-test
    stub docker
    stub_exit docker 3
    run_step
    assert_status 3
}

# The tests of the job T48 adds to same-bits: "Go / rules", the rules of code by the tool of
# .github of this workflow's own version, tools/coderules, and the caller's lists (R33).

test_go_runs_rules_with_same_bits_alone_by_the_tool_of_its_own_version() {
    use_workflow go.yml
    assert_eq "$(wf '.jobs.rules | {name, needs, if, "runs-on", "timeout-minutes", permissions}')" \
        '{"name":"rules","needs":"toolchain","if":"${{ !cancelled() && inputs.same-bits }}","runs-on":"ubuntu-24.04","timeout-minutes":20,"permissions":null}' "the job rules"
    assert_eq "$(wf '[.jobs.rules.steps[] | .uses // .name | sub("@[0-9a-f]{40}$"; "@<sha>")]')" \
        '["actions/checkout@<sha>","actions/checkout@<sha>","actions/cache/restore@<sha>","actions/download-artifact@<sha>","Toolchain image","actions/cache/restore@<sha>","Go caches","The rules of code","actions/cache/save@<sha>"]' "its steps"
    assert_eq "$(wf '.jobs.rules.steps[0].with')" '{"persist-credentials":false}' "the checkout of the caller"
    assert_eq "$(wf '.jobs.rules.steps[1].with')" \
        '{"repository":"${{ job.workflow_repository }}","ref":"${{ job.workflow_sha }}","path":".shared-github","persist-credentials":false}' "the checkout of .github"
}

# The workspace as the two checkouts leave it: the caller's module, with its lists or without, and
# .github of the workflow's version in .shared-github.
rules_workspace() {
    mkdir -p "$step_workspace/.shared-github/tools/coderules" "$step_workspace/.github"
    printf 'module github.com/altnovatrail/.github/tools/coderules\n' > "$step_workspace/.shared-github/tools/coderules/go.mod"
    if [ "${1-}" != without-lists ]; then
        printf '{"code-imports": ["math"]}\n' > "$step_workspace/.github/coderules.json"
    fi
}

test_go_rules_builds_the_tool_in_the_toolchain_stage_and_runs_it_on_the_module() {
    rules_workspace
    use_workflow go.yml
    select_step rules 'name=The rules of code'
    stub docker
    run_step
    assert_status 0
    assert_calls docker 1
    assert_call docker 1 run --rm --user "$(id -u):$(id -g)" --env HOME=/tmp \
        "${go_cache_env[@]}" --volume "$step_workspace:/work" --volume "$step_temp/go-cache:/go-cache" --workdir /work \
        --volume "$step_temp/shared-github/tools/coderules:/tool:ro" \
        novatrail-toolchain bash -c 'go -C /tool build -o /tmp/coderules . && /tmp/coderules -lists .github/coderules.json .'
    # .github's checkout is out of the caller's module, where the tool would see a nested module.
    assert_eq "$(if [ -e "$step_workspace/.shared-github" ]; then echo there; else echo gone; fi)" gone "the checkout in the workspace"
    assert_eq "$(if [ -f "$step_temp/shared-github/tools/coderules/go.mod" ]; then echo moved; else echo not; fi)" moved "the checkout in RUNNER_TEMP"
}

test_go_rules_stops_without_the_callers_lists() {
    rules_workspace without-lists
    use_workflow go.yml
    select_step rules 'name=The rules of code'
    stub docker
    run_step
    assert_status 1
    assert_line "::error::same-bits holds the code to the rules of code by the caller's lists, .github/coderules.json, and there is none (architecture 3.3 of .github)."
    assert_calls docker 0
}

test_go_rules_fails_with_the_tool() {
    rules_workspace
    use_workflow go.yml
    select_step rules 'name=The rules of code'
    stub docker
    stub_exit docker 1
    run_step
    assert_status 1
}
