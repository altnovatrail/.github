# Trial (T48, never merged): the four recipes go.yml calls, for the trial module at the root.

ci-lint:
    test -z "$(gofmt -l trial)"
    go vet ./...

ci-test:
    mkdir -p coverage
    go test -race -count=1 -coverprofile=coverage/go.out ./...

ci-vuln:
    echo "The trial module requires nothing."

ci-licenses:
    echo "The trial module requires nothing."
