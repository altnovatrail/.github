# Trial (T34, never merged): the four recipes both go.yml and typescript.yml call, for the Go
# module and the TypeScript package at the root at once, as in a repository with both. ci-test
# writes both reports: go.yml uploads coverage/go.out, typescript.yml coverage/lcov.info. Vitest
# empties coverage/ before its tests (coverage.clean), so Go's profile comes after it.

ci-lint:
    test -z "$(gofmt -l .)"
    go vet ./...
    npm ci --no-audit --no-fund
    npx tsc --noEmit

ci-test:
    npm ci --no-audit --no-fund
    npx vitest run --coverage
    go test -race -count=1 ./...

ci-vuln:
    npm audit --audit-level=high

# go.yml hands its list in and takes no submodule; typescript.yml takes spec's recipe from it.
ci-licenses:
    if [ -n "${ALLOWED_LICENSES+x}" ]; then echo "The Go module requires nothing."; else just -f spec/justfile licenses-check-repo package-lock.json licenses.json; fi
