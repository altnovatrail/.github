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
    assert_eq "$(wf '.jobs | keys')" '["arm64","check","coverage","fma-diff","rules","targets"]' "the jobs"
    assert_eq "$(wf '[.jobs | to_entries[] | select(.value | has("permissions")) | .key]')" '["coverage"]' "the jobs with permissions of their own"
    assert_eq "$(wf '.jobs.coverage.permissions')" '{"contents":"read","id-token":"write"}' "the coverage job's permissions"
}

test_go_hands_the_report_of_the_test_job_alone_to_the_coverage_job() {
    use_workflow go.yml
    assert_eq "$(wf '[.jobs.check.steps[-2:][] | .name]')" '["ci-${{ matrix.check }}","Coverage report"]' "the last steps of the checks"
    assert_eq "$(wf '.jobs.check.steps[-1] | {if, uses: (.uses | sub("@[0-9a-f]{40}$"; "@<sha>"))}')" \
        '{"if":"matrix.check == '"'test'"'","uses":"actions/upload-artifact@<sha>"}' "the step that uploads the report"
    assert_eq "$(wf '.jobs.check.steps[-1].with')" \
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
            --volume "$step_workspace:/work" --workdir /work toolchain just "ci-$check"
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

# The tests of the cache of the toolchain stage (T52; R36): the step "Toolchain image" with the
# file the step before it restored, or none, and the three steps every job that builds the stage
# has, in go.yml and typescript.yml alike, read as text.

# The step "Toolchain image" of the job check, a Dockerfile in the workspace, and, with a word, the
# file the cache restored.
toolchain_step() {
    use_workflow go.yml
    select_step check 'name=Toolchain image'
    mkdir -p "$step_workspace/.devcontainer"
    printf 'FROM scratch AS toolchain\n' > "$step_workspace/.devcontainer/Dockerfile"
    if [ "$#" -gt 0 ]; then
        printf '%s\n' "$1" > "$step_temp/toolchain.tar"
    fi
    stub docker
}

# What the file of the cache holds once the step is done, or none.
toolchain_file() {
    if [ -e "$step_temp/toolchain.tar" ]; then cat "$step_temp/toolchain.tar"; else echo none; fi
}

test_go_builds_the_toolchain_stage_from_the_dockerfile_alone_and_saves_it_on_a_miss() {
    toolchain_step
    run_step
    assert_status 0
    assert_calls docker 2
    assert_call docker 1 build --target toolchain --tag toolchain -
    assert_call_stdin docker 1 "$step_workspace/.devcontainer/Dockerfile"
    assert_call docker 2 save --output "$step_temp/toolchain.tar" toolchain
    assert_eq "$(toolchain_file)" "an image" "the file the cache saves"
}

test_go_loads_the_toolchain_stage_from_the_cache_without_building_it() {
    toolchain_step "a cached image"
    run_step
    assert_status 0
    assert_calls docker 2
    assert_call docker 1 load --quiet --input "$step_temp/toolchain.tar"
    assert_call docker 2 image inspect toolchain
    assert_line "Toolchain image: loaded from the cache."
    assert_eq "$(toolchain_file)" none "the file once loaded"
}

# A file of the cache came with a hit, whose entry no save replaces: the step builds the image and
# writes no file for the save step, which does not run on a hit.
test_go_builds_the_toolchain_stage_when_the_file_of_the_cache_does_not_load() {
    toolchain_step "a broken image"
    stub_exit_on docker load 1
    run_step
    assert_status 0
    assert_calls docker 2
    assert_call docker 1 load --quiet --input "$step_temp/toolchain.tar"
    assert_line "::warning::The cache's file of the toolchain stage does not load as the image toolchain: the image is built from the Dockerfile, on every run until the entry is deleted (gh cache delete) or the Dockerfile changes."
    assert_call docker 2 build --target toolchain --tag toolchain -
    assert_eq "$(toolchain_file)" none "the file that did not load"
}

test_go_builds_the_toolchain_stage_when_the_file_of_the_cache_holds_no_image_toolchain() {
    toolchain_step "an image of another name"
    stub_exit_on docker image 1
    run_step
    assert_status 0
    assert_calls docker 3
    assert_call docker 2 image inspect toolchain
    assert_line "::warning::The cache's file of the toolchain stage does not load as the image toolchain: the image is built from the Dockerfile, on every run until the entry is deleted (gh cache delete) or the Dockerfile changes."
    assert_call docker 3 build --target toolchain --tag toolchain -
    assert_eq "$(toolchain_file)" none "the file that did not load"
}

test_go_fails_with_the_build_of_the_toolchain_stage() {
    toolchain_step
    stub_exit_on docker build 1
    run_step
    assert_status 1
    assert_calls docker 1
    assert_eq "$(toolchain_file)" none "the file of the cache"
}

test_go_drops_the_file_of_the_cache_that_does_not_load_even_when_the_build_fails() {
    toolchain_step "a broken image"
    stub_exit_on docker load 1
    stub_exit_on docker build 1
    run_step
    assert_status 1
    assert_calls docker 2
    assert_eq "$(toolchain_file)" none "the file that did not load"
}

test_go_goes_on_without_the_cache_when_the_image_cannot_be_saved() {
    toolchain_step
    stub_exit_on docker save 1
    run_step
    assert_status 0
    assert_calls docker 2
    assert_line "::warning::The image of the toolchain stage could not be saved for the cache: the next run builds it again."
    assert_eq "$(toolchain_file)" none "the part docker save wrote"
}

# The three steps around the build, from the job check of go.yml, with the SHA of the action as
# <sha>: Dependabot moves it, and both steps have to name the same one.
cache_steps='[{"name":"Toolchain image from the cache","id":"toolchain","uses":"actions/cache/restore@<sha>","with":{"path":"${{ runner.temp }}/toolchain.tar","key":"toolchain-${{ runner.os }}-${{ runner.arch }}-${{ hashFiles('"'"'.devcontainer/Dockerfile'"'"') }}"}},{"name":"Toolchain image"},{"name":"Toolchain image into the cache","if":"steps.toolchain.outputs.cache-hit != '"'"'true'"'"'","uses":"actions/cache/save@<sha>","with":{"path":"${{ runner.temp }}/toolchain.tar","key":"${{ steps.toolchain.outputs.cache-primary-key }}"}}]'

test_go_and_typescript_take_the_toolchain_stage_from_the_cache_in_every_job_that_builds_it() {
    local file jobs job run sha
    use_workflow go.yml
    run=$(wf '.jobs.check.steps[] | select(.name == "Toolchain image") | .run')
    sha=$(wf_raw '.jobs.check.steps[] | select(.name == "Toolchain image from the cache") | .uses | sub("^[^@]*@"; "")')
    for file in go.yml typescript.yml; do
        use_workflow "$file"
        jobs=$(wf_raw '.jobs | to_entries[] | select(any(.value.steps[]; .name == "Toolchain image" or ((.run // "") | test("docker build")))) | .key' | tr '\n' ' ')
        case $file in
            go.yml) assert_eq "$jobs" "check targets fma-diff arm64 rules " "the jobs of $file that build the stage" ;;
            *) assert_eq "$jobs" "check " "the jobs of $file that build the stage" ;;
        esac
        for job in $jobs; do
            assert_eq "$(wf --arg j "$job" '[.jobs[$j].steps[] | select(.name == "Toolchain image")] | length')" 1 "the builds of $job in $file"
            assert_eq "$(wf --arg j "$job" '.jobs[$j].steps | (map(.name) | index("Toolchain image")) as $i | .[$i - 1:$i + 2]
                | map(if .uses then .uses |= sub("@[0-9a-f]{40}$"; "@<sha>") else {name} end)')" \
                "$cache_steps" "the cache of $job in $file"
            assert_eq "$(wf --arg j "$job" '[.jobs[$j].steps[] | select(.uses // "" | startswith("actions/cache/")) | .uses | sub("^[^@]*@"; "")] | unique')" \
                "[\"$sha\"]" "the one SHA of actions/cache in $job of $file"
            assert_eq "$(wf --arg j "$job" '.jobs[$j].steps[] | select(.name == "Toolchain image") | .run')" "$run" "the build of $job in $file"
        done
    done
}

# The tests of same-bits (T46; R107 in spec): learner-model's and engine's recipes test-targets
# and fma-diff, as jobs of go.yml. A step hands its script to one toolchain container on stdin; the
# cases run that script as the container would, with bash in the workspace, and with the stand-in
# go first on PATH, which answers as the case says and writes down every call with its build
# variables.

# The job's steps, as the jobs of the checks have them: the checkout without credentials, the
# toolchain stage from the cache, then one step of its own.
same_bits_steps='["actions/checkout@<sha>","actions/cache/restore@<sha>","Toolchain image","actions/cache/save@<sha>"'

# Run the script that the first docker call of the step read on stdin, as the container would.
run_container_script() {
    local call
    call=$(harness_call docker 1)
    [ -f "$call.stdin" ] || fail "the docker run read no script on stdin"
    stub go
    script_status=0
    mkdir -p "$state/tmp"
    (cd -- "$step_workspace" && /usr/bin/env -i "PATH=$state/bin:/usr/bin:/bin" "HOME=$state/home" "TMPDIR=$state/tmp" \
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
run_same_bits_step() {
    use_workflow go.yml
    select_step "$1" "name=$2"
    stub docker
    run_step
    assert_status 0
    assert_calls docker 1
    assert_call docker 1 run --rm -i --user "$(id -u):$(id -g)" --env HOME=/tmp \
        --volume "$step_workspace:/work" --workdir /work toolchain bash -s -
}

test_go_runs_targets_and_fma_diff_with_same_bits_alone() {
    use_workflow go.yml
    local job
    for job in targets fma-diff; do
        assert_eq "$(wf --arg j "$job" '.jobs[$j] | {name, if, "runs-on", "timeout-minutes", permissions}')" \
            "{\"name\":\"$job\",\"if\":\"inputs.same-bits\",\"runs-on\":\"ubuntu-24.04\",\"timeout-minutes\":30,\"permissions\":null}" "the job $job"
        assert_eq "$(wf --arg j "$job" '[.jobs[$j].steps[:4][] | .uses // .name | sub("@[0-9a-f]{40}$"; "@<sha>")] | tostring')" \
            "\"${same_bits_steps//\"/\\\"}]\"" "the first steps of $job"
        assert_eq "$(wf --arg j "$job" '.jobs[$j].steps[0].with')" '{"persist-credentials":false}' "the checkout of $job"
        assert_eq "$(wf --arg j "$job" '.jobs[$j].steps | length')" 5 "the steps of $job"
    done
}

test_go_targets_runs_the_tests_on_every_amd64_target_in_order() {
    run_same_bits_step targets 'Tests on the targets'
    run_container_script
    assert_script_status 0
    assert_calls go 8
    assert_call go 1 env GOHOSTARCH
    assert_call go 2 test -count=1 ./...
    assert_call_record go 2 env "GOOS unset" "GOARCH unset" "GOAMD64=v3" "GODEBUG unset"
    assert_call go 3 test -count=1 ./...
    assert_call_record go 3 env "GOOS unset" "GOARCH unset" "GOAMD64=v1" "GODEBUG=cpu.all=off"
    assert_call go 4 test -count=1 ./...
    assert_call_record go 4 env "GOOS unset" "GOARCH=386" "GOAMD64 unset" "GODEBUG unset"
    assert_call go 5 env GOROOT
    assert_call go 6 test -count=1 -exec=/usr/local/go/lib/wasm/go_js_wasm_exec ./...
    assert_call_record go 6 env "GOOS=js" "GOARCH=wasm" "GOAMD64 unset" "GODEBUG unset"
    assert_call go 7 build ./...
    assert_call_record go 7 env "GOOS=wasip1" "GOARCH=wasm" "GOAMD64 unset" "GODEBUG unset"
    assert_call go 8 vet ./...
    assert_call_record go 8 env "GOOS=wasip1" "GOARCH=wasm" "GOAMD64 unset" "GODEBUG unset"
    assert_script_line "== GOARCH=386 go test -count=1 ./..."
}

test_go_targets_runs_another_host_with_cpu_all_off_and_no_amd64_build() {
    run_same_bits_step targets 'Tests on the targets'
    echo arm64 > "$state/stub/go.hostarch"
    run_container_script
    assert_script_status 0
    assert_calls go 6
    assert_call go 2 test -count=1 ./...
    assert_call_record go 2 env "GOOS unset" "GOARCH unset" "GOAMD64 unset" "GODEBUG=cpu.all=off"
    assert_call go 3 env GOROOT
    refute_script_has "GOAMD64="
    refute_script_has "GOARCH=386"
}

test_go_targets_fails_on_the_first_target_that_fails() {
    run_same_bits_step targets 'Tests on the targets'
    echo GOARCH=386 > "$state/stub/go.fails"
    run_container_script
    assert_script_status 1
    assert_calls go 4
    refute_script_has "GOOS=js"
}

# Two packages with code, as go list prints them for the caller's module.
two_packages() {
    printf '%s\n' example.com/m example.com/m/sub > "$state/stub/go.packages"
}

fma_targets=(arm64 ppc64le s390x riscv64 loong64 amd64/v3)

test_go_fma_diff_passes_when_no_package_fuses_and_the_control_does() {
    run_same_bits_step fma-diff 'The assembler with fusion and without it'
    two_packages
    run_container_script
    assert_script_status 0
    local target
    for target in "${fma_targets[@]}"; do
        assert_script_line "fma-diff: $target: ok"
    done
    # For each target: go list, each package and the control, with fusion and without it.
    assert_calls go 42
    assert_call go 1 list -f '{{if .GoFiles}}{{.ImportPath}}{{end}}' ./...
    assert_call_record go 1 env "GOOS=linux" "GOARCH=arm64" "GOAMD64=v1" "GODEBUG unset"
    assert_call go 2 build -o /dev/null "-gcflags=-S " example.com/m
    assert_call_record go 2 env "GOOS=linux" "GOARCH=arm64" "GOAMD64=v1" "GODEBUG unset"
    assert_call go 3 build -o /dev/null "-gcflags=-S -d=fmahash=n" example.com/m
    assert_call go 36 list -f '{{if .GoFiles}}{{.ImportPath}}{{end}}' ./...
    assert_call_record go 36 env "GOOS=linux" "GOARCH=amd64" "GOAMD64=v3" "GODEBUG unset"
    assert_call go 42 -C "$(harness_argv "$(harness_call go 41).argv" | awk '{print $2}')" build -o /dev/null "-gcflags=-S -d=fmahash=n" .
    assert_call_record go 42 env "GOOS=linux" "GOARCH=amd64" "GOAMD64=v3" "GODEBUG unset"
}

test_go_fma_diff_writes_its_own_control_and_builds_it_as_a_module_of_its_own() {
    run_same_bits_step fma-diff 'The assembler with fusion and without it'
    run_container_script
    assert_script_status 0
    local control
    control=$(harness_argv "$(harness_call go 2).argv" | awk '{print $2}')
    assert_call go 2 -C "$control" build -o /dev/null "-gcflags=-S " .
    assert_eq "$(cat "$control/go.mod")" $'module fmacontrol\n\ngo 1.21' "the control's go.mod"
    assert_eq "$(grep -c '^func ' "$control/control.go")" 3 "the control's functions"
    assert_eq "$(grep -cF 'return a*b + c' "$control/control.go")" 1 "the multiply-add of the control"
    assert_eq "$(sed -n 's/^package //p' "$control/control.go")" fma "the control's package"
}

test_go_fma_diff_fails_on_a_target_where_a_package_fuses() {
    run_same_bits_step fma-diff 'The assembler with fusion and without it'
    two_packages
    echo "example.com/m/sub ppc64le/v1" > "$state/stub/go.fuses"
    run_container_script
    assert_script_status 1
    assert_script_line "fma-diff: ppc64le: the compiler fuses in example.com/m/sub; put float64() round the * or / (R107 in spec):"
    assert_script_line "fma-diff: arm64: ok"
    assert_script_line "fma-diff: amd64/v3: ok"
    refute_script_has "fma-diff: ppc64le: ok"
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
        '["actions/checkout@<sha>","actions/cache/restore@<sha>","Toolchain image","actions/cache/save@<sha>","ci-test","Tests on the targets"]' "its steps"
    assert_eq "$(wf '.jobs.arm64.steps[0].with')" '{"persist-credentials":false}' "its checkout"
    # The targets as the job targets has them, word for word: one script for both hosts.
    assert_eq "$(wf '.jobs.arm64.steps[] | select(.name == "Tests on the targets") | .run')" "$(wf '.jobs.targets.steps[] | select(.name == "Tests on the targets") | .run')" "its tests on the targets"
}

test_go_arm64_runs_ci_test_in_the_toolchain_stage_without_the_license_list() {
    use_workflow go.yml
    select_step arm64 name=ci-test
    stub docker
    run_step
    assert_status 0
    assert_calls docker 1
    assert_call docker 1 run --rm --user "$(id -u):$(id -g)" --env HOME=/tmp \
        --volume "$step_workspace:/work" --workdir /work toolchain just ci-test
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
    assert_eq "$(wf '.jobs.rules | {name, if, "runs-on", "timeout-minutes", permissions}')" \
        '{"name":"rules","if":"inputs.same-bits","runs-on":"ubuntu-24.04","timeout-minutes":20,"permissions":null}' "the job rules"
    assert_eq "$(wf '[.jobs.rules.steps[] | .uses // .name | sub("@[0-9a-f]{40}$"; "@<sha>")]')" \
        '["actions/checkout@<sha>","actions/checkout@<sha>","actions/cache/restore@<sha>","Toolchain image","actions/cache/save@<sha>","The rules of code"]' "its steps"
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
        --volume "$step_workspace:/work" --workdir /work \
        --volume "$step_temp/shared-github/tools/coderules:/tool:ro" \
        toolchain bash -c 'go -C /tool build -o /tmp/coderules . && /tmp/coderules -lists .github/coderules.json .'
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
