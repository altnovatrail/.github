# A trial for T25 of RUN.md, never merged: the recipe the shared release.yml runs. What it builds
# does not matter here, only that spec's recipes around it run by spec's toolchain script.

# Write one file for the release into dist/.
release-files version:
    mkdir -p dist
    printf 'trial %s\n' {{ quote(version) }} > dist/trial.txt
