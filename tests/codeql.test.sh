# shellcheck shell=bash disable=SC2016 # jq's variables and GitHub's expressions stay unexpanded in single quotes.
# The tests of codeql.yml's step "Go of the caller's toolchain stage". The stand-in curl
# answers with an archive the case builds: a go/bin/go that says its version, as go.dev's archive
# holds go/ at its top.
# shellcheck source=tests/lib.sh
. "${BASH_SOURCE[0]%/*}/lib.sh"

GO_STEP="name=Go of the caller's toolchain stage"
# A sum of no archive here, for the architecture the job does not run on.
NO_SUM=0000000000000000000000000000000000000000000000000000000000000000

# An archive as go.dev's, its go saying "go version go<version> linux/<arch>" under
# GOTOOLCHAIN=local alone, into $state/go.tar.gz; its sha256 into archive_sum.
go_archive() {
    local tree="$state/archive"
    rm -rf -- "$tree"
    mkdir -p "$tree/go/bin"
    printf '#!/usr/bin/env bash\n[ "$1" = version ] && [ "$GOTOOLCHAIN" = local ] && echo "go version go%s linux/%s"\n' "$1" "$2" > "$tree/go/bin/go"
    chmod 755 "$tree/go/bin/go"
    pack_archive
}

# $state/archive packed into $state/go.tar.gz, and its sha256 into archive_sum.
pack_archive() {
    tar -C "$state/archive" -czf "$state/go.tar.gz" go
    archive_sum=$(sha256sum < "$state/go.tar.gz")
    archive_sum=${archive_sum%% *}
}

# The caller's .devcontainer/Dockerfile, from stdin.
dockerfile() {
    mkdir -p "$step_workspace/.devcontainer"
    cat > "$step_workspace/.devcontainer/Dockerfile"
}

# A Dockerfile as spec's: Go in the stage toolchain-core, with comments and continued lines, which
# the stage toolchain is built from, and a devcontainer stage after it whose ENV and ARGs the step
# must not read, nor its # escape=, which comes after the first instruction and is no directive.
spec_dockerfile() {
    dockerfile <<EOF
# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/devcontainers/base:3.0.13-noble@sha256:48be AS toolchain-core
ARG NODE_VERSION=24.21.0
ARG GO_VERSION=1.27.4
ARG GO_SHA256_AMD64=${archive_sum}
ARG GO_SHA256_ARM64=${NO_SUM}
RUN echo "go \${GO_VERSION}"; \\
    fetch "https://go.dev/dl/go\${GO_VERSION}.linux-\${arch}.tar.gz"
ENV PATH="/usr/local/node/bin:/usr/local/go/bin:/home/vscode/.local/bin:\${PATH}" \\
    GOTOOLCHAIN=local

FROM toolchain-core AS toolchain

FROM toolchain AS devcontainer
# escape=\`
ARG GO_VERSION=0.0.1
ENV GOFLAGS=-mod=mod
EOF
}

# The step, with the runner on that architecture, X64 by default, and curl answering with the
# archive.
go_step() {
    use_workflow codeql.yml
    select_step analyze "$GO_STEP"
    runner_env RUNNER_ARCH "${1:-X64}"
    stub curl
    curl_answer 200 < "$state/go.tar.gz"
}

test_codeql_takes_go_from_the_archive_of_the_toolchain_stage_without_docker() {
    go_archive 1.27.4 amd64
    spec_dockerfile
    go_step
    run_step
    assert_status 0
    assert_line "go version go1.27.4 linux/amd64"
    assert_calls curl 1
    assert_call curl 1 -fsSL --proto =https --proto-redir =https --retry 3 --retry-all-errors \
        -o "$step_temp/go1.27.4.linux-amd64.tar.gz" https://go.dev/dl/go1.27.4.linux-amd64.tar.gz
    assert_calls docker 0
    assert_runner_file GITHUB_PATH "$step_temp/go/bin"
    assert_runner_file GITHUB_ENV GOTOOLCHAIN=local
    assert_eq "$(if [ -e "$step_temp/go1.27.4.linux-amd64.tar.gz" ]; then echo kept; else echo removed; fi)" removed "the archive"
    assert_eq "$(env -u GOTOOLCHAIN "$step_temp/go/bin/go" version 2>&1 || true)" "" "what the go unpacked says without GOTOOLCHAIN=local"
}

test_codeql_reads_the_dockerfile_as_dockers_parser_does() {
    go_archive 1.28rc1 amd64
    # Carriage returns, blanks after a \ and at the ends of lines, an empty line and a comment
    # inside a continued ENV, instructions and a stage named in other cases.
    dockerfile < <(printf '%s\r\n' \
        "# escape=\\" \
        'from --platform=linux/amd64 ubuntu:24.04 as Toolchain' \
        'arg GO_VERSION=1.28rc1  ' \
        "ARG GO_SHA256_AMD64=${archive_sum}" \
        'env PATH=/usr/local/go/bin:${PATH} \  ' \
        '' \
        '    # a comment Docker drops' \
        '    GOTOOLCHAIN=auto')
    go_step
    run_step
    assert_status 0
    assert_line "go version go1.28rc1 linux/amd64"
    assert_runner_file GITHUB_PATH "$step_temp/go/bin"
    assert_runner_file GITHUB_ENV GOTOOLCHAIN=local
}

# The step stops before curl, saying why, and hands the steps after it nothing.
stops_before_curl() {
    run_step
    assert_status 1
    assert_line "::error::$1"
    assert_calls curl 0
    assert_runner_file GITHUB_PATH
    assert_runner_file GITHUB_ENV
}

test_codeql_stops_without_a_dockerfile_its_toolchain_stage_or_dockers_escape_character() {
    go_archive 1.27.4 amd64
    go_step
    stops_before_curl "CodeQL takes the Go of the toolchain stage of .devcontainer/Dockerfile, and the repository has no .devcontainer/Dockerfile."
    dockerfile <<'EOF'
FROM golang:1.27.4 AS builder
FROM builder AS devcontainer
EOF
    stops_before_curl ".devcontainer/Dockerfile has no stage toolchain, FROM ... AS toolchain."
    spec_dockerfile
    sed -i '2i # escape=`' "$step_workspace/.devcontainer/Dockerfile"
    stops_before_curl '.devcontainer/Dockerfile sets another escape character than \, and CodeQL reads its continued lines by \.'
}

test_codeql_stops_on_a_dockerfile_that_pins_go_otherwise() {
    local reason="CodeQL takes Go by ARG GO_VERSION and GO_SHA256_AMD64 of the toolchain stage of .devcontainer/Dockerfile, each once as ARG <name>=<value>, as spec's Dockerfile pins Go, and the stage and the stages it is built from have"
    go_archive 1.27.4 amd64
    go_step
    # Go from an image of its own: no ARG at all.
    dockerfile <<'EOF'
FROM golang:1.27.4@sha256:0000 AS toolchain
EOF
    stops_before_curl "$reason ARG GO_VERSION=<value> 0 times."
    # The ARGs only in a stage the toolchain stage is not built from.
    dockerfile <<EOF
FROM ubuntu:24.04 AS toolchain
FROM toolchain AS devcontainer
ARG GO_VERSION=1.27.4
ARG GO_SHA256_AMD64=${archive_sum}
EOF
    stops_before_curl "$reason ARG GO_VERSION=<value> 0 times."
    # The ARGs before the first FROM, outside every stage.
    dockerfile <<EOF
ARG GO_VERSION=1.27.4
ARG GO_SHA256_AMD64=${archive_sum}
FROM ubuntu:24.04 AS toolchain
ARG GO_VERSION
ARG GO_SHA256_AMD64
EOF
    stops_before_curl "$reason ARG GO_VERSION=<value> 0 times."
    # Twice, in two stages of the chain.
    dockerfile <<EOF
FROM ubuntu:24.04 AS core
ARG GO_VERSION=1.27.4
FROM core AS toolchain
ARG GO_VERSION=1.27.3
ARG GO_SHA256_AMD64=${archive_sum}
EOF
    stops_before_curl "$reason ARG GO_VERSION=<value> 2 times."
    # The version with the sum of arm64 alone.
    dockerfile <<EOF
FROM ubuntu:24.04 AS toolchain
ARG GO_VERSION=1.27.4
ARG GO_SHA256_ARM64=${archive_sum}
EOF
    stops_before_curl "$reason ARG GO_SHA256_AMD64=<value> 0 times."
    # A version or a sum that is none.
    dockerfile <<EOF
FROM ubuntu:24.04 AS toolchain
ARG GO_VERSION="1.27.4"
ARG GO_SHA256_AMD64=${archive_sum}
EOF
    stops_before_curl 'ARG GO_VERSION of .devcontainer/Dockerfile is "1.27.4", which is not a version of Go.'
    dockerfile <<EOF
FROM ubuntu:24.04 AS toolchain
ARG GO_VERSION=1.27.4
ARG GO_SHA256_AMD64=${archive_sum^^}
EOF
    stops_before_curl "ARG GO_SHA256_AMD64 of .devcontainer/Dockerfile is ${archive_sum^^}, which is not a sha256 in hexadecimal."
}

# The toolchain stage with Go as spec's, and the ENV lines from stdin; the step stops on $1.
stops_on_env() {
    dockerfile <<EOT
FROM ubuntu:24.04 AS toolchain
ARG GO_VERSION=1.27.4
ARG GO_SHA256_AMD64=${archive_sum}
$(cat)
EOT
    stops_before_curl "The toolchain stage of .devcontainer/Dockerfile sets $1, which CodeQL's build would take from the image, and codeql.yml takes Go without building it: it sets GOTOOLCHAIN=local alone."
}

test_codeql_stops_on_a_go_variable_of_the_toolchain_stage_it_cannot_work_out() {
    go_archive 1.27.4 amd64
    go_step
    stops_on_env GOFLAGS <<< "ENV GOFLAGS=-mod=mod"
    stops_on_env CGO_ENABLED <<< "env CGO_ENABLED=0"
    stops_on_env GOEXPERIMENT <<< "ENV GOEXPERIMENT none"
    stops_on_env GOPATH <<< "ENV GOTOOLCHAIN=local GOPATH=/go GOBIN=/go/bin"
    stops_on_env GOAMD64 < <(printf '%s\n' 'ENV PATH=/usr/local/go/bin:${PATH} \ ' '' '    # a comment Docker drops' '    GOAMD64=v3')
}

test_codeql_stops_on_a_runner_other_than_x64() {
    go_archive 1.27.4 arm64
    spec_dockerfile
    go_step ARM64
    stops_before_curl "CodeQL takes the archive of Go for X64, and the runner is ARM64."
}

test_codeql_stops_on_an_archive_that_is_not_the_one_the_dockerfile_checks() {
    local want
    go_archive 1.27.4 amd64
    want=$archive_sum
    spec_dockerfile
    go_archive 1.27.4 other
    go_step
    run_step
    assert_status 1
    assert_line "::error::The sha256 of https://go.dev/dl/go1.27.4.linux-amd64.tar.gz is ${archive_sum}, and ARG GO_SHA256_AMD64 of .devcontainer/Dockerfile is ${want}."
    assert_eq "$(if [ -e "$step_temp/go" ]; then echo unpacked; else echo none; fi)" none "the go folder"
    assert_runner_file GITHUB_PATH
    assert_runner_file GITHUB_ENV
    # go.dev gives nothing.
    printf 'not found\n' | curl_answer 404
    run_step
    assert_status 1
    assert_line "::error::go.dev gave no https://go.dev/dl/go1.27.4.linux-amd64.tar.gz."
    assert_runner_file GITHUB_PATH
    assert_runner_file GITHUB_ENV
}

# The step with the archive as it is now, from a fresh runner's temp.
fails_on_the_archive() {
    rm -rf -- "$step_temp/go"
    spec_dockerfile
    go_step
    run_step
    assert_status 1
    assert_line "::error::$1"
    assert_runner_file GITHUB_PATH
    assert_runner_file GITHUB_ENV
}

test_codeql_stops_on_an_archive_that_does_not_unpack_or_a_go_that_does_not_run_as_pinned() {
    # The sum holds, and the file is no archive.
    printf 'not an archive\n' > "$state/go.tar.gz"
    archive_sum=$(sha256sum < "$state/go.tar.gz")
    archive_sum=${archive_sum%% *}
    fails_on_the_archive "https://go.dev/dl/go1.27.4.linux-amd64.tar.gz does not unpack."
    # A go that fails.
    go_archive 1.27.4 amd64
    printf '#!/usr/bin/env bash\nexit 1\n' > "$state/archive/go/bin/go"
    pack_archive
    fails_on_the_archive "The Go of https://go.dev/dl/go1.27.4.linux-amd64.tar.gz does not run."
    # A go that names another version.
    go_archive 1.27.3 amd64
    fails_on_the_archive 'The Go of https://go.dev/dl/go1.27.4.linux-amd64.tar.gz says "go version go1.27.3 linux/amd64", not go1.27.4 linux/amd64.'
}

test_codeql_builds_no_image_and_analyses_go_by_autobuild_after_the_step_on_x64() {
    use_workflow codeql.yml
    assert_eq "$(wf_raw '[.jobs[] | .steps[]? | .run // empty | select(test("(^|[\\s;|&(])docker\\s"))] | length')" 0 "the steps that call docker"
    assert_eq "$(wf '.jobs.analyze.steps | map(.name // .uses | split("@")[0])')" \
        '["actions/checkout","Go of the caller'"'"'s toolchain stage","github/codeql-action/init","github/codeql-action/analyze"]' "the steps of analyze"
    assert_eq "$(wf_raw --arg n "${GO_STEP#name=}" '.jobs.analyze.steps[] | select(.name == $n) | .if')" "matrix.language == 'go'" "the step's if"
    assert_eq "$(wf_raw '.jobs.analyze["runs-on"]')" ubuntu-24.04 "the runner of analyze, X64"
    assert_eq "$(wf_raw '.jobs.analyze.steps[2].with["build-mode"]')" "\${{ matrix.language == 'go' && 'autobuild' || 'none' }}" "init's build-mode"
}
