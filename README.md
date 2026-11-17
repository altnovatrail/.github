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

The NovaTrail organization's own repository on GitHub. It holds the organization's profile, which GitHub shows on [github.com/altnovatrail](https://github.com/altnovatrail). It also holds the community health files that GitHub shows in every repository of the organization that has none of its own: how to contribute, how to report a vulnerability, the code of conduct, and the forms and template for issues and pull requests. It also gets the CI workflows that the repositories share: the shared checks before any repository has code, and the workflows for code together with the first code. Its one Go code, [tools/coderules](tools/coderules/main.go), is a tool those workflows run: the test of the rules of code that keep a library's bits the same on every build.

A component of [NovaTrail](https://github.com/altnovatrail/spec), a universal open platform for adaptive learning, interactive lessons and AI tutoring. It belongs to stage 0, Foundation, together with spec.

## Documents

- [docs/architecture.md](docs/architecture.md) — the component: what it does and does not do, its data and links, and what is still to decide.
- [docs/sources.md](docs/sources.md) — the external facts the documents rest on, each with its source, the date it was read and its quote.
- [docs/measurements.md](docs/measurements.md) — the results of measurements: trial runs of the shared workflows, the suite of their tests, durations and sizes.
- [docs/decisions.md](docs/decisions.md) — the decision log: what was decided, why, and what was rejected.
- [RUN.md](RUN.md) — the work plan, in epics.
- `run/` — the plan's other tables: [the epics for later](run/EPICS.md), [the open questions](run/QUESTIONS.md) and [the technical debt](run/DEBT.md).

The profile and the community health files, which GitHub shows to everyone:

- [profile/README.md](profile/README.md) — the organization's profile.
- [CONTRIBUTING.md](CONTRIBUTING.md) — how to contribute to a NovaTrail repository.
- [SECURITY.md](SECURITY.md) — how to report a vulnerability, privately.
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) — the code of conduct, the Contributor Covenant 2.1.
- [.github/ISSUE_TEMPLATE/](.github/ISSUE_TEMPLATE/) — the issue forms, a bug report and a change proposal, and the template chooser: it offers no blank issue and sends a vulnerability to SECURITY.md.
- [.github/pull_request_template.md](.github/pull_request_template.md) — the pull request template and its checklist.

The working rules, for people and coding agents alike, are in [CLAUDE.md](CLAUDE.md) and [AGENTS.md](AGENTS.md). The platform's shared vocabulary, formats, contracts and decisions are in [spec](https://github.com/altnovatrail/spec), checked out here as a git submodule: clone this repository with `git clone --recurse-submodules`.
