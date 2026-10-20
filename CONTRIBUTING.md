# Contributing to NovaTrail

Thank you for your interest in NovaTrail. This guide holds in every repository of [altnovatrail](https://github.com/altnovatrail) that has no CONTRIBUTING.md of its own.

NovaTrail is in early design. Its documents are the product for now, and each repository's work goes task by task, in the order its RUN.md sets. The rules that every repository shares are in RULES.md of [spec](https://github.com/altnovatrail/spec), and each repository's CLAUDE.md adds its own. Read RULES.md in the repository's `spec/` submodule: that is the version the repository pins. This guide does not repeat the rules; where it seems to differ from them, they win.

## Before you start

- **Open an issue first**, unless the change fixes a typo or a broken link. Say what you would change and why: the maintainer plans each repository's work in its RUN.md, so a pull request that comes without an issue may wait, or be declined.
- **Read the repository's `docs/decisions.md`** before you propose a change. What a decision rejected is not proposed again without new evidence; if you have such evidence, say so in the issue.
- **Write issues and pull requests in English or Russian.** In the repositories themselves, the documents under `docs/` and RUN.md are in Russian, and everything else — README, code, comments — is in English.

## What every contribution keeps to

- **No learners' data.** Never put a learner's name, work, handwriting, voice, photo, email or account identifier into an issue, a pull request, a screenshot, a test or an example. Examples are synthetic.
- **No samples for eval sets yet.** Handwriting, voice and photo samples for eval sets are not accepted until the project decides how the people who make them consent to their publication. That is П-16, an open question of spec's privacy document.
- **No secrets.** Keys and tokens never go into a commit.
- **The devcontainer.** Work in the repository's devcontainer: it has every tool at the exact version the repository pins.
- **Licenses.** Add only dependencies whose licenses are compatible with Apache-2.0. A development or CI tool that never ships may carry another OSI-approved license or free terms for open source, but only as a named exception, as RULES.md says.

## License and sign-off

The code, the documents and the official modules' content are under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0), and a contribution you submit is under the same license, as section 5 of the license says. The one exception is the code of conduct: it keeps the license of the Contributor Covenant, [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/), and so does a change to it.

Sign off every commit. The sign-off certifies the [Developer Certificate of Origin 1.1](https://developercertificate.org/): that you have the right to submit the contribution under the project's open source license.

```
git commit -s
```

This adds a line `Signed-off-by: Your Name <you@example.com>` to the commit, with the same name and email as the commit's author: the DCO check of every pull request compares the two, and a sign-off with another address fails it. The line and the email in it stay public in the history for good: point (d) of the certificate says that the record of a contribution, sign-off included, is maintained indefinitely. To keep your address private, make your GitHub noreply address the email you commit with; `git commit -s` then signs off with it too.

## Coding agents

Coding agents are welcome. The repository's AGENTS.md and CLAUDE.md bind them as they bind people, and the person who signs off a commit answers for it.

## Security and conduct

- Report a vulnerability privately, as [SECURITY.md](https://github.com/altnovatrail/.github/blob/main/SECURITY.md) says — never in a public issue.
- Everyone who takes part follows the [code of conduct](https://github.com/altnovatrail/.github/blob/main/CODE_OF_CONDUCT.md).
