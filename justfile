# .github's own recipes, for its one Go module, tools/coderules: the tool of the rules of code
# that the shared go.yml runs with same-bits (R33 in docs/decisions.md). The ci- ones are what
# go.yml runs for .github itself, called from self-ci.yml by local path, one job each, in the
# toolchain stage of .devcontainer/Dockerfile, as for every Go repository of NovaTrail (R16).
# The tools only the checks need, at exact versions, as engine's justfile runs them: each is a Go
# program run straight from its module, so nothing is installed for it and go.mod gains no
# require. Dependabot does not see them, so they are raised by hand.
GOVULNCHECK := "golang.org/x/vuln/cmd/govulncheck@v1.9.0"
GO_LICENSES := "github.com/google/go-licenses/v2@v2.0.1"
MODULE := "tools/coderules"

# List the recipes.
default:
    @just --list

# Fails on code gofmt would rewrite and on what go vet reports. The controls in testdata/ break the
# rules on purpose, build constraints among them, and are no code of the module.
# Check formatting and go vet.
ci-lint:
    #!/usr/bin/env bash
    set -euo pipefail
    # The Go files git tracks or would, outside every testdata/. A file deleted from the working
    # tree but still in the index is skipped, so that gofmt does not fail on it with no word of
    # formatting.
    unformatted="$(git ls-files -z --cached --others --exclude-standard -- '*.go' ':(exclude,glob)**/testdata/**' \
        | while IFS= read -r -d '' file; do if [ -e "$file" ]; then printf '%s\0' "$file"; fi; done \
        | xargs -0 -r gofmt -l)"
    if [ -n "$unformatted" ]; then
        echo "ci-lint: gofmt would rewrite these files; run gofmt -w on them:" >&2
        echo "$unformatted" >&2
        exit 1
    fi
    go -C {{ MODULE }} vet ./...

# The coverage goes into coverage/go.out at the root, one Go profile, which the job coverage of
# go.yml sends to Codecov (R48 spec). Every test counts for every package of the module.
# Run the tests, with the race detector, and write their coverage.
ci-test:
    mkdir -p coverage
    go -C {{ MODULE }} test -race -count=1 -covermode=atomic -coverpkg=./... \
        -coverprofile={{ quote(justfile_directory() / "coverage/go.out") }} ./...

# Fail on a known vulnerability in code the module reaches.
ci-vuln:
    go -C {{ MODULE }} run {{ GOVULNCHECK }} ./...

# Fails if a package the module is built from carries a license outside ALLOWED_LICENSES, SPDX
# identifiers separated by commas, which go.yml sets.
# Check the licenses of what the module is built from against ALLOWED_LICENSES.
ci-licenses:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -z "${ALLOWED_LICENSES:-}" ]; then
        echo "ci-licenses: ALLOWED_LICENSES is not set. CI takes it from go.yml; to run this here, set it to the list there." >&2
        exit 1
    fi
    # The module itself is .github's, under the LICENSE at the root of the repository, Apache-2.0,
    # which go-licenses looks for in the folder of the module alone: it is left out by name, and what
    # the module is built from — the standard library, as go.mod requires nothing — is checked.
    go -C {{ MODULE }} run {{ GO_LICENSES }} check ./... --allowed_licenses="$ALLOWED_LICENSES" \
        --ignore github.com/altnovatrail/.github/tools/coderules
