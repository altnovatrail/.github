---
paths:
  - "tools/coderules/**"
  - "justfile"
---

# The Go code of .github

`tools/coderules/`, the tool of the rules of code that the shared `go.yml` runs with `same-bits`, is `.github`'s one Go code, and the justfile's four `ci-` recipes check it, as `go.yml` checks every caller's Go code, from `self-ci.yml` (R33). It takes the Go of spec's container and nothing else, and the justfile runs govulncheck and go-licenses straight from their modules at exact versions: `just ci-test` runs its tests and writes their coverage to `coverage/go.out`, and `ALLOWED_LICENSES=<the list of go.yml> just ci-licenses` runs its license check. A task that touches the code ends with `ci-lint`, `ci-test`, `ci-vuln` and `ci-licenses` green.
