# Trial (T29, never merged): the four recipes typescript.yml calls, with ci-licenses on spec's
# recipe, as R19 agrees it. Each first shows that ALLOWED_LICENSES never reached its container;
# the other three also show that their job has no spec submodule.

# Types, from the lock file's packages.
ci-lint:
    test -z "${ALLOWED_LICENSES+x}"
    test ! -e spec/justfile
    npm ci --no-audit --no-fund
    npx tsc --noEmit

# The tests, in Node and in Chromium.
ci-test:
    test -z "${ALLOWED_LICENSES+x}"
    test ! -e spec/justfile
    npm ci --no-audit --no-fund
    npx vitest run

# The advisories of every package of the lock file, at high and above: the registry answers.
ci-vuln:
    test -z "${ALLOWED_LICENSES+x}"
    test ! -e spec/justfile
    npm audit --audit-level=high

# The license of every package of the lock file, by spec's recipe from the spec submodule, with
# this repository's exceptions.
ci-licenses:
    test -z "${ALLOWED_LICENSES+x}"
    just -f spec/justfile licenses-check-repo package-lock.json licenses.json
