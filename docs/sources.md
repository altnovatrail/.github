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

### 2.1. Reusable workflows

Read 2026-10-19:
- **calling and pinning** — [GitHub Docs, Reuse workflows](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows), section Calling a reusable workflow: "`{owner}/{repo}/.github/workflows/{filename}@{ref}` for reusable workflows in public and private repositories" and "Using the commit SHA is the safest option for stability and security";
- **the folder** — the same page, section Creating a reusable workflow: "Subdirectories of the `workflows` directory are not supported";
- **limits** — [GitHub Docs, Reusing workflow configurations](https://docs.github.com/en/actions/reference/workflows-and-actions/reusing-workflow-configurations), section Limitations of reusable workflows: "You can connect up to ten levels of workflows" and "You can call a maximum of 50 unique reusable workflows from a single workflow file";
- **permissions** — the same page, section Supported keywords for jobs that call a reusable workflow: "If `jobs.<job_id>.permissions` is not specified in the calling job, the called workflow will have the default permissions for the `GITHUB_TOKEN`" and "The `GITHUB_TOKEN` permissions passed from the caller workflow can be only downgraded (not elevated) by the called workflow";
- **context** — the same page, section `github` context: "When a reusable workflow is triggered by a caller workflow, the `github` context is always associated with the caller workflow";
- **checkout** — [GitHub Docs, Reusing workflow configurations](https://docs.github.com/en/actions/concepts/workflows-and-actions/reusing-workflow-configurations) (Concepts), section Reusable workflows: "if the called workflow uses `actions/checkout`, the action checks out the contents of the repository that hosts the caller workflow, not the called workflow";
- **the check's name** in a ruleset — "`<job name> / <reusable job name>`", a quote of GitHub Docs in the decision log of `spec`.

Read 2026-11-01:
- **permissions in a reusable workflow** — [GitHub Docs, Reusing workflow configurations](https://docs.github.com/en/actions/reference/workflows-and-actions/reusing-workflow-configurations): "The `GITHUB_TOKEN` permissions passed from the caller workflow can be only downgraded (not elevated) by the called workflow". How a call without the permission ends, the page does not say. How it ended on the trial — measurements 4.1.

### 2.2. Contexts, variables and events

Read 2026-10-19:
- **the shared workflow's own files** — [GitHub Docs, Contexts reference](https://docs.github.com/en/actions/reference/workflows-and-actions/contexts), section `job` context: `job.workflow_sha` — "The commit SHA of the workflow file that defines the current job", `job.workflow_repository` — "The `owner/repo` of the repository containing the workflow file that defines the current job"; an example on the same page: "This example reusable workflow uses `job.workflow_repository` and `job.workflow_sha` to check out its own source code, rather than the caller's repository".

Read 2026-10-20:
- **the `workflow_run` context** — [GitHub Docs, Events that trigger workflows](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows), section `workflow_run`: `GITHUB_SHA` — "Last commit on default branch", `GITHUB_REF` — "Default branch".

Read 2026-10-20:
- **the workflow file** — [GitHub Docs, Workflows](https://docs.github.com/en/actions/concepts/workflows-and-actions/workflows), section Workflow triggers: "Each workflow run will use the version of the workflow that is present in the associated commit SHA or Git ref of the event". For `workflow_run` this is `GITHUB_SHA`, the last commit of the default branch (above, "the `workflow_run` context").

Read 2026-10-21:
- **`job.workflow_ref`** — [GitHub Docs, Contexts reference](https://docs.github.com/en/actions/reference/workflows-and-actions/contexts), section `job` context: "The full ref of the workflow file that defines the current job".

Read 2026-10-21:
- **`CI`** — GitHub, [Variables reference](https://github.com/github/docs/blob/efd4783/content/actions/reference/workflows-and-actions/variables.md) at the commit efd4783, Default environment variables: "`CI` | Always set to `true`".

Read 2026-11-01:
- **default variables** — github/docs at 33b1f4a, `data/reusables/actions/environment-variables-are-fixed.md`: "You can't overwrite the value of the default environment variables named `GITHUB_*` and `RUNNER_*`. Currently you can overwrite the value of the `CI` variable. However, it's not guaranteed that this will always be possible".

Read 2026-11-08:
- **`job.workflow_repository` and `job.workflow_sha`** — [GitHub Docs, Contexts reference](https://docs.github.com/en/actions/reference/workflows-and-actions/contexts) describes them: "The commit SHA of the workflow file that defines the current job" and "The `owner/repo` of the repository containing the workflow file that defines the current job". That actionlint 1.7.12 does not know them — measurements 2.5.

Read 2026-11-16:
- **the contexts of a matrix** — github/docs at 6d84733, `content/actions/reference/workflows-and-actions/contexts.md`, Context availability: "`jobs.<job_id>.strategy` | `github, needs, vars, inputs`";
- **`fromJSON`** — the same commit, `expressions.md`: "Returns a JSON object or JSON data type for `value`. You can use this function to provide a JSON object as an evaluated expression or to convert any data type that can be represented in JSON or JavaScript, such as strings, booleans, null values, arrays, and objects", and its example sets a matrix by it: "`matrix: ${{ fromJSON(needs.job1.outputs.matrix) }}`".

Read 2026-11-16:
- **`RUNNER_ARCH`** — [GitHub Docs, Variables reference](https://docs.github.com/en/actions/reference/workflows-and-actions/variables), Default environment variables: "The architecture of the runner executing the job. Possible values are `X86`, `X64`, `ARM`, or `ARM64`." `GITHUB_PATH` — "The path on the runner to the file that sets system `PATH` variables from workflow commands. The path to this file is unique to the current step and changes for each step in a job."

### 2.3. The step's shell and `set -e`

Read 2026-10-20:
- **the step's shell** — without `shell` a step on Linux runs as `bash -e {0}`, and with `shell: bash` as `bash --noprofile --norc -eo pipefail {0}`: [GitHub Docs, Workflow syntax](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax), section `defaults.run.shell`.

Read 2026-10-22:
- **the step's shell** — GitHub Docs, Workflow syntax, `content/actions/reference/workflows-and-actions/workflow-syntax.md` at the commit c67a936 of github/docs: "By default, fail-fast behavior is enforced using `set -e` for both `sh` and `bash`. When `shell: bash` is specified, `-o pipefail` is also applied".

Read 2026-11-01:
- **the steps' shells** — github/docs at the commit 33b1f4a, `data/reusables/actions/supported-shells.md`. On Linux without `shell` — "`bash -e {0}`", and "Note that this runs a different command to when `bash` is specified explicitly". With `shell: bash` — "`bash --noprofile --norc -eo pipefail {0}`".
- **`set -e` in bash** — [Bash Reference Manual, The Set Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html), edition 5.3:
  - "The shell does not exit if the command that fails is part of the command list immediately following a while or until reserved word, part of the test in an if statement, part of any command executed in a && or || list except the command following the final && or ||";
  - "If a compound command or shell function executes in a context where -e is being ignored, none of the commands executed within the compound command or function body will be affected by the -e setting, even if -e is set and a command returns a failure status".

### 2.4. Secrets, forks and skipped jobs

Read 2026-10-19:
- [GitHub Docs, Using secrets in GitHub Actions](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets), section Using secrets in a workflow: "With the exception of `GITHUB_TOKEN`, secrets are not passed to the runner when a workflow is triggered from a forked repository";
- [GitHub Docs, Securely using pull_request_target](https://docs.github.com/en/actions/reference/security/securely-using-pull_request_target), section Risks of `pull_request_target`: "Workflows triggered by `pull_request_target` run with elevated trust: the job receives the base repository's `GITHUB_TOKEN` and access to repository and organization secrets"; on the same page: "Workflows triggered by this event should not check out, build, or run code from an untrusted pull request with access to repository secrets or a privileged `GITHUB_TOKEN`";
- [GitHub Docs, Status checks](https://docs.github.com/en/pull-requests/reference/status-checks): "A job that is skipped will report its status as "Success". It will not prevent a pull request from merging, even if it is a required check";
- [GitHub Docs, Dependabot on GitHub Actions](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-on-actions), section Restrictions when Dependabot triggers events: "Secrets are populated from Dependabot secrets. GitHub Actions secrets are not available".

### 2.5. OIDC in GitHub Actions

Read 2026-10-19:
- [GitHub Docs, OpenID Connect reference](https://docs.github.com/en/actions/reference/security/oidc), section Custom claims provided by GitHub, `job_workflow_ref`: "For jobs using a reusable workflow, the ref path to the reusable workflow".

Read 2026-10-22:
- **the OIDC token in steps** — github/docs at the commit 5815d11, `content/actions/reference/security/oidc.md`, section Methods for requesting the OIDC token: "The following environment variables on the runner" — `ACTIONS_ID_TOKEN_REQUEST_URL` and `ACTIONS_ID_TOKEN_REQUEST_TOKEN`, "Bearer token for the request to the OIDC provider". How cosign reads them — sources 7.1.

Read 2026-10-22:
- **GitHub OIDC** — github/docs at the commit 5815d11, `oidc-with-reusable-workflows.md`: "The `workflow`, `ref`, and other attributes describe the caller workflow, while `job_workflow_ref` refers to the called workflow".

### 2.6. GitHub's runners

Read 2026-10-21:
- **Docker on the runner** — The ubuntu-24.04 runner has Docker 28.0.4 and Buildx 0.38.0 ([`Ubuntu2404-Readme.md`](https://github.com/actions/runner-images/blob/06f4a91/images/ubuntu/Ubuntu2404-Readme.md) at the commit 06f4a91, image 20261012.334.1).

Read 2026-11-01:
- **the runner's image** — [`Ubuntu2404-Readme.md`](https://github.com/actions/runner-images/blob/4da2307112a0fad2fd2ecaca8ba7d08683b8c581/images/ubuntu/Ubuntu2404-Readme.md) at the commit 4da2307, image 20261026.354.1: Bash 5.2.21(1)-release, Git 2.56.0, jq 1.7, OpenSSL 3.0.13-0ubuntu3.16, tar 1.35+dfsg-3ubuntu0.4 and yq 4.54.1. In the devcontainer — bash 5.2.21, git 2.56.0, jq 1.7, OpenSSL 3.0.13 and GNU tar 1.35.

Read 2026-11-08:
- [GitHub Docs, GitHub-hosted runners reference](https://docs.github.com/en/actions/reference/runners/github-hosted-runners), section Standard GitHub-hosted runners for public repositories: in the table, Linux arm64 has `ubuntu-24.04-arm`, `ubuntu-22.04-arm` and `ubuntu-26.04-arm`, 4 CPU and 16 GB, and "Use of the standard GitHub-hosted runners is free and unlimited on public repositories".

Read 2026-11-18:
- **how long a job runs** — github/docs at the commit 6946b3e (2026-11-12), `content/actions/reference/limits.md`, for all GitHub-hosted runners: "Job execution time | 6 hours | Each job in a workflow can run for up to 6 hours of execution time. If a job reaches this limit, the job is terminated and fails."

### 2.7. `actions/checkout`

Read 2026-10-20:
- **actions/checkout** v7.0.1 — the latest release (2026-07-20); the tag points to the commit `3d3c42e5aac5ba805825da76410c181273ba90b1` (the GitHub API, `repos/actions/checkout/git/refs/tags/v7.0.1`).

Read 2026-10-20:
- **checkout v7.0.1 without `ref`** — [`src/input-helper.ts`](https://github.com/actions/checkout/blob/3d3c42e5aac5ba805825da76410c181273ba90b1/src/input-helper.ts) at the commit 3d3c42e. If `ref` is not set, checkout takes the event's ref and commit: `result.ref = github.context.ref` and `result.commit = github.context.sha`.

Read 2026-10-22:
- **the post step of `actions/checkout`** — v7.0.1 at the commit 3d3c42e, the one pinned in both releases. Its `action.yml` has `post: dist/index.js`, and on the post step `src/main.ts` calls `gitSourceProvider.cleanup(stateHelper.RepositoryPath)`. If the checkout has `.git/config`, `cleanup` in `src/git-source-provider.ts` calls `authHelper.removeAuth()`. And that one, in `src/git-auth-helper.ts`, runs in the checkout `git config --local` and `git submodule foreach --recursive` with `sh -c "git config --local …"`. What this step ran on the trial — measurements 5.4.

Read 2026-10-22:
- **the `submodules` input** — actions/checkout v7.0.1, the commit 3d3c42e, `src/input-helper.ts`, lines 146–152: `const submodulesString = (core.getInput('submodules') || '').toUpperCase()`, and then a comparison with `'RECURSIVE'` and `'TRUE'`.

Read 2026-11-16:
- **a sparse checkout** — `action.yml` at 3d3c42e: `sparse-checkout` — "Do a sparse checkout on given patterns. Each pattern should be separated with new lines."; `sparse-checkout-cone-mode` — "Specifies whether to use cone-mode when doing a sparse checkout.", `default: true`; `filter` — "Partially clone against a given filter. Overrides sparse-checkout if set.". `src/git-source-provider.ts` at 3d3c42e: `} else if (settings.sparseCheckout) { fetchOptions.filter = 'blob:none'`, and "For sparse checkouts, let `checkout` fetch the needed objects lazily"; without cone mode it calls `git.sparseCheckoutNonConeMode`.

### 2.8. `actions/cache`

Read 2026-11-09:
- **`actions/cache`** — v6.1.0, the latest release, 2026-06-26 (the GitHub API, `repos/actions/cache/releases/latest`); the tag v6.1.0 is the commit 55cc8345863c7cc4c66a329aec7e433d2d1c52a9. The license is MIT: "The MIT License (MIT)", `LICENSE` at the tag. `canvas` pins the same commit in `page.yml` (`main` 66266e1 of `canvas`);
- **entries** — the README at the tag v6.1.0: "The cache is scoped to the key, version, and branch. The default branch cache is available to other branches" ("Cache scopes"); "Cache version is a hash generated for a combination of compression tool used (Gzip, Zstd, etc. based on the runner OS) and the `path` of directories being cached", and an example: "`build-linux` will create two different caches as the `paths` are different" ("Cache Version");
- **saving** — `src/saveImpl.ts` at the tag v6.1.0: the step writes an error of `saveCache` by `utils.logWarning`, and `saveOnlyRun` leaves the cause to the toolkit — "warning for most failures, info for benign concurrency races, error for 5xx"; the job goes on. The README, "Read-only access": "When the cache token is read-only, the save step does not fail the job".

Read 2026-11-16:
- **restoring by a prefix** — `restore/action.yml` at the tag v6.1.0, commit 55cc834: the input `restore-keys` is "An ordered multiline string listing the prefix-matched keys, that are used for restoring stale cache if no cache hit occurred for key. Note `cache-hit` returns false in this case."; the outputs are `cache-hit` — "A boolean value to indicate an exact match was found for the primary key", `cache-primary-key` — "A resolved cache key for which cache match was attempted", and `cache-matched-key` — "Key of the cache that was restored, it could either be the primary key on cache-hit or a partial/complete match of one of the restore keys".

Read 2026-11-16:
- **a lookup without the download** — `restore/action.yml` at the tag v6.1.0, commit 55cc834: the input `lookup-only` — "Check if a cache entry exists for the given input(s) (key, restore-keys) without downloading the cache", `default: 'false'`. `src/restoreImpl.ts` at the same commit: on a miss — "`cache-hit` is intentionally not set to `false` here to preserve existing behavior"; on a hit it sets `cache-hit` by `isExactKeyMatch` and, with `lookupOnly`, writes "Cache found and can be restored from key: ${cacheKey}" instead of "Cache restored from key: ${cacheKey}";
- **the limit and the eviction** — github/docs at the commit d59b263 (2026-11-13), `content/actions/reference/workflows-and-actions/dependency-caching.md`, "Usage limits and eviction policy": "GitHub will remove any cache entries that have not been accessed in over 7 days. There is no limit on the number of caches you can store, but the total size of all caches in a repository is limited. By default, the limit is 10 GB per repository"; "Cache access for low-trust workflow triggers": "only these workflow triggers can create or overwrite caches in the default branch’s scope:" — `push`, `workflow_dispatch`, `repository_dispatch`, `delete`, `registry_package`, `page_build`, `schedule` —, and "The `pull_request` event is not affected. Caches created by a `pull_request` run are already scoped to the merge ref (`refs/pull/.../merge`) and cannot be written to the default branch's scope".

Read 2026-11-18:
- **which entry a restore key gives** — github/docs at the commit 6d84733 (2026-11-16), `content/actions/reference/workflows-and-actions/dependency-caching.md`, "Matching a cache key": "If there are multiple partial matches for a restore key, the action returns the most recently created cache"; and "If there are still no hits in the current branch, the `cache` action retries the same steps on the default branch";
- **`cache-hit` by a restore key** — the README at the tag v6.1.0, commit 55cc834: "The `cache` action provides a `cache-hit` output which is set to `true` when the cache is restored using the primary `key` and `false` when the cache is restored using `restore-keys` or no cache is restored."

### 2.9. `actions/upload-artifact`

Read 2026-10-20:
- **actions/upload-artifact** v7.0.2 — the latest release (2026-10-07, `repos/actions/upload-artifact/releases/latest`), the tag points to the commit `cf430e030ddbb5b0abf93d22962f4752f3646cd9` (`repos/actions/upload-artifact/git/refs/tags/v7.0.2`).

Read 2026-11-01:
- **artifact names** — the README of `actions/upload-artifact` at cf430e0, v7.0.2: "Artifact names must be unique since each created artifact is idempotent so multiple jobs cannot modify the same artifact". `spec` already has an artifact `coverage` in its `ci.yml`.

Read 2026-11-16:
- **the inputs** — `action.yml` at cf430e0, v7.0.2: `retention-days` — "Duration after which artifact will expire in days. 0 means using default retention. Minimum 1 day."; `compression-level` — "0: No compression", "For large files that are not easily compressed, a value of 0 is recommended for significantly faster uploads"; `overwrite` — "If true, an artifact with a matching name will be deleted before a new one is uploaded. If false, the action will fail if an artifact for the given name already exists."; `if-no-files-found` — "ignore: Do not output any warnings or errors, the action does not fail"; `archive` — "When `archive` is `false`, only a single file can be uploaded. The name of the file will be used as the artifact name (ignoring the `name` parameter)"; the output `artifact-id` — "A unique identifier for the artifact that was just uploaded. Empty if the artifact upload failed.";
- **the limits** — the README at cf430e0, "Limitations": "You may also be limited by Artifacts if you have exceeded your shared storage quota. Storage is calculated every 6-12 hours".

### 2.10. `actions/download-artifact`

Read 2026-11-16:
- **the version** — v8.0.2, the commit `9000827ccba6bdab643e8b6fd33ac0654aef8333`, as `go.yml` and `typescript.yml` pin it (sources 10.3);
- **by its ID** — `action.yml` at 9000827: `artifact-ids` — "IDs of the artifacts to download, comma-separated. Either inputs `artifact-ids` or `name` can be used, but not both."; `path` — "Destination path. Supports basic tilde expansion. Defaults to $GITHUB_WORKSPACE"; `digest-mismatch` — "Default is error which will fail the action"; without `github-token` — "the action will attempt to download artifacts from the current repository and the current workflow run". `src/download-artifact.ts` at 9000827: by IDs it throws "None of the provided artifact IDs were found", and it downloads into `path` itself when `isSingleArtifactDownload || inputs.mergeMultiple || artifacts.length === 1`, with `expectedHash: artifact.digest`.

### 2.11. Jobs that need another, re-runs and the storage of artifacts

Read 2026-11-16, github/docs at the commit d59b263 (2026-11-13):
- **`needs`** — `data/reusables/actions/jobs/section-using-jobs-in-a-workflow-needs.md`: "If a job fails or is skipped, all jobs that need it are skipped unless the jobs use a conditional expression that causes the job to continue"; `content/actions/how-tos/write-workflows/choose-when-workflows-run/control-jobs-with-conditions.md`: "A job that is skipped will report its status as "Success". It will not prevent a pull request from merging, even if it is a required check" (as in sources 2.4);
- **`!cancelled()`** — `content/actions/reference/workflows-and-actions/expressions.md`, "Status check functions": "A default status check of `success()` is applied unless you include one of these functions", and "If you want to run a job or step regardless of its success or failure, use the recommended alternative: `if: ${{ !cancelled() }}`";
- **`continue-on-error` and `outcome`** — `contexts.md`: `steps.<step_id>.outcome` — "The result of a completed step before `continue-on-error` is applied", and "When a `continue-on-error` step fails, the `outcome` is `failure`, but the final `conclusion` is `success`";
- **re-runs** — `content/actions/how-tos/manage-workflow-runs/re-run-workflows-and-jobs.md`: "When you re-run failed jobs or a specific job, GitHub also re-runs the jobs that depend on them. Jobs that aren't included keep their outputs from the previous attempt, which the newly run jobs can use";
- **the storage of artifacts** — `content/billing/concepts/product-billing/github-actions.md`: "For **private repositories**, usage is measured against two parts of your plan:" — "**Compute**" and "**Storage:** Artifact and cache storage have separate allowances"; "**Cache storage:** Actions cache storage is a separate allowance of 10 GB per repository. Cache storage is not shared with artifacts"; "If your account does not have a valid payment method on file, usage is blocked once you consume the included compute usage". `data/reusables/billing/actions-included-quotas.md`: the plan for organizations Free — "Artifact storage" 500 MB. The organization `altnovatrail` is on the plan `free` (`gh api orgs/altnovatrail`, `.plan.name`), and every repository of it is public. Whether the quota of artifact storage holds for a public repository the page does not say in words; what the trial saw — measurements 7.3.

Read 2026-11-16, github/docs at the commit d59b263, as above:
- **`always()`** — `content/actions/reference/workflows-and-actions/expressions.md`, "always": "Causes the step to always execute, and returns `true`, even when canceled. The `always` expression is best used at the step level or on tasks that you expect to run even when a job is canceled"; and the warning: "Avoid using `always` for any task that could suffer from a critical failure, for example: getting sources, otherwise the workflow may hang until it times out";
- **`needs.<job_id>.result`** — `contexts.md`, `needs` context: "The result of a job that the current job depends on. Possible values are `success`, `failure`, `cancelled`, or `skipped`." Neither this page nor the pages of the matrix say how the result of a job with a matrix comes out of the results of its jobs; the trial measured it (measurements 2.7);
- **`fail-fast`** — `data/reusables/actions/jobs/section-using-a-build-matrix-for-your-jobs-failfast.md`: "If `jobs.<job_id>.strategy.fail-fast` is set to `true` or its expression evaluates to `true`, {% data variables.product.github %} will cancel all in-progress and queued jobs in the matrix if any job in the matrix fails. This property defaults to `true`.";
- **a job that times out** — `content/actions/reference/workflows-and-actions/workflow-syntax.md`, `jobs.<job_id>.timeout-minutes`: "The maximum number of minutes to let a job run before GitHub automatically cancels it"; `workflow-cancellation.md` of the same folder: "For steps that need to be canceled, the runner machine sends `SIGINT/Ctrl-C` to the step's entry process (`node` for JavaScript actions, `docker` for container actions, and `bash/cmd/pwd` when using `run` in a step). If the process doesn't exit within 7500 ms, the runner will send `SIGTERM/Ctrl-Break` to the process, then wait for 2500 ms for the process to exit. If the process is still running, the runner kills the process tree." The first quote renders `{% data variables.product.prodname_dotcom %}` as GitHub.

### 2.12. Composite actions and the self repository reference `$/`

Read 2026-11-16, github/docs at the commit 91aa429 (2026-11-16):
- **the self repository reference** — `content/actions/reference/workflows-and-actions/workflow-syntax.md`, "Example: Using an action in the same repository as the workflow at the running commit (recommended)": "The `$/` prefix is the self repository reference. It references an action stored in the same repository as the workflow or action that is currently running, and resolves to that repository at the running commit (the same SHA as the running workflow or action). You do not need to check out the repository first"; "A `$/` reference must not include an `@{ref}` suffix"; "`$/` always resolves against the repository of the file it appears in, not the repository that called it. For example, if a reusable workflow in one repository is called by a workflow in another repository, a `$/` reference in the called workflow resolves to the called workflow's repository, not the calling workflow's repository"; and `./path/to/action` resolves to "A path in the runner's checked-out workspace, relative to the default working directory". The commit 6a8580f, "Document the $/ self-referencing uses syntax for actions and reusable workflows (#62055)", 2026-07-29, brought it to `metadata-syntax.md` (the GitHub API, the history of the file);
- **composite actions** — `content/actions/reference/workflows-and-actions/metadata-syntax.md`: `runs.post`, "Allows you to run a script at the end of a job, once the `main:` action has completed", is a key of "`runs` for JavaScript actions", and the section "`runs` for composite actions" names `runs.using` — "You must set this value to `'composite'`" — and `runs.steps`, "These can be either `run` steps or `uses` steps", with no `post`; `runs.steps[*].shell` — "Required if `run` is set"; `runs.steps[*].if` — "You can use any supported context and expression to create a conditional"; and "With composite actions you can use the [`inputs` context] to access action inputs".

## 3. GitHub: rulesets, releases and the organization

### 3.1. Rulesets, required checks and merge

Read 2026-10-20:
- **the ruleset's rule on findings** — [GitHub Docs, Available rules for rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets), section Require code scanning results: a merge does not pass if "A required tool finds a code scanning alert of a severity that is defined in the ruleset", "A required tool's analysis is still in progress" or "A required tool is not configured for the repository".

Read 2026-10-20:
- **the source of a required check** — [GitHub Docs, Available rules for rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets), section Require status checks to pass: "Any person or integration with write permissions to a repository can set the state of any status check in the repository", and so "you can select an app as the expected source of status updates";
- **the message of a squash merge** — [GitHub Docs, About pull request merges](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/about-pull-request-merges), section Merge message for a squash merge: "GitHub generates a default commit message that you can edit. The default message can include the pull request title, pull request description, or commit information, depending on repository settings".

Read 2026-10-20:
- **the `code_scanning` rule** — [GitHub Docs, Set code scanning merge protection](https://docs.github.com/en/code-security/how-tos/find-and-fix-code-vulnerabilities/manage-your-configuration/set-merge-protection): a tool has two thresholds. Alerts — "**None**, **Errors**, **Errors and Warnings** or **All**", Security alerts — "**None**, **Critical**, **High or higher**, **Medium or higher**, or **All**". Which results it trusts — [GitHub Docs, REST API endpoints for rules](https://docs.github.com/en/rest/repos/rules), Update a repository ruleset, the rule `code_scanning`: "When configured, code scanning must be enabled and have results for both the commit and the reference being updated";
- **the ruleset of `.github` after the edit** — the GitHub API, `PUT repos/altnovatrail/.github/rulesets/25477399`, 2026-10-20. The body was put together from `GET`. A comparison before and after showed exactly two edits: the rule `code_scanning` and `allowed_merge_methods: ["merge"]`. `GET repos/altnovatrail/.github/rules/branches/main` names both;
- **the merge method** — [GitHub Docs, Available rules for rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets), section Require a pull request before merging: "Optionally, you can require a merge type of merge, squash, or rebase. This means the targeted branches may only be merged based on the allowed type. Additionally if the repository has disabled a merge method and the ruleset required a different method, the merge will be blocked". `.github` has `allow_merge_commit` on (the GitHub API, `repos/altnovatrail/.github`).

### 3.2. Releases and source code archives

Read 2026-10-20:
- **immutable releases** — the GitHub API: `PUT repos/altnovatrail/.github/immutable-releases` answered 204, and `GET` of the same path `{"enabled":true,"enforced_by_owner":false}`, as for `spec`. The ruleset `v-tags` — `POST repos/altnovatrail/.github/rulesets` with the rules `update`, `deletion` and `non_fast_forward` on `refs/tags/v*`, with no bypass; the model is the ruleset of `spec` 25426896;
- **the Releases API's refusal** to a commit that is no longer the tip of `main` — [GitHub Docs, REST API endpoints for releases](https://docs.github.com/en/rest/releases/releases), Create a release: "If the commit identified by target_commitish … adds or modifies any file under .github/workflows/ relative to the repository's default branch, the authenticating token must be authorized to modify workflows. Otherwise, this endpoint returns 404 Not Found; some authentication paths surface 403 Resource not accessible by integration instead", and "The GITHUB_TOKEN available to GitHub Actions cannot be authorized for this". How the release of `spec` lets this refusal pass — the recipe `release-refusal` of [spec v0.2.11](https://github.com/altnovatrail/spec/blob/v0.2.11/justfile).

Read 2026-11-01:
- **source code archives** — github/docs at 33b1f4a, `content/repositories/working-with-files/using-files/downloading-source-code-archives.md`, section Stability of source code archives:
  - "The exact compression settings used to generate a zipball or tarball may change over time. The extracted contents won't change if the branch or tag doesn't change, but the outer compressed archive may have a different byte layout";
  - "If you rely on stability of archives for security (for example: to ensure you don't attempt to unzip a maliciously-crafted file), we recommend using releases instead of using source downloads".

### 3.3. The organization's policy for actions

Read 2026-10-19:
- [GitHub Docs, Disabling or limiting GitHub Actions for your organization](https://docs.github.com/en/organizations/managing-organization-settings/disabling-or-limiting-github-actions-for-your-organization), section Managing GitHub Actions permissions for your organization: "When you enable **Require actions to be pinned to a full-length commit SHA**, all actions must be pinned to a full-length commit SHA to be used. This includes actions from your organization and actions authored by GitHub. Reusable workflows can still be referenced by tag".

Read 2026-10-20:
- **the actions policy** — the GitHub API, `repos/altnovatrail/<repository>/actions/permissions`, for `.github`, `spec`, `module-kit` and `tutor`: `enabled: true`, `allowed_actions: all`, `sha_pinning_required: true` (`tutor` — read 2026-10-20).

### 3.4. Community health files, issue forms and the pull request template

Read 2026-11-01:
- **where GitHub takes them from** — [GitHub Docs, Creating a default community health file](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file):
  - "Store issue templates and their configuration file in `.github/ISSUE_TEMPLATE`", and for the other files the first of the places is "The `.github` folder";
  - "if a repository defines valid issue templates or issue template configuration in its own `.github/ISSUE_TEMPLATE` folder, none of the contents of the default `.github/ISSUE_TEMPLATE` folder will be used".
- **the pull request template** — [GitHub Docs, Creating a pull request template for your repository](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/creating-a-pull-request-template-for-your-repository): "You can create default pull request templates for your organization or personal account" and "To store your file in a hidden directory, name the pull request template `.github/pull_request_template.md`".
- **the issue type** — [GitHub Docs, Syntax for issue forms](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms), the key `type`: "The issue type that will be automatically added to issues created with this template. Issue types are defined at the organization level". On the same page, of `labels`: "If a label does not already exist in the repository, it will not be automatically added to the issue". The page's example writes `type: bug`, and whether GitHub tells case apart is not said. The forms name the types as the organization calls them: Task, Bug and Feature, all enabled (the GitHub API, `orgs/altnovatrail/issue-types`).
- **Markdown in forms** — [GitHub Docs, Syntax for GitHub's form schema](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema):
  - for `markdown` — "Markdown formatting is supported", for a checkbox's label — "Markdown is supported for bold or italic text formatting, and hyperlinks". The descriptions of `textarea` and `input` say nothing about Markdown;
  - `render` — "If a value is provided, submitted text will be formatted into a codeblock. When this key is provided, the text area will not expand for file attachments or Markdown editing";
  - `required` — "Prevents form submission until element is completed. Only for public repositories".
- **a blank issue** — [GitHub Docs, Configuring issue templates for your repository](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository): with `blank_issues_enabled: false` "users with write access or above (Write, Maintain, or Admin roles) will still see the Blank issue option in the template chooser, labeled Maintainers only", and `contact_links` lead outside.

### 3.5. `gh release verify` and `verify-asset`

Read 2026-11-16:
- **the `gh` of the runner** — the image `ubuntu-24.04`, version 20261111.370.1: "GitHub CLI 2.103.3" (actions/runner-images at e130079, `images/ubuntu/Ubuntu2404-Readme.md`);
- **`gh release verify-asset`** — cli/cli at the tag v2.103.3, 63837fb, `pkg/cmd/release/verify-asset/verify_asset.go`: `Use: "verify-asset [<tag>] <file-path>"`, `Args: cobra.MaximumNArgs(2)` — one file a call. Each call works out the file's digest, then `shared.FetchRefSHA(ctx, config.HttpClient, baseRepo, tagName)`, then `config.AttClient.GetByDigest(api.FetchParams{… PredicateType: "release" …})` for the tag's commit, keeps the attestations of the tag, then `shared.FilterAttestationsByFileDigest(filteredAttestations, fileDigest.Digest())` — "attestation for %s does not contain subject %s" when none —, and verifies the one left by `config.AttVerifier.VerifyAttestation(releaseRefDigest, filteredAttestations[0])`. The file's name is not compared: only the digest;
- **`gh release verify`** — the same tag, `pkg/cmd/release/verify/verify.go`: the same `FetchRefSHA` and `GetByDigest`, "duplicate attestations found for release %s in %s" when the tag has more than one, the same `VerifyAttestation`, and then `if opts.Exporter != nil { return opts.Exporter.Write(config.IO, verified) }` — with `--format json` the result of the verification is printed; without it, `printVerifiedSubjects` reads `statementData.Subject` from the verified envelope and prints each subject that has a name, "Name" and "Digest".

### 3.6. The rate limits of the REST API

Read 2026-11-16:
- [GitHub Docs, Rate limits for the REST API](https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api):
  - "The rate limit for `GITHUB_TOKEN` is 1,000 requests per hour per repository. For requests to resources that belong to a GitHub Enterprise Cloud account, the limit is 15,000 requests per hour per repository";
  - the secondary rate limits: "No more than 100 concurrent requests are allowed", no more than 900 points per minute for REST API endpoints, "No more than 90 seconds of CPU time per 60 seconds of real time is allowed", "No more than 80 content-generating requests per minute and no more than 500 content-generating requests per hour are allowed";
  - the points: "Most REST API `GET`, `HEAD`, and `OPTIONS` requests" — 1, "Most REST API `POST`, `PATCH`, `PUT`, or `DELETE` requests" — 5, and "Some REST API endpoints have a different point cost that is not shared publicly".

### 3.7. The names of release assets

Read 2026-11-16:
- [GitHub Docs, REST API endpoints for release assets](https://docs.github.com/en/rest/releases/assets), Upload a release asset: "GitHub renames asset filenames that have special characters, non-alphanumeric characters, and leading or trailing periods. The "List release assets" endpoint lists the renamed filenames".

## 4. Dependabot

### 4.1. GitHub Docs on Dependabot

Read 2026-10-19:
- [GitHub Docs, About Dependabot version updates](https://docs.github.com/en/code-security/concepts/supply-chain-security/dependabot-version-updates), section Updates for actions: "Dependabot also checks workflow files for uses of reusable workflows, and updates the Git reference for these called reusable workflows";
- [GitHub Docs, Supported ecosystems and repositories](https://docs.github.com/en/code-security/reference/supply-chain-security/supported-ecosystems-and-repositories), section GitHub Actions: "If the commit you use is not associated with any tag, Dependabot will update the GitHub Actions to the latest commit (which might differ from the latest release)" and "Dependabot will ignore actions or reusable workflows referenced locally (for example, `./.github/actions/foo.yml`)". It updates the version comment if that is on the same line — a quote in the decision log of `spec`.

Read 2026-10-20:
- **Dependabot's reference** — [GitHub Docs, Dependabot options reference](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference), section `cooldown`. GitHub Actions is among the package managers where `default-days` works, and with no setting "Apply a **default cooldown period of 3 days** to version updates, even when `cooldown` is not configured".

Read 2026-11-08:
- [GitHub Docs, Dependabot options reference](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference), section `groups`: "All updates for dependencies that match a rule are combined in a single pull request", "If a dependency matches more than one rule, it's included in the first group that it matches" and "Any outdated dependencies that do not match a rule are updated in individual pull requests". A group's name "must start and end with a letter, and can contain letters, pipes `|`, underscores `_`, or hyphens `-`". Of `patterns`: "Both options support using `*` as a wild card to define matches with dependency names". Whether `*` matches `/` and whether `cooldown` acts on a group, the reference does not say. Section `open-pull-requests-limit`: "If five pull requests with version updates are open, no further pull requests are raised until some of those open requests are merged or closed".

Read 2026-11-16:
- github/docs at the commit 91aa429 (2026-11-16), `content/code-security/reference/supply-chain-security/dependabot-options-reference.md`, "`directories` or `directory`": "For GitHub Actions, use the value `/`. Dependabot will search the `/.github/workflows` directory, as well as the `action.yml/action.yaml` file from the root directory", and "Use `directories` to define a list of multiple directories of manifests"; "`group-by` (`groups`)": "When set to `dependency-name`, Dependabot will create a single pull request for each dependency update across all specified directories, rather than separate pull requests per directory", and "All directories must use the same package ecosystem"; `data/features/dependabot-updates-group-by.yml` holds it for `fpt: '*'`.

### 4.2. dependabot-core

Read 2026-10-20:
- **the pause for references to a reusable workflow** — [dependabot-core](https://github.com/dependabot/dependabot-core/tree/fda701f49c7d6ba5807e98a06549fdb935e3bd2e), the commit fda701f (`main`, 2026-10-20). By its README, it is "the library at the heart of Dependabot security / version updates". In it:
  - `github_actions/lib/dependabot/github_actions/file_parser.rb` makes a reference to a reusable workflow a dependency, like an action: "For reusable workflows (.github/workflows/*.yml), use the repository name + workflow path to distinguish between different workflow files in the same repository";
  - `update_checker.rb` builds for each dependency a `LatestVersionFinder` with `cooldown_options: update_cooldown`;
  - in `update_checker/latest_version_finder.rb`, `cooldown_enabled?` returns `true`. If the reference is pinned by a SHA that has a tag, the candidates are tags. The date of each is taken by `common/lib/dependabot/git_metadata_fetcher.rb` from a clone: `git for-each-ref --format="%(refname:short) %(creatordate:short)" refs/tags`. `check_if_version_in_cooldown_period?` reads it by `Time.parse`, so the window of three times 86,400 seconds opens at midnight of that day. GitHub's release date — "Priority: GitHub Release published_at > tag creation date > commit date" — the same file takes only when it proposes a bare SHA;
  - `creatordate` — by [the documentation of git](https://github.com/git/git/blob/master/Documentation/git-for-each-ref.adoc) (`git-for-each-ref`): "For commit and tag objects, the special `creatordate` and `creator` fields will correspond to the appropriate date or name-email-date tuple from the `committer` or `tagger` fields depending on the object type". The tag `v0.1.0` is lightweight, it points straight at the commit (the GitHub API, `repos/altnovatrail/.github/git/refs/tags/v0.1.0`: the object `commit`). The commit is 2026-10-20T13:17:26Z, the release 13:18:27Z;
  - the pause came to this ecosystem with #12486 (2025-06-20), its flag was removed in #12577 (2025-07-08), and Dependabot has raised reusable workflows since the commit dcf1e27 "Allow updating reusable workflows" (2023-02-17) — by the history of the files in the GitHub API.

Read 2026-10-21:
- **Dependabot and the Dockerfile** — [`docker/lib/dependabot/docker/file_parser.rb`](https://github.com/dependabot/dependabot-core/blob/fda701f/docker/lib/dependabot/docker/file_parser.rb) of dependabot-core at the commit fda701f, 2026-10-20. `parse` goes through the lines of the Dockerfile and skips each one that does not match `FROM_LINE` — "`next unless FROM_LINE.match?(line)`" — and `FROM_LINE` starts with `^#{FROM}\s+`. It does not read a line `COPY --from`.

Read 2026-11-08:
- **dependabot-core** at the commit [fda701f](https://github.com/dependabot/dependabot-core/tree/fda701f49c7d6ba5807e98a06549fdb935e3bd2e), 2026-10-20:
  - `common/lib/wildcard_matcher.rb` — a pattern is split by `*`, the parts are escaped by `Regexp.quote` and joined by `.*`, and the comparison is `downcase` on both sides. `.*` matches `/` too;
  - `common/lib/dependabot/dependency_group.rb` — `contains?` checks the dependency's name, `dependency.name`, against `patterns` by `WildcardMatcher.match?`;
  - `github_actions/lib/dependabot/github_actions/file_parser.rb` — "For reusable workflows (.github/workflows/*.yml), use the repository name + workflow path", `name = "#{repo_name}#{path}"`. That is what Dependabot's pull requests in `spec` are called, "Bump altnovatrail/.github/.github/workflows/<file>.yml". It does not parse a reference by a local path: "TODO: Support Docker references and path references";
  - `updater/lib/dependabot/updater/group_update_creation.rb` — a group's update takes for each dependency `update_checker_for` with `update_cooldown: job.cooldown`, as a single update does in `operations/update_all_versions.rb`.

### 4.3. Dependabot's pull requests in `spec`

Read 2026-11-01:
- **Dependabot in `spec`** — the pull requests #40–#42, "Bump altnovatrail/.github/.github/workflows/<file>.yml from 0.1.0 to 0.1.3", opened and merged 2026-10-23, and #49–#51, "from 0.1.3 to 0.1.10", opened 2026-10-26. The commit of #40 has the author `dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>`, the committer `GitHub <noreply@github.com>`, the sign-off `Signed-off-by: dependabot[bot] <support@github.com>`, and "DCO / sign-off" is success. The releases of `.github`: v0.1.3 — 2026-10-21T04:50:54Z, the commit of its tag — 2026-10-20T23:49:54-05:00; v0.1.4 — 2026-10-21T15:30:24Z; v0.1.10 — 2026-10-22T18:09:38Z (`gh release list`, `git log -1 --format=%cI <tag>`).

Read 2026-11-16:
- **dependabot-core** at the commit d73abc7 (`main`, 2026-11-16), `github_actions/lib/dependabot/github_actions/file_parser.rb`: `dependency_for_declarations` skips a reference that "`string.start_with?(".", "docker://")`" and one that does not match `GITHUB_REPO_REFERENCE`, `owner/repo[/path]@ref`, so `$/.github/actions/toolchain`, which has no `@`, is no dependency; and `github_dependency` names a reference with a path and a SHA "`elsif path && ref&.match?(/^[0-9a-f]{6,40}$/)`" by "`"#{repo_name}#{path}"`": `altnovatrail/.github/.github/actions/toolchain`, which the pattern `altnovatrail/.github/*` matches (the reading of 2026-11-08 above).

## 5. CodeQL

### 5.1. `github/codeql-action`

Read 2026-10-19:
- [codeql-action, README](https://github.com/github/codeql-action), section Workflow Permissions: "All advanced setup code scanning workflows must have the `security-events: write` permission".

Read 2026-10-20:
- **github/codeql-action** v4.39.0 — the newest tag `v4.*` by `git ls-remote --tags https://github.com/github/codeql-action` (released 2026-10-15, the GitHub API, `repos/github/codeql-action/releases/tags/v4.39.0`). The repository's latest "release" is a CodeQL bundle, not a version of the action. The tag is annotated, 48870fd, and points to the commit `6f2ac81f5cd81fe351a197ba0b00d91d03cd2aee` (`repos/github/codeql-action/git/tags/48870fdd6b42ee6474ec4207209ff87609271a5e`). The inputs of `init` of this version are `languages`, `build-mode`, `queries` (`init/action.yml` at the tag v4.39.0);
- **the CodeQL bundle** — `init/action.yml` at the commit 6f2ac81, the input `tools`: "A special value `linked` which uses the version of the CodeQL tools that the Action has been bundled with", and without the input "the Action will check in several places until it finds the CodeQL tools". In `src/setup-codeql.ts` of the same commit, without the input `defaultCliVersion.enabledVersions[0]` is taken — the version from GitHub's flags, and with `linked` the version from `src/defaults.json`, `"cliVersion": "2.27.2"`. A trial run confirmed it — measurements 1.1.

Read 2026-10-20:
- **the `config` input** of `init` — `init/action.yml` at the commit 6f2ac81 (v4.39.0): "Configuration passed as a YAML string in the same format as the config-file input. This takes precedence over the config-file input". An empty input is the same as an absent one: `getOptionalInput` in `src/actions-util.ts` of the same commit returns `undefined` for an empty string, and `src/init-action.ts` parses `config` only if it is set;
- **the repository property `github-codeql-config-file`** — besides the input `config-file`, `init` can take the configuration file from the repository property `github-codeql-config-file`. It is read by `getConfigFileInput` in `src/config/file.ts` at 6f2ac81, behind the flag `config_file_repository_property`, and the property's name is set in `src/feature-flags/properties.ts`. If a file and `config` come together, `init` takes only `config`: "Both a config file and config input were provided. Ignoring config file." (`src/config-utils.ts`). The organization's schema of properties is empty (the GitHub API, `orgs/altnovatrail/properties/schema`, 2026-10-20), so no repository has such a property.

Read 2026-10-21:
- **an explicit build mode** — [`src/codeql.ts`](https://github.com/github/codeql-action/blob/6f2ac81f5cd81fe351a197ba0b00d91d03cd2aee/src/codeql.ts) of codeql-action at the commit 6f2ac81, v4.39.0: `extractUsingBuildMode` runs `codeql database trace-command --use-build-mode`, and with `autobuild` and a failure answers "We were unable to automatically build your code". No separate step `autobuild` is needed: [`src/analyze-action.ts`](https://github.com/github/codeql-action/blob/6f2ac81f5cd81fe351a197ba0b00d91d03cd2aee/src/analyze-action.ts) of the same commit skips the old autobuild of Go — "Skipping legacy Go autobuild since a build mode has been specified".

### 5.2. GitHub Docs on code scanning

Read 2026-10-19:
- [GitHub Docs, Workflow configuration options](https://docs.github.com/en/code-security/reference/code-scanning/workflow-configuration-options), section Analysis category: "If you don't specify a `category` parameter in your workflow, GitHub will generate a category name for you, based on the name of the workflow file triggering the action, the action name, and any matrix variables". A shared workflow has one file name for all repositories, so `category` is set explicitly;
- default setup and a repository's own workflow do not work together — a quote in a task of the plan of `spec`, its «Выяснилось при планировании».

Read 2026-10-20:
- **findings and merge** — [GitHub Docs, Triaging code scanning alerts in pull requests](https://docs.github.com/en/code-security/how-tos/manage-security-alerts/manage-code-scanning-alerts/triage-alerts-in-pull-requests): "the check that contains the results of code scanning is: Code scanning results" and "If the code scanning results check finds any problems with a severity of `error`, `critical`, or `high`, the check fails". What this check is called on a pull request — measurements 1.1;
- **building for CodeQL** — [GitHub Docs, CodeQL build options and steps for compiled languages](https://docs.github.com/en/code-security/reference/code-scanning/codeql/build-options-for-compiled-languages), section Building Go: "CodeQL supports build modes `autobuild` or `manual` for Go code" — without a build, `none`, Go is not analysed.

Read 2026-10-20:
- **`paths-ignore`** — [GitHub Docs, Workflow configuration options](https://docs.github.com/en/code-security/reference/code-scanning/workflow-configuration-options):
  - section Specifying directories to scan: "You can use this option when you run the CodeQL actions on an interpreted language (Python, Ruby, and JavaScript/TypeScript) or when you analyze a compiled language without building the code (currently supported for C/C++, C#, Java and Rust)". The documentation does not name the language `actions`, while the Actions extractor takes the paths into account (sources 5.3);
  - on the same page, of patterns: "`**` characters can only be at the start or end of a line, or surrounded by slashes" and "You'll need to quote anything that contains a `*` character";
  - section Configuration details: the value of the input `config` "must be a YAML string that follows the configuration file format".

### 5.3. `github/codeql` at the tag codeql-cli/v2.27.2

Read 2026-10-20:
- **`paths-ignore` of the Actions extractor** — [`actions/extractor/tools/autobuild.sh`](https://github.com/github/codeql/blob/codeql-cli/v2.27.2/actions/extractor/tools/autobuild.sh) in github/codeql at the tag codeql-cli/v2.27.2 says: "If the user provided `paths-ignore`, those patterns are excluded". The documentation does not name the language `actions` in the section Specifying directories to scan (sources 5.2); the trial — measurements 1.2.

Read 2026-10-21:
- **Go's autobuild** — [`go/extractor/autobuilder/autobuilder.go`](https://github.com/github/codeql/blob/codeql-cli/v2.27.2/go/extractor/autobuilder/autobuilder.go) in github/codeql at the tag codeql-cli/v2.27.2: "If a project is accompanied by a build script (such as a makefile), then we try executing such", and the list — `make` for Makefile, makefile and GNUmakefile, `ninja` for build.ninja, `./build` and `./build.sh`.

## 6. Scorecard

### 6.1. `scorecard-action` and `scorecard-webapp`

Read 2026-10-19:
- [scorecard-action v2.5.0, README](https://github.com/ossf/scorecard-action/blob/v2.5.0/README.md), section Workflow Restrictions: "The workflow can't contain top level env vars or defaults", "No workflow level write permissions", "Only the job with `ossf/scorecard-action` can use `id-token: write` permissions", and for its job — "The steps running in this job must belong to this approved list of GitHub actions:" `actions/checkout`, `actions/upload-artifact`, `github/codeql-action/upload-sarif`, `ossf/scorecard-action`, `step-security/harden-runner`. The triggers are `push` and `schedule` on the default branch, a quote in the decision log of `spec`;
- [scorecard-webapp, PR #778](https://github.com/ossf/scorecard-webapp/pull/778) "Fix default branch verification", merged 2025-04-16: "This PR modifies the verification procedure to use the repository of the **calling** workflow instead";
- that the server rejected the result, v2.5.0 does not count as an error: [`signing/signing.go`](https://github.com/ossf/scorecard-action/blob/fa7117db83c52d787ae5a89f350999701505d78e/signing/signing.go), the function `ProcessSignature`, on a failed publication writes `::warning::Unable to POST scorecard results to webapp` and returns `nil`. The commit fa7117d is the tag v2.5.0; read 2026-10-20;
- there is no input `fail_on_publish_error` in v2.5.0: neither the README nor `action.yaml` of this tag names it. `main` has it since 2026-10-14 (the commit 1dfaf3539e, #1721): "Fail the step when the Scorecard API rejects published results". It will come with the next release.

Read 2026-11-12, the comment of `scorecard.yml`:
- [scorecard-action v2.5.0, README](https://github.com/ossf/scorecard-action/blob/v2.5.0/README.md), section Workflow Restrictions: the server sets the rules — "our API enforces certain rules on the producing workflow, which may reject the results and cause the Scorecard Action run to fail", — and the subsection Restrictions on the job containing `ossf/scorecard-action` names three more for the job: "No job level env vars or defaults", "No containers or services" and "The job should run on one of the Ubuntu hosted runners".

### 6.2. `ossf/scorecard` at the commit 61e8474

Read 2026-10-20:
- **Scorecard's Dangerous-Workflow** — [`checks/raw/dangerous_workflow.go`](https://github.com/ossf/scorecard/blob/61e84743356275f6ffca23b1b2f2cb945e19eb96/checks/raw/dangerous_workflow.go) at the commit 61e8474, the version of Scorecard, v5.6.0, by which the server scored `.github` (the field `scorecard` in the answer of Scorecard's API). In a workflow with the trigger `pull_request_target` or `workflow_run`, the function `checkJobForUntrustedCodeCheckout` marks a checkout whose `ref` contains `github.event.pull_request` or `github.event.workflow_run`; it does not read the job's `if` condition;
- **the risk of Dangerous-Workflow** — [`docs/checks.md`](https://github.com/ossf/scorecard/blob/61e84743356275f6ffca23b1b2f2cb945e19eb96/docs/checks.md) of Scorecard at the same commit: "Risk: `Critical` (vulnerable to repository compromise)".

Read 2026-10-20:
- **checkout without `ref` in Scorecard** — in [`checks/raw/dangerous_workflow.go`](https://github.com/ossf/scorecard/blob/61e84743356275f6ffca23b1b2f2cb945e19eb96/checks/raw/dangerous_workflow.go) at the commit 61e8474, the function `checkJobForUntrustedCodeCheckout` skips a step without the input `ref`: `if !ok || ref.Value == nil { continue }`. The function `validateScriptInjection` looks for an injection only in `run:`, by a list of contexts, and `head_sha` is not in it;
- **npm in Scorecard** — in [`checks/raw/shell_download_validate.go`](https://github.com/ossf/scorecard/blob/61e84743356275f6ffca23b1b2f2cb945e19eb96/checks/raw/shell_download_validate.go) at 61e8474, the function `isNpmUnpinnedDownload` leaves unmarked only `npm ci` — "`npm ci` will verify all hashes are present" — and a package from git pinned by a commit hash. The other install commands of npm it marks. The code scanning finding #2 is line 113 of `.devcontainer/Dockerfile`, Pinned-Dependencies — 8. The archives that the Dockerfile downloads by curl and unpacks by tar it did not mark: `.github` has no other findings of Pinned-Dependencies.

### 6.3. Scorecard's API

Read 2026-10-20:
- **Scorecard's API** — `https://api.scorecard.dev/projects/github.com/<owner>/<repository>`: an accepted result comes with the date, the repository's commit and the score — the fields `date`, `repo.commit`, `score` in the answer for `ossf/scorecard`; a repository without a published result gets 404, as `spec` does.

### 6.4. `ossf/scorecard` v5.6.0: the self repository reference

Read 2026-11-16:
- `checks/raw/pinned_dependencies.go` at the tag v5.6.0 (2026-10-12): "`func isSameRepositoryReference(uses string) bool { return strings.HasPrefix(uses, "./") || strings.HasPrefix(uses, "$/") }`", which `isActionDependencyPinned` asks first: a reference by `$/` counts as pinned, as one by `./`. It came with the commit bbcee33, ":bug: Recognize self-repository action references (#5191)", 2026-09-28, which v5.6.0 holds (the GitHub API, `compare/v5.6.0...bbcee33`: `behind`). `scorecard-action` v2.5.0, the commit fa7117d that `scorecard.yml` pins, requires `github.com/ossf/scorecard/v5 v5.6.0` in its `go.mod`.

## 7. Sigstore

### 7.1. cosign

Read 2026-10-21:
- **cosign** v3.1.4 — the latest release, 2026-10-20 (the GitHub API, `repos/sigstore/cosign/releases/latest`); the license is Apache-2.0. The sum of `cosign-linux-amd64` from `cosign_checksums.txt` of the same release is `424e2c97d0b45fd7a6b608a87f090f35633f4c23ece5f092d48bba11aaf4bbfa`, and the downloaded file matched it.

Read 2026-10-22:
- **the OIDC token for cosign** — cosign v3.1.4, the commit 8843105, takes the token from them (sources 2.5): `VariableGitHubRequestToken Variable = "ACTIONS_ID_TOKEN_REQUEST_TOKEN"` in `pkg/cosign/env/env.go`, and the request with it is sent by `pkg/providers/github/github.go`. The signing step of the shared release is a plain `run:`, and signing passes: so the steps of a job see these variables.

### 7.2. Fulcio: signing from a reusable workflow

Read 2026-10-19:
- [Fulcio, OIDC usage](https://github.com/sigstore/fulcio/blob/main/docs/oidc.md), section Case study: GitHub Actions: "GitHub Actions uses the `job_workflow_ref` as its SAN";
- [Fulcio, OID information](https://github.com/sigstore/fulcio/blob/main/docs/oid-info.md), section Mapping OIDC token claims to Fulcio OIDs: `job_workflow_ref` is the Build Signer URI, "Reference to specific build instructions that are responsible for signing. Can be the same as Build Config URI. For example a reusable workflow in GitHub Actions or a Circle CI Orbs"; `workflow_ref` is the Build Config URI, "A reference to the initiating build instructions"; `repository` is the Source Repository URI.

So, together with GitHub's `job_workflow_ref` (sources 2.5), the signature of the shared release names the shared workflow, and the caller's workflow and its repository are in the Build Config URI and the Source Repository URI.

### 7.3. Calls of cosign at once

Read 2026-11-16:
- **the limits of Sigstore's public instance** — none in numbers in what was read: [Sigstore FAQ](https://docs.sigstore.dev/about/faq/) and [sigstore/community, ROADMAP.md](https://github.com/sigstore/community/blob/main/ROADMAP.md) have no word of rate limits. cosign 3.1.4 prints on `sign-blob` that the service "is provided pursuant to the Hosted Project Tools Terms of Use" (the log of the trial #127, measurements 5.12). [LF Projects, Hosted Project Tools Terms of Use](https://lfprojects.org/policies/hosted-project-tools-terms-of-use/), last updated 2023-02-21: "Such access and use shall not exceed a reasonable degree of use appropriate to the nature of the particular Hosted Project Tool", and "The Provider may … suspend access to the Hosted Project Tool if the Provider determines that Your use thereof poses a security or other risk";
- **cosign's TUF cache** — cosign at the tag v3.1.4, commit 0e48502 (the tag object 8843105), `pkg/cosign/tuf.go`: "The cache directory is provided by the user as an environment variable TUF_ROOT, or the default $HOME/.sigstore/root is used", by `opts := tuf.DefaultOptions()` of sigstore-go and `opts.CachePath = tufCacheDir`; its `go.mod` requires `github.com/sigstore/sigstore-go v1.3.0` and `github.com/theupdateframework/go-tuf/v2 v2.4.2`;
- **sigstore-go** v1.3.0, `pkg/tuf/options.go`: "CacheValidity period in days (default 0)", and `DefaultOptions` sets no other — so every call refreshes the metadata; `pkg/tuf/client.go`: the cache lies in `filepath.Join(opts.CachePath, URLToPath(opts.RepositoryBaseURL))`;
- **go-tuf** v2.4.2: `metadata/updater/updater.go`, `persistMetadata` writes a file of metadata to `os.CreateTemp(update.cfg.LocalMetadataDir, "tuf_tmp")`, renames it into place, reads it back and fails — "failed to persist metadata" — when what it reads is not what it wrote; a target, such as the trusted root, is written by `os.WriteFile(filePath, data, 0644)`, in place. `metadata/config/config.go`, `EnsurePathsExist` creates the folders of the cache with `os.MkdirAll(path, 0700)`, so a `TUF_ROOT` that does not exist yet is made.

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
- **`CI`** — Vitest at commit c8558f1: [`browser.headless`](https://github.com/vitest-dev/vitest/blob/c8558f1/docs/config/browser/headless.md) — "**Default:** `process.env.CI`" and "If you are running Vitest in CI, it will be enabled by default"; [`allowOnly`](https://github.com/vitest-dev/vitest/blob/c8558f1/docs/config/allowonly.md) — "**Default:** `!process.env.CI`" and "By default, Vitest does not permit tests marked with the `only` flag in Continuous Integration (CI) environments". That `CI` is set on the runner: sources 2.2.

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
- **the build cache** — [Docker Docs, GitHub Actions cache](https://github.com/docker/docs/blob/773efbb/content/manuals/build/cache/backends/gha.md) at commit 773efbb: "This cache storage backend works with the default `docker` driver only when the containerd image store is enabled" and "If you invoke the `docker buildx` command manually from an inline step, then the variables must be manually exposed. Consider using the `crazy-max/ghaction-github-runtime`, GitHub Action as a helper for exposing the variables". Docker and Buildx on the runner — sources 2.6.

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
