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

### 8.1. npm's documentation

Read 2026-10-20:
- **integrity in npm** — npm's documentation, [`npm cache`](https://github.com/npm/cli/blob/ae98c62586b6fea44114f72e249e246a2981de70/docs/lib/content/commands/npm-cache.md) on the branch `latest` of npm/cli, the commit ae98c62: "All data that passes through the cache is fully verified for integrity on both insertion and extraction". Which hash npm checks against without a lock file, this page does not say, and the repository has no hash.

Read 2026-10-21:
- **npm** — Node 24.21.0 comes with npm 11.19.0: [nodejs.org/dist/index.json](https://nodejs.org/dist/index.json), the entry `v24.21.0` — `"npm":"11.19.0"`. npm's documentation site shows v11 in the edition 11.21.0. The definition of `ignore-scripts` below is the same in npm's sources at the tag v11.19.0, the commit bfacd33: `workspaces/config/lib/definitions/definitions.js`;
- **`npm ci`** — [npm Docs, npm ci](https://docs.npmjs.com/cli/v11/commands/npm-ci): "The project **must** have an existing `package-lock.json` or `npm-shrinkwrap.json`", "If dependencies in the package lock do not match those in `package.json`, `npm ci` will exit with an error, instead of updating the package lock" and "It will never write to `package.json` or any of the package-locks: installs are essentially frozen";
- **`ignore-scripts`** — the same page, section Configuration: "If true, npm does not run scripts specified in package.json files. Note that commands explicitly intended to run a particular script, such as `npm start`, `npm stop`, `npm restart`, `npm test`, and `npm run` will still run their intended script if `ignore-scripts` is set, but they will *not* run any pre- or post-scripts". An environment variable sets the same — [npm Docs, config](https://docs.npmjs.com/cli/v11/using-npm/config): "Any environment variables that start with `npm_config_` will be interpreted as a configuration parameter";
- **`npm audit`** — [npm Docs, npm audit](https://docs.npmjs.com/cli/v11/commands/npm-audit): "The audit command submits a description of the dependencies configured in your project to your default registry and asks for a report of known vulnerabilities" — it needs the network. Of `--audit-level`: "This option does not filter the report output, it simply changes the command's failure threshold".

Read 2026-10-22:
- **trusted publishing** — npm/documentation at the commit 7e98ab4, `content/packages-and-modules/securing-your-code/trusted-publishers.mdx`:
  - "Trusted publishing requires npm CLI version 11.5.1 or later and Node version 22.14.0 or higher";
  - of a reusable workflow: "validation checks the calling workflow's name instead of the workflow that actually contains the publish command", and "The `id-token: write` permission must also be given to both parent and child workflows";
  - "Configurations created after Sep 03, 2026 are automatically set to allow `npm stage publish`, and you can choose whether to also permit direct publishing with `npm publish`", and "A newly created trusted publisher configuration must complete its first successful publish within 2 days";
  - provenance: "npm automatically generates and publishes provenance attestations … you don't need to add the `--provenance` flag", and "your package's `repository.url` field in `package.json` must exactly match your GitHub repository".

Read 2026-11-01:
- **trusted publishing and a reusable workflow** — the page [npm Docs, Trusted publishing](https://docs.npmjs.com/trusted-publishers) says the same as npm/documentation at 7e98ab4: "validation checks the calling workflow's name instead of the workflow that actually contains the publish command".

Read 2026-11-01:
- **npm/documentation** — the commit c62df53, 2023-10-23, the last commit of the file `content/policies/unpublish.mdx`:
  - "So if you've ever published a package called "bob" at version 1.1.0, no other package can ever be published with that name at that version. This is true even if that package is unpublished";
  - "Once `package@version` has been used, you can never use it again. You must publish a new version even if you unpublished the old one";
  - "If you entirely unpublish all versions of a package, you may not publish any new versions of that package until 24 hours have passed".

Read 2026-11-02:
- **trusted publishing** — `content/packages-and-modules/securing-your-code/trusted-publishers.mdx` of npm/documentation, the last commit 5152d27 of 2026-10-06: "validation checks the calling workflow's name instead of the workflow that actually contains the publish command", and "The `id-token: write` permission must also be given to both parent and child workflows". Provenance — "when all of these conditions are met": trusted publishing, a public repository, a public package. Of a reusable workflow of another repository the document says nothing.

### 8.2. `npm/cli`

Read 2026-10-22:
- **`npm trust`** — npm/cli v11.19.0, `docs/lib/content/commands/npm-trust.md`: "Package must exist: The package you're configuring must already exist on the npm registry". `lib/trust-cmd.js` allows publishing by the flag `--allow-publish`, and staged publishing by `--allow-stage-publish`;
- **npm CLI 11.19.1**, the one that comes with Node 24.22.1. It does not differ from 11.19.0 in `lib/utils/oidc.js`, `lib/commands/publish.js`, libnpmpublish and npm-registry-fetch (`gh api repos/npm/cli/compare/v11.19.0...v11.19.1`):
  - `oidc.js` without `ACTIONS_ID_TOKEN_REQUEST_URL` and `_TOKEN` skips the exchange — "Skipped because incorrect permissions for id-token within GitHub workflow", at the level silly. A refusal of the exchange and its success it writes at the level verbose: "Failed token exchange request with body message: …", "Successfully retrieved and set token";
  - `publish.js` calls the exchange before the branch `--dry-run` (line 147). The package's scripts run only when a folder is published. Since npm 11.0.0 it does not publish a version below the highest one without a tag: "Cannot implicitly apply the "latest" tag because previously published version … is higher than the new version";
  - npm's license is Artistic-2.0 (npm's `package.json`), and `spec/tools/licenses/config.mjs` v0.2.21 does not have it.

Read 2026-11-01:
- **npm** — `lib/commands/view.js` of npm 11.19.0 from the devcontainer, lines 151–157: on `pckmnt.time?.unpublished` the command throws an error "Unpublished on ${u.time}" with `statusCode: 404` and `code: 'E404'`. Between v11.19.0 and v11.19.1, 33 files changed. Of the files of `view` and `publish`, only `test/lib/commands/publish.js` is among them (`gh api repos/npm/cli/compare/v11.19.0...v11.19.1`).

### 8.3. npm's registry

Read 2026-10-22:
- **the registry's cache** — 2026-10-22. `https://registry.npmjs.org/semver` answers `cf-cache-status: HIT`, `cache-control: public, max-age=300` and `age` over a hundred seconds, even to a request with `Cache-Control: no-cache`. With `?write=true` the answer is `cf-cache-status: DYNAMIC`. npm-registry-fetch, which comes with npm 11.19.1, does not cache such a GET: "do not cache, because this GET is fetching a rev that will be used for a subsequent PUT or DELETE" (`lib/index.js`).

Read 2026-11-01:
- **the publication of `spec` to npm** — `https://registry.npmjs.org/@altnovatrail%2fspec`: `latest` is 0.4.1, which came out 2026-10-29T20:31:01Z, with `dist.attestations`, provenance `https://slsa.dev/provenance/v1`; 0.4.0, which the author of `spec` published by hand, has no provenance. The npm steps of `spec`'s `release.yml` are the steps of the shared `release.yml` v0.1.10 with the differences that the plan of `spec` names.

Read 2026-11-01:
- **`time` remembers unpublished version numbers** — `https://registry.npmjs.org/<package>?write=true`. In `time`, but not in `versions`, there are:
  - for `ua-parser-js` — 0.7.29, 0.8.0 and 1.0.0;
  - for `coa` — 2.0.3, 2.0.4, 2.1.1, 2.1.3, 3.0.1 and 3.1.3;
  - for `rc` — 1.2.9, 1.3.9 and 2.3.9.

  For `@altnovatrail/spec` at 18:59 UTC the keys of `time` are its eight versions, from `0.0.0-stage` to 0.5.4, and `created` with `modified`;
- **a package unpublished whole** — the same request.
  - `asdasd`, `aaaaaaa` and `test-unpublish` answer 200, and the answer has only `_id`, `name`, `_rev` and `time`.
  - For `asdasd`, `time` has `created`, `modified`, `1.0.0` and `unpublished`: `{"time":"2016-09-28T19:51:40.289Z","versions":["1.0.0"]}`.
  - `time` also keeps the numbers that are not in `unpublished.versions`: for `aaaaaaa` — 2.0.0 and 4.0.1.
  - A name that never existed, `dfgdfg`, gets 404 `{"error":"Not found"}`.
  - A package published again has no `time.unpublished`, and `time` keeps the earlier numbers: for `pokemon-assets` — 0.6.0 and 0.7.0, which are not in `versions`.

Read 2026-11-02:
- **the documents of packages unpublished whole**, by the step "Check the npm package" of [spec v0.6.3](https://github.com/altnovatrail/spec/blob/v0.6.3/.github/workflows/release.yml) — `curl https://registry.npmjs.org/<name>?write=true`, 2026-11-02:
  - for `asdasd`, `aaaaaaa` and `test-unpublish`, `versions` is empty, and `time` has `created`, `modified`, `unpublished` and every number the package held: `1.0.0`; `2.0.0`, `1.0.0`, `1.0.1`, `3.0.0`, `4.0.0` and `4.0.1`; `0.0.1` and `0.0.0`;
  - `time.unpublished.versions` has the numbers the package held last: `["1.0.0"]`, `["1.0.0","1.0.1","3.0.0","4.0.0"]` and `["0.0.0"]`. The numbers unpublished earlier — `2.0.0` and `4.0.1` for `aaaaaaa`, `0.0.1` for `test-unpublish` — are only in `time`;
  - a jq filter that takes from `time` only `created`, `modified` and `unpublished` loses the keys of the numbers, as a first reading of this day did.

Read 2026-11-02:
- **the documents of packages unpublished whole** — the same as above, in the first reading, read whole: `curl https://registry.npmjs.org/<name>?write=true | jq '{keys: keys, versions: (.versions // {} | keys), time: .time}'`. The document's keys are `_id`, `_rev`, `name` and `time`, and `time` has every number the package held. The earlier step `(.time // {}) | has($v)` did find such a number.

### 8.4. The open bugs of `npm/cli`

Read 2026-10-22:
- **npm's open bugs** — npm/cli#9889: `npm publish` exits with 0 while the version is only staged. npm/cli#9969: OIDC for repositories with GitHub's immutable subject.

Read 2026-11-01:
- **the immutable OIDC subject** — the GitHub API, `repos/altnovatrail/<repository>/actions/oidc/customization/sub`: `spec` and `canvas` have `"use_immutable_subject":true`, the prefixes `repo:altnovatrail@344507087/spec@1424771727` and `repo:altnovatrail@344507087/canvas@1425820257`. npm/cli#9969 — "OIDC trusted publishing fails with "package not found" for GitHub repos that use immutable OIDC subject claims" — is open, updated 2026-10-28; npm/cli#9889 is open too (the GitHub API).

Read 2026-11-02:
- **npm's open bugs** — [npm/cli#9969](https://github.com/npm/cli/issues/9969) — open, updated 2026-10-28; [npm/cli#9889](https://github.com/npm/cli/issues/9889) — open, updated 2026-10-22.

### 8.5. npm's registry: the delay of the check before a version is served

Read 2026-11-24: [GitHub Changelog, npm publish-time malware scanning, 2026-07-28](https://github.blog/changelog/2026-07-28-npm-publish-time-malware-scanning-and-dual-use-metadata/): the check "introduces a short delay between publishing and availability, typically around five minutes. It may take longer, up to 15 minutes or more, at peak times or depending on a package's content and size. These times reflect current typical behavior and may change as scanning evolves; they aren't a service guarantee."

## 9. Node, browsers and the TypeScript tests

### 9.1. Node

Read 2026-10-22:
- **Node** — `https://nodejs.org/dist/index.json`: v24.22.1, 2026-10-20, npm 11.19.1, `security: true`. In the `SHASUMS256.txt` of v24.22.1 — `6c172a9ab6718f7b801fb5a7bd486af2ee5e32758086a04b84fcce2aa77095e6  node-v24.22.1-linux-x64.tar.xz`, and the downloaded archive matched it.

Read 2026-11-13, the documentation of Node v24.21.0, the version of the `toolchain` stage:
- **`node:wasi`** — [`api/wasi.md`](https://nodejs.org/docs/v24.21.0/api/wasi.md): "Stability: 1 - Experimental"; the example passes `version: 'preview1'`, `args: argv`, `env` and `preopens`, and runs `wasi.start(instance)`. Of `new WASI([options])`:
  - `args` — "An array of strings that the WebAssembly application will see as command-line arguments. The first argument is the virtual path to the WASI command itself";
  - `env` — "An object similar to `process.env` that the WebAssembly application will see as its environment";
  - `preopens` — "The string keys of `preopens` are treated as directories within the file system. The corresponding values in `preopens` are the real paths to those directories on the host machine";
  - `returnOnExit` — "By default, when WASI applications call `__wasi_proc_exit()`  `wasi.start()` will return with the exit code specified rather than terminating the process. Setting this option to `false` will cause the Node.js process to exit with the specified exit code instead. **Default:** `true`", and in the history of changes: "v20.1.0 … default value of returnOnExit changed to true";
  - `version` — "Currently the only supported versions are `unstable` and `preview1`. This option is mandatory";
  - `wasi.start(instance)` — "Attempt to begin execution of `instance` as a WASI command by invoking its `_start()` export", and it "requires that `instance` exports a [`WebAssembly.Memory`][] named `memory`";
  - and under Security: "The current Node.js threat model does not provide secure sandboxing as is present in some WASI runtimes";
- **`--disable-warning`** — [`api/cli.md`](https://nodejs.org/docs/v24.21.0/api/cli.md), `--disable-warning=code-or-type`, added in v21.3.0 and v20.11.0, "now stable" from v24.20.0: "Disable specific process warnings by `code` or `type`" and "The Node.js core warning types are: `DeprecationWarning` and `ExperimentalWarning`". The trial — measurements 2.6.

### 9.2. Playwright

Read 2026-10-21:
- **Playwright in Docker** — [`docs/src/docker.md`](https://github.com/microsoft/playwright/blob/66070a1/docs/src/docker.md) at commit 66070a1, section Recommended Docker Configuration: "Using `--init` Docker flag is recommended to avoid special treatment for processes with PID=1. This is a common reason for zombie processes" and "Using `--ipc=host` is recommended when using Chromium. Without it, Chromium can run out of memory and crash". Playwright — v1.64.1, Apache-2.0 (the GitHub API);
  - [`docs/src/browsers.md`](https://github.com/microsoft/playwright/blob/66070a1/docs/src/browsers.md), ibid.: "Each version of Playwright needs specific versions of browser binaries to operate". The browsers lie in "`~/.cache/ms-playwright` on Linux", and `PLAYWRIGHT_BROWSERS_PATH` sets another path;
  - the Playwright image sets `ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright` and installs the browsers there ([`utils/docker/Dockerfile.noble`](https://github.com/microsoft/playwright/blob/66070a1/utils/docker/Dockerfile.noble), ibid.);
  - the browsers' system packages are installed by `apt-get install`, and, when not root, through sudo: "Switching to root user to install dependencies..." ([`dependencies.ts`](https://github.com/microsoft/playwright/blob/66070a1/packages/playwright-core/src/server/registry/dependencies.ts), ibid.);
  - neither the documentation nor the downloader names sums of the browser downloads: no check of a sum was found in `browserFetcher.ts` and `registry/index.ts`. This is the result of a search, not the documentation's words;
- **the Playwright image** — `mcr.microsoft.com/playwright:v1.64.1-noble`, the index `sha256:7852dc5a7d72f5fe458a597d690f6c42fbc8e9e26ddfa95f8e6ef552558d9bbf`; amd64 — `sha256:bdfda2a8fdf48707c5e50a49bd3e06d8d0c759153dc8ee057d8a81c3450bb3e9`, 986,271,382 bytes compressed, in seven layers (the MCR registry). `utils/docker/Dockerfile.noble` at the tag v1.64.1 installs into `/ms-playwright` chromium with the headless shell and ffmpeg, firefox and webkit, and the system libraries by `install-deps`, outside that folder. [`docs/src/docker.md`](https://github.com/microsoft/playwright/blob/v1.64.1/docs/src/docker.md) at the tag v1.64.1: "This image includes the Playwright browsers and browser system dependencies. The Playwright package/dependency is not included in the image" and "If the Playwright version in your Docker image does not match the version in your project/tests, Playwright will be unable to locate browser executables";
- **Chromium's system libraries** — [`nativeDeps.ts`](https://github.com/microsoft/playwright/blob/v1.64.1/packages/playwright-core/src/server/registry/nativeDeps.ts) at the tag v1.64.1, the entry `ubuntu24.04-x64`, `chromium`: 21 packages, from `libasound2t64` to `libxrandr2`. `install-deps` installs them by `apt-get install -y --no-install-recommends`, with no versions.

Read 2026-10-21:
- **Chrome for Testing** — Playwright's [`docs/src/release-notes-js.md`](https://github.com/microsoft/playwright/blob/v1.64.1/docs/src/release-notes-js.md) at the tag v1.64.1, commit cfe490d, section Version 1.57: "Playwright now runs on Chrome for Testing builds rather than Chromium. Headed mode uses `chrome`; headless mode uses `chrome-headless-shell`". In [`registry/index.ts`](https://github.com/microsoft/playwright/blob/v1.64.1/packages/playwright-core/src/server/registry/index.ts) ibid., `chromium` and `chromium-headless-shell` for `ubuntu24.04-x64` have `cftUrl(…)`, the path `builds/cft/${browserVersion}/…` on `https://cdn.playwright.dev`. Firefox, WebKit and FFmpeg have paths of their own — `builds/firefox/…`, `builds/webkit/…` and `builds/ffmpeg/…`;
- **the folder in the image** — the decision log and `docs/architecture.md` of `canvas` at 88492c4. In the layer of the v1.64.1 image with `playwright-core install chromium` lie `chromium-1248` with `WidevineCdm/LICENSE`, `chromium_headless_shell-1248` and `ffmpeg-1013`. The `ABOUT` of Chrome Headless Shell: "Google Chrome … Copyright 2026 Google LLC. All rights reserved … See the Terms of Service at chrome://terms". The binary itself calls itself "Google Chrome for Testing 156.0.8078.4", and the folder takes 273 MB.

### 9.3. Vitest and istanbul

Read 2026-10-21:
- **Vitest in the browser** — [Vitest, Browser Mode](https://vitest.dev/guide/browser): "Vitest always requires a provider to be defined. You can chose either `preview`, `playwright` or `webdriverio`" and "to run tests in CI you need to install either `playwright` or `webdriverio`";
- **`CI`** — Vitest at commit c8558f1: [`browser.headless`](https://github.com/vitest-dev/vitest/blob/c8558f1/docs/config/browser/headless.md) — "**Default:** `process.env.CI`" and "If you are running Vitest in CI, it will be enabled by default"; [`allowOnly`](https://github.com/vitest-dev/vitest/blob/c8558f1/docs/config/allowonly.md) — "**Default:** `!process.env.CI`" and "By default, Vitest does not permit tests marked with the `only` flag in Continuous Integration (CI) environments". That `CI` is set on the runner: [github/docs](https://github.com/github/docs/blob/e0b0c90/content/actions/reference/workflows-and-actions/variables.md).

Read 2026-11-01:
- **Vitest** — vitest-dev/vitest on `main` 2debb4e, the latest release v5.0.5:
  - `docs/guide/coverage.md`: "By default Vitest will show only files that were imported during test run. To include uncovered files in the report, you'll need to configure `coverage.include` with a pattern that will pick your source files";
  - `docs/config/coverage.md`: `coverage.reportsDirectory` has "Default: `'./coverage'`", and "Vitest will delete this directory before running tests if `coverage.clean` is enabled (default value)";
  - the file's name — istanbuljs/istanbuljs on `main` 28ffdbc, `packages/istanbul-reports`: `lcovonly` writes `opts.file || 'lcov.info'`, and `lcov` the same `lcov.info` and HTML in `lcov-report`.

Read 2026-11-16:
- **the V8 coverage** — vitest-dev/vitest at the tag v5.1.0, commit 7a38449, `docs/guide/coverage.md`, V8 Provider: "This provider requires Javascript runtime that's implemented on top of V8 engine, such as NodeJS, Deno or any Chromium based browsers such as Google Chrome";
- **the engines at the callers** — `ci-test` of `app`, `main` 9e55f30, runs `vitest run --coverage --project node --project '*(chromium)'`, then `vitest run --project '*(webkit)' --project '*(firefox)'`, "without it: Vitest's v8 coverage works in Chromium alone", citing a decision and a record of sources of its own; `ci-test` of `canvas`, `main` 9c75901, the same with `'* chromium'`, `'* webkit'` and `'* firefox'`. `skill-map`, `main` of 2026-11-16, runs `vitest run --coverage` alone.

### 9.4. OSV-Scanner

Read 2026-10-21:
- **OSV-Scanner** — v2.7.0, 2026-10-12 (the GitHub API, `repos/google/osv-scanner/releases/latest`), Apache-2.0, the release holds `osv-scanner_SHA256SUMS`. [Offline Mode](https://google.github.io/osv-scanner/usage/offline-mode/): "Offline scanning checks your project against a local database instead of calling the OSV.dev API" and "When a local database is not present, you will get an error message".

### 9.5. Docker: the build cache

Read 2026-10-21:
- **the build cache** — [Docker Docs, GitHub Actions cache](https://github.com/docker/docs/blob/773efbb/content/manuals/build/cache/backends/gha.md) at commit 773efbb: "This cache storage backend works with the default `docker` driver only when the containerd image store is enabled" and "If you invoke the `docker buildx` command manually from an inline step, then the variables must be manually exposed. Consider using the `crazy-max/ghaction-github-runtime`, GitHub Action as a helper for exposing the variables". Docker and Buildx on the runner — [runner-images](https://github.com/actions/runner-images/blob/06f4a91/images/ubuntu/Ubuntu2404-Readme.md).

### 9.6. Ubuntu Snapshot Service

Read 2026-10-21:
- **the Ubuntu archive at a date** — [Ubuntu Snapshot Service](https://snapshot.ubuntu.com/): "The Ubuntu snapshot service makes it possible to see and use the Ubuntu archive as it was at any specified date and time", "Snapshots of the Ubuntu archive are available for any date and time after 1 March 2023", "We intend to ensure snapshots are available for dates up to at least 2 years in the past" and "The apt included in Ubuntu 24.04 and later automatically detects when snapshots are supported for a repository". An example from there — `apt install hello --update --snapshot 20240301T030400Z`. The Playwright image creates a user of its own, `pwuser` (`adduser pwuser` in `Dockerfile.noble` v1.64.1), while the `devcontainer` stage of spec's repository template runs as `vscode` (`USER vscode`).

### 9.7. Docker: the Dockerfile and the base image of the template

Read 2026-11-16:
- **the Dockerfile** — the Dockerfile reference, [moby/buildkit](https://github.com/moby/buildkit/blob/38b0e2ab2e9bc5fd3f622759ac92ad4b649f3bf4/frontend/dockerfile/docs/reference.md) at commit 38b0e2a, `frontend/dockerfile/docs/reference.md`, the source of Docker Docs' page: "The instruction is not case-sensitive"; "Comment lines are removed before the Dockerfile instructions are executed", with the example `RUN echo hello \` over `# comment`; "If not specified, the default escape character is `\`" — "The escape character is used both to escape characters in a line, and to escape a newline. This allows a Dockerfile instruction to span multiple lines"; `FROM [--platform=<platform>] <image> [AS <name>]` — "The name can be used in subsequent `FROM <name>`"; "An `ARG` declared before a `FROM` is outside of a build stage, so it can't be used in any instruction after a `FROM`. To use the default value of an `ARG` declared before the first `FROM` use an `ARG` instruction without a value inside of a build stage"; "A stage inherits any environment variables that were set using `ENV` by its parent stage or any ancestor"; and "The `ENV` instruction also allows an alternative syntax `ENV <key> <value>`, omitting the `=`".
- **the parser** — the same commit, `frontend/dockerfile/parser/parser.go`: the line continuation is ``regexp.MustCompile(`([^\` + s + `])\` + s + `[ \t]*$|^\` + s + `[ \t]*$`)`` — the escape character, then blanks, at the end of a line; `trimNewline` is `bytes.TrimRight(src, "\r\n")`; inside a continued instruction a comment line is skipped (`if isComment(scanner.Bytes())`), and so is an empty one, with "[WARNING]: Empty continuation lines will become errors in a future release."; `isComment` — the line, its leading blanks dropped, starts with `#`. `directives.go`: a directive is `^([a-zA-Z][a-zA-Z0-9]*)\s*=\s*(.+?)\s*$` after the `#`, and `keyEscape = "escape"`.
- **the base image** — the configuration of `mcr.microsoft.com/devcontainers/base:3.0.13-noble` at the digest `sha256:48be4ade…7eae` that the template's Dockerfile pins, for linux/amd64 the manifest `sha256:957c4e15…b910` and its configuration `sha256:be453845…7b15`, by the registry's API without a token: `"Env":["PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin","LANG=C.UTF-8"]`.

## 10. Go, go-licenses and Codecov

### 10.1. Go

Read 2026-11-01:
- **Go** — [Go 1.22 Release Notes](https://go.dev/doc/go1.22): "`go test -cover` now prints coverage summaries for covered packages that do not have their own test files" — "functions in the package are treated as uncovered". And also: "if a package contains no executable code at all, we can't report a meaningful coverage percentage; for such packages the `go` tool will continue to report that there are no test files". The trial — measurements 4.1.

Read 2026-11-13, Go 1.27.3 of the devcontainer, in its `GOROOT`; the four files named below are byte for byte the same at the tag `go1.27.4` of golang/go, the Go of the `toolchain` stage, and so is the line of `AppendPWD`:
- **the executors of wasm** — `lib/wasm/go_wasip1_wasm_exec` chooses by `GOWASIRUNTIME` among `wasmedge`, `wasmer`, `wazero` and `wasmtime`, the default, and any other value ends with "Unknown Go WASI runtime specified"; wasmtime runs with `--dir=/ --env PWD="$PWD" --env PATH="$PATH" -W max-wasm-stack=8388608`, and wazero with `-mount /:/ -env-inherit`. `lib/wasm/go_js_wasm_exec` ends with `exec node --stack-size=8192 "$DIR/wasm_exec_node.js" "$@"`;
- **`go test -exec`** — `go help testflag`: "-exec xprog — Run the test binary using xprog. The behavior is the same as in 'go run'", and `go help run`: "If the -exec flag is given, 'go run' invokes the binary using xprog: 'xprog a.out arguments...'". In the source, `src/cmd/go/internal/test/testflag.go` reads the flag as `base.StringsFlag`, a command split into words, and `src/cmd/go/internal/test/test.go` runs the test with `cmd.Dir = a.Package.Dir` and `env = base.AppendPWD(env, cmd.Dir)`: the folder of the package, and `PWD` set to it. The trial — measurements 2.6.

Read 2026-11-16, Go 1.27.4 of the devcontainer, the Go of the `toolchain` stage, in its `GOROOT`:
- **a module taken from the cache** — `src/cmd/go/internal/modfetch/fetch.go`: `Download` returns the module's folder after `f.checkMod(ctx, mod)`, which reads the module's `ziphash` from the cache and hands it to `checkModSum`: "Check whether mod+h is listed in go.sum already. If so, we're done", and else "Consult checksum database if appropriate" — `if useSumDB(mod)`, `checkSumDB(mod, h)`, which "Calls base.Fatalf if mismatch detected";
- **`go mod verify`** — `go help mod verify`: "Verify checks that the dependencies of the current module, which are stored in a local downloaded source cache, have not been modified since being downloaded. If all the modules are unmodified, verify prints "all modules verified." Otherwise it reports which modules have been changed and causes 'go mod' to exit with a non-zero status." In `src/cmd/go/internal/modcmd/verify.go` it takes `mg.BuildList()` of the module graph and, for each module, hashes the archive, `dirhash.HashZip`, and the folder, `dirhash.HashDir`, against the `ziphash` — "zip has been modified", "dir has been modified" —, and a module with neither on disk it skips: "Nothing downloaded yet. Nothing to verify.";
- **the trim of the build cache** — `src/cmd/go/internal/cache/cache.go`: "We set the mtime on a cache file on each use, but at most one per mtimeInterval (1 hour)", "We scan the cache for entries to delete at most once per trimInterval (1 day)"; `mtimeInterval = 1 * time.Hour`, `trimInterval = 24 * time.Hour`, `trimLimit = 5 * 24 * time.Hour`; `Trim` keeps "in dir/trim.txt the time of the last completed cache trim" and, when it is a day old, deletes in `trimSubdir` the files older than `cutoff := now.Add(-trimLimit - mtimeInterval)`;
- **the cache of tests** — `go help test`: "The rule for a match in the cache is that the run involves the same test binary and the flags on the command line come entirely from a restricted set of 'cacheable' test flags, defined as -benchtime, -coverprofile, -cpu, -failfast, -fullpath, -list, -outputdir, -parallel, -run, -short, -skip, -timeout and -v. If a run of go test has any test or non-test flags outside this set, the result is not cached." And: "The idiomatic way to disable test caching explicitly is to use -count=1. Tests that open files within the package's module or that consult environment variables only match future runs in which the files and environment variables are unchanged."

Read 2026-11-16, Go 1.27.4 of the devcontainer:
- **the build cache at once** — `go help cache`: "The cache is safe for concurrent invocations of the go command."

Read 2026-11-18:
- **what finds a build** — `src/cmd/go/internal/cache/cache.go` of Go 1.27.4, the Go of the `toolchain` stage, in the devcontainer's `GOROOT`: "An ActionID is a cache action key, the hash of a complete description of a repeatable computation (command line, environment variables, input file contents, executable contents)";
- **golangci-lint's cache** — golangci-lint v2.15.0, its latest release (the GitHub API, `repos/golangci/golangci-lint/releases/latest`), the commit 25c5369: `internal/go/cache/cache.go` has the comment and the constants of Go's above — `mtimeInterval = 1 * time.Hour`, `trimInterval  = 24 * time.Hour`, `trimLimit     = 5 * 24 * time.Hour` —, `func (c *DiskCache) Close() error { return c.Trim() }` and the same `cutoff := now.Add(-trimLimit - mtimeInterval)`. Where `pkg/commands/run.go` makes its cache, `cache.NewCache`, no call of its `Close` was found. The version a caller's `toolchain` stage installs is the caller's own.

### 10.2. go-licenses

Read 2026-10-21:
- **`--allowed_licenses`** — [README go-licenses v2.0.1](https://github.com/google/go-licenses/blob/v2.0.1/README.md), section Usages, Check: "Allow only specific license names" — `go-licenses check <package> [package...] --allowed_licenses=<comma separated license names>`. The trial — measurements 2.1.

### 10.3. Codecov

Read 2026-11-01:
- **the Codecov app** — `gh api orgs/altnovatrail/installations`: `codecov`, `repository_selection: all`. The Codecov API, `api.codecov.io/api/v2/github/altnovatrail/repos/`, names all 13 repositories. Before the trial only `spec` was active, and after it `.github` too;
- **the Codecov CLI** — the releases of codecov/codecov-cli, the license Apache-2.0. v11.3.2 is Latest, came out 2026-10-28: "Clear Dependabot high alert (urllib3)" and "Rebuilt from main so the Linux and Alpine binaries publish".
  - `https://cli.codecov.io/v11.3.2/linux/codecov.SHA256SUM` — `8e1bfb71661378530f6ea21e82b414095899e565cbb4cf555c613064be17b973  codecov`. For v11.3.1 the same file holds `ca1d6419…`, the same sum as in the `ci.yml` of `spec`.
  - gpg 2.4.4 accepted the signature `codecov.SHA256SUM.sig`: "Good signature from "Codecov Uploader (Codecov Uploader Verification Key) <security@codecov.io>"", "Primary key fingerprint: 2703 4E7F DB85 0E0B BC2C 62FF 806B B28A ED77 9869".
  - The same fingerprint is named by the page [Codecov Uploader](https://docs.codecov.com/docs/codecov-uploader), updated 2026-06-07: "Key Fingerprint: `2703 4E7F DB85 0E0B BC2C 62FF 806B B28A ED77 9869`". It says to take the key from `https://keybase.io/codecovsecops/pgp_keys.asc`.
  - The binary calls itself `codecovcli, version 11.3.2`, and its `sha256sum` agrees with the file of sums;
- **actions** — `git ls-remote`: `codecov/codecov-action` v7.1.1 — 303a32d, `actions/upload-artifact` v7.0.2 — cf430e0, `actions/download-artifact` v8.0.2 — 9000827. All three are the latest releases. The license of codecov-action is MIT. Its `action.yml` at 303a32d:
  - `core.getIDToken` takes the OIDC token, with the audience `https://codecov.io`, if `use_oidc` and this is not a fork;
  - a fork is `github.event.pull_request.head.repo.full_name` not equal to `github.repository`, and then the report goes without a token, from the branch `owner:branch`, as for `spec`;
- **the paths in Codecov** — the default rule for Go's import paths, Codecov, Fixing paths, as the decision log of `spec` quotes it. The trial — measurements 4.1;
- **several uploads per commit** — [Codecov, codecov.yml reference](https://docs.codecov.com/docs/codecovyml-reference), updated 2026-07-23. `codecov.notify.wait_for_ci` has "Should Codecov wait for all CI statuses to complete before sending ours", `true` by default. `codecov.notify.after_n_builds` has "How many uploaded reports Codecov should wait to receive before sending statuses", `1` by default.

## 11. The tools of the checks

### 11.1. gitleaks

Read 2026-10-19:
- **the release and the license** — the GitHub API — `repos/gitleaks/gitleaks/releases/latest`: v8.30.1, 2026-03-21, the files are archives for the platforms and `gitleaks_8.30.1_checksums.txt`, with no signature and no attestation; `repos/gitleaks/gitleaks/license`: MIT.

Read 2026-10-20:
- **gitleaks** — [README v8.30.1](https://github.com/gitleaks/gitleaks/blob/v8.30.1/README.md), section Load Configuration: "The order of precedence is:", and the fourth — "A `.gitleaks.toml` file within the target path". The sum of the archive `gitleaks_8.30.1_linux_x64.tar.gz` is from `gitleaks_8.30.1_checksums.txt` of the same release: `551f6fc83ea457d62a0d98237cbad105af8d557003051f41f3e7ca7b3f2470eb`.

### 11.2. actionlint and ShellCheck

Read 2026-10-20:
- **actionlint** 1.7.12 — the latest release (the GitHub API, `repos/rhysd/actionlint/releases/latest`, 2026-03-30); the sum of the archive `actionlint_1.7.12_linux_amd64.tar.gz` is from `actionlint_1.7.12_checksums.txt`: `8aca8db96f1b94770f1b0d72b6dddcb1ebb8123cb3712530b08cc387b349a3d8`;
- **shellcheck** 0.11.0 — the latest release (the GitHub API, `repos/koalaman/shellcheck/releases/latest`, 2025-08-04), the license is GPL-3.0 (`repos/koalaman/shellcheck/license`); it has no files of sums, so the sum of `shellcheck-v0.11.0.linux.x86_64.tar.xz` was computed from the downloaded archive: `8c3be12b05d5c177a04c29e3c78ce89ac86f1595681cab149b65b97c4e227198`.

### 11.3. yq and bats-core

Read 2026-11-01:
- **yq** — v4.54.1, the latest release, 2026-09-29 (the GitHub API, `repos/mikefarah/yq/releases/latest`). The license is MIT: "The MIT License (MIT)", `LICENSE` at the tag v4.54.1.
  - Among the release's files are `yq_linux_amd64`, `checksums` and `checksums_hashes_order`. SHA-256 is the eighteenth line of `checksums_hashes_order`, and in the line `yq_linux_amd64` of the file `checksums` the sums follow the name in the same order. The SHA-256 sum is `8e34fc298390875de416e6a4afcb8cabeceb25d9aa8506c1a2f9353cf702ea5f`.
  - The downloaded file, 14,168,224 bytes, agreed with it, and `--version` gives "yq (https://github.com/mikefarah/yq/) version v4.54.1".
- **bats-core** — v1.14.0, the latest release, 2026-07-21, the release has no files (the GitHub API, `repos/bats-core/bats-core/releases/latest`); the license is MIT.

### 11.4. just

Read 2026-10-20:
- **`just --dry-run`** — the help of just 1.58.0, `just --help`: "Print what just would do without doing it". The trial — measurements 5.1.

### 11.5. git

Read 2026-10-22:
- **git** v2.55.0, commit e9019fc. `Documentation/git-clone.adoc`, `--local`: "The files under `.git/objects/` directory are hardlinked to save space when possible", and "If the repository is specified as a local path (e.g., `/path/to/repo`), this is the default". `Documentation/git-worktree.adoc`, `add`: "The new worktree is linked to the current repository, sharing everything except per-worktree files such as `HEAD`, `index`, etc.".

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
