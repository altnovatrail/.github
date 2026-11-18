# .github

[![CI](https://github.com/altnovatrail/.github/actions/workflows/self-ci.yml/badge.svg)](https://github.com/altnovatrail/.github/actions/workflows/self-ci.yml)
[![Release](https://github.com/altnovatrail/.github/actions/workflows/self-release.yml/badge.svg)](https://github.com/altnovatrail/.github/actions/workflows/self-release.yml)
[![CodeQL](https://github.com/altnovatrail/.github/actions/workflows/self-codeql.yml/badge.svg)](https://github.com/altnovatrail/.github/actions/workflows/self-codeql.yml)
[![Latest release](https://img.shields.io/github/v/release/altnovatrail/.github)](https://github.com/altnovatrail/.github/releases/latest)
[![Go version](https://img.shields.io/github/go-mod/go-version/altnovatrail/.github?filename=tools%2Fcoderules%2Fgo.mod)](tools/coderules/go.mod)
[![Coverage](https://codecov.io/gh/altnovatrail/.github/branch/main/graph/badge.svg)](https://codecov.io/gh/altnovatrail/.github)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/altnovatrail/.github/badge)](https://scorecard.dev/viewer/?uri=github.com/altnovatrail/.github)
[![License](https://img.shields.io/github/license/altnovatrail/.github)](LICENSE)

[![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=altnovatrail_.github&metric=code_smells)](https://sonarcloud.io/summary/new_code?id=altnovatrail_.github)
[![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=altnovatrail_.github&metric=reliability_rating)](https://sonarcloud.io/summary/new_code?id=altnovatrail_.github)
[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=altnovatrail_.github&metric=security_rating)](https://sonarcloud.io/summary/new_code?id=altnovatrail_.github)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=altnovatrail_.github&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=altnovatrail_.github)
[![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=altnovatrail_.github&metric=vulnerabilities)](https://sonarcloud.io/summary/new_code?id=altnovatrail_.github)

The NovaTrail organization's own repository on GitHub. It holds the organization's profile, which GitHub shows on [github.com/altnovatrail](https://github.com/altnovatrail). It also holds the community health files that GitHub shows in every repository of the organization that has none of its own: how to contribute, how to report a vulnerability, the code of conduct, and the forms and template for issues and pull requests. It also holds the CI workflows that the repositories share — the shared checks, which a repository runs before it has code, and the workflows for code, which came with the first code they check —, and a composite action that gives a repository's own job the image and the Go caches those workflows use. Its one Go code, [tools/coderules](tools/coderules/main.go), is a tool those workflows run: the test of the rules of code that keep a library's bits the same on every build.

A component of [NovaTrail](https://github.com/altnovatrail/spec), a universal open platform for adaptive learning, interactive lessons and AI tutoring.

Nothing calls it while the platform runs, and it holds no learner's data. Every other repository of NovaTrail, spec among them, shows its community health files where it has none of its own and calls its shared workflows, each pinned by a release of this one; the shared release signs a repository's files keylessly through Sigstore and publishes its packages to npm, and the wrappers for code send the coverage of a repository's tests to Codecov.

Its card is architecture 3.11 spec, among the documents of [spec](https://github.com/altnovatrail/spec); its own documents, its decisions and its plan are in [docs/](docs/README.md).
