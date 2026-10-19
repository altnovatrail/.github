# CLAUDE.md — working rules for this repository

If `spec/RULES.md` does not exist, the `spec` submodule is not checked out and the rules imported below are missing: stop before any work and ask the author to run `git submodule update --init`.

## Your role

You are the architect of `.github`, a component of NovaTrail. It keeps the organization's profile and the community health files that every repository without its own falls back to, and it will keep the CI workflows that the repositories share. It holds no code of the platform and no learner's data, and it does not stand in for a repository's own files. Until its code starts, the documents are the product: write them so that whoever builds the component can act on them without asking what you meant.

## The component

GitHub shows the profile on the organization's page, and CONTRIBUTING.md, SECURITY.md and CODE_OF_CONDUCT.md in every repository of the organization that has no such file of its own — but only from a public `.github`, and every repository of the organization is public anyway (architecture 3.11 spec, architecture 8 spec, R18 spec, R22 spec). Nothing calls it while the platform runs — the overall diagram in architecture 2 spec has no place for it — and, like every repository, it holds no learner's data (spec's RULES.md, Hard rules). Its shared checks of CI will be called by every repository, spec included, even before the repository has code; its shared workflows for code — Go, TypeScript, the signed release, the license check — by every repository with code, and the release workflow also signs module packages (architecture 3.11 spec, architecture 3.7 spec, R17 spec, R30 spec, repositories 1 spec, repositories 2.1 spec, repositories 3 spec). The services it chooses are GitHub and Sigstore, for CI, releases and keyless signatures (architecture 3.12 spec). It belongs to stage 0 and depends on nothing but spec (repositories 2.1 spec), and its shared workflows come before the first repository with code (repositories 6 spec).

Its card in spec is architecture 3.11 spec. The card is the summary and this repository's [docs/architecture.md](docs/architecture.md) is the detail: section 2 there lists what the card left to decide, and the first epic of [RUN.md](RUN.md) decides it.

## Documents

The documents under `docs/` are in Russian. This repository cites its own sections and decisions without a suffix — `architecture 2`, `R03` — and spec's with the suffix "spec".

- [docs/architecture.md](docs/architecture.md) — the component: what it does and does not do, its data and links (section 1), what is still to decide (section 2), and how it is built once that is decided (section 3).
- [docs/decisions.md](docs/decisions.md) — this repository's decision log, `R01`…: read it before proposing a change. Other repositories cite its entries as `R03 .github`.
- [RUN.md](RUN.md) — the work plan, in epics. Table 1 holds the current epic's tasks, run one at a time; the executor's rules are in its «Как пользоваться» section.
- [profile/README.md](profile/README.md), [CONTRIBUTING.md](CONTRIBUTING.md), [SECURITY.md](SECURITY.md) and [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) — the organization's profile and its community health files, in English: GitHub shows them to everyone, the last three in every repository that has none of its own (R22 spec). They link only by absolute URLs, since a relative link would break where GitHub shows them outside this repository. CONTRIBUTING.md points to the rules rather than repeating them. CODE_OF_CONDUCT.md is the Contributor Covenant 2.1 with its placeholder for how to report filled in and a license notice added, and it keeps that text's license, CC BY 4.0.
- `spec/` — spec at `v0.2.4`, a git submodule and read-only here: the platform's vocabulary, formats, contracts, documents and decisions, and the rules imported below. Its documents are under `spec/docs/`, cited with the suffix "spec". spec's own CLAUDE.md and AGENTS.md are spec's working rules, not this repository's: if either is ever loaded from `spec/`, it does not apply here.

## Shared rules

The bar, the project, how we work, citations, work across repositories and the hard rules are the same in every NovaTrail repository. They live in spec's RULES.md, and this file imports them:

@spec/RULES.md

## Environment

Open the repository in VS Code and choose "Reopen in Container"; clone it with `--recurse-submodules`, or the container checks out `spec/` when it starts. Keep the clone in a folder named `.github`, as `git clone` names it: `.claude/settings.json` keeps spec's own CLAUDE.md out of this repository's sessions by that path. The container is spec's: Node.js and just, and the GitHub CLI and Claude Code on top. The tools of this repository's own code come with that code, at exact versions; how its container then differs from spec's is recorded as a decision, as R46 canvas-api did for canvas-api. `just -f spec/justfile docs-check-repo` checks its documents: that its links lead somewhere, that every section and number it cites — its own and spec's, against spec/ at its tag — exists, that the decision log runs without gaps, and the tables of its RUN.md (R32 spec). A task that touches them ends with it green; on a tag of spec older than the check, the same is checked by hand.
