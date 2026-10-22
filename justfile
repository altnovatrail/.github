# A trial for T27 of RUN.md, never merged: the recipe the shared release.yml runs, which writes
# the npm archive of the trial package into dist/, with the release's number as its version.

# Write the npm archive of the trial package into dist/.
release-files version:
    #!/usr/bin/env bash
    set -euo pipefail
    version={{ quote(version) }}
    mkdir -p dist
    npm version --no-git-tag-version --allow-same-version "${version#v}" > /dev/null
    npm pack --pack-destination dist --ignore-scripts
