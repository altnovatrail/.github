# .github — sources

> The external facts that the documents of `docs/` stand on: the documentation of GitHub and of other providers, the code of actions and tools at a commit, the answers of the GitHub API and of npm's registry, the tags of `spec`, the files of other repositories. Here are their records: the address, the version or commit, the date read and the quote in the source's language, while [architecture.md](architecture.md) and the log hold the claim and a reference to the record by its number, as to a section: `sources 2.1` (RULES.md spec, The bar; R143 spec).
>
> The results of measurements — trial pull requests and their runs, steps run apart from the workflow, the suite of tests of the steps, durations and sizes — are in [measurements.md](measurements.md).

## 1. How to keep it

- **A record** is a subsection "N.M" of a topic: one source — the pages of one publisher on one subject, the code or files of one project, a tag of `spec` — or one reading of several sources for the sake of one decision. It holds the address, the version, the commit or the date of the page, the date read and the quote in the source's language, word for word. What was read not from the primary source — a copy, a quote from a decision of `spec` — the record names as such.
- **A reading** is a paragraph "Read <date> (<decision or task>):" and the items under it. The readings of one source on different dates are one record, by dates.
- **A reference.** A claim of a document refers to a record by its number, as to a section: `sources 2.1`, and from another repository `sources 2.1 .github`. A record's number does not change: a new record goes to the end of its topic, a new topic to the end of the file.
- **A source read again** is a new reading with its date in the same record, and the earlier text is not edited: the decisions of its day stand on it. If the source has changed and a claim has diverged from it, that is an amendment to the decision or an item of architecture 2, not an edit of the record.
- **What is not here:** the results of measurements — they are in measurements.md, and a record that a trial stood beside names its measurement; the quotes that the entries of the log give themselves — they stay in the entry (RULES.md spec, How we work: a decision is not rewritten).
- **Where from.** The records 2.1–14.2 are the former section "Sources" of architecture 4, sorted out by source on 2026-11-12 (T55). The items were moved word for word; an item where a trial stood beside the quote was cut in two, and both parts refer to each other. Which group of the section went to which records, the table of architecture 4 names. Not from it are the record 13.6 and the readings that name T55.

## 2. GitHub Actions

### 2.1. Reusable workflows

Read 2026-10-19 (R03):
- **calling and pinning** — [GitHub Docs, Reuse workflows](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows), section Calling a reusable workflow: "`{owner}/{repo}/.github/workflows/{filename}@{ref}` for reusable workflows in public and private repositories" and "Using the commit SHA is the safest option for stability and security";
- **the folder** — the same page, section Creating a reusable workflow: "Subdirectories of the `workflows` directory are not supported";
- **limits** — [GitHub Docs, Reusing workflow configurations](https://docs.github.com/en/actions/reference/workflows-and-actions/reusing-workflow-configurations), section Limitations of reusable workflows: "You can connect up to ten levels of workflows" and "You can call a maximum of 50 unique reusable workflows from a single workflow file";
- **permissions** — the same page, section Supported keywords for jobs that call a reusable workflow: "If `jobs.<job_id>.permissions` is not specified in the calling job, the called workflow will have the default permissions for the `GITHUB_TOKEN`" and "The `GITHUB_TOKEN` permissions passed from the caller workflow can be only downgraded (not elevated) by the called workflow";
- **context** — the same page, section `github` context: "When a reusable workflow is triggered by a caller workflow, the `github` context is always associated with the caller workflow";
- **checkout** — [GitHub Docs, Reusing workflow configurations](https://docs.github.com/en/actions/concepts/workflows-and-actions/reusing-workflow-configurations) (Concepts), section Reusable workflows: "if the called workflow uses `actions/checkout`, the action checks out the contents of the repository that hosts the caller workflow, not the called workflow";
- **the check's name** in a ruleset — "`<job name> / <reusable job name>`", a quote of GitHub Docs in R30 spec.

Read 2026-11-01 (the 2026-11-01 amendments to R16 and R19, T34):
- **permissions in a reusable workflow** — [GitHub Docs, Reusing workflow configurations](https://docs.github.com/en/actions/reference/workflows-and-actions/reusing-workflow-configurations): "The `GITHUB_TOKEN` permissions passed from the caller workflow can be only downgraded (not elevated) by the called workflow". How a call without the permission ends, the page does not say. How it ended on the trial — measurements 4.1.

### 2.2. Contexts, variables and events

Read 2026-10-19 (R03):
- **the shared workflow's own files** — [GitHub Docs, Contexts reference](https://docs.github.com/en/actions/reference/workflows-and-actions/contexts), section `job` context: `job.workflow_sha` — "The commit SHA of the workflow file that defines the current job", `job.workflow_repository` — "The `owner/repo` of the repository containing the workflow file that defines the current job"; an example on the same page: "This example reusable workflow uses `job.workflow_repository` and `job.workflow_sha` to check out its own source code, rather than the caller's repository".

Read 2026-10-20 (R10):
- **the `workflow_run` context** — [GitHub Docs, Events that trigger workflows](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows), section `workflow_run`: `GITHUB_SHA` — "Last commit on default branch", `GITHUB_REF` — "Default branch".

Read 2026-10-20 (R12; the amendment to R10):
- **the workflow file** — [GitHub Docs, Workflows](https://docs.github.com/en/actions/concepts/workflows-and-actions/workflows), section Workflow triggers: "Each workflow run will use the version of the workflow that is present in the associated commit SHA or Git ref of the event". For `workflow_run` this is `GITHUB_SHA`, the last commit of the default branch (above, "the `workflow_run` context").

Read 2026-10-21 (R18):
- **`job.workflow_ref`** — [GitHub Docs, Contexts reference](https://docs.github.com/en/actions/reference/workflows-and-actions/contexts), section `job` context: "The full ref of the workflow file that defines the current job".

Read 2026-10-21 (R19):
- **`CI`** — GitHub, [Variables reference](https://github.com/github/docs/blob/efd4783/content/actions/reference/workflows-and-actions/variables.md) at the commit efd4783, Default environment variables: "`CI` | Always set to `true`".

Read 2026-11-01 (R28, T35):
- **default variables** — github/docs at 33b1f4a, `data/reusables/actions/environment-variables-are-fixed.md`: "You can't overwrite the value of the default environment variables named `GITHUB_*` and `RUNNER_*`. Currently you can overwrite the value of the `CI` variable. However, it's not guaranteed that this will always be possible".

Read 2026-11-08 (R33, T48):
- **`job.workflow_repository` and `job.workflow_sha`** — [GitHub Docs, Contexts reference](https://docs.github.com/en/actions/reference/workflows-and-actions/contexts) describes them: "The commit SHA of the workflow file that defines the current job" and "The `owner/repo` of the repository containing the workflow file that defines the current job". That actionlint 1.7.12 does not know them — measurements 2.5.

### 2.3. The step's shell and `set -e`

Read 2026-10-20 (R10):
- **the step's shell** — without `shell` a step on Linux runs as `bash -e {0}`, and with `shell: bash` as `bash --noprofile --norc -eo pipefail {0}`: [GitHub Docs, Workflow syntax](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax), section `defaults.run.shell`.

Read 2026-10-22 (R22, the amendments to R16 and R19, T26):
- **the step's shell** — GitHub Docs, Workflow syntax, `content/actions/reference/workflows-and-actions/workflow-syntax.md` at the commit c67a936 of github/docs: "By default, fail-fast behavior is enforced using `set -e` for both `sh` and `bash`. When `shell: bash` is specified, `-o pipefail` is also applied".

Read 2026-11-01 (R28, T35):
- **the steps' shells** — github/docs at the commit 33b1f4a, `data/reusables/actions/supported-shells.md`. On Linux without `shell` — "`bash -e {0}`", and "Note that this runs a different command to when `bash` is specified explicitly". With `shell: bash` — "`bash --noprofile --norc -eo pipefail {0}`".
- **`set -e` in bash** — [Bash Reference Manual, The Set Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html), edition 5.3:
  - "The shell does not exit if the command that fails is part of the command list immediately following a while or until reserved word, part of the test in an if statement, part of any command executed in a && or || list except the command following the final && or ||";
  - "If a compound command or shell function executes in a context where -e is being ignored, none of the commands executed within the compound command or function body will be affected by the -e setting, even if -e is set and a command returns a failure status".

### 2.4. Secrets, forks and skipped jobs

Read 2026-10-19 (R05):
- [GitHub Docs, Using secrets in GitHub Actions](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets), section Using secrets in a workflow: "With the exception of `GITHUB_TOKEN`, secrets are not passed to the runner when a workflow is triggered from a forked repository";
- [GitHub Docs, Securely using pull_request_target](https://docs.github.com/en/actions/reference/security/securely-using-pull_request_target), section Risks of `pull_request_target`: "Workflows triggered by `pull_request_target` run with elevated trust: the job receives the base repository's `GITHUB_TOKEN` and access to repository and organization secrets"; on the same page: "Workflows triggered by this event should not check out, build, or run code from an untrusted pull request with access to repository secrets or a privileged `GITHUB_TOKEN`";
- [GitHub Docs, Status checks](https://docs.github.com/en/pull-requests/reference/status-checks): "A job that is skipped will report its status as "Success". It will not prevent a pull request from merging, even if it is a required check";
- [GitHub Docs, Dependabot on GitHub Actions](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-on-actions), section Restrictions when Dependabot triggers events: "Secrets are populated from Dependabot secrets. GitHub Actions secrets are not available".

### 2.5. OIDC in GitHub Actions

Read 2026-10-19 (architecture 2.3):
- [GitHub Docs, OpenID Connect reference](https://docs.github.com/en/actions/reference/security/oidc), section Custom claims provided by GitHub, `job_workflow_ref`: "For jobs using a reusable workflow, the ref path to the reusable workflow".

Read 2026-10-22 (the amendments to R10 and R18, T25):
- **the OIDC token in steps** — github/docs at the commit 5815d11, `content/actions/reference/security/oidc.md`, section Methods for requesting the OIDC token: "The following environment variables on the runner" — `ACTIONS_ID_TOKEN_REQUEST_URL` and `ACTIONS_ID_TOKEN_REQUEST_TOKEN`, "Bearer token for the request to the OIDC provider". How cosign reads them — sources 7.1.

Read 2026-10-22 (the amendment to R18, T27):
- **GitHub OIDC** — github/docs at the commit 5815d11, `oidc-with-reusable-workflows.md`: "The `workflow`, `ref`, and other attributes describe the caller workflow, while `job_workflow_ref` refers to the called workflow".

### 2.6. GitHub's runners

Read 2026-10-21 (R19):
- **Docker on the runner** — The ubuntu-24.04 runner has Docker 28.0.4 and Buildx 0.38.0 ([`Ubuntu2404-Readme.md`](https://github.com/actions/runner-images/blob/06f4a91/images/ubuntu/Ubuntu2404-Readme.md) at the commit 06f4a91, image 20261012.334.1).

Read 2026-11-01 (R28, T35):
- **the runner's image** — [`Ubuntu2404-Readme.md`](https://github.com/actions/runner-images/blob/4da2307112a0fad2fd2ecaca8ba7d08683b8c581/images/ubuntu/Ubuntu2404-Readme.md) at the commit 4da2307, image 20261026.354.1: Bash 5.2.21(1)-release, Git 2.56.0, jq 1.7, OpenSSL 3.0.13-0ubuntu3.16, tar 1.35+dfsg-3ubuntu0.4 and yq 4.54.1. In the devcontainer — bash 5.2.21, git 2.56.0, jq 1.7, OpenSSL 3.0.13 and GNU tar 1.35.

Read 2026-11-08 (the 2026-11-08 amendment to R16, T47):
- [GitHub Docs, GitHub-hosted runners reference](https://docs.github.com/en/actions/reference/runners/github-hosted-runners), section Standard GitHub-hosted runners for public repositories: in the table, Linux arm64 has `ubuntu-24.04-arm`, `ubuntu-22.04-arm` and `ubuntu-26.04-arm`, 4 CPU and 16 GB, and "Use of the standard GitHub-hosted runners is free and unlimited on public repositories".

### 2.7. `actions/checkout`

Read 2026-10-20 (R08):
- **actions/checkout** v7.0.1 — the latest release (2026-07-20); the tag points to the commit `3d3c42e5aac5ba805825da76410c181273ba90b1` (the GitHub API, `repos/actions/checkout/git/refs/tags/v7.0.1`).

Read 2026-10-20 (R12; the amendment to R10):
- **checkout v7.0.1 without `ref`** — [`src/input-helper.ts`](https://github.com/actions/checkout/blob/3d3c42e5aac5ba805825da76410c181273ba90b1/src/input-helper.ts) at the commit 3d3c42e. If `ref` is not set, checkout takes the event's ref and commit: `result.ref = github.context.ref` and `result.commit = github.context.sha`.

Read 2026-10-22 (the amendments to R10 and R18, T28):
- **the post step of `actions/checkout`** — v7.0.1 at the commit 3d3c42e, the one pinned in both releases. Its `action.yml` has `post: dist/index.js`, and on the post step `src/main.ts` calls `gitSourceProvider.cleanup(stateHelper.RepositoryPath)`. If the checkout has `.git/config`, `cleanup` in `src/git-source-provider.ts` calls `authHelper.removeAuth()`. And that one, in `src/git-auth-helper.ts`, runs in the checkout `git config --local` and `git submodule foreach --recursive` with `sh -c "git config --local …"`. What this step ran on the trial — measurements 5.4.

Read 2026-10-22 (R22, the amendments to R16 and R19, T26):
- **the `submodules` input** — actions/checkout v7.0.1, the commit 3d3c42e, `src/input-helper.ts`, lines 146–152: `const submodulesString = (core.getInput('submodules') || '').toUpperCase()`, and then a comparison with `'RECURSIVE'` and `'TRUE'`.

### 2.8. `actions/cache`

Read 2026-11-09 (R36, T52):
- **`actions/cache`** — v6.1.0, the latest release, 2026-06-26 (the GitHub API, `repos/actions/cache/releases/latest`); the tag v6.1.0 is the commit 55cc8345863c7cc4c66a329aec7e433d2d1c52a9. The license is MIT: "The MIT License (MIT)", `LICENSE` at the tag. `canvas` pins the same commit in `page.yml` (`main` 66266e1 of `canvas`);
- **entries** — the README at the tag v6.1.0: "The cache is scoped to the key, version, and branch. The default branch cache is available to other branches" ("Cache scopes"); "Cache version is a hash generated for a combination of compression tool used (Gzip, Zstd, etc. based on the runner OS) and the `path` of directories being cached", and an example: "`build-linux` will create two different caches as the `paths` are different" ("Cache Version");
- **saving** — `src/saveImpl.ts` at the tag v6.1.0: the step writes an error of `saveCache` by `utils.logWarning`, and `saveOnlyRun` leaves the cause to the toolkit — "warning for most failures, info for benign concurrency races, error for 5xx"; the job goes on. The README, "Read-only access": "When the cache token is read-only, the save step does not fail the job".

### 2.9. `actions/upload-artifact`

Read 2026-10-20 (R09):
- **actions/upload-artifact** v7.0.2 — the latest release (2026-10-07, `repos/actions/upload-artifact/releases/latest`), the tag points to the commit `cf430e030ddbb5b0abf93d22962f4752f3646cd9` (`repos/actions/upload-artifact/git/refs/tags/v7.0.2`).

Read 2026-11-01 (the 2026-11-01 amendments to R16 and R19, T34):
- **artifact names** — the README of `actions/upload-artifact` at cf430e0, v7.0.2: "Artifact names must be unique since each created artifact is idempotent so multiple jobs cannot modify the same artifact". `spec` already has an artifact `coverage` in its `ci.yml`.

## 3. GitHub: rulesets, releases and the organization

### 3.1. Rulesets, required checks and merge

Read 2026-10-20 (R09):
- **the ruleset's rule on findings** — [GitHub Docs, Available rules for rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets), section Require code scanning results: a merge does not pass if "A required tool finds a code scanning alert of a severity that is defined in the ruleset", "A required tool's analysis is still in progress" or "A required tool is not configured for the repository".

Read 2026-10-20 (R10):
- **the source of a required check** — [GitHub Docs, Available rules for rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets), section Require status checks to pass: "Any person or integration with write permissions to a repository can set the state of any status check in the repository", and so "you can select an app as the expected source of status updates";
- **the message of a squash merge** — [GitHub Docs, About pull request merges](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/about-pull-request-merges), section Merge message for a squash merge: "GitHub generates a default commit message that you can edit. The default message can include the pull request title, pull request description, or commit information, depending on repository settings".

Read 2026-10-20 (R12; the amendment to R10):
- **the `code_scanning` rule** — [GitHub Docs, Set code scanning merge protection](https://docs.github.com/en/code-security/how-tos/find-and-fix-code-vulnerabilities/manage-your-configuration/set-merge-protection): a tool has two thresholds. Alerts — "**None**, **Errors**, **Errors and Warnings** or **All**", Security alerts — "**None**, **Critical**, **High or higher**, **Medium or higher**, or **All**". Which results it trusts — [GitHub Docs, REST API endpoints for rules](https://docs.github.com/en/rest/repos/rules), Update a repository ruleset, the rule `code_scanning`: "When configured, code scanning must be enabled and have results for both the commit and the reference being updated";
- **the ruleset of `.github` after the edit** — the GitHub API, `PUT repos/altnovatrail/.github/rulesets/25477399`, 2026-10-20. The body was put together from `GET`. A comparison before and after showed exactly two edits: the rule `code_scanning` and `allowed_merge_methods: ["merge"]`. `GET repos/altnovatrail/.github/rules/branches/main` names both;
- **the merge method** — [GitHub Docs, Available rules for rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets), section Require a pull request before merging: "Optionally, you can require a merge type of merge, squash, or rebase. This means the targeted branches may only be merged based on the allowed type. Additionally if the repository has disabled a merge method and the ruleset required a different method, the merge will be blocked". `.github` has `allow_merge_commit` on (the GitHub API, `repos/altnovatrail/.github`).

### 3.2. Releases and source code archives

Read 2026-10-20 (R10):
- **immutable releases** — the GitHub API: `PUT repos/altnovatrail/.github/immutable-releases` answered 204, and `GET` of the same path `{"enabled":true,"enforced_by_owner":false}`, as for `spec`. The ruleset `v-tags` — `POST repos/altnovatrail/.github/rulesets` with the rules `update`, `deletion` and `non_fast_forward` on `refs/tags/v*`, with no bypass; the model is the ruleset of `spec` 25426896;
- **the Releases API's refusal** to a commit that is no longer the tip of `main` — [GitHub Docs, REST API endpoints for releases](https://docs.github.com/en/rest/releases/releases), Create a release: "If the commit identified by target_commitish … adds or modifies any file under .github/workflows/ relative to the repository's default branch, the authenticating token must be authorized to modify workflows. Otherwise, this endpoint returns 404 Not Found; some authentication paths surface 403 Resource not accessible by integration instead", and "The GITHUB_TOKEN available to GitHub Actions cannot be authorized for this". How the release of `spec` lets this refusal pass — sources 12.1.

Read 2026-11-01 (R28, T35):
- **source code archives** — github/docs at 33b1f4a, `content/repositories/working-with-files/using-files/downloading-source-code-archives.md`, section Stability of source code archives:
  - "The exact compression settings used to generate a zipball or tarball may change over time. The extracted contents won't change if the branch or tag doesn't change, but the outer compressed archive may have a different byte layout";
  - "If you rely on stability of archives for security (for example: to ensure you don't attempt to unzip a maliciously-crafted file), we recommend using releases instead of using source downloads".

### 3.3. The organization's policy for actions

Read 2026-10-19 (R04):
- [GitHub Docs, Disabling or limiting GitHub Actions for your organization](https://docs.github.com/en/organizations/managing-organization-settings/disabling-or-limiting-github-actions-for-your-organization), section Managing GitHub Actions permissions for your organization: "When you enable **Require actions to be pinned to a full-length commit SHA**, all actions must be pinned to a full-length commit SHA to be used. This includes actions from your organization and actions authored by GitHub. Reusable workflows can still be referenced by tag".

Read 2026-10-20 (R10):
- **the actions policy** — the GitHub API, `repos/altnovatrail/<repository>/actions/permissions`, for `.github`, `spec`, `module-kit` and `tutor`: `enabled: true`, `allowed_actions: all`, `sha_pinning_required: true` (`tutor` — read 2026-10-20, T12).

### 3.4. Community health files, issue forms and the pull request template

Read 2026-11-01 (R29, T37):
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

## 4. Dependabot

### 4.1. GitHub Docs on Dependabot

Read 2026-10-19 (R04):
- [GitHub Docs, About Dependabot version updates](https://docs.github.com/en/code-security/concepts/supply-chain-security/dependabot-version-updates), section Updates for actions: "Dependabot also checks workflow files for uses of reusable workflows, and updates the Git reference for these called reusable workflows";
- [GitHub Docs, Supported ecosystems and repositories](https://docs.github.com/en/code-security/reference/supply-chain-security/supported-ecosystems-and-repositories), section GitHub Actions: "If the commit you use is not associated with any tag, Dependabot will update the GitHub Actions to the latest commit (which might differ from the latest release)" and "Dependabot will ignore actions or reusable workflows referenced locally (for example, `./.github/actions/foo.yml`)". It updates the version comment if that is on the same line — a quote in R30 spec.

Read 2026-10-20 (R12; the amendment to R10):
- **Dependabot's reference** — [GitHub Docs, Dependabot options reference](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference), section `cooldown`. GitHub Actions is among the package managers where `default-days` works, and with no setting "Apply a **default cooldown period of 3 days** to version updates, even when `cooldown` is not configured".

Read 2026-11-08 (the 2026-11-08 amendment to R04, T45):
- [GitHub Docs, Dependabot options reference](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference), section `groups`: "All updates for dependencies that match a rule are combined in a single pull request", "If a dependency matches more than one rule, it's included in the first group that it matches" and "Any outdated dependencies that do not match a rule are updated in individual pull requests". A group's name "must start and end with a letter, and can contain letters, pipes `|`, underscores `_`, or hyphens `-`". Of `patterns`: "Both options support using `*` as a wild card to define matches with dependency names". Whether `*` matches `/` and whether `cooldown` acts on a group, the reference does not say. Section `open-pull-requests-limit`: "If five pull requests with version updates are open, no further pull requests are raised until some of those open requests are merged or closed".

### 4.2. dependabot-core

Read 2026-10-20 (R12; the amendment to R10):
- **the pause for references to a reusable workflow** — [dependabot-core](https://github.com/dependabot/dependabot-core/tree/fda701f49c7d6ba5807e98a06549fdb935e3bd2e), the commit fda701f (`main`, 2026-10-20). By its README, it is "the library at the heart of Dependabot security / version updates". In it:
  - `github_actions/lib/dependabot/github_actions/file_parser.rb` makes a reference to a reusable workflow a dependency, like an action: "For reusable workflows (.github/workflows/*.yml), use the repository name + workflow path to distinguish between different workflow files in the same repository";
  - `update_checker.rb` builds for each dependency a `LatestVersionFinder` with `cooldown_options: update_cooldown`;
  - in `update_checker/latest_version_finder.rb`, `cooldown_enabled?` returns `true`. If the reference is pinned by a SHA that has a tag, the candidates are tags. The date of each is taken by `common/lib/dependabot/git_metadata_fetcher.rb` from a clone: `git for-each-ref --format="%(refname:short) %(creatordate:short)" refs/tags`. `check_if_version_in_cooldown_period?` reads it by `Time.parse`, so the window of three times 86,400 seconds opens at midnight of that day. GitHub's release date — "Priority: GitHub Release published_at > tag creation date > commit date" — the same file takes only when it proposes a bare SHA;
  - `creatordate` — by [the documentation of git](https://github.com/git/git/blob/master/Documentation/git-for-each-ref.adoc) (`git-for-each-ref`): "For commit and tag objects, the special `creatordate` and `creator` fields will correspond to the appropriate date or name-email-date tuple from the `committer` or `tagger` fields depending on the object type". The tag `v0.1.0` is lightweight, it points straight at the commit (the GitHub API, `repos/altnovatrail/.github/git/refs/tags/v0.1.0`: the object `commit`). The commit is 2026-10-20T13:17:26Z, the release 13:18:27Z;
  - the pause came to this ecosystem with #12486 (2025-06-20), its flag was removed in #12577 (2025-07-08), and Dependabot has raised reusable workflows since the commit dcf1e27 "Allow updating reusable workflows" (2023-02-17) — by the history of the files in the GitHub API.

Read 2026-10-21 (the amendment to R19):
- **Dependabot and the Dockerfile** — [`docker/lib/dependabot/docker/file_parser.rb`](https://github.com/dependabot/dependabot-core/blob/fda701f/docker/lib/dependabot/docker/file_parser.rb) of dependabot-core at the commit fda701f, 2026-10-20. `parse` goes through the lines of the Dockerfile and skips each one that does not match `FROM_LINE` — "`next unless FROM_LINE.match?(line)`" — and `FROM_LINE` starts with `^#{FROM}\s+`. It does not read a line `COPY --from`.

Read 2026-11-08 (the 2026-11-08 amendment to R04, T45):
- **dependabot-core** at the commit [fda701f](https://github.com/dependabot/dependabot-core/tree/fda701f49c7d6ba5807e98a06549fdb935e3bd2e), 2026-10-20:
  - `common/lib/wildcard_matcher.rb` — a pattern is split by `*`, the parts are escaped by `Regexp.quote` and joined by `.*`, and the comparison is `downcase` on both sides. `.*` matches `/` too;
  - `common/lib/dependabot/dependency_group.rb` — `contains?` checks the dependency's name, `dependency.name`, against `patterns` by `WildcardMatcher.match?`;
  - `github_actions/lib/dependabot/github_actions/file_parser.rb` — "For reusable workflows (.github/workflows/*.yml), use the repository name + workflow path", `name = "#{repo_name}#{path}"`. That is what Dependabot's pull requests in `spec` are called, "Bump altnovatrail/.github/.github/workflows/<file>.yml" (architecture 2.6). It does not parse a reference by a local path: "TODO: Support Docker references and path references";
  - `updater/lib/dependabot/updater/group_update_creation.rb` — a group's update takes for each dependency `update_checker_for` with `update_cooldown: job.cooldown`, as a single update does in `operations/update_all_versions.rb`.

### 4.3. Dependabot's pull requests in `spec`

Read 2026-11-01 (R25, T31):
- **Dependabot in `spec`** — the pull requests #40–#42, "Bump altnovatrail/.github/.github/workflows/<file>.yml from 0.1.0 to 0.1.3", opened and merged 2026-10-23, and #49–#51, "from 0.1.3 to 0.1.10", opened 2026-10-26. The commit of #40 has the author `dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>`, the committer `GitHub <noreply@github.com>`, the sign-off `Signed-off-by: dependabot[bot] <support@github.com>`, and "DCO / sign-off" is success. The releases of `.github`: v0.1.3 — 2026-10-21T04:50:54Z, the commit of its tag — 2026-10-20T23:49:54-05:00; v0.1.4 — 2026-10-21T15:30:24Z; v0.1.10 — 2026-10-22T18:09:38Z (`gh release list`, `git log -1 --format=%cI <tag>`).

## 5. CodeQL

### 5.1. `github/codeql-action`

Read 2026-10-19 (R03):
- [codeql-action, README](https://github.com/github/codeql-action), section Workflow Permissions: "All advanced setup code scanning workflows must have the `security-events: write` permission".

Read 2026-10-20 (R09):
- **github/codeql-action** v4.39.0 — the newest tag `v4.*` by `git ls-remote --tags https://github.com/github/codeql-action` (released 2026-10-15, the GitHub API, `repos/github/codeql-action/releases/tags/v4.39.0`). The repository's latest "release" is a CodeQL bundle, not a version of the action. The tag is annotated, 48870fd, and points to the commit `6f2ac81f5cd81fe351a197ba0b00d91d03cd2aee` (`repos/github/codeql-action/git/tags/48870fdd6b42ee6474ec4207209ff87609271a5e`). The inputs of `init` of this version are `languages`, `build-mode`, `queries` (`init/action.yml` at the tag v4.39.0);
- **the CodeQL bundle** — `init/action.yml` at the commit 6f2ac81, the input `tools`: "A special value `linked` which uses the version of the CodeQL tools that the Action has been bundled with", and without the input "the Action will check in several places until it finds the CodeQL tools". In `src/setup-codeql.ts` of the same commit, without the input `defaultCliVersion.enabledVersions[0]` is taken — the version from GitHub's flags, and with `linked` the version from `src/defaults.json`, `"cliVersion": "2.27.2"`. A trial run confirmed it — measurements 1.1.

Read 2026-10-20 (the amendment to R09, T14):
- **the `config` input** of `init` — `init/action.yml` at the commit 6f2ac81 (v4.39.0): "Configuration passed as a YAML string in the same format as the config-file input. This takes precedence over the config-file input". An empty input is the same as an absent one: `getOptionalInput` in `src/actions-util.ts` of the same commit returns `undefined` for an empty string, and `src/init-action.ts` parses `config` only if it is set;
- **the repository property `github-codeql-config-file`** — besides the input `config-file`, `init` can take the configuration file from the repository property `github-codeql-config-file`. It is read by `getConfigFileInput` in `src/config/file.ts` at 6f2ac81, behind the flag `config_file_repository_property`, and the property's name is set in `src/feature-flags/properties.ts`. If a file and `config` come together, `init` takes only `config`: "Both a config file and config input were provided. Ignoring config file." (`src/config-utils.ts`). The organization's schema of properties is empty (the GitHub API, `orgs/altnovatrail/properties/schema`, 2026-10-20), so no repository has such a property.

Read 2026-10-21 (the amendment to R09, T19):
- **an explicit build mode** — [`src/codeql.ts`](https://github.com/github/codeql-action/blob/6f2ac81f5cd81fe351a197ba0b00d91d03cd2aee/src/codeql.ts) of codeql-action at the commit 6f2ac81, v4.39.0: `extractUsingBuildMode` runs `codeql database trace-command --use-build-mode`, and with `autobuild` and a failure answers "We were unable to automatically build your code". No separate step `autobuild` is needed: [`src/analyze-action.ts`](https://github.com/github/codeql-action/blob/6f2ac81f5cd81fe351a197ba0b00d91d03cd2aee/src/analyze-action.ts) of the same commit skips the old autobuild of Go — "Skipping legacy Go autobuild since a build mode has been specified".

### 5.2. GitHub Docs on code scanning

Read 2026-10-19 (R03):
- [GitHub Docs, Workflow configuration options](https://docs.github.com/en/code-security/reference/code-scanning/workflow-configuration-options), section Analysis category: "If you don't specify a `category` parameter in your workflow, GitHub will generate a category name for you, based on the name of the workflow file triggering the action, the action name, and any matrix variables". A shared workflow has one file name for all repositories, so `category` is set explicitly;
- default setup and a repository's own workflow do not work together — a quote in T15 `spec`, «Выяснилось при планировании».

Read 2026-10-20 (R09):
- **findings and merge** — [GitHub Docs, Triaging code scanning alerts in pull requests](https://docs.github.com/en/code-security/how-tos/manage-security-alerts/manage-code-scanning-alerts/triage-alerts-in-pull-requests): "the check that contains the results of code scanning is: Code scanning results" and "If the code scanning results check finds any problems with a severity of `error`, `critical`, or `high`, the check fails". What this check is called on a pull request — measurements 1.1;
- **building for CodeQL** — [GitHub Docs, CodeQL build options and steps for compiled languages](https://docs.github.com/en/code-security/reference/code-scanning/codeql/build-options-for-compiled-languages), section Building Go: "CodeQL supports build modes `autobuild` or `manual` for Go code" — without a build, `none`, Go is not analysed.

Read 2026-10-20 (the amendment to R09, T14):
- **`paths-ignore`** — [GitHub Docs, Workflow configuration options](https://docs.github.com/en/code-security/reference/code-scanning/workflow-configuration-options):
  - section Specifying directories to scan: "You can use this option when you run the CodeQL actions on an interpreted language (Python, Ruby, and JavaScript/TypeScript) or when you analyze a compiled language without building the code (currently supported for C/C++, C#, Java and Rust)". The documentation does not name the language `actions`, while the Actions extractor takes the paths into account (sources 5.3);
  - on the same page, of patterns: "`**` characters can only be at the start or end of a line, or surrounded by slashes" and "You'll need to quote anything that contains a `*` character";
  - section Configuration details: the value of the input `config` "must be a YAML string that follows the configuration file format".

### 5.3. `github/codeql` at the tag codeql-cli/v2.27.2

Read 2026-10-20 (the amendment to R09, T14):
- **`paths-ignore` of the Actions extractor** — [`actions/extractor/tools/autobuild.sh`](https://github.com/github/codeql/blob/codeql-cli/v2.27.2/actions/extractor/tools/autobuild.sh) in github/codeql at the tag codeql-cli/v2.27.2 says: "If the user provided `paths-ignore`, those patterns are excluded". The documentation does not name the language `actions` in the section Specifying directories to scan (sources 5.2); the trial — measurements 1.2.

Read 2026-10-21 (the amendment to R09, T19):
- **Go's autobuild** — [`go/extractor/autobuilder/autobuilder.go`](https://github.com/github/codeql/blob/codeql-cli/v2.27.2/go/extractor/autobuilder/autobuilder.go) in github/codeql at the tag codeql-cli/v2.27.2: "If a project is accompanied by a build script (such as a makefile), then we try executing such", and the list — `make` for Makefile, makefile and GNUmakefile, `ninja` for build.ninja, `./build` and `./build.sh`.

## 6. Scorecard

### 6.1. `scorecard-action` and `scorecard-webapp`

Read 2026-10-19 (R03; architecture 2.2):
- [scorecard-action v2.5.0, README](https://github.com/ossf/scorecard-action/blob/v2.5.0/README.md), section Workflow Restrictions: "The workflow can't contain top level env vars or defaults", "No workflow level write permissions", "Only the job with `ossf/scorecard-action` can use `id-token: write` permissions", and for its job — "The steps running in this job must belong to this approved list of GitHub actions:" `actions/checkout`, `actions/upload-artifact`, `github/codeql-action/upload-sarif`, `ossf/scorecard-action`, `step-security/harden-runner`. The triggers are `push` and `schedule` on the default branch, a quote in R30 spec;
- [scorecard-webapp, PR #778](https://github.com/ossf/scorecard-webapp/pull/778) "Fix default branch verification", merged 2025-04-16: "This PR modifies the verification procedure to use the repository of the **calling** workflow instead";
- that the server rejected the result, v2.5.0 does not count as an error: [`signing/signing.go`](https://github.com/ossf/scorecard-action/blob/fa7117db83c52d787ae5a89f350999701505d78e/signing/signing.go), the function `ProcessSignature`, on a failed publication writes `::warning::Unable to POST scorecard results to webapp` and returns `nil`. The commit fa7117d is the tag v2.5.0; read 2026-10-20;
- there is no input `fail_on_publish_error` in v2.5.0: neither the README nor `action.yaml` of this tag names it. `main` has it since 2026-10-14 (the commit 1dfaf3539e, #1721): "Fail the step when the Scorecard API rejects published results". It will come with the next release.

Read 2026-11-12 (T55; the comment of `scorecard.yml`):
- [scorecard-action v2.5.0, README](https://github.com/ossf/scorecard-action/blob/v2.5.0/README.md), section Workflow Restrictions: the server sets the rules — "our API enforces certain rules on the producing workflow, which may reject the results and cause the Scorecard Action run to fail", — and the subsection Restrictions on the job containing `ossf/scorecard-action` names three more for the job: "No job level env vars or defaults", "No containers or services" and "The job should run on one of the Ubuntu hosted runners".

### 6.2. `ossf/scorecard` at the commit 61e8474

Read 2026-10-20 (R10):
- **Scorecard's Dangerous-Workflow** — [`checks/raw/dangerous_workflow.go`](https://github.com/ossf/scorecard/blob/61e84743356275f6ffca23b1b2f2cb945e19eb96/checks/raw/dangerous_workflow.go) at the commit 61e8474, the version of Scorecard, v5.6.0, by which the server scored `.github` (the field `scorecard` in the answer of Scorecard's API). In a workflow with the trigger `pull_request_target` or `workflow_run`, the function `checkJobForUntrustedCodeCheckout` marks a checkout whose `ref` contains `github.event.pull_request` or `github.event.workflow_run`; it does not read the job's `if` condition;
- **the risk of Dangerous-Workflow** — [`docs/checks.md`](https://github.com/ossf/scorecard/blob/61e84743356275f6ffca23b1b2f2cb945e19eb96/docs/checks.md) of Scorecard at the same commit: "Risk: `Critical` (vulnerable to repository compromise)".

Read 2026-10-20 (R12; the amendment to R10):
- **checkout without `ref` in Scorecard** — in [`checks/raw/dangerous_workflow.go`](https://github.com/ossf/scorecard/blob/61e84743356275f6ffca23b1b2f2cb945e19eb96/checks/raw/dangerous_workflow.go) at the commit 61e8474, the function `checkJobForUntrustedCodeCheckout` skips a step without the input `ref`: `if !ok || ref.Value == nil { continue }`. The function `validateScriptInjection` looks for an injection only in `run:`, by a list of contexts, and `head_sha` is not in it;
- **npm in Scorecard** — in [`checks/raw/shell_download_validate.go`](https://github.com/ossf/scorecard/blob/61e84743356275f6ffca23b1b2f2cb945e19eb96/checks/raw/shell_download_validate.go) at 61e8474, the function `isNpmUnpinnedDownload` leaves unmarked only `npm ci` — "`npm ci` will verify all hashes are present" — and a package from git pinned by a commit hash. The other install commands of npm it marks. The code scanning finding #2 is line 113 of `.devcontainer/Dockerfile`, Pinned-Dependencies — 8. The archives that the Dockerfile downloads by curl and unpacks by tar it did not mark: `.github` has no other findings of Pinned-Dependencies (В12 RUN.md, now R34 spec).

### 6.3. Scorecard's API

Read 2026-10-20 (R09):
- **Scorecard's API** — `https://api.scorecard.dev/projects/github.com/<owner>/<repository>`: an accepted result comes with the date, the repository's commit and the score — the fields `date`, `repo.commit`, `score` in the answer for `ossf/scorecard`; a repository without a published result gets 404, as `spec` does.

## 7. Sigstore

### 7.1. cosign

Read 2026-10-21 (R18):
- **cosign** v3.1.4 — the latest release, 2026-10-20 (the GitHub API, `repos/sigstore/cosign/releases/latest`); the license is Apache-2.0. The sum of `cosign-linux-amd64` from `cosign_checksums.txt` of the same release is `424e2c97d0b45fd7a6b608a87f090f35633f4c23ece5f092d48bba11aaf4bbfa`, and the downloaded file matched it.

Read 2026-10-22 (the amendments to R10 and R18, T25):
- **the OIDC token for cosign** — cosign v3.1.4, the commit 8843105, takes the token from them (sources 2.5): `VariableGitHubRequestToken Variable = "ACTIONS_ID_TOKEN_REQUEST_TOKEN"` in `pkg/cosign/env/env.go`, and the request with it is sent by `pkg/providers/github/github.go`. The signing step of the shared release is a plain `run:`, and signing passes: so the steps of a job see these variables.

### 7.2. Fulcio: signing from a reusable workflow

Read 2026-10-19 (architecture 2.3):
- [Fulcio, OIDC usage](https://github.com/sigstore/fulcio/blob/main/docs/oidc.md), section Case study: GitHub Actions: "GitHub Actions uses the `job_workflow_ref` as its SAN";
- [Fulcio, OID information](https://github.com/sigstore/fulcio/blob/main/docs/oid-info.md), section Mapping OIDC token claims to Fulcio OIDs: `job_workflow_ref` is the Build Signer URI, "Reference to specific build instructions that are responsible for signing. Can be the same as Build Config URI. For example a reusable workflow in GitHub Actions or a Circle CI Orbs"; `workflow_ref` is the Build Config URI, "A reference to the initiating build instructions"; `repository` is the Source Repository URI.

So, together with GitHub's `job_workflow_ref` (sources 2.5), the signature of the shared release names the shared workflow, and the caller's workflow and its repository are in the Build Config URI and the Source Repository URI.

## 8. npm

### 8.1. npm's documentation

Read 2026-10-20 (R12; the amendment to R10):
- **integrity in npm** — npm's documentation, [`npm cache`](https://github.com/npm/cli/blob/ae98c62586b6fea44114f72e249e246a2981de70/docs/lib/content/commands/npm-cache.md) on the branch `latest` of npm/cli, the commit ae98c62: "All data that passes through the cache is fully verified for integrity on both insertion and extraction". Which hash npm checks against without a lock file, this page does not say, and the repository has no hash.

Read 2026-10-21 (R19):
- **npm** — Node 24.21.0 comes with npm 11.19.0: [nodejs.org/dist/index.json](https://nodejs.org/dist/index.json), the entry `v24.21.0` — `"npm":"11.19.0"`. npm's documentation site shows v11 in the edition 11.21.0. The definition of `ignore-scripts` below is the same in npm's sources at the tag v11.19.0, the commit bfacd33: `workspaces/config/lib/definitions/definitions.js`;
- **`npm ci`** — [npm Docs, npm ci](https://docs.npmjs.com/cli/v11/commands/npm-ci): "The project **must** have an existing `package-lock.json` or `npm-shrinkwrap.json`", "If dependencies in the package lock do not match those in `package.json`, `npm ci` will exit with an error, instead of updating the package lock" and "It will never write to `package.json` or any of the package-locks: installs are essentially frozen";
- **`ignore-scripts`** — the same page, section Configuration: "If true, npm does not run scripts specified in package.json files. Note that commands explicitly intended to run a particular script, such as `npm start`, `npm stop`, `npm restart`, `npm test`, and `npm run` will still run their intended script if `ignore-scripts` is set, but they will *not* run any pre- or post-scripts". An environment variable sets the same — [npm Docs, config](https://docs.npmjs.com/cli/v11/using-npm/config): "Any environment variables that start with `npm_config_` will be interpreted as a configuration parameter";
- **`npm audit`** — [npm Docs, npm audit](https://docs.npmjs.com/cli/v11/commands/npm-audit): "The audit command submits a description of the dependencies configured in your project to your default registry and asks for a report of known vulnerabilities" — it needs the network. Of `--audit-level`: "This option does not filter the report output, it simply changes the command's failure threshold".

Read 2026-10-22 (the amendment to R18, T27):
- **trusted publishing** — npm/documentation at the commit 7e98ab4, `content/packages-and-modules/securing-your-code/trusted-publishers.mdx`:
  - "Trusted publishing requires npm CLI version 11.5.1 or later and Node version 22.14.0 or higher";
  - of a reusable workflow: "validation checks the calling workflow's name instead of the workflow that actually contains the publish command", and "The `id-token: write` permission must also be given to both parent and child workflows";
  - "Configurations created after Sep 03, 2026 are automatically set to allow `npm stage publish`, and you can choose whether to also permit direct publishing with `npm publish`", and "A newly created trusted publisher configuration must complete its first successful publish within 2 days";
  - provenance: "npm automatically generates and publishes provenance attestations … you don't need to add the `--provenance` flag", and "your package's `repository.url` field in `package.json` must exactly match your GitHub repository".

Read 2026-11-01 (R25, T31):
- **trusted publishing and a reusable workflow** — the page [npm Docs, Trusted publishing](https://docs.npmjs.com/trusted-publishers) says the same as npm/documentation at 7e98ab4: "validation checks the calling workflow's name instead of the workflow that actually contains the publish command".

Read 2026-11-01 (the 2026-11-01 amendment to R18, T33):
- **npm/documentation** — the commit c62df53, 2023-10-23, the last commit of the file `content/policies/unpublish.mdx`:
  - "So if you've ever published a package called "bob" at version 1.1.0, no other package can ever be published with that name at that version. This is true even if that package is unpublished";
  - "Once `package@version` has been used, you can never use it again. You must publish a new version even if you unpublished the old one";
  - "If you entirely unpublish all versions of a package, you may not publish any new versions of that package until 24 hours have passed".

Read 2026-11-02 (the 2026-11-02 amendment to R18, T42):
- **trusted publishing** — `content/packages-and-modules/securing-your-code/trusted-publishers.mdx` of npm/documentation, the last commit 5152d27 of 2026-10-06: "validation checks the calling workflow's name instead of the workflow that actually contains the publish command", and "The `id-token: write` permission must also be given to both parent and child workflows". Provenance — "when all of these conditions are met": trusted publishing, a public repository, a public package. Of a reusable workflow of another repository the document says nothing.

### 8.2. `npm/cli`

Read 2026-10-22 (the amendment to R18, T27):
- **`npm trust`** — npm/cli v11.19.0, `docs/lib/content/commands/npm-trust.md`: "Package must exist: The package you're configuring must already exist on the npm registry". `lib/trust-cmd.js` allows publishing by the flag `--allow-publish`, and staged publishing by `--allow-stage-publish`;
- **npm CLI 11.19.1**, the one that comes with Node 24.22.1. It does not differ from 11.19.0 in `lib/utils/oidc.js`, `lib/commands/publish.js`, libnpmpublish and npm-registry-fetch (`gh api repos/npm/cli/compare/v11.19.0...v11.19.1`):
  - `oidc.js` without `ACTIONS_ID_TOKEN_REQUEST_URL` and `_TOKEN` skips the exchange — "Skipped because incorrect permissions for id-token within GitHub workflow", at the level silly. A refusal of the exchange and its success it writes at the level verbose: "Failed token exchange request with body message: …", "Successfully retrieved and set token";
  - `publish.js` calls the exchange before the branch `--dry-run` (line 147). The package's scripts run only when a folder is published. Since npm 11.0.0 it does not publish a version below the highest one without a tag: "Cannot implicitly apply the "latest" tag because previously published version … is higher than the new version";
  - npm's license is Artistic-2.0 (npm's `package.json`), and `spec/tools/licenses/config.mjs` v0.2.21 does not have it.

Read 2026-11-01 (the 2026-11-01 amendment to R18, T33):
- **npm** — `lib/commands/view.js` of npm 11.19.0 from the devcontainer, lines 151–157: on `pckmnt.time?.unpublished` the command throws an error "Unpublished on ${u.time}" with `statusCode: 404` and `code: 'E404'`. Between v11.19.0 and v11.19.1, 33 files changed. Of the files of `view` and `publish`, only `test/lib/commands/publish.js` is among them (`gh api repos/npm/cli/compare/v11.19.0...v11.19.1`).

### 8.3. npm's registry

Read 2026-10-22 (the amendment to R18, T27):
- **the registry's cache** — 2026-10-22. `https://registry.npmjs.org/semver` answers `cf-cache-status: HIT`, `cache-control: public, max-age=300` and `age` over a hundred seconds, even to a request with `Cache-Control: no-cache`. With `?write=true` the answer is `cf-cache-status: DYNAMIC`. npm-registry-fetch, which comes with npm 11.19.1, does not cache such a GET: "do not cache, because this GET is fetching a rev that will be used for a subsequent PUT or DELETE" (`lib/index.js`).

Read 2026-11-01 (R25, T31):
- **the publication of `spec` to npm** — `https://registry.npmjs.org/@altnovatrail%2fspec`: `latest` is 0.4.1, which came out 2026-10-29T20:31:01Z, with `dist.attestations`, provenance `https://slsa.dev/provenance/v1`; 0.4.0, which the author of `spec` published by hand, has no provenance. The npm steps of `spec`'s `release.yml` are the steps of the shared `release.yml` v0.1.10 with the differences that T51 `spec` names.

Read 2026-11-01 (the 2026-11-01 amendment to R18, T33):
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

Read 2026-11-02 (R31, T40):
- **the documents of packages unpublished whole**, by the step of `spec` (sources 12.7) — `curl https://registry.npmjs.org/<name>?write=true`, 2026-11-02:
  - for `asdasd`, `aaaaaaa` and `test-unpublish`, `versions` is empty, and `time` has `created`, `modified`, `unpublished` and every number the package held: `1.0.0`; `2.0.0`, `1.0.0`, `1.0.1`, `3.0.0`, `4.0.0` and `4.0.1`; `0.0.1` and `0.0.0`;
  - `time.unpublished.versions` has the numbers the package held last: `["1.0.0"]`, `["1.0.0","1.0.1","3.0.0","4.0.0"]` and `["0.0.0"]`. The numbers unpublished earlier — `2.0.0` and `4.0.1` for `aaaaaaa`, `0.0.1` for `test-unpublish` — are only in `time`;
  - corrected 2026-11-02 in T42: the first reading took from `time` only `created`, `modified` and `unpublished` — a jq filter — and so lost the keys of the numbers. On it stood В34 and the words of the amendment of T40 to R18 that the shared step does not find such a number; that is wrong (the amendment of T42 to R18).

Read 2026-11-02 (the 2026-11-02 amendment to R18, T42):
- **the documents of packages unpublished whole** — the same as above, in the reading of T40, read whole: `curl https://registry.npmjs.org/<name>?write=true | jq '{keys: keys, versions: (.versions // {} | keys), time: .time}'`. The document's keys are `_id`, `_rev`, `name` and `time`, and `time` has every number the package held. The earlier step `(.time // {}) | has($v)` did find such a number.

### 8.4. The open bugs of `npm/cli`

Read 2026-10-22 (the amendment to R18, T27):
- **npm's open bugs** — npm/cli#9889: `npm publish` exits with 0 while the version is only staged. npm/cli#9969: OIDC for repositories with GitHub's immutable subject.

Read 2026-11-01 (R25, T31):
- **the immutable OIDC subject** — the GitHub API, `repos/altnovatrail/<repository>/actions/oidc/customization/sub`: `spec` and `canvas` have `"use_immutable_subject":true`, the prefixes `repo:altnovatrail@344507087/spec@1424771727` and `repo:altnovatrail@344507087/canvas@1425820257`. npm/cli#9969 — "OIDC trusted publishing fails with "package not found" for GitHub repos that use immutable OIDC subject claims" — is open, updated 2026-10-28; npm/cli#9889 is open too (the GitHub API).

Read 2026-11-02 (the 2026-11-02 amendment to R18, T42):
- **npm's open bugs** (Д7 in RUN.md) — [npm/cli#9969](https://github.com/npm/cli/issues/9969) — open, updated 2026-10-28; [npm/cli#9889](https://github.com/npm/cli/issues/9889) — open, updated 2026-10-22.

## 9. Node, browsers and the TypeScript tests

### 9.1. Node

Read 2026-10-22 (the amendment to R18, T27):
- **Node** — `https://nodejs.org/dist/index.json`: v24.22.1, 2026-10-20, npm 11.19.1, `security: true`. In the `SHASUMS256.txt` of v24.22.1 — `6c172a9ab6718f7b801fb5a7bd486af2ee5e32758086a04b84fcce2aa77095e6  node-v24.22.1-linux-x64.tar.xz`, and the downloaded archive matched it.

Read 2026-11-13 (R39, T58), the documentation of Node v24.21.0, the version of the `toolchain` stage:
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

Read 2026-10-21 (R19):
- **Playwright in Docker** — [`docs/src/docker.md`](https://github.com/microsoft/playwright/blob/66070a1/docs/src/docker.md) at commit 66070a1, section Recommended Docker Configuration: "Using `--init` Docker flag is recommended to avoid special treatment for processes with PID=1. This is a common reason for zombie processes" and "Using `--ipc=host` is recommended when using Chromium. Without it, Chromium can run out of memory and crash". Playwright — v1.64.1, Apache-2.0 (the GitHub API);
  - [`docs/src/browsers.md`](https://github.com/microsoft/playwright/blob/66070a1/docs/src/browsers.md), ibid.: "Each version of Playwright needs specific versions of browser binaries to operate". The browsers lie in "`~/.cache/ms-playwright` on Linux", and `PLAYWRIGHT_BROWSERS_PATH` sets another path;
  - the Playwright image sets `ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright` and installs the browsers there ([`utils/docker/Dockerfile.noble`](https://github.com/microsoft/playwright/blob/66070a1/utils/docker/Dockerfile.noble), ibid.);
  - the browsers' system packages are installed by `apt-get install`, and, when not root, through sudo: "Switching to root user to install dependencies..." ([`dependencies.ts`](https://github.com/microsoft/playwright/blob/66070a1/packages/playwright-core/src/server/registry/dependencies.ts), ibid.);
  - neither the documentation nor the downloader names sums of the browser downloads: no check of a sum was found in `browserFetcher.ts` and `registry/index.ts`. This is the result of a search, not the documentation's words;
- **the Playwright image** — `mcr.microsoft.com/playwright:v1.64.1-noble`, the index `sha256:7852dc5a7d72f5fe458a597d690f6c42fbc8e9e26ddfa95f8e6ef552558d9bbf`; amd64 — `sha256:bdfda2a8fdf48707c5e50a49bd3e06d8d0c759153dc8ee057d8a81c3450bb3e9`, 986,271,382 bytes compressed, in seven layers (the MCR registry). `utils/docker/Dockerfile.noble` at the tag v1.64.1 installs into `/ms-playwright` chromium with the headless shell and ffmpeg, firefox and webkit, and the system libraries by `install-deps`, outside that folder. [`docs/src/docker.md`](https://github.com/microsoft/playwright/blob/v1.64.1/docs/src/docker.md) at the tag v1.64.1: "This image includes the Playwright browsers and browser system dependencies. The Playwright package/dependency is not included in the image" and "If the Playwright version in your Docker image does not match the version in your project/tests, Playwright will be unable to locate browser executables";
- **Chromium's system libraries** — [`nativeDeps.ts`](https://github.com/microsoft/playwright/blob/v1.64.1/packages/playwright-core/src/server/registry/nativeDeps.ts) at the tag v1.64.1, the entry `ubuntu24.04-x64`, `chromium`: 21 packages, from `libasound2t64` to `libxrandr2`. `install-deps` installs them by `apt-get install -y --no-install-recommends`, with no versions.

Read 2026-10-21 (the amendment to R19):
- **Chrome for Testing** — Playwright's [`docs/src/release-notes-js.md`](https://github.com/microsoft/playwright/blob/v1.64.1/docs/src/release-notes-js.md) at the tag v1.64.1, commit cfe490d, section Version 1.57: "Playwright now runs on Chrome for Testing builds rather than Chromium. Headed mode uses `chrome`; headless mode uses `chrome-headless-shell`". In [`registry/index.ts`](https://github.com/microsoft/playwright/blob/v1.64.1/packages/playwright-core/src/server/registry/index.ts) ibid., `chromium` and `chromium-headless-shell` for `ubuntu24.04-x64` have `cftUrl(…)`, the path `builds/cft/${browserVersion}/…` on `https://cdn.playwright.dev`. Firefox, WebKit and FFmpeg have paths of their own — `builds/firefox/…`, `builds/webkit/…` and `builds/ffmpeg/…`;
- **the folder in the image** — R13 canvas and architecture 4 canvas at 88492c4. In the layer of the v1.64.1 image with `playwright-core install chromium` lie `chromium-1248` with `WidevineCdm/LICENSE`, `chromium_headless_shell-1248` and `ffmpeg-1013`. The `ABOUT` of Chrome Headless Shell: "Google Chrome … Copyright 2026 Google LLC. All rights reserved … See the Terms of Service at chrome://terms". The binary itself calls itself "Google Chrome for Testing 156.0.8078.4", and the folder takes 273 MB.

### 9.3. Vitest and istanbul

Read 2026-10-21 (R19):
- **Vitest in the browser** — [Vitest, Browser Mode](https://vitest.dev/guide/browser): "Vitest always requires a provider to be defined. You can chose either `preview`, `playwright` or `webdriverio`" and "to run tests in CI you need to install either `playwright` or `webdriverio`";
- **`CI`** — Vitest at commit c8558f1: [`browser.headless`](https://github.com/vitest-dev/vitest/blob/c8558f1/docs/config/browser/headless.md) — "**Default:** `process.env.CI`" and "If you are running Vitest in CI, it will be enabled by default"; [`allowOnly`](https://github.com/vitest-dev/vitest/blob/c8558f1/docs/config/allowonly.md) — "**Default:** `!process.env.CI`" and "By default, Vitest does not permit tests marked with the `only` flag in Continuous Integration (CI) environments". That `CI` is set on the runner: sources 2.2.

Read 2026-11-01 (the 2026-11-01 amendments to R16 and R19, T34):
- **Vitest** — vitest-dev/vitest on `main` 2debb4e, the latest release v5.0.5:
  - `docs/guide/coverage.md`: "By default Vitest will show only files that were imported during test run. To include uncovered files in the report, you'll need to configure `coverage.include` with a pattern that will pick your source files";
  - `docs/config/coverage.md`: `coverage.reportsDirectory` has "Default: `'./coverage'`", and "Vitest will delete this directory before running tests if `coverage.clean` is enabled (default value)";
  - the file's name — istanbuljs/istanbuljs on `main` 28ffdbc, `packages/istanbul-reports`: `lcovonly` writes `opts.file || 'lcov.info'`, and `lcov` the same `lcov.info` and HTML in `lcov-report`.

### 9.4. OSV-Scanner

Read 2026-10-21 (R19):
- **OSV-Scanner** — v2.7.0, 2026-10-12 (the GitHub API, `repos/google/osv-scanner/releases/latest`), Apache-2.0, the release holds `osv-scanner_SHA256SUMS`. [Offline Mode](https://google.github.io/osv-scanner/usage/offline-mode/): "Offline scanning checks your project against a local database instead of calling the OSV.dev API" and "When a local database is not present, you will get an error message".

### 9.5. Docker: the build cache

Read 2026-10-21 (R19):
- **the build cache** — [Docker Docs, GitHub Actions cache](https://github.com/docker/docs/blob/773efbb/content/manuals/build/cache/backends/gha.md) at commit 773efbb: "This cache storage backend works with the default `docker` driver only when the containerd image store is enabled" and "If you invoke the `docker buildx` command manually from an inline step, then the variables must be manually exposed. Consider using the `crazy-max/ghaction-github-runtime`, GitHub Action as a helper for exposing the variables". Docker and Buildx on the runner — sources 2.6.

### 9.6. Ubuntu Snapshot Service

Read 2026-10-21 (R19):
- **the Ubuntu archive at a date** — [Ubuntu Snapshot Service](https://snapshot.ubuntu.com/): "The Ubuntu snapshot service makes it possible to see and use the Ubuntu archive as it was at any specified date and time", "Snapshots of the Ubuntu archive are available for any date and time after 1 March 2023", "We intend to ensure snapshots are available for dates up to at least 2 years in the past" and "The apt included in Ubuntu 24.04 and later automatically detects when snapshots are supported for a repository". An example from there — `apt install hello --update --snapshot 20240301T030400Z`. The Playwright image creates a user of its own, `pwuser` (`adduser pwuser` in `Dockerfile.noble` v1.64.1), while the `devcontainer` stage of spec's repository template runs as `vscode` (`USER vscode`).

## 10. Go, go-licenses and Codecov

### 10.1. Go

Read 2026-11-01 (the 2026-11-01 amendments to R16 and R19, T34):
- **Go** — [Go 1.22 Release Notes](https://go.dev/doc/go1.22): "`go test -cover` now prints coverage summaries for covered packages that do not have their own test files" — "functions in the package are treated as uncovered". And also: "if a package contains no executable code at all, we can't report a meaningful coverage percentage; for such packages the `go` tool will continue to report that there are no test files". The trial — measurements 4.1.

Read 2026-11-13 (R39, T58), Go 1.27.3 of the devcontainer, in its `GOROOT`; the four files named below are byte for byte the same at the tag `go1.27.4` of golang/go, the Go of the `toolchain` stage, and so is the line of `AppendPWD`:
- **the executors of wasm** — `lib/wasm/go_wasip1_wasm_exec` chooses by `GOWASIRUNTIME` among `wasmedge`, `wasmer`, `wazero` and `wasmtime`, the default, and any other value ends with "Unknown Go WASI runtime specified"; wasmtime runs with `--dir=/ --env PWD="$PWD" --env PATH="$PATH" -W max-wasm-stack=8388608`, and wazero with `-mount /:/ -env-inherit`. `lib/wasm/go_js_wasm_exec` ends with `exec node --stack-size=8192 "$DIR/wasm_exec_node.js" "$@"`;
- **`go test -exec`** — `go help testflag`: "-exec xprog — Run the test binary using xprog. The behavior is the same as in 'go run'", and `go help run`: "If the -exec flag is given, 'go run' invokes the binary using xprog: 'xprog a.out arguments...'". In the source, `src/cmd/go/internal/test/testflag.go` reads the flag as `base.StringsFlag`, a command split into words, and `src/cmd/go/internal/test/test.go` runs the test with `cmd.Dir = a.Package.Dir` and `env = base.AppendPWD(env, cmd.Dir)`: the folder of the package, and `PWD` set to it. The trial — measurements 2.6.

### 10.2. go-licenses

Read 2026-10-21 (R16):
- **`--allowed_licenses`** — [README go-licenses v2.0.1](https://github.com/google/go-licenses/blob/v2.0.1/README.md), section Usages, Check: "Allow only specific license names" — `go-licenses check <package> [package...] --allowed_licenses=<comma separated license names>`. The trial — measurements 2.1.

### 10.3. Codecov

Read 2026-11-01 (the 2026-11-01 amendments to R16 and R19, T34):
- **the Codecov app** — `gh api orgs/altnovatrail/installations`: `codecov`, `repository_selection: all`. The Codecov API, `api.codecov.io/api/v2/github/altnovatrail/repos/`, names all 13 repositories. Before T34 only `spec` was active, and after the trial `.github` too;
- **the Codecov CLI** — the releases of codecov/codecov-cli, the license Apache-2.0. v11.3.2 is Latest, came out 2026-10-28: "Clear Dependabot high alert (urllib3)" and "Rebuilt from main so the Linux and Alpine binaries publish".
  - `https://cli.codecov.io/v11.3.2/linux/codecov.SHA256SUM` — `8e1bfb71661378530f6ea21e82b414095899e565cbb4cf555c613064be17b973  codecov`. For v11.3.1 the same file holds `ca1d6419…`, the same sum as in the `ci.yml` of `spec`.
  - gpg 2.4.4 accepted the signature `codecov.SHA256SUM.sig`: "Good signature from "Codecov Uploader (Codecov Uploader Verification Key) <security@codecov.io>"", "Primary key fingerprint: 2703 4E7F DB85 0E0B BC2C 62FF 806B B28A ED77 9869".
  - The same fingerprint is named by the page [Codecov Uploader](https://docs.codecov.com/docs/codecov-uploader), updated 2026-06-07: "Key Fingerprint: `2703 4E7F DB85 0E0B BC2C 62FF 806B B28A ED77 9869`". It says to take the key from `https://keybase.io/codecovsecops/pgp_keys.asc`.
  - The binary calls itself `codecovcli, version 11.3.2`, and its `sha256sum` agrees with the file of sums;
- **actions** — `git ls-remote`: `codecov/codecov-action` v7.1.1 — 303a32d, `actions/upload-artifact` v7.0.2 — cf430e0, `actions/download-artifact` v8.0.2 — 9000827. All three are the latest releases. The license of codecov-action is MIT. Its `action.yml` at 303a32d:
  - `core.getIDToken` takes the OIDC token, with the audience `https://codecov.io`, if `use_oidc` and this is not a fork;
  - a fork is `github.event.pull_request.head.repo.full_name` not equal to `github.repository`, and then the report goes without a token, from the branch `owner:branch`, as for `spec` (R48 spec);
- **the paths in Codecov** — the default rule for Go's import paths, Codecov, Fixing paths (the 2026-11-01 amendment to R48 spec). The trial — measurements 4.1;
- **several uploads per commit** — [Codecov, codecov.yml reference](https://docs.codecov.com/docs/codecovyml-reference), updated 2026-07-23. `codecov.notify.wait_for_ci` has "Should Codecov wait for all CI statuses to complete before sending ours", `true` by default. `codecov.notify.after_n_builds` has "How many uploaded reports Codecov should wait to receive before sending statuses", `1` by default.

## 11. The tools of the checks

### 11.1. gitleaks

Read 2026-10-19 (R03):
- **the release and the license** — the GitHub API — `repos/gitleaks/gitleaks/releases/latest`: v8.30.1, 2026-03-21, the files are archives for the platforms and `gitleaks_8.30.1_checksums.txt`, with no signature and no attestation; `repos/gitleaks/gitleaks/license`: MIT.

Read 2026-10-20 (R08):
- **gitleaks** — [README v8.30.1](https://github.com/gitleaks/gitleaks/blob/v8.30.1/README.md), section Load Configuration: "The order of precedence is:", and the fourth — "A `.gitleaks.toml` file within the target path". The sum of the archive `gitleaks_8.30.1_linux_x64.tar.gz` is from `gitleaks_8.30.1_checksums.txt` of the same release: `551f6fc83ea457d62a0d98237cbad105af8d557003051f41f3e7ca7b3f2470eb`.

### 11.2. actionlint and ShellCheck

Read 2026-10-20 (R08):
- **actionlint** 1.7.12 — the latest release (the GitHub API, `repos/rhysd/actionlint/releases/latest`, 2026-03-30); the sum of the archive `actionlint_1.7.12_linux_amd64.tar.gz` is from `actionlint_1.7.12_checksums.txt`: `8aca8db96f1b94770f1b0d72b6dddcb1ebb8123cb3712530b08cc387b349a3d8`;
- **shellcheck** 0.11.0 — the latest release (the GitHub API, `repos/koalaman/shellcheck/releases/latest`, 2025-08-04), the license is GPL-3.0 (`repos/koalaman/shellcheck/license`); it has no files of sums, so the sum of `shellcheck-v0.11.0.linux.x86_64.tar.xz` was computed from the downloaded archive: `8c3be12b05d5c177a04c29e3c78ce89ac86f1595681cab149b65b97c4e227198`.

### 11.3. yq and bats-core

Read 2026-11-01 (R28, T35):
- **yq** — v4.54.1, the latest release, 2026-09-29 (the GitHub API, `repos/mikefarah/yq/releases/latest`). The license is MIT: "The MIT License (MIT)", `LICENSE` at the tag v4.54.1.
  - Among the release's files are `yq_linux_amd64`, `checksums` and `checksums_hashes_order`. SHA-256 is the eighteenth line of `checksums_hashes_order`, and in the line `yq_linux_amd64` of the file `checksums` the sums follow the name in the same order. The SHA-256 sum is `8e34fc298390875de416e6a4afcb8cabeceb25d9aa8506c1a2f9353cf702ea5f`.
  - The downloaded file, 14,168,224 bytes, agreed with it, and `--version` gives "yq (https://github.com/mikefarah/yq/) version v4.54.1".
- **bats-core** — v1.14.0, the latest release, 2026-07-21, the release has no files (the GitHub API, `repos/bats-core/bats-core/releases/latest`); the license is MIT.

### 11.4. just

Read 2026-10-20 (R14):
- **`just --dry-run`** — the help of just 1.58.0, `just --help`: "Print what just would do without doing it". The trial — measurements 5.1.

### 11.5. git

Read 2026-10-22 (the amendments to R10 and R18, T28):
- **git** v2.55.0, commit e9019fc. `Documentation/git-clone.adoc`, `--local`: "The files under `.git/objects/` directory are hardlinked to save space when possible", and "If the repository is specified as a local path (e.g., `/path/to/repo`), this is the default". `Documentation/git-worktree.adoc`, `add`: "The new worktree is linked to the current repository, sharing everything except per-worktree files such as `HEAD`, `index`, etc.".

## 12. `spec`: tags, recipes and scripts

### 12.1. `spec` v0.2.11

Read 2026-10-20 (R10):
- **the Releases API's refusal for a release of `spec`** (sources 3.2) — The `release.yml` of `spec` at v0.2.6 let only a 404 through. From v0.2.7 both a 404 and a 403 are let through, but only when the commit is no longer the tip and adds or changes files of `.github/workflows/` against the tip: `git diff --quiet --diff-filter=AM "$tip" "$TARGET" -- .github/workflows/` (the `release.yml` of `spec` v0.2.9; the amendment to R31 spec). From v0.2.11 this rule is the recipe `release-refusal`, and it also requires the commit to lie in the tip's history (below, in the reading for R14).

Read 2026-10-20 (R14):
- **`release-version`** in `spec/justfile` v0.2.11 takes a commit and a path to a workflow. The recipe's comment: outside `spec` "the line is RELEASE_LINE as the workflow named second sets it at that commit, a path from the repository's root, whatever the shell sets: a release workflow's own env, the tip's, must not number an older commit. A commit from before that workflow existed takes the checked-out file's line";
- **`release-refusal <commit> <tip> <error file>`** ibid.: "Exits 0 when the refusal is that one, and 1 with the reason when it is not or when anything cannot be read". The `release.yml` of `spec` v0.2.11 calls both recipes through the launch script `$RUNNER_TEMP/toolchain`: it runs the command in the `toolchain` stage, with the working folder and `$RUNNER_TEMP` mounted, the second read-only;
- **the sums of the archives** — `.devcontainer/Dockerfile` from the recipe at v0.2.11 (R34 spec). All eight sums — Node 24.21.0, just 1.58.0, gh 2.101.0 and just-lsp 0.10.0, each for amd64 and arm64 — matched the archives that were downloaded 2026-10-20 from the addresses of that Dockerfile and checked by `sha256sum`.

### 12.2. `spec` v0.2.12, v0.2.13 and v0.2.17

Read 2026-10-21 (R16):
- **the list of `spec`** — `spec/tools/licenses/config.mjs` at v0.2.12: `allowed` — 0BSD, Apache-2.0, BlueOak-1.0.0, BSD-2-Clause, BSD-3-Clause, CC0-1.0, ISC, MIT, MIT-0 and Unlicense, one per line. The trial of the step — measurements 2.1.

Read 2026-10-21 (R19):
- **`licenses-check` of `spec`** — `spec/tools/licenses/main.mjs` at v0.2.13: "The lock file is always the one beside this script: no path comes from the command line". It walks the `packages` of the lock file and takes the `license` of each package, and for a lock file without `packages`, version 1, it would check zero packages and answer "ok".

Read 2026-10-22 (the amendments to R10 and R18, T25):
- **`toolchain.sh`** — `spec/tools/toolchain/toolchain.sh` at v0.2.17, mode 100755. Its modes: `build` — "build the stage as the image novatrail-toolchain", `run <command> [<argument>...]` — "run a command in it" and `spec [--dry-run] <recipe> [<argument>...]` — "run one of spec's recipes, from spec's justfile". On the launch: "The repository is mounted at /work, and RUNNER_TEMP read-only at its own path, where gh leaves the error of a refused release; nothing else of the runner's environment goes in". The script's tests are the recipe `toolchain-test`, with a stub for docker.

### 12.3. `spec` v0.2.18–v0.2.21

Read 2026-10-22 (R22, the amendments to R16 and R19, T26):
- **the tags of `spec`** — v0.2.18 04ab0d2, v0.2.19 6462304, v0.2.20 6caf6ff and v0.2.21 14e2a11 (`gh release list -R altnovatrail/spec`), each immutable. `tools/licenses/config.mjs`, `.devcontainer/` and `tools/toolchain/` have not changed since v0.2.17 (`git diff`);
- **the 2026-10-22 amendment to R39 spec**, v0.2.18 and newer. «Исключение, которое принимает лицензию вне списка, … держит только пакет, который lock-файл помечает `dev`», and «`devOptional` — не `dev`». «То же исключение покрывает пакеты, которые сам инструмент называет в `optionalDependencies`, — так приходят его сборки под платформы, — пока они тоже `dev` и под той же лицензией». An exception for `null` or `SEE LICENSE IN <file>` «поправляет то, что говорит lock-файл, а не принимает лицензию вне списка»;
- **the recipes** — `spec/justfile` v0.2.21. `licenses-check-repo lock exceptions=""` runs from the folder it is called from: `cd {{quote(invocation_directory())}} && node … --lock=… --exceptions=…`. `licenses-allowed` — `node tools/licenses/main.mjs --allowed`, one identifier per line, in the order of `config.mjs`. Neither calls `_tools`.

### 12.4. `spec` v0.4.1

Read 2026-11-01 (R25, T31):
- **the tag** — v0.4.1, commit 23000f3, came out 2026-10-29: `gh release view` — immutable, and `gh release verify v0.4.1 -R altnovatrail/spec` — "Release v0.4.1 verified!", with the files `format-0.1.tar.gz` and `altnovatrail-spec-0.4.1.tgz` and their bundle. Between v0.2.23 and it — 76 commits (`git log --oneline v0.2.23..v0.4.1`). `tools/toolchain/` and `tools/licenses/` have not changed (`git diff --quiet`);
- **Go in the `toolchain` stage** — `.devcontainer/Dockerfile` from `editDevcontainer` v0.4.1 for `.github`: Go 1.27.3. The sums of the archives match go.dev's list, `https://go.dev/dl/?mode=json&include=all`: `go1.27.3.linux-amd64.tar.gz` — `65efbc80fdc1fa2cd2631cad5b481777a68e8725f34e89f50fc6ac714e379b40`, `go1.27.3.linux-arm64.tar.gz` — `a06e99309dbcbdca1a8ccd2282c3ee146e55930886e26b4f1193269587165f49`. The recipe gives `devcontainer.json` and `host-network.sh` the same as here. There is no docker in the devcontainer, and the image was not built here: the pull request's CI will build the `toolchain` stage;
- **the README badges** — each address answered 200 and a value: CI, Release and CodeQL — "passing", the release number — "v0.1.10", Scorecard — 6.8, the license — "Apache-2.0"; for SonarCloud, code smells — 0, reliability, security and maintainability — A, vulnerabilities — 0.

### 12.5. `spec` v0.5.3

Read 2026-11-01 (R27, T36):
- **the tag** — v0.5.3, commit 38ce564, came out 2026-11-01 at 17:19 UTC: `gh release view` — immutable, and `gh release verify v0.5.3 -R altnovatrail/spec` — "Release v0.5.3 verified!". Between v0.4.1 and it — v0.5.0, T46 `spec` (R74 spec), and v0.5.1 and v0.5.2, T50 `spec`; v0.5.3 itself is the answer to В28;
- **what did not change** — `.devcontainer/`, RULES.md, AGENTS.md, `repo-template/`, `tools/toolchain/`, `tools/licenses/`, `tools/new-repo/` and `tools/docs-check/` (`git diff --quiet v0.4.1 v0.5.3`). In `tools/release/` only a test changed. The recipes `_tools`, `docs-check-repo`, `licenses-allowed`, `licenses-check-repo`, `release-version` and `release-refusal` in `justfile` are the same, word for word; the new ones are `ci-lint`, `ci-test`, `ci-vuln` and `ci-licenses` for `go.yml`;
- **the README of `spec` v0.5.3**, section "Status": "version 0.1 … comes out as files for code from the release v0.3.0, with its types for Go from v0.3.4 and for TypeScript from v0.4.0 … The first contract between components, the types of the element `<novatrail-canvas>` between `canvas` and `app`, comes out from v0.5.0", with a link to R74 spec, "and the other contracts come after it";
- **`spec` calls `go.yml`** — the 2026-11-01 amendment to R30 spec: the job "Go" in the `ci.yml` of `spec` calls the shared `go.yml` v0.1.10, commit f3addb7, by a SHA with the version beside it, and its `ci-licenses` checks by the `ALLOWED_LICENSES` that `go.yml` gives.

### 12.6. `spec` v0.6.2

Read 2026-11-01 (R30, T38):
- **the tag** — v0.6.2, commit 49d0fb6, came out 2026-11-01 at 23:54 UTC. `gh release view` — immutable, and `gh release verify v0.6.2 -R altnovatrail/spec` — "Release v0.6.2 verified!". Between v0.5.3 and it — v0.5.4–v0.5.8, v0.6.0 and v0.6.1 (`gh api repos/altnovatrail/spec/releases`). v0.6.2 differs from v0.6.1 only in RUN.md and concepts 16 `spec`;
- **what did not change** — `.devcontainer/`, AGENTS.md, `repo-template/`, `tools/toolchain/`, `tools/licenses/`, `tools/new-repo/` and `tools/docs-check/` (`git diff --stat v0.5.3 v0.6.2`).
  - The recipes that the shared and `self-` workflows call — `docs-check-repo`, `licenses-allowed`, `licenses-check-repo`, `release-version`, `release-refusal` and `ci-*` — are the same word for word.
  - The new recipes are `release-verify` and `release-verify-npm`, and `release-version-test` now calls `_tools`.
  - `tools/package.json` got the sigstore-js packages for `release-verify`, and `_tools` installs them for the documents check too;
- **RULES.md**:
  - a new hard rule "Release files are verified": "A file of a NovaTrail release — a binary, an archive, an index — enters code or CI only once `just -f spec/justfile release-verify` has accepted it …, where it enters NovaTrail";
  - in the rule on language — "and so is spec's cross-repository plan, COORDINATION.md (R76 spec)";
- **the README of `spec` v0.6.2**, section "Status": "Version 0.1 came out as files for code from the release v0.3.0, with its types for Go from v0.3.4 and for TypeScript from v0.4.0; version 0.2, whose digit on a crop is 24 px high unless the module gives it, comes out from v0.6.0. The format is still to be tried on the modules of the first slice";
- **В29 and В30** — they are not in `spec` v0.6.2: neither RUN.md nor the decision log of `spec` names them.

Read 2026-11-02 (the 2026-11-02 amendment to R18, T39):
- **`toolchain.sh` v0.6.2** (the comment at the top of the file): "The repository is mounted at /work, and RUNNER_TEMP read-only at its own path … nothing else of the runner's environment goes in". On `spec --dry-run`: "just's dry run parses the call, prints the recipe and runs nothing".

### 12.7. `spec` v0.6.3

Read 2026-11-02 (R31, T40):
- **the tag** — v0.6.3, commit 8460f11, came out 2026-11-02 at 02:30 UTC. `gh release view` — immutable, and `gh release verify v0.6.3 -R altnovatrail/spec` — "Release v0.6.3 verified!". There are no tags between v0.6.2 and it (`gh release list -R altnovatrail/spec`);
- **what did not change** — `.devcontainer/`, RULES.md, AGENTS.md, README.md, `justfile`, `tools/toolchain/`, `tools/licenses/` and `tools/docs-check/` (`git diff --quiet v0.6.2 v0.6.3`). In `tools/release/` only `test/` changed, and `tools/package.json` and `tools/package-lock.json` did not. The recipes that the shared and `self-` workflows call are the same word for word. `repo-template/` and `tools/new-repo/` (R79 spec) and `tools/types/npm/README.md` changed;
- **the 2026-11-02 amendment to R63 spec** — «прошлый индекс получает и проверяет шаг общего `release.yml` `.github` на раннере, а рецепт `release-files` `modules` получает уже проверенный файл. Т-35 закрыт — ответ автора 2026-11-02 по строке „в реестр spec“ `.github` В33, вариантом 1′». How the file reaches the recipe, «решает T41 `.github`»;
- **the 2026-11-02 amendment to R77 spec** — «В пункте „Где проверяется“ слова „в том шаге, который его получает“ у релиза `modules` значат шаг общего `release.yml` на раннере, а не рецепт `release-files`»;
- **an unpublished version number at `spec`** — the comment of the step "Check the npm package" of the `release.yml` of `spec` v0.6.3: "A version it held lies in its time then, or under time.unpublished.versions once the whole package is gone". The step looks for the number there too: `(.time.unpublished.versions? // []) | index($v) != null`. The documents of such packages in the registry — sources 8.3;
- **COORDINATION.md of `spec` v0.6.3** — the row 2.2 is marked done 2026-11-02, with the pull requests 85 and 86 of `.github`, the submodule `v0.6.2` and the release `v0.1.13`. The row 2.3 is "E11: T40, T41", and the row 3.7 is «рецепт `release-files` `modules` получает его проверенным от общего релиза, а не скачивает сам», by the 2026-11-02 amendment to R63 spec, and «как именно — T41 `.github`».

Read 2026-11-02 (the 2026-11-02 amendment to R18, T41):
- **`previous` of the step of the version number** — `tools/release/version.mjs` of `spec` v0.6.3: "previous= the newest release before it, where the release notes start", and `nextVersion` puts `newest` in it, the highest release by number. `modules` has no releases, no `release.yml` and no recipe `release-files` yet (the GitHub API).

Read 2026-11-02 (the 2026-11-02 amendment to R18, T42):
- **the check of `spec`** — the step "Check the npm package" of the `release.yml` of `spec` v0.6.3: `jq -e --arg v "$version" '((.time // {}) | has($v)) or ((.time.unpublished.versions? // []) | index($v) != null)'`. The shared step's check is now the same: the `diff` of the lines with `jq -e --arg v "$version"` of both files is empty. The second half catches a number from `unpublished.versions` without a key in `time`; none of the three documents has such a number.

### 12.8. `spec` v0.9.8

Read 2026-11-08 (R32, T43):
- **the tag** — v0.9.8, commit b1fbc61, came out 2026-11-08 at 01:29 UTC and became the newest release of `spec`. `gh release view` — immutable, and `gh release verify v0.9.8 -R altnovatrail/spec` — "Release v0.9.8 verified!". Between v0.6.3 and it, 29 tags, from v0.6.4 to v0.9.7;
- **what changed of what `.github` takes** (`git diff v0.6.3 v0.9.8`):
  - `.devcontainer/Dockerfile`. The base image is `mcr.microsoft.com/devcontainers/base:3.0.12-noble` by digest instead of 3.0.10. buf 1.75.0 was added with sums for amd64 and arm64 (R83 spec), and the comments on Go name any code of the repository. `devcontainer.json` and `host-network.sh` did not change;
  - RULES.md. The session of `spec` finds the rows «в реестр spec» itself, on `main` (R81 spec). A new hard rule is on production images (R105 spec);
  - spec's repository template: rule 2 of RUN.md follows R81 spec, and the Environment of CLAUDE.md has buf;
  - the README of `spec`: format 0.3 comes out from v0.9.0, the admission table from the line 0.8 (R96 spec), the code of the contracts from the line 0.7 (R83 spec);
  - card 3.11 spec — only the part on `infra` changed (R105, R106 spec);
- **what did not change for the workflows of `.github`.** The recipes `docs-check-repo`, `licenses-allowed`, `licenses-check-repo`, `release-version`, `release-refusal` and `release-verify` have the same parameters, and `tools/toolchain/` and `tools/docs-check/` did not change. `tools/release/verify.mjs`, beyond what it took before, takes the files of `spec` `admission-<version>.tar.gz` and `altnovatrail-contracts-<version>.tgz`. `tools/licenses/main.mjs` only moved `inRepository` to `tools/shared.mjs`. The recipe on a real file — measurements 5.8;
- **what `spec` hands to `.github`** (RUN.md of `spec` v0.9.8, table 4):
  - Д69 — the answer to В35: the comment of the step "Check the npm package" of the `release.yml` of `spec` says, as the shared step does, that the number of a package unpublished whole stays a key in `time`;
  - Д80 — the `paths` list of the kind modules in the template, and in CONTRIBUTING that only the eval-set organizer brings in eval-set samples (the 2026-11-02 amendment to R25 spec; concepts 15 spec). Both «своим переходом»;
  - Д88 — a group `groups` for the references `altnovatrail/.github/*` in the template `dependabot.yml`, «своим релизом»;
  - Д91 — the step "Publish to npm" waits for the version in the registry for up to 20 minutes, with `timeout-minutes` to fit (the 2026-11-02 amendment to R37 spec), «своей задачей»;
  - Д114 — the options of the shared `go.yml`: runs on the targets, the difference check `fma-diff`, a job on `ubuntu-24.04-arm`, and then the shared test of the rules of code (R107 spec), «своей задачей»;
- **COORDINATION.md of `spec` v0.9.8.** Item 2 is closed: the row 2.3 is «2026-11-02, pull request 88–91, релизы `v0.1.14` и `v0.1.15`». In «Состоянии», `.github` has the submodule v0.6.3, the release v0.1.15 and «нет: E11 сделан, таблица 2 пуста». Of Д5 it says that it «ждёт теперь одного `infra`».

Read 2026-11-08 (the 2026-11-08 amendment to R18, T44):
- **the 2026-11-02 amendment to R37 spec** — the limit of 20 minutes. The registry checks a package before serving it: "introduces a short delay between publishing and availability, typically around five minutes. It may take longer, up to 15 minutes or more, at peak times or depending on a package's content and size" ([GitHub Changelog, npm publish-time malware scanning, 2026-07-28](https://github.blog/changelog/2026-07-28-npm-publish-time-malware-scanning-and-dual-use-metadata/), as quoted by the amendment, which read it 2026-11-02);
- **the second 2026-11-03 amendment to R37 spec** — the archive. «Версия в реестре доступна, когда документ пакета её показал и реестр отдаёт её архив». For the release of `spec` v0.7.2 the document showed 0.7.2 at 04:17:35 UTC, while the archive answered 404 until 04:22:50. Before T44 the shared step downloaded the archive by a single `curl -fsSL --retry 3`, which does not retry a 404 — the same race;
- **the step "Publish to npm" of the `release.yml` of `spec` v0.9.8** — rounds every 10 seconds, `deadline=$((SECONDS + 1200))` and no more than 120 rounds. The document — `curl -sS --proto "=https" --retry 3 --max-time 30`, the archive — `curl -sS --proto "=https" --proto-redir "=https" -L --max-time 60`, without a retry. A package on which npm failed is looked for in three rounds, until the document shows it. The shared step took this for one package, with the same error messages.

Read 2026-11-08 (the 2026-11-08 amendment to R08):
- **the script** — `spec/tools/toolchain/toolchain.sh` v0.9.8: "toolchain.sh build" — "build the stage as the image novatrail-toolchain", "toolchain.sh spec [--dry-run] <recipe>" — "run one of spec's recipes, from spec's justfile". The command runs as the runner's user, with its home in `/tmp`, the repository's root in `/work`, and `RUNNER_TEMP` read-only.

### 12.9. `spec` v0.9.9

Read 2026-11-08 (R34, T51):
- **the tag** — v0.9.9, commit fa5da0b, came out 2026-11-08 at 16:03 UTC and became the newest release of `spec`. `gh release view` — immutable, and `gh release verify v0.9.9 -R altnovatrail/spec` — "Release v0.9.9 verified!";
- **what changed** (`git diff --stat v0.9.8 v0.9.9`) — 13 files: COORDINATION.md, RUN.md, `docs/`, `format/README.md` and the example of traps, `tools/contracts/report.mjs` and `tools/docs-check/citations.mjs` with their tests. `.devcontainer/`, RULES.md, `justfile` and `tools/toolchain/` did not change;
- **card 3.11 spec** — the item «для кода» names the input `same-bits` of the Go wrapper: runs on the targets, `fma-diff`, a run on arm64 and the test of the rules of code by the tool of `.github` with the caller's lists in `.github/coderules.json`. Table 5 of RUN.md `spec` recorded the answer to В36 `.github` — card 3.11 spec and Д116;
- **COORDINATION.md of `spec` v0.9.9** — in «Состоянии», `.github` has the submodule v0.9.8, the release v0.1.21 and «нет: E12–E15 сделаны, таблица 2 пуста».

### 12.10. `spec` v0.12.0

Read 2026-11-09 (R35):
- **the tag** — v0.12.0, commit 5b4640a, came out 2026-11-09 at 19:38 UTC; `gh release list` calls it "Latest". `gh release view` — immutable, and `gh release verify v0.12.0 -R altnovatrail/spec` — "Release v0.12.0 verified!";
- **what changed** (`git diff --stat v0.9.9 v0.12.0`) — 56 commits, 756 files: format 0.4 (v0.10.0), the part `deployment/` (v0.11.0), the admission table 0.2 (v0.12.0), the contracts, the types, `repo-template/` and `tools/new-repo/`, `justfile` and `tools/release/`. `.devcontainer/`, RULES.md, `tools/toolchain/`, `tools/docs-check/` and `tools/licenses/` did not change;
- **COORDINATION.md of `spec` v0.12.0** — in «Состоянии», `.github` has the submodule v0.9.9, the release v0.1.21 and «нет: таблица 2 пуста»; the row 2.4 is «задачи ещё нет»: the cache of the image of the `toolchain` stage in `go.yml`, `typescript.yml` and `documents.yml`, with no cache in the shared `release.yml`, and a release of `.github` (the 2026-11-09 amendment to R31 spec; Д146 in RUN.md `spec`). T104 `spec`, the cache in `toolchain.sh`, is not yet done at v0.12.0.

### 12.11. `spec` v0.13.0

Read 2026-11-10 (R37):
- **the tag** — v0.13.0, commit 59fd14f, came out 2026-11-10 at 00:27 UTC; `gh release list` calls it "Latest". `gh release view` — immutable, and `gh release verify v0.13.0 -R altnovatrail/spec` — "Release v0.13.0 verified!";
- **T104 `spec`** (RUN.md `spec`, «Сделано (2026-11-09)»; commit 82411a5) — `tools/toolchain/toolchain.sh`: "The image may come from a file of docker save, which the caller keeps in the cache of GitHub Actions by the sha256 of the Dockerfile (R31): TOOLCHAIN_IMAGE_FILE names it, its whole path. Unset or empty, build builds the stage, as ever". The docker calls — "load --quiet --input <file>, image inspect novatrail-toolchain, build as above, save --output <file> novatrail-toolchain". The warning is a line `::warning::toolchain.sh: …` in stdout without the path, and the path is a line in stderr;
- **what else changed** (`git diff --stat v0.12.0 v0.13.0`) — 102 files: the legal texts (`legal/`), the DPIA, the `ci.yml` and `release.yml` of `spec`, `justfile`, `tools/docs-check/config.mjs` — the document `docs/dpia.md`. `.devcontainer/`, RULES.md and `tools/licenses/` did not change;
- **COORDINATION.md of `spec` v0.13.0** — the row 2.4: «E17: T52 сделана, T53 ждёт; ветка `e17`, черновой pull request 109».

Read 2026-11-10 (the 2026-11-10 amendment to R36, T53):
- **the script** — `spec/tools/toolchain/toolchain.sh` v0.13.0: "TOOLCHAIN_IMAGE_FILE names it, its whole path. Unset or empty, build builds the stage, as ever"; the warning about a file that did not give the image — "::warning::toolchain.sh: the file of TOOLCHAIN_IMAGE_FILE did not give the image novatrail-toolchain, so it is built. The cache entry that held the file is broken and stays: delete it, or it is hit again";
- **the path** — the `ci.yml` of `spec` v0.13.0 keeps the file in `${{ runner.temp }}/novatrail-toolchain.tar` under the same key as `go.yml` (RUN.md `spec`, T104, «Сделано»).

### 12.12. `spec` v0.16.3

Read 2026-11-12 (R38, T54):
- **the tag** — v0.16.3, commit 664398e, the merge of pull request 138 of `spec`, came out 2026-11-12 at 20:17 UTC; `gh release list` calls it "Latest". `gh release view` — immutable, and `gh release verify v0.16.3 -R altnovatrail/spec` — "Release v0.16.3 verified!";
- **what changed** (`git diff --stat v0.13.0 v0.16.3`) — 77 commits, 302 files: RULES.md, CLAUDE.md and the rules `.claude/rules/` of `spec`, `docs/` in English with `docs/sources.md` and `docs/measurements.md`, `DEBT.md`, the parts `consent-age/` and `export/`, `legal/` of version 2, the contracts, `repo-template/`, `tools/docs-check/`, `tools/session/`, `tools/tokens/`, `tools/translation/`, `tools/release/` and `.devcontainer/Dockerfile` — Go 1.27.4. `tools/toolchain/` did not change;
- **Go 1.27.4** — the sums of the archives by `https://go.dev/dl/?mode=json`: `linux-amd64` — `7226736c2339719cda28fbf3a54d71aa63bcefe376e98cef00034268dab24840`, `linux-arm64` — `3392582988a273a87ab5043ee1b2c9c17a2c3c00580bf9326c47a2e0aaaeac92`, the same as in the Dockerfile of `spec` v0.16.3.

## 13. Other repositories of NovaTrail

### 13.1. The `spec` submodule and `documents.yml` in other repositories

Read 2026-11-01 (R25, T31):
- **the callers of `documents.yml`** (Д5 in RUN.md) — `ci.yml` and the `spec` submodule on the `main` of each, the GitHub API: `api`, `app`, `engine`, `infra`, `learner-model`, `modules`, `sim` and `skill-map` — v0.2.9; `module-kit` — v0.2.13; `canvas` — v0.2.42; `tutor` — v0.3.3. They call `documents.yml` by the SHA of v0.1.0, and `tutor` by that of v0.1.5 and `canvas` of v0.1.10.

Read 2026-11-02 (R30, T38):
- **the callers of `documents.yml`** (Д5 in RUN.md; 2026-11-02) — the `spec` submodule on the `main` of each, the GitHub API: `api`, `app`, `engine`, `infra`, `learner-model`, `modules`, `sim` and `skill-map` have v0.2.9, `module-kit` v0.2.13, `canvas` v0.4.1, `tutor` v0.5.4. They call `documents.yml` by the SHA of v0.1.0, `tutor` by that of v0.1.5, and `canvas` of v0.1.12.

Read 2026-11-02 (the 2026-11-02 amendment to R18, T42):
- **the callers of `documents.yml`** (Д5 in RUN.md) — the `spec` submodule on the `main` of each, the GitHub API: `engine`, `infra`, `learner-model`, `modules`, `sim` and `skill-map` have v0.2.9, `module-kit` v0.2.13, `api`, `app`, `canvas` and `tutor` v0.6.2. They call `documents.yml` by the SHA of v0.1.0, `tutor` by that of v0.1.5, and `canvas` of v0.1.12.

Read 2026-11-08 (R32, T43):
- **the callers of `documents.yml`** (Д5 in RUN.md) — the `spec` submodule on the `main` of each, the GitHub API: `infra` — v0.2.9, `canvas` — v0.6.5, `app` — v0.6.6, `module-kit` — v0.9.3, `api` — v0.9.4, `learner-model`, `modules` and `tutor` — v0.9.5, and `engine`, `sim` and `skill-map` — v0.9.8. The tag is named by the submodule's commit: the tags `vX.Y.Z` and `contracts/vX.Y.Z` stand on one commit.

Read 2026-11-08 (the 2026-11-08 amendment to R08):
- **the callers** — the `spec` submodule on the `main` of each, the GitHub API: `infra` — v0.2.9, and the other ten — v0.6.6 or newer: `app` — v0.6.6, `api` — v0.9.4, `learner-model` and `tutor` — v0.9.5, `canvas`, `engine`, `module-kit`, `modules`, `sim` and `skill-map` — v0.9.8. `infra` calls `documents.yml` by the SHA of `v0.1.0`, ff2a359, and its latest commit is of 2026-10-21.

Read 2026-11-12 (R38, T54):
- **`module-kit`** — the `spec` submodule on `main` is commit 58d3f46, `v0.15.0` (the GitHub API, `repos/altnovatrail/module-kit/contents/spec`): the row 7.1 of COORDINATION.md `spec` is not done yet.

### 13.2. `canvas` and npm

Read 2026-10-22 (the amendment to R18, T27):
- **the registry and `canvas`** — `https://registry.npmjs.org/@altnovatrail%2fcanvas` answers 404 "Not found", and `-/org/altnovatrail/package` 200. `canvas` has no `release.yml`, no releases, no immutable releases and no ruleset of tags (the GitHub API).

Read 2026-11-01 (R25, T31):
- **`canvas` and npm** (Д7 in RUN.md) — `canvas` has neither releases nor `release.yml` (the GitHub API), and `@altnovatrail/canvas` in the registry is 404 "Not found". Its T24 is in the epic E5, which stands in table 2 of RUN.md `canvas`, among the epics for later, and its current epic E7 carries no release: «первый релиз — T24 в E5 или своя задача» (RUN.md `canvas`, `main`).

Read 2026-11-02 (R30, T38):
- **`canvas` and npm** (Д7 in RUN.md; 2026-11-02) — `canvas` still has neither releases nor `release.yml` (the GitHub API), and `@altnovatrail/canvas` in the registry is 404. Its current epic is E8 «Первый релиз» (RUN.md `canvas`, `main`):
  - T67 moves `canvas` to a tag of the line 0.6;
  - T70 brings out v0.1.0 and puts the same archive in npm;
  - T71 — the next versions by the step of the shared release, through trusted publishing.

Read 2026-11-02 (the 2026-11-02 amendment to R18, T42):
- **`canvas` and npm** (Д7 in RUN.md):
  - `canvas` has `.github/workflows/release.yml` — commit bc60d93, "Do T66: the release build and its trial run", 2026-11-02. It calls the shared `release.yml` v0.1.12 by the SHA 4225639, with `publish: false` and `npm-package: "@altnovatrail/canvas"`, and its runs of 2026-11-02 — `pull_request` and `workflow_run` — passed (the GitHub API);
  - `canvas` has no releases, `@altnovatrail/canvas` in the registry is 404, and T70 «Первый релиз: пакет» and T71 «Публикация шагом npm» in RUN.md `canvas` are `[ ]`.

Read 2026-11-08 (R32, T43):
- **`canvas` and npm** (Д7 in RUN.md):
  - `canvas` has the releases v0.1.0, v0.1.1 and v0.1.2, all of 2026-11-02. In the registry, `@altnovatrail/canvas` has the versions `0.0.0-stage` and 0.1.0 without provenance, and then 0.1.1, at 05:39 UTC, and 0.1.2, at 16:36 UTC, with the provenance `https://slsa.dev/provenance/v1`;
  - the provenance of 0.1.1 (`registry.npmjs.org/-/npm/v1/attestations/@altnovatrail%2fcanvas@0.1.1`): the workflow is `.github/workflows/release.yml` of the repository `altnovatrail/canvas` on `refs/heads/main`, the run 41395016624. The run is `workflow_run`, "success", and its `referenced_workflows` is `altnovatrail/.github/.github/workflows/release.yml@09443e1027ef24197439dfe60a072d14c3626cc3`, v0.1.13. Its job is "Release / release";
  - so npm accepted a publication through trusted publishing from a reusable workflow of another repository and recorded the caller's provenance. Now the `release.yml` of `canvas` on `main` calls the shared v0.1.13 with `npm-package: "@altnovatrail/canvas"`.

### 13.3. Who calls the shared workflows for code

Read 2026-10-22 (the amendment to R19, T29):
- **the callers** — `.github/workflows/` and `justfile` of the twelve other repositories of the organization — `canvas` and the eleven others — through the GitHub API. Only `canvas` calls `typescript.yml`. `ALLOWED_LICENSES` is read by the `ci-licenses` of `module-kit` and `tutor`, but that is go-licenses with the list from `go.yml`. GitHub's code search `org:altnovatrail ALLOWED_LICENSES` answered empty, so the files were read one by one.

Read 2026-11-01 (the 2026-11-01 amendments to R16 and R19, T34):
- **who calls the wrappers** — `ci.yml` on the `main` of each repository of the organization, the GitHub API:
  - `canvas` — `typescript.yml` v0.1.10;
  - `spec` — `go.yml` v0.1.10;
  - `tutor` — `go.yml` v0.1.5;
  - `module-kit` — `go.yml` v0.1.2;
  - the others — neither.

  The `ci-test` of `module-kit` and `tutor` is `go test -race -count=1 ./...`, that of `canvas` is `vitest run`, and none of them writes a report. The Go modules are named `github.com/altnovatrail/module-kit` and `github.com/altnovatrail/tutor`.

### 13.4. `canvas`

Read 2026-10-21 (the amendment to R19):
- **`headless`** — `vitest.config.ts` of `canvas` at 88492c4: `headless: true`, with the comment "Headless whatever CI says: there is no display in the container or on the runner. CI still keeps test.only out of CI, as Vitest's allowOnly does by default";
- **`npm` from a script** — `scripts/package.ts` of `canvas` at 88492c4 runs `execFileSync(process.execPath, [npm, "pack", …])`, where `npm` is `../lib/node_modules/npm/bin/npm-cli.js` from the folder of `process.execPath`: "no program is looked up in PATH". The finding `typescript:S4036` and the red quality gate are named by RUN.md `canvas`, T08;
- **the ruleset of `canvas`** — `repos/altnovatrail/canvas/rulesets/25506234/history` (the GitHub API): the version 54216848 is of 2026-10-21T23:13:18Z. It differs from the previous version, 54024579, only by five new checks in `required_status_checks`, all with `integration_id` 15368. For pull request #19 of `canvas`, `gh pr checks 19 --required` names ten checks, and all are "pass".

Read 2026-10-22 (R22, the amendments to R16 and R19, T26):
- **`canvas`** — the GitHub API, `main` 7163904. The `spec` submodule is 04ab0d2, v0.2.18. `ci.yml` calls `typescript.yml@c772cc8… # v0.1.5`, and `ci-licenses` is `node scripts/licenses.ts`, which reads `ALLOWED_LICENSES`. Its T32 moves `ci-licenses` to the recipe of `spec` once a wrapper comes out with the submodule in the job `licenses`.

Read 2026-10-22 (the amendment to R19, T29):
- **`canvas`** — the GitHub API and a clone outside the repository. `main` is 379c774, the merge commit of pull request #25, merged at 16:08 UTC, and `scripts/licenses.ts` went by commit 1a335a9. `ci-licenses` is `{{ quote(just_executable()) }} -f spec/justfile licenses-check-repo package-lock.json licenses.json` (`justfile`, line 48). `git grep ALLOWED_LICENSES` at 379c774 finds the variable only in the documents and in the header of `justfile`: "Nothing here reads ALLOWED_LICENSES, which .github keeps for older checks until its Д6". The `spec` submodule is 04ab0d2, v0.2.18, and `ci.yml` calls `typescript.yml@0ab2799… # v0.1.8`. All four "TypeScript / …" are green both on the head of #25, 1a335a9, and on 379c774.

Read 2026-11-08 (the 2026-11-08 amendment to R04, T45):
- **the `release.yml` of `canvas`** on `main`, bdb9e6d, 2026-11-08 — the `paths` list as in the template of architecture 3.3, with `npm-package: "@altnovatrail/canvas"`. Its rule is the 2026-11-02 amendment to R08 canvas, and `NOTICE` in the archive is R46 canvas (the decision log of `canvas` on `main`).

Read 2026-11-09 (R36, T52):
- **the pattern** — R57 canvas (`docs/decisions.md` of `canvas`, `main` 66266e1) and its steps in `page.yml`: `actions/cache/restore` with the key `toolchain-${{ runner.os }}-${{ runner.arch }}-${{ hashFiles('.devcontainer/Dockerfile') }}`, `emulators/toolchain.sh` — `docker load` of the file or a build with `docker save` —, and `actions/cache/save` when `steps.toolchain.outputs.cache-hit != 'true'` with the key `cache-primary-key`.

### 13.5. `learner-model` and `engine`

Read 2026-11-08 (the 2026-11-08 amendment to R16, T46):
- **the recipes** `test-targets` and `fma-diff` of the `justfile` of `learner-model` (`main` 50f1b51) and of `engine` (`main` 33500ea) are the same, but for the comments and the number of the decision in the message of `fma-diff`. The scripts of the job are these recipes, with the control `testdata/fma/control.go` of `learner-model` inside `go.yml`.

Read 2026-11-08 (the 2026-11-08 amendment to R16, T47):
- **the job "Go arm64"** of `learner-model` and `engine` — `ubuntu-24.04-arm`, the `toolchain` stage, `just ci-test`, to which the recipe added `test-targets` and `fma-diff`. The job `arm64` of `go.yml` does the same, but for `fma-diff`: its output does not depend on the host — so the recipe's comment says —, and it already runs in "Go / fma-diff".

Read 2026-11-08 (R33, T48):
- **two copies of the test** — the `rules_test.go` of `learner-model` (`main` 50f1b51, 677 lines) and of `engine` (`main` 28cbde9, 721 lines, "a port of learner-model's rules_test.go, with the engine's lists"). `diff`: `engine` has an allowed module in `require`, a rule for `replace`, the parsing of `go.mod` blocks, the importer `importer.ForCompiler(fset, "source", nil)` and a check of the external tests with the same set of `*types.Package`; the copies have different `codeImports`, `testImports` and `mathTestFuncs`, and the messages name the repository. In both, the check of nested modules exempts `.devcontainer/gopls/go.mod`. Each copy has its own `testdata/coderules`: each is fitted to its own lists.

### 13.6. Rulesets and the `spec` submodules of other repositories

The readings of the record stood in the text of architecture 2.9 and 3.3, with no record, and T55 moved them here 2026-11-12, as they were: the record does not hold the API's answers.

Read 2026-10-20 (the amendment to R30 spec; T17 and T16 `spec`):
- **the rulesets of `spec`, `module-kit` and `tutor`** — the GitHub API: the rule `code_scanning` and merge only stand at `spec` and `module-kit` since T17 `spec`, and at `tutor` since T16 `spec`.

Read 2026-10-21 (the amendment to R32 spec; T21 `spec`):
- **the submodule of `engine`** — the GitHub API: commit 5eafb1a, v0.2.9.

## 14. MathTrail and patterns outside NovaTrail

### 14.1. canvas-api

Read 2026-10-19 (R03):
- **the workflows of canvas-api** — `.github/workflows/` at commit [0901af0](https://github.com/MathTrail/canvas-api/tree/0901af0439280334b3da33ffc4cc5c853e4403ff/.github/workflows) — `ci.yml`, `codeql.yml`, `scorecard.yml`, `release.yml` and `deploy.yml`. The only reusable workflow is `deploy.yml`, and only the `release.yml` of the same repository calls it; canvas-api calls no workflow of other repositories. The license check — R48 canvas-api, the signature — R52 canvas-api, CI in the toolchain's image — R49 canvas-api.

Read 2026-10-20 (R09):
- **the ruleset of canvas-api** — canvas-api has the rule `code_scanning` (sources 3.1) with the tool CodeQL and the thresholds `errors` and `high_or_higher` (the GitHub API, `repos/mathtrail/canvas-api/rulesets/25036747`).

Read 2026-10-21 (R16):
- **the names of the recipes** — the `justfile` of canvas-api at commit 0901af0: `ci-lint`, `ci-test`, `ci-vuln` and `ci-licenses`; govulncheck and go-licenses run there through `go run` at the exact version of the module, and CI calls the same recipes in the toolchain's image (R49 canvas-api).

Read 2026-10-21 (R19):
- **canvas-api** at commit 0901af0, through the GitHub API:
  - `web/.npmrc` — `save-exact=true` and `ignore-scripts=true`, with the comment "No package runs code of its own while it is being installed: nothing in the tree needs to, and what it would run is code nobody here has read"; the recipe `web-install` — `npm ci --no-audit --no-fund`;
  - `ci-vuln` — `npm audit --prefix web --omit=dev --audit-level=high`, without installing packages. `ci-licenses` — `node web/scripts/licenses.ts check --allowed … --except lightningcss=MPL-2.0` by `web/package-lock.json` of version 3 (R48 canvas-api);
  - format and lint — Biome 2.5.15, types — `tsc --noEmit`, tests — Vitest 5.0.3 with happy-dom (R47 canvas-api). There are no tests in a browser there.

### 14.2. `nodenv/.github`

Read 2026-10-19 (R03):
- **a repository named `.github`** — the documentation does not name it as a place of shared workflows. That is how [nodenv/.github](https://github.com/nodenv/.github) is built (commit 01e040a): `nodenv/nodenv` calls `uses: nodenv/.github/.github/workflows/release.yml@bd27009d5f178c0a88d42f7b07e6a3c7623ed768 # v7.0.8`, and the README explains: "GitHub doesn't allow them to live in any other directory, so the reusable workflows are all in the same location as the workflows _for this repository. To distinguish them, the workflows for this repository are prefixed with `.github_`". That Dependabot bumps such a reference was shown by a maintainer of dependabot-core in [issue #12489](https://github.com/dependabot/dependabot-core/issues/12489), 2025-12-29: "issue is not reproducible. Attaching screenshots below for a bump PR to version 7.0.5". T17 `spec` confirmed the call (architecture 2.8); whether Dependabot bumps the reference, `v0.1.1` will show (T14).
