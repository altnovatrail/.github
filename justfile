# Trial (T64, never merged): the recipes typescript.yml calls, with ci-engines, by the contract of
# the amendment to R19. Each prints the size of /dev/shm, which is the host's with --ipc=host and
# Docker's 64 MB without it. .github's own Go recipes are not here, so "Go / …" of self-ci.yml are
# red on this pull request.

ci: ci-lint ci-test ci-engines ci-vuln ci-licenses

ci-lint:
    df -k /dev/shm
    test ! -e spec/justfile
    npm ci --no-audit --no-fund

# The tests in Node and Chromium, with the coverage.
ci-test:
    df -k /dev/shm
    test ! -e spec/justfile
    npm ci --no-audit --no-fund
    node_modules/.bin/vitest run --coverage --project node --project 'browser (chromium)'

# The tests in WebKit and Firefox, without it.
ci-engines:
    df -k /dev/shm
    test ! -e spec/justfile
    npm ci --no-audit --no-fund
    node_modules/.bin/vitest run --project 'browser (webkit)' --project 'browser (firefox)'

ci-vuln:
    df -k /dev/shm
    npm audit --audit-level=high

ci-licenses:
    df -k /dev/shm
    just -f spec/justfile licenses-check-repo package-lock.json licenses.json
