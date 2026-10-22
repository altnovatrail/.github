# .github

The NovaTrail organization's own repository on GitHub. It holds the organization's profile, which GitHub shows on [github.com/altnovatrail](https://github.com/altnovatrail). It also holds the community health files that GitHub shows in every repository of the organization that has none of its own: how to contribute, how to report a vulnerability, and the code of conduct. It also gets the CI workflows that the repositories share: the shared checks before any repository has code, and the workflows for code together with the first code.

A component of [NovaTrail](https://github.com/altnovatrail/spec/tree/v0.2.21), a universal open platform for adaptive learning, interactive lessons and AI tutoring. It belongs to stage 0, Foundation, together with spec.

## Status

Detailing done. The first epic of [RUN.md](RUN.md) decided what the component's card left open: which CI workflows are shared and which are each repository's own, how they are versioned, and how they keep secrets ([docs/decisions.md](docs/decisions.md), R03–R05). The second epic, E2, is done. The shared checks for secrets, DCO, documents, CodeQL and Scorecard are written, and `.github` publishes them in releases of its own; the first is v0.1.0. Its `main` is under a ruleset: CodeQL's findings hold a merge, and a pull request goes into `main` only as a merge commit (E4). The third epic, E3, is done too: the Go wrapper, Go in the shared CodeQL and the signed release are written, and module-kit's first release, v0.1.0, came out of the shared release, each file signed. The fifth epic, E5, is done as well: the TypeScript wrapper, typescript.yml, was tried here on a trial package with a test in Chromium and came out in v0.1.5. canvas's first code calls it by that release's SHA, and canvas's ruleset requires its four checks. Two epics are under way. E6 has moved `.github` to spec v0.2.17 and then v0.2.21, which answer what `.github` asked of it: both releases run spec's recipes by spec's toolchain script, the shared one from the release T25 brings, for callers on spec v0.2.17 or newer, and the license checks take spec's recipes, the TypeScript wrapper's from the release T26 brings, and since the release T29 brings, typescript.yml carries no copy of spec's license list; E7 has added publishing to npm to the shared release, from the release T27 brings: a caller names its package, and the first real publication comes with canvas's first release that publishes.

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

The working rules, for people and coding agents alike, are in [CLAUDE.md](CLAUDE.md) and [AGENTS.md](AGENTS.md). The platform's shared vocabulary, formats, contracts and decisions are in [spec](https://github.com/altnovatrail/spec/tree/v0.2.21), checked out here as a git submodule at `v0.2.21`: clone this repository with `git clone --recurse-submodules`.

## License

[Apache-2.0](LICENSE), except [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md): it is the Contributor Covenant 2.1 and keeps that text's own license, [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
