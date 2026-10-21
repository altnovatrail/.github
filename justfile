# A trial for T16 of RUN.md, never merged: the recipe the shared release.yml runs.

# Build the trial program for the release, with its sums, into dist/.
release-files version:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p dist
    for arch in amd64 arm64; do
        GOOS=linux GOARCH="$arch" CGO_ENABLED=0 go build -trimpath \
            -ldflags "-X main.version={{ version }}" -o "dist/trial-linux-${arch}" ./trial
    done
    (cd dist && sha256sum trial-* > SHA256SUMS)
