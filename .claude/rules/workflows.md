---
paths:
  - ".github/workflows/**"
  - "tests/**"
---

# The workflows and their tests

`bash tests/run.sh` runs the tests of the workflows' steps (R28): each step, taken out of its file word for word, runs in bash on the runner's tools, with stand-ins for `docker`, `gh`, `curl`, `wget`, cosign and npm, in the cases where it passes and where it fails. A task that changes a step of a workflow — a shared one or a `self-` one — brings that step's cases and ends with the suite green. The job Workflows of `self-ci.yml` runs it on every pull request. The devcontainer has no yq, as it has no actionlint, so a local run takes yq at the version and SHA-256 that `self-ci.yml` pins, into a temporary directory, and names it by `YQ`.
