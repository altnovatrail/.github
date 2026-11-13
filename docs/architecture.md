# .github — architecture

> Status: 2026-11-13, the epics E1 (T01–T05), E2 (T06–T10), E4 (T11), E3 (T12–T20), E5 (T21–T23), E6 (T24–T26, T28 and T29), E7 (T27), E8 (T30), E9 (T31–T37), E10 (T38 and T39), E11 (T40–T42), E12 (T43), E13 (T44 and T45) and E14 (T46–T48) are done, and their tasks are in the archives `docs/plan/`; the tasks of E15 were deleted. T51, with no epic, moved `.github` to `spec` v0.9.9, where the card 3.11 spec names the input `same-bits` and the tool `tools/coderules/`, and closed В36 (R34); and on 2026-11-09 `.github` moved to v0.12.0 with no epic and no task (R35): the cache of the image of the `toolchain` stage in the shared workflows, which the tag gives to `.github`, is the epic E17 (row 2.4 of COORDINATION.md `spec`; Д146 in RUN.md `spec`), and it is done: the release `v0.1.22`, its tasks in the archive `docs/plan/E17.md`. In it T52 gave the cache to `go.yml` and `typescript.yml` on the branch `e17` (R36); on 2026-11-10 `.github` moved, with no task, to v0.13.0, which has T104 `spec`, the cache in `toolchain.sh` (R37); and T53 gave the cache to `documents.yml` and to the repository's own job "Workflows" of `self-ci.yml` (the 2026-11-10 amendment to R36). E18, the saving of tokens by row 7.2 of COORDINATION.md `spec`: T54 moved `.github` to `spec` v0.16.3 and took the way of work of E10 `spec` — one task per session, the rules of the parts and `DEBT.md` (R38); T55 moved the "Sources" and the measurements to [sources.md](sources.md) and [measurements.md](measurements.md) and left a pointer in place of section 4; T56 translated this document, sources and measurements into English; and T57 translated the log and put the budgets of size in `docs-budgets.json` (the 2026-11-13 amendment to R38); E18 is done, its tasks in the archive `docs/plan/E18.md`. E19, the caller's tests on wasip1 in the shared `go.yml` (Д213 spec): T58 runs them by `go test -exec` with an executor on `node:wasi` in "Go / targets" and "Go / arm64" (R39), the release `v0.1.24`; E19 is done, its task in the archive `docs/plan/E19.md`. E15 closed Д5 — `documents.yml` runs the documents check by `spec`'s script (the 2026-11-08 amendment to R08) — and removed the history from RUN.md. In E14 the checks of the same bits of `learner-model` and `engine` became the input `same-bits` of the shared `go.yml` (T46, T47), and their test of the rules of code became a shared tool of `.github`, `tools/coderules/`, the first Go code of `.github`'s own (T48; R33; R107 spec). In E13 the npm step of the shared release came to wait up to 20 minutes for the version and its archive (T44; the 2026-11-08 amendment to R18), and the templates of 3.3 got a Dependabot group and the list of the kind typescript (T45; the 2026-11-08 amendment to R04). In E12 T43 moved `.github` to `spec` v0.9.8 (R32). The devcontainer got buf, as `spec` has it, the template of 3.3 got the `paths` list of the kind modules, and CONTRIBUTING.md got the eval-set organizer. The first publication of `canvas` by the npm step of the shared release went through with provenance, and Д7 is closed (the 2026-11-08 amendment to R18). In E11 T40 moved `.github` to `spec` v0.6.3 (R31), where Т-35 is closed by the 2026-11-02 amendment to R63 spec. T41 gave the shared release the input `previous-file`: it downloads the file of the previous release and checks it before the build, and hands it to the recipe `release-files` as its second argument (the 2026-11-02 amendment to R18; 3.1, 3.3). T42 took into the npm step the check of `time.unpublished.versions` of `spec`'s step, so that the copies of the step match. The premise of В34 — that without it the number of a package unpublished whole is not found — proved wrong (the 2026-11-02 amendment to R18). In E10 T38 moved `.github` to `spec` v0.6.2 (R30), where Т-27 is closed: R77 spec decided what a check of the signature verifies. T39 moved the rerun path of the shared release to the recipe `release-verify`, and a run that publishes stops first thing if the caller's workflow is not its `release.yml` on `main` or if the shared `release.yml` is pinned otherwise than by a SHA of its own path (the 2026-11-02 amendment to R18; 2.3). In E9 T31 moved `.github` to `spec` v0.4.1 (R25), and T36 to v0.5.3, with the answer to В28 (R27); T32 gave SECURITY.md a deadline for the first reply (R26), and T35 gave the suite of tests of the steps of the shared workflows (2.13; R28). T33 came with its own cases in it: the npm step of the shared release refuses a number that npm has already given out, and a package unpublished whole (the amendment to R18). T34 in [RUN.md](../RUN.md) came the same way: the Go and TypeScript wrappers send the caller's test coverage to Codecov by OIDC (the 2026-11-01 amendments to R16 and R19; 3.3, "Coverage"). Both releases of `.github` run `spec`'s recipes by `spec`'s script (T25) in the copy of the checkout (T28; the amendments to R10 and R18), and T26 took the license recipes (the amendments to R16 and R19). Since T29 `typescript.yml` has no copy of the list of its own: Д6 is closed. E7 is the publishing to npm in the shared release: the step exists since T27 (the amendment to R18), and the first real publication is `@altnovatrail/canvas` 0.1.1 from the release `canvas` v0.1.1, 2026-11-02 (sources 13.2). The TypeScript wrapper was checked by the first code of `canvas`, T08 canvas, and its checks stand in its ruleset of `main`. The point that the card left to the detailing is decided — the shared workflows and a repository's own (R03–R05, section 3). What is still open is section 2: 2.7 is decided for the license list too (R16); 2.2 is decided, both steps passed (R09, R13); for 2.8 the call works, and Dependabot raises the reference (Д10 in RUN.md `spec`); 2.3 — the signing is decided (R18) and checked on the first release of `module-kit`, and R77 spec decided what the consumer checks (R30); 2.10 is decided (R23); 2.11 is decided by the 2026-11-01 amendment to R22 spec, and T37 wrote the templates (R29); 2.12 is decided and done (T28), and with the amendment to R31 spec the release of `spec` is built the same way; 2.13 is decided (R28) and done (T35). The shared checks — secrets, DCO, documents, CodeQL and Scorecard — and the release of `.github` exist, and the first release is `v0.1.0` (R10). `main` is under a ruleset (R11): CodeQL findings hold the merge, and a pull request merges into `main` only by a merge commit (R12). The texts of the calling files are section 3.3. The Go wrapper is `go.yml` (R16), the shared release is `release.yml` (R18), the TypeScript wrapper is `typescript.yml` (R19).
>
> What the component does, what it does not do, and what is still to be decided about it. This is the detail of its card, architecture 3.11 spec. The card stays the summary: if the detail changes what the card says, the card is changed in `spec` by the same route as the questions to its registers (RULES.md, Across repositories).
>
> Why it was decided so and not otherwise is in [decisions.md](decisions.md); the work plan is in [RUN.md](../RUN.md). The records of the external facts that the claims stand on are in [sources.md](sources.md), and the results of measurements are in [measurements.md](measurements.md): a claim cites its record, `sources 2.1` or `measurements 1.1`. The concepts are concepts spec. The documents and decisions of `spec` are in `spec/docs/` and are cited with the suffix "spec".

## 1. Purpose and bounds

**Does:**
- keeps the organization's profile, `profile/README.md`. GitHub shows it on the page github.com/altnovatrail (architecture 3.11 spec);
- keeps the default community health files — CONTRIBUTING, SECURITY and the code of conduct — and with them the issue and pull request templates: the issue forms "Bug report" and "Change proposal", a template chooser with no blank issue, and a pull request template with a checklist (the 2026-11-01 amendment to R22 spec; R29). GitHub shows them in every repository of the organization that has none of its own, if `.github` is public; all the repositories of the organization are public too (architecture 3.11 spec, architecture 8 spec; R18 spec; R22 spec);
- gets the shared workflows of CI, with actions pinned by a SHA (architecture 3.11 spec; R03, section 3.1):
  - the shared checks — the secrets scan, DCO, CodeQL, Scorecard and the documents check. Every repository takes them, `spec` too, even before its code (repositories 1, 2.1 spec; R30 spec); `spec` has its own documents check, `just docs-check`. Scorecard is shared: the Scorecard server accepted the result of a shared workflow (2.2; architecture 3.11 spec). T17 `spec` connected them in `spec` and `module-kit`, T16 `spec` in `tutor`, and T21 `spec` in the nine others, after each moved to a tag of `spec`. So `spec` and all eleven component repositories call them (the amendment to R30 spec);
  - for code — Go and TypeScript, wrappers over the repository's recipes with the license check inside, and the release with a signature. Each comes with the code it is checked on: the Go wrapper and the release with the first code of `module-kit`, where the code of the platform begins, and the TypeScript wrapper with the first code in TypeScript, at `canvas` (R03; architecture 3.11 spec; repositories 6 spec). The wrappers take the license list and the check of the npm lock file as `spec`'s recipes (R39 spec; T26), and the release calls `spec`'s release recipes by its script `tools/toolchain/toolchain.sh` (the amendment to R31 spec; T25). `spec` cannot call the shared release — that one takes the recipes from the caller's `spec` submodule — and its `release.yml` is its own: it signs the files with the same keyless cosign and publishes the types package `@altnovatrail/spec` to npm by the steps of the shared release, carried over into it; and since T50 `spec`, `spec` calls the shared Go wrapper as any repository in Go does — the job "Go" with its own recipes `ci-*` (architecture 3.11 spec; R64 spec; the second 2026-10-29 amendment to R37 spec; the 2026-11-01 amendment to R30 spec);
- the shared workflow of the release signs module packages too. R77 spec decided what the consumer checks of the signature, and one recipe of `spec`, `release-verify`, checks it, where the file enters NovaTrail. The library of `module-kit` checks no signatures: it checks a package by the chain of digests from the index that a pull request of `api` pinned (architecture 3.7, 3.11 spec; the 2026-11-01 amendment to R17 spec; R30). The same workflow publishes the UI package from the signed release to npm, in the scope `@altnovatrail`, as the same file, through trusted publishing, when the caller has named the package by the input `npm-package` (R37 spec; the amendment to R18, T27).

**Does not:**
- does not stand in for the files that a repository has of its own: GitHub takes a default file only when there is none of the repository's own (R22 spec). With issue templates it is stricter: a form or a `config.yml` of the repository's own in its `.github/ISSUE_TEMPLATE` drops all the shared ones, so a repository sets up no templates of its own (the 2026-11-01 amendment to R22 spec);
- does not give the license for other repositories: there is no default LICENSE, and each repository has its own (R20 spec; R22 spec);
- does not repeat the rules: CONTRIBUTING leads to `RULES.md` and the repository's CLAUDE.md, and a copy would drift from them (R21 spec; R22 spec);
- holds no code of the platform: while the platform runs nobody calls `.github`, and the overall diagram does not have it (architecture 2 spec). It has one Go code of its own — the CI tool `tools/coderules/`, the test of the rules of code that the shared `go.yml` with `same-bits` runs on the caller's code (R33; R107 spec). The same `go.yml` checks it, and its coverage goes to Codecov.

**Data and links:**
- no learners' data and no secrets, as in no repository (RULES.md, Hard rules);
- at build time it depends on nothing but `spec`, like all (repositories 2.1 spec);
- every repository will take the shared checks of CI, `spec` too, even before code (repositories 1, 2.1, 3 spec; R30 spec). Into a repository made from the repository template of spec, the language checks, the justfile and the signed releases come with its code (repositories 1 spec). `spec` and `module-kit` were the first to connect the shared workflows (T17 `spec`), `tutor` after them (T16 `spec`), and then the nine others (T21 `spec`);
- its services are GitHub and Sigstore: CI, releases, keyless signing — the npm registry, where the shared release publishes the UI packages, and Codecov, where the Go and TypeScript wrappers send the caller's test coverage, by OIDC (architecture 3.12 spec; R37 spec, R48 spec; the 2026-11-01 amendments to R16 and R19). The README badges take their images from shields.io, the Scorecard API and SonarCloud (R48 spec; R25). `.github` has no coverage badge: it has no code of its own that Codecov would measure (2.13);
- stage 0, together with `spec` (repositories 2.1 spec).

## 2. To decide when detailed

The points "To decide when detailed" of the card, a subsection per point, and the gaps found on the way. Each point names where it will be decided: a task in [RUN.md](../RUN.md) or the epic that will bring it. A decided point names the entry of the log, and the decision itself moves to section 3. A question that goes beyond this repository goes «в реестр spec» (RULES.md, Across repositories).

### 2.1. Shared workflows and a repository's own

- **Gist:** which CI workflows live in `.github` and are called by all repositories, and which each repository has of its own — the point "To decide when detailed" of the card (architecture 3.11 spec).
- **Decided:** R03, R04 and R05, the task T01. The design is section 3.

### 2.2. Scorecard from a shared workflow

- **Gist:** Scorecard with the publishing of its results puts restrictions on the workflow that runs it, and the Scorecard server may reject the result (sources 6.1). The server accepts a reusable workflow, but by which file it checks the restrictions — the calling one or the shared one — is not said.
- **What is known:**
  - the server checks the branch by the calling repository (scorecard-webapp, PR #778), and it supports Scorecard in a reusable workflow — this speaks for its checking the restrictions by the shared file. This is not said directly;
  - the shared `scorecard.yml` keeps the restrictions. The calling file cannot keep them: its job has `uses:` of the shared workflow instead of steps, and `id-token: write`, while "Only the job with `ossf/scorecard-action` can use `id-token: write` permissions" (sources 6.1). If the server checks the calling file, it will reject the result, and a fallback is needed.
- **How it will be decided:** in two steps. The first is a run of `self-scorecard.yml` in the epic E2: its job too has `uses:` and `id-token: write`, so if the server checks the calling file, it will reject this very result — whether it is accepted, the epic itself checks. The second is the first call from another repository by the full path, as for 2.8: the check of the branch by the caller (PR #778) concerns exactly such a call. A green job proves nothing: when the server refuses, scorecard-action v2.5.0 only warns and returns success, and the input `fail_on_publish_error`, which fails the step, is not yet in v2.5.0 (sources 6.1; T17 `spec` recorded the same). Whether the result is accepted is seen only on the Scorecard server; with a release that has the input, it is worth turning it on. If the server rejects it — the fallback of R03: an identical copy of `scorecard.yml` in each repository.
- **The first step passed** on 2026-10-20 (the amendment to R09): the Scorecard API gives the result of `self-scorecard.yml` for the commit of `main` 53b829f, score 5.4, and the log of the run warns of no refusal. The server accepted the calling file with `uses:` and `id-token: write`.
- **The second step passed** on 2026-10-20, in T17 `spec`: the server accepted the result of the shared `scorecard.yml` called from another repository. The Scorecard API gives the results of `spec` and `module-kit`, and then of `tutor` too, and the logs of the runs have no warning of a refusal (RUN.md `spec`, T17 and T16). As of 2026-10-20 these are `spec` 5eafb1a — 6.7, `module-kit` 254452e — 6.3 and `tutor` 6e04f80 — 6.3 (the Scorecard API). A copy in each repository is not needed.
- **Decided:** Scorecard is the shared `scorecard.yml` (R03, R09), both steps passed (the amendment to R09, R13). The tasks are T08 and T17 `spec`.

### 2.3. The signature of the shared release: whose identity

- **Gist:** keyless signing from the shared workflow of the release will get the identity of the workflow that makes the signature. A check of the signature, like R52 canvas-api, checks the exact identity `release.yml@refs/heads/main` of the calling repository, and for the shared release that identity will be different.
- **What is known:** the Sigstore certificate for a job from a reusable workflow names the shared workflow as its identity (SAN), and carries the calling workflow and its repository in its extensions — Build Config URI and Source Repository URI (sources 2.5 and 7.2). The signature of a package is checked by `module-kit` (architecture 3.7 spec; R17 spec), and the image and the builds by `infra` (Т-19).
- **How it will be decided:** with the first release of `module-kit` (E2 `spec`), together with the shared workflow of the release: what exactly `module-kit` and `infra` check — the identity of the shared workflow, the caller's repository and workflow, or both. The caller pins the shared workflow by a SHA (R04), so the SAN ends with `@<sha>`, not with a tag, and the check must make sure that this SHA is a release of `.github`. The options and the recommendation are Т-27: `spec` recorded the question and the recommendation of `.github` — to check both, the SAN by the SHA of one of the releases of `.github`.
- **Decided:** R18, the task T16 — the signature and its check by the release itself. Each file is signed by keyless cosign, and before publishing the bundle is checked against the identity of the shared `release.yml`, `https://github.com/<job.workflow_ref>`, and against the caller's repository. The trial #33 showed that the SAN names the shared `release.yml`, and the Build Config URI the caller's workflow (measurements 5.2). The first release of `module-kit`, `v0.1.0`, is signed the same way, and the check of its files passed (measurements 5.2). What the consumer checks remains Т-27.
- **Task:** the epic E3, with the first release of `module-kit`; the question itself is Т-27, decided together with `module-kit` and `infra`, which check the signature. In `spec` it is decided by T37 `spec` — after T16 of this repository and the first release of `module-kit`. The same task will decide where the checker takes the list of releases of `.github` from (RUN.md `spec`, T37).
- **Added in Т-27** (2026-10-22, by В23; R25): the SHA of a release of `.github` in the SAN does not pin all the code that ran with the right to sign. The shared release runs `spec`'s script on the runner, from the caller's submodule (the amendment to R18), so the condition of the check is also the immutable releases of `spec` with the ruleset of its tags `v*`. Which of this the consumer checks is decided by the same T37 `spec`.
- **Decided in `spec`** (R77 spec, 2026-11-01; here R30, T38): Т-27 is closed — both are checked.
  - A file of the shared release passes only if the SAN and the Build Signer URI are the shared `release.yml` at the SHA of a commit of a release of `.github` no lower than v0.1.7, on the history of its `main`, and not on a branch or a tag. The certificate must name as the caller the repository's `release.yml` on `main`, the commit of the tag and the numeric IDs of the repository and the organization.
  - The check reads the list of releases of `.github` from GitHub through git, without a token. Its condition is immutable releases and a ruleset of tags `v*` at `.github`, `spec` and each releasing repository (3.3). It trusts the tags of `spec` under the same condition: this is the answer to the addition above.
  - A single recipe of `spec`, `release-verify`, checks it, where the file enters NovaTrail. The library of `module-kit` checks no signatures.
  - The signature of a file that came out, as the consumer checks it, is checked at `.github` in one place — the rerun path of the shared release (R18). It diverges from the rule: its regexp lets in a SAN with any SHA, branch or tag of `.github`. T39 in [RUN.md](../RUN.md) corrects it — by the recipe `release-verify`, by the author's decision when planning E10.
  - "Sign every file" before publishing checks the signature of its run against the identity `job.workflow_ref` — that by which the caller pinned the shared `release.yml`. Pinning by a branch or a tag would give files that the rule rejects, and the release itself does not guard against it — В31 in [RUN.md](../RUN.md).
- **Done in T39** (the 2026-11-02 amendment to R18): the rerun path checks the signature by the recipe `release-verify` from the caller's `spec` submodule, and it no longer needs cosign. A run that publishes stops first thing if the caller's workflow is not its `.github/workflows/release.yml` on `main`, or if the shared `release.yml` is pinned otherwise than by its own path at a SHA. The latter is the author's answer to В31: the shared release checks the form of the SHA as a string, and whether it is a release of `.github` no lower than v0.1.7 is checked by the recipe at the consumer.

### 2.4. Which commits of `main` get a release

- **Gist:** R04 puts out the shared workflows in releases, as R31 spec does. But `spec` releases every green commit of `main`, and `.github` has commits that do not touch the shared workflows: the profile, the community health files, its own `self-` workflows, the documents.
- **Decided:** R10, the task T09: a release goes to a commit that changes a shared workflow since the previous release, and the first release always comes out. The design is section 3.5.

### 2.5. How `.github` counts the release number

- **Gist:** at `spec` the number is counted by `tools/release/version.mjs` with tests, and the recipe `release-version` feeds it three lists of tags `v*`: all the tags, the tags from the history of the commit being released, and the tags on that commit itself. The commit is the recipe's argument, `HEAD` by default (the justfile of `spec`; R31 spec). `.github` has no code of its own.
- **Decided:** R10, the task T09: the functions of `version.mjs` from the submodule, and the line `0.1` in `self-release.yml` itself. Since T13 the number is counted by `spec`'s recipe `release-version` itself, and since T17 by its interface for other repositories: the recipe reads the line from `self-release.yml` of the commit being released (the amendment to R31 spec; the amendments to R10 and R12). The design is section 3.5.

### 2.6. The `cooldown` pause for references to `.github`

- **Gist:** Dependabot waits three days after a version comes out before it proposes the version — so `dependabot.yml` of `spec` says for each ecosystem (R30 spec). It raises the references to the shared workflows in the same ecosystem `github-actions`; the documentation does not say separately that the pause acts on them too.
- **Decided:** R10, the task T09: three days, as for everything. The design is sections 3.3 and 3.5. The pause holds the references to `.github` too. For dependabot-core a reference to a reusable workflow is a dependency of the ecosystem `github-actions`, and the same code checks the pause for it as for an action (the amendment to R10, the task T11; sources 4.2). The count runs from the date of the tag, to the day, and the tag of a GitHub release is lightweight, and its date is the date of the commit. So after a release that came out minutes after the merge, the pause lasts from two to three days. A release that came out later than its commit gets a shorter pause — that is 2.10.
- **In practice** (Д10 in RUN.md `spec`; R25): the Dependabot pull requests of `spec` #40–#42 of 2026-10-23 raised the references to `.github` from v0.1.0 to v0.1.3, not to v0.1.10: v0.1.4–v0.1.10 came out later, from 2026-10-21T15:30Z, and the pause still held them. The commit of v0.1.3 is dated 2026-10-20T23:49:54-05:00, and the release itself came out at 2026-10-21T04:50Z (sources 4.3). #49–#51 of 2026-10-26 raise the same references to v0.1.10 (sources 4.3).

### 2.7. How a shared workflow reads the files of `.github` of its own version

- **Gist:** a shared workflow may need data — the license list (3.1), the version and the sum of gitleaks. `actions/checkout` in it takes the calling repository, not `.github` (sources 2.1).
- **What is known:** GitHub describes how a reusable workflow takes its own repository at its own version: `actions/checkout` with `repository: ${{ job.workflow_repository }}` and `ref: ${{ job.workflow_sha }}` (sources 2.2).
- **Options:** keep the data right in the file of the shared workflow — a list of about ten SPDX identifiers, the version and the sum; keep them as separate files of `.github` and take them by a second checkout by `job.workflow_repository` and `job.workflow_sha`.
- **Recommendation:** in the file itself, while the data is this small. Then a change of the data is a change of the shared workflow, and that is what gives a release (2.4), and the caller gets the data of the version it is pinned at. A separate file — when there is more data, with a checkout by `job.workflow_sha`.
- **Task:** the epic E2 for gitleaks, the epic E3 for the license list, the epic E5 for its copy in `typescript.yml`.
- **Decided for gitleaks:** R08, the design is section 3.1.
- **Decided for the license list:** R16, the task T15. The list is in `go.yml` itself, and `self-ci.yml` checks it against the list of `spec`. The design is sections 3.1 and 3.4.
- **Decided for TypeScript:** R19, the tasks T21 and T22. A copy of the list was in `typescript.yml` itself too, as in `go.yml`, and `self-ci.yml` checked both copies against the list of `spec` — until T29.
- **The list is at `spec` since T26:** `self-ci.yml` checks the copies against the output of the recipe of `spec` `licenses-allowed`, not against the text of its file (R39 spec; the amendment to R16). The `ci-licenses` of a TypeScript caller checks the lock file by a recipe of `spec` and takes the list from there too. So since T29 there is no copy in `typescript.yml`: no caller read it, and one copy is checked — in `go.yml` (the amendment to R19).

### 2.8. Shared workflows from a repository named `.github`

- **Gist:** R03 puts the shared workflows into `altnovatrail/.github`. That GitHub calls workflows from a repository with such a name, and that Dependabot raises the references to it, is confirmed by the example of `nodenv/.github`, not by the documentation (sources 14.2).
- **Options:** leave them in `.github` and check by the first call; set up a separate repository for the shared workflows at once — that is a change to the list of repositories of R18 spec, «в реестр spec».
- **Recommendation:** leave them in `.github`: the example works, and Dependabot raises its reference (issue #12489 of dependabot-core, sources 14.2), and the card 3.11 spec puts the shared workflows here. The first call by the full path will confirm it — from `spec` in T17 `spec`. If it does not pass — a separate repository, «в реестр spec».
- **The call works** (T17 and T16 `spec`; R13). `spec`, `module-kit` and `tutor` call the shared workflows by the full path, `altnovatrail/.github/.github/workflows/<file>@<sha>`, and their checks run.
- **Task:** the call is T17 `spec`, done. Whether Dependabot raises such a reference, the first release after `v0.1.0` will show — T14 (Д10 in RUN.md `spec`).
- **Dependabot raises the reference** (Д10 in RUN.md `spec`; R25). At `spec` its pull requests #40–#42 raised the references to `scorecard.yml`, `secrets.yml` and `dco.yml` — each by its own pull request — and were merged on 2026-10-23. "DCO / sign-off" passed on them: the sign-off of `dependabot[bot]` was accepted by the exception of 3.1. The pause held them — 2.6.

### 2.9. Who sets the ruleset of `main` of `.github` itself

- **Gist:** each repository has its own ruleset of `main` by R30 spec: only through a pull request, all checks required but Scorecard. For the other repositories of stages 0–2 `spec` set it — T16 and T21 `spec` — and `.github` is of stage 0 too. But `.github` writes its own workflows itself (R03), and the names of its checks will appear in the epic E2.
- **Decided:** R11, the task T10: the ruleset 25477399, as at `spec`, with six required checks. Since R12 it has the rule `code_scanning` and merge commits only. By the amendment to R30 spec the same is required of all and stands at `spec` and all eleven component repositories: at `spec`, `module-kit` and `tutor` since T17 and T16 `spec` (sources 13.6), at the nine others since T21 `spec` (the amendment to R30 spec). The design is sections 3.3 and 3.4.

### 2.10. The pause of a release that came out later than its commit

- **Gist:** the pause of the references to `.github` is counted from the date of the release's tag, to the day (2.6). The tag that `gh release create` makes is lightweight, and its date is the date of the commit (sources 4.2). If a release comes out later than its commit, the pause turns out shorter than three days, or vanishes altogether.
- **What is known:**
  - a release usually comes out minutes after the merge: `v0.1.0` came out a minute after its commit;
  - it comes out later than its commit if the button puts it out after a failed run, or if the run stands long in the queue;
  - Dependabot reads the date from the tags of the repository's clone, not from the release (sources 4.2).
- **Options:**
  - accept it, and in the rare case of a late release hold the Dependabot pull requests at the callers by hand;
  - make an annotated tag before the release: it has a date of its own. But then the tag appears before the release, not together with it (R04; R31 spec). If the creation of the release fails after that, the next run will stop at "a tag without a release".
- **Recommendation:** accept. The case is rare and is seen by the date of the release, while the second option, for its sake alone, changes how a release comes out and adds a new failure to it.
- **Decided:** R23, the author's answer of 2026-10-22 to В13 — by the recommendation: the release comes out as before, and the Dependabot pull requests with a late release are held by hand at the callers.

### 2.11. The issue and pull request templates

- **Gist:** where the issue and pull request templates of NovaTrail lie is decided by T36 `spec`, with the first code of `module-kit` (Д4 in RUN.md `spec`). If GitHub takes templates from `.github` the same way as the community health files, they will lie here, beside CONTRIBUTING, SECURITY and the code of conduct (R22 spec).
- **How it will be decided:** T36 `spec` decides it by an amendment to R22 spec and gives a prompt to the session of `.github`. That session writes the files itself, as a task of its own (RUN.md `spec`, T36).
- **Decided:** by the 2026-11-01 amendment to R22 spec — by the author's answers when planning T36 `spec`. The amendment is so far on `main` of `spec`, not in the tag of the submodule. The templates lie here, as default files: the forms and `config.yml` in `.github/ISSUE_TEMPLATE/`, the pull request template `.github/pull_request_template.md`. T37 in [RUN.md](../RUN.md) wrote them (R29), and step 2 of T36 `spec` checks them and closes Д4.

### 2.12. What the containers of `spec`'s recipes can change in the checkout

- **Gist:** `spec`'s script mounts the whole checkout for writing into each of its containers, `.git` too (sources 12.2). After these containers the runner of the shared `release.yml` itself reads this `.git`:
  - `git diff` decides whether the release comes out;
  - `git archive` builds the tree whose files are then signed;
  - `git fetch`, when the Releases API refuses, goes by `.git/config`.

  `self-release.yml` has the same, without `git archive`. It was so before T25 too: the wrapper `$RUNNER_TEMP/toolchain` mounted the same. T25 protected the script itself by checking its sum (the amendment to R18), but not `.git`.
- **What is known:** the code of `spec` runs in these containers — the recipes `release-version` and `release-refusal` — on the Node, just and git of the caller's image. These recipes install no npm packages: they have no dependency `_tools` (`spec/justfile` v0.2.17). The build of the caller's files, `release-files`, runs in its own container and does not see the checkout (R18).
- **Options:**
  - run `spec`'s recipes in a copy of the checkout. A container then changes only the copy, and the runner's `git diff`, `git archive` and `git fetch` read an untouched `.git`. The sum of the script of the copy is checked, as now;
  - build the tree by `git archive` before the first container, and on a refusal take the tip of `main` through the API, without `git fetch`. Then `git diff` remains;
  - a row «в реестр spec»: the script mounts the checkout read-only, except what the recipes need to write;
  - accept: the containers run only the code of `spec` at a tag and the tools that the caller pinned.
- **Recommendation:** a copy of the checkout. One change in `.github` closes all three paths, and `spec` needs to change nothing.
- **Decided by the author (2026-10-22):** a copy of the checkout, by the recommendation — the answer to В24.
- **Decided:** the amendments to R10 and R18, the task T28. `spec`'s recipes in both releases run in a copy of the checkout, and the runner's `git` reads only the checkout itself, which no container mounts. T28 found a fourth such path too — the post step of `actions/checkout`: at the end of the job it runs `git config` and `git submodule foreach` in the checkout (sources 2.7; measurements 5.4). The copy closes it too. The design is sections 3.1 and 3.4.
- **Task:** T28, done.
- **The release of `spec`** is built the same way since the 2026-10-22 amendment to R31 spec — the answer to В25 (R25): the step of the number takes a copy of the checkout before the first container, and `release-refusal` after a refusal runs in a new copy, taken after `git fetch`. It does not check the sum of `spec`'s script: the script is no longer run from the copy after its container.

### 2.13. Tests of the shared workflows

- **Gist:** since `spec` v0.2.35 RULES.md, How we work, requires: "Code comes with its tests: a pull request that adds or changes what code does adds or changes the tests of its automated suite too" (the 2026-10-26 amendment to R48 spec). The code of `.github` is the shared workflows, YAML and steps in bash, and they have no automated suite of tests.
- **What is known:**
  - every pull request of `.github` runs `secrets.yml`, `dco.yml`, `documents.yml` and `codeql.yml` by the local path — on `.github` itself and only in the case where the check passes — and actionlint with shellcheck over all the workflows (3.4). `scorecard.yml` runs on `main`;
  - `go.yml`, `typescript.yml` and `release.yml` do not run in the CI of `.github` at all. Each change of them was checked by a trial pull request with no merge and by steps taken out of the file word for word and run locally with stubs of `docker`, `gh`, cosign and npm (R16, R18, R19 and the amendments to them). The next pull request repeats neither;
  - Codecov does not measure the coverage of steps in bash, so `.github` will have no `codecov/patch`, and the rule is held only by words;
  - the first changes of the shared workflows after the rule are T33 and T34 in [RUN.md](../RUN.md).
- **Options:**
  1. **the suite of tests of the steps**: the steps of the shared workflows, taken out of the file word for word, run in a job of their own in `self-ci.yml` with stubs — what the trials did by hand, on every pull request, and the negative cases too. A change of a step comes with its own cases. The cost is test code of its own and a way to take a step out of YAML: `.github` has neither packages nor a YAML parser. The parser can be downloaded by version and sum, like actionlint (R08);
  2. **permanent trials**: `self-` workflows on every pull request call `go.yml`, `typescript.yml` and `release.yml` with `publish: false` by the local path, on trial code in `.github` itself. The wrappers take the recipes and the `toolchain` stage from the caller's root, so `.github` would become a repository in Go and TypeScript, with their checks of CodeQL, Dependabot and SonarCloud. The negative cases cannot be run this way;
  3. **trials as before**: a trial pull request and a local run of the steps, recorded in the decision. These are tests, but not a suite: the next change will not repeat them. Only `spec` can read the rule of RULES.md this way — «в реестр spec».
- **Recommendation:** 1, as a task of its own before T33 and T34: both changes will then come with their own tests, as the rule demands, and the negative cases of the trials will become part of the suite.
- **Decided by the author (2026-11-01):** the suite of tests of the steps, by the recommendation — the answer to В27.
- **Decided:** R28, the task T35. The folder `tests/`, and in it a harness in bash and 53 tests. The steps run on the runner with stubs, the file is read by yq 4.54.1, by version and sum in `self-ci.yml`, and the suite runs as steps of the job "Workflows". The first cases are the `npm` step of `release.yml`, "Toolchain image" and the `ci-*` of the wrappers, and their structure. The other steps will get cases with their next change. Codecov still does not measure the coverage of bash, so the rule is held by the review of the pull request: a change of a step comes with its own cases. The design is section 3.4.
- **Task:** T35 in [RUN.md](../RUN.md), done.

## 3. Design

Decided under 2.1: R03 — which workflows are shared and which are a repository's own; R04 — how they are versioned; R05 — secrets and forks. The files of the shared checks are written by epic E2, the workflows for code by epic E3 (table 2 of [RUN.md](../RUN.md)), and they were connected by T17 `spec` — in `spec` and `module-kit` —, T16 `spec` — in `tutor` — and T21 `spec` — in the other nine, after each moved to a tag of `spec` with `docs-check-repo`. The external facts this rests on are the records of [sources.md](sources.md), the results of the trials are in [measurements.md](measurements.md), and a claim below names its record.

### 3.1. Shared workflows

A shared workflow lies directly in `.github/workflows/` of this repository, runs only through `on: workflow_call` and is called as `altnovatrail/.github/.github/workflows/<file>@<sha> # vX.Y.Z` (R04). The permissions are given by the caller's job, and the shared workflow only lowers them; `actions/checkout` in it takes the caller's repository. A shared workflow takes no secrets (R05).

**Before code — in every repository, `spec` included:**

| Workflow | What it does | Who calls it | Inputs | Permissions from the caller | What it needs from the repository | Check in the ruleset |
|---|---|---|---|---|---|---|
| `secrets.yml` | job `gitleaks`: the secrets scan by gitleaks 8.30.1 over the whole history of the commit checked (`--log-opts=HEAD`), as R49 canvas-api, with `--redact`; the archive is checked against the sha256 sum in the file itself (R08) | all | none | `contents: read` | `.gitleaks.toml` with the repository's own exceptions — optional: gitleaks reads it from the folder it scans (sources 11.1). It holds `[extend]` with `useDefault = true`, or it would replace the rules of gitleaks, and the check fails on such a file. On a pull request both it and `.gitleaksignore` are taken from the base, and `gitleaks:allow` comments have no effect: a pull request will not weaken the scan of its own commits | "Secrets / gitleaks", holds the merge |
| `dco.yml` | job `sign-off`: every commit of the pull request, but for merge commits, has a `Signed-off-by` of its author, by name and address (R30 spec); the commits are `git rev-list` between the parents of the pull request's merge commit, `HEAD^1..HEAD^2`, from a checkout with the full history, without the API; on another event it fails | all, the caller's job only on a pull request | none | `contents: read` | required sign-off of web commits: a commit made on github.com gets it only this way. The organization has it on (R22 spec) | "DCO / sign-off", holds the merge |
| `documents.yml` | job `docs-check-repo`: takes a checkout with the submodule, and the submodule's script `spec/tools/toolchain/toolchain.sh` builds the `toolchain` stage from the caller's `.devcontainer/Dockerfile` and runs `docs-check-repo` in it (R32 spec) — from the release after `v0.1.20`, as `spec`'s `ci.yml` and the shared release do (the 2026-11-08 amendment to R08). Without the script the step fails and names the reason. The image of the stage comes from the caller's GitHub Actions cache: the variable `TOOLCHAIN_IMAGE_FILE` names the file `${{ runner.temp }}/novatrail-toolchain.tar`, and `spec`'s script from v0.13.0 loads or writes it; the older script does not notice it and builds the image as before (the 2026-11-10 amendment to R36) | all but `spec`: it has its own `just docs-check` | none | `contents: read` | `.devcontainer/Dockerfile` with the `toolchain` stage and the submodule `spec/` — both from the repository template; the submodule at the tag v0.2.17 or newer, which has the script, and before it v0.2.3, with the recipe `docs-check-repo` (R32 spec). So the caller moves to v0.2.17 before it raises the reference to this release | "Documents / docs-check-repo", holds the merge |
| `codeql.yml` | CodeQL advanced setup (R09): job `languages` builds the list — `actions` always and the caller's languages, each once; another language stops the check with the reason. A job `analyze` per language — `build-mode: none`, and for `go` `autobuild`, with Go from the caller's `toolchain` stage (the amendment to R09); `tools: linked`, the query suite `security-extended`, `category` — `/language:<language>`. A green analysis means that CodeQL ran through, not that it found nothing. The findings are held by the ruleset rule `code_scanning` — in every repository by the amendment to R30 spec, in `.github` from R12 | all | `languages` — the repository's languages beyond `actions`, separated by a space, a comma or a line: `javascript-typescript` and, from the release after T19, `go`. Before code — empty, for `spec` — `javascript-typescript` for `tools/` (T17 spec). `paths-ignore`, from `v0.1.1`, — the paths CodeQL does not read in the analysis of `javascript-typescript`, like `paths-ignore` of its configuration: bare paths, one per line, without quotes. Job `languages` makes a YAML string of them, and `init` gets it as the input `config`, but only for this analysis. The analysis of `actions` does not get them and reads every workflow (R09). Nor does the analysis of `go` get them: a compiled language CodeQL reads by the build, and `paths-ignore` does not reach it (sources 5.2). A line that starts with `#` is a comment. A comma, a `#` after a space or a tab, a `- ` at the start and a quote at either end stop the check. For `spec` — `draft/**`, the prototype (Д8 in RUN.md `spec`) | `contents: read`, `security-events: write` | for `go` — Go in `/usr/local/go` of the `toolchain` stage of `.devcontainer/Dockerfile`, the one where the checks of `go.yml` run. The analysis copies it from there to the runner, together with the image's variables `GO*` and `CGO_*` (the amendment to R09). Go's autobuild first runs `make`, `ninja`, `./build` or `./build.sh`, if the root has such a file, — on the runner, not in the `toolchain` stage. The build executes Go and the pull request's code with the step's token — the same change the branch's author can make to the caller's workflow anyway; the default setup of code scanning is off. `paths-ignore` must not remove all the code of a language: then the analysis of that language fails — "CodeQL could not process any code written in JavaScript/TypeScript" (measurements 1.2). The input lives in the caller's workflow itself, so a pull request can change it together with its code. Only a review of the diff of `.github/workflows/` sees such a change, and the project has one author, and the ruleset requires no approvals (R09; R30 spec) | "CodeQL / analyze (<language>)", holds the merge. "CodeQL / languages" is not required: if it fails, there are no analyses at all, and the merge waits for them, and it names the reason |
| `scorecard.yml` | job `scorecard`: OpenSSF Scorecard with its results published, SARIF to code scanning; the job has only approved actions and not one script of its own (R09) | all, on a push to `main` and on a schedule | none | on the job — `contents: read`, `security-events: write` and `id-token: write`; at the workflow level — read only | the caller is a small separate file without `env` and `defaults` (2.2) | "Scorecard / scorecard", does not hold the merge (R30 spec) |

Dependabot signs off a commit with another address than the one the author is named by. In `spec`, in the commit c6b3cb5, the author is `dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>`, and the sign-off is `Signed-off-by: dependabot[bot] <support@github.com>`. So `dco.yml` checks the sign-off against the author by name and address, and for `dependabot[bot]` accepts this sign-off as a named exception. Otherwise every pull request of Dependabot would be red, and T17 `spec` expects the opposite. The exception holds only if the pull request was opened by `dependabot[bot]`, and the committer is `GitHub <noreply@github.com>`: anyone can set the author of a commit, but not the author of a pull request.

**With the first code — in the repositories with code** (epic E3 — `go.yml`, with the scaffold of the CLI of `module-kit` (R16), and `release.yml`, with its first release; epic E5 — `typescript.yml`, with the first code in TypeScript, in `canvas`):

| Workflow | What it does | Who calls it | Inputs | Permissions from the caller | What it needs from the repository | Holds the merge |
|---|---|---|---|---|---|---|
| `go.yml` | a job for each of the caller's four `just` recipes — `ci-lint`, `ci-test`, `ci-vuln` and `ci-licenses` —, in the `toolchain` stage of its `.devcontainer/Dockerfile`, as the runner's user. `ci-licenses` gets `ALLOWED_LICENSES` in its environment — the ASF's category A, as SPDX identifiers (R16). Job `test` hands on the coverage report as the artifact `go-coverage`, and job `coverage` — the only one with `id-token: write`, after all four — sends it to Codecov by OIDC. It takes the Codecov CLI v11.3.2, by the sha256 in the file itself, and a failed upload fails only a pull request (the 2026-11-01 amendment to R16). With the input `same-bits` — four more jobs in the same stage. Two of them by a script in one container: `targets` runs the tests at GOAMD64 v3, at v1 with `GODEBUG=cpu.all=off`, at `GOARCH=386`, in js/wasm through `go_js_wasm_exec` and in wasip1 through an executor on `node:wasi` that the script writes outside the checkout, and checks wasip1 with `go vet` (R39, T58); `fma-diff` compares the assembler of every package with code, with fusion and with `-d=fmahash=n`, on six targets, with its own control (the 2026-11-08 amendment to R16, T46). The third, `arm64`, runs on `ubuntu-24.04-arm`: the caller's `ci-test` in its own container, and then the script `targets`, which on a host other than amd64 runs its build with `cpu.all=off`, js/wasm and wasip1 (the 2026-11-08 amendment to R16, T47). The fourth, `rules`, holds the code to the rules of code by the tool `tools/coderules/` of `.github` of the same commit as the file `go.yml` — a second checkout by `job.workflow_repository` and `job.workflow_sha` —, with the caller's lists `.github/coderules.json` (R33, T48) | repositories of the kind go; first `module-kit`, from the scaffold of the CLI (T10 module-kit), and from T50 `spec` also `spec`, over all its Go modules (the 2026-11-01 amendment to R30 spec); with `same-bits` — `learner-model` and `engine` (R107 spec) | `same-bits` — boolean, `false` by default | `contents: read`, `id-token: write`; the second for job `coverage`: a called workflow only lowers permissions | Go in the `toolchain` stage at an exact version and with `GOTOOLCHAIN=local`; recipes with these names, and `ci-licenses` by the list from `ALLOWED_LICENSES`. `ci-test` writes one coverage profile, `coverage/go.out`, over every package of every module, and without it "Go / test" is red. The caller has no artifacts of its own named `go-coverage` or `typescript-coverage`: an artifact's name is unique in a run. The Codecov app sees the repository, and `codecov.yml` is by 3.3. The code and the tests do not read `spec/`: the job takes a checkout without the submodule (R21 spec). The tools of the checks and their versions are the repository's own, and so are the exceptions of the license check, each with a decision, as R48 canvas-api. With `same-bits` — also Node in the `toolchain` stage, for js/wasm and for wasip1 by `node:wasi`, of a version that knows `--disable-warning` — v20.11 or newer on the line 20, v21.3 or newer from 21 on (sources 9.1), and `bash` in it, the tests pass without race detection too, on 386 and in wasm, and `.github/coderules.json` holds the caller's lists (3.3) | yes: "Go / lint", "Go / test", "Go / vuln" and "Go / licenses", when the caller's job is named "Go", and with `same-bits` also "Go / targets", "Go / fma-diff", "Go / arm64" and "Go / rules". "Go / coverage" does not hold the merge, but `codecov/patch` from Codecov does — once the author puts it in the ruleset (3.3) |
| `typescript.yml` | the same for TypeScript, by the contract of R19: a job for each of `ci-lint`, `ci-test`, `ci-vuln` and `ci-licenses` in the caller's `toolchain` stage, as the runner's user. Job `licenses` takes the submodule `spec`, and `ci-licenses` checks the lock file by `spec`'s recipe `licenses-check-repo` from it (R39 spec; the amendment to R19). The container runs with `--init`, and for job `test`, where the browser starts, also with `--ipc=host`, for Chromium. Of the environment only `CI` goes into it: by it Vitest does not let `test.only` through, and, if the configuration does not set `headless` itself, also runs the browser headless. It is worth setting it explicitly, `headless: true`: the development container has no `CI` (the amendments to R19). Coverage — as in `go.yml`: the lcov report as the artifact `typescript-coverage`, and job `coverage` sends it to Codecov (the 2026-11-01 amendment to R19) | repositories of the kind typescript; first `canvas`, from T08 canvas | none | `contents: read`, `id-token: write`, as for `go.yml` | Node in the `toolchain` stage at an exact version; `ci-test` writes the lcov report, `coverage/lcov.info`, and a module that no test loads is in it with zeros — by Vitest's `coverage.include` — or fails the recipe; a lock file and `.npmrc` with `ignore-scripts=true` and `save-exact=true`; recipes with these names — `ci-lint` checks the format, the lint and the types —, and each installs the packages itself, through `npm ci`; `ci-licenses` checks every package of the lock file by the recipe `just -f spec/justfile licenses-check-repo <lock-file> [<exceptions file>]`, and the submodule `spec` is at the tag v0.2.18 or newer, where the recipe has the `dev` boundary. The exceptions are a JSON file of the repository's own, the recommended name `licenses.json`, each with a decision (the amendment to R19). The browsers for the tests are in the `toolchain` stage, only those the tests run, of the revision that the Playwright of the lock file expects, at the path from `ENV PLAYWRIGHT_BROWSERS_PATH` of that stage, with the integrity by the rules and the terms named in the decision. Playwright's browser `chromium` is a build of Google Chrome for Testing on Google's terms, free for everyone, not Chromium under an open license. The 2026-10-22 amendment to R12 spec accepts them: NovaTrail does not distribute the browser, and the platform builds and runs without it (the amendments to R19). The checkout is without the submodule, but for job `licenses`: the code and the tests do not read `spec/` (R21 spec). Job `licenses`, like `documents.yml`, takes all the caller's submodules, so the repository has no submodules but the public `spec`. The tools of the checks and their versions are its own | yes: "TypeScript / lint", "TypeScript / test", "TypeScript / vuln" and "TypeScript / licenses", when the caller's job is named "TypeScript". "TypeScript / coverage" — no, as in `go.yml` |
| `release.yml` | a release with keyless signing (R18). The number comes from `spec`'s release recipes, which the script `spec/tools/toolchain/toolchain.sh` from the caller's submodule runs, in the copy of the checkout: the recipes' containers change only it, and the runner's `git` reads the checkout itself (2.12). The line is `RELEASE_LINE` of the caller's workflow. A release comes out only if the paths of `paths` changed since the last one; the first always comes out. The files are built by the caller's recipe `release-files` from the commit's tree, in its `toolchain` stage. Only the commit that the run itself names, `GITHUB_SHA`, is signed: its certificate names the same commit as the tag, and an older commit is covered by the release of the tip. Every file, module packages too (R17 spec), is signed by cosign 3.1.4 with a bundle beside it, and every bundle is checked before publishing — against the shared `release.yml`, the caller's repository and this commit. A run that publishes first checks that the signature will be one that R77 spec lets in: the caller's workflow is its `.github/workflows/release.yml` on `main`, and the shared `release.yml` is pinned by a SHA (the amendment to R18, T39). The release is Latest, immutable, and `gh release verify` and `verify-asset` check it. With `npm-package` the same archive of the package goes to npm, through trusted publishing, after the release has come out and been checked. The archive is checked before the release already, and the number with it: a number that npm has already given out and a package unpublished whole stop the run before the release. A rerun for a commit already released publishes the archive from the release, after checking its attestation and signature. The signature is checked by `spec`'s recipe `release-verify` (R77 spec), and a dry run of the recipe goes before the build already (the amendment to R18, T39). The publication is judged by the registry, not by npm's exit code (the amendments to R18). A version counts as published when the package's document has shown it and the registry has served its archive: the step waits for both in rounds, up to 20 minutes, and the job's `timeout-minutes` is 45 (the 2026-11-08 amendment to R18, T44). With the input `previous-file` the recipe gets the file of the last release: before the build the step "The previous release's file" downloads it with its bundle from the newest release, checks the attestation, and the signature by the recipe `release-verify`, and hands it to the recipe as the second argument, read-only. The first release gets an empty second argument, and a file that cannot be downloaded or checked stops the run before the build (the 2026-11-02 amendment to R63 spec; the amendment to R18, T41) | `module-kit` first, then `modules` and the other repositories with releases; with `npm-package` — the repositories with UI packages, `canvas` first (R37 spec) | `paths` — pathspecs of what the release is built from, one per line; `publish` — `false` for a trial without publishing; `npm-package` — a package in the scope `@altnovatrail` that the release publishes to npm, empty — publishes none; `previous-file` — the name of the file of the last release that the recipe gets, for example `module-index.json`, empty — gets none | `contents: write`, `id-token: write`, `actions: read` | a recipe `release-files VERSION` that writes plain files with safe names into `dist/`. It builds from the commit's tree without history or submodules, so it has no `git`, and the version comes as an argument; `RELEASE_LINE` in its own `release.yml`; CI — `ci.yml`; immutable releases and a ruleset of the tags `v*` — a condition of the signature check (R77 spec); the submodule `spec` — `altnovatrail/spec` at the tag v0.2.17 or newer, which has this script: otherwise the run stops before the build and names the reason (the amendment to R18). The workflow is `.github/workflows/release.yml`, and it pins the shared `release.yml` by the SHA of a release (R04): otherwise a run that publishes stops first thing (T39). With `npm-package` — the `npm pack` archive among the files of `dist/`. The submodule `spec` — v0.6.0 or newer, which has `release-verify`: otherwise the run stops before the build (T39). With `previous-file` — the recipe `release-files VERSION PREVIOUS` with two parameters, among the files of `dist/` a file with this name, and the same submodule, v0.6.0 or newer (T41). In `package.json` — `repository` as an object with the URL of this repository, without `private`, `publishConfig` or a `tag` of its own. The first version of the package is published by hand, and the package's trusted publisher names the repository and the file of the caller's release workflow, with no environment, and allows `npm publish` (3.3) | no: it is not a check of a pull request |

The license list for `go.yml` and `typescript.yml` is one for all — category A of the ASF's policy, as in `spec`'s check (the amendment to R12 spec). For Go it lies in `go.yml` itself, `ALLOWED_LICENSES`, and `self-ci.yml` checks it against what `spec`'s recipe `licenses-allowed` prints (2.7; R16; R39 spec). `typescript.yml` has no copy: the `ci-licenses` of a TypeScript caller checks the lock file by `spec`'s recipe `licenses-check-repo` and takes the list from `spec`, at the tag of its submodule (the amendments to R19). Neither wrapper has inputs, and their recipe names are the same — above (R16, R19). Both send coverage by the same job `coverage`, and they differ only in the artifact's name and the report file. Only this job has the permission `id-token: write`: the jobs of the matrix execute the pull request's code (the 2026-11-01 amendments to R16 and R19). Every job of both that builds the image of the `toolchain` stage takes it from the caller's GitHub Actions cache — a `docker save` file by a key of the runner's OS and architecture and the hash of the Dockerfile — and builds it only on a miss, saving it at once; the shared release takes no cache (R36). The identity of the signature — 2.3.

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

`.github/workflows/ci.yml` — on a pull request and a push to `main`; beside the three shared ones go the repository's own jobs. Job `documents` requires `.devcontainer/Dockerfile` with the `toolchain` stage and the submodule `spec/` at a tag with the recipe `docs-check-repo` — v0.2.3 or newer (R32 spec; section 3.1). A repository at an older tag first moves to a new one, in a task of its own (RULES.md, Across repositories), or "Documents / docs-check-repo" is red. Before T21 `spec`, engine, for example, stood like that — at v0.1.0, the commit ec6c48e. Now all eleven repositories of the components stand at v0.2.9 or newer (the amendment to R32 spec): the submodule of engine is the commit 5eafb1a, v0.2.9 (sources 13.6):

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
    uses: altnovatrail/.github/.github/workflows/documents.yml@ff2a3597769ca85e59e476b1a41bdcbc1f50e3ed # v0.1.0
```

`.github/workflows/codeql.yml` — on a pull request and a push to `main`. It is not run weekly: the CodeQL bundle is pinned together with the action (R09). The repository's languages beyond `actions` go in the input `languages`: `javascript-typescript` and, from the release after T19, `go` —, and then "CodeQL / analyze (go)" also goes into the ruleset of `main` (section 3.1):

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
    uses: altnovatrail/.github/.github/workflows/codeql.yml@ff2a3597769ca85e59e476b1a41bdcbc1f50e3ed # v0.1.0
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
      # Every reference to a shared workflow of .github in one pull request, to one release:
      # Dependabot names each altnovatrail/.github/.github/workflows/<file>.yml.
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

A repository in Go adds to `ci.yml` the job "Go", which calls the shared `go.yml` (R16). `go.yml` is in the releases of `.github` from `v0.1.2`, the commit `d01dd881d6b4efb6013dd72f40a713b8d2dd3bad`; the latest release is named by `gh release view` and `git ls-remote`, as above. From `v0.1.12`, the commit `4225639bcd04f43ef58f95cabf9fdfd947cbcb07`, the wrapper sends the coverage of the tests to Codecov, and the caller's job gives it `id-token: write` (the 2026-11-01 amendment to R16). From `v0.1.18`, the commit `6f774969620624790f9c7ff1a94d9bbd8b80e342`, the wrapper has the input `same-bits` — on it below; a caller without it needs nothing new (the 2026-11-08 amendment to R16, T46). From `v0.1.19`, the commit `982ffe64b1f26f1ca4e0279c093d83cbb8ff3882`, the input also has the job "Go / arm64" (the 2026-11-08 amendment to R16, T47). From `v0.1.20`, the commit `f87e8da72bd70ce171816881b9288cb6f7b17901`, — also "Go / rules", with the caller's lists `.github/coderules.json` (the 2026-11-08 amendment to R16, T48; R33). From `v0.1.22`, the commit `c0234058dc1a85edd7b5d579b90f8fdb98ea826b`, every job of the wrapper that builds the `toolchain` stage takes its image from the caller's GitHub Actions cache and builds it only on a miss (R36); the caller needs nothing new — neither permissions nor inputs. From `v0.1.24`, the commit `fab102d8bbb4659575e107ee488e072aaaa71821`, "Go / targets" and "Go / arm64" run the tests on wasip1 too, in `node:wasi` (R39): a caller with `same-bits` whose tests fail on wasip1 gets both red, and it needs nothing new either. The text below pins `v0.1.24`. To the earlier releases this permission changes nothing: a called workflow only lowers permissions. How the caller moves — "Coverage" below.

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
    uses: altnovatrail/.github/.github/workflows/go.yml@fab102d8bbb4659575e107ee488e072aaaa71821 # v0.1.24
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

A repository in TypeScript adds to `ci.yml` the job "TypeScript", which calls the shared `typescript.yml` (R19). `typescript.yml` is in the releases of `.github` from `v0.1.5`, the commit `c772cc86973240e21cebb310fd0cda221a752ade`; the latest release is named by `gh release view` and `git ls-remote`, as above. From `v0.1.8`, the commit `0ab279940126dadbde0f5a3912ce196ed39470ab`, job `licenses` takes the submodule `spec`, and `ci-licenses` checks the lock file by `spec`'s recipe `licenses-check-repo`. The submodule is at the tag v0.2.18 or newer (the amendment to R19). The caller moves `ci-licenses` to the recipe together with raising the reference to this release or after it, but not before: the older wrapper does not provide the submodule. From `v0.1.10`, the commit `f3addb7403d084c560c61481e217b93f8e7ee1f3`, the wrapper does not pass `ALLOWED_LICENSES` into the container: of the environment only `CI` goes there, and `ci-licenses` takes the list from `spec` (the amendment to R19). From `v0.1.12`, the commit `4225639bcd04f43ef58f95cabf9fdfd947cbcb07`, the wrapper sends the coverage of the tests to Codecov, as `go.yml` does, and the job's permissions are the same (the 2026-11-01 amendment to R19). From `v0.1.22`, the commit `c0234058dc1a85edd7b5d579b90f8fdb98ea826b`, job `check` takes the image of the `toolchain` stage from the cache, as `go.yml` does (R36); the caller needs nothing new. The text below pins `v0.1.22`. What is needed of the recipes, `.npmrc` and the `toolchain` stage — R19 and section 3.1.

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
    uses: altnovatrail/.github/.github/workflows/typescript.yml@c0234058dc1a85edd7b5d579b90f8fdb98ea826b # v0.1.22
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

A repository with releases adds `.github/workflows/release.yml`, which calls the shared `release.yml` (R18). `release.yml` is in the releases of `.github` since `v0.1.4`. Since `v0.1.6`, commit `630924eeb673272d634120b054d1ae93ca33a70c`, it runs the recipes of `spec` by the script `spec/tools/toolchain/toolchain.sh` from the caller's submodule. The submodule must be `altnovatrail/spec` at the tag v0.2.17 or newer: otherwise the run of Release on `main` stops and names the reason (the amendment to R18). So the caller moves to v0.2.17 before it raises the reference to `.github`. Since `v0.1.7`, commit `0acbf75e5c8362b649924bf1abdae973ce71085e`, the recipes of `spec` run in the copy of the checkout, and the runner's `git` reads only the checkout itself (the amendment to R18); this asks nothing new of the caller. Since `v0.1.9`, commit `41d5144e304cfad05c681de6934405c08a7435db`, the shared release has the input `npm-package` — on it below —, and a caller without it needs nothing new. Since `v0.1.11`, commit `c1b848779d9f1d73817ca078a7cba3664632f03b`, the npm step rejects, before the release, a number that npm has already given out, and a package unpublished whole (the 2026-11-01 amendment to R18); this too asks nothing new of a caller without `npm-package`. Since `v0.1.13`, commit `09443e1027ef24197439dfe60a072d14c3626cc3`, a run that publishes stops before anything else if the caller's workflow is not `.github/workflows/release.yml` on `main`, or if the shared `release.yml` is pinned other than by its own path and a SHA: R77 spec would reject the signature of such a run, and the files of a release are immutable. The template below keeps both. A caller with `npm-package` also needs the submodule `spec` at v0.6.0 or newer: a rerun checks the archive by the recipe `release-verify`, and a dry run of the recipe goes before the build. So such a caller moves to v0.6.0 before it raises the reference to this release (the amendment to R18). Since `v0.1.14`, commit `96dadfef02ca25376d4ea88f887003639d20080e`, the shared release has the input `previous-file` — on it below —, and a caller without it needs nothing new. Since `v0.1.15`, commit `89d3ceee0b9977b3334488a4133d084d76474e0d`, the check of an unpublished version number in the npm step is the same as in the step of `spec` (the amendment to R18, T42); this asks nothing new of the caller. Since `v0.1.16`, commit `ea6771cc1af95e59e19f71997a74c25d0966603e`, the npm step waits up to 20 minutes for the version and its archive, and the job's `timeout-minutes` is 45 (the 2026-11-08 amendment to R18, T44); this too asks nothing new of the caller. The text below pins `v0.1.16`. The `paths` list lists what the output is built from, by the kind of the repository, and not everything but the exclusions (the 2026-10-22 amendment to R31 spec; the amendment to R18). This template keeps the list itself, and R31 spec gives only the rule it is made by (the 2026-11-01 amendment to R31 spec). Below is the list of the kind go: the Go code without the tests, `go.mod`, `go.sum`, `justfile`, `LICENSE`, the whole `.devcontainer/Dockerfile` — Go is pinned in it — and `release.yml` itself, so that a change of the line gives a release. `*.go` in a git pathspec without the magic `glob` takes files at any depth, and `**/*.go` would miss a Go file in the root (measurements 2.2). The files that the code embeds by `//go:embed` the caller adds to the list itself, and the code in `testdata/`, which is not part of the build, it excludes itself: the list holds what the consumer will get. The lists of the kinds typescript and modules are below, after the input `previous-file` (T45; the 2026-11-01 amendment to R31 spec). The caller's job sets no `concurrency` of its own: the shared job waits in the queue `release` by itself:

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
    uses: altnovatrail/.github/.github/workflows/release.yml@ea6771cc1af95e59e19f71997a74c25d0966603e # v0.1.16
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
- `self-ci.yml`, `name: CI` — on a pull request and on a push to `main`. The jobs "Secrets", "DCO" (on a pull request only) and "Documents" call the shared workflows by the local path `./.github/workflows/<file>`, so a pull request checks the very version that it changes. The job "Workflows" is actionlint 1.7.12 over all the workflows, with shellcheck 0.11.0 over the scripts in them: their code lives here. actionlint and shellcheck, like gitleaks, are downloaded at an exact version and checked against a sha256 sum in the file itself, and the devcontainer does not have them (R08); actionlint does not take the runner's shellcheck. The ignores of actionlint, each with its reason, are in `.github/actionlint.yaml`. The same job compares `ALLOWED_LICENSES` in `go.yml` — and in any other workflow where this list appears — with what the recipe `licenses-allowed` of `spec` prints at the tag of `.github`, and names the copy that diverged (R16). `typescript.yml` has no copy, and only `go.yml` is required by name to have one (the amendment to R19). The recipe runs in the `toolchain` stage of `.github` itself: the script `spec/tools/toolchain/toolchain.sh` builds it, so the job takes the checkout with the submodule (the amendment to R16), and the image from the cache, by the same steps and the same entry as `documents.yml` (the 2026-11-10 amendment to R36);
- the job "Go" of `self-ci.yml` calls the shared `go.yml` by the local path, without `same-bits`: the four recipes of the root `justfile` of `.github` — `ci-lint`, `ci-test`, `ci-vuln` and `ci-licenses` over the module `tools/coderules` through `go -C` —, and the upload of the coverage to Codecov by the `.github/codecov.yml` of the template of 3.3. govulncheck is v1.9.0, and go-licenses v2.0.1, as at `engine`. go-licenses does not check the module itself: its LICENSE is the root one, Apache-2.0, and go-licenses looks for LICENSE in the module's folder. `.sonarcloud.properties` removes `tools/coderules/testdata/**` from the search for duplicates: two controls are near copies of each other on purpose (R33);
- the suite of tests of the steps (R28) — steps of the same job after actionlint:
  - "Install yq" — yq 4.54.1 by the sum from the `checksums` of its release;
  - "Lint the tests" — the job's shellcheck 0.11.0 over `tests/*.sh` and `tests/stubs/*`;
  - "Test the workflows" — `YQ="$RUNNER_TEMP/yq" bash tests/run.sh`.

  The folder `tests/`: `run.sh` — the launcher, one bash process per test; `lib.sh` — the harness; `stubs/` — the stubs; `<workflow>.test.sh` — the cases of a workflow; `harness.test.sh` — the tests of the harness itself.

  A test chooses a step: `select_step <job> id=<id>` or `name=<name>`. Then it sets the context — `ctx`, `set_env`, `runner_env` — and the stubs: `stub`, `stub_in_temp`, `stub_exit`, `stub_stdout`, `curl_answer`, `curl_offline`. Then it runs `run_step` and checks the exit code, the lines of output, the step's outputs and the calls of the stubs. `wf` reads the structure and the text of `if:`.

  Locally the suite runs from the root of the repository, with yq 4.54.1 downloaded by the same sum: `YQ=<path> bash tests/run.sh`. A test stops after 120 seconds, the step under test after 60, and "Test the workflows" after 5 minutes, within the job's 10 minutes. shellcheck is of the version in "Install shellcheck". The devcontainer does not have them, as it does not have actionlint (R08);
- `self-release.yml`, `name: Release` — its own release, as at `spec` (R31 spec; R10): after a green `self-ci.yml` on `main`, only from a push from the repository itself, and by the button — on `main`, after a green CI. The runs go in a queue, `queue: max`. The checkout is the tip of `main` that the event saw, with all the history and the submodule, and the commit on which CI passed is named only by its SHA (R12). The number is computed by the recipe `release-version` of `spec` in the `toolchain` stage, and the script of `spec` runs it from the submodule: `spec/tools/toolchain/toolchain.sh spec release-version <commit> .github/workflows/self-release.yml` (the amendment to R10). The script runs from the copy of the checkout in `RUNNER_TEMP`, and the runner's `git` reads only the checkout itself, which no container mounts (2.12). It reads the line from this file at the commit being released, and for a commit older than the file, from the file of the tip, which it sees in the copy of the checkout (T17; the amendment to R31 spec). A release comes out if a shared workflow has changed, and `gh release verify` checks it. A refusal 404 or 403 "Resource not accessible by integration" is let pass only if the commit is no longer the tip of `main`, lies in its history and adds or changes files of `.github/workflows/` relative to it: the release of the tip will cover its edit (sources 3.2 and 12.1). This is decided by the recipe `release-refusal` of `spec` — one copy of the rule for both releases (T17). The recipe runs only after a refusal, so on every run the step of the number tries its call without running it, `toolchain.sh spec --dry-run`: otherwise a tag of `spec` that renames the recipe or changes the number of its parameters would surface only on a rare refusal, and would make red the very run that the refusal is to let pass (T17; sources 11.4; measurements 5.1). What sets it apart on purpose from the `release.yml` of `spec` after the amendment to R31 spec is this. A release comes out only if a shared workflow has changed, and every release is Latest (R10). A tag without a release is checked for the previous release too (R10). The commit of CI must be a full SHA and an ancestor of the checkout (R12) — `spec` has no such checks. Nor does it have the trial of the call: there one edit changes both the recipe and its call;
- `self-codeql.yml`, `name: CodeQL` — on a pull request and on a push to `main`; `self-scorecard.yml`, `name: Scorecard` — on a push to `main` and once a week. Both call the shared ones by the local path, and `.github` names the language `go` besides `actions`: its code is the tool `tools/coderules/` (the 2026-11-08 amendment to R09, R33); `dependabot.yml` and `.sonarcloud.properties` are as in 3.3.

The ruleset of `main` lets into `main` only a pull request with green required checks — their list is in R11. Besides, a pull request must have no findings of CodeQL of the level `high` and above, and no errors, and it is merged only by a merge commit (R12). The ruleset `v-tags` holds the tags of releases (R10).

### 3.5. Versions and updates

By R04 and R10:
- **a release of `.github`** comes out by itself after a green CI on `main`, as in R31 spec, but only for a commit that, since the previous release, changes a shared workflow — a file of `.github/workflows/` without the prefix `self-` — or the tool `tools/coderules/`, which `go.yml` builds at its own version (R33); the first release always comes out. `git diff` finds the edit, and an edit of comments alone is an edit too: the references of the comments of `go.yml`, `release.yml` and `scorecard.yml`, which T55 pointed at the records, will be released after the merge as `v0.1.23` (the 2026-11-12 amendment to R38). The number is the next patch of the line `RELEASE_LINE` from `self-release.yml`, now `0.1`. It is computed by the recipe `release-version` from the submodule's `spec/justfile` by the tags of `.github`, and run by the script `spec/tools/toolchain/toolchain.sh` from the copy of the checkout (T25, T28). The recipe reads the line from the `self-release.yml` of the commit being released (T17). Before T13 the number was computed by the functions `readLine`, `readTags` and `nextVersion` from `spec/tools/release/version.mjs`, and before T17 the line was taken from the tip. Every release is Latest, immutable, with an attestation, and the tags `v*` are under the ruleset `v-tags`;
- **the callers** pin a shared workflow by a SHA, with a comment of the version on the same line. Their Dependabot raises both the SHA and the comment if the commit has a tag (sources 4.1). It raises all the references to `.github` in one pull request — by the group `shared-workflows` of the template of 3.3 (the 2026-11-08 amendment to R04);
- **actions inside the shared workflows** are pinned the same way, and the Dependabot of `.github` itself raises them. A merged update comes out as a release, and after it the callers' Dependabot raises the reference;
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
