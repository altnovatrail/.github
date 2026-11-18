# The documents of .github

What the [README](../README.md) of the repository leaves out, which says only what the component is and where it stands in NovaTrail (the second 2026-11-17 amendment to R21 spec). How to build and run the component, and anything else of the kind, is added here as it comes, or in a document of its own that this list names.

- [architecture.md](architecture.md) — the component: what it does and does not do, its data and links, and what is still to decide.
- [decisions.md](decisions.md) — the decision log: what was decided, why, and what was rejected.
- [sources.md](sources.md) — the records of external facts the documents rest on, each with its source, its date and its quote.
- [measurements.md](measurements.md) — the results of measurements: trial runs of the shared workflows, the suite of their tests, durations and sizes.
- [RUN.md](../RUN.md) — the work plan, in epics.
- `run/` — the plan's other tables: [the epics for later](../run/EPICS.md), [the open questions](../run/QUESTIONS.md) and [the technical debt](../run/DEBT.md).

What the other repositories take from it, by the SHA of a [release](https://github.com/altnovatrail/.github/releases):

- [.github/workflows/](../.github/workflows/) — the shared workflows, beside `.github`'s own `self-` ones; what each does and the calling files a repository copies are in [architecture.md](architecture.md), sections 3.1 and 3.3.
- [.github/actions/toolchain/](../.github/actions/toolchain/action.yml) — the composite action for a repository's own job: the image of its stage `toolchain` and the Go caches, architecture section 3.7.
- [tools/coderules/](../tools/coderules/main.go) — the test of the rules of code that the Go wrapper runs, with its `justfile` recipes; [tests/](../tests/) — the suite of the workflows' steps.

The profile and the community health files, which GitHub shows to everyone:

- [profile/README.md](../profile/README.md) — the organization's profile.
- [CONTRIBUTING.md](../CONTRIBUTING.md) — how to contribute to a NovaTrail repository.
- [SECURITY.md](../SECURITY.md) — how to report a vulnerability, privately.
- [CODE_OF_CONDUCT.md](../CODE_OF_CONDUCT.md) — the code of conduct, the Contributor Covenant 2.1.
- [.github/ISSUE_TEMPLATE/](../.github/ISSUE_TEMPLATE/) — the issue forms, a bug report and a change proposal, and the template chooser: it offers no blank issue and sends a vulnerability to SECURITY.md.
- [.github/pull_request_template.md](../.github/pull_request_template.md) — the pull request template and its checklist.

The working rules, for people and coding agents alike, are in [CLAUDE.md](../CLAUDE.md) and [AGENTS.md](../AGENTS.md). The platform's shared vocabulary, formats, contracts and decisions are in [spec](https://github.com/altnovatrail/spec), checked out here as a git submodule: clone this repository with `git clone --recurse-submodules`.
