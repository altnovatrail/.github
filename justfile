# Trial (T22, never merged): the four recipes typescript.yml calls, as R19 agrees them.

# Types, from the lock file's packages.
ci-lint:
    npm ci --no-audit --no-fund
    npx tsc --noEmit

# The tests, in Node and in Chromium.
ci-test:
    npm ci --no-audit --no-fund
    npx vitest run

# The advisories of every package of the lock file, at high and above: the registry answers.
ci-vuln:
    npm audit --audit-level=high

# The license of every package of the lock file, against ALLOWED_LICENSES.
ci-licenses:
    node trial/licenses.mjs
