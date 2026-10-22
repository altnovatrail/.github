# Trial (T26, never merged): the four recipes typescript.yml calls, with ci-licenses on spec's
# recipe, as R19 now agrees it. The other three first show that their job has no spec submodule.

# Types, from the lock file's packages.
ci-lint:
    test ! -e spec/justfile
    npm ci --no-audit --no-fund
    npx tsc --noEmit

# The tests, in Node and in Chromium.
ci-test:
    test ! -e spec/justfile
    npm ci --no-audit --no-fund
    npx vitest run

# The advisories of every package of the lock file, at high and above: the registry answers.
ci-vuln:
    test ! -e spec/justfile
    npm audit --audit-level=high

# The license of every package of the lock file, by spec's recipe from the spec submodule, with
# this repository's exceptions.
ci-licenses:
    just -f spec/justfile licenses-check-repo trial/lock-v1.json
