# .github

[![CI](https://github.com/altnovatrail/.github/actions/workflows/self-ci.yml/badge.svg)](https://github.com/altnovatrail/.github/actions/workflows/self-ci.yml)
[![Release](https://github.com/altnovatrail/.github/actions/workflows/self-release.yml/badge.svg)](https://github.com/altnovatrail/.github/actions/workflows/self-release.yml)
[![CodeQL](https://github.com/altnovatrail/.github/actions/workflows/self-codeql.yml/badge.svg)](https://github.com/altnovatrail/.github/actions/workflows/self-codeql.yml)
[![Latest release](https://img.shields.io/github/v/release/altnovatrail/.github)](https://github.com/altnovatrail/.github/releases/latest)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/altnovatrail/.github/badge)](https://scorecard.dev/viewer/?uri=github.com/altnovatrail/.github)
[![License](https://img.shields.io/github/license/altnovatrail/.github)](LICENSE)

[![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=altnovatrail_.github&metric=code_smells)](https://sonarcloud.io/summary/new_code?id=altnovatrail_.github)
[![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=altnovatrail_.github&metric=reliability_rating)](https://sonarcloud.io/summary/new_code?id=altnovatrail_.github)
[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=altnovatrail_.github&metric=security_rating)](https://sonarcloud.io/summary/new_code?id=altnovatrail_.github)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=altnovatrail_.github&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=altnovatrail_.github)
[![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=altnovatrail_.github&metric=vulnerabilities)](https://sonarcloud.io/summary/new_code?id=altnovatrail_.github)

The NovaTrail organization's own repository on GitHub. It holds the organization's profile, which GitHub shows on [github.com/altnovatrail](https://github.com/altnovatrail). It also holds the community health files that GitHub shows in every repository of the organization that has none of its own: how to contribute, how to report a vulnerability, the code of conduct, and the forms and template for issues and pull requests. It also gets the CI workflows that the repositories share: the shared checks before any repository has code, and the workflows for code together with the first code.

A component of [NovaTrail](https://github.com/altnovatrail/spec/tree/v0.5.3), a universal open platform for adaptive learning, interactive lessons and AI tutoring. It belongs to stage 0, Foundation, together with spec.

## Status

Detailing done. The first epic of [RUN.md](RUN.md) decided what the component's card left open: which CI workflows are shared and which are each repository's own, how they are versioned, and how they keep secrets ([docs/decisions.md](docs/decisions.md), R03–R05). The second epic, E2, is done. The shared checks for secrets, DCO, documents, CodeQL and Scorecard are written, and `.github` publishes them in releases of its own; the first is v0.1.0. Its `main` is under a ruleset: CodeQL's findings hold a merge, and a pull request goes into `main` only as a merge commit (E4). The third epic, E3, is done too: the Go wrapper, Go in the shared CodeQL and the signed release are written, and module-kit's first release, v0.1.0, came out of the shared release, each file signed. The fifth epic, E5, is done as well: the TypeScript wrapper, typescript.yml, was tried here on a trial package with a test in Chromium and came out in v0.1.5. canvas's first code calls it by that release's SHA, and canvas's ruleset requires its four checks. The sixth and seventh epics, E6 and E7, are done too. E6 has moved `.github` to spec v0.2.17 and then v0.2.21, which answer what `.github` asked of it: both releases run spec's recipes by spec's toolchain script, the shared one from the release T25 brings, for callers on spec v0.2.17 or newer, and the license checks take spec's recipes, the TypeScript wrapper's from the release T26 brings, and since the release T29 brings, typescript.yml carries no copy of spec's license list; E7 has added publishing to npm to the shared release, from the release T27 brings: a caller names its package, and the first real publication comes with canvas's first release that publishes. The eighth epic, E8, has moved `.github` to spec v0.2.23. The ninth, E9, has moved it to spec v0.4.1, which gives this README its status badges, and then to v0.5.3, which answers what `.github` asked of spec on the way; E9 also takes up what that release asks of `.github`: a response time in SECURITY.md, a suite of tests for the shared workflows, a check the npm step of the shared release still lacks, and the upload of test coverage in the code wrappers.

## Documents

The documents are in Russian.

- [docs/architecture.md](docs/architecture.md) — the component: what it does and does not do, its data and links, and what is still to decide.
- [docs/decisions.md](docs/decisions.md) — the decision log: what was decided, why, and what was rejected.
- [RUN.md](RUN.md) — the work plan, in epics.

The profile and the community health files are in English, since GitHub shows them to everyone:

- [profile/README.md](profile/README.md) — the organization's profile.
- [CONTRIBUTING.md](CONTRIBUTING.md) — how to contribute to a NovaTrail repository.
- [SECURITY.md](SECURITY.md) — how to report a vulnerability, privately.
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) — the code of conduct, the Contributor Covenant 2.1.
- [.github/ISSUE_TEMPLATE/](.github/ISSUE_TEMPLATE/) — the issue forms, a bug report and a change proposal, and the template chooser: it offers no blank issue and sends a vulnerability to SECURITY.md.
- [.github/pull_request_template.md](.github/pull_request_template.md) — the pull request template and its checklist.

The working rules, for people and coding agents alike, are in [CLAUDE.md](CLAUDE.md) and [AGENTS.md](AGENTS.md). The platform's shared vocabulary, formats, contracts and decisions are in [spec](https://github.com/altnovatrail/spec/tree/v0.5.3), checked out here as a git submodule at `v0.5.3`: clone this repository with `git clone --recurse-submodules`.

## License

[Apache-2.0](LICENSE), except [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md): it is the Contributor Covenant 2.1 and keeps that text's own license, [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
