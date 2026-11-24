# .github — sources

> The facts of the outside world that the documents of `docs/` rest on and that no run of ours checks: a provider's terms and policies, a license, a page that changes in place with no version, an answer of an API or a registry that no run of ours checks, other projects' practice. Here are their records — the address, the date read and a quote in the source's language —, while [architecture.md](architecture.md) and the decision log hold the claim and a citation of its one record by its number, `sources 2.1`, not a chain. A record's heading names its topic, not a task.
>
> No record is needed for GitHub's documentation, or the code of an action or a tool, at a version or commit — a link beside the claim —, for a behaviour a test or a measurement checks — they are its evidence —, or for spec's tags and the files of NovaTrail's and MathTrail's repositories — git, at a tag or commit. The results of measurements — trial pull requests and their runs, steps run apart from the workflow, the suite of tests of the steps, durations and sizes — are in [measurements.md](measurements.md).

## 1. How to keep it

- **What is a record.** The line is whether a run of ours checks the fact and whether its source has a version, not whether it is a law or technology. A record holds terms, a policy, a license, and any fact whose source changes in place with no version and which no run of ours checks: a limit of a service, an answer of the GitHub API or of npm's registry, an open issue. A text outside the repositories, and other projects' practice, are records too.
- **What is no record.**
  - An answer that never changes — a run of a workflow, a version of a ruleset's history, the attestation of a package's version: a link where the claim stands.
  - GitHub's documentation, at a commit of [github/docs](https://github.com/github/docs), and the documentation or code of an action, a tool or a library at a version, a tag or a commit: a link where the claim stands, with no quote.
  - A behaviour a test of `tests/` or a record of [measurements.md](measurements.md) checks: the test or the record is its evidence; a sum, the Dockerfile that checks the archive against it.
  - spec's tags and the files of the other NovaTrail repositories and of MathTrail: git — a link to the repository at its tag or commit, or the submodule `spec/`.
- **A record** is a subsection "N.M" of a topic: one source — the pages of one publisher on one subject — or one reading of several sources for the sake of one decision. It holds the address, the date of the page where it has one, the date read, and the quote in the source's language, word for word. What was not read from the primary source — a copy, a pointer, a page that did not open — the record names as such.
- **A reference.** A claim of a document refers to its one record by its number: `sources 2.1`, and from another repository `sources 2.1 .github`; not to a chain of records.
- **The source was read again.** The same text: the record's date read changes. Another text: the claims and decisions that rest on it are rewritten in the same change, and the record holds the new reading alone; where a decision waits on the author, that is an open question, and both readings stand until it is closed. A record holds the current state; its history is git.
- **Numbers.** A record's number never changes and is never given again: a new record goes at the end of its topic, a new topic at the end of the file, and a record removed leaves a gap. The archives of `docs/plan/` keep citing a removed record, and the documents check does not look up their citations of records.
- **What is not here:** the results of measurements — they are in measurements.md, and a record that a trial stood beside names its measurement; the quotes that the entries of the log give themselves — they stay in the entry.
- **Where from.** The records were once the section "Sources" of `docs/architecture.md`; the archives cite its groups, and the table from a group to its records is at the end of [docs/plan/history.md](plan/history.md).

## 2. GitHub Actions

GitHub's documentation is a link to [github/docs](https://github.com/github/docs) at a commit where the claim stands, and the code of an action or of the runner's image a link at its tag or commit; a behaviour of a step that a test or a trial checks is a measurement. What stays here are the terms and the limits of the service, which change in place and which no run of ours checks.

### 2.6. GitHub's runners

Read 2026-11-24, github/docs at the commit e0b0c90 (2026-11-23):
- **the standard runners of a public repository** — `data/reusables/actions/supported-github-runners.md`: "Use of the standard {% data variables.product.prodname_dotcom %}-hosted runners is free and unlimited on public repositories", and in its table Linux arm64 — `ubuntu-24.04-arm`, `ubuntu-22.04-arm` and `ubuntu-26.04-arm` — has 4 CPU and 16 GB;
- **how long a job runs** — `content/actions/reference/limits.md`, for all GitHub-hosted runners: "Job execution time | 6 hours | Each job in a workflow can run for up to 6 hours of execution time. If a job reaches this limit, the job is terminated and fails."

### 2.8. `actions/cache`

Read 2026-11-09:
- **the license** — MIT: "The MIT License (MIT)", `LICENSE` at the tag v6.1.0, the commit 55cc8345863c7cc4c66a329aec7e433d2d1c52a9.

Read 2026-11-24:
- **the limit and the eviction** — github/docs at the commit e0b0c90 (2026-11-23), `content/actions/reference/workflows-and-actions/dependency-caching.md`, "Usage limits and eviction policy": "{% data variables.product.github %} will remove any cache entries that have not been accessed in over 7 days. There is no limit on the number of caches you can store, but the total size of all caches in a repository is limited. By default, the limit is 10 GB per repository, but this limit can be increased by enterprise owners, organization owners, or repository administrators."

### 2.11. The storage of artifacts

Read 2026-11-24, github/docs at the commit e0b0c90 (2026-11-23):
- **what is measured** — `content/billing/concepts/product-billing/github-actions.md`: "For **private repositories**, usage is measured against two parts of your plan:" — "**Compute**" and "**Storage:** Artifact and cache storage have separate allowances"; "**Cache storage:** Actions cache storage is a separate allowance of 10 GB per repository. Cache storage is not shared with artifacts"; "If your account does not have a valid payment method on file, usage is blocked once you consume the included compute usage";
- **the quota** — `data/reusables/billing/actions-included-quotas.md`: the plan Free for organizations — "Artifact storage" 500 MB;
- **the plan** — the organization `altnovatrail` is on the plan `free` (the GitHub API, `gh api orgs/altnovatrail`, `.plan.name`), and every repository of it is public. Whether the quota of artifact storage holds for a public repository the page does not say in words; what the trial saw — measurements 7.3.

## 3. GitHub: rulesets, releases and the organization

GitHub's documentation is a link to [github/docs](https://github.com/github/docs) at a commit where the claim stands, the REST API's included, which github/docs keeps in `src/rest/data/`; the code of `gh` and of the runner's image is a link at its tag or commit, and a version of a ruleset's history is the GitHub API's path where the claim stands. What stays here are the settings of the organization and its repositories as the GitHub API answers them, and the limits of the service, which change in place and which no run of ours checks.

### 3.2. Immutable releases

Read 2026-11-24:
- the GitHub API, `GET repos/altnovatrail/.github/immutable-releases`: `{"enabled":true,"enforced_by_owner":false}`, and the same for `spec`.

### 3.3. The organization's policy for actions

Read 2026-11-24:
- the GitHub API, `repos/altnovatrail/<repository>/actions/permissions`, for `.github`, `spec`, `module-kit` and `tutor`: `enabled: true`, `allowed_actions: all`, `sha_pinning_required: true`.

### 3.4. The organization's issue types

Read 2026-11-24:
- the GitHub API, `orgs/altnovatrail/issue-types`: Task, Bug and Feature, each `is_enabled: true`. The issue forms name the types as the organization calls them.

### 3.6. The rate limits of the REST API

Read 2026-11-24, github/docs at the commit e0b0c90 (2026-11-23), `content/rest/using-the-rest-api/rate-limits-for-the-rest-api.md`:
- `data/reusables/rest-api/primary-rate-limit-github-token-in-actions.md`: "The rate limit for `GITHUB_TOKEN` is 1,000 requests per hour per repository. For requests to resources that belong to a {% data variables.product.prodname_ghe_cloud %} account, the limit is 15,000 requests per hour per repository";
- the secondary rate limits, `data/reusables/rest-api/secondary-rate-limit-rest-graphql.md`: "No more than 100 concurrent requests are allowed", "No more than 900 points per minute are allowed for REST API endpoints", "No more than 90 seconds of CPU time per 60 seconds of real time is allowed", "In general, no more than 80 content-generating requests per minute and no more than 500 content-generating requests per hour are allowed", and "These secondary rate limits are subject to change without notice";
- the points: "Most REST API `GET`, `HEAD`, and `OPTIONS` requests" — 1, "Most REST API `POST`, `PATCH`, `PUT`, or `DELETE` requests" — 5, and "Some REST API endpoints have a different point cost that is not shared publicly".

## 4. Dependabot

GitHub's documentation of Dependabot is a link to github/docs at a commit, and the code of dependabot-core a link at the commit where the claim stands; Dependabot's pull requests in `spec` are links to them. No record of this topic is left.

## 5. CodeQL

GitHub's documentation of code scanning is a link to github/docs at a commit, the code of `github/codeql-action` and `github/codeql` a link at the tag the workflow pins, and what a trial saw is in measurements.md. No record of this topic is left.

## 6. Scorecard

The code and the README of `scorecard-action` and `ossf/scorecard` are links at the tags `scorecard.yml` pins and runs, and a pull request of `scorecard-webapp` a link where the claim stands. What stays here is the answer of Scorecard's API, which changes with every published result and which no run of ours checks.

### 6.3. Scorecard's API

Read 2026-11-24:
- `https://api.scorecard.dev/projects/github.com/<owner>/<repository>` answers with the date, the repository's commit and the score — the fields `date`, `repo.commit` and `score`: for `ossf/scorecard`, `2026-11-23T13:43:26Z`, 789a810, 8.8; for `altnovatrail/.github`, `2026-11-24T06:14:21Z`, the commit of `main` eaecbb0, 6.8, by `scorecard.version` v5.6.0;
- a repository with no result gets 404, as `octocat/Spoon-Knife` does; `spec`, `module-kit`, `tutor`, `app`, `canvas` and `infra` get 200.

## 7. Sigstore

The code of cosign, sigstore-go and go-tuf is a link at the tag cosign pins, and Fulcio's documentation a link at a commit. What stays here are the license of cosign and the terms of Sigstore's public instance, which no run of ours checks.

### 7.1. cosign

Read 2026-11-24:
- **the license** — Apache-2.0: "Apache License", "Version 2.0, January 2004", `LICENSE` at the tag v3.1.4, the commit 0e48502 (the tag object 8843105).

### 7.3. Calls of cosign at once

Read 2026-11-24:
- **the limits of Sigstore's public instance** — none in numbers in what was read: [Sigstore FAQ](https://docs.sigstore.dev/about/faq/) has no word of limits, and [sigstore/community, ROADMAP.md](https://github.com/sigstore/community/blob/949654a/ROADMAP.md) names them only as work to do: "Complete performance analysis to ensure appropriate rate limits and incremental cost vectors are known". cosign 3.1.4 prints on `sign-blob` that the service "is provided pursuant to the Hosted Project Tools Terms of Use" (the log of the trial #127, measurements 5.12). [LF Projects, Hosted Project Tools Terms of Use](https://lfprojects.org/policies/hosted-project-tools-terms-of-use/), "Version 1.0, last updated: February 21, 2023": "Such access and use shall not exceed a reasonable degree of use appropriate to the nature of the particular Hosted Project Tool", and "The Provider may also in its discretion (a) suspend access to the Hosted Project Tool if the Provider determines that Your use thereof poses a security or other risk".

## 8. npm

npm's documentation and the code of `npm/cli` and npm-registry-fetch are links at the tag or commit where the claim stands, the npm that Node carries a link to Node at its tag, and an attestation of a package's version a link to the registry's answer for it. What stays here are npm's policies, the answers of npm's registry and of the GitHub API, and npm's open bugs, which change in place and which no run of ours checks.

### 8.1. npm's policies

Read 2026-11-24, npm/documentation at the last commits of its files:
- **unpublishing** — `content/policies/unpublish.mdx`, the commit c62df53 of 2023-10-23:
  - "So if you've ever published a package called "bob" at version 1.1.0, no other package can ever be published with that name at that version. This is true even if that package is unpublished";
  - "Once `package@version` has been used, you can never use it again. You must publish a new version even if you unpublished the old one";
  - "If you entirely unpublish all versions of a package, you may not publish any new versions of that package until 24 hours have passed";
- **a trusted publisher's setting** — `content/packages-and-modules/securing-your-code/trusted-publishers.mdx`, the commit 5152d27 of 2026-10-06: "Configurations created after Sep 03, 2026 are automatically set to allow `npm stage publish`, and you can choose whether to also permit direct publishing with `npm publish`", and "A newly created trusted publisher configuration must complete its first successful publish within 2 days".

### 8.3. npm's registry

Read 2026-11-24:
- **the registry's cache** — `https://registry.npmjs.org/semver` answers `cf-cache-status: HIT`, `cache-control: public, max-age=300` and `age` of a few minutes, even to a request with `Cache-Control: no-cache`. With `?write=true` the answer is `cf-cache-status: DYNAMIC`;
- **`time` remembers unpublished version numbers** — `https://registry.npmjs.org/<package>?write=true`. In `time`, but not in `versions`, there are:
  - for `ua-parser-js` — 0.7.29, 0.8.0 and 1.0.0;
  - for `coa` — 2.0.3, 2.0.4, 2.1.1, 2.1.3, 3.0.1 and 3.1.3;
  - for `rc` — 1.2.9, 1.3.9 and 2.3.9;
- **a package unpublished whole** — the same request, read whole: `curl https://registry.npmjs.org/<name>?write=true | jq '{keys: keys, versions: (.versions // {} | keys), time: .time}'`:
  - `asdasd`, `aaaaaaa` and `test-unpublish` answer 200; the document's keys are `_id`, `_rev`, `name` and `time`, with no `versions`;
  - `time` has `created`, `modified`, `unpublished` and every number the package held: `1.0.0`; `1.0.0`, `1.0.1`, `2.0.0`, `3.0.0`, `4.0.0` and `4.0.1`; `0.0.0` and `0.0.1`. For `asdasd`, `time.unpublished` is `{"time":"2016-09-28T19:51:40.289Z","versions":["1.0.0"]}`;
  - `time.unpublished.versions` has the numbers the package held last: `["1.0.0"]`, `["1.0.0","1.0.1","3.0.0","4.0.0"]` and `["0.0.0"]`. The numbers unpublished earlier — `2.0.0` and `4.0.1` for `aaaaaaa`, `0.0.1` for `test-unpublish` — are only in `time`;
  - a name that never existed, `dfgdfg`, gets 404 `{"error":"Not found"}`;
  - a package published again has no `time.unpublished`, and `time` keeps the earlier numbers: for `pokemon-assets` — 0.6.0 and 0.7.0, which are not in `versions`.

### 8.4. The open bugs of `npm/cli`

Read 2026-11-24, the GitHub API:
- **npm's open bugs** — [npm/cli#9889](https://github.com/npm/cli/issues/9889), "[BUG] 409 "Cannot publish over previously staged version" for a package that never used staged publishing", open, updated 2026-11-19: "The first publish that triggered this reported success", while "The version does not exist as a published version"; [npm/cli#9969](https://github.com/npm/cli/issues/9969), "[BUG] OIDC trusted publishing fails with "package not found" for GitHub repos that use immutable OIDC subject claims", open, updated 2026-10-28;
- **the immutable OIDC subject** — `repos/altnovatrail/<repository>/actions/oidc/customization/sub`: `spec` and `canvas` have `"use_immutable_subject":true`, the prefixes `repo:altnovatrail@344507087/spec@1424771727` and `repo:altnovatrail@344507087/canvas@1425820257`.

### 8.5. npm's registry: the delay of the check before a version is served

Read 2026-11-24: [GitHub Changelog, npm publish-time malware scanning, 2026-07-28](https://github.blog/changelog/2026-07-28-npm-publish-time-malware-scanning-and-dual-use-metadata/): the check "introduces a short delay between publishing and availability, typically around five minutes. It may take longer, up to 15 minutes or more, at peak times or depending on a package's content and size. These times reflect current typical behavior and may change as scanning evolves; they aren't a service guarantee."

## 9. Node, browsers and the TypeScript tests

The documentation and code of Node, Playwright, Vitest, istanbul, OSV-Scanner, Docker and BuildKit are links at the tag or commit where the claim stands, the files of `app` and `canvas` git at a commit, the configuration of an image a link to its blob at its digest, and a behaviour a trial saw is in measurements.md. What stays here is the license and the release of OSV-Scanner, which no run of ours checks.

### 9.4. OSV-Scanner

Read 2026-11-24, the GitHub API:
- **the release** — `repos/google/osv-scanner/releases/tags/v2.7.0`: v2.7.0, 2026-10-12, holds `osv-scanner_SHA256SUMS`;
- **the license** — `repos/google/osv-scanner/license`: Apache-2.0.

## 10. Go, go-licenses and Codecov

The documentation and code of Go, golangci-lint and go-licenses are links at the tag or commit where the claim stands, and a behaviour a trial saw is in measurements.md; the sum of the Codecov CLI is held by the steps that check it. What stays here are the Codecov app of the organization, the license of the CLI, the key its sums are signed with, and Codecov's pages, which change in place and which no run of ours checks.

### 10.3. Codecov

Read 2026-11-24:
- **the Codecov app** — the GitHub API, `gh api orgs/altnovatrail/installations`: `codecov`, `repository_selection: all`;
- **the Codecov CLI** — the license Apache-2.0 (the GitHub API, `repos/codecov/codecov-cli/license`); v11.3.2 came out 2026-10-28;
  - gpg accepted the signature `codecov.SHA256SUM.sig` of `https://cli.codecov.io/v11.3.2/linux/codecov.SHA256SUM`, with the key `https://keybase.io/codecovsecops/pgp_keys.asc`: "Good signature from "Codecov Uploader (Codecov Uploader Verification Key) <security@codecov.io>"", "Primary key fingerprint: 2703 4E7F DB85 0E0B BC2C 62FF 806B B28A ED77 9869"; the file holds `8e1bfb71661378530f6ea21e82b414095899e565cbb4cf555c613064be17b973  codecov`;
  - the same fingerprint is named by the page [Codecov Uploader](https://docs.codecov.com/docs/codecov-uploader), updated 2026-06-07: "Key Fingerprint: `2703 4E7F DB85 0E0B BC2C 62FF 806B B28A ED77 9869`". It says to take the key from `https://keybase.io/codecovsecops/pgp_keys.asc`;
- **several uploads per commit** — [Codecov, codecov.yml reference](https://docs.codecov.com/docs/codecovyml-reference), updated 2026-07-23. `codecov.notify.wait_for_ci` has "Should Codecov wait for all CI statuses to complete before sending ours", `true` by default. `codecov.notify.after_n_builds` has "How many uploaded reports Codecov should wait to receive before sending statuses", `1` by default.

## 11. The tools of the checks

The documentation and code of gitleaks, just and git are links at the tag where the claim stands, a behaviour a trial saw is in measurements.md, and the sum of an archive is held by the step that checks it. What stays here are the licenses of the tools and the files of their releases, which no run of ours checks.

### 11.1. gitleaks

Read 2026-11-24, the GitHub API:
- **the release** — `repos/gitleaks/gitleaks/releases/tags/v8.30.1`: v8.30.1, 2026-03-21, the files are archives for the platforms and `gitleaks_8.30.1_checksums.txt`, with no signature; `repos/gitleaks/gitleaks/attestations/sha256:<sum of the linux_x64 archive>` answers 404;
- **the license** — `repos/gitleaks/gitleaks/license`: MIT.

### 11.2. ShellCheck

Read 2026-11-24, the GitHub API:
- **the release** — `repos/koalaman/shellcheck/releases/tags/v0.11.0`: v0.11.0, 2025-08-04, the files are archives for the platforms and a zip, with no file of sums;
- **the license** — `repos/koalaman/shellcheck/license`: GPL-3.0.

### 11.3. yq and bats-core

Read 2026-11-24:
- **yq** — the license MIT: "The MIT License (MIT)", `LICENSE` at the tag v4.54.1, and the GitHub API, `repos/mikefarah/yq/license`;
- **bats-core** — the GitHub API: `repos/bats-core/bats-core/releases/tags/v1.14.0` — v1.14.0, 2026-07-21, with no files; `repos/bats-core/bats-core/license` — MIT.

## 12. `spec`: tags, recipes and scripts

spec's tags are git: a claim links to spec's file at its tag, or names the submodule `spec/`, and the topic holds no record.

## 13. Other repositories of NovaTrail

The files of the other repositories of NovaTrail are git: a claim links to the repository at its commit, and the topic holds no record.

## 14. MathTrail and patterns outside NovaTrail

MathTrail's files are git: a claim links to the repository at its commit. What stays here is an answer of the API with no version and other projects' practice.

### 14.1. canvas-api: the ruleset of `main`

Read 2026-11-24: canvas-api has the rule `code_scanning` with the tool CodeQL and the thresholds `errors` and `high_or_higher` (the GitHub API, `repos/mathtrail/canvas-api/rulesets/25036747`).

### 14.2. `nodenv/.github`

Read 2026-10-19:
- **a repository named `.github`** — the documentation does not name it as a place of shared workflows. That is how [nodenv/.github](https://github.com/nodenv/.github) is built (commit 01e040a): `nodenv/nodenv` calls `uses: nodenv/.github/.github/workflows/release.yml@bd27009d5f178c0a88d42f7b07e6a3c7623ed768 # v7.0.8`, and the README explains: "GitHub doesn't allow them to live in any other directory, so the reusable workflows are all in the same location as the workflows _for this repository. To distinguish them, the workflows for this repository are prefixed with `.github_`". That Dependabot bumps such a reference was shown by a maintainer of dependabot-core in [issue #12489](https://github.com/dependabot/dependabot-core/issues/12489), 2025-12-29: "issue is not reproducible. Attaching screenshots below for a bump PR to version 7.0.5". `spec` confirmed the call; whether Dependabot bumps the reference, `v0.1.1` will show.
