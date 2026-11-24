# .github — architecture

> Status: the shared checks, the workflows for code, the shared release, the composite action `toolchain` and the tool `tools/coderules/` exist and come out in releases of `.github`, and no point still to be decided below is open. Where the rest is set: the tag of `spec` — the submodule `spec/`; the line the releases are numbered in — `RELEASE_LINE` in `self-release.yml`; the releases — the tags `v*` and [the releases](https://github.com/altnovatrail/.github/releases); what a task did — its pull request and the archives `docs/plan/`; what is put off — [run/DEBT.md](../run/DEBT.md).
>
> What the component does, what it does not do, and what is still to be decided about it. This is the detail of its card in `spec/docs/architecture.md`, the one its heading names `.github`. The card stays the summary: if the detail changes what the card says, the card is changed in `spec` the same way as a question for its registers, by a row «В реестр spec».
>
> Why it was decided so and not otherwise is in [decisions.md](decisions.md); the work plan is in [RUN.md](../RUN.md). A fact no run of ours checks — terms, a license, a page or an answer of an API with no version — is a record of [sources.md](sources.md), with its address, the date read and a quote, and the results of measurements are in [measurements.md](measurements.md): a claim cites its record, `sources 2.1` or `measurements 1.1`. GitHub's documentation and the code of actions and tools at a version or commit are a link beside the claim, a test or a measurement its evidence, and spec's tags and the files of NovaTrail's and MathTrail's repositories are git, at a commit. The concepts are the glossary of `spec/docs/concepts.md`. The documents and decisions of `spec` are under `spec/docs/`; a text here says in words what it takes from them, and cites none.

## 1. Purpose and bounds

**Does:**
- keeps the organization's profile, `profile/README.md`. GitHub shows it on the page github.com/altnovatrail;
- keeps the default community health files — CONTRIBUTING, SECURITY and the code of conduct — and with them the issue and pull request templates: the issue forms "Bug report" and "Change proposal", a template chooser with no blank issue, and a pull request template with a checklist. GitHub shows them in every repository of the organization that has none of its own, if `.github` is public; all the repositories of the organization are public too ([github/docs](https://github.com/github/docs/blob/e85b503/content/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file.md));
- keeps the shared workflows of CI, with actions pinned by a SHA:
  - the shared checks — the secrets scan, DCO, CodeQL, Scorecard and the documents check. Every repository takes them, `spec` too, even before its code; `spec` has its own documents check, `just docs-check`. Scorecard is shared: the Scorecard server accepts the result of a shared workflow. `spec` and all eleven component repositories call them;
  - for code — Go and TypeScript, wrappers over the repository's recipes with the license check inside, and the release with a signature. Each comes into a repository with the code it checks. The wrappers take the license list and the check of the npm lock file as `spec`'s recipes, and the release calls `spec`'s release recipes by its script `tools/toolchain/toolchain.sh`. `spec` cannot call the shared release — that one takes the recipes from the caller's `spec` submodule — and its `release.yml` is its own: it signs the files with the same keyless cosign and publishes the types package `@altnovatrail/spec` to npm by the steps of the shared release, copied into it. For its Go code `spec` calls the shared Go wrapper as any repository in Go does — the job "Go" with its own recipes `ci-*`;
  - the composite action `toolchain`, `.github/actions/toolchain`, for a job of the caller's own that runs Go in its stage `toolchain`: the image of the stage and the caches of Go from the caller's cache of GitHub Actions, and their save on a push to `main`, by the steps that `go.yml`'s job `arm64` takes from it too. It comes out in the releases of the workflows and is pinned the same way;
- the shared workflow of the release signs module packages too. One recipe of `spec`, `release-verify`, checks the signature, where the file enters NovaTrail. The library of `module-kit` checks no signatures: it checks a package by the chain of digests from the index that a pull request of `api` pinned. The same workflow publishes the UI package from the signed release to npm, in the scope `@altnovatrail`, as the same file, through trusted publishing, when the caller has named the package by the input `npm-package`.

**Does not:**
- does not stand in for the files that a repository has of its own: GitHub takes a default file only when there is none of the repository's own. With issue templates it is stricter: a form or a `config.yml` of the repository's own in its `.github/ISSUE_TEMPLATE` drops all the shared ones, so a repository sets up no templates of its own;
- does not give the license for other repositories: there is no default LICENSE, and each repository has its own;
- does not repeat the rules: CONTRIBUTING leads to `RULES.md` and the repository's CLAUDE.md, and a copy would drift from them;
- holds no code of the platform: while the platform runs nobody calls `.github`, and the platform's overall diagram in `spec/docs/architecture.md` does not have it. It has one Go code of its own — the CI tool `tools/coderules/`, the test of the rules of code that the shared `go.yml` with `same-bits` runs on the caller's code. The same `go.yml` checks it, and its coverage goes to Codecov.

**Data and links:**
- no learners' data and no secrets, as in no repository;
- at build time it depends on nothing but `spec`, like all;
- every repository takes the shared checks of CI, `spec` too, even before code. Into a repository made from the repository template of spec, the language checks, the justfile and the signed releases come with its code;
- its services are GitHub and Sigstore: CI, releases, keyless signing — the npm registry, where the shared release publishes the UI packages, and Codecov, where the Go and TypeScript wrappers send the caller's test coverage, by OIDC. The README badges are those `spec/docs/repositories.md` sets for every repository, their images from shields.io, the Scorecard API, SonarCloud and Codecov, and SonarCloud's analysis is a required check;
- stage 0, together with `spec`.

## 2. To decide when detailed

The points "To decide when detailed" of the card, a subsection per point, and the gaps found on the way. An open point names where it will be decided: a task in [RUN.md](../RUN.md) or the epic that will bring it. A decided point says what was decided, the log says why and what was rejected, and its design is below. A question that goes beyond this repository goes «в реестр spec».

### 2.1. Shared workflows and a repository's own

- **Gist:** which CI workflows live in `.github` and are called by all repositories, and which each repository has of its own — the point "To decide when detailed" of the card.
- **Decided:** the checks that are the same in every repository and the wrappers for code are shared workflows of `.github`, and a repository's own are what only it knows; the shared ones come out in releases and are pinned by a SHA; a shared workflow takes no secrets. The design is below.

### 2.2. Scorecard from a shared workflow

- **Gist:** Scorecard with the publishing of its results puts restrictions on the workflow that runs it, and the Scorecard server may reject the result ([scorecard-action v2.5.0](https://github.com/ossf/scorecard-action/blob/fa7117d/README.md)). The calling file cannot keep them: its job has `uses:` of the shared workflow instead of steps, and `id-token: write`, while "Only the job with `ossf/scorecard-action` can use `id-token: write` permissions" ([scorecard-action v2.5.0](https://github.com/ossf/scorecard-action/blob/fa7117d/README.md)).
- **Decided:** Scorecard is the shared `scorecard.yml`. The server accepts the result both of `self-scorecard.yml` by the local path and of the shared file called from another repository by the full path: Scorecard's API returned a result for each, and the decision log names the runs and the commits (how the API answers, sources 6.3). That it checks the restrictions by the shared file follows from this and from its check of the branch by the caller ([scorecard-webapp#778](https://github.com/ossf/scorecard-webapp/pull/778), merged as [4fd7753](https://github.com/ossf/scorecard-webapp/commit/4fd77533bca17442608c5481cacc232d1a565018)); its documentation does not say so.
- **Pitfall:** a green job does not show that the result was accepted. When the server refuses, scorecard-action at the version `scorecard.yml` pins only warns and returns success, and has no input `fail_on_publish_error` ([scorecard-action v2.5.0](https://github.com/ossf/scorecard-action/blob/fa7117d/signing/signing.go), [its inputs](https://github.com/ossf/scorecard-action/blob/fa7117d/action.yaml)): the acceptance is seen in the Scorecard API and in the log of the run. A raise of the action in that file is when to look for the input and turn it on.

### 2.3. The signature of the shared release: whose identity

- **Gist:** keyless signing from the shared workflow of the release gets the identity of the shared workflow, not of the caller's `release.yml`.
- **Decided:** each file is signed by keyless cosign: the SAN and the Build Signer URI name the shared `release.yml` at the SHA the caller pinned it by, and the Build Config URI the caller's workflow (Fulcio at e742ea2: [the SAN](https://github.com/sigstore/fulcio/blob/e742ea2/docs/oidc.md), [the URIs](https://github.com/sigstore/fulcio/blob/e742ea2/docs/oid-info.md); measurements 5.2).
  - The consumer checks a file by one recipe of `spec`, `release-verify`, where the file enters NovaTrail: the SAN and the Build Signer URI are the shared `release.yml` at the SHA of a commit of a release of `.github` no lower than v0.1.7, on the history of its `main`, not a branch or a tag; the caller is the repository's `release.yml` on `main`, with the commit of the tag and the numeric IDs of the repository and the organization. It reads the list of releases of `.github` through git, without a token, and its condition is immutable releases and a ruleset of tags `v*` at `.github`, `spec` and each releasing repository, which a repository sets before its first release; it trusts the tags of `spec` under the same condition. The library of `module-kit` checks no signatures.
  - The shared release checks the signature of a file that came out on its rerun path by the same recipe, from the caller's `spec` submodule. A run that publishes stops first thing if the caller's workflow is not its `.github/workflows/release.yml` on `main`, or if the shared `release.yml` is pinned otherwise than by its own path at a SHA. The release checks the SHA's form as a string; whether it is a release of `.github` no lower than v0.1.7 is the consumer's check. The design is below, with the shared workflows.

### 2.4. Which commits of `main` get a release

- **Gist:** the shared workflows come out in releases, as `spec`'s files do. But `spec` releases every green commit of `main`, and `.github` has commits that do not touch what the callers take: the profile, the community health files, its own `self-` workflows, the documents.
- **Decided:** a release goes to a commit that changes what the callers take since the previous release, and the first release always comes out. The design is below, with the versions and updates.

### 2.5. How `.github` counts the release number

- **Gist:** at `spec` the number is counted by `tools/release/version.mjs` with tests, and the recipe `release-version` of its justfile feeds it three lists of tags `v*`: all the tags, the tags from the history of the commit being released, and the tags on that commit itself.
- **Decided:** `spec`'s recipe `release-version` counts it, by its interface for other repositories, and reads the line from `RELEASE_LINE` of `self-release.yml` of the commit being released. The design is below, with the versions and updates.

### 2.6. The `cooldown` pause for references to `.github`

- **Gist:** Dependabot waits three days after a version comes out before it proposes the version — so `dependabot.yml` of `spec` says for each ecosystem. It raises the references to the shared workflows in the same ecosystem `github-actions`.
- **Decided:** three days, as for everything. The design is below, in the calling files and the versions and updates.
- **How it acts:** the pause holds the references to `.github` too: for dependabot-core a reference to a reusable workflow is a dependency of the ecosystem `github-actions`, and the same code checks the pause for it as for an action (dependabot-core at fda701f: [the parser](https://github.com/dependabot/dependabot-core/blob/fda701f/github_actions/lib/dependabot/github_actions/file_parser.rb), [the pause](https://github.com/dependabot/dependabot-core/blob/fda701f/github_actions/lib/dependabot/github_actions/update_checker/latest_version_finder.rb)). The count runs from the date of the tag, to the day, and the tag of a GitHub release is lightweight, its date the date of the commit ([the tags' dates](https://github.com/dependabot/dependabot-core/blob/fda701f/common/lib/dependabot/git_metadata_fetcher.rb); [git v2.56.1](https://github.com/git/git/blob/03b4152/Documentation/git-for-each-ref.adoc)). So after a release that came out minutes after the merge, the pause lasts from two to three days, as the Dependabot pull requests of `spec` showed ([spec#40](https://github.com/altnovatrail/spec/pull/40), [spec#49](https://github.com/altnovatrail/spec/pull/49)); a release that came out later than its commit gets a shorter pause — a point of its own below.

### 2.7. How a shared workflow reads the files of `.github` of its own version

- **Gist:** a shared workflow may need data — the license list of the Go wrapper, the version and the sum of gitleaks. `actions/checkout` in it takes the calling repository, not `.github` ([github/docs](https://github.com/github/docs/blob/e0b0c90/content/actions/concepts/workflows-and-actions/reusing-workflow-configurations.md)); a reusable workflow takes its own repository at its own version by `actions/checkout` with `repository: ${{ job.workflow_repository }}` and `ref: ${{ job.workflow_sha }}` ([github/docs](https://github.com/github/docs/blob/e0b0c90/content/actions/reference/workflows-and-actions/contexts.md)).
- **Decided:** the data is in the file of the shared workflow itself, so a change of the data is a change of the shared workflow, which gives a release, and the caller gets the data of the version it is pinned at. `go.yml` keeps the one copy of `spec`'s license list, which `self-ci.yml` holds to the output of `spec`'s recipe `licenses-allowed`; `typescript.yml` keeps none: a TypeScript caller's `ci-licenses` checks the lock file by a recipe of `spec` and takes the list from there. Code or data too large for the file is taken by a second checkout by `job.workflow_sha`: so `go.yml` with `same-bits` runs the tool `tools/coderules/` of its own release. The design is below.

### 2.8. Shared workflows from a repository named `.github`

- **Gist:** the shared workflows are to lie in `altnovatrail/.github`. That GitHub calls workflows from a repository with such a name, and that Dependabot raises the references to it, the documentation does not say; the example of `nodenv/.github` and issue #12489 of dependabot-core show it (sources 14.2).
- **Decided:** they stay in `.github`. The callers call them by the full path, `altnovatrail/.github/.github/workflows/<file>@<sha>`, and their checks run. Dependabot raises the references to `.github` — at a caller, in one pull request, by the group `shared-workflows` of the calling files — and "DCO / sign-off" accepts the sign-off of `dependabot[bot]` by its named exception ([spec#40](https://github.com/altnovatrail/spec/pull/40)); the pause holds them.

### 2.9. Who sets the ruleset of `main` of `.github` itself

- **Gist:** each repository has its own ruleset of `main`, as `spec` requires of every one: only through a pull request, all checks required but Scorecard. `.github` writes its own workflows itself, so it sets its own ruleset.
- **Decided:** the ruleset 25477399, as at `spec`, with `.github`'s required checks, the rule `code_scanning` and merge commits only. `spec` requires the same of every repository. The design is below, in the calling files and `.github`'s own CI.

### 2.10. The pause of a release that came out later than its commit

- **Gist:** the pause of the references to `.github` is counted from the date of the release's tag, to the day, and the tag that `gh release create` makes is lightweight, dated by its commit; Dependabot reads the date from the tags of the repository's clone, not from the release ([dependabot-core at fda701f](https://github.com/dependabot/dependabot-core/blob/fda701f/common/lib/dependabot/git_metadata_fetcher.rb)). A release that comes out later than its commit — after a failed run put out by the button, or after a long queue — gets a pause shorter than three days, or none.
- **Decided:** the release comes out as before, and a Dependabot pull request with a late release is held by hand at the callers until three days have passed since the release came out.

### 2.11. The issue and pull request templates

- **Gist:** whether GitHub takes the issue and pull request templates from `.github` the same way as the community health files, and so where NovaTrail's lie.
- **Decided:** they lie here, as default files — the forms and `config.yml` in `.github/ISSUE_TEMPLATE/`, the pull request template `.github/pull_request_template.md`.

### 2.12. What the containers of `spec`'s recipes can change in the checkout

- **Gist:** `spec`'s script mounts the whole checkout for writing into each of its containers, `.git` too (`spec/tools/toolchain/toolchain.sh`). After these containers the runner of the shared `release.yml` reads this `.git`: `git diff` decides whether the release comes out, `git archive` builds the tree whose files are then signed, `git fetch`, when the Releases API refuses, goes by `.git/config`, and the post step of `actions/checkout` runs `git config` and `git submodule foreach` in the checkout at the end of the job ([actions/checkout v7.0.1](https://github.com/actions/checkout/blob/3d3c42e/src/git-auth-helper.ts); measurements 5.4). `self-release.yml` has the same, without `git archive`.
- **Decided:** `spec`'s recipes in both releases run in a copy of the checkout, whose copy of the script has its sum checked, and the runner's `git` reads only the checkout itself, which no container mounts. The build of the caller's files, `release-files`, runs in its own container and does not see the checkout. The release of `spec` is built the same way. The design is below.

### 2.13. Tests of the shared workflows

- **Gist:** code comes with its tests, by the shared rules: a pull request that adds or changes code adds or changes the tests of its automated suite too. Most of the code of `.github` is the shared workflows, YAML and steps in bash, which Codecov does not measure.
- **Decided:** the suite `tests/`. A step, taken out of its file word for word, runs on the runner with stubs, in cases where it passes and where it fails; the file is read by yq at the version and sum in `self-ci.yml`, and the suite runs as steps of the job "Workflows". A change of a step comes with its own cases, and the review of the pull request holds it, since Codecov does not measure bash. The design is below, in `.github`'s own CI.

## 3. Design

The first point decided which workflows are shared and which are a repository's own, how they are versioned, and how they treat secrets and forks. The external facts this rests on are the records of [sources.md](sources.md), the results of the trials are in [measurements.md](measurements.md), and a claim below names its record.

### 3.1. Shared workflows

A shared workflow lies directly in `.github/workflows/` of this repository, runs only through `on: workflow_call` and is called as `altnovatrail/.github/.github/workflows/<file>@<sha> # vX.Y.Z`. The permissions are given by the caller's job, and the shared workflow only lowers them; `actions/checkout` in it takes the caller's repository. A shared workflow takes no secrets. A shared action lies in a folder of `.github/actions/` and is a step of the caller's own job, `altnovatrail/.github/.github/actions/<name>@<sha> # vX.Y.Z`: there is one, `toolchain`, described at the end of the design.

**Before code — in every repository, `spec` included:**

| Workflow | What it does | Who calls it | Inputs | Permissions from the caller | What it needs from the repository | Check in the ruleset |
|---|---|---|---|---|---|---|
| `secrets.yml` | job `gitleaks`: the secrets scan by gitleaks over the whole history of the commit checked (`--log-opts=HEAD`), with `--redact` | all | none | `contents: read` | `.gitleaks.toml` with the repository's own exceptions — optional: gitleaks reads it from the folder it scans ([README](https://github.com/gitleaks/gitleaks/blob/v8.30.1/README.md) of v8.30.1, Load Configuration). It holds `[extend]` with `useDefault = true`, or it would replace the rules of gitleaks, and the check fails on such a file. On a pull request both it and `.gitleaksignore` are taken from the base, and `gitleaks:allow` comments have no effect: a pull request will not weaken the scan of its own commits | "Secrets / gitleaks", holds the merge |
| `dco.yml` | job `sign-off`: every commit of the pull request, but for merge commits, has a `Signed-off-by` of its author, by name and address; the commits are `git rev-list` between the parents of the pull request's merge commit, `HEAD^1..HEAD^2`, from a checkout with the full history, without the API; on another event it fails | all, the caller's job only on a pull request | none | `contents: read` | required sign-off of web commits: a commit made on github.com gets it only this way. The organization has it on | "DCO / sign-off", holds the merge |
| `documents.yml` | job `docs-check-repo`: takes a checkout with the submodule, and the submodule's script `spec/tools/toolchain/toolchain.sh` builds the stage `toolchain-core` or `toolchain`, as `go.yml`'s checks without a browser take it, from the caller's `.devcontainer/Dockerfile` and runs `docs-check-repo` in it. Without the script the step fails and names the reason. The image of the stage comes from the caller's GitHub Actions cache: `TOOLCHAIN_IMAGE_FILE` names the file of the stage, `${{ runner.temp }}/novatrail-<stage>.tar`, which the script loads or writes. Only a push to `main` saves it, and elsewhere the step hands the script the variable only with a file from the cache; file and key are those of `go.yml` and `typescript.yml` | all but `spec`: it has its own `just docs-check` | none | `contents: read` | `.devcontainer/Dockerfile` with the `toolchain` stage and the submodule `spec/` at a tag with the script and the recipe `docs-check-repo`, both from the repository template | "Documents / docs-check-repo", holds the merge |
| `codeql.yml` | CodeQL advanced setup: job `languages` builds the list — `actions` always and the caller's languages, each once; another language stops the check with the reason. A job `analyze` per language — `build-mode: none`, and for `go` `autobuild`, with Go of the caller's `toolchain` stage; `tools: linked`, the query suite `security-extended`, `category` — `/language:<language>`. A green analysis means that CodeQL ran through, not that it found nothing. The findings are held by the ruleset rule `code_scanning` | all | `languages` — the repository's languages beyond `actions`, separated by a space, a comma or a line: `javascript-typescript` and `go`; before code — empty; for `spec` — `javascript-typescript go`, for `tools/` and its Go modules. `paths-ignore` — the paths CodeQL does not read in the analysis of `javascript-typescript`, like `paths-ignore` of its configuration: bare paths, one per line, without quotes. Job `languages` makes a YAML string of them, and `init` gets it as the input `config`, but only for this analysis. The analysis of `actions` does not get them and reads every workflow. Nor does the analysis of `go` get them: a compiled language CodeQL reads by the build, and `paths-ignore` does not reach it ([github/docs](https://github.com/github/docs/blob/e0b0c90/content/code-security/reference/code-scanning/workflow-configuration-options.md)). A line that starts with `#` is a comment. A comma, a `#` after a space or a tab, a `- ` at the start and a quote at either end stop the check. For `spec` — `draft/**`, the prototype | `contents: read`, `security-events: write` | for `go` — Go of the `toolchain` stage of `.devcontainer/Dockerfile`, the one where the checks of `go.yml` run, pinned as at `spec`: `ARG GO_VERSION` and `GO_SHA256_AMD64` in that stage or one it is built from, the job running on X64. The analysis takes that archive of go.dev, checked by that sum, onto the runner, without building the stage; a Dockerfile that names them otherwise, or whose stages set a `GO*` or `CGO_*` but `GOTOOLCHAIN`, stops it with the reason. Go's autobuild first runs `make`, `ninja`, `./build` or `./build.sh`, if the root has such a file, — on the runner, not in the `toolchain` stage. The build executes Go and the pull request's code with the step's token — the same change the branch's author can make to the caller's workflow anyway; the default setup of code scanning is off. `paths-ignore` must not remove all the code of a language: then the analysis of that language fails — "CodeQL could not process any code written in JavaScript/TypeScript" (measurements 1.2). The input lives in the caller's workflow itself, so a pull request can change it together with its code. Only a review of the diff of `.github/workflows/` sees such a change, and the project has one author, and the ruleset requires no approvals | "CodeQL / analyze (<language>)", holds the merge. "CodeQL / languages" is not required: if it fails, there are no analyses at all, and the merge waits for them, and it names the reason |
| `scorecard.yml` | job `scorecard`: OpenSSF Scorecard with its results published, SARIF to code scanning; the job has only approved actions and not one script of its own | all, on a push to `main` and on a schedule | none | on the job — `contents: read`, `security-events: write` and `id-token: write`; at the workflow level — read only | the caller is a small separate file without `env` and `defaults` | "Scorecard / scorecard", does not hold the merge |

Dependabot signs off a commit with another address than the one the author is named by. In `spec`, in the commit c6b3cb5, the author is `dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>`, and the sign-off is `Signed-off-by: dependabot[bot] <support@github.com>`. So `dco.yml` checks the sign-off against the author by name and address, and for `dependabot[bot]` accepts this sign-off as a named exception: otherwise every pull request of Dependabot would be red. The exception holds only if the pull request was opened by `dependabot[bot]`, and the committer is `GitHub <noreply@github.com>`: anyone can set the author of a commit, but not the author of a pull request.

**With code — in the repositories with code;** a workflow comes into a repository with the code it checks:

| Workflow | What it does | Who calls it | Inputs | Permissions from the caller | What it needs from the repository | Holds the merge |
|---|---|---|---|---|---|---|
| `go.yml` | a job for each of the caller's four `just` recipes — `ci-lint`, `ci-test`, `ci-vuln` and `ci-licenses` —, in the `toolchain` stage of its `.devcontainer/Dockerfile`, as the runner's user. `ci-licenses` gets `ALLOWED_LICENSES` in its environment — the ASF's category A, as SPDX identifiers. Job `test` hands on the coverage report as the artifact `go-coverage`, and job `coverage` — the only one with `id-token: write`, after all four — sends it to Codecov by OIDC; its failure fails only a pull request. With the input `same-bits` — four more checks in the same stage. "Go / targets" holds the matrix `target`, a job "Go / target (<target>)" each, by one script in one container that runs the targets `TARGETS` names: `amd64-v3`, the tests at GOAMD64 v3; `cpu-off`, at v1 with `GODEBUG=cpu.all=off`; `386`; `js-wasm`, through `go_js_wasm_exec`; and `wasip1`, through an executor on `node:wasi` that the script writes outside the checkout, with `go vet`. The job `targets` after them, with `always()`, is red unless every one passed. `fma-diff` compares the assembler of every package with code, with fusion and with `-d=fmahash=n`, on six targets at once, each printed whole in their order, with its own control. `arm64` runs on `ubuntu-24.04-arm`: the caller's `ci-test` in its own container, and then the script of the targets on `cpu-off js-wasm wasip1`. `rules` holds the code to the rules of code by the tool `tools/coderules/` of `.github` of the same commit as the file `go.yml` — a second checkout by `job.workflow_repository` and `job.workflow_sha` —, with the caller's lists `.github/coderules.json`. Every job that runs Go takes `GOMODCACHE`, `GOCACHE` and `GOLANGCI_LINT_CACHE` from the caller's GitHub Actions cache, one folder mounted at `/go-cache`, by a key of the runner's OS and architecture, the check — for `target`, its target —, the Dockerfile and `go.sum`, and on its miss by the same key without `go.sum`, whose entry loses its modules and keeps its builds; `go mod verify` checks what the exact key gave in every module of the caller, and a push to `main` alone saves, under the exact key. The image of the stage comes from the job `toolchain`, "Go / toolchain", which on a miss alone builds it and hands it on by the artifact `go-toolchain-image`; the jobs on amd64 need it and run unless the run is cancelled, and `arm64` builds its own, taking it and the caches of Go by the composite action `toolchain` of its own commit, `$/.github/actions/toolchain`. `lint`, `vuln` and `licenses` run in `toolchain-core` where the Dockerfile has it and its `toolchain` holds more, by an entry and the artifact `go-toolchain-core-image` of their own | repositories of the kind go, `module-kit` among them, and `spec` over all its Go modules; with `same-bits` — `learner-model` and `engine` | `same-bits` — boolean, `false` by default | `contents: read`, `id-token: write`; the second for job `coverage`: a called workflow only lowers permissions | Go in the `toolchain` stage at an exact version and with `GOTOOLCHAIN=local`; recipes with these names, and `ci-licenses` by the list from `ALLOWED_LICENSES`. `ci-test` writes one coverage profile, `coverage/go.out`, over every package of every module, and without it "Go / test" is red. The caller has no artifacts of its own named `go-coverage`, `typescript-coverage`, `go-toolchain-image`, `typescript-toolchain-image` or their `-core-` twins: an artifact's name is unique in a run. Where the Dockerfile has a core, what `ci-lint`, `ci-vuln`, `ci-licenses` and `release-files` need is in it. The Codecov app sees the repository, and `codecov.yml` is as the calling files below give it. The code and the tests do not read `spec/`: the job takes a checkout without the submodule. The tools of the checks and their versions are the repository's own, and so are the exceptions of the license check, each with a decision. With `same-bits` — also Node in the `toolchain` stage, for js/wasm and for wasip1 by `node:wasi`, of a version that knows `--disable-warning` — v20.11 or newer on the line 20, v21.3 or newer from 21 on ([`cli.md`](https://github.com/nodejs/node/blob/v24.21.0/doc/api/cli.md) of Node v24.21.0), and `bash` in it, the tests pass without race detection too, on 386 and in wasm, and `.github/coderules.json` holds the caller's lists | yes: "Go / lint", "Go / test", "Go / vuln" and "Go / licenses", when the caller's job is named "Go", and with `same-bits` also "Go / targets", "Go / fma-diff", "Go / arm64" and "Go / rules". "Go / coverage", "Go / toolchain" and "Go / target …" do not hold the merge, but `codecov/patch` from Codecov does — once the author puts it in the ruleset |
| `typescript.yml` | the same for TypeScript, by the same contract: a job for each of `ci-lint`, `ci-test`, `ci-vuln` and `ci-licenses` in the caller's `toolchain` stage, as the runner's user. With the input `engines` — a fifth, `ci-engines`, the tests in WebKit and Firefox, as "TypeScript / engines" beside `ci-test`, which then runs Node and Chromium with the coverage. Job `licenses` takes the submodule `spec`, and `ci-licenses` checks the lock file by `spec`'s recipe `licenses-check-repo` from it. The container runs with `--init`, and for jobs `test` and `engines`, where the browsers start, also with `--ipc=host`. Of the environment only `CI` goes into it: by it Vitest does not let `test.only` through, and, if the configuration does not set `headless` itself, also runs the browser headless. It is worth setting it explicitly, `headless: true`: the development container has no `CI`. Coverage — as in `go.yml`: the lcov report as the artifact `typescript-coverage`, and job `coverage` sends it to Codecov. The image of the stage — by the job `toolchain` of `go.yml`, "TypeScript / toolchain", with the artifact `typescript-toolchain-image`; `lint`, `vuln` and `licenses` in `toolchain-core`, as in `go.yml` | repositories of the kind typescript, `canvas` and `app` among them | `engines` — boolean, `false` by default | `contents: read`, `id-token: write`, as for `go.yml` | Node in the `toolchain` stage at an exact version; `ci-test` writes the lcov report, `coverage/lcov.info`, and a module that no test loads is in it with zeros — by Vitest's `coverage.include` — or fails the recipe; a lock file and `.npmrc` with `ignore-scripts=true` and `save-exact=true`; recipes with these names — `ci-lint` checks the format, the lint and the types —, and each installs the packages itself, through `npm ci`; `ci-licenses` checks every package of the lock file by the recipe `just -f spec/justfile licenses-check-repo <lock-file> [<exceptions file>]` of its submodule `spec`, with the `dev` boundary. The exceptions are a JSON file of the repository's own, the recommended name `licenses.json`, each with a decision. The browsers for the tests are in the `toolchain` stage, only those the tests run, of the three of `spec`'s kind `typescript` — Chrome Headless Shell, WebKit and Firefox —, with `engines` WebKit and Firefox among them, of the revision that the Playwright of the lock file expects, at the path from `ENV PLAYWRIGHT_BROWSERS_PATH` of that stage, with the integrity by the rules and the terms named in the decision. Playwright's browser `chromium` is a build of Google Chrome for Testing on Google's terms, free for everyone, not Chromium under an open license. The shared rules of licenses accept them for a tool that never ships: NovaTrail does not distribute the browser, and the platform builds and runs without it. The checkout is without the submodule, but for job `licenses`: the code and the tests do not read `spec/`. Job `licenses`, like `documents.yml`, takes all the caller's submodules, so the repository has no submodules but the public `spec`. The tools of the checks and their versions are its own | yes: "TypeScript / lint", "TypeScript / test", "TypeScript / vuln" and "TypeScript / licenses", when the caller's job is named "TypeScript", and with `engines` also "TypeScript / engines". "TypeScript / coverage" and "TypeScript / toolchain" — no, as in `go.yml` |
| `release.yml` | a release with keyless signing. The number comes from `spec`'s release recipes, which the script `spec/tools/toolchain/toolchain.sh` from the caller's submodule runs, in the copy of the checkout: the recipes' containers change only it, and the runner's `git` reads the checkout itself. The line is `RELEASE_LINE` of the caller's workflow. A release comes out only if the paths of `paths` changed since the last one; the first always comes out. The files are built by the caller's recipe `release-files` from the commit's tree, in its stage `toolchain-core`, or `toolchain` without one, and the number in the same. Only the commit that the run itself names, `GITHUB_SHA`, is signed: its certificate names the same commit as the tag, and an older commit is covered by the release of the tip. Every file, module packages too, is signed by cosign with a bundle beside it, and every bundle is checked before publishing — against the shared `release.yml`, the caller's repository and this commit —, eight files at once, each with a copy of one TUF cache. A run that publishes first checks that the signature will be one that `release-verify` lets in: the caller's workflow is its `.github/workflows/release.yml` on `main`, and the shared `release.yml` is pinned by a SHA. The release is Latest and immutable; `gh release verify` checks its attestation by one call, and each file is held to the sha256 of a subject in it. With `npm-package` the same archive of the package goes to npm, through trusted publishing, after the release has come out and been checked. The archive is checked before the release already, and the number with it: a number that npm has already given out and a package unpublished whole stop the run before the release. A rerun for a commit already released publishes the archive from the release, after checking its attestation and signature. The signature is checked by `spec`'s recipe `release-verify`, and a dry run of the recipe goes before the build already. The publication is judged by the registry, not by npm's exit code. A version counts as published when the package's document has shown it and the registry has served its archive: the step waits for both in rounds, up to 20 minutes, within the job's `timeout-minutes`. With the input `previous-file` the recipe gets the file of the last release: before the build the step "The previous release's file" downloads it with its bundle from the newest release, checks the attestation, and the signature by the recipe `release-verify`, and hands it to the recipe as the second argument, read-only. The first release gets an empty second argument, and a file that cannot be downloaded or checked stops the run before the build | `module-kit`, `modules` and the other repositories with releases; with `npm-package` — the repositories with UI packages, `canvas` among them | `paths` — pathspecs of what the release is built from, one per line; `publish` — `false` for a trial without publishing; `npm-package` — a package in the scope `@altnovatrail` that the release publishes to npm, empty — publishes none; `previous-file` — the name of the file of the last release that the recipe gets, for example `module-index.json`, empty — gets none | `contents: write`, `id-token: write`, `actions: read` | a recipe `release-files VERSION` that writes plain files with safe names into `dist/`. It builds from the commit's tree without history or submodules, so it has no `git`, and the version comes as an argument; `RELEASE_LINE` in its own `release.yml`; CI — `ci.yml`; immutable releases and a ruleset of the tags `v*` — a condition of the signature check; the submodule `spec` — `altnovatrail/spec` at a tag with the script and the recipe `release-verify`: otherwise the run stops before the build and names the reason. The workflow is `.github/workflows/release.yml`, and it pins the shared `release.yml` by the SHA of a release: otherwise a run that publishes stops first thing. With `npm-package` — the `npm pack` archive among the files of `dist/`. With `previous-file` — the recipe `release-files VERSION PREVIOUS` with two parameters, and among the files of `dist/` a file with this name. In `package.json` — `repository` as an object with the URL of this repository, without `private`, `publishConfig` or a `tag` of its own. The first version of the package is published by hand, and the package's trusted publisher names the repository and the file of the caller's release workflow, with no environment, and allows `npm publish` | no: it is not a check of a pull request |

The license list for `go.yml` and `typescript.yml` is one for all — category A of the ASF's policy, as in `spec`'s check. For Go it lies in `go.yml` itself, `ALLOWED_LICENSES`, and `self-ci.yml` checks it against what `spec`'s recipe `licenses-allowed` prints. `typescript.yml` has no copy: the `ci-licenses` of a TypeScript caller checks the lock file by `spec`'s recipe `licenses-check-repo` and takes the list from `spec`, at the tag of its submodule. Each has an input of its own — `same-bits` and `engines` —, and their four recipe names are the same — above. Both send coverage by the same job `coverage`, and they differ only in the artifact's name and the report file. Only this job has the permission `id-token: write`: the jobs of the matrix execute the pull request's code. Every job of both that builds the image of the `toolchain` stage takes it from the caller's GitHub Actions cache — a `docker save` file by a key of the runner's OS and architecture and the hash of the Dockerfile, `${{ runner.temp }}/novatrail-toolchain.tar` of the image `novatrail-toolchain`, as `documents.yml` and `spec`'s `toolchain.sh` have it, so a caller keeps one entry of the image —, and on a miss the job `toolchain` alone builds it for the jobs after it, which take it by an artifact of the run; only a push to `main` saves it. The core, where it is a stage of its own, has its own file, `novatrail-toolchain-core.tar`, entry and artifact. The jobs of `go.yml` take the caches of Go the same way; the shared release takes no cache.

The names of the jobs in the shared workflows and in the calling files are the same for every repository: a required check is named "`<job name> / <reusable job name>`" ([github/docs](https://github.com/github/docs/blob/e0b0c90/content/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/troubleshooting-rules.md)), and the ruleset of `main` in every repository lists the same names — but for CodeQL, which has a check per language of the repository. The caller's job is named after the check — "Secrets", "DCO", "Documents" —, and the shared workflow's job after what it runs.

### 3.2. The repositories' own workflows

A repository's own is what only that one repository knows. Its own checks run in the `toolchain` stage of its devcontainer, as in `spec`.

| Repository | Its own workflows and checks |
|---|---|
| `spec` | `ci.yml` — "Documents and tools": `docs-check`, `format-check`, `types-check`, `go-check`, the license check of `tools/`, the number and the files of the release and the tests of `tools/` with coverage — and "Coverage", the upload of the coverage of `tools/` to Codecov by OIDC; beside them job "Go", the shared `go.yml` with its own recipes `ci-*`, which sends the coverage of Go. `release.yml` — its own release: the format's files and the types package, the cosign signature and the publishing of `@altnovatrail/spec` to npm by the steps of the shared release |
| `.github` | `self-ci.yml`, `self-release.yml`, `self-codeql.yml` and `self-scorecard.yml` — `.github`'s own CI, below |
| `modules` | the check of the packages by the CLI of `module-kit` and by the learner simulator `sim`, at tags; from stage 2 — eval with a key of the platform, by the rule of secrets and forks below |
| `learner-model`, `engine` | the gate of `sim` at a tag through `go.work` |
| `canvas` | the build of the samples page with the CLI of `module-kit` and the release of `modules`, at a tag |
| `api` | the SDKs of AI providers come only through `tutor` |
| `module-kit`, `engine`, `sim` and the widgets | the test vectors of the generator of randomness and of the derivation of seeds (Т-18) |

SonarCloud is not a workflow: the analysis is automatic, and its check is set by the SonarQube Cloud app.

### 3.3. Calling files

Every repository of a component has the same files; they differ only in the inputs of CodeQL — `languages` and `paths-ignore` —, in what the kind of the repository adds: for the kind go, job "Go" and the ecosystem `gomod`, for the kind typescript, job "TypeScript" and the ecosystem `npm` —, and in their own jobs. A file pins a shared workflow by the SHA of a release of `.github`, with its tag in a comment on the same line, and Dependabot raises both. The texts below are ready to copy, with the latest release in place of `<sha> # <version>`: its tag is named by `gh release view -R altnovatrail/.github --json tagName --jq .tagName`, and its commit by `git ls-remote https://github.com/altnovatrail/.github refs/tags/<tag>`. How `spec` and `.github` differ comes after them; no check of this repository reads these texts.

`.github/workflows/ci.yml` — on a pull request and a push to `main`; beside the three shared ones go the repository's own jobs. Job `documents` requires `.devcontainer/Dockerfile` with the `toolchain` stage and the submodule `spec/` at a tag with the recipe `docs-check-repo`:

```yaml
# Dependabot raises the SHA of a release of .github and the tag beside it together.
name: CI

on:
  pull_request:
  push:
    branches: [main]

permissions:
  contents: read

# A new push to a pull request cancels its older run; every commit to main is checked.
concurrency:
  group: ci-${{ github.event_name == 'pull_request' && github.ref || github.sha }}
  cancel-in-progress: ${{ github.event_name == 'pull_request' }}

jobs:
  secrets:
    name: Secrets
    uses: altnovatrail/.github/.github/workflows/secrets.yml@<sha> # <version>

  # A pull request's commits are what it checks; a push to main has been checked as one.
  dco:
    name: DCO
    if: github.event_name == 'pull_request'
    uses: altnovatrail/.github/.github/workflows/dco.yml@<sha> # <version>

  documents:
    name: Documents
    uses: altnovatrail/.github/.github/workflows/documents.yml@<sha> # <version>
```

`.github/workflows/codeql.yml` — on a pull request and a push to `main`. It is not run weekly: the CodeQL bundle is pinned together with the action. The repository's languages beyond `actions` go in the input `languages`, `javascript-typescript` and `go`, and then "CodeQL / analyze (<language>)" goes into the ruleset of `main` too:

```yaml
# A called workflow only lowers what its caller's job gives: security-events: write is for the
# upload of the results.
name: CodeQL

on:
  pull_request:
  push:
    branches: [main]

permissions:
  contents: read

concurrency:
  group: codeql-${{ github.event_name == 'pull_request' && github.ref || github.sha }}
  cancel-in-progress: ${{ github.event_name == 'pull_request' }}

jobs:
  codeql:
    name: CodeQL
    permissions:
      contents: read
      security-events: write
    uses: altnovatrail/.github/.github/workflows/codeql.yml@<sha> # <version>
```

`.github/workflows/scorecard.yml` — on a push to `main` and weekly:

```yaml
# No env or defaults, and only read permission at the top: the Scorecard server takes the result
# of a workflow that publishes only so.
name: Scorecard

on:
  push:
    branches: [main]
  schedule:
    - cron: "41 4 * * 1"

permissions:
  contents: read

jobs:
  scorecard:
    name: Scorecard
    permissions:
      contents: read
      security-events: write
      id-token: write
    uses: altnovatrail/.github/.github/workflows/scorecard.yml@<sha> # <version>
```

`.github/dependabot.yml` — weekly, as in `spec`: `github-actions` in `/`, which raises the references to the shared workflows too, and `docker` in `/.devcontainer`; the ecosystems of the languages come with code. Every ecosystem has the `cooldown` pause of three days. It does not hold back the base image, but it holds back the references to `.github`. The references to the shared workflows go as one group, `shared-workflows`: all in one pull request, to one release, not a pull request per file:

```yaml
version: 2

updates:
  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: weekly
    cooldown:
      default-days: 3
    groups:
      # One pull request moves every reference to .github to one release; Dependabot names them
      # altnovatrail/.github/.github/workflows/<file>.yml and …/actions/toolchain.
      shared-workflows:
        patterns: ["altnovatrail/.github/*"]

  - package-ecosystem: docker
    directory: /.devcontainer
    schedule:
      interval: weekly
    cooldown:
      default-days: 3
```

The group:
- **the name of a reference** — in dependabot-core a reference to a reusable workflow is a dependency named "repository and workflow path", `altnovatrail/.github/.github/workflows/<file>.yml`. And `*` in `patterns` matches any characters, `/` too, ignoring case (dependabot-core at fda701f: [the parser](https://github.com/dependabot/dependabot-core/blob/fda701f/github_actions/lib/dependabot/github_actions/file_parser.rb), [the pattern](https://github.com/dependabot/dependabot-core/blob/fda701f/common/lib/wildcard_matcher.rb)). Actions of other owners are not in the group and go a pull request per action;
- **the pause** of the group is the same: an update of the group checks every reference by the same check with the `cooldown` of the Dependabot job ([dependabot-core at fda701f](https://github.com/dependabot/dependabot-core/blob/fda701f/updater/lib/dependabot/updater/group_update_creation.rb)). The group waits three days, as each reference alone does;
- **holding back one reference** is not possible with the group: there is one pull request. A release that came out later than its commit is held back by hand, whole;
- **`.github` itself** has no group: its own `self-` workflows call the shared ones by a local path, `./.github/workflows/<file>.yml`, and Dependabot does not raise such a reference ([github/docs](https://github.com/github/docs/blob/e0b0c90/data/reusables/actions/dependabot-version-updates-actions-caveats.md); [dependabot-core at fda701f](https://github.com/dependabot/dependabot-core/blob/fda701f/github_actions/lib/dependabot/github_actions/file_parser.rb)).

Dependabot raises the references to `.github`, the pause holds them, and DCO accepts the sign-off of its commit. The policy of actions does not hinder the call: `.github`, `spec`, `module-kit` and `tutor` have `allowed_actions: all` and `sha_pinning_required: true` (sources 3.3), and the references by a SHA keep it; the server of Scorecard accepts the result of the shared workflow.

`.sonarcloud.properties` — without `spec/**`, which SonarCloud analyses in `spec` itself:

```properties
sonar.exclusions=spec/**
```

A repository in Go adds to `ci.yml` the job "Go", which calls the shared `go.yml`:

```yaml
  # id-token: write is for the coverage job alone, which sends the coverage to Codecov by OIDC: a
  # called workflow can only lower what this job gives it.
  go:
    name: Go
    permissions:
      contents: read
      id-token: write
    uses: altnovatrail/.github/.github/workflows/go.yml@<sha> # <version>
```

A repository whose bits must be the same on every build — `learner-model` and `engine` — adds to job "Go" the input `same-bits`:

```yaml
    with:
      # The bits stay the same on every build: the checks it adds need .github/coderules.json.
      same-bits: true
```

With it:
- the ruleset of `main` gets also "Go / targets", "Go / fma-diff", "Go / arm64" and "Go / rules", once they have first come to `main`, a step of the author's outside the repository;
- the repository has no recipes, jobs or tests of its own for what these checks do: `fma-diff` has its own control, and "Go / arm64" runs on arm64;
- `.github/coderules.json` holds the lists, which the tool `tools/coderules/` reads with `DisallowUnknownFields`. Each field is a list, empty if the file does not name it: `code-imports` — the packages the code may import, besides its own; `test-imports` — what the tests may import beyond them; `test-math` — the functions of `math` the tests may call beyond those the rules allow everyone; `requires` — the modules `go.mod` may require; `nested-modules` — the folders from the root where the `go.mod` of a nested module may lie, as the lock file of a tool that the code does not read. Without the file "Go / rules" fails and names the reason. The rules, and what they allow everyone of `math`, `strings` and `strconv`, are in the tool, not in the lists. The files of `learner-model` and `engine` are the examples: [learner-model](https://github.com/altnovatrail/learner-model/blob/main/.github/coderules.json), [engine](https://github.com/altnovatrail/engine/blob/main/.github/coderules.json).

And to `dependabot.yml` — the ecosystem `gomod`, with the same pause. Dependabot does not see Go in the Dockerfile or the tools that the recipes run through `go run` at an exact version, and they are raised by hand:

```yaml
  - package-ecosystem: gomod
    directory: /
    schedule:
      interval: weekly
    cooldown:
      default-days: 3
```

A repository in TypeScript adds to `ci.yml` the job "TypeScript", which calls the shared `typescript.yml`. Its `ci-licenses` checks the lock file by `spec`'s recipe `licenses-check-repo`, which job `licenses` takes from the submodule. What is needed of the recipes, `.npmrc` and the `toolchain` stage is in the table of the shared workflows.

```yaml
  # id-token: write is for the coverage job alone, which sends the coverage to Codecov by OIDC: a
  # called workflow can only lower what this job gives it.
  typescript:
    name: TypeScript
    permissions:
      contents: read
      id-token: write
    uses: altnovatrail/.github/.github/workflows/typescript.yml@<sha> # <version>
```

A repository that tests in WebKit and Firefox, as `app` and `canvas`, gives the job the input `engines`. `ci-test` keeps Node and Chromium, `ci-engines` runs WebKit and Firefox, and "TypeScript / engines" enters the ruleset once on `main`:

```yaml
    with:
      engines: true
```

And to `dependabot.yml` — the ecosystem `npm`, with the same pause; `directory` is the folder of `package.json`. Dependabot does not see Node in the Dockerfile or the browsers for the tests, and they are raised by hand, like Go: in the Dockerfile it reads only the `FROM` lines ([dependabot-core at fda701f](https://github.com/dependabot/dependabot-core/blob/fda701f/docker/lib/dependabot/docker/file_parser.rb)), and the Playwright image stands in `COPY --from`. So a pull request that raises `playwright` is red until the tag and digest of the image and the browser's revision are raised by hand in it too:

```yaml
  - package-ecosystem: npm
    directory: /
    schedule:
      interval: weekly
    cooldown:
      default-days: 3
```

With tests in Vitest and with `@types/node`, two more additions go to the entry, as at `canvas`. The group `vitest` is needed because `@vitest/browser-playwright` requires `vitest` at an exact version, and separate pull requests would be red. The `ignore` of the major versions of `@types/node` is there because the types follow Node, which is raised by hand:

```yaml
    groups:
      # @vitest/browser-playwright pins vitest exactly, so the two move in one pull request.
      vitest:
        patterns: ["vitest", "@vitest/*"]
    ignore:
      # The types of Node follow the major version of the Node in .devcontainer/Dockerfile, which
      # moves by hand.
      - dependency-name: "@types/node"
        update-types: ["version-update:semver-major"]
```

**Coverage.** A repository with the job "Go" or "TypeScript" sends the coverage of its tests to Codecov from the wrapper. Its `ci-test` writes the report — for Go the profile `coverage/go.out`, for TypeScript lcov `coverage/lcov.info` —, and `.gitignore` keeps `coverage/` out. The Codecov app is installed for the organization on all repositories (sources 10.3), so it needs no setup. `.github/codecov.yml` follows the `codecov.yml` of `spec`: a threshold of 90% for the changed lines, and a comment only when the coverage changes. A Go profile names a file by its import path, which for NovaTrail's modules is `github.com/altnovatrail/<repository>`, and Codecov cuts it down to the path in the repository by itself, by a default rule (measurements 4.1). So the file has no `fixes` of its own:

```yaml
# The report is the one ci-test writes, which the coverage job of .github's go.yml or
# typescript.yml uploads. Codecov cuts the import path that a Go profile names a file by down to
# its path in the repository, by a default rule of its own.

coverage:
  status:
    # A pull request that changes no line of the report passes as "Coverage not affected".
    patch:
      default:
        target: 90%
    # Codecov sets no project status for a public repository on its plan; should it set one, the
    # status only informs.
    project:
      default:
        informational: true

comment:
  layout: "condensed_header, diff, files"
  require_changes: true
```

The job comes with its coverage in one pull request: `ci-test` with the report, `.gitignore`, `codecov.yml` and the `permissions` of the job, as in the texts above. Without the permission the run of CI does not start at all — "The nested job 'coverage' is requesting 'id-token: write', but is only allowed 'id-token: none'" —, and without the report "… / test" is red (measurements 4.1). After the first upload on `main`, `codecov/patch` goes into the ruleset of `main`, with `integration_id` 254, as at `spec`: a step of the author's outside the repository. While `main` has no report, `codecov/patch` comes as a success — "No report found to compare against" (measurements 4.1). The coverage badge goes into the README with the first upload on `main`, as `spec/docs/repositories.md` sets for the badges.

The caller creates no artifacts `go-coverage` and `typescript-coverage` of its own: an artifact's name is unique within a run. A repository with Go and TypeScript writes the Go profile after the tests of Vitest: Vitest clears `coverage/` before its tests. It has two uploads per commit, and it adds `codecov: {notify: {after_n_builds: 2}}` to `codecov.yml`. By default Codecov waits for one report, and `wait_for_ci` waits only for the end of the statuses of CI, so the status could go out on the first report (sources 10.3). At `spec`, its own upload sends the lcov of `tools/` beside the Go profile that `go.yml` sends.

A repository with releases adds `.github/workflows/release.yml`, which calls the shared `release.yml`; what it needs of the repository is in the table of the shared workflows. A run that publishes stops before anything else if the caller's workflow is not `.github/workflows/release.yml` on `main`, or if the shared `release.yml` is pinned other than by its own path and a SHA: `release-verify` would reject the signature of such a run, and the files of a release are immutable. The template below keeps both. The `paths` list lists what the output is built from, by the kind of the repository, and not everything but the exclusions: `spec` gives the rule it is made by, and this section keeps the lists. Below is the list of the kind go: the Go code without the tests, `go.mod`, `go.sum`, `justfile`, `LICENSE`, the whole `.devcontainer/Dockerfile` — Go is pinned in it — and `release.yml` itself, so that a change of the line gives a release. `*.go` in a git pathspec without the magic `glob` takes files at any depth, and `**/*.go` would miss a Go file in the root (measurements 2.2). The files that the code embeds by `//go:embed` the caller adds to the list itself, and the code in `testdata/`, which is not part of the build, it excludes itself: the list holds what the consumer will get. The lists of the kinds typescript and modules are below, after the input `previous-file`. The caller's job sets no `concurrency` of its own: the shared job waits in the queue `release` by itself:

```yaml
# The signature lets a release into NovaTrail only from this file on main, with the shared release
# pinned by a SHA. RELEASE_LINE is the line the releases are numbered in.
name: Release

on:
  workflow_run:
    workflows: ["CI"]
    types: [completed]
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read

env:
  RELEASE_LINE: "0.1"

jobs:
  release:
    name: Release
    permissions:
      contents: write
      id-token: write
      actions: read
    uses: altnovatrail/.github/.github/workflows/release.yml@<sha> # <version>
    with:
      paths: |
        *.go
        :(exclude)*_test.go
        go.mod
        go.sum
        justfile
        LICENSE
        .devcontainer/Dockerfile
        .github/workflows/release.yml
```

Before a repository's first release, immutable releases are turned on for it (`PUT repos/altnovatrail/<repository>/immutable-releases`) and a ruleset of the tags `v*` is set: `update`, `deletion` and `non_fast_forward`, with no bypass, as the ruleset 25452244 of `.github`. Without them the check of the signature cannot rely on the tag: that is its condition. Both are the author's steps outside the repository.

An edit of `RELEASE_LINE` gives a release by itself: the caller's `release.yml` is in the list. Edits that may leave the output unchanged give a release too: the tools of the `devcontainer` stage in the Dockerfile, a raise of the reference to the shared `release.yml`, and a new base image — the `toolchain` stage is built in it. The raise of the reference and the image come as pull requests of Dependabot, once a week, and the image also without the pause.

A repository with a UI package adds the line `npm-package: "@altnovatrail/<name>"` to `with:`. Then the same archive that is signed in the release, `<scope>-<name>-<X.Y.Z>.tgz`, as `npm pack` names it, goes to npm by trusted publishing. The author's steps outside the repository, in the task of the repository that releases the package:
1. the first release comes out without `npm-package`: a trusted publisher is set up only for a package that is already in the registry;
2. the author checks the archive of this release — `gh release verify-asset` and the signature — and publishes it by hand from an empty folder, with 2FA: `npm publish ./<archive>.tgz --access public`. This version has no provenance;
3. the trusted publisher: `npm trust github @altnovatrail/<name> --file <file of the release workflow> --repository altnovatrail/<repository> --allow-publish`, or the same on the npm site. There is no environment, and direct publishing is allowed: a new setting allows only staged publishing by default (sources 8.1);
4. within 2 days of the setup (sources 8.1), the first publishing by it must go through — the pull request that adds `npm-package`. The edit of `release.yml` gives a release by itself if the file is in the `paths` list, as above.

If npm refuses when the GitHub release has already come out, the run is rerun: the rerun takes the archive from the release, checks the attestation, and the signature by the recipe `release-verify` of `spec`, and publishes it. The button does the same if the released commit is still the tip of `main`. Otherwise the author publishes the same checked file by hand: the next release does not publish the old version. A number that npm has already given out — unpublished, or with another archive — npm will never take. The run then fails before the release and says to raise `RELEASE_LINE`: every release of the line would take the same number. A package unpublished whole takes no new versions for 24 hours, and then its next version is published by hand, like the first, and the trusted publisher is set again if it is gone: whether it outlives the package, npm's documentation does not say. The package's `package.json` has `repository` as an object with the repository's url, and no `private`, `publishConfig` or `tag` of its own: otherwise the run stops even before the release and names the reason.

A repository whose release is built on a file of the previous release — `modules` with its cumulative index — adds the line `previous-file: module-index.json` to `with:`. Then:
- the recipe takes two parameters, `release-files version previous:`. As the second it gets the path `/previous/module-index.json` to the file of the newest release, checked before the build — read-only —, and the first release gets an empty string. An empty string is what means "there is no previous", and the recipe tells the build so explicitly. The recipe and the input change together: just, given two arguments for a recipe with one parameter, answers "justfile does not contain recipe …" with the second argument — empty on the first release, `/previous/module-index.json` on the next ones —, and given one for a recipe with two, "got 1 positional argument but takes 2" (measurements 5.1). The run then stops before the release;
- among the files of `dist/` is a file of the same name: the next release will take it from this one, and without it the run will stop before the release;
- the input can be set from the repository's first release too. If it is added later, the file must already be in the newest release, signed by the shared release v0.1.7 or newer: otherwise `release-verify` will not let it in, and the run will stop before the build;
- a run that failed to read Sigstore, GitHub or the npm registry is rerun: the recipe then refuses, and there is no release yet.

The list of the kind typescript is for a repository whose output is an npm package built by the TypeScript compiler, as at `canvas`. Where a caller's list diverges from it, the template is right. The caller's `with:` holds the names of its own build files — below, those of `canvas`:

```yaml
      paths: |
        src/*.ts
        :(exclude)src/*.test.ts
        :(exclude)src/*.fixture.ts
        :(exclude)src/*.check.ts
        package.json
        tsconfig.base.json
        tsconfig.build.json
        justfile
        README.md
        LICENSE
        NOTICE
        .devcontainer/Dockerfile
        .github/workflows/release.yml
      npm-package: "@altnovatrail/<name>"
```

- The list holds the package's code without the tests, the fixtures and the type checks `*.check.ts`. `src/*.ts` without the magic `glob` takes files at any depth, as `*.go` does for the kind go, and so do the exclusions.
- `package.json` and the compiler configurations the package is built by — at `canvas`, `tsconfig.base.json` and `tsconfig.build.json`. The lock file is not in the list: it does not go into the archive, and the compiler is pinned at an exact version in `package.json`.
- `README.md`, `LICENSE` and `NOTICE` are files of the archive: `npm pack` always puts README and LICENSE into the archive, and at `canvas` `NOTICE` goes into the archive by a decision of `canvas`. A repository without `NOTICE` does not name it.
- `.devcontainer/Dockerfile` — whole, as for the kind go: its `toolchain` stage holds Node and npm, with which the recipe `release-files` packs the archive.
- `justfile` with the recipe `release-files`, and `release.yml` itself, as for the kind go.
- The differences from the kind go are only the sources and the build files. A file that the archive takes from outside the list, the caller adds itself: the list holds what the consumer will get.

The list of the kind modules is for a repository whose output is module packages and their index; the architecture and the log of `modules` take it from here. Where a caller's list diverges from it, the template is right. In the caller's `with:`:

```yaml
      paths: |
        :(glob)modules/**
        :(exclude,glob)modules/*/eval/**
        withdrawals.yaml
        justfile
        LICENSE
        .github/workflows/release.yml
      previous-file: module-index.json
```

- The list holds the folders of the modules without their eval sets, the withdrawals file `withdrawals.yaml`, `justfile` with the recipe `release-files`, the root's `LICENSE` and `release.yml` itself. Withdrawals are an input of the build of the index, so a pull request with only a withdrawal gives a release.
- `.devcontainer/Dockerfile` is not in the list, unlike the kind go. A package and the index depend only on the module's files and the format version of its manifest, not on the version of the CLI of `module-kit` in the Dockerfile. So a raise of the CLI or of the base image gives no release.
- The price is the whole `justfile`: an edit of a CI recipe in it will give a release with the same index.
- The magic `glob` is needed so that `*` does not match `/`: without it the exclusion `modules/*/eval/**` would also take a module's `media/eval/`. The list was checked by the trial of `modules`.

The merge in the ruleset of `main` is held by the checks of the column "Check in the ruleset" of the table of the shared workflows — for a repository on Go, also the four checks "Go / …" —, and by the repository's own jobs, with `integration_id` 15368 for the checks of GitHub Actions and 12526 for SonarCloud, as at `spec` and `.github`: without it a required check would be closed by a status of the same name from anyone who has write access ([github/docs](https://github.com/github/docs/blob/e0b0c90/content/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets.md)). The merge is held by the findings of CodeQL too — by the rule `code_scanning` —, and a pull request goes into `main` only by a merge commit, in every repository.
- The rule is set after the first analysis of CodeQL on `main`: it needs results on the branch that the pull request changes too ([github/docs](https://github.com/github/docs/blob/e0b0c90/src/rest/data/fpt-2022-11-28/repos.json), the rule `code_scanning`).
- The repository's setting `allow_merge_commit` is not turned off: if a repository has turned off a method that the ruleset requires, the merge does not go through at all ([github/docs](https://github.com/github/docs/blob/e0b0c90/content/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets.md)).

Differences:
- `spec` has no job `documents` in its `ci.yml` — beside it is its own job "Documents and tools", and the job "Go" with the shared `go.yml` —, its `codeql.yml` has `with: languages: javascript-typescript go` for `tools/` and its Go modules and `paths-ignore: draft/**` for the prototype, and its ruleset has "Documents and tools" in place of "Documents / docs-check-repo", and also "CodeQL / analyze (javascript-typescript)" and "CodeQL / analyze (go)". `spec` has `.sonarcloud.properties` and `dependabot.yml` of its own — the exclusions of the tests and the drafts, npm in `/tools` —, and they are not replaced: it needs no exclusion `spec/**`, as it has no submodule;
- `.github` has calling files of its own, with the prefix `self-`: the names `codeql.yml` and `scorecard.yml` are taken here by the shared workflows themselves. Its ruleset also requires "Workflows" — its own job with actionlint.

The calling files common to all are written by the session of `spec` — through `.repos/<name>`, when a repository is created and by edits in all of them at once. What a repository's code adds — the language's job, the input of CodeQL, the ecosystem of Dependabot, `release.yml` — is written by the repository's own session, by the texts of this section. The required checks in the ruleset, immutable releases and the ruleset of tags are set by the author, or by the executor with the author's confirmation.

### 3.4. `.github`'s own CI

`.github`'s own workflows lie beside the shared ones and start with `self-`; the shared ones have no prefix, and they are run only through `workflow_call`:
- `self-ci.yml`, `name: CI` — on a pull request and on a push to `main`. The jobs "Secrets", "DCO" (on a pull request only) and "Documents" call the shared workflows by the local path `./.github/workflows/<file>`, so a pull request checks the very version that it changes. The job "Workflows" is actionlint over all the workflows, with shellcheck over the scripts in them: their code lives here. actionlint and shellcheck, like gitleaks, are downloaded at the exact version and checked against the sha256 sum in the file itself, and the devcontainer does not have them; actionlint does not take the runner's shellcheck. The ignores of actionlint, each with its reason, are in `.github/actionlint.yaml`. The same job compares `ALLOWED_LICENSES` in `go.yml` — and in any other workflow where this list appears — with what the recipe `licenses-allowed` of `spec` prints at the tag of `.github`, and names the copy that diverged. `typescript.yml` has no copy, and only `go.yml` is required by name to have one. The recipe runs in the `toolchain` stage of `.github` itself: the script `spec/tools/toolchain/toolchain.sh` builds it, so the job takes the checkout with the submodule, and the image from the cache, by the same steps and the same entry as `documents.yml`, which only a push to `main` saves;
- the job "Go" of `self-ci.yml` calls the shared `go.yml` by the local path, without `same-bits`: the four recipes of the root `justfile` of `.github` — `ci-lint`, `ci-test`, `ci-vuln` and `ci-licenses` over the module `tools/coderules` through `go -C` —, and the upload of the coverage to Codecov by `.github/codecov.yml`. govulncheck and go-licenses are at the versions of the `justfile`. go-licenses does not check the module itself: its LICENSE is the root one, Apache-2.0, and go-licenses looks for LICENSE in the module's folder. `.sonarcloud.properties` removes `tools/coderules/testdata/**` from the search for duplicates: two controls are near copies of each other on purpose;
- the suite of tests of the steps — steps of the same job after actionlint:
  - "Install yq" — yq by the sum from the `checksums` of its release;
  - "Lint the tests" — the job's shellcheck over `tests/*.sh` and `tests/stubs/*`;
  - "Lint the actions" — the same shellcheck over each run script of each composite action of `.github/actions/`, taken out by yq, as actionlint reads none; a script that fails is named with its action;
  - "Test the workflows" — `YQ="$RUNNER_TEMP/yq" bash tests/run.sh`.

  The folder `tests/`: `run.sh` — the launcher, one bash process per test; `lib.sh` — the harness; `stubs/` — the stubs; `<workflow>.test.sh` — the cases of a workflow; `harness.test.sh` — the tests of the harness itself.

  A test chooses a step: `select_step <job> id=<id>` or `name=<name>`, after `use_workflow <file>`, or after `use_action <name>`, which reads a composite action of `.github/actions/` as the one job `action`. Then it sets the context — `ctx`, `set_env`, `runner_env` — and the stubs: `stub`, `stub_in_temp`, `stub_exit`, `stub_stdout`, `curl_answer`, `curl_offline`. Then it runs `run_step` and checks the exit code, the lines of output, the step's outputs and the calls of the stubs. `wf` reads the structure and the text of `if:`.

  Locally the suite runs from the root of the repository, with yq of the version of "Install yq", downloaded by the same sum: `YQ=<path> bash tests/run.sh`. The time limits are those of a test in `tests/run.sh`, of the step under test in `tests/lib.sh`, and of "Test the workflows" and its job in `self-ci.yml`. shellcheck is of the version in "Install shellcheck". The devcontainer does not have them, as it does not have actionlint;
- the job "Toolchain action" of `self-ci.yml` runs the composite action `toolchain` by the local path, as a caller's own job does: the call with `check: action`, a build of `tools/coderules` in the image with the Go caches mounted, and the call with `save: "true"`, which saves on a push to `main` alone;
- `self-release.yml`, `name: Release` — its own release, as at `spec`: after a green `self-ci.yml` on `main`, only from a push from the repository itself, and by the button — on `main`, after a green CI. The runs go in a queue, `queue: max`. The checkout is the tip of `main` that the event saw, with all the history and the submodule, and the commit on which CI passed is named only by its SHA. The number is computed by the recipe `release-version` of `spec` in the `toolchain` stage, and the script of `spec` runs it from the submodule: `spec/tools/toolchain/toolchain.sh spec release-version <commit> .github/workflows/self-release.yml`. The script runs from the copy of the checkout in `RUNNER_TEMP`, and the runner's `git` reads only the checkout itself, which no container mounts. It reads the line from this file at the commit being released, and for a commit older than the file, from the file of the tip, which it sees in the copy of the checkout. A release comes out if a shared workflow, a shared action of `.github/actions/` or the tool has changed, and `gh release verify` checks it. A refusal 404 or 403 "Resource not accessible by integration" is let pass only if the commit is no longer the tip of `main`, lies in its history and adds or changes files of `.github/workflows/` relative to it: the release of the tip will cover its edit ([github/docs](https://github.com/github/docs/blob/e0b0c90/src/rest/data/fpt-2022-11-28/releases.json), Create a release; `spec/justfile`). This is decided by the recipe `release-refusal` of `spec` — one copy of the rule for both releases. The recipe runs only after a refusal, so on every run the step of the number tries its call without running it, `toolchain.sh spec --dry-run`: otherwise a tag of `spec` that renames the recipe or changes the number of its parameters would surface only on a rare refusal, and would make red the very run that the refusal is to let pass (measurements 5.1). What sets it apart on purpose from the `release.yml` of `spec`: a release comes out only if a shared workflow has changed, and every release is Latest; a tag without a release is checked for the previous release too; the commit of CI must be a full SHA and an ancestor of the checkout; and the call of `release-refusal` is tried on every run, where in `spec` one edit changes both the recipe and its call;
- `self-codeql.yml`, `name: CodeQL` — on a pull request and on a push to `main`; `self-scorecard.yml`, `name: Scorecard` — on a push to `main` and once a week. Both call the shared ones by the local path, and `.github` names the language `go` besides `actions`: its code is the tool `tools/coderules/`; `.sonarcloud.properties` is as in the calling files, and so is `dependabot.yml` but for `github-actions`, which reads `/` and `/.github/actions/toolchain` and groups by `group-by: dependency-name`, so that one pull request moves an action in both.

The ruleset of `main` lets into `main` only a pull request with green required checks, which the ruleset 25477399 lists. Besides, a pull request must have no findings of CodeQL of the level `high` and above, and no errors, and it is merged only by a merge commit. The ruleset `v-tags` holds the tags of releases.

### 3.5. Versions and updates

- **a release of `.github`** comes out by itself after a green CI on `main`, as at `spec`, but only for a commit that, since the previous release, changes a shared workflow — a file of `.github/workflows/` without the prefix `self-` —, a shared action — a folder of `.github/actions/` — or the tool `tools/coderules/`, which `go.yml` builds at its own version; the first release always comes out. `git diff` finds the edit, and an edit of comments alone is an edit too. The number is the next patch of the line `RELEASE_LINE` from `self-release.yml`, read as `.github`'s own CI above says. It is computed by the recipe `release-version` from the submodule's `spec/justfile` by the tags of `.github`, and run by the script `spec/tools/toolchain/toolchain.sh` from the copy of the checkout. Every release is Latest, immutable, with an attestation, and the tags `v*` are under the ruleset `v-tags`;
- **the callers** pin a shared workflow, and the composite action `toolchain`, by a SHA, with a comment of the version on the same line. Their Dependabot raises both the SHA and the comment if the commit has a tag ([github/docs](https://github.com/github/docs/blob/e0b0c90/data/reusables/actions/dependabot-version-updates-actions-caveats.md)). It raises all the references to `.github` in one pull request — by the group `shared-workflows` of the calling files;
- **actions inside the shared workflows** and the composite action are pinned the same way, and the Dependabot of `.github` itself raises them, in both by one pull request. A merged update comes out as a release, and after it the callers' Dependabot raises the reference;
- **the `cooldown` pause** is three days for each ecosystem of Dependabot, at `.github` and at the callers, `github-actions` among them, which raises the references to `.github`: an error of a release must have time to be found before twelve pull requests spread it. The pause does not hold the base image of the devcontainer: Microsoft's registry does not give the date of a release, and Dependabot offers the new image at once. It holds the references to a reusable workflow, as it holds actions. The count starts from the date of the commit under the release's tag, to the day, because a release's tag is lightweight ([dependabot-core at fda701f](https://github.com/dependabot/dependabot-core/blob/fda701f/common/lib/dependabot/git_metadata_fetcher.rb));
- **the tools that Dependabot does not see** — gitleaks, actionlint, shellcheck, yq of the suite of tests, cosign and Node with its npm for the step of publishing, and the CLI of Codecov of the wrappers, with the sha256 sums of their archives — are raised by hand, as an `ARG` in the Dockerfile of `spec`. The CLI of Codecov is raised in `go.yml` and `typescript.yml` together: a case of the suite keeps its version and sum the same in both, and the sum is checked against the signed `codecov.SHA256SUM` of its release (sources 10.3);
- **pinning by a SHA** is held by the rule Exact versions: the organization's requirement to pin by a SHA does not apply to a reference to a reusable workflow ([github/docs](https://github.com/github/docs/blob/e0b0c90/data/reusables/actions/actions-use-policy-settings.md)).

### 3.6. Secrets and forks

For every repository:
- a shared workflow takes no secrets: its `workflow_call` has no `secrets`, and the caller does not pass `secrets: inherit`. It has only `GITHUB_TOKEN` with the permissions that the caller gave, and a short-lived OIDC token if the caller gave `id-token: write`: cosign signs with it, npm exchanges it for a publishing token, and Codecov accepts the upload of the coverage by it. Neither is a secret;
- `pull_request_target` is used nowhere; `workflow_run` does not take the code of a pull request with secrets or with write access, as at the release of `spec`;
- a repository's own job with a secret runs only on a push to `main` and on a pull request from a branch of the repository itself. A pull request from a fork passes the shared checks without secrets;
- on a pull request from a fork such a job is not skipped, but fails and names the reason. A skipped job counts as a success for a required check and does not hold the merge ([github/docs](https://github.com/github/docs/blob/e0b0c90/data/reusables/actions/workflows/skipped-job-status-checks-passing.md)), and a failed one holds it until the edit is moved to a branch of the repository;
- a pull request of Dependabot comes from a branch of the repository, but gets no secrets of Actions — only the secrets of Dependabot ([github/docs](https://github.com/github/docs/blob/e0b0c90/content/code-security/reference/supply-chain-security/dependabot-on-actions.md)). How a job with a secret treats it is decided together with that job, and for eval in Т-28;
- where the key for eval lies is Т-28: an environment secret in the repositories with eval, or Secret Manager of `infra` through Workload Identity Federation; it is decided with eval at stage 2.

### 3.7. The composite action `toolchain`

`.github/actions/toolchain/action.yml`, "Toolchain image and Go caches", is for a job of the caller's own that runs Go in its stage `toolchain`, as "Binaries / build" of `module-kit` does. Its inputs: `check` — the word the key of the Go caches names the job by, its own, as `binaries`, never one of `go.yml`'s checks, `lint`, `test`, `vuln`, `licenses`, `target-<target>`, `fma-diff`, `arm64` or `rules`, whose entry it would share —, and `save`, `"false"` by default. The job calls it twice with the same `check`:
- before its work, without `save`: the image `novatrail-toolchain` of the stage `toolchain` from the entry `toolchain-<OS>-<architecture>-<hash of the Dockerfile>`, or built from `.devcontainer/Dockerfile` and, on a push to `main` alone, saved at once; then the folder `${{ runner.temp }}/go-cache` from the entry `go-<OS>-<architecture>-<check>-<hash of the Dockerfile>-<hash of **/go.sum>`, checked by `go mod verify` in every module of the caller, or on its miss the newest entry of the key without `go.sum`, without its modules, or empty;
- after its work, with `save: "true"`: it reads the key the first call asked for and whether it hit, from `${{ runner.temp }}/novatrail-go-cache.key`, and on a miss, on a push to `main` alone, saves the folder by it. A job whose work failed does not reach it.

The calls refuse, each with its reason: a `save` other than `true` or `false`; a `check` other than a word of letters, digits, `.`, `_` and `-`; a call without `save` in a job that has taken the caches by it already, as two would share one key file; a call with `save` without one before it.

The job checks out its tree before the first call and runs on `ubuntu-24.04` or `ubuntu-24.04-arm`; each `docker run` of its work mounts the folder and points Go into it, by the lines of the action's header comment: `--env GOMODCACHE=/go-cache/mod --env GOCACHE=/go-cache/build --env GOLANGCI_LINT_CACHE=/go-cache/lint` and `--volume "$RUNNER_TEMP/go-cache:/go-cache"`. The file, the image, the folder and the keys are those of `go.yml`, so the entries are the ones its jobs fill and read, and `go.yml`'s `arm64` takes the action itself, by `$/` ([github/docs](https://github.com/github/docs/blob/e0b0c90/content/actions/reference/workflows-and-actions/workflow-syntax.md)): the steps are one file, and a move of `.github` that changes them reaches the caller with the SHA its Dependabot raises. The suite holds the action's scripts and the SHA of `actions/cache` to those of `go.yml`'s other jobs, and `self-ci.yml` runs the action as a caller's job does and hands ShellCheck its scripts. In the caller's workflow, by the SHA and the tag of the release that the calling files pin the workflows to — the group `shared-workflows` of its `dependabot.yml` moves them all at once:

```yaml
    steps:
      - uses: actions/checkout@<sha of actions/checkout> # <its version>
        with:
          persist-credentials: false

      - name: Toolchain image and Go caches
        uses: altnovatrail/.github/.github/actions/toolchain@<sha> # <version>
        with:
          check: binaries

      - name: The work
        run: |
          docker run --rm --user "$(id -u):$(id -g)" --env HOME=/tmp \
              --env GOMODCACHE=/go-cache/mod --env GOCACHE=/go-cache/build --env GOLANGCI_LINT_CACHE=/go-cache/lint \
              --volume "$PWD:/work" --volume "$RUNNER_TEMP/go-cache:/go-cache" --workdir /work \
              novatrail-toolchain just <recipe>

      - name: Go caches into the cache
        uses: altnovatrail/.github/.github/actions/toolchain@<sha> # <version>
        with:
          check: binaries
          save: "true"
```

## 4. Sources and measurements

The records of the facts no run checks are in [sources.md](sources.md), and the results of measurements in [measurements.md](measurements.md); a document holds neither. The archives `docs/plan/` cite this section and its former groups by name, and the table that leads from a group to its records is kept with them, at the end of [docs/plan/history.md](plan/history.md).
