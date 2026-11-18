# The recipes of .github's one Go module, tools/coderules, which the shared go.yml checks from
# self-ci.yml as it checks every Go repository's (R16, R33). The tools of the checks run straight
# from their modules at exact versions, so nothing is installed for them and go.mod gains no
# require; Dependabot does not see them, so they are raised by hand.
GOVULNCHECK := "golang.org/x/vuln/cmd/govulncheck@v1.9.0"
GO_LICENSES := "github.com/google/go-licenses/v2@v2.0.1"
MODULE := "tools/coderules"

# List the recipes.
default:
    @just --list

# The controls in testdata/ break the rules on purpose, build constraints among them, and are no
# code of the module.
# Check formatting and go vet.
ci-lint:
    #!/usr/bin/env bash
    set -euo pipefail
    # A file deleted from the working tree but still in the index is skipped, so that gofmt does not
    # fail on it with no word of formatting.
    unformatted="$(git ls-files -z --cached --others --exclude-standard -- '*.go' ':(exclude,glob)**/testdata/**' \
        | while IFS= read -r -d '' file; do if [ -e "$file" ]; then printf '%s\0' "$file"; fi; done \
        | xargs -0 -r gofmt -l)"
    if [ -n "$unformatted" ]; then
        echo "ci-lint: gofmt would rewrite these files; run gofmt -w on them:" >&2
        echo "$unformatted" >&2
        exit 1
    fi
    go -C {{ MODULE }} vet ./...

# coverage/go.out is the report go.yml's coverage job sends to Codecov (R48 spec).
# Run the tests, with the race detector, and write their coverage.
ci-test:
    mkdir -p coverage
    go -C {{ MODULE }} test -race -count=1 -covermode=atomic -coverpkg=./... \
        -coverprofile={{ quote(justfile_directory() / "coverage/go.out") }} ./...

# Fail on a known vulnerability in code the module reaches.
ci-vuln:
    go -C {{ MODULE }} run {{ GOVULNCHECK }} ./...

# ALLOWED_LICENSES, SPDX identifiers separated by commas, is the list go.yml sets.
# Check the licenses of what the module is built from against ALLOWED_LICENSES.
ci-licenses:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -z "${ALLOWED_LICENSES:-}" ]; then
        echo "ci-licenses: ALLOWED_LICENSES is not set. CI takes it from go.yml; to run this here, set it to the list there." >&2
        exit 1
    fi
    # The module is .github's, under the LICENSE at the root, Apache-2.0, which go-licenses looks for
    # in the folder of the module alone: so it is left out by name, and what it is built from is
    # checked.
    go -C {{ MODULE }} run {{ GO_LICENSES }} check ./... --allowed_licenses="$ALLOWED_LICENSES" \
        --ignore github.com/altnovatrail/.github/tools/coderules
