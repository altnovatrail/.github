# .github — architecture

> Status: the shared checks, the workflows for code, the shared release, the composite action `toolchain` and the tool `tools/coderules/` exist and come out in releases of `.github` (R04, R10), and no point of section 2 is open. Where the rest is set: the tag of `spec` — the submodule `spec/`; the line the releases are numbered in — `RELEASE_LINE` in `self-release.yml`; the releases — the tags `v*` and [the releases](https://github.com/altnovatrail/.github/releases); what a task did — its pull request and the archives `docs/plan/`; what is put off — [run/DEBT.md](../run/DEBT.md).
>
> What the component does, what it does not do, and what is still to be decided about it. This is the detail of its card, architecture 3.11 spec. The card stays the summary: if the detail changes what the card says, the card is changed in `spec` by the same route as the questions to its registers (RULES.md, Across repositories).
>
> Why it was decided so and not otherwise is in [decisions.md](decisions.md); the work plan is in [RUN.md](../RUN.md). The records of the external facts that the claims stand on are in [sources.md](sources.md), and the results of measurements are in [measurements.md](measurements.md): a claim cites its record, `sources 2.1` or `measurements 1.1`. The concepts are concepts spec. The documents and decisions of `spec` are in `spec/docs/` and are cited with the suffix "spec".

## 1. Purpose and bounds

**Does:**
- keeps the organization's profile, `profile/README.md`. GitHub shows it on the page github.com/altnovatrail (architecture 3.11 spec);
- keeps the default community health files — CONTRIBUTING, SECURITY and the code of conduct — and with them the issue and pull request templates: the issue forms "Bug report" and "Change proposal", a template chooser with no blank issue, and a pull request template with a checklist (R22 spec; R29). GitHub shows them in every repository of the organization that has none of its own, if `.github` is public; all the repositories of the organization are public too (architecture 3.11 spec, architecture 8 spec; R18 spec; R22 spec);
- keeps the shared workflows of CI, with actions pinned by a SHA (architecture 3.11 spec; R03, section 3.1):
  - the shared checks — the secrets scan, DCO, CodeQL, Scorecard and the documents check. Every repository takes them, `spec` too, even before its code (repositories 1, 2.1 spec; R30 spec); `spec` has its own documents check, `just docs-check`. Scorecard is shared: the Scorecard server accepts the result of a shared workflow (2.2; architecture 3.11 spec). `spec` and all eleven component repositories call them (R30 spec);
  - for code — Go and TypeScript, wrappers over the repository's recipes with the license check inside, and the release with a signature. Each comes into a repository with the code it checks (R03; architecture 3.11 spec; repositories 6 spec). The wrappers take the license list and the check of the npm lock file as `spec`'s recipes (R39 spec), and the release calls `spec`'s release recipes by its script `tools/toolchain/toolchain.sh` (R31 spec). `spec` cannot call the shared release — that one takes the recipes from the caller's `spec` submodule — and its `release.yml` is its own: it signs the files with the same keyless cosign and publishes the types package `@altnovatrail/spec` to npm by the steps of the shared release, copied into it. For its Go code `spec` calls the shared Go wrapper as any repository in Go does — the job "Go" with its own recipes `ci-*` (architecture 3.11 spec; R64 spec; R37 spec; R30 spec);
  - the composite action `toolchain`, `.github/actions/toolchain`, for a job of the caller's own that runs Go in its stage `toolchain`: the image of the stage and the caches of Go from the caller's cache of GitHub Actions, and their save on a push to `main`, by the steps that `go.yml`'s job `arm64` takes from it too. It comes out in the releases of the workflows and is pinned the same way (R49);
- the shared workflow of the release signs module packages too. One recipe of `spec`, `release-verify`, checks the signature, where the file enters NovaTrail, by R77 spec. The library of `module-kit` checks no signatures: it checks a package by the chain of digests from the index that a pull request of `api` pinned (architecture 3.7, 3.11 spec; R17 spec; R30). The same workflow publishes the UI package from the signed release to npm, in the scope `@altnovatrail`, as the same file, through trusted publishing, when the caller has named the package by the input `npm-package` (R37 spec; R18).

**Does not:**
- does not stand in for the files that a repository has of its own: GitHub takes a default file only when there is none of the repository's own (R22 spec). With issue templates it is stricter: a form or a `config.yml` of the repository's own in its `.github/ISSUE_TEMPLATE` drops all the shared ones, so a repository sets up no templates of its own (R22 spec);
- does not give the license for other repositories: there is no default LICENSE, and each repository has its own (R20 spec; R22 spec);
- does not repeat the rules: CONTRIBUTING leads to `RULES.md` and the repository's CLAUDE.md, and a copy would drift from them (R21 spec; R22 spec);
- holds no code of the platform: while the platform runs nobody calls `.github`, and the overall diagram does not have it (architecture 2 spec). It has one Go code of its own — the CI tool `tools/coderules/`, the test of the rules of code that the shared `go.yml` with `same-bits` runs on the caller's code (R33; R107 spec). The same `go.yml` checks it, and its coverage goes to Codecov.

**Data and links:**
- no learners' data and no secrets, as in no repository (RULES.md, Hard rules);
- at build time it depends on nothing but `spec`, like all (repositories 2.1 spec);
- every repository takes the shared checks of CI, `spec` too, even before code (repositories 1, 2.1, 3 spec; R30 spec). Into a repository made from the repository template of spec, the language checks, the justfile and the signed releases come with its code (repositories 1 spec);
- its services are GitHub and Sigstore: CI, releases, keyless signing — the npm registry, where the shared release publishes the UI packages, and Codecov, where the Go and TypeScript wrappers send the caller's test coverage, by OIDC (architecture 3.12 spec; R37 spec, R48 spec; R16, R19). The README badges are those of repositories 2.3 spec, their images from shields.io, the Scorecard API, SonarCloud and Codecov, and SonarCloud's analysis is a required check (R48 spec; R25; R11);
- stage 0, together with `spec` (repositories 2.1 spec).

## 2. To decide when detailed

The points "To decide when detailed" of the card, a subsection per point, and the gaps found on the way. An open point names where it will be decided: a task in [RUN.md](../RUN.md) or the epic that will bring it. A decided point names the entry of the log, which says why and what was rejected, and its design is section 3. A question that goes beyond this repository goes «в реестр spec» (RULES.md, Across repositories).

### 2.1. Shared workflows and a repository's own

- **Gist:** which CI workflows live in `.github` and are called by all repositories, and which each repository has of its own — the point "To decide when detailed" of the card (architecture 3.11 spec).
- **Decided:** R03, R04 and R05. The design is section 3.

### 2.2. Scorecard from a shared workflow

- **Gist:** Scorecard with the publishing of its results puts restrictions on the workflow that runs it, and the Scorecard server may reject the result (sources 6.1). The calling file cannot keep them: its job has `uses:` of the shared workflow instead of steps, and `id-token: write`, while "Only the job with `ossf/scorecard-action` can use `id-token: write` permissions" (sources 6.1).
- **Decided:** Scorecard is the shared `scorecard.yml` (R03, R09). The server accepts the result both of `self-scorecard.yml` by the local path and of the shared file called from another repository by the full path (R09, R13). That it checks the restrictions by the shared file follows from this and from its check of the branch by the caller (scorecard-webapp, PR #778; sources 6.1); its documentation does not say so.
- **Pitfall:** a green job does not show that the result was accepted. When the server refuses, scorecard-action at the version `scorecard.yml` pins only warns and returns success, and has no input `fail_on_publish_error` (sources 6.1): the acceptance is seen in the Scorecard API and in the log of the run. A raise of the action in that file is when to look for the input and turn it on.

### 2.3. The signature of the shared release: whose identity

- **Gist:** keyless signing from the shared workflow of the release gets the identity of the shared workflow, not of the caller's `release.yml`.
- **Decided:** R18 and R30, by R77 spec. Each file is signed by keyless cosign: the SAN and the Build Signer URI name the shared `release.yml` at the SHA the caller pinned it by, and the Build Config URI the caller's workflow (sources 2.5 and 7.2; measurements 5.2).
  - The consumer checks a file by one recipe of `spec`, `release-verify`, where the file enters NovaTrail: the SAN and the Build Signer URI are the shared `release.yml` at the SHA of a commit of a release of `.github` no lower than v0.1.7, on the history of its `main`, not a branch or a tag; the caller is the repository's `release.yml` on `main`, with the commit of the tag and the numeric IDs of the repository and the organization. It reads the list of releases of `.github` through git, without a token, and its condition is immutable releases and a ruleset of tags `v*` at `.github`, `spec` and each releasing repository (3.3); it trusts the tags of `spec` under the same condition. The library of `module-kit` checks no signatures.
  - The shared release checks the signature of a file that came out on its rerun path by the same recipe, from the caller's `spec` submodule. A run that publishes stops first thing if the caller's workflow is not its `.github/workflows/release.yml` on `main`, or if the shared `release.yml` is pinned otherwise than by its own path at a SHA. The release checks the SHA's form as a string; whether it is a release of `.github` no lower than v0.1.7 is the consumer's check. The design is section 3.1.

### 2.4. Which commits of `main` get a release

- **Gist:** R04 puts out the shared workflows in releases, as R31 spec does. But `spec` releases every green commit of `main`, and `.github` has commits that do not touch what the callers take: the profile, the community health files, its own `self-` workflows, the documents.
- **Decided:** R10: a release goes to a commit that changes what the callers take since the previous release, and the first release always comes out. The design is section 3.5.

### 2.5. How `.github` counts the release number

- **Gist:** at `spec` the number is counted by `tools/release/version.mjs` with tests, and the recipe `release-version` feeds it three lists of tags `v*`: all the tags, the tags from the history of the commit being released, and the tags on that commit itself (the justfile of `spec`; R31 spec).
- **Decided:** R10: `spec`'s recipe `release-version` counts it, by its interface for other repositories, and reads the line from `RELEASE_LINE` of `self-release.yml` of the commit being released (R31 spec). The design is section 3.5.

### 2.6. The `cooldown` pause for references to `.github`

- **Gist:** Dependabot waits three days after a version comes out before it proposes the version — so `dependabot.yml` of `spec` says for each ecosystem (R30 spec). It raises the references to the shared workflows in the same ecosystem `github-actions`.
- **Decided:** R10: three days, as for everything. The design is sections 3.3 and 3.5.
- **How it acts:** the pause holds the references to `.github` too: for dependabot-core a reference to a reusable workflow is a dependency of the ecosystem `github-actions`, and the same code checks the pause for it as for an action (sources 4.2). The count runs from the date of the tag, to the day, and the tag of a GitHub release is lightweight, its date the date of the commit (sources 4.2). So after a release that came out minutes after the merge, the pause lasts from two to three days, as the Dependabot pull requests of `spec` showed (sources 4.3); a release that came out later than its commit gets a shorter pause — that is 2.10.

### 2.7. How a shared workflow reads the files of `.github` of its own version

- **Gist:** a shared workflow may need data — the license list (3.1), the version and the sum of gitleaks. `actions/checkout` in it takes the calling repository, not `.github` (sources 2.1); a reusable workflow takes its own repository at its own version by `actions/checkout` with `repository: ${{ job.workflow_repository }}` and `ref: ${{ job.workflow_sha }}` (sources 2.2).
- **Decided:** R08, R16, R19 and R33: the data is in the file of the shared workflow itself, so a change of the data is a change of the shared workflow, which gives a release (2.4), and the caller gets the data of the version it is pinned at. `go.yml` keeps the one copy of `spec`'s license list, which `self-ci.yml` holds to the output of `spec`'s recipe `licenses-allowed`; `typescript.yml` keeps none: a TypeScript caller's `ci-licenses` checks the lock file by a recipe of `spec` and takes the list from there (R39 spec). Code or data too large for the file is taken by a second checkout by `job.workflow_sha`: so `go.yml` with `same-bits` runs the tool `tools/coderules/` of its own release (R33). The design is sections 3.1 and 3.4.

### 2.8. Shared workflows from a repository named `.github`

- **Gist:** R03 puts the shared workflows into `altnovatrail/.github`. That GitHub calls workflows from a repository with such a name, and that Dependabot raises the references to it, the documentation does not say; the example of `nodenv/.github` and issue #12489 of dependabot-core show it (sources 14.2).
- **Decided:** R03: they stay in `.github`. The callers call them by the full path, `altnovatrail/.github/.github/workflows/<file>@<sha>`, and their checks run (R13). Dependabot raises the references to `.github` — at a caller, in one pull request, by the group of 3.3 (R04) — and "DCO / sign-off" accepts the sign-off of `dependabot[bot]` by the exception of 3.1 (R25; sources 4.3); the pause holds them — 2.6.

### 2.9. Who sets the ruleset of `main` of `.github` itself

- **Gist:** each repository has its own ruleset of `main` by R30 spec: only through a pull request, all checks required but Scorecard. `.github` writes its own workflows itself (R03), so it sets its own ruleset.
- **Decided:** R11 and R12: the ruleset 25477399, as at `spec`, with the required checks of R11, the rule `code_scanning` and merge commits only. R30 spec requires the same of every repository. The design is sections 3.3 and 3.4.

### 2.10. The pause of a release that came out later than its commit

- **Gist:** the pause of the references to `.github` is counted from the date of the release's tag, to the day, and the tag that `gh release create` makes is lightweight, dated by its commit; Dependabot reads the date from the tags of the repository's clone, not from the release (2.6; sources 4.2). A release that comes out later than its commit — after a failed run put out by the button, or after a long queue — gets a pause shorter than three days, or none.
- **Decided:** R23: the release comes out as before, and a Dependabot pull request with a late release is held by hand at the callers until three days have passed since the release came out.

### 2.11. The issue and pull request templates

- **Gist:** whether GitHub takes the issue and pull request templates from `.github` the same way as the community health files, and so where NovaTrail's lie.
- **Decided:** R22 spec and R29: they lie here, as default files — the forms and `config.yml` in `.github/ISSUE_TEMPLATE/`, the pull request template `.github/pull_request_template.md`.

### 2.12. What the containers of `spec`'s recipes can change in the checkout

- **Gist:** `spec`'s script mounts the whole checkout for writing into each of its containers, `.git` too (sources 12.2). After these containers the runner of the shared `release.yml` reads this `.git`: `git diff` decides whether the release comes out, `git archive` builds the tree whose files are then signed, `git fetch`, when the Releases API refuses, goes by `.git/config`, and the post step of `actions/checkout` runs `git config` and `git submodule foreach` in the checkout at the end of the job (sources 2.7; measurements 5.4). `self-release.yml` has the same, without `git archive`.
- **Decided:** R10 and R18: `spec`'s recipes in both releases run in a copy of the checkout, whose copy of the script has its sum checked, and the runner's `git` reads only the checkout itself, which no container mounts. The build of the caller's files, `release-files`, runs in its own container and does not see the checkout (R18). The release of `spec` is built the same way (R31 spec). The design is sections 3.1 and 3.4.

### 2.13. Tests of the shared workflows

- **Gist:** RULES.md, How we work: "Code comes with its tests: a pull request that adds or changes what code does adds or changes the tests of its automated suite too" (R48 spec). Most of the code of `.github` is the shared workflows, YAML and steps in bash, which Codecov does not measure.
- **Decided:** R28: the suite `tests/`. A step, taken out of its file word for word, runs on the runner with stubs, in cases where it passes and where it fails; the file is read by yq at the version and sum in `self-ci.yml`, and the suite runs as steps of the job "Workflows". A change of a step comes with its own cases, and the review of the pull request holds it, since Codecov does not measure bash. The design is section 3.4.

## 3. Design

Decided under 2.1: R03 — which workflows are shared and which are a repository's own; R04 — how they are versioned; R05 — secrets and forks. The files of the shared checks are written by epic E2, the workflows for code by epic E3 (table 2 of [RUN.md](../RUN.md)), and they were connected by T17 `spec` — in `spec` and `module-kit` —, T16 `spec` — in `tutor` — and T21 `spec` — in the other nine, after each moved to a tag of `spec` with `docs-check-repo`. The external facts this rests on are the records of [sources.md](sources.md), the results of the trials are in [measurements.md](measurements.md), and a claim below names its record.

### 3.1. Shared workflows

A shared workflow lies directly in `.github/workflows/` of this repository, runs only through `on: workflow_call` and is called as `altnovatrail/.github/.github/workflows/<file>@<sha> # vX.Y.Z` (R04). The permissions are given by the caller's job, and the shared workflow only lowers them; `actions/checkout` in it takes the caller's repository. A shared workflow takes no secrets (R05). A shared action lies in a folder of `.github/actions/` and is a step of the caller's own job, `altnovatrail/.github/.github/actions/<name>@<sha> # vX.Y.Z` (R49): there is one, `toolchain`, from `v0.1.32`, section 3.7.

**Before code — in every repository, `spec` included:**

| Workflow | What it does | Who calls it | Inputs | Permissions from the caller | What it needs from the repository | Check in the ruleset |
|---|---|---|---|---|---|---|
| `secrets.yml` | job `gitleaks`: the secrets scan by gitleaks 8.30.1 over the whole history of the commit checked (`--log-opts=HEAD`), as R49 canvas-api, with `--redact`; the archive is checked against the sha256 sum in the file itself (R08) | all | none | `contents: read` | `.gitleaks.toml` with the repository's own exceptions — optional: gitleaks reads it from the folder it scans (sources 11.1). It holds `[extend]` with `useDefault = true`, or it would replace the rules of gitleaks, and the check fails on such a file. On a pull request both it and `.gitleaksignore` are taken from the base, and `gitleaks:allow` comments have no effect: a pull request will not weaken the scan of its own commits | "Secrets / gitleaks", holds the merge |
| `dco.yml` | job `sign-off`: every commit of the pull request, but for merge commits, has a `Signed-off-by` of its author, by name and address (R30 spec); the commits are `git rev-list` between the parents of the pull request's merge commit, `HEAD^1..HEAD^2`, from a checkout with the full history, without the API; on another event it fails | all, the caller's job only on a pull request | none | `contents: read` | required sign-off of web commits: a commit made on github.com gets it only this way. The organization has it on (R22 spec) | "DCO / sign-off", holds the merge |
| `documents.yml` | job `docs-check-repo`: takes a checkout with the submodule, and the submodule's script `spec/tools/toolchain/toolchain.sh` builds the stage `toolchain-core` or `toolchain`, as `go.yml`'s checks without a browser take it (R47), from the caller's `.devcontainer/Dockerfile` and runs `docs-check-repo` in it (R32 spec) — from the release after `v0.1.20`, as `spec`'s `ci.yml` and the shared release do (the 2026-11-08 amendment to R08). Without the script the step fails and names the reason. The image of the stage comes from the caller's GitHub Actions cache: `TOOLCHAIN_IMAGE_FILE` names the file of the stage, `${{ runner.temp }}/novatrail-<stage>.tar`, and `spec`'s script from v0.13.0 loads or writes it; the older script does not notice it and builds the image as before (the 2026-11-10 amendment to R36). Only a push to `main` saves it, and elsewhere the step hands the script the variable only with a file from the cache; file and key are those of `go.yml` and `typescript.yml` (R42, R47) | all but `spec`: it has its own `just docs-check` | none | `contents: read` | `.devcontainer/Dockerfile` with the `toolchain` stage and the submodule `spec/` — both from the repository template; the submodule at the tag v0.2.17 or newer, which has the script, and before it v0.2.3, with the recipe `docs-check-repo` (R32 spec). So the caller moves to v0.2.17 before it raises the reference to this release | "Documents / docs-check-repo", holds the merge |
| `codeql.yml` | CodeQL advanced setup (R09): job `languages` builds the list — `actions` always and the caller's languages, each once; another language stops the check with the reason. A job `analyze` per language — `build-mode: none`, and for `go` `autobuild`, with Go of the caller's `toolchain` stage (the amendment to R09; R45); `tools: linked`, the query suite `security-extended`, `category` — `/language:<language>`. A green analysis means that CodeQL ran through, not that it found nothing. The findings are held by the ruleset rule `code_scanning` — in every repository by the amendment to R30 spec, in `.github` from R12 | all | `languages` — the repository's languages beyond `actions`, separated by a space, a comma or a line: `javascript-typescript` and, from the release after T19, `go`. Before code — empty, for `spec` — `javascript-typescript` for `tools/` (T17 spec). `paths-ignore`, from `v0.1.1`, — the paths CodeQL does not read in the analysis of `javascript-typescript`, like `paths-ignore` of its configuration: bare paths, one per line, without quotes. Job `languages` makes a YAML string of them, and `init` gets it as the input `config`, but only for this analysis. The analysis of `actions` does not get them and reads every workflow (R09). Nor does the analysis of `go` get them: a compiled language CodeQL reads by the build, and `paths-ignore` does not reach it (sources 5.2). A line that starts with `#` is a comment. A comma, a `#` after a space or a tab, a `- ` at the start and a quote at either end stop the check. For `spec` — `draft/**`, the prototype (Д8 in RUN.md `spec`) | `contents: read`, `security-events: write` | for `go` — Go of the `toolchain` stage of `.devcontainer/Dockerfile`, the one where the checks of `go.yml` run, pinned as at `spec`: `ARG GO_VERSION` and `GO_SHA256_AMD64` in that stage or one it is built from, the job running on X64. The analysis takes that archive of go.dev, checked by that sum, onto the runner, without building the stage; a Dockerfile that names them otherwise, or whose stages set a `GO*` or `CGO_*` but `GOTOOLCHAIN`, stops it with the reason (R45). Go's autobuild first runs `make`, `ninja`, `./build` or `./build.sh`, if the root has such a file, — on the runner, not in the `toolchain` stage. The build executes Go and the pull request's code with the step's token — the same change the branch's author can make to the caller's workflow anyway; the default setup of code scanning is off. `paths-ignore` must not remove all the code of a language: then the analysis of that language fails — "CodeQL could not process any code written in JavaScript/TypeScript" (measurements 1.2). The input lives in the caller's workflow itself, so a pull request can change it together with its code. Only a review of the diff of `.github/workflows/` sees such a change, and the project has one author, and the ruleset requires no approvals (R09; R30 spec) | "CodeQL / analyze (<language>)", holds the merge. "CodeQL / languages" is not required: if it fails, there are no analyses at all, and the merge waits for them, and it names the reason |
| `scorecard.yml` | job `scorecard`: OpenSSF Scorecard with its results published, SARIF to code scanning; the job has only approved actions and not one script of its own (R09) | all, on a push to `main` and on a schedule | none | on the job — `contents: read`, `security-events: write` and `id-token: write`; at the workflow level — read only | the caller is a small separate file without `env` and `defaults` (2.2) | "Scorecard / scorecard", does not hold the merge (R30 spec) |

Dependabot signs off a commit with another address than the one the author is named by. In `spec`, in the commit c6b3cb5, the author is `dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>`, and the sign-off is `Signed-off-by: dependabot[bot] <support@github.com>`. So `dco.yml` checks the sign-off against the author by name and address, and for `dependabot[bot]` accepts this sign-off as a named exception. Otherwise every pull request of Dependabot would be red, and T17 `spec` expects the opposite. The exception holds only if the pull request was opened by `dependabot[bot]`, and the committer is `GitHub <noreply@github.com>`: anyone can set the author of a commit, but not the author of a pull request.

**With the first code — in the repositories with code** (epic E3 — `go.yml`, with the scaffold of the CLI of `module-kit` (R16), and `release.yml`, with its first release; epic E5 — `typescript.yml`, with the first code in TypeScript, in `canvas`):

| Workflow | What it does | Who calls it | Inputs | Permissions from the caller | What it needs from the repository | Holds the merge |
|---|---|---|---|---|---|---|
| `go.yml` | a job for each of the caller's four `just` recipes — `ci-lint`, `ci-test`, `ci-vuln` and `ci-licenses` —, in the `toolchain` stage of its `.devcontainer/Dockerfile`, as the runner's user. `ci-licenses` gets `ALLOWED_LICENSES` in its environment — the ASF's category A, as SPDX identifiers (R16). Job `test` hands on the coverage report as the artifact `go-coverage`, and job `coverage` — the only one with `id-token: write`, after all four — sends it to Codecov by OIDC. It takes the Codecov CLI v11.3.2, by the sha256 in the file itself, and a failed upload fails only a pull request (the 2026-11-01 amendment to R16). With the input `same-bits` — four more checks in the same stage. "Go / targets" holds the matrix `target`, a job "Go / target (<target>)" each, by one script in one container that runs the targets `TARGETS` names: `amd64-v3`, the tests at GOAMD64 v3; `cpu-off`, at v1 with `GODEBUG=cpu.all=off`; `386`; `js-wasm`, through `go_js_wasm_exec`; and `wasip1`, through an executor on `node:wasi` that the script writes outside the checkout, with `go vet` (R39, T58). The job `targets` after them, with `always()`, is red unless every one passed (R43, T62). `fma-diff` compares the assembler of every package with code, with fusion and with `-d=fmahash=n`, on six targets at once, each printed whole in their order, with its own control (the 2026-11-08 amendment to R16, T46; R43). `arm64` runs on `ubuntu-24.04-arm`: the caller's `ci-test` in its own container, and then the script of the targets on `cpu-off js-wasm wasip1` (the 2026-11-08 amendment to R16, T47). `rules` holds the code to the rules of code by the tool `tools/coderules/` of `.github` of the same commit as the file `go.yml` — a second checkout by `job.workflow_repository` and `job.workflow_sha` —, with the caller's lists `.github/coderules.json` (R33, T48). Every job that runs Go takes `GOMODCACHE`, `GOCACHE` and `GOLANGCI_LINT_CACHE` from the caller's GitHub Actions cache, one folder mounted at `/go-cache`, by a key of the runner's OS and architecture, the check — for `target`, its target —, the Dockerfile and `go.sum`, and on its miss by the same key without `go.sum`, whose entry loses its modules and keeps its builds; `go mod verify` checks what the exact key gave in every module of the caller, and a push to `main` alone saves, under the exact key (R41, T60; the 2026-11-18 amendment to R41, T75). The image of the stage comes from the job `toolchain`, "Go / toolchain", which on a miss alone builds it and hands it on by the artifact `go-toolchain-image`; the jobs on amd64 need it and run unless the run is cancelled, and `arm64` builds its own (R42, T61), taking it and the caches of Go by the composite action `toolchain` of its own commit, `$/.github/actions/toolchain` (R49, T69). `lint`, `vuln` and `licenses` run in `toolchain-core` where the Dockerfile has it and its `toolchain` holds more, by an entry and the artifact `go-toolchain-core-image` of their own (R47, T66) | repositories of the kind go; first `module-kit`, from the scaffold of the CLI (T10 module-kit), and from T50 `spec` also `spec`, over all its Go modules (the 2026-11-01 amendment to R30 spec); with `same-bits` — `learner-model` and `engine` (R107 spec) | `same-bits` — boolean, `false` by default | `contents: read`, `id-token: write`; the second for job `coverage`: a called workflow only lowers permissions | Go in the `toolchain` stage at an exact version and with `GOTOOLCHAIN=local`; recipes with these names, and `ci-licenses` by the list from `ALLOWED_LICENSES`. `ci-test` writes one coverage profile, `coverage/go.out`, over every package of every module, and without it "Go / test" is red. The caller has no artifacts of its own named `go-coverage`, `typescript-coverage`, `go-toolchain-image`, `typescript-toolchain-image` or their `-core-` twins: an artifact's name is unique in a run. Where the Dockerfile has a core, what `ci-lint`, `ci-vuln`, `ci-licenses` and `release-files` need is in it (R47). The Codecov app sees the repository, and `codecov.yml` is by 3.3. The code and the tests do not read `spec/`: the job takes a checkout without the submodule (R21 spec). The tools of the checks and their versions are the repository's own, and so are the exceptions of the license check, each with a decision, as R48 canvas-api. With `same-bits` — also Node in the `toolchain` stage, for js/wasm and for wasip1 by `node:wasi`, of a version that knows `--disable-warning` — v20.11 or newer on the line 20, v21.3 or newer from 21 on (sources 9.1), and `bash` in it, the tests pass without race detection too, on 386 and in wasm, and `.github/coderules.json` holds the caller's lists (3.3) | yes: "Go / lint", "Go / test", "Go / vuln" and "Go / licenses", when the caller's job is named "Go", and with `same-bits` also "Go / targets", "Go / fma-diff", "Go / arm64" and "Go / rules". "Go / coverage", "Go / toolchain" and "Go / target …" do not hold the merge, but `codecov/patch` from Codecov does — once the author puts it in the ruleset (3.3) |
| `typescript.yml` | the same for TypeScript, by the contract of R19: a job for each of `ci-lint`, `ci-test`, `ci-vuln` and `ci-licenses` in the caller's `toolchain` stage, as the runner's user. With the input `engines` — a fifth, `ci-engines`, the tests in WebKit and Firefox, as "TypeScript / engines" beside `ci-test`, which then runs Node and Chromium with the coverage (the 2026-11-16 amendment to R19, T64). Job `licenses` takes the submodule `spec`, and `ci-licenses` checks the lock file by `spec`'s recipe `licenses-check-repo` from it (R39 spec; the amendment to R19). The container runs with `--init`, and for jobs `test` and `engines`, where the browsers start, also with `--ipc=host`. Of the environment only `CI` goes into it: by it Vitest does not let `test.only` through, and, if the configuration does not set `headless` itself, also runs the browser headless. It is worth setting it explicitly, `headless: true`: the development container has no `CI` (the amendments to R19). Coverage — as in `go.yml`: the lcov report as the artifact `typescript-coverage`, and job `coverage` sends it to Codecov (the 2026-11-01 amendment to R19). The image of the stage — by the job `toolchain` of `go.yml`, "TypeScript / toolchain", with the artifact `typescript-toolchain-image` (R42); `lint`, `vuln` and `licenses` in `toolchain-core`, as in `go.yml` (R47) | repositories of the kind typescript; first `canvas`, from T08 canvas | `engines` — boolean, `false` by default | `contents: read`, `id-token: write`, as for `go.yml` | Node in the `toolchain` stage at an exact version; `ci-test` writes the lcov report, `coverage/lcov.info`, and a module that no test loads is in it with zeros — by Vitest's `coverage.include` — or fails the recipe; a lock file and `.npmrc` with `ignore-scripts=true` and `save-exact=true`; recipes with these names — `ci-lint` checks the format, the lint and the types —, and each installs the packages itself, through `npm ci`; `ci-licenses` checks every package of the lock file by the recipe `just -f spec/justfile licenses-check-repo <lock-file> [<exceptions file>]`, and the submodule `spec` is at the tag v0.2.18 or newer, where the recipe has the `dev` boundary. The exceptions are a JSON file of the repository's own, the recommended name `licenses.json`, each with a decision (the amendment to R19). The browsers for the tests are in the `toolchain` stage, only those the tests run, of the three of `spec`'s kind `typescript` — Chrome Headless Shell, WebKit and Firefox (R79 spec) —, with `engines` WebKit and Firefox among them, of the revision that the Playwright of the lock file expects, at the path from `ENV PLAYWRIGHT_BROWSERS_PATH` of that stage, with the integrity by the rules and the terms named in the decision. Playwright's browser `chromium` is a build of Google Chrome for Testing on Google's terms, free for everyone, not Chromium under an open license. The 2026-10-22 amendment to R12 spec accepts them: NovaTrail does not distribute the browser, and the platform builds and runs without it (the amendments to R19). The checkout is without the submodule, but for job `licenses`: the code and the tests do not read `spec/` (R21 spec). Job `licenses`, like `documents.yml`, takes all the caller's submodules, so the repository has no submodules but the public `spec`. The tools of the checks and their versions are its own | yes: "TypeScript / lint", "TypeScript / test", "TypeScript / vuln" and "TypeScript / licenses", when the caller's job is named "TypeScript", and with `engines` also "TypeScript / engines". "TypeScript / coverage" and "TypeScript / toolchain" — no, as in `go.yml` |
| `release.yml` | a release with keyless signing (R18). The number comes from `spec`'s release recipes, which the script `spec/tools/toolchain/toolchain.sh` from the caller's submodule runs, in the copy of the checkout: the recipes' containers change only it, and the runner's `git` reads the checkout itself (2.12). The line is `RELEASE_LINE` of the caller's workflow. A release comes out only if the paths of `paths` changed since the last one; the first always comes out. The files are built by the caller's recipe `release-files` from the commit's tree, in its stage `toolchain-core`, or `toolchain` without one, and the number in the same (R47). Only the commit that the run itself names, `GITHUB_SHA`, is signed: its certificate names the same commit as the tag, and an older commit is covered by the release of the tip. Every file, module packages too (R17 spec), is signed by cosign 3.1.4 with a bundle beside it, and every bundle is checked before publishing — against the shared `release.yml`, the caller's repository and this commit —, eight files at once, each with a copy of one TUF cache (R44, T63). A run that publishes first checks that the signature will be one that R77 spec lets in: the caller's workflow is its `.github/workflows/release.yml` on `main`, and the shared `release.yml` is pinned by a SHA (the amendment to R18, T39). The release is Latest and immutable; `gh release verify` checks its attestation by one call, and each file is held to the sha256 of a subject in it (R44, T63). With `npm-package` the same archive of the package goes to npm, through trusted publishing, after the release has come out and been checked. The archive is checked before the release already, and the number with it: a number that npm has already given out and a package unpublished whole stop the run before the release. A rerun for a commit already released publishes the archive from the release, after checking its attestation and signature. The signature is checked by `spec`'s recipe `release-verify` (R77 spec), and a dry run of the recipe goes before the build already (the amendment to R18, T39). The publication is judged by the registry, not by npm's exit code (the amendments to R18). A version counts as published when the package's document has shown it and the registry has served its archive: the step waits for both in rounds, up to 20 minutes, and the job's `timeout-minutes` is 45 (the 2026-11-08 amendment to R18, T44). With the input `previous-file` the recipe gets the file of the last release: before the build the step "The previous release's file" downloads it with its bundle from the newest release, checks the attestation, and the signature by the recipe `release-verify`, and hands it to the recipe as the second argument, read-only. The first release gets an empty second argument, and a file that cannot be downloaded or checked stops the run before the build (the 2026-11-02 amendment to R63 spec; the amendment to R18, T41) | `module-kit` first, then `modules` and the other repositories with releases; with `npm-package` — the repositories with UI packages, `canvas` first (R37 spec) | `paths` — pathspecs of what the release is built from, one per line; `publish` — `false` for a trial without publishing; `npm-package` — a package in the scope `@altnovatrail` that the release publishes to npm, empty — publishes none; `previous-file` — the name of the file of the last release that the recipe gets, for example `module-index.json`, empty — gets none | `contents: write`, `id-token: write`, `actions: read` | a recipe `release-files VERSION` that writes plain files with safe names into `dist/`. It builds from the commit's tree without history or submodules, so it has no `git`, and the version comes as an argument; `RELEASE_LINE` in its own `release.yml`; CI — `ci.yml`; immutable releases and a ruleset of the tags `v*` — a condition of the signature check (R77 spec); the submodule `spec` — `altnovatrail/spec` at the tag v0.2.17 or newer, which has this script: otherwise the run stops before the build and names the reason (the amendment to R18). The workflow is `.github/workflows/release.yml`, and it pins the shared `release.yml` by the SHA of a release (R04): otherwise a run that publishes stops first thing (T39). With `npm-package` — the `npm pack` archive among the files of `dist/`. The submodule `spec` — v0.6.0 or newer, which has `release-verify`: otherwise the run stops before the build (T39). With `previous-file` — the recipe `release-files VERSION PREVIOUS` with two parameters, among the files of `dist/` a file with this name, and the same submodule, v0.6.0 or newer (T41). In `package.json` — `repository` as an object with the URL of this repository, without `private`, `publishConfig` or a `tag` of its own. The first version of the package is published by hand, and the package's trusted publisher names the repository and the file of the caller's release workflow, with no environment, and allows `npm publish` (3.3) | no: it is not a check of a pull request |

The license list for `go.yml` and `typescript.yml` is one for all — category A of the ASF's policy, as in `spec`'s check (the amendment to R12 spec). For Go it lies in `go.yml` itself, `ALLOWED_LICENSES`, and `self-ci.yml` checks it against what `spec`'s recipe `licenses-allowed` prints (2.7; R16; R39 spec). `typescript.yml` has no copy: the `ci-licenses` of a TypeScript caller checks the lock file by `spec`'s recipe `licenses-check-repo` and takes the list from `spec`, at the tag of its submodule (the amendments to R19). Each has an input of its own — `same-bits` and `engines` —, and their four recipe names are the same — above (R16, R19). Both send coverage by the same job `coverage`, and they differ only in the artifact's name and the report file. Only this job has the permission `id-token: write`: the jobs of the matrix execute the pull request's code (the 2026-11-01 amendments to R16 and R19). Every job of both that builds the image of the `toolchain` stage takes it from the caller's GitHub Actions cache — a `docker save` file by a key of the runner's OS and architecture and the hash of the Dockerfile, `${{ runner.temp }}/novatrail-toolchain.tar` of the image `novatrail-toolchain`, as `documents.yml` and `spec`'s `toolchain.sh` have it, so a caller keeps one entry of the image —, and on a miss the job `toolchain` alone builds it for the jobs after it, which take it by an artifact of the run; only a push to `main` saves it (R42). The core, where it is a stage of its own, has its own file, `novatrail-toolchain-core.tar`, entry and artifact (R47). The jobs of `go.yml` take the caches of Go the same way (R41); the shared release takes no cache (R36). The identity of the signature — 2.3.

The names of the jobs in the shared workflows and in the calling files are the same for every repository: a required check is named "`<job name> / <reusable job name>`" (sources 2.1), and the ruleset of `main` in every repository lists the same names (R30 spec) — but for CodeQL, which has a check per language of the repository. The caller's job is named after the check — "Secrets", "DCO", "Documents" —, and the shared workflow's job after what it runs (R08).

### 3.2. The repositories' own workflows

A repository's own is what only that one repository knows (R30 spec). Its own checks run in the `toolchain` stage of its devcontainer, as in `spec`.

| Repository | Its own workflows and checks |
|---|---|
| `spec` | `ci.yml` — "Documents and tools": `docs-check`, `format-check`, `types-check`, `go-check`, the license check of `tools/`, the number and the files of the release and the tests of `tools/` with coverage — and "Coverage", the upload of coverage to Codecov by OIDC (R30, R48 spec). `release.yml` — its own release: the format's files and the types package, the cosign signature and the publishing of `@altnovatrail/spec` to npm by the steps of the shared release (R31, R64, R73 spec; the second 2026-10-29 amendment to R37 spec). Job "Go" — the shared `go.yml` v0.1.10 with its own recipes `ci-*`, from T50 `spec`; the coverage of Go — for now by its own upload, together with the coverage of `tools/`, until the upload in the wrapper, T34 (the 2026-11-01 amendments to R30 and R48 spec) |
| `.github` | `self-ci.yml`, `self-release.yml`, `self-codeql.yml` and `self-scorecard.yml` — section 3.4 |
| `modules` | the check of the packages by the CLI of `module-kit` and by the learner simulator `sim`, at tags; from stage 2 — eval with a key of the platform (R24 spec), by the rule of R05 (repositories 4 spec) |
| `learner-model`, `engine` | the gate of `sim` at a tag through `go.work` (repositories 1, 4 spec) |
| `canvas` | the build of the samples page with the CLI of `module-kit` and the release of `modules`, at a tag (R25 spec) |
| `api` | the SDKs of AI providers come only through `tutor` (R15 spec) |
| `module-kit`, `engine`, `sim` and the widgets | the test vectors of the generator of randomness and of the derivation of seeds (Т-18) |

SonarCloud is not a workflow: the analysis is automatic, and its check is set by the SonarQube Cloud app (R30 spec).

### 3.3. Calling files

Every repository of a component has the same files; they differ only in the inputs of CodeQL — `languages` and `paths-ignore` —, in what the kind of the repository adds: for the kind go, job "Go" and the ecosystem `gomod` (R16), for the kind typescript, job "TypeScript" and the ecosystem `npm` (R19) —, and in their own jobs. The shared workflows are pinned by the SHA of the first release of `.github`, `v0.1.0` — the commit `ff2a3597769ca85e59e476b1a41bdcbc1f50e3ed` —, with a comment of the version on the same line, and Dependabot raises them (R04). When copying, take the latest release of `.github`: its tag is named by `gh release view -R altnovatrail/.github`, and its commit by `git ls-remote https://github.com/altnovatrail/.github refs/tags/<tag>`; `v0.1.0` below is the first of them. The texts below are ready to copy; how `spec` and `.github` differ comes after them. actionlint 1.7.12 with shellcheck 0.11.0 found nothing to remark on in the three workflows below, and all five shared workflows exist at this commit; no check here reads `dependabot.yml`.

`.github/workflows/ci.yml` — on a pull request and a push to `main`; beside the three shared ones go the repository's own jobs. Job `documents` requires `.devcontainer/Dockerfile` with the `toolchain` stage and the submodule `spec/` at a tag with the recipe `docs-check-repo` — v0.2.3 or newer (R32 spec; section 3.1). A repository at an older tag first moves to a new one, in a task of its own (RULES.md, Across repositories), or "Documents / docs-check-repo" is red. All eleven repositories of the components stand at v0.2.9 or newer (the amendment to R32 spec; sources 13.6):

```yaml
# NovaTrail's shared checks (R03 .github), pinned to a release of .github by SHA with its version
# beside it; Dependabot moves both. The repository's own jobs go beside them.
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
    uses: altnovatrail/.github/.github/workflows/secrets.yml@ff2a3597769ca85e59e476b1a41bdcbc1f50e3ed # v0.1.0

  # A pull request's commits are what it checks; a push to main has been checked as one.
  dco:
    name: DCO
    if: github.event_name == 'pull_request'
    uses: altnovatrail/.github/.github/workflows/dco.yml@ff2a3597769ca85e59e476b1a41bdcbc1f50e3ed # v0.1.0

  documents:
    name: Documents
    uses: altnovatrail/.github/.github/workflows/documents.yml@93c848fb51a10a245968cf730b99cc709a7748bf # v0.1.31
```

`.github/workflows/codeql.yml` — on a pull request and a push to `main`. It is not run weekly: the CodeQL bundle is pinned together with the action (R09). The repository's languages beyond `actions` go in the input `languages`: `javascript-typescript` and, from the release after T19, `go` —, and then "CodeQL / analyze (go)" also goes into the ruleset of `main` (section 3.1). From `v0.1.30` it builds no image for Go (R45):

```yaml
# CodeQL over the repository's workflows and its languages (R09 .github), pinned to a release of
# .github. The job gives the shared workflow what it needs to upload its results.
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
    uses: altnovatrail/.github/.github/workflows/codeql.yml@8311cbfc01082e9b196c0af8d7b49192115cc84c # v0.1.30
```

`.github/workflows/scorecard.yml` — on a push to `main` and weekly:

```yaml
# OpenSSF Scorecard (R09 .github), pinned to a release of .github. Like the shared file, it has no
# env or defaults and only read permission at the top, as the Scorecard server asks of a workflow
# that publishes.
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
    uses: altnovatrail/.github/.github/workflows/scorecard.yml@ff2a3597769ca85e59e476b1a41bdcbc1f50e3ed # v0.1.0
```

`.github/dependabot.yml` — weekly, as in `spec`: `github-actions` in `/`, which raises the references to the shared workflows too, and `docker` in `/.devcontainer`; the ecosystems of the languages come with code (repositories 2.2 spec, step 5). Every ecosystem has the `cooldown` pause of three days (R10). It does not hold back the base image, but it holds back the references to `.github` (2.6). The references to the shared workflows go as one group, `shared-workflows`: all in one pull request, to one release, not a pull request per file (the 2026-11-08 amendment to R04; Д88 in RUN.md `spec`):

```yaml
version: 2

updates:
  # The actions of the workflows, and the references to .github's shared workflows with them.
  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: weekly
    cooldown:
      default-days: 3
    groups:
      # Every reference to a shared workflow or action of .github in one pull request, to one release:
      # Dependabot names each altnovatrail/.github/.github/workflows/<file>.yml and actions/toolchain.
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
- **the name of a reference** — in dependabot-core a reference to a reusable workflow is a dependency named "repository and workflow path", `altnovatrail/.github/.github/workflows/<file>.yml`. And `*` in `patterns` matches any characters, `/` too, ignoring case (sources 4.2). Actions of other owners are not in the group and go, as before, a pull request per action;
- **the pause** of the group is the same: an update of the group checks every reference by the same check with the `cooldown` of the Dependabot job (sources 4.2). The group waits three days, as each reference alone does;
- **holding back one reference** is not possible with the group: there is one pull request. A release that came out later than its commit is held back by hand, whole, as before (2.10);
- **`.github` itself** has no group: its own `self-` workflows call the shared ones by a local path, `./.github/workflows/<file>.yml`, and Dependabot does not raise such a reference (sources 4.1 and 4.2).

The group is brought into the callers by the session of `spec` (the 2026-10-21 amendment to R30 spec; Д88 in RUN.md `spec`).

`.sonarcloud.properties` — without `spec/**` (Д7 in RUN.md `spec`, closed in T21 `spec`):

```properties
sonar.exclusions=spec/**
```

A repository in Go adds to `ci.yml` the job "Go", which calls the shared `go.yml` (R16). `go.yml` is in the releases of `.github` from `v0.1.2`, the commit `d01dd881d6b4efb6013dd72f40a713b8d2dd3bad`; the latest release is named by `gh release view` and `git ls-remote`, as above. From `v0.1.12`, the commit `4225639bcd04f43ef58f95cabf9fdfd947cbcb07`, the wrapper sends the coverage of the tests to Codecov, and the caller's job gives it `id-token: write` (the 2026-11-01 amendment to R16). From `v0.1.18`, the commit `6f774969620624790f9c7ff1a94d9bbd8b80e342`, the wrapper has the input `same-bits` — on it below (the 2026-11-08 amendment to R16, T46). From `v0.1.19`, the commit `982ffe64b1f26f1ca4e0279c093d83cbb8ff3882`, the input also has the job "Go / arm64" (the 2026-11-08 amendment to R16, T47). From `v0.1.20`, the commit `f87e8da72bd70ce171816881b9288cb6f7b17901`, — also "Go / rules", with the caller's lists `.github/coderules.json` (the 2026-11-08 amendment to R16, T48; R33). From `v0.1.22` every job of the wrapper that builds the `toolchain` stage takes its image from the caller's GitHub Actions cache and builds it only on a miss (R36). From `v0.1.24` "Go / targets" and "Go / arm64" run the tests on wasip1 too, in `node:wasi` (R39): a caller with `same-bits` whose tests fail on wasip1 gets both red. From `v0.1.25` the Go caches come from the caller's cache, from `v0.1.33` by the prefix on a miss (R41). From `v0.1.32` "Go / arm64" takes the composite action of 3.7 (R49). None of these asks the caller for new permissions or inputs. The text below pins `v0.1.33`. To the earlier releases this permission changes nothing: a called workflow only lowers permissions. How the caller moves — "Coverage" below.

```yaml
  # The repository's Go code, by its own ci- recipes in its toolchain stage, and the coverage of
  # its tests, which the shared workflow sends to Codecov (R16 .github). id-token: write is for its
  # coverage job alone, which asks for an OIDC token: a called workflow can only lower what this
  # job gives it.
  go:
    name: Go
    permissions:
      contents: read
      id-token: write
    uses: altnovatrail/.github/.github/workflows/go.yml@f1c7e9e6f8245fdbdbc23c4091f3c26350e3a44e # v0.1.33
```

A repository whose bits must be the same on every build — `learner-model` and `engine` (R107 spec) — adds to job "Go" the input `same-bits` (the 2026-11-08 amendment to R16, T46). The input is in `go.yml` from `v0.1.18`, and earlier releases do not know it: GitHub will reject a call with an unknown input. So the caller raises the reference to `v0.1.19` or newer in the same pull request: `v0.1.18` has the input, but without "Go / arm64".

```yaml
    with:
      # The tests on the builds where the bits are most at risk, and fma-diff (R107 in spec).
      same-bits: true
```

Then, in the caller:
- the ruleset of `main` gets also "Go / targets", "Go / fma-diff", "Go / arm64" and "Go / rules", once they have first come to `main` (rule 4). "Go / arm64" from `v0.1.19`, "Go / rules" from `v0.1.20`;
- the recipes `test-targets` and `fma-diff` leave the `justfile`, and so does their call through `&&` in `ci-test`. `testdata/fma` leaves the repository: `fma-diff` has its own control;
- the repository's own job "Go arm64" leaves `ci.yml`: "Go / arm64" does its work from `v0.1.19`, not earlier: `v0.1.18` does not know this job, and without its own job the caller would lose the run on arm64 silently. `rules_test.go` with `testdata/coderules` leave from `v0.1.20`: "Go / rules" takes their place, and the same release requires the lists. The caller raises the reference to `go.yml` to `v0.1.20` in the same pull request where it puts the lists: without them "Go / rules" is red;
- `.github/coderules.json` holds the lists, which the tool `tools/coderules/` reads with `DisallowUnknownFields`. Each field is a list, empty if the file does not name it: `code-imports` — the packages the code may import, besides its own; `test-imports` — what the tests may import beyond them; `test-math` — the functions of `math` the tests may call beyond those the rules allow everyone; `requires` — the modules `go.mod` may require; `nested-modules` — the folders from the root where the `go.mod` of a nested module may lie, as the lock file of a tool that the code does not read. Without the file "Go / rules" fails and names the reason (R33). The lists of `learner-model` are from its `rules_test.go` (`main` 50f1b51):

```json
{
  "code-imports": [
    "cmp", "encoding/binary", "errors", "math", "math/bits", "slices", "strconv", "strings",
    "unicode/utf8"
  ],
  "test-imports": [
    "bytes", "crypto/sha256", "fmt", "go/ast", "go/importer", "go/parser", "go/token", "go/types",
    "math/rand/v2", "os", "path/filepath", "runtime", "testing"
  ],
  "test-math": ["Exp", "Log"],
  "requires": [],
  "nested-modules": [".devcontainer/gopls"]
}
```

  `engine` has its own lists, those of its `rules_test.go`, with `github.com/altnovatrail/learner-model` in `code-imports` and `requires` and without `test-math`. The rules, and what they allow everyone of `math`, `strings` and `strconv`, are in the tool, not in the lists. The packages that only `rules_test.go` itself imported — `go/ast` and its neighbours — can be removed from `test-imports` together with it.

And to `dependabot.yml` — the ecosystem `gomod`, with the same pause. Dependabot does not see Go in the Dockerfile or the tools that the recipes run through `go run` at an exact version, and they are raised by hand (R04 module-kit):

```yaml
  # The Go modules the code is built from.
  - package-ecosystem: gomod
    directory: /
    schedule:
      interval: weekly
    cooldown:
      default-days: 3
```

A repository in TypeScript adds to `ci.yml` the job "TypeScript", which calls the shared `typescript.yml` (R19). `typescript.yml` is in the releases of `.github` from `v0.1.5`, the commit `c772cc86973240e21cebb310fd0cda221a752ade`; the latest release is named by `gh release view` and `git ls-remote`, as above. From `v0.1.8`, the commit `0ab279940126dadbde0f5a3912ce196ed39470ab`, job `licenses` takes the submodule `spec`, and `ci-licenses` checks the lock file by `spec`'s recipe `licenses-check-repo`. The submodule is at the tag v0.2.18 or newer (the amendment to R19). The caller moves `ci-licenses` to the recipe together with raising the reference to this release or after it, but not before: the older wrapper does not provide the submodule. From `v0.1.10` the wrapper does not pass `ALLOWED_LICENSES` into the container: of the environment only `CI` goes there, and `ci-licenses` takes the list from `spec` (the amendment to R19). From `v0.1.12`, the commit `4225639bcd04f43ef58f95cabf9fdfd947cbcb07`, the wrapper sends the coverage of the tests to Codecov, as `go.yml` does, and the job's permissions are the same (the 2026-11-01 amendment to R19). From `v0.1.22` job `check` takes the image of the `toolchain` stage from the cache, as `go.yml` does (R36), which asks nothing new; from `v0.1.29` it has the input `engines`, below. The text below pins `v0.1.29`. What is needed of the recipes, `.npmrc` and the `toolchain` stage — R19 and section 3.1.

```yaml
  # The repository's TypeScript code, by its own ci- recipes in its toolchain stage, and the
  # coverage of its tests, which the shared workflow sends to Codecov (R19 .github). id-token:
  # write is for its coverage job alone, which asks for an OIDC token: a called workflow can only
  # lower what this job gives it.
  typescript:
    name: TypeScript
    permissions:
      contents: read
      id-token: write
    uses: altnovatrail/.github/.github/workflows/typescript.yml@93c848fb51a10a245968cf730b99cc709a7748bf # v0.1.31
```

A repository that tests in WebKit and Firefox, as `app` and `canvas`, gives the job the input `engines`, from `v0.1.29`: an earlier release rejects the input (the 2026-11-16 amendment to R19, T64). `ci-test` keeps Node and Chromium, `ci-engines` runs WebKit and Firefox, and "TypeScript / engines" enters the ruleset once on `main`:

```yaml
    with:
      engines: true
```

And to `dependabot.yml` — the ecosystem `npm`, with the same pause; `directory` is the folder of `package.json`. Dependabot does not see Node in the Dockerfile or the browsers for the tests, and they are raised by hand, like Go: in the Dockerfile it reads only the `FROM` lines (sources 4.2), and the Playwright image stands in `COPY --from`. So a pull request that raises `playwright` is red until the tag and digest of the image and the browser's revision are raised by hand in it too (R13 canvas):

```yaml
  # The npm packages the code is built and checked with.
  - package-ecosystem: npm
    directory: /
    schedule:
      interval: weekly
    cooldown:
      default-days: 3
```

With tests in Vitest and with `@types/node`, two more additions go to the entry, as at `canvas` (R12 canvas; the amendment to R19). The group `vitest` is needed because `@vitest/browser-playwright` requires `vitest` at an exact version, and separate pull requests would be red. The `ignore` of the major versions of `@types/node` is there because the types follow Node, which is raised by hand:

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

**Coverage.** A repository with the job "Go" or "TypeScript" sends the coverage of its tests to Codecov from the wrapper (the 2026-11-01 amendments to R16 and R19; R48 spec). Its `ci-test` writes the report — for Go the profile `coverage/go.out`, for TypeScript lcov `coverage/lcov.info` (3.1) —, and `.gitignore` keeps `coverage/` out. The Codecov app is installed for the organization on all repositories (sources 10.3), so it needs no setup. `.github/codecov.yml` follows the `codecov.yml` of `spec`: a threshold of 90% for the changed lines, and a comment only when the coverage changes. A Go profile names a file by its import path, which for NovaTrail's modules is `github.com/altnovatrail/<repository>`, and Codecov cuts it down to the path in the repository by itself, by a default rule (sources 10.3; measurements 4.1). So the file has no `fixes` of its own:

```yaml
# What Codecov does with the coverage of the tests, which the coverage job of .github's shared
# go.yml or typescript.yml uploads (R48 in spec; R16, R19 .github): the report ci-test writes, a
# Go profile in coverage/go.out or lcov in coverage/lcov.info. A Go profile names a file by its
# import path, which Codecov cuts down to the path in the repository by a default rule of its own.

coverage:
  status:
    # New and changed lines are covered at 90 % at least (R48 in spec). The ruleset of main
    # requires this check once a pull request of Dependabot has shown that it comes (R30 in spec).
    # A pull request that changes no line of the report, the documents alone, passes as "Coverage
    # not affected".
    patch:
      default:
        target: 90%
    # On the plan Codecov gives a public repository, it sets no project status (R48 in spec).
    # Should it ever set one, it only informs: the badge shows the coverage of the whole.
    project:
      default:
        informational: true

# As spec's: a comment only when the coverage changes, with the diff and the files.
comment:
  layout: "condensed_header, diff, files"
  require_changes: true
```

The caller moves in this order — by the repository's own session, in a task of its own (Д29 in RUN.md `spec`):
1. still on the former release of the wrapper — `ci-test` with the report, `.gitignore`, `codecov.yml` and the `permissions` of the language's job, as in the texts above. The former wrapper does not read the report, and the permission `id-token: write` gives it nothing;
2. the raise of the reference to a release with the upload, `v0.1.12` or newer — a pull request of Dependabot or the repository's own. If it comes before step 1, it is red: without the permission the run of CI does not start at all — "The nested job 'coverage' is requesting 'id-token: write', but is only allowed 'id-token: none'" —, and without the report "… / test" is red (measurements 4.1). Such a pull request is held back by hand until step 1 is merged;
3. after the first pull request of Dependabot with the upload — `codecov/patch` in the ruleset of `main`, with `integration_id` 254, as at `spec`: rule 4, a step of the author (the 2026-10-23 amendments to R30 spec). While `main` has no report, `codecov/patch` comes as a success — "No report found to compare against" (measurements 4.1);
4. the coverage badge in the README — by repositories 2.3 spec, with the first upload on `main`.

The caller creates no artifacts `go-coverage` and `typescript-coverage` of its own: an artifact's name is unique within a run (3.1). A repository with Go and TypeScript writes the Go profile after the tests of Vitest: Vitest clears `coverage/` before its tests (the 2026-11-01 amendment to R19). It has two uploads per commit, and it adds `codecov: {notify: {after_n_builds: 2}}` to `codecov.yml`. By default Codecov waits for one report, and `wait_for_ci` waits only for the end of the statuses of CI, so the status could go out on the first report (sources 10.3). At `spec`, its own upload stays for the lcov of `tools/`, and the Go profile goes over to the upload of `go.yml` by its move (Д29 in RUN.md `spec`).

A repository with releases adds `.github/workflows/release.yml`, which calls the shared `release.yml` (R18). `release.yml` is in the releases of `.github` since `v0.1.4`. Since `v0.1.6`, commit `630924eeb673272d634120b054d1ae93ca33a70c`, it runs the recipes of `spec` by the script `spec/tools/toolchain/toolchain.sh` from the caller's submodule. The submodule must be `altnovatrail/spec` at the tag v0.2.17 or newer: otherwise the run of Release on `main` stops and names the reason (the amendment to R18). So the caller moves to v0.2.17 before it raises the reference to `.github`. Since `v0.1.9`, commit `41d5144e304cfad05c681de6934405c08a7435db`, the shared release has the input `npm-package` — on it below —, and a caller without it needs nothing new. Since `v0.1.13`, commit `09443e1027ef24197439dfe60a072d14c3626cc3`, a run that publishes stops before anything else if the caller's workflow is not `.github/workflows/release.yml` on `main`, or if the shared `release.yml` is pinned other than by its own path and a SHA: R77 spec would reject the signature of such a run, and the files of a release are immutable. The template below keeps both. A caller with `npm-package` also needs the submodule `spec` at v0.6.0 or newer: a rerun checks the archive by the recipe `release-verify`, and a dry run of the recipe goes before the build. So such a caller moves to v0.6.0 before it raises the reference to this release (the amendment to R18). Since `v0.1.14`, commit `96dadfef02ca25376d4ea88f887003639d20080e`, the shared release has the input `previous-file` — on it below —, and a caller without it needs nothing new. These ask nothing new of the caller — that of `v0.1.11`, of a caller without `npm-package`: from `v0.1.7` the recipes of `spec` run in the copy of the checkout, and the runner's `git` reads only the checkout itself (the amendment to R18); from `v0.1.11` the npm step rejects, before the release, a number that npm has already given out, and a package unpublished whole (the 2026-11-01 amendment to R18), and from `v0.1.15` it checks an unpublished number as the step of `spec` does (T42); from `v0.1.16` it waits up to 20 minutes for the version and its archive, and the job's `timeout-minutes` is 45 (the 2026-11-08 amendment to R18, T44); from `v0.1.28`, commit `6c7aec565ff96693e70ea0bdaa2bdd876dfce4fe`, the release signs and checks its files eight at once, and checks the files it published against its attestation by one call (R44). The text below pins `v0.1.28`. The `paths` list lists what the output is built from, by the kind of the repository, and not everything but the exclusions (the 2026-10-22 amendment to R31 spec; the amendment to R18). This template keeps the list itself, and R31 spec gives only the rule it is made by (the 2026-11-01 amendment to R31 spec). Below is the list of the kind go: the Go code without the tests, `go.mod`, `go.sum`, `justfile`, `LICENSE`, the whole `.devcontainer/Dockerfile` — Go is pinned in it — and `release.yml` itself, so that a change of the line gives a release. `*.go` in a git pathspec without the magic `glob` takes files at any depth, and `**/*.go` would miss a Go file in the root (measurements 2.2). The files that the code embeds by `//go:embed` the caller adds to the list itself, and the code in `testdata/`, which is not part of the build, it excludes itself: the list holds what the consumer will get. The lists of the kinds typescript and modules are below, after the input `previous-file` (T45; the 2026-11-01 amendment to R31 spec). The caller's job sets no `concurrency` of its own: the shared job waits in the queue `release` by itself:

```yaml
# NovaTrail's shared release (R18 .github), pinned to a release of .github by SHA with its version
# beside it. RELEASE_LINE is the line the releases are numbered in; paths, what they are built from.
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
    uses: altnovatrail/.github/.github/workflows/release.yml@93c848fb51a10a245968cf730b99cc709a7748bf # v0.1.31
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

Before a repository's first release, immutable releases are turned on for it (`PUT repos/altnovatrail/<repository>/immutable-releases`) and a ruleset of the tags `v*` is set: `update`, `deletion` and `non_fast_forward`, with no bypass, as the ruleset 25452244 of `.github` (R10). Without them the check of the signature cannot rely on the tag: that is its condition (R77 spec). Both settings fall under rule 4. At `module-kit` they are set since T16, and its ruleset of tags is 25559103.

An edit of `RELEASE_LINE` gives a release by itself: the caller's `release.yml` is in the list. Edits that may leave the output unchanged give a release too: the tools of the `devcontainer` stage in the Dockerfile, a raise of the reference to the shared `release.yml`, and a new base image — the `toolchain` stage is built in it. The raise of the reference and the image come as pull requests of Dependabot, once a week, and the image also without the pause (3.5). The first two edits were named by the 2026-10-22 amendment to R31 spec, and the image by the 2026-11-01 amendment.

A repository with a UI package adds the line `npm-package: "@altnovatrail/<name>"` to `with:` — since `v0.1.9` (R37 spec; the amendment to R18). Then the same archive that is signed in the release, `<scope>-<name>-<X.Y.Z>.tgz`, as `npm pack` names it, goes to npm by trusted publishing. The author's steps — by rule 4, in the task of the repository that releases the package:
1. the first release comes out without `npm-package`: a trusted publisher is set up only for a package that is already in the registry;
2. the author checks the archive of this release — `gh release verify-asset` and the signature — and publishes it by hand from an empty folder, with 2FA: `npm publish ./<archive>.tgz --access public`. This version has no provenance;
3. the trusted publisher: `npm trust github @altnovatrail/<name> --file <file of the release workflow> --repository altnovatrail/<repository> --allow-publish`, or the same on the npm site. There is no environment, and direct publishing is allowed: a new setting allows only staged publishing by default;
4. within 2 days of the setup, the first publishing by it must go through — the pull request that adds `npm-package`. The edit of `release.yml` gives a release by itself if the file is in the `paths` list, as above.

If npm refuses when the GitHub release has already come out, the run is rerun: the rerun takes the archive from the release, checks the attestation, and the signature by the recipe `release-verify` of `spec` (since `v0.1.13`), and publishes it. The button does the same if the released commit is still the tip of `main`. Otherwise the author publishes the same checked file by hand: the next release does not publish the old version. A number that npm has already given out — unpublished, or with another archive — npm will never take. The run then fails before the release and says to raise `RELEASE_LINE`: every release of the line would take the same number. A package unpublished whole takes no new versions for 24 hours, and then its next version is published by hand, like the first, and the trusted publisher is set again if it is gone: whether it outlives the package, npm's documentation does not say (the 2026-11-01 amendment to R18). The package's `package.json` has `repository` as an object with the repository's url, and no `private`, `publishConfig` or `tag` of its own: otherwise the run stops even before the release and names the reason.

A repository whose release is built on a file of the previous release — `modules` with its cumulative index (R63 spec) — adds the line `previous-file: module-index.json` to `with:`, since `v0.1.14` (the 2026-11-02 amendment to R63 spec; the amendment to R18). Then:
- the recipe takes two parameters, `release-files version previous:`. As the second it gets the path `/previous/module-index.json` to the file of the newest release, checked before the build — read-only —, and the first release gets an empty string. An empty string is what means "there is no previous", and the recipe tells the build so explicitly (R63 spec). The recipe and the input change together: just, given two arguments for a recipe with one parameter, answers "justfile does not contain recipe …" with the second argument — empty on the first release, `/previous/module-index.json` on the next ones —, and given one for a recipe with two, "got 1 positional argument but takes 2" (measurements 5.1). The run then stops before the release;
- among the files of `dist/` is a file of the same name: the next release will take it from this one, and without it the run will stop before the release;
- the submodule `spec` is at v0.6.0 or newer, which has `release-verify`, as with `npm-package`;
- the input can be set from the repository's first release too. If it is added later, the file must already be in the newest release, signed by the shared release v0.1.7 or newer: otherwise `release-verify` will not let it in (R77 spec), and the run will stop before the build;
- a run that failed to read Sigstore, GitHub or the npm registry is rerun: the recipe then refuses, and there is no release yet.

The list of the kind typescript is for a repository whose output is an npm package built by the TypeScript compiler, first at `canvas`. This is its list from `release.yml` on `main` (bdb9e6d, 2026-11-08), written down by T66 canvas by the rule of the template (the 2026-11-02 amendment to R08 canvas; the 2026-10-22 amendment to R31 spec). Where they diverge from the template, the template is right. The caller's `with:` holds the names of the build files of `canvas`, and another repository has its own:

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
- `package.json` and the compiler configurations the package is built by — at `canvas`, `tsconfig.base.json` and `tsconfig.build.json`. The lock file is not in the list: it does not go into the archive, and the compiler is pinned at an exact version in `package.json` (R08 canvas).
- `README.md`, `LICENSE` and `NOTICE` are files of the archive: `npm pack` always puts README and LICENSE into the archive, and at `canvas` `NOTICE` goes into the archive by R46 canvas. A repository without `NOTICE` does not name it.
- `.devcontainer/Dockerfile` — whole, as for the kind go: its `toolchain` stage holds Node and npm, with which the recipe `release-files` packs the archive.
- `justfile` with the recipe `release-files`, and `release.yml` itself, as for the kind go.
- The differences from the kind go are only the sources and the build files. A file that the archive takes from outside the list, the caller adds itself: the list holds what the consumer will get (the 2026-10-22 amendment to R31 spec).

The list of the kind modules is for a repository whose output is module packages and their index (the 2026-11-01 amendment to R31 spec; Д80 in RUN.md `spec`). It is cited by architecture 3.3 modules and the 2026-11-06 amendment to R03 modules, and the `release.yml` of `modules` carries the same list since T16 modules. Where they diverge from the template, the template is right. In the caller's `with:`:

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

- The list holds the folders of the modules without their eval sets, the withdrawals file `withdrawals.yaml`, `justfile` with the recipe `release-files`, the root's `LICENSE` and `release.yml` itself. Withdrawals are an input of the build of the index, so a pull request with only a withdrawal gives a release (Д45 in RUN.md `spec`).
- `.devcontainer/Dockerfile` is not in the list, unlike the kind go. A package and the index depend only on the module's files and the format version of its manifest, not on the version of the CLI of `module-kit` in the Dockerfile (R03 modules). So a raise of the CLI or of the base image gives no release.
- The price is the whole `justfile`: an edit of a CI recipe in it will give a release with the same index.
- The magic `glob` is needed so that `*` does not match `/`: without it the exclusion `modules/*/eval/**` would also take a module's `media/eval/`. The list was checked by the trial of `modules` (R03 modules).

The merge in the ruleset of `main` is held by the checks of the column "Check in the ruleset" of section 3.1 — for a repository on Go, also the four checks "Go / …" (R16) —, and by the repository's own jobs (R30 spec), with `integration_id` 15368 for the checks of GitHub Actions and 12526 for SonarCloud, as at `spec` and `.github` (R11): without it a required check would be closed by a status of the same name from anyone who has write access (sources 3.1). The merge is held by the findings of CodeQL too — by the rule `code_scanning` —, and a pull request goes into `main` only by a merge commit. This must be so for everyone by the amendment to R30 spec. At `.github` it is set since R12, at `spec`, `module-kit` and `tutor` since T17 and T16 `spec`, and at the nine others since T21 `spec`.
- The rule is set after the first analysis of CodeQL on `main`: it needs results on the branch that the pull request changes too (sources 3.1).
- The repository's setting `allow_merge_commit` is not turned off: if a repository has turned off a method that the ruleset requires, the merge does not go through at all (sources 3.1).

Differences:
- `spec` has no job `documents` in its `ci.yml` — beside it is its own job "Documents and tools", and since T50 `spec` also the job "Go" with the shared `go.yml` —, its `codeql.yml` has `with: languages: javascript-typescript` for `tools/` and, since `v0.1.1`, `paths-ignore: draft/**` for the prototype (Д8 in RUN.md `spec`), and its ruleset has "Documents and tools" in place of "Documents / docs-check-repo", and also "CodeQL / analyze (javascript-typescript)". `spec` already has `.sonarcloud.properties` and `dependabot.yml` of its own — the exclusions of the tests and the drafts, npm in `/tools` (R30 spec) —, and they are not replaced: it needs no exclusion `spec/**`, as it has no submodule;
- `.github` has calling files of its own, with the prefix `self-` (section 3.4): the names `codeql.yml` and `scorecard.yml` are taken here by the shared workflows themselves. Its ruleset also requires "Workflows" — its own job with actionlint (R11).

The first call was made by T17 `spec` (R13; RUN.md `spec`, T17):
- `spec` and `module-kit` call the shared workflows by the full path (2.8), and the server of Scorecard accepted the result (2.2). The policy of actions does not hinder the call: `.github`, `spec`, module-kit and `tutor` have `allowed_actions: all` and `sha_pinning_required: true` (sources 3.3), and the references by a SHA keep it;
- Dangerous-Workflow of the `release.yml` of `spec` after the amendment to R31 spec is 10;
- whether Dependabot raises the reference to `.github`, whether the pause holds it, and how DCO will take the sign-off of its commit, its first pull requests after `v0.1.1` will show (T14; Д10 in RUN.md `spec`). They showed — at `spec`, #40–#42 on 2026-10-23: it raises the reference, each file by a pull request of its own, the pause holds, and DCO accepts the sign-off of its commit (2.6, 2.8; R25).

The calling files common to all are written by the session of `spec` — through `.repos/<name>`, when a repository is created and by edits in all of them at once (R30 spec). What a repository's code adds — the language's job, the input of CodeQL, the ecosystem of Dependabot, `release.yml` — is written by the repository's own session, by the texts of this section (the 2026-10-21 amendment to R30 spec). The required checks in the ruleset, immutable releases and the ruleset of tags are still set by the author, or by the executor with the author's confirmation. Before the amendment, T10 `module-kit` was the exception: by the author's order the session of `.github` did it (the amendment to R03).

### 3.4. `.github`'s own CI

`.github`'s own workflows lie beside the shared ones and start with `self-`; the shared ones have no prefix, and they are run only through `workflow_call`:
- `self-ci.yml`, `name: CI` — on a pull request and on a push to `main`. The jobs "Secrets", "DCO" (on a pull request only) and "Documents" call the shared workflows by the local path `./.github/workflows/<file>`, so a pull request checks the very version that it changes. The job "Workflows" is actionlint 1.7.12 over all the workflows, with shellcheck 0.11.0 over the scripts in them: their code lives here. actionlint and shellcheck, like gitleaks, are downloaded at an exact version and checked against a sha256 sum in the file itself, and the devcontainer does not have them (R08); actionlint does not take the runner's shellcheck. The ignores of actionlint, each with its reason, are in `.github/actionlint.yaml`. The same job compares `ALLOWED_LICENSES` in `go.yml` — and in any other workflow where this list appears — with what the recipe `licenses-allowed` of `spec` prints at the tag of `.github`, and names the copy that diverged (R16). `typescript.yml` has no copy, and only `go.yml` is required by name to have one (the amendment to R19). The recipe runs in the `toolchain` stage of `.github` itself: the script `spec/tools/toolchain/toolchain.sh` builds it, so the job takes the checkout with the submodule (the amendment to R16), and the image from the cache, by the same steps and the same entry as `documents.yml`, which only a push to `main` saves (the 2026-11-10 amendment to R36; R42);
- the job "Go" of `self-ci.yml` calls the shared `go.yml` by the local path, without `same-bits`: the four recipes of the root `justfile` of `.github` — `ci-lint`, `ci-test`, `ci-vuln` and `ci-licenses` over the module `tools/coderules` through `go -C` —, and the upload of the coverage to Codecov by the `.github/codecov.yml` of the template of 3.3. govulncheck is v1.9.0, and go-licenses v2.0.1, as at `engine`. go-licenses does not check the module itself: its LICENSE is the root one, Apache-2.0, and go-licenses looks for LICENSE in the module's folder. `.sonarcloud.properties` removes `tools/coderules/testdata/**` from the search for duplicates: two controls are near copies of each other on purpose (R33);
- the suite of tests of the steps (R28) — steps of the same job after actionlint:
  - "Install yq" — yq 4.54.1 by the sum from the `checksums` of its release;
  - "Lint the tests" — the job's shellcheck 0.11.0 over `tests/*.sh` and `tests/stubs/*`;
  - "Lint the actions" — the same shellcheck over each run script of each composite action of `.github/actions/`, taken out by yq, as actionlint reads none; a script that fails is named with its action (R49);
  - "Test the workflows" — `YQ="$RUNNER_TEMP/yq" bash tests/run.sh`.

  The folder `tests/`: `run.sh` — the launcher, one bash process per test; `lib.sh` — the harness; `stubs/` — the stubs; `<workflow>.test.sh` — the cases of a workflow; `harness.test.sh` — the tests of the harness itself.

  A test chooses a step: `select_step <job> id=<id>` or `name=<name>`, after `use_workflow <file>`, or after `use_action <name>`, which reads a composite action of `.github/actions/` as the one job `action` (R49). Then it sets the context — `ctx`, `set_env`, `runner_env` — and the stubs: `stub`, `stub_in_temp`, `stub_exit`, `stub_stdout`, `curl_answer`, `curl_offline`. Then it runs `run_step` and checks the exit code, the lines of output, the step's outputs and the calls of the stubs. `wf` reads the structure and the text of `if:`.

  Locally the suite runs from the root of the repository, with yq 4.54.1 downloaded by the same sum: `YQ=<path> bash tests/run.sh`. A test stops after 120 seconds, the step under test after 60, and "Test the workflows" after 5 minutes, within the job's 10 minutes. shellcheck is of the version in "Install shellcheck". The devcontainer does not have them, as it does not have actionlint (R08);
- the job "Toolchain action" of `self-ci.yml` runs the composite action of 3.7 by the local path, as a caller's own job does: the call with `check: action`, a build of `tools/coderules` in the image with the Go caches mounted, and the call with `save: "true"`, which saves on a push to `main` alone (R49);
- `self-release.yml`, `name: Release` — its own release, as at `spec` (R31 spec; R10): after a green `self-ci.yml` on `main`, only from a push from the repository itself, and by the button — on `main`, after a green CI. The runs go in a queue, `queue: max`. The checkout is the tip of `main` that the event saw, with all the history and the submodule, and the commit on which CI passed is named only by its SHA (R12). The number is computed by the recipe `release-version` of `spec` in the `toolchain` stage, and the script of `spec` runs it from the submodule: `spec/tools/toolchain/toolchain.sh spec release-version <commit> .github/workflows/self-release.yml` (the amendment to R10). The script runs from the copy of the checkout in `RUNNER_TEMP`, and the runner's `git` reads only the checkout itself, which no container mounts (2.12). It reads the line from this file at the commit being released, and for a commit older than the file, from the file of the tip, which it sees in the copy of the checkout (T17; the amendment to R31 spec). A release comes out if a shared workflow, a shared action of `.github/actions/` (R49) or the tool has changed, and `gh release verify` checks it. A refusal 404 or 403 "Resource not accessible by integration" is let pass only if the commit is no longer the tip of `main`, lies in its history and adds or changes files of `.github/workflows/` relative to it: the release of the tip will cover its edit (sources 3.2 and 12.1). This is decided by the recipe `release-refusal` of `spec` — one copy of the rule for both releases (T17). The recipe runs only after a refusal, so on every run the step of the number tries its call without running it, `toolchain.sh spec --dry-run`: otherwise a tag of `spec` that renames the recipe or changes the number of its parameters would surface only on a rare refusal, and would make red the very run that the refusal is to let pass (T17; sources 11.4; measurements 5.1). What sets it apart on purpose from the `release.yml` of `spec` after the amendment to R31 spec is this. A release comes out only if a shared workflow has changed, and every release is Latest (R10). A tag without a release is checked for the previous release too (R10). The commit of CI must be a full SHA and an ancestor of the checkout (R12) — `spec` has no such checks. Nor does it have the trial of the call: there one edit changes both the recipe and its call;
- `self-codeql.yml`, `name: CodeQL` — on a pull request and on a push to `main`; `self-scorecard.yml`, `name: Scorecard` — on a push to `main` and once a week. Both call the shared ones by the local path, and `.github` names the language `go` besides `actions`: its code is the tool `tools/coderules/` (the 2026-11-08 amendment to R09, R33); `.sonarcloud.properties` is as in 3.3, and so is `dependabot.yml` but for `github-actions`, which reads `/` and `/.github/actions/toolchain` and groups by `group-by: dependency-name`, so that one pull request moves an action in both (R49).

The ruleset of `main` lets into `main` only a pull request with green required checks — their list is in R11. Besides, a pull request must have no findings of CodeQL of the level `high` and above, and no errors, and it is merged only by a merge commit (R12). The ruleset `v-tags` holds the tags of releases (R10).

### 3.5. Versions and updates

By R04 and R10:
- **a release of `.github`** comes out by itself after a green CI on `main`, as in R31 spec, but only for a commit that, since the previous release, changes a shared workflow — a file of `.github/workflows/` without the prefix `self-` —, a shared action — a folder of `.github/actions/` (R49) — or the tool `tools/coderules/`, which `go.yml` builds at its own version (R33); the first release always comes out. `git diff` finds the edit, and an edit of comments alone is an edit too: the references of the comments of `go.yml`, `release.yml` and `scorecard.yml`, which T55 pointed at the records, will be released after the merge as `v0.1.23` (the 2026-11-12 amendment to R38). The number is the next patch of the line `RELEASE_LINE` from `self-release.yml`, now `0.1`. It is computed by the recipe `release-version` from the submodule's `spec/justfile` by the tags of `.github`, and run by the script `spec/tools/toolchain/toolchain.sh` from the copy of the checkout (T25, T28). The recipe reads the line from the `self-release.yml` of the commit being released (T17). Before T13 the number was computed by the functions `readLine`, `readTags` and `nextVersion` from `spec/tools/release/version.mjs`, and before T17 the line was taken from the tip. Every release is Latest, immutable, with an attestation, and the tags `v*` are under the ruleset `v-tags`;
- **the callers** pin a shared workflow, and the composite action `toolchain` (R49), by a SHA, with a comment of the version on the same line. Their Dependabot raises both the SHA and the comment if the commit has a tag (sources 4.1). It raises all the references to `.github` in one pull request — by the group `shared-workflows` of the template of 3.3 (the 2026-11-08 amendment to R04);
- **actions inside the shared workflows** and the composite action are pinned the same way, and the Dependabot of `.github` itself raises them, in both by one pull request (R49). A merged update comes out as a release, and after it the callers' Dependabot raises the reference;
- **the `cooldown` pause** is three days for each ecosystem of Dependabot, at `.github` and at the callers, `github-actions` among them, which raises the references to `.github`: an error of a release must have time to be found before twelve pull requests spread it. The pause does not hold the base image of the devcontainer: Microsoft's registry does not give the date of a release, and Dependabot offered the new image at once — at `spec` and at canvas-api (T15 spec). It holds the references to a reusable workflow, as it holds actions. The count starts from the date of the commit under the release's tag, to the day, because a release's tag is lightweight (2.6, 2.10; sources 4.2);
- **the tools that Dependabot does not see** — gitleaks, actionlint, shellcheck, yq of the suite of tests (R28), cosign and Node with its npm for the step of publishing, and the CLI of Codecov of the wrappers, with the sha256 sums of their archives — are raised by hand, as an `ARG` in the Dockerfile of `spec` (R30 spec; the amendments to R16 and R18). The CLI of Codecov is raised in `go.yml` and `typescript.yml` together: a case of the suite keeps its version and sum the same in both (R28), and the sum is checked against the signed `codecov.SHA256SUM` of its release (sources 10.3);
- **pinning by a SHA** is held by the rule Exact versions: the organization's requirement to pin by a SHA does not apply to a reference to a reusable workflow (sources 3.3).

### 3.6. Secrets and forks

By R05 — for all repositories `spec` recorded its rule by the amendment to R24 spec:
- a shared workflow takes no secrets: its `workflow_call` has no `secrets`, and the caller does not pass `secrets: inherit`. It has only `GITHUB_TOKEN` with the permissions that the caller gave, and a short-lived OIDC token if the caller gave `id-token: write`: cosign signs with it, npm exchanges it for a publishing token (the amendment to R18), and Codecov accepts the upload of the coverage by it (the 2026-11-01 amendments to R16 and R19). Neither is a secret;
- `pull_request_target` is used nowhere; `workflow_run` does not take the code of a pull request with secrets or with write access, as at the release of `spec` (R31 spec);
- a repository's own job with a secret runs only on a push to `main` and on a pull request from a branch of the repository itself. A pull request from a fork passes the shared checks without secrets;
- on a pull request from a fork such a job is not skipped, but fails and names the reason. A skipped job counts as a success for a required check and does not hold the merge (sources 2.4), and a failed one holds it until the edit is moved to a branch of the repository;
- a pull request of Dependabot comes from a branch of the repository, but gets no secrets of Actions — only the secrets of Dependabot (sources 2.4). How a job with a secret treats it is decided together with that job, and for eval in Т-28;
- where the key for eval lies is Т-28: an environment secret in the repositories with eval, or Secret Manager of `infra` through Workload Identity Federation; it is decided with eval at stage 2. The question itself was opened by R24 spec.

### 3.7. The composite action `toolchain`

By R49, T69; from the release `v0.1.32` (T72), and with the Go caches by the prefix from `v0.1.33` (T75), which the text below pins. `.github/actions/toolchain/action.yml`, "Toolchain image and Go caches", is for a job of the caller's own that runs Go in its stage `toolchain`, as "Binaries / build" of `module-kit` does (row 3.11 of COORDINATION.md spec). Its inputs: `check` — the word the key of the Go caches names the job by, its own, as `binaries`, never one of `go.yml`'s checks, `lint`, `test`, `vuln`, `licenses`, `target-<target>`, `fma-diff`, `arm64` or `rules`, whose entry it would share —, and `save`, `"false"` by default. The job calls it twice with the same `check`:
- before its work, without `save`: the image `novatrail-toolchain` of the stage `toolchain` from the entry `toolchain-<OS>-<architecture>-<hash of the Dockerfile>`, or built from `.devcontainer/Dockerfile` and, on a push to `main` alone, saved at once (R36, R42); then the folder `${{ runner.temp }}/go-cache` from the entry `go-<OS>-<architecture>-<check>-<hash of the Dockerfile>-<hash of **/go.sum>`, checked by `go mod verify` in every module of the caller, or on its miss the newest entry of the key without `go.sum`, without its modules, or empty (R41 and its 2026-11-18 amendment);
- after its work, with `save: "true"`: it reads the key the first call asked for and whether it hit, from `${{ runner.temp }}/novatrail-go-cache.key`, and on a miss, on a push to `main` alone, saves the folder by it. A job whose work failed does not reach it.

The calls refuse, each with its reason: a `save` other than `true` or `false`; a `check` other than a word of letters, digits, `.`, `_` and `-`; a call without `save` in a job that has taken the caches by it already, as two would share one key file; a call with `save` without one before it.

The job checks out its tree before the first call and runs on `ubuntu-24.04` or `ubuntu-24.04-arm`; each `docker run` of its work mounts the folder and points Go into it, by the lines of the action's header comment: `--env GOMODCACHE=/go-cache/mod --env GOCACHE=/go-cache/build --env GOLANGCI_LINT_CACHE=/go-cache/lint` and `--volume "$RUNNER_TEMP/go-cache:/go-cache"`. The file, the image, the folder and the keys are those of `go.yml`, so the entries are the ones its jobs fill and read, and `go.yml`'s `arm64` takes the action itself, by `$/` (sources 2.12): the steps are one file, and a move of `.github` that changes them reaches the caller with the SHA its Dependabot raises. The suite holds the action's scripts and the SHA of `actions/cache` to those of `go.yml`'s other jobs (R28), and `self-ci.yml` runs the action as a caller's job does and hands ShellCheck its scripts (3.4). In the caller's workflow, by the SHA and the version of the release that the workflows of 3.3 are pinned to — the group `shared-workflows` of its `dependabot.yml` moves them all at once (R04):

```yaml
    steps:
      - uses: actions/checkout@<sha> # v7.0.1
        with:
          persist-credentials: false

      - name: Toolchain image and Go caches
        uses: altnovatrail/.github/.github/actions/toolchain@f1c7e9e6f8245fdbdbc23c4091f3c26350e3a44e # v0.1.33
        with:
          check: binaries

      - name: The work
        run: |
          docker run --rm --user "$(id -u):$(id -g)" --env HOME=/tmp \
              --env GOMODCACHE=/go-cache/mod --env GOCACHE=/go-cache/build --env GOLANGCI_LINT_CACHE=/go-cache/lint \
              --volume "$PWD:/work" --volume "$RUNNER_TEMP/go-cache:/go-cache" --workdir /work \
              novatrail-toolchain just <recipe>

      - name: Go caches into the cache
        uses: altnovatrail/.github/.github/actions/toolchain@f1c7e9e6f8245fdbdbc23c4091f3c26350e3a44e # v0.1.33
        with:
          check: binaries
          save: "true"
```

## 4. Sources and measurements

The records of external facts are in [sources.md](sources.md), and the results of measurements in [measurements.md](measurements.md); they are not here (RULES.md spec, The bar; R143 spec). The section stays while the log and the archives `docs/plan/` cite it, and those are not rewritten. Until 2026-11-12 it held groups — by decision and date of reading —, and T55 sorted them out by source. A reference of the log to "architecture 4" or to a group by its name leads here, and the table leads to the records of the group:

| Group | Decision, read | Where it went |
|---|---|---|
| "Reusable workflows" | R03, 2026-10-19 | sources 2.1, 2.2 and 14.2 |
| «Закрепление по SHA и Dependabot» | R04, 2026-10-19 | sources 3.3 and 4.1 |
| "CodeQL" | R03, 2026-10-19 | sources 5.1 and 5.2 |
| "Scorecard" | R03; architecture 2.2, 2026-10-19 | sources 6.1 |
| «Секреты и форки» | R05, 2026-10-19 | sources 2.4 |
| "gitleaks" | R03, 2026-10-19 | sources 11.1 |
| «CodeQL и Scorecard» | R09, 2026-10-20 | sources 2.9, 3.1, 5.1, 5.2, 6.3 and 14.1; measurements 1.1 |
| «Релиз `.github`» | R10, 2026-10-20 | sources 2.2, 2.3, 3.1, 3.2, 3.3, 6.2 and 12.1 |
| «Ответы на вопросы E2» | R12; the amendment to R10, 2026-10-20 | sources 2.2, 2.7, 3.1, 4.1, 4.2, 6.2 and 8.1 |
| «Исключения CodeQL» | the amendment to R09, T14, 2026-10-20 | sources 5.1, 5.2 and 5.3; measurements 1.2 |
| «Интерфейс релиза `spec` и суммы архивов» | R14, 2026-10-20 | sources 11.4 and 12.1; measurements 5.1 |
| «Общий релиз» | R18, 2026-10-21 | sources 2.2 and 7.1; measurements 5.2 |
| «Обёртка Go» | R16, 2026-10-21 | sources 10.2, 12.2 and 14.1; measurements 2.1 |
| «Обёртка TypeScript» | R19, 2026-10-21 | sources 2.2, 2.6, 8.1, 9.2, 9.3, 9.4, 9.5, 9.6, 12.2 and 14.1; measurements 3.1 |
| «Первый код `canvas`» | the amendment to R19, 2026-10-21 | sources 4.2, 9.2 and 13.4; measurements 3.2 |
| «Скрипт `spec` в релизах» | the amendments to R10 and R18, T25, 2026-10-22 | sources 2.5, 7.1 and 12.2; measurements 5.3 |
| «Копия checkout» | the amendments to R10 and R18, T28, 2026-10-22 | sources 2.7 and 11.5; measurements 5.4 |
| «Рецепты лицензий `spec`» | R22, the amendments to R16 and R19, T26, 2026-10-22 | sources 2.3, 2.7, 12.3 and 13.4; measurements 3.3 |
| «Без копии списка в `typescript.yml`» | the amendment to R19, T29, 2026-10-22 | sources 13.3 and 13.4; measurements 3.4 |
| «Публикация в npm» | the amendment to R18, T27, 2026-10-22 | sources 2.5, 8.1, 8.2, 8.3, 8.4, 9.1 and 13.2; measurements 5.5 |
| «Переход на `spec` v0.4.1» | R25, T31, 2026-11-01 | sources 4.3, 8.1, 8.3, 8.4, 12.4, 13.1 and 13.2; measurements 2.2 |
| «Переход на `spec` v0.5.3» | R27, T36, 2026-11-01 | sources 12.5 |
| «Переход на `spec` v0.6.2» | R30, T38, 2026-11-01 and 2026-11-02 | sources 12.6, 13.1 and 13.2; measurements 5.8 |
| «Подпись на повторе общего релиза» | the 2026-11-02 amendment to R18, T39, 2026-11-02 | sources 12.6; measurements 5.7 |
| «Переход на `spec` v0.6.3» | R31, T40, 2026-11-02 | sources 8.3 and 12.7; measurements 5.8 |
| «Файл прошлого релиза» | the 2026-11-02 amendment to R18, T41, 2026-11-02 | sources 12.7; measurements 5.1 and 5.9 |
| «Номер пакета, снятого целиком, и сверка долгов» | the 2026-11-02 amendment to R18, T42, 2026-11-02 | sources 8.1, 8.3, 8.4, 12.7, 13.1 and 13.2; measurements 5.10 |
| «Переход на `spec` v0.9.8» | R32, T43, 2026-11-08 | sources 12.8, 13.1 and 13.2; measurements 5.8 |
| «Ожидание реестра в шаге npm» | the 2026-11-08 amendment to R18, T44, 2026-11-08 | sources 12.8; measurements 5.11 |
| «Группа Dependabot и перечень typescript» | the 2026-11-08 amendment to R04, T45, 2026-11-08 | sources 4.1, 4.2 and 13.4 |
| «Вход `same-bits` `go.yml`» | the 2026-11-08 amendment to R16, T46, 2026-11-08 | sources 13.5; measurements 2.3 |
| «Job `arm64` `go.yml`» | the 2026-11-08 amendment to R16, T47, 2026-11-08 | sources 2.6 and 13.5; measurements 2.4 |
| «Инструмент правил кода» | R33, T48, 2026-11-08 | sources 2.2 and 13.5; measurements 2.5 |
| «`documents.yml` скриптом `spec`» | the 2026-11-08 amendment to R08, 2026-11-08 | sources 12.8 and 13.1; measurements 6.2 |
| «Переход на `spec` v0.9.9» | R34, T51, 2026-11-08 | sources 12.9; measurements 9.1 |
| «Переход на `spec` v0.12.0» | R35, 2026-11-09 | sources 12.10; measurements 9.1 |
| «Кеш образа стадии `toolchain`» | R36, T52, 2026-11-09 | sources 2.8 and 13.4; measurements 7.1 |
| «Переход на `spec` v0.13.0» | R37, 2026-11-10 | sources 12.11; measurements 9.1 |
| «Кеш образа в `documents.yml`» | the 2026-11-10 amendment to R36, T53, 2026-11-10 | sources 12.11; measurements 7.2 |
| «Переход на `spec` v0.16.3» | R38, T54, 2026-11-12 | sources 12.12 and 13.1; measurements 9.1 |
| «Набор тестов шагов» | R28, T35, 2026-11-01 | sources 2.2, 2.3, 2.6, 3.2 and 11.3; measurements 6.1 |
| «Снятый номер в шаге npm» | the 2026-11-01 amendment to R18, T33, 2026-11-01 | sources 8.1, 8.2 and 8.3; measurements 5.6 |
| «Шаблоны issue и pull request» | R29, T37, 2026-11-01 | sources 3.4; measurements 8.1 |
| «Загрузка покрытия» | the 2026-11-01 amendments to R16 and R19, T34, 2026-11-01 | sources 2.1, 2.9, 9.3, 10.1, 10.3 and 13.3; measurements 4.1 |
| «Go в CodeQL» | the amendment to R09, T19, 2026-10-21 | sources 5.1 and 5.3; measurements 1.3 |
| «Инструменты общих проверок» | R08, 2026-10-20 | sources 2.7, 11.1 and 11.2; measurements 1.4 |
| «Подпись без ключей из reusable workflow» | architecture 2.3, 2026-10-19 | sources 2.5 and 7.2 |
| "canvas-api" | R03, 2026-10-19 | sources 14.1 |
