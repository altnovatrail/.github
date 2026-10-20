# .github

The NovaTrail organization's own repository on GitHub. It holds the organization's profile, which GitHub shows on [github.com/altnovatrail](https://github.com/altnovatrail). It also holds the community health files that GitHub shows in every repository of the organization that has none of its own: how to contribute, how to report a vulnerability, and the code of conduct. It also gets the CI workflows that the repositories share: the shared checks before any repository has code, and the workflows for code together with the first code.

A component of [NovaTrail](https://github.com/altnovatrail/spec/tree/v0.2.6), a universal open platform for adaptive learning, interactive lessons and AI tutoring. It belongs to stage 0, Foundation, together with spec.

## Status

Detailing done. The first epic of [RUN.md](RUN.md) decided what the component's card left open: which CI workflows are shared and which are each repository's own, how they are versioned, and how they keep secrets ([docs/decisions.md](docs/decisions.md), R03–R05). The second epic, E2, is under way: it writes the shared checks and publishes the first release of `.github`. The checks for secrets, DCO, documents, CodeQL and Scorecard are written; the release comes next. The workflows for code follow with module-kit's first code, in the order RUN.md sets.

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

The working rules, for people and coding agents alike, are in [CLAUDE.md](CLAUDE.md) and [AGENTS.md](AGENTS.md). The platform's shared vocabulary, formats, contracts and decisions are in [spec](https://github.com/altnovatrail/spec/tree/v0.2.6), checked out here as a git submodule at `v0.2.6`: clone this repository with `git clone --recurse-submodules`.

## License

[Apache-2.0](LICENSE), except [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md): it is the Contributor Covenant 2.1 and keeps that text's own license, [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
