# .github decision log

> Why .github is built the way it is. Each entry says what was decided, why, what was rejected and where it is described.
>
> **Rule:** do not re-propose what was rejected without new facts. If a decision has to change, ask the author and update this file. An entry is never rewritten: an amendment with its date at the end of the entry corrects it, or a new entry replaces it, and the old one stays where it is, marked "Superseded".
>
> The repository was made 2026-10-19 from the repository template of `spec` v0.1.0 (R21 spec), moved the same day to `spec` v0.2.3 (R01), then to v0.2.4 (R02); 2026-10-20 — to v0.2.5 (R06), v0.2.6 (R07), v0.2.9 (R13) and v0.2.11 (R14), 2026-10-21 — to v0.2.12 (R15), v0.2.13 (R17) and v0.2.14 (R20), 2026-10-22 — to v0.2.17 (R21), v0.2.21 (R22) and v0.2.23 (R24), 2026-11-01 — to v0.4.1 (R25) and v0.5.3 (R27), 2026-11-02 — to v0.6.2 (R30) and v0.6.3 (R31), 2026-11-08 — to v0.9.8 (R32) and v0.9.9 (R34), 2026-11-09 — to v0.12.0 (R35), 2026-11-10 — to v0.13.0 (R37), and 2026-11-12 — to v0.16.3 (R38). How it comes to differ from the repository template over time — by tools in the devcontainer, by rules in RUN.md — is recorded here as a decision, as R46 canvas-api recorded the differences from its model. Next number — R39.
>
> Here entries are cited as `R03`, in other repositories as `R03 .github`. The decisions of `spec` are cited as "R18 spec", MathTrail's decisions as "R37 canvas-api", and in a list as "canvas-api: R37, R38". Each log has its own numbers.
>
> Open questions that concern several repositories are in the registers of `spec`: О- in product 13 spec, П- in privacy 9 spec, Т- in repositories 8 spec. What is still to decide in the component itself is in [architecture.md](architecture.md), section 2.

## The `spec` tag

The entries run by number, so the moves to a tag later than R05 stand further on: R06 and R07 in the section "The `spec` tag — continued", R13–R15 in the section "The `spec` tag after the shared workflows", and R17 at the end of the log, in the section "The `spec` tag after the Go wrapper".

**R01. `.github` is on `spec` v0.2.3: the submodule `spec/` is at this tag, the links to `spec` pinned to a tag name it, and what came from the repository template is as in the repository template of v0.2.3.** The links without a tag — to `spec` in CONTRIBUTING.md and in the profile's table of repositories — stay without one: they lead to the repository, not to a version of it.
- **What the tag brings to `.github`** (`git diff v0.1.0 v0.2.3` in `spec/`, read 2026-10-19):
  - R30 spec — the CI checks are the same for all repositories, and all of them but Scorecard hold the merge. Which of them become shared workflows, what their inputs are and how their SHAs are updated is decided by T01, and T17 and T16 `spec` connect them. This is the main input of T01;
  - R31 spec — the release of `spec` comes out by itself after a green CI on `main`, and only its workflow sets tags. A tag comes out with each green `main`, and a repository moves to a new one by a task of its own. A shared "signed release" from `.github` for `spec` is rejected for now: `spec` has no code, and the first tag with R30 spec is needed by `.github` itself;
  - R32 spec — this repository's documents are checked by `just -f spec/justfile docs-check-repo`, the submodule's `docs-check`, and an example of a citation is written in inline code. Whether this is a shared workflow in CI or a repository's own is decided by T01;
  - R24 spec — where the key for eval lies and how eval runs on a pull request from a fork. T15 `spec` passed this open point to T01 and T17 `spec`, and R30 spec names the pull request from a fork from it;
  - RULES.md — an example of a citation is written in code (Citations); a development or CI tool that does not ship may carry another OSI license or free terms for open source, but only as a named exception (Hard rules; R12 spec);
  - R23, R25–R29 spec — about other components. Of them, only `canvas`'s own check comes into CI — the build of the page of samples with the CLI of `module-kit` and the release of `modules` (R25 spec), — and it is in architecture 2.1 among the repositories' own checks;
  - the repository template — rule 6 of RUN.md and five examples of citations in code;
  - the devcontainer — the base image `devcontainers/base` 3.0.10 by digest; Claude Code is installed without the packages' install scripts, its `install.cjs` is run by name, and `claude --version` stops the build if a placeholder was left instead of the binary; `git.alwaysSignOff` — commits from Source Control are signed off by DCO (R22 spec).
- **What is changed here:**
  - `spec/` is at v0.2.3, commit d7c6340. The links to `spec` in README.md and `profile/README.md` and the tag in CLAUDE.md and RUN.md are v0.2.3. That the repository was made from the repository template of v0.1.0, the opening of the log still says: it is history;
  - the examples of citations, rule 6 of RUN.md and `.devcontainer/` are as in the repository template of v0.2.3. The devcontainer is the one that the recipe of `spec` v0.2.3 builds for `.github`, with the container's name and the network `novatrail-github`. The move brings in no differences from the repository template;
  - T01 gets R30 spec among its inputs and «Разделы» and depends on T03, and architecture 2.1 gets what the tag says about its question: R24, R25, R30–R32 spec and the amendment to R12 spec;
  - architecture 1 and CLAUDE.md say that `spec` takes the shared checks too (R30 spec), and CONTRIBUTING.md — about the exception of RULES.md for tools that do not ship.

— *Why now:* T01 decides which checks become shared workflows, and which checks the platform has was decided by R30 spec — at v0.1.0 it does not exist. T17 `spec` waits for `.github` to read R30 spec at the new tag. v0.2.3 is the newest release of `spec` as of 2026-10-19 (`gh release list -R altnovatrail/spec`), and only it has R32 spec with `docs-check-repo`: rule 6 is checked by a program, not by eye. The release is confirmed by an attestation: `gh release verify v0.2.3 -R altnovatrail/spec` — "Release v0.2.3 verified!", the tag is on commit d7c6340 (2026-10-19).

— *Rejected:*
- staying on v0.1.0 until T01 and reading R30 spec online: a session reads the documents of `spec` of the version the repository refers to (R21 spec), and a citation of R30 spec would not be checked against the submodule;
- v0.2.0, the first automatic release (R31 spec), or v0.2.1 and v0.2.2: they have R30 spec, but not R32 spec and `docs-check-repo`, and rule 6 would stay a check by hand;
- leaving the devcontainer as at v0.1.0 or carrying the changes over selectively: the container of `.github` is the container of `spec` (CLAUDE.md, Environment), and a difference of it would have to be recorded as a decision, and there is no reason for a difference;
- examples of citations in guillemets, as before: `docs-check` checks a number in guillemets against the log, and R32 spec rejected not checking them.

— *Consequence:* T03 goes before T01 in table 1. The section Environment of the repository template's CLAUDE.md still says "Until a check of the documents reaches this repository…": this is a question to the repository template, and it is in table 3 of RUN.md «в реестр spec». — RUN.md, T03 and T01; CLAUDE.md; README.md; CONTRIBUTING.md; `profile/README.md`; `.devcontainer/`; architecture 1, 2.1.

— *Amendment 2026-10-19:* `.github` is on `spec` v0.2.4 (R02). The question to the repository template from the "Consequence", В1, is decided in v0.2.4, and the row left table 3. The rest of what is said above about v0.2.3 is the history of this move.

**R02. `.github` is on `spec` v0.2.4: the submodule `spec/` is at this tag, the links to `spec` pinned to a tag name it, and what came from the repository template is as in the repository template of v0.2.4.**
- **What the tag brings to `.github`** (`git diff v0.2.3 v0.2.4` in `spec/`, read 2026-10-19; the edits are by the report of T03, T18 `spec`, «Дополнено»):
  - the repository template's CLAUDE.md, Environment, names `just -f spec/justfile docs-check-repo`, and leaves the check by hand for a tag of `spec` older than this check. This is the answer to В1 from T03;
  - repositories 1, 2.1, 2.2 and 3 spec (in 2.2 — step 5): all repositories take the shared CI checks from `.github`, `spec` too, even before code (R30 spec); the justfile, the language checks and the signed releases come with code. Before, 2.1 and 3 said «Общие workflow из `.github` берут все репозитории с кодом», 1 — «justfile, CI и подписанные релизы приходят с кодом», and step 5 in 2.2 — «CI — общие workflow из `.github`, когда появится код». Step 5 now names Dependabot too: «CI — общие проверки из `.github` и Dependabot, ещё до кода».
- **What is changed here:**
  - `spec/` is at v0.2.4, commit fe7349b. The links to `spec` in README.md and `profile/README.md` and the tag in CLAUDE.md and RUN.md are v0.2.4;
  - CLAUDE.md, Environment, is as in the repository template of v0.2.4; the row В1 left table 3 of RUN.md;
  - architecture 1 and CLAUDE.md — Your role and The component — say who takes the shared checks, by repositories 1, 2.1 and 3 spec, and T01 names repositories 1, 2.1, 2.2 and 3 spec in its «Разделах»;
  - `.devcontainer/` did not change in v0.2.4: it matches what the recipe of `spec` v0.2.4 builds for `.github`. The move brings in no differences from the repository template.

— *Why now:* before T01. Who calls the shared workflows is its question, and at v0.2.3 repositories 3 spec answered "all repositories with code", although R30 spec connects them in `spec` too. At v0.2.4 repositories spec agrees with R30 spec. The card architecture 3.11 spec still names as shared only Go, TypeScript, the signed release and the license check: T02 checks it against the decision of T01. v0.2.4 is the newest release of `spec` as of 2026-10-19 (`gh release view v0.2.4 -R altnovatrail/spec`: immutable, Latest), confirmed by an attestation: `gh release verify v0.2.4 -R altnovatrail/spec` — "Release v0.2.4 verified!", the tag is on commit fe7349b.

— *Rejected:*
- T01 on v0.2.3: in repositories 1, 2.1 and 3 spec it would read the old "only repositories with code", and docs-check-repo would not notice this — the numbers of the sections are the same;
- taking both edits in T01, without a task of their own: a repository moves to a new tag by a task of its own (RULES.md, Across repositories);
- correcting CLAUDE.md, Environment, in our own words before the tag: CLAUDE.md would diverge from the repository template (R01).

— *Consequence:* T04 goes before T01 in table 1, and T01 depends on it and reads repositories 1, 2.1, 2.2 and 3 spec. The point «Открыто» of T03 is closed by this tag as to repositories 3 spec; T02 still checks the card 3.11 spec. — RUN.md, T04 and T01; CLAUDE.md; README.md; `profile/README.md`; architecture 1.

— *Amendment 2026-10-20:* `.github` is on `spec` v0.2.5 (R06). What is said above about v0.2.4 is the history of this move.

## Shared workflows

**R03. The shared workflows of `.github` are the checks that are the same in all repositories, and the wrappers for code; a repository's own are what only it knows.**
- **Shared before code** — in all repositories, `spec` too: `secrets.yml` — the secrets scan by gitleaks; `dco.yml` — the DCO check; `documents.yml` — `docs-check-repo`, in all but `spec`; `codeql.yml` — CodeQL; `scorecard.yml` — Scorecard. What each one does, who calls it, its inputs, permissions and what it needs from the repository — architecture 3.1.
- **Shared with the first code** — E2 `spec`, with `module-kit`:
  - `go.yml` and `typescript.yml` are wrappers: they build the caller's `toolchain` stage and run its `just` recipes with agreed names, the license check among them. The recipes are the repository's own (R30 spec), the wrapper is shared (architecture 3.11 spec). The list of licenses is one, category A of the ASF policy (R12 spec), the exceptions are the repository's own, each with its own decision;
  - `release.yml` — a signed release without keys, of module packages too (R17 spec).
- **A repository's own** — the CI and release of `spec`, the gate of `sim`, the eval of `modules`, the build of the page of samples of `canvas`, the SDK check of `api`, the test vectors: architecture 3.2. SonarCloud is not a workflow (R30 spec).
- **Where they lie.** The shared ones lie right in `.github/workflows/`, only `on: workflow_call` and without a prefix. The own workflows of `.github` lie there too and start with `self-`. `self-ci.yml` calls the shared ones by the local path, so a pull request checks the version it changes, and runs actionlint (architecture 3.4).
- **The calling files** are the same in all component repositories, but for the input of CodeQL — the repository's languages — and the repository's own jobs; `spec` has no `documents.yml`, and `.github` has its own, with the prefix `self-` (architecture 3.3, 3.4). The files of the components and of `spec` are written by the session of `spec` through `.repos/<name>` (R30 spec), and T17 and T16 `spec` connect them.

— *Why:* the author's decisions of 2026-10-19 in planning T01 — which checks are shared before code, and a Go and TypeScript wrapper over the repository's own recipes. The split into files, the prefix `self-`, the local call in `self-ci.yml` and actionlint are a proposal of the plan, which the author approved the same day. The DCO check by `git log` and the exception for the sign-off of `dependabot[bot]` (architecture 3.1) are a proposal of the executor from the review of T01.
- The checks of R30 spec are the same for all repositories, and five of them are built the same way in all; what the repositories differ in — the languages for CodeQL — comes as an input. A copy in thirteen repositories is thirteen edits for each change, and a shared workflow is one, which Dependabot carries around by itself (R04).
- `docs-check-repo` is the same in all but `spec` (R32 spec): it needs only the `toolchain` stage and the submodule, and all have them from the repository template.
- The card names Go and TypeScript as shared (architecture 3.11 spec), and R30 spec names the language checks a repository's own. The wrapper reconciles the one with the other: what to check, the repository knows, and how to build the image and run the recipe is the same for all. This is how the CI of canvas-api is built: each of its jobs calls a recipe `ci-*` in the toolchain image (R49 canvas-api).
- A file per check, not one for all: CodeQL and Scorecard have their own triggers and permissions, and Scorecard with publishing requires a job of its own without extra steps (architecture 4). Each check is its own name in the ruleset.
- GitHub does not support subfolders in `.github/workflows/` (architecture 4), so the own workflows are told from the shared ones by name.

— *Rejected:*
- one shared workflow with all the checks — for the reason above;
- a copy of Scorecard in each repository right away: it stays the fallback path, if the Scorecard server does not accept the shared one (architecture 2.2);
- `docs-check-repo` as a job of its own in each repository — twelve identical copies;
- the language checks wholly a repository's own, as R30 spec reads — six repositories on Go (`module-kit`, `learner-model`, `engine`, `sim`, `tutor`, `api`) would write the same thing;
- deciding everything about code only in E2: the direction for code does not depend on the exact inputs, and T17 `spec` waits for an answer now;
- the templates `workflow-templates/` in place of shared workflows — the copies would diverge, and they would have to be updated in each repository by hand;
- required workflows through a ruleset of the organization — the Free plan has none (R30 spec).

— *Consequence:* T17 `spec` connects the five shared checks in `spec` and `module-kit`, T16 `spec` in the other repositories. The next epic of `.github` writes the files. The card 3.11 spec names as shared only the workflows for code — T02 will check it against this decision. — architecture 1, 3.1–3.4; RUN.md, T01.

— *Amendment 2026-10-19:* "E2" in the "Rejected" above is the epic E2 of `spec`, «Формат модуля v0». The own epics of `.github` from T02 are E2 «Общие проверки» and E3 «Общие workflow для кода» (RUN.md, table 2): E3 writes the workflows for code together with the epic E2 of `spec`.

— *Amendment 2026-10-20:* the check of the card that the "Consequence" gave to T02 is done: by the row В4, `spec` rewrote the card 3.11 in v0.2.6 — it names the checks before code as shared too, — and repositories 6 spec and the epic E2 in RUN.md `spec` say that the workflows for code come with the first code of `module-kit` (R07). The row В4 left table 3 of RUN.md.

— *Amendment 2026-10-20:* the shared checks were connected by T17 `spec` — in `spec` and `module-kit` — and by T16 `spec` — in `tutor`. The nine others will be connected by T21 `spec`, after each moves to the tag (the amendment to R30 spec; R13). This is how the words of the "Consequence" about T16 `spec` read too. — architecture 1, 3; RUN.md, T12.

— *Amendment 2026-10-21:* in v0.2.11 `spec` split the workflows for code by the code they are checked on — this is the answer to В14 (R14). The Go wrapper and the release come with the first code of `module-kit`, and the TypeScript wrapper with the first code in TypeScript, at `canvas` (architecture 3.11 spec; repositories 6 spec). This is how "Shared with the first code — E2 `spec`, with `module-kit`" at the start of the entry and the amendment about the check of the card read: `typescript.yml` is the epic E5 of RUN.md. T21 `spec` connected the shared checks to the nine others too, so `spec` and all eleven component repositories call them (the amendment to R30 spec); what is said in the amendment above about T21 is history. — architecture 1, 3, 3.1, 3.3; CLAUDE.md; README.md; RUN.md, T17.

— *Amendment 2026-10-21:* the Go wrapper is checked not by the first code of the format of `module-kit` but by the scaffold of its CLI — the author's decision of 2026-10-21 (R16; T10 module-kit, R04 module-kit). At the author's request, the session of `.github` made the scaffold, in a temporary clone of `module-kit`. This is an exception from RULES.md, Across repositories: "a session changes neither spec nor any other repository from where it works", — and from R30 spec: the CI files of the component repositories are written by the session of `spec`, through `.repos/<name>`. The merge and the ruleset of `module-kit` are the author's. The calling files now differ by the kind of the repository too: the kind go has the job "Go" and the ecosystem `gomod` (R16). What is said above about the first code of `module-kit` as the check of the Go wrapper is history; the shared release (T16) is still checked by the first release of `module-kit`. — RUN.md, T15.

**R04. The shared workflows come out as releases of `.github`, as `spec` does: a release comes out by itself after a green CI on `main` — the next patch, the tag together with an immutable release. The callers pin the shared workflows by a SHA with a comment of the version, and Dependabot raises them.** Which commits get a release is decided in architecture 2.4; how it is built is architecture 3.5.

— *Why:* the author's decision of 2026-10-19 in planning T01.
- Dependabot raises a reference to a reusable workflow together with the comment of the version if the commit has a tag; without a tag it moves the reference to the latest commit (architecture 4). A release on the model of R31 spec sets the tag itself, after a green CI, and it cannot be forgotten.
- Pinning by a SHA keeps the rule Exact versions: the organization's requirement to pin actions by a SHA does not apply to references to reusable workflows (architecture 4).

— *Rejected:*
- the SHA of the head of `main` without tags: Dependabot would raise the reference to the latest commit without a version number, and the reference would not show what changed;
- tags by hand — R31 spec rejected them: a tag can be forgotten or set on a commit with a red CI.

— *Consequence:* `.github` has its own `self-release.yml`, a ruleset of the tags `v*` and immutable releases, as `spec` has. Which commits get a release, how the number is counted and whether references to `.github` need the `cooldown` pause are the open points of architecture 2.4–2.6. — architecture 3.4, 3.5.

— *Amendment 2026-10-20:* the points 2.4–2.6 were decided by R10, the task T09: only a commit that changes a shared workflow gets a release, the number is counted by the functions of `version.mjs` from the submodule along the line `0.1`, the pause is three days. The immutable releases and the ruleset `v-tags` of `.github` were set 2026-10-20. — architecture 3.5; RUN.md, T09.

— *Amendment 2026-11-08:* **the caller's Dependabot raises all references to the shared workflows of `.github` in one pull request: in the template `dependabot.yml` of architecture 3.3, the ecosystem `github-actions` has the group `shared-workflows` with `patterns: ["altnovatrail/.github/*"]`.** The task T45, by Д88 in RUN.md `spec`.
- **Why.** Without the group there is a pull request per file, five at a caller with five shared checks: five rebases and five rounds of CI. And by default there are no more than five open pull requests with version updates: "If five pull requests with version updates are open, no further pull requests are raised until some of those open requests are merged or closed" (the Dependabot reference, `open-pull-requests-limit`, read 2026-11-08; architecture 4). A reference beyond them would wait until the earlier ones were merged. The references go to one release of `.github` anyway, and in one pull request they will stay on it.
- **What holds the group.** The name of a reference in dependabot-core is `altnovatrail/.github/.github/workflows/<file>.yml`, and the `*` of the pattern matches any characters, `/` too. The pause of three days (R10) holds the group as well: an update of the group checks each reference with the same `cooldown` (architecture 4).
- **The price.** A reference cannot be held back apart from the others. A release that came out later than its commit is held back whole, as before (R23).
- **Rejected:** a group for the whole ecosystem `github-actions`, `patterns: ["*"]`. Actions of other owners come out in their own releases and break in their own ways, and one red pull request would hold them all together with the references to `.github`.

`.github` itself has no group: its own workflows call the shared ones by the local path, and Dependabot does not raise such a reference. The session of `spec` brings in the group at the callers (the 2026-10-21 amendment to R30 spec). — architecture 3.3, 3.5, 4; RUN.md, T45.

**R05. The shared workflows take no secrets, and a job with a secret does not run code from a fork. Where the key for eval lies is decided together with eval at stage 2.** How it is built is architecture 3.6.

— *Why:* the author's decision of 2026-10-19 in planning T01, by the open point of R24 spec. That a job with a secret fails on a pull request from a fork rather than being skipped, and the reservation about the pull requests of Dependabot, are a proposal of the executor from the review of T01; the author reads T01 line by line.
- A pull request from a fork gets no secrets (R30 spec). So a job with a secret on it either does not run or requires `pull_request_target`, and that runs the workflow with secrets and write permission (architecture 4). A shared workflow without secrets has nothing to leak.
- A skipped job counts as a success for a required check (architecture 4). So a job with a secret fails on a pull request from a fork rather than being skipped: otherwise the change would be merged, and the job would never have passed.
- A pull request of Dependabot gets no Actions secrets either, only Dependabot secrets (architecture 4). This does not hinder the shared checks, and a job with a secret settles it together with itself.
- Eval is needed from stage 2 (repositories 4 spec), and one of the options for the place of the key — the Secret Manager of `infra` — waits for the code of `infra`, which will appear after П-11 (architecture 3.11 spec).

— *Rejected:*
- `pull_request_target` for eval on a pull request from a fork;
- deciding the place of the key now. A secret of `modules` would keep a long-lived key in GitHub earlier than it is needed, and the Secret Manager of `infra` through Workload Identity Federation depends on `infra`, which has no code yet.

— *Consequence:* the rule for forks decides part of the open point of R24 spec, and it concerns all repositories with jobs that need a secret. So both the rule and what is left of the point — the place of the key and the pull requests of Dependabot at eval — go as a row of table 3 of RUN.md «в реестр spec». — architecture 3.6; R24 spec.

— *Amendment 2026-10-20:* `spec` recorded the rule for forks as an amendment to R24 spec, for all repositories, and the place of the key for eval and the pull requests of Dependabot at eval as the question Т-28 (v0.2.6, R07). The row В3 left table 3 of RUN.md.

## The `spec` tag — continued

**R06. `.github` is on `spec` v0.2.5: the submodule `spec/` is at this tag, the links to `spec` pinned to a tag name it, and what came from the repository template is as in the repository template of v0.2.5.**
- **What the tag brings to `.github`** (`git diff v0.2.4 v0.2.5` in `spec/`, read 2026-10-20): nothing that would change its documents or files. v0.2.5 has the answers to the questions of `spec` itself (В7, В8, В11, В12 and В19 in its RUN.md): the vocabulary, the cards 3.1, 3.5, 3.10, the rows of `infra` in 3.11 and 3.12, Т-7, Т-15, Т-17, the amendments to R11 spec and R32 spec. The part of the card 3.11 spec about `.github`, RULES.md, `repo-template/` and `.devcontainer/` are the same. Of what `.github` cites, these changed: architecture 3.11 spec — the rows of `infra`; architecture 3.12 spec — the domain of the widgets; repositories 8 spec — the rows Т-7, Т-15 and Т-17; the vocabulary concepts spec; R11 spec and R32 spec — by amendments about Т-7 and about Д2 `spec`; the row of the epic E2 in table 2 of RUN.md `spec` — T01 and T02 `module-kit` go at the same time as the epic, not before it. None of these edits changes what `.github` says about them: the epic E3 goes together with E2 `spec` and the first code of `module-kit` anyway.
- **What is changed here:** `spec/` is at v0.2.5, commit 5ac51d3. The links to `spec` in README.md and `profile/README.md` and the tag in CLAUDE.md and RUN.md are v0.2.5. Environment in CLAUDE.md, «Как пользоваться» in RUN.md and `.devcontainer/` match the repository template and the recipe of v0.2.5. The move brings in no differences from the repository template.

— *Why now:* the author's decision of 2026-10-20 — «реши тех. долги»: to close Д2 now, not in planning E2, and not to wait for a tag that has something new for `.github` and where В3–В5 are already recorded, as Д2 proposed. Closing it before the epic E2 is cheaper than remembering it: E2 will start from the latest tag of `spec`. v0.2.5 is the newest release of `spec` as of 2026-10-20, immutable (`gh release view v0.2.5 -R altnovatrail/spec`); `gh release verify v0.2.5 -R altnovatrail/spec` confirmed it by an attestation, the tag is on commit 5ac51d3.

— *Rejected:* staying on v0.2.4 until a tag with the answers to В3–В5. `spec` does not have them yet, and when they appear, a task of its own will move to the new tag anyway; v0.2.5 without them closes Д2 now.

— *Consequence:* Д2 is closed, and with it Д1 — the rebuilt container was checked in the same task (RUN.md, T05). — RUN.md, T05; CLAUDE.md; README.md; `profile/README.md`.

— *Amendment 2026-10-20:* `.github` is on `spec` v0.2.6 (R07). What is said above about v0.2.5 is the history of this move.

**R07. `.github` is on `spec` v0.2.6: the submodule `spec/` is at this tag, the links to `spec` pinned to a tag name it, and what came from the repository template is as in the repository template of v0.2.6.**
- **What the tag brings to `.github`** (`git diff v0.2.5 v0.2.6` in `spec/`, read 2026-10-20) — the rows В3–В6 from T01, T02 and T05, recorded in `spec`:
  - the amendment to R24 spec — the rule of R05 for a job with a secret on a pull request from a fork, for all repositories; the amendment to R30 spec — the open point about forks is closed by it;
  - the card 3.11 spec names the checks before code as shared too, and repositories 6 spec and the row of the epic E2 in RUN.md `spec` say that the workflows for code come with the first code of `module-kit` (R03);
  - Т-27 — what a check of the signature of the shared release verifies (architecture 2.3), with our recommendation; Т-28 — where the key of eval lies and how eval runs on a pull request of Dependabot;
  - T17 `spec` waits for the epic E2 of `.github` — the shared checks and the first release, — takes the `cooldown` pause by 2.6 and the fallback path of Scorecard by 2.2, and checks the result of Scorecard on the server: scorecard-action v2.5.0 only warns when the server refuses. T16 `spec` skips the ruleset of `main` of `.github` if E2 sets it (2.9).

  RULES.md, `repo-template/` and `.devcontainer/` are the same.
- **What is changed here:** `spec/` is at v0.2.6, commit 4e55421. The links to `spec` in README.md and `profile/README.md` and the tag in CLAUDE.md and RUN.md are v0.2.6. Environment in CLAUDE.md, «Как пользоваться» in RUN.md and `.devcontainer/` match the repository template and the recipe of v0.2.6. The rows В3–В6 left table 3, and architecture 1, 2.2, 2.3, 2.9 and 3.6, CLAUDE.md, and the rows E3 and T08 in RUN.md name what `spec` recorded: Scorecard is shared under the condition from the card, 2.3 is Т-27, the key of eval is Т-28. That scorecard-action v2.5.0 only warns when the server refuses, architecture 4 confirms by the primary source. The move brings in no differences from the repository template.

— *Why now:* this is the first task of the epic E2 (RUN.md, T06). Its tasks rest on T17 and T16 `spec`, the card 3.11 and the questions about the signature and the key of eval in the wording that v0.2.6 recorded. v0.2.6 is the newest release of `spec` as of 2026-10-20, immutable; `gh release verify v0.2.6 -R altnovatrail/spec` confirmed it by an attestation, the tag is on commit 4e55421.

— *Rejected:* leaving the rows В3–В6 until the next move. A row «в реестр spec» leaves when the question is recorded in `spec`, and the numbers it got `.github` can cite only at a tag that has them: `docs-check-repo` checks them against the submodule.

— *Consequence:* table 3 of RUN.md is empty; R03 and R05 get amendments about where `spec` recorded their rows. — RUN.md, T06, T08, E3; architecture: status, 1, 2.2, 2.3, 2.9, 3.6, 4; CLAUDE.md; README.md; `profile/README.md`.

— *Amendment 2026-10-20:* `.github` is on `spec` v0.2.9 (R13). What is said above about v0.2.6 is the history of this move.

## Shared workflows — the files

**R08. Secrets, DCO and the documents check are the shared `secrets.yml`, `dco.yml` and `documents.yml`, and `.github` runs them by its `self-ci.yml` by the local path, together with actionlint. The workflows download the checks' tools — gitleaks, actionlint and shellcheck — themselves, by the exact version and sha256 sum written in the workflow's file itself.** What each one does, who calls it, the permissions and the names of the checks — architecture 3.1 and 3.4.
- **`secrets.yml`** — gitleaks 8.30.1 over the whole history of the commit checked, `--log-opts=HEAD`, with `--redact`. The exceptions are the caller's `.gitleaks.toml`, if it has one; it holds `[extend]` with `useDefault = true`, and the check does not accept a file without it.
- **`dco.yml`** — every commit of a pull request but merge commits has the `Signed-off-by` of its author, by name and address; the key of the line in any case, as git reads it. The commits come from git, without the API: between the parents of the pull request's merge commit, `HEAD^1..HEAD^2`. The sign-off `dependabot[bot] <support@github.com>` of the author `dependabot[bot]` is a named exception. On an event without a pull request the check fails rather than passing having checked nothing.
- **`documents.yml`** — `just -f spec/justfile docs-check-repo` in the caller's `toolchain` stage, with the submodule.
- **The names of the checks** are "Secrets / gitleaks", "DCO / sign-off", "Documents / docs-check-repo": the caller's job is named after the check, and the job of the shared workflow after what it runs. `.github` also has "Workflows" — actionlint 1.7.12 over all workflows, with shellcheck 0.11.0, without pyflakes.
- **The devcontainer does not change:** gitleaks, actionlint and shellcheck are only in CI, and there is no difference from the container of `spec` (CLAUDE.md, Environment).
- **CONTRIBUTING.md** says that the sign-off matches the commit's author, and that the GitHub noreply address is set as the address of the commits.
- **A pull request does not weaken its own scan:** on a pull request `.gitleaks.toml` and `.gitleaksignore` are taken from the base, and the comments `gitleaks:allow` have no effect. The Dependabot exception in DCO holds only in a pull request that `dependabot[bot]` opened, and for a commit whose committer is GitHub.
- **Licenses:** gitleaks and actionlint are MIT. ShellCheck is GPL-3.0: it is a CI tool, it ships nowhere and puts none of its own code into what ships, so it comes in as a named exception (RULES.md, Licenses; the amendment to R12 spec).

— *Why:* the author's decisions of 2026-10-20 in planning E2 (RUN.md, the epic E2): the data of a shared workflow is in the file itself (architecture 2.7), and that the checks fail where they must is checked by a trial pull request. The make-up of the files, the names of the jobs and `.sonarcloud.properties` without `spec/**` are a proposal of the plan of the epic, which the author approved the same day.
- The version and the sum in the file itself — an edit of the data is an edit of the shared workflow: it gives a release (architecture 2.4), and the caller gets the tool of the version it is pinned at.
- The releases of gitleaks have no signature, only `checksums.txt` (architecture 4): the sum pinned in the file keeps the archive from being swapped after it was read.
- DCO by git, not by the API: a list of commits through the API would need permission to read pull requests, and `contents: read` is enough for git. The strict check by name and address and the Dependabot exception are by its sign-off in commit c6b3cb5 of `spec` (architecture 3.1).
- gitleaks with the default configuration finds a key of the generic kind, and the history of `.github` is clean: a local run 2026-10-20 — the rule `generic-api-key` on a trial key, "no leaks found" on `.github`.
- Without `--log-opts` gitleaks reads all branches (architecture 4): the branch of a trial pull request with a fake key would turn every run red until it was deleted. A file of exceptions without `useDefault` would silently leave the check without rules.
- The range of DCO comes from the merge commit itself, not from the event: a rerun after the base moved ahead reads only the pull request's commits. The review of T07 found this and all of the above.
- The runner's shellcheck is a version nobody pinned (RULES.md, Exact versions only); shellcheck has no file of sums, so the sum is of the archive downloaded 2026-10-20. Pinned are the analysers whose output is the result of the check. The runner's base tools — git, curl, tar, docker — are part of the image `ubuntu-24.04`, as in the CI of `spec`.
- Exceptions that a pull request brings itself, and a commit author whom anyone can set, would let a pull request pass the check without passing it: the review of T07, round 2.

— *Rejected:*
- gitleaks-action — its license is not open, and it needs a key (R30 spec);
- gitleaks through `go run`, as in canvas-api (R49 canvas-api): there is no Go by exact version either on the runner or in the `toolchain` stage;
- images of gitleaks and actionlint by digest: an image registry is one more dependency, and both tools have a release archive with a sum;
- gitleaks and actionlint in the devcontainer — a difference from the container of `spec` that would have to be recorded as a decision, with no need: CI checks;
- DCO through the pull request API — permission to read pull requests beyond `contents: read`; the range from the pull request event — it does not take into account that the base moved ahead;
- shellcheck and pyflakes that are on the runner — their versions are not pinned;
- `.gitleaks.toml`, `.gitleaksignore` and `gitleaks:allow` from the pull request itself; the Dependabot exception by the commit's author alone.

— *Consequence:* CodeQL and Scorecard are T08; the ruleset of `main` will list these names of checks — T10. — architecture 2.7, 3.1, 3.4, 4; CONTRIBUTING.md; RUN.md, T07.

— *Amendment 2026-11-08:* **the documents check `documents.yml` is run by the script `spec/tools/toolchain/toolchain.sh` of the caller's submodule — `build`, then `spec docs-check-repo`, — not by a `docker run` of its own. A submodule without the script, older than v0.2.17, stops the step and names the reason.** The author's decision of 2026-11-08 by Д5 in RUN.md.
- **Why.** How the stage is built and how a recipe runs in it is decided by `spec`, in the submodule's script, at each caller at its tag — this is how `ci.yml` of `spec` and the shared release run recipes since T25 (the 2026-10-21 amendment to R31 spec). A copy of its own in the step would lag behind the edits of the script, and the documents check would get them by hand (Д5).
- **Why now.** The condition of Д5 — all callers on v0.2.17 or newer — is not met: `infra` is on v0.2.9. But `infra` calls `documents.yml` by the SHA of `v0.1.0`, and a release with the script will not touch its `main`. Only a pull request of Dependabot that raises its references will be red, until it moves to `spec` v0.2.17 or newer, and `infra` holds such a pull request back itself, like a release that came out later than its commit (R23). No row of COORDINATION.md `spec` has a next step of `infra`.

*Rejected:*
- waiting for `infra`, as the author decided 2026-10-22: the condition would keep the debt with no deadline;
- the script for those who have it, and a `docker run` of its own for the rest: two paths in one shared workflow, which the author rejected 2026-10-22.

Consequence: a caller moves to `spec` v0.2.17 before it raises its reference to a release with this edit (architecture 3.1). — architecture 3.1, 4; RUN.md, Д5.

— *Amendment 2026-11-10:* **the step "Documents" of `documents.yml` is split: "Toolchain image" checks the submodule's script and builds the stage by `toolchain.sh build`, and "Documents" runs the recipe; between them are the cache steps of R36.** The task T53. What is said above about one step is history; the reason a step without the script fails, and its text, are as before.

**R09. CodeQL and Scorecard are the shared `codeql.yml` and `scorecard.yml`, and `.github` calls them by its own `self-codeql.yml` and `self-scorecard.yml` by the local path.** What each one does, who calls it, the permissions and the names of the checks — architecture 3.1 and 3.4.
- **`codeql.yml`** — advanced setup: the language `actions` always, and the repository's languages by the input `languages`, separated by a space, a comma or a line. For now the input takes only `javascript-typescript`, and another language stops the check with the reason. The list is assembled by the job `languages`, in bash, and each language is in it once. The analysis is a job per language: `build-mode: none`, `tools: linked`, the suite `security-extended`, `category` — `/language:<language>`. The checks are "CodeQL / languages" and "CodeQL / analyze (<language>)"; the analyses hold the merge.
- **The findings of CodeQL** are not held by the check of the analysis: it is green if CodeQL passed, even when it found a vulnerability. They are held by the ruleset rule `code_scanning`, as in R50 canvas-api, or by the required check "CodeQL" from GitHub Advanced Security, which code scanning puts on a pull request itself (architecture 4). The ruleset rules of all repositories are set by R30 spec — this is the row В7 of RUN.md «в реестр spec».
- **`scorecard.yml`** — Scorecard with publishing of the results and SARIF into code scanning; the job has only approved actions, without scripts of its own. The check "Scorecard / scorecard" does not hold the merge (R30 spec).
- **The callers** are `self-codeql.yml` on a pull request and a push to `main`; `self-scorecard.yml` on a push to `main` and once a week, without `env` and `defaults`, with only read permission at the top.

— *Why:* R03 and the author's decisions in planning E2. The make-up of the files is a proposal of the plan of the epic, which the author approved 2026-10-20; what the review of T08 changed in it is below.
- `actions` always runs: every repository has workflows, and it is enough for the caller to name its own languages. The list is assembled by the job, not by the caller, — so `actions` is not lost, whatever the caller passes. The runner's jq is not needed: bash assembles the list.
- Only `javascript-typescript`: the platform's code is in Go and TypeScript (R03), and CodeQL does not parse Go without a build (architecture 4). At canvas-api it runs with `build-mode: manual` and `go build` (R50 canvas-api, `codeql.yml`), and the build will come with the workflows for code, in E3.
- "CodeQL / languages" must not be required. The trial pull request #9 passed `go`: the job `languages` failed with the reason, and for the analyses GitHub sent one skipped check "CodeQL / analyze (${{ matrix.language }})". "CodeQL / analyze (actions)" did not come at all, so a required analysis holds the merge anyway, and "CodeQL / languages" names the reason.
- `tools: linked` is the CodeQL bundle that the pinned commit of the action was released with, for v4.39.0 — 2.27.2. Without this input the bundle is chosen by GitHub's flags at the time of the run (architecture 4), and the same commit of `.github` would analyse with another version, and versions are only exact (RULES.md, Hard rules). This is also why `self-codeql.yml` has no weekly run: on unchanged code it would repeat the last analysis. New queries come with the pull request that raises the action, and CodeQL runs on it.
- `category` is explicit: CodeQL builds the default category from the name of the workflow's file and the values of the matrix (architecture 4), and an explicit one does not change if the calling file or job is renamed or replaced by a copy of its own. A language keeps one analysis, and there will be no abandoned old one.
- `security-extended` — as at canvas-api (R50 canvas-api).
- The restrictions of Scorecard for publishing are on the job and the workflow themselves (architecture 4), so `scorecard.yml` has not a single step of its own.

— *Rejected:*
- an input with the full list of languages, `actions` included — the caller could forget `actions`;
- `build-mode: none` for any language — Go is not parsed that way, and the caller would learn this from someone else's error;
- CodeQL without the input `tools` — the bundle would change without an edit in `.github`; a weekly run of CodeQL — with `tools: linked` it would repeat the last analysis;
- "CodeQL / languages" among the required — the merge is held without it, and the ruleset of each repository would get an extra name;
- the default setup of code scanning — it turns off a repository's own CodeQL workflow (T15 spec);
- Scorecard on a pull request — the action supports push and a schedule on the main branch, and its `pull_request` is experimental (R30 spec).

— *Consequence:* whether the server accepts the result of `self-scorecard.yml` — the first step of architecture 2.2 — is seen after the merge to `main`. — architecture 2.2, 3.1, 3.3, 3.4, 4; RUN.md, T08.

— *Amendment 2026-10-20:* the first step of architecture 2.2 is passed. After the merge of T08, `self-scorecard.yml` passed on `main`, run 39366831518, and the Scorecard API returns a result for the commit of `main` 53b829f: `date` — 2026-10-20T03:55:38Z, `score` — 5.4. There is no warning "Unable to POST" in the run's log. The server accepted the result, although the caller's job has `uses:` and `id-token: write`: a calling file with them does not hinder it. The second step is the first call from another repository, T17 spec. CodeQL on `main` — the analysis `/language:actions`, CodeQL 2.27.2, no findings. — architecture 2.2; RUN.md, T08 and T09.

— *Amendment 2026-10-20:* the findings of CodeQL at `.github` are held by the ruleset rule `code_scanning` — CodeQL, the thresholds `errors` and `high_or_higher` (R12, the answer to В7). What is said above about the choice between the rule and the check "CodeQL" is history. For the other repositories `spec` records the choice, by the row В7 of RUN.md. — architecture 3.1; RUN.md, T11.

— *Amendment 2026-10-20:*
- `spec` recorded В7 in v0.2.7, as an amendment to R30 spec: the findings of CodeQL are held by the rule with the same thresholds in all repositories. The row В7 left table 3 of RUN.md (R13).
- The second step of architecture 2.2 is passed in T17 `spec`: the Scorecard server accepted the result of the shared `scorecard.yml` at `spec` and `module-kit`, and then at `tutor` too (architecture 2.2; R13).

— RUN.md, T12.

— *Amendment 2026-10-20:* by the debt of `spec` about the prototype (Д8 in RUN.md `spec`), the task T14. `codeql.yml` got the input `paths-ignore` — the paths that CodeQL does not read, one per line.
- The job `languages` assembles from them one line of YAML, `paths-ignore: [...]`, where each path is a JSON string. YAML reads such strings as double-quoted scalars, so a path that starts with `*` or holds a colon stays a string. Empty lines and the spaces around a path are dropped, and a control character in a path stops the check.
- `init` gets this line as the input `config`; without paths there is no configuration.
- Only the analyses of the caller's languages get the configuration — here `javascript-typescript`. The analysis of `actions` does not get it and reads all workflows: so "`actions` is not lost, whatever the caller passes", as said above. The Actions extractor would take the paths into account (architecture 4), and then `vendor/**` would silently remove from the analysis the composite actions in this folder too. All the code of a language cannot be removed by paths: then the analysis of that language fails (architecture 3.1, 4).
- A line that starts with `#` is a comment. The check is stopped by a comma anywhere, a `#` after a space or a tab, `- ` at the start and a quotation mark at the edges: in a block of lines each of them would end up inside one pattern, and the path would match nothing. A space inside a path is allowed — the prototype of `spec` is named so too. A control character stops the check as well: it would break the YAML that `init` reads.

**Why so.** `spec` needs to exclude `draft/` — the prototype that a design tool built — as it is already excluded from SonarCloud (R33 spec). Without the input, its findings would hold up a pull request by the rule `code_scanning` (the amendment to R30 spec).

**Rejected:**
- an input with the path to a configuration file — each caller would get one more file for the sake of one list;
- the lines of the paths right in the YAML through `${{ }}` — YAML would read a path with an asterisk at the start as an alias;
- reading the paths on a pull request from the base, as `.gitleaks.toml` (R08), — or taking from the input only the paths that are already in the base version of the calling file. This is a deliberate exception from the rule of R08 "A pull request does not weaken its own scan": a pull request that adds its folder to `paths-ignore` skips the analysis of this folder. Why this is acceptable:
  - the input lies inside a boundary that only the review guards anyway. A pull request that changes `.github/workflows/` can get around any shared check — for example, name in `uses:` its own copy of the workflow. `.gitleaks.toml` lay outside this boundary, and `paths-ignore` lies inside it;
  - the review here is the author's own reading: the project has one, and the ruleset requires no approvals (R30 spec);
  - `spec` asked for exactly an input (Д8 in RUN.md `spec`). Taking its value from the base would mean parsing the YAML of the calling file for the sake of one input, and the boundary would not close from this.

**Trials** — pull requests #19 and #20, both without a merge (architecture 4). In #19, with the input, the JavaScript analysis gave 0 results, and without the input it found `js/xss` in `trial/sample.html`, and the check "CodeQL" turned red. In #20, already with the configuration only for the caller's languages, the `actions` analysis got no configuration, and JavaScript again gave 0 results. — architecture 3.1, 3.3, 4; RUN.md, T14; `codeql.yml`.

— *Amendment 2026-10-21:* by T19 the shared `codeql.yml` takes `go`. The Go analysis runs with `build-mode: autobuild`: with an explicit mode the analyze step builds the database itself. The Go for the build is the one in the caller's `toolchain` stage: the job builds the stage, copies `/usr/local/go` onto the runner ahead of the runner's own Go and sets `GOTOOLCHAIN=local`. So the analysis runs with the same Go as the checks of `go.yml` (R16), from the archive that the caller's Dockerfile checked against its sum. The trial pull request #30, without a merge, showed the finding go/command-injection, and without it a clean analysis (architecture 4). Together with Go, its variables `GO*` and `CGO_*` move over from the image, and the Go analysis gets no `paths-ignore`: CodeQL reads a compiled language by its build. Autobuild of Go first runs a Makefile or `build.sh` from the root, if there is one, on the runner; should such a file be needed, the Go analysis will need the mode `manual`. What is said above, "Only `javascript-typescript`", is history. *Rejected:* `actions/setup-go` by `go.mod`, and the runner's Go, which switches by `go.mod`. A library's `go.mod` names a lower bound — `module-kit`'s says `go 1.27.0` — and not the pinned Go 1.27.3, and the archive is then not checked against the caller's sum. Also rejected is `build-mode: manual` with a build command of its own: it would need one more shared recipe, and autobuild copes with Go. — architecture 3.1, 3.3, 4; RUN.md, T19.

— *Amendment 2026-11-08:* in `.github` itself CodeQL reads Go too: `self-codeql.yml` gives the shared `codeql.yml` `languages: go`, since T48 has given `.github` Go code — the tool `tools/coderules/` (R33). The nested `go.mod` of the controls in `testdata/` did not get in the way of Go's autobuild: "CodeQL / analyze (go)" on pull request #103 is green (architecture 4). In the ruleset of `main` of `.github` this check is added by a step of the author, after the first analysis on `main` (R11). — architecture 3.4; RUN.md, T48.

**R10. A release of `.github` is `self-release.yml` on the pattern of `spec`'s `release.yml`: a release goes only to a commit that changes a shared workflow, the number is worked out by the functions of `version.mjs` from the submodule on the line `0.1`, and Dependabot waits three days — both in `.github` and in the callers.** How it is built — architecture 3.4 and 3.5.
- **Which commits get a release (2.4)** — a commit of `main` in which a shared workflow has changed since the last release: a file of `.github/workflows/` without the prefix `self-`. The first release always comes out. The profile, the community files, its own `self-` workflows and the documents give no release: `self-release.yml` checks `git diff` against the last release. A file that a shared workflow will read from `.github` — the license list by 2.7, in E3 — will enter this check together with it.
- **The number (2.5)** — the functions `readLine`, `readTags` and `nextVersion` from the submodule's `spec/tools/release/version.mjs`, and they read `RELEASE_LINE` from `self-release.yml` itself: the line `0.1`, the first release `v0.1.0`. The rules of the number are the same as `spec`'s (R31 spec): the next patch of the line, and a commit with a release and a commit older than the newest release get nothing.
- **The mark Latest** — on every release, and not only on the tip of `main`, as in `spec`.
- **The button** releases the tip of `main` if it has no release and a shared workflow has changed since the last release. A raised `RELEASE_LINE` gives no release by itself: the new line will start with the next change of a shared workflow.
- **The number is worked out on every green commit of `main`**, even without a release. So a change that breaks this step — for example, a new tag of `spec` in which `version.mjs` no longer exports what is needed — turns Release red on the commit that brought it. A pull request does not run this step.
- **The differences from `spec`'s `release.yml`**, besides what is said: the steps run with `pipefail` — without it a failed `git ls-remote` would leave the tip empty; a refusal of the Releases API to a commit that is no longer the tip is skipped with the response 403 too, and not only 404 (architecture 4); an error of `git diff` is not taken for a change; a tag without a release is checked at the last release too, from which `git diff` is counted, and the tip is read after a refusal, not before. What of this `spec` needs too is row В9 of RUN.md, «в реестр spec».
- **The pause `cooldown` (2.6)** — three days, as for everything, the callers' references to `.github` included. T17 and T16 of `spec` add it to the callers' `dependabot.yml`. The `dependabot.yml` of `.github` itself is `github-actions` in `/` and `docker` in `/.devcontainer`, once a week, `cooldown` 3 days. The pause does not hold the base image: Microsoft's registry does not report the release date, and Dependabot proposed a new image at once — in `spec` and in canvas-api (T15 spec). Whether it holds references to a reusable workflow is not checked: the first raise of a reference in T17 spec will show it (architecture 2.6).
- **The settings of `.github`** — immutable releases and the ruleset `v-tags`: tags `v*` cannot be moved, deleted or rewritten, with no bypass, as in `spec`. Set 2026-10-20, before the merge of T09, with the author's consent (RUN.md, «Как пользоваться», rule 4).

— *Why:* the author's decisions of 2026-10-20 when planning E2 — by the recommendations of architecture 2.4–2.6; how the file is built — the pattern of `spec`'s `release.yml` and the plan of the epic.
- 2.4: a release without changes in the shared workflows would give a pull request of Dependabot in each of the twelve callers — for a workflow that did not change. The number means "the shared workflows have changed".
- 2.5: the same rules of the number and the same tests as `spec`'s, without a second copy. As a command, `version.mjs` reads `RELEASE_LINE` from `spec`'s `release.yml`, next to itself, and the recipe `release-version` of `spec/justfile` lists the tags of `spec`: just runs a recipe in the folder of its justfile — checked on just 1.58.0 of the devcontainer, `just -f <folder>/justfile` with a recipe `pwd` prints that folder. So the functions are imported, and the line comes from its own file. `self-release.yml` repeats the lists of tags and the lines of output after the recipe and the command: if `version.mjs` takes the line from the environment, `.github` will take `spec`'s recipe as it is — row В8 of RUN.md, «в реестр spec».
- Latest on every release: the number of a new release is always the highest — `nextVersion` releases nothing below the newest — and the tip of `main` may by 2.4 remain without a release of its own, and the mark would get stuck on an old one.
- 2.6: a release of `.github` has already passed its CI, where the shared workflows are called by a local path (architecture 3.4), but three days let an error be noticed before twelve pull requests spread it. An urgent change can be raised by hand too.
- The Dependabot of `.github` sees the actions of the shared workflows and of its own, and the base image of the devcontainer. A raised action of a shared workflow comes out as a release, and after it the callers' Dependabot raises the reference (R04). There is no npm ecosystem, as there is in `spec`: `.github` has no packages.
- The checkout of the commit is by `workflow_run.head_sha`, as in `spec`: CI passed on exactly that commit, and the job's condition lets in only a push from the repository itself. Scorecard deems such a checkout in a workflow with `workflow_run` dangerous by the text of `ref` alone (architecture 4). Another way of writing the same `ref` would only hide the pattern from the check, so the file does not work around it.

— *Rejected:*
- a release of every green commit, as in `spec` — pull requests in the callers for unchanged workflows;
- an own copy of `version.mjs` and of the recipe — a second instance of the rules of the number, which will drift from `spec`;
- the recipe `release-version` of `spec/justfile` as it is — it counts the tags and the line of `spec`;
- Latest only on the tip of `main`, as in `spec` — by 2.4 the mark would get stuck on an old release;
- references to `.github` without a pause — twelve pull requests would spread an error before it is noticed.

— *Consequence:* the first release of `.github` is `v0.1.0`, after the merge of T09; the callers will pin its SHA (architecture 3.3, T10). — architecture 2.4–2.6, 3.3–3.5, 4; RUN.md, T09.

— *Amendment 2026-10-20:* the first release has come out: `v0.1.0`, commit `ff2a3597769ca85e59e476b1a41bdcbc1f50e3ed` — the merge of T09, the Release run 39429212586. It is immutable and Latest, and `gh release verify v0.1.0 -R altnovatrail/.github` confirms it. Scorecard on this commit marked Dangerous-Workflow: the checkout by `workflow_run.head_sha` in `self-release.yml`, code scanning finding #9, the check's score 0. This is question В10 of RUN.md, «в реестр spec». Dependency-Update-Tool with `dependabot.yml` is 10. — architecture 3.3; RUN.md, T09 and T10.

— *Amendment 2026-10-20:*
- The checkout of `self-release.yml` is the tip of `main`, and the commit on which CI passed is named only by its SHA (R12, the answer to В10). What is said above in "Why" about the checkout by `workflow_run.head_sha` is history.
- The number is still worked out on every green commit of `main`, but by the files of the tip. So a change that breaks the step turns red the first run that takes it into its checkout: the run of its own commit or of an older one whose CI ended later.
- Whether the pause holds references to a reusable workflow (2.6) has been checked by the sources of dependabot-core — it holds them. For dependabot-core such a reference is a dependency of the `github-actions` ecosystem, and the same code checks the pause for it as for an action (architecture 2.6, 4). T17 of `spec` will only see it. The count runs from the date of the commit under the tag, to the day: the release tag is lightweight. So a release that came out later than its commit gets a shorter pause — that is architecture 2.10, question В13 of RUN.md.

— architecture 2.6, 3.4, 3.5; RUN.md, T11.

— *Amendment 2026-10-20:* `spec` recorded В8 and В9 in v0.2.7, as an amendment to R31 spec. `spec`'s `release.yml` now has `pipefail` and skips 404 and 403. The recipe `release-version` takes a commit and outside `spec` takes the line from `RELEASE_LINE`. The rows have left table 3 of RUN.md (R13); `self-release.yml` will call the recipe in T13.
- The pause of three days in the callers' `dependabot.yml` was added by T17 and T16 of `spec` — in `spec`, `module-kit` and `tutor`; T21 of `spec` will add it to the nine others.
- T17 of `spec` did not see a raise of a reference: there were no pull requests of Dependabot in the callers yet. `v0.1.1` will show it (T14; Д10 in RUN.md of `spec`).

— RUN.md, T12, T13.

— *Amendment 2026-10-20:* by В8 and В9, task T13. The number is worked out by `spec`'s recipe `release-version` as it is, and `self-release.yml` skips a refusal of the Releases API by the rule of `spec`'s `release.yml`.
- **The number.** `just -f spec/justfile release-version <commit>` in the `toolchain` stage. Outside `spec` the recipe takes the line from `RELEASE_LINE`, and `self-release.yml` reads it from the text of its file by `spec`'s script `tools/release/line.mjs` — the same way the recipe reads the `release.yml` of `spec` itself. Through the parsed YAML of `env` the string `0.10` without quotes would come as `0.1`: that is how GitHub parses YAML — "This issue is related to the way we parse yaml … try adding ' around '3.10'" (actions/runner#1989, the answer of a member of the runner team 2022-07-11; there it is a value of a matrix, `3.10` → `3.1`). So the line still comes from the tip's file (R12), but not from the parsed `env`, as the task said; the amendment to R13 is below.
  - The own wrapping — the functions of `version.mjs` and the own lists of tags — is gone. What is said above and in R12 about the functions of `version.mjs` is history.
  - What was rejected above, "the recipe `release-version` of `spec/justfile` as it is — it counts the tags and the line of `spec`", is history too: with the amendment to R31 spec the recipe counts the tags of the repository it is called from.
- **The refusal.** After a refusal `main` is fetched again — `git fetch` without the submodules. A refusal is skipped only if the commit is no longer the tip and adds or changes files of `.github/workflows/` relative to it (`git diff --diff-filter=AM`), as in `spec`. The rest of the "Differences" above — `pipefail`, 403 next to 404, that an error of `git diff` is not taken for a change, and the reading of the tip after a refusal — `spec` has too since the amendment to R31 spec, so these are no longer differences. The argument about `git ls-remote` for `pipefail` is history: the step no longer calls it.

The intended differences from `spec`'s `release.yml` stay (architecture 3.4):
- a release only when a shared workflow changes, and Latest on every release;
- the check of a tag without a release at the last release too;
- the checks of a full SHA and of an ancestor (R12): `spec`'s recipe rejects a shallow clone too, and `.github` checks it earlier, with a clear reason;
- the line from the tip's file (R12).

**The trial.** A local trial of the version step gives the same results as in T11, and reads the line `RELEASE_LINE: 0.10` without quotes as `0.10`. The publication step with a stubbed response of `gh` skips a refusal 404 and 403 only for a commit that is no longer the tip and changes files of the workflows. A refusal to the tip, a refusal without such a difference and another error fail it. — architecture 2.5, 3.4, 3.5; RUN.md, T13; `self-release.yml`.

— *Amendment 2026-10-20:* by В16, task T17. The number is `release-version <commit> .github/workflows/self-release.yml`, the refusal is `spec`'s recipe `release-refusal`; both commands run through the launch script `$RUNNER_TEMP/toolchain`, as in `spec`'s `release.yml`. The wrappings of `.github` — the reading of the line by the script `line.mjs` and the own copy of the rule of refusal — are gone. Of the four intended differences above the last is gone, the line from the tip's file (R12): the line, as in `spec`, now comes from the commit being released. The other three stay, and one has been added to them (architecture 3.4):
- a release only when a shared workflow changes, and Latest on every release;
- the check of a tag without a release at the last release too;
- the checks of a full SHA and of an ancestor;
- a trial of the call of `release-refusal` without running it, `just --dry-run`, on every run. The recipe runs only after a refusal, and a tag of `spec` that renames it or changes the number of its parameters would otherwise surface only then — as a red run that the refusal should have skipped. The trial does not see another order of the same parameters. In `spec` the recipe and its call are changed by one change.

The pause in `dependabot.yml` was added to the nine other callers by T21 of `spec`: their files are from architecture 3.3 (the amendment to R30 spec). — architecture 2.5, 3.4, 3.5; RUN.md, T17.

— *Amendment 2026-10-22:* by В18, task T25. The `toolchain` stage is built, and `spec`'s recipes are run in it, by the script `spec/tools/toolchain/toolchain.sh` from the submodule, and not by an own wrapper `$RUNNER_TEMP/toolchain` — as the 2026-10-21 amendment to R31 spec requires. The number step calls `build`, then `spec --dry-run release-refusal` with the three arguments of the publication step, and `spec release-version`. After a refusal the publication step calls `spec release-refusal`. How the stage is built and how a command runs in it now arrive with the tag of `spec`, and the paths go to docker as arguments.
- The trial of the call stays a difference from `spec`'s `release.yml` (above): there the script, the recipes and their tests are one commit. Its message no longer names the cause — a missing recipe or another number of arguments — but leads to the log: just, the script and docker all write there.
- The script must be in the submodule: otherwise the step of the number names the cause rather than failing on an error of the shell. Its sum is taken before the first container and checked before each next call, as in the shared release (the amendment to R18): the containers get the checkout for writing.
- After the merge of T24 the run on `main` worked out the number by the recipes of v0.2.17 still with its own wrapper (RUN.md, T24). The merge of T25 will run it by `spec`'s script for the first time.

— architecture 3.4, 3.5; RUN.md, T25.

— *Amendment 2026-10-22:* by the author's answer to В24, task T28 (architecture 2.12). The number step runs `spec`'s script from a copy of the checkout, as the shared release does (the amendment to R18). Each container of the script gets for writing the folder the script was run from, `.git` too. So before the first container the step takes a copy — `cp -a` into `RUNNER_TEMP` — and runs the script from there. `git diff` against the last release, `git fetch` after a refusal and the post step of `actions/checkout` read the checkout itself, and no container mounts it (architecture 4).
- The script's sum is taken in the checkout and checked in the copy — before `release-version`, after the container of the trial. What is said above about the sum — "checked before each next call" — is now about the copy.
- After a refusal `release-refusal` runs in a new copy, taken after `git fetch`. The old copy has no new tip, and `git fetch` in it would read a `.git/config` that a container may have changed. No container has seen the new copy, so the publication step no longer checks the sum, and the output of the `toolchain` step is gone.
- Checked locally, on steps taken out word for word, with docker and `gh` stubbed (RUN.md, T28).

— architecture 2.12, 3.4, 3.5, 4; RUN.md, T28.

— *Amendment 2026-11-01:* by R28, task T35. The suite of the steps' tests lies in `tests/`, outside `.github/workflows/`, and gives no release, like the profile, the community files, its own `self-` workflows and the documents. The `git diff` check in `self-release.yml` does not change: it looks only at `.github/workflows/` without `self-*` anyway. A change of a step of a shared workflow and of its cases goes in one pull request, and the release is given by the step, not by the cases. — RUN.md, T35.

— *Amendment 2026-11-08:* a change of the tool `tools/coderules/` gives a release of `.github` too: the shared `go.yml` of its own version reads it, by `job.workflow_sha`, and a change of the tool is a change of what the caller gets (R33). The list of `git diff` of the step "Work out the version" is `.github/workflows/` without `self-*` and `tools/coderules/`, and the cases of the suite hold it (R28). — architecture 3.4, 3.5; RUN.md, T48.

**R11. The ruleset of `main` of `.github` itself is set by epic E2, as in `spec`: the branch cannot be deleted or rewritten, a merge only through a pull request, without approvals, the branch up to date before a merge, no bypass. Required are "Secrets / gitleaks", "DCO / sign-off", "Documents / docs-check-repo", "Workflows", "CodeQL / analyze (actions)" and "SonarCloud Code Analysis".** Set 2026-10-20, ruleset 25477399, with the author's consent (RUN.md, «Как пользоваться», rule 4).
- The checks of GitHub Actions are with `integration_id` 15368, SonarCloud with 12526, as in `spec`.
- "CodeQL / languages" and "Scorecard / scorecard" are not required (R09; R30 spec). There is no rule about the findings of CodeQL in the ruleset: the task that moves `.github` to the tag of `spec` with the answer to В7 of RUN.md will add it.
- The merge methods are merge, squash and rebase, as in `spec`: R30 spec does not name them, and this is the API's default. With squash a new commit lands on `main`, whose message is edited at the merge, and DCO does not read it — this is В11 of RUN.md, «в реестр spec»; `.github` itself merges only by a merge commit.

— *Why:* the author's decision of 2026-10-20 when planning E2 — by the recommendation of architecture 2.9: required checks are named by job, and epic E2 writes the jobs of `.github`. The list is by R30 spec, R08 and R09; "Workflows" is an own job of `.github` (architecture 3.4). So T16 of `spec` skips `.github`: what is decided, it reads here.

— *Rejected:*
- the ruleset in T16 of `spec`, as for the others — `.github` itself knows the names of the checks of `.github`, and until T16 its `main` would stay unprotected;
- "CodeQL / languages" among the required — the merge is held without it too (R09).

— *Consequence:* `main` of `.github` changes only through a pull request with green checks, the author's too. — architecture 2.9, 3.3, 3.4; RUN.md, T10.

— *Amendment 2026-10-20:* the ruleset 25477399 got the rule `code_scanning` — CodeQL, the thresholds `errors` and `high_or_higher` — and of the merge methods only merge is left (R12, the answers to В7 and В11). Both changes were set with the author's consent before the pull request of T11. What is said above, that there is no rule about the findings, and about the three merge methods is history. — architecture 3.3, 3.4; RUN.md, T11.

— *Amendment 2026-10-20:* `spec` recorded В11 in v0.2.7, as an amendment to R30 spec: only merge in all the repositories. The row has left table 3 of RUN.md (R13). — RUN.md, T12.

— *Amendment 2026-11-08:* with the Go code of `.github`, the ruleset of `main` (25477399) also requires "Go / lint", "Go / test", "Go / vuln", "Go / licenses" and "CodeQL / analyze (go)" — with `integration_id` 15368, like the other checks of GitHub Actions — and `codecov/patch` — with `integration_id` 254, as in `spec`. The required checks are twelve in all. The executor set them 2026-11-08, at the author's word, after all six had come to `main` with the merge of #103, f87e8da; the other rules of the ruleset are the same (R33; RUN.md, T48). — architecture 3.4; RUN.md, T48.

**R12. By the author's answers to В7, В10 and В11: the findings of CodeQL hold the merge by the ruleset's rule `code_scanning`, a pull request enters `main` only by a merge commit, and the release takes the tip of `main` into its checkout and names the commit on which CI passed only by its SHA.** The ruleset — architecture 3.3 and 3.4, the release — 3.4. In table 3 of RUN.md, «в реестр spec», lie two things: what of these answers `spec` and the other repositories need, and the answers to В8, В9 and В12. The last three are done by `spec`; what of them `.github` needs — the recipe by В8 and the Dockerfile by В12 — it will take together with the tag of `spec`.
- **The findings of CodeQL (В7)** are held by the rule `code_scanning` in the ruleset of `main` 25477399 — as in canvas-api (R50 canvas-api):
  - the tool — CodeQL;
  - the threshold of findings — `errors`;
  - the threshold of security findings — `high_or_higher`.

  The merge does not pass if CodeQL has found a finding of this level in the pull request, if the analysis is still running or if CodeQL is not set up in the repository. Results are needed both on the commit of the pull request and on the branch it changes (architecture 4); `main` of `.github` has them since T08. The check "CodeQL / analyze (actions)" stays required: it says that the analysis has passed.
- **The merge methods (В11)** — only merge: `allowed_merge_methods` is `merge`. Exactly the commits that the DCO check read land on `main`, and the merge commit, which by R30 spec it skips. The repository's setting `allow_merge_commit` stays on: if the repository has turned off a method that the ruleset requires, the merge does not pass at all (architecture 4).
- **The checkout of the release (В10)** — without `ref`. For `workflow_run` this is the tip of `main` that the event saw — `GITHUB_SHA`; GitHub takes the workflow's file itself from the same commit (architecture 4). The commit on which CI passed, `TARGET`, is named only by its SHA:
  - the check that it is a full SHA and an ancestor of the checkout;
  - the lists of tags;
  - `git diff` against the last release;
  - the release's `--target`.

  The `toolchain` stage, the functions of `version.mjs` and `RELEASE_LINE` are taken from the tip, as are the steps of the file itself.
- **The settings** were set 2026-10-20, before the pull request of T11, with the author's consent (RUN.md, «Как пользоваться», rule 4). The body of the `PUT` is assembled from the `GET` of the ruleset — the whole list `rules` with all its parameters — so the required checks kept their `integration_id`. Without it a status from anyone with write access would close the check (architecture 4). A comparison before and after showed exactly two changes.

— *Why:* the author's decisions of 2026-10-20 on rows В7, В10 and В11 of RUN.md, by their recommendations (RUN.md, T11).
- **В7.** A green check of the analysis says that CodeQL has passed, not that it found nothing (R09). The rule holds the thresholds in the ruleset itself, as in canvas-api, and will not let through a pull request on which there was no analysis.
- **В11.** R30 spec does not name the merge methods, and three methods are the API's default (R11). With squash a new commit lands on `main`, whose message is edited at the merge, and DCO does not read it (architecture 4). `.github` and `spec` do not merge that way anyway.
- **В10.** In a workflow with `workflow_run` Scorecard marks a checkout whose `ref` contains `github.event.workflow_run`: it looks only at the text of `ref` and names the risk "Critical" (architecture 4), and everyone sees the score 0. A checkout without `ref` it does not check. The release does not need a checkout of the CI commit: only `git diff` reads its tree, from the history. And the commit itself is in the history of the tip, because the ruleset does not allow rewriting the history of `main` (R11).
- **The price of В10 is small:**
  - the steps of the release ran from the tip before too: for `workflow_run` the file is taken from `GITHUB_SHA`;
  - a raised `RELEASE_LINE` is a change of a file in `.github/workflows/`. The Releases API will refuse a commit that is no longer the tip (architecture 4), and the release of the tip will cover it;
  - a tip that changed only the Dockerfile or the submodule does not change the number, while the rules of `version.mjs` are the same. If the submodule brought other rules, the number of an old commit whose CI ended later is worked out by them too: the Releases API will not reject such a commit, since the submodule does not lie in `.github/workflows/`. And a broken step on such a tip will turn the run of the old commit red too;
  - one case is loud and rare. One change raises the line, the next one returns it, and the run of an older commit is still in the queue. Then it may come out in the raised line, the following runs will fail on "older than the newest release", and the line is raised again.
- **A local trial** of the step — the same script, only docker replaced by the git and node of the devcontainer:
  - on `main` before T11, 795b054, — "nothing to release";
  - on ff2a359 — `released=v0.1.0`;
  - on 53b829f — `behind=v0.1.0`;
  - on a commit that changes a shared workflow — "releasing v0.1.1";
  - on a commit not from the checkout's history and on a non-SHA — an error.

— *Rejected:*
- **В7:**
  - the required check "CodeQL" of GitHub Advanced Security — its thresholds are set in the repository's settings, outside the ruleset;
  - doing nothing — a green analysis with a finding would let the merge through;
- **В11:**
  - merge and rebase — rebase lays on `main` copies of the commits with new SHAs;
  - three methods — DCO does not read a squash commit;
- **В10:**
  - closing the finding as false — the check's score would stay 0;
  - the release as a separate job in CI on push. The file would come out of another kind than `spec`'s `release.yml` (R31 spec); CI would get a job with `contents: write`, and every pull request a skipped check "Release";
  - `RELEASE_LINE` from the file of the CI commit through `git show`. Then two commits would be mixed: the step and the functions from the tip, and the line from the old one. A repeated CI of a commit before T09 would fail on a file it does not have.

— *Consequence:* amendments to R09, R10 and R11. Rows В7, В10 and В11 stay in table 3 of RUN.md — with the author's answer and with what `spec` makes of it. — architecture 2.9, 3.1, 3.3–3.5, 4; RUN.md, T11; `self-release.yml`.

— *Amendment 2026-10-20:*
- `spec` recorded В7–В11 in v0.2.7, as amendments to R30 and R31 spec, and their rows have left table 3 of RUN.md (R13). This concerns the answers to В8 and В9 too: the opening of the entry says that they "lie" in table 3, and now they are recorded in `spec`.
- The answer to В12 was narrowed when planning E3: `.github` accepts the finding about `npm install -g` by R33 spec. So the "Dockerfile by В12" that `.github` will take with the tag of `spec` is now only the sums of the archives.
- `self-release.yml` will call the recipe by В8 in T13. For `spec` itself the recipe reads the line from the commit's `release.yml`, through `git show` — the path that is rejected above for `.github`. Outside `spec` the recipe takes `RELEASE_LINE` from the environment, and `.github` will give it from the tip's file, as is decided here (R13).

— RUN.md, T12.

— *Amendment 2026-10-20:* T13 called `spec`'s recipe `release-version` (the amendment to R10). The CI commit is still named only by its SHA:
- the checks of a full SHA and of an ancestor;
- the recipe's argument: the recipe counts the tags for this commit;
- `git diff` against the last release and, after a refusal, the comparison of its files of `.github/workflows/` with the tip;
- the release's `--target`.

The `toolchain` stage, `spec`'s recipe and the line are taken from the tip, and `tools/release/line.mjs` reads the line from the text of `self-release.yml`. What is said above about the functions of `version.mjs` and about the trial "by the same script" is history. — architecture 3.4; RUN.md, T13.

— *Amendment 2026-10-20:* the line is taken from the `self-release.yml` of the commit being released, not from the tip. So decided the amendment to R31 spec — the author's answer to В16 (R14). What is said above about the line from the tip, and the rejected "`RELEASE_LINE` from the file of the CI commit through `git show`", is history. The argument against this path, that a repeated CI of a commit before T09 would fail, no longer holds: to a commit older than the file `spec`'s recipe gives the line of the copy from the checkout. — RUN.md, T17.

## The `spec` tag after the shared workflows

**R13. `.github` is on `spec` v0.2.9: the submodule `spec/` is at this tag, the links to `spec` pinned to a tag name it, and what came from the repository template is as in the template of v0.2.9.**
- **What the tag brings `.github`** (`git diff v0.2.6 v0.2.9` in `spec/`, read 2026-10-20). This is v0.2.7, v0.2.8 and v0.2.9, tasks T17 and T16 of `spec`:
  - the amendment to R30 spec, by В7 and В11 of `.github`. In all the repositories the ruleset of `main` lists the shared checks, holds the findings of CodeQL by a rule — CodeQL, `errors`, `high_or_higher` — and accepts only merge. In `.github` this is set since R12. The second amendment is that T16 of `spec` is split: `tutor` is connected, T21 of `spec` will connect the nine others, after each moves to the tag;
  - the amendment to R31 spec, by В8–В10:
    - `spec`'s `release.yml` no longer checks out the event's commit, the steps run with `pipefail`, and only the documented refusal — 404 and 403 — is skipped;
    - the recipe `release-version` takes a commit as an argument and counts the tags of the repository it is called from. `.github` will call it in T13;
    - for `spec` itself the recipe reads the line from the `release.yml` of that commit, through `git show`. For `.github` R12 rejected this path, and outside `spec` the recipe takes the line from `RELEASE_LINE` anyway. `.github` will give it from the environment of its workflow, that is, from the tip's file, as R12 decided;
  - R33 spec — the findings of analyzers that a change cannot close. Among them are all the open Scorecard findings of `.github` in code scanning as of 2026-10-20: #1 Branch-Protection, #6 Code-Review, #2 Pinned-Dependencies (`npm install -g`), #5 Maintained, #7 CII-Best-Practices, #4 Fuzzing and #8 CI-Tests. The reasons of R33 spec fit `.github` for all but Fuzzing: in R33 spec it is "there is no code yet that parses outside input", and `.github`'s `dco.yml` reads the metadata of a pull request's commits, from a fork too. `.github`'s own reason is that it has no code in a language for which fuzz tests are written: only YAML and bash steps in workflows. The parsing of this metadata is checked by the trial pull requests (R08), so finding #4 stays open (rule 12 of RUN.md);
  - rule 12 of the template's RUN.md — before a new task, close the findings of the last one;
  - the results of T17 and T16 of `spec`:
    - `spec`, `module-kit` and `tutor` call the shared checks by the SHA of `v0.1.0` — so the call by the full path works (architecture 2.8);
    - the Scorecard server accepted the result of the shared `scorecard.yml` from another repository — the second step of architecture 2.2;
    - the ruleset of `main` of `module-kit` is 25488826;
  - the debts of `spec` addressed to `.github`:
    - Д8 in RUN.md of `spec` — an input of exclusions for the shared `codeql.yml`, for the prototype `draft/`; this is T14;
    - Д9 — CodeQL for Go, which needs a build; this is E3, together with `go.yml`;
    - Д10 — Dependabot with the shared checks is not checked in practice; `v0.1.1` of T14 will show it.

  RULES.md, `.devcontainer/` and `repo-template/` are the same, but for the template's RUN.md.
- **What is changed here:**
  - `spec/` — at v0.2.9, commit 5eafb1a. The links to `spec` in README.md and `profile/README.md` and the tag in CLAUDE.md and RUN.md — v0.2.9;
  - in «Как пользоваться» of RUN.md — rule 12, as in the template. Environment in CLAUDE.md and `.devcontainer/` match the template and the recipe of v0.2.9: `.devcontainer/` is checked against what `editDevcontainer` of `tools/new-repo` builds for `.github`;
  - rows В7–В11 have left table 3, and В12 is narrowed: R33 spec settled the finding about `npm install -g`. R03, R07 and R09–R12 get amendments about where `spec` recorded these rows, who connected the shared checks and what became of В12. A new row В15, «в реестр spec», asks to remove the fallback path of Scorecard from the card 3.11 spec;
  - CLAUDE.md, The component: Scorecard is shared with no condition, and the shared checks are already called by `spec`, `module-kit` and `tutor`;
  - architecture:
    - 2.2 is decided, and for 2.8 the call works;
    - 2.9, 3.1 and 3.3 — the rules of the ruleset are now shared;
    - 3.3 — what the first call showed;
    - 3.4 and section 4 — how `self-release.yml` still differs from `spec`'s `release.yml`;
    - section 1 and the opening of section 3 — who has already connected the shared checks;
  - in T14 and T15 of RUN.md, Д8, Д9 and Д10 of `spec` are named by their numbers.

— *Why now:* this is the first task of epic E3 (RUN.md, T12). The tasks of the epic rest on the amendments to R30 and R31 spec, on R33 spec and on the results of T17 of `spec`.
- The task named v0.2.8 — the newest release at the time the epic was planned. v0.2.9 came out later, at 18:13 UTC: it closed T16 of `spec` for `tutor`, started T21 of `spec` and the debts Д9 and Д10 addressed to `.github`. The author decided to move to it (RUN.md, T12, «Решено автором»).
- The release is immutable; `gh release verify v0.2.9 -R altnovatrail/spec` confirmed it by its attestation, the tag is on commit 5eafb1a.

— *Rejected:*
- v0.2.8, as the task said. It has no Д9, Д10 and T21, and the next move would be needed only for their numbers;
- v0.2.7 — it has no results of T17 of `spec`, no R33 spec and no debt about the prototype.

— *Consequence:* table 3 — В12–В15. T13 calls `spec`'s recipe, T14 gives the input of exclusions and `v0.1.1`, and T15 plans Go for CodeQL (Д9 in RUN.md of `spec`). — RUN.md, T12–T15; architecture: the status, 1, 2.2, 2.8, 2.9, 3, 3.1, 3.3, 3.4, 4; CLAUDE.md; README.md; `profile/README.md`.

— *Amendment 2026-10-20:* in T13 `self-release.yml` takes the line for the recipe not from the parsed `env` but from the text of its file — by `spec`'s script `tools/release/line.mjs`, as the recipe reads the `release.yml` of `spec` itself. Through `env` the string `0.10` without quotes would become `0.1` (the amendment to R10). The file is still the same — the tip's, as R12 decided. — RUN.md, T13.

— *Amendment 2026-10-20:* `.github` is on `spec` v0.2.11 (R14). `spec` recorded rows В12, В14, В15 and В16, and they have left table 3 of RUN.md. The line is now taken from the `self-release.yml` of the commit being released (the amendment to R12), so what is said above about the line from the environment and from the tip's file is history, as is all that is said about v0.2.9. — RUN.md, T17.

**R14. `.github` is on `spec` v0.2.11: the submodule `spec/` is at this tag, the links to `spec` pinned to a tag name it, and what came from the repository template is as in the template of v0.2.11.**
- **What the tag brings `.github`** (`git diff v0.2.9 v0.2.11` in `spec/`, read 2026-10-20). These are the answers to В12, В14, В15 and В16 of `.github` and the closing of epic E1 of `spec`:
  - R34 spec — an archive that `.devcontainer/Dockerfile` downloads is checked against a sha256 sum written beside its version, an `ARG` for each architecture. The rule is in RULES.md, Exact versions only. This is the answer to В12;
  - architecture 3.11 spec and repositories 6 spec — the answers to В14 and В15. The Go wrapper and the release come with the first code of `module-kit`, the TypeScript wrapper with the first code in TypeScript, in `canvas`. Scorecard is shared, with no fallback path;
  - the amendment to R31 spec — the release's interface for other repositories, the answer to В16. `release-version <commit> <workflow>` reads the line from the named workflow at the commit being released, and `release-refusal <commit> <tip> <error file>` decides whether a refusal of the Releases API may be skipped;
  - T21 spec connected the shared checks in the nine other repositories. Epic E1 of `spec` is closed and in the archive; `spec` has no current epic;
  - Д12 in RUN.md of `spec` — each repository moves to this tag by a task of its own and closes its rows.

  `repo-template/` has not changed, and RULES.md got one sentence — about the sums (R34 spec).
- **What is changed here:**
  - `spec/` — at v0.2.11, commit 2b8b8a1. The links to `spec` in README.md and `profile/README.md` and the tag in CLAUDE.md and RUN.md — v0.2.11;
  - `.devcontainer/Dockerfile` is taken from the recipe of v0.2.11, with sha256 sums, and all eight sums are checked against the archives (architecture 4). «Как пользоваться» and Environment in CLAUDE.md match the template and have not changed;
  - rows В12, В14, В15 and В16 have left table 3. The new rows «в реестр spec», В17 and В18, are about what `spec` gives to other repositories: the citation `R34` without a suffix in the Dockerfile, and the launch script `$RUNNER_TEMP/toolchain`, which the callers of the release recipes repeat after `spec`'s `release.yml`;
  - `self-release.yml` calls `spec`'s release recipes by their interface, both through the launch script `$RUNNER_TEMP/toolchain`, as in `spec`. The number is `release-version "$TARGET" .github/workflows/self-release.yml`, the refusal is `release-refusal`. The own copy of the rule of refusal and the line from the tip are gone (the amendments to R10 and R12). The number step tries the call of `release-refusal` through `just --dry-run`;
  - by the answer to В14 and the results of T21 of `spec` — CLAUDE.md, The component, README.md and architecture 1, 2.9, 3, 3.1 and 3.3. The TypeScript wrapper comes with the first code in TypeScript, and the shared checks are called by `spec` and all eleven component repositories; R03 gets an amendment;
  - architecture — the status, 2.5, 3.4, 3.5 and section 4. In RUN.md — the description of epic E3, T16 and the row of E5, and in table 4 — Д3: the devcontainer image with the new Dockerfile was not built here — and Д4: the move to v0.2.12 or newer before T15 is planned.

— *Why now:* Д12 of `spec` asks to move to the tag with the answers and close one's rows. The answer to В16 removes from `.github` the second copy of the rule of refusal: the next change of `spec` will reach it with the tag. v0.2.11 was the newest release of `spec` when the task started, 2026-10-20. It is immutable, and `gh release verify v0.2.11 -R altnovatrail/spec` confirmed it by its attestation, the tag is on commit 2b8b8a1. The author entrusted the task to be done autonomously (RUN.md, T17).

— *Rejected:*
- keeping the line from the tip and passing it to the recipe through `RELEASE_LINE`, as R12 decided. The recipe can still do this, but the amendment to R31 spec — the author's answer to В16 — makes the line of the commit being released the rule — "whatever the environment sets, where the `env` is the tip workflow's". The recipe's comment in `spec/justfile` says the same: "a release workflow's own env, the tip's, must not number an older commit";
- v0.2.10 — it does not yet have the answers to the rows of other repositories;
- v0.2.12. It came out at 23:39 UTC, during the task, and changes only `spec`'s RUN.md — the plan of its epic E2, tasks T22–T38 (`git diff --stat v0.2.11 v0.2.12` in `spec/`, 2026-10-21; `gh release verify v0.2.12` confirms it). It does not change the files that `.github` takes from `spec` — RULES.md, the template, `.devcontainer/` and the recipes — and the task names v0.2.11. The plan of E2 of `spec` names T15 and T16 of `.github`: T36 and T37 of `spec` wait for them. So it is worth moving to the tag with this plan before T15 is planned.

— *Consequence:* in table 3 — В13, В17 and В18. Д3 is closed by Rebuild Container — a step of the author — and Д4 by the move to a new tag before T15 is planned. — RUN.md, T17; architecture: the status, 1, 2.5, 2.9, 3, 3.1, 3.3–3.5, 4; R03, R10, R12, R13; CLAUDE.md; README.md; `profile/README.md`; `.devcontainer/`; `self-release.yml`.

— *Amendment 2026-10-21:* `.github` is on `spec` v0.2.12 (R15), and Д4 in RUN.md is closed. What is said above about v0.2.11 and about moving to v0.2.12 being worth doing later is the history of this move. — RUN.md, T18.

**R15. `.github` is on `spec` v0.2.12: the submodule `spec/` is at this tag, the links to `spec` pinned to a tag name it, and what came from the template is as in the template v0.2.12.**
- **What the tag brings to `.github`** (`git diff v0.2.11 v0.2.12` in `spec/`, read 2026-10-21). Only RUN.md of `spec`: the epic E2 «Формат модуля v0» became the current one, its tasks are T22–T38. `.github` is named by this plan so:
  - «Нужно» of the epic: «первый код и первый релиз `module-kit`, а с ними T15 и T16 `.github` — к T36 и T37». In table 1 T36 waits only for the first code of `module-kit`, and T37 for T16 `.github` and the first release of `module-kit`;
  - «Почему такой порядок»: «T36 и T37 — с первым кодом и первым релизом `module-kit`, как T15 и T16 `.github`»;
  - T36 `spec` — the issue and pull request templates (Д4 in RUN.md `spec`), with the first code of `module-kit`. If GitHub takes the templates from `.github`, as the community files, the session of `.github` writes them in a task of its own, by a prompt of `spec`;
  - T37 `spec` — what checks the signature of a package (Т-27), after T16 `.github` and the first release of `module-kit`. It will also decide where the checker takes the list of releases of `.github` from;
  - «Результат» of the epic: Т-27 is decided on the first release of `module-kit`;
  - «Не входит» of the epic: the Go and TypeScript wrappers and the shared release are the epics E3 and E5 `.github`, and CodeQL for Go is Д9 `spec`. The row of E2 in table 2 of RUN.md `spec`, which R07 cited, is gone: the epic became the current one.

  RULES.md, `.devcontainer/` and `repo-template/` did not change.
- **What is changed here:**
  - `spec/` — at v0.2.12, the commit b721be9. The links to `spec` in README.md and `profile/README.md` and the tag in CLAUDE.md and RUN.md — v0.2.12;
  - «Как пользоваться», Environment in CLAUDE.md and `.devcontainer/` did not change: in the template and in the recipe of `spec` nothing changed between the tags;
  - an amendment to R14. In RUN.md — the result and the order of the epic, the row on T15 and T16 in table 1, В17 without the number that this entry took, and the opening of table 4: Д4 in RUN.md is closed;
  - architecture 2.3 names T37 `spec`, and the new 2.11 the issue and pull request templates of T36 `spec`.

— *Why now:* Д4 says to move to the latest release of `spec` before planning T15: the plan of E2 `spec` names T15 and T16 `.github`, and it exists only from v0.2.12. The author decided to do T15 now, 2026-10-21, on trial code of `module-kit` (RUN.md, T18). v0.2.12 is the newest release of `spec` on 2026-10-21 (`gh release list -R altnovatrail/spec`), it is immutable, and `gh release verify v0.2.12 -R altnovatrail/spec` confirmed it by its attestation; the tag is on the commit b721be9.

— *Rejected:* staying on v0.2.11 until the real code of `module-kit` — T15 would then be planned without seeing that «Нужно» of the plan E2 `spec` puts T15 and T16 beside the first code and the first release of `module-kit`, for its T36 and T37.

— *Consequence:* Д4 in RUN.md is closed. — RUN.md, T18; R14; CLAUDE.md; README.md; `profile/README.md`; architecture: status, 2.3, 2.11.

— *Amendment 2026-10-21:* `.github` is on `spec` v0.2.13 (R17). What is said above about v0.2.12 is the history of this move. — RUN.md, T20.

## Shared workflows for code

**R16. The Go wrapper is the shared `go.yml`: a job for each of the caller's four recipes — `ci-lint`, `ci-test`, `ci-vuln` and `ci-licenses` —, in the `toolchain` stage of its devcontainer. The license list for `ci-licenses` — the ASF's category A, as `spec` has it — is in `go.yml` itself, and `self-ci.yml` holds it to `spec`'s list. `.github` has no Go code, so `go.yml` is checked by a call from a pull request of a repository in Go — by the branch's SHA, before the release.**
- **Design** (architecture 3.1):
  - `on: workflow_call`, with no inputs and no secrets (R05); permissions — `contents: read`;
  - the matrix `check: [lint, test, vuln, licenses]` with `fail-fast: false`. A job is named by its recipe, so the checks are "Go / lint", "Go / test", "Go / vuln" and "Go / licenses" when the caller's job is named "Go". Each is a name of its own in the ruleset of `main` (R30 spec);
  - the job takes a checkout without the submodule: the code and its tests take the files of `spec` from the releases of `spec`, not from the submodule (R21 spec; «Результат» of the epic E2 in RUN.md `spec`), and a check that reads `spec/` fails here just as it would fail for a user. The job builds the `toolchain` stage from the caller's `.devcontainer/Dockerfile`, as `documents.yml` does, and runs `just ci-<check>` in it as the runner's user, with `HOME=/tmp`. Of the step's environment only `ALLOWED_LICENSES` goes into the container;
  - what to check and with what is the caller's business: its recipes, its Go in its Dockerfile, the versions of the tools in its `justfile` (R03; R30 spec). `go.yml` sets only the names of the recipes and the license list.
- **The license list** (architecture 2.7): `ALLOWED_LICENSES` is ten SPDX identifiers of the ASF's category A, the same as in `spec/tools/licenses/config.mjs` (R12 spec). It is in `go.yml` itself, as 2.7 recommended: a change of the list is a change of a shared workflow, which gives a release (architecture 2.4), and the caller gets the list of the version it is pinned to. The job "Workflows" of `self-ci.yml` holds it to the list of `spec` at the tag `.github` is on. `spec` has no interface for the list, so the check reads the file as text — one quoted identifier per line — and fails on any other layout rather than letting it pass (В19 «в реестр spec»). A move to a tag that changes this list will turn the CI of `.github` red until `go.yml` catches up. Exceptions are in the caller's recipe, each with its own decision.
- **The check of `go.yml` itself:** `self-ci.yml` does not call it — `.github` has no Go code. A change is checked by a pull request of a repository in Go that calls `go.yml` by the branch's SHA, before the release; the first such is T10 `module-kit`.
- **CodeQL for Go** is not part of this: it is the input `languages` of the shared `codeql.yml` with a build — task T19 (Д9 in RUN.md `spec`).

— *Why:* the author's decision of 2026-10-21 — to do T15 now, on the scaffold of the CLI of `module-kit` (the amendment to R03), and to have the executor make the decisions of its planning by the recommendations and record them here (RUN.md, T15).
- The names of the recipes are as canvas-api has them (R49 canvas-api): one repository in Go already calls them so, and no new names need inventing.
- A job per recipe: each check holds the merge and is seen on its own (R30 spec), and a red `ci-vuln` does not hide the outcome of `ci-test`. Building the image in each job takes a minute, and on public repositories it costs nothing.
- The list in `go.yml`, not at the caller: it is one for all repositories (R12 spec), and the callers would have as many copies as there are repositories in Go.

— *An exception to the rules.* The scaffold of the CLI and its recipes in `module-kit` were made by the session of `.github` on the author's instruction — the amendment to R03, R04 module-kit.

— *Rejected:*
- one job with all the recipes: one check for four, and the first red recipe would hide the rest;
- the list from `spec/tools/licenses/config.mjs` of the caller's submodule. It is an internal file of `spec`, and `spec` promised no interface for it, as it promised none for `line.mjs` before В16. The list would depend on the caller's tag, not on the version of `go.yml`;
- a separate file of `.github` that the shared workflow reads by `job.workflow_sha`: a second checkout for ten words (architecture 2.7);
- govulncheck and go-licenses in `go.yml` itself, at a shared version. The checks are the repository's (R03; R30 spec), and the caller pins their versions itself, as in the `justfile` of canvas-api (architecture 4);
- a cache of Go modules and builds between runs: while a run takes minutes, it is not needed.

— *Consequence:* `module-kit` calls `go.yml` (T10 module-kit), and four checks "Go / …" go into its ruleset of `main` — the author puts them there. The first release of `.github` with `go.yml` comes out with the merge of T15. — architecture 2.7, 3.1, 3.3, 3.4, 4; RUN.md, T15, T19; `go.yml`; `self-ci.yml`.

— *Amendment 2026-10-21:* the release came out — `v0.1.2`, the commit d01dd88, immutable and Latest; `gh release verify` confirms it. `module-kit` calls `go.yml` by its SHA (T10 module-kit, merged edd5bca), and the four checks "Go / …" stand in its ruleset of `main` 25488826. The executor put them there, with the author's consent. — architecture 3.3; RUN.md, T15.

— *Amendment 2026-10-22:* by В19, task T26. The list is held to what the recipe of `spec` `licenses-allowed` prints at the tag of `.github`, one SPDX identifier per line (R39 spec). This is the list's interface, and `self-ci.yml` no longer reads `config.mjs` as text. What is said above — "`spec` has no interface for the list, so the check reads the file as text" — is history.
- The recipe runs in the `toolchain` stage of `.github` itself: the job "Workflows" builds it by the script `spec/tools/toolchain/toolchain.sh` and calls the recipe with it, as `spec` calls its recipes everywhere (the amendment to R31 spec). The list is taken by an assignment, not through a pipeline: the step has no `pipefail`, and a failed recipe would otherwise give an empty list. An empty output or a line that is not an SPDX identifier stops the step.
- `go.yml` does not change. Its branch `licenses` still runs without the submodule, and the caller's `ci-licenses` is go-licenses by `ALLOWED_LICENSES`: `spec` has no license check for Go. Only the branch `licenses` of `typescript.yml` got an exception from the checkout without the submodule (the amendment to R19).
- The trial is local, by the step taken out of the file word for word, with a stub of docker. Equal copies — a green step. A copy that diverged, and a copy without the line `ALLOWED_LICENSES` — red, and it names the file. An empty output, a line of the wrong form and a failed recipe — red too. On the runner — pull request #58 (architecture 4).

— architecture 2.7, 3.4, 4; RUN.md, T26; `self-ci.yml`.

— *Amendment 2026-11-01:* by Д29 in RUN.md `spec`, task T34. `go.yml` sends the test coverage to Codecov by OIDC, with no secret (R48 spec). The author's answers in planning — CLI v11.3.2, a trial pull request of `.github` and the merge by the executor — are in RUN.md, T34.
- **The contract of `ci-test`.** The recipe writes the coverage of its tests as one profile of `go test -coverprofile` to the file `coverage/go.out` — over every package of every module of the repository, as the `ci-test` of `spec` does (the 2026-11-01 amendment to R48 spec). A package without tests of its own Go puts into the profile itself, with zeros: since Go 1.22 "functions in the package are treated as uncovered" (architecture 4). A package with no executable code at all does not get into the profile, but it has no lines for `codecov/patch` either. The recipe writes the report itself: the wrapper passes it nothing. A recipe without a report fails "Go / test" — on a pull request and on `main`. `coverage/` is in the caller's `.gitignore`.
- **Job `test`** hands on the report as the artifact `go-coverage`: the step "Coverage report" runs only in it, after the recipe, with `if-no-files-found: error`. The name is the wrapper's. An artifact's name is unique in a run, and `spec` already has an artifact `coverage` of its own (architecture 4). So the caller sets up no artifacts of its own named `go-coverage` and `typescript-coverage`. The report is kept for a week: after a failure of Codecov the upload job is rerun.
- **Job `coverage`** is the check "Go / coverage", built as the job "Coverage" of the `ci.yml` of `spec` (R48 spec and its 2026-10-23 amendments; the 2026-10-23 amendment to R30 spec):
  - `needs: check` — it waits for all four checks, as the upload of `spec` waits for all of its own. A red "lint" or "vuln" holds the merge anyway, and the matrix and the names of the checks do not change;
  - `id-token: write` — only it has it, as a permission of the job, not of the workflow. The jobs of the matrix run the pull request's code, and it does not: it takes a checkout without the submodule, the report from the artifact, the Codecov CLI and `codecov/codecov-action` v7.1.1;
  - the permission is given to it by the caller's job: a called workflow only lowers permissions (architecture 4). So the caller gives `contents: read` and `id-token: write` (architecture 3.3);
  - the Codecov CLI is v11.3.2, by the sha256 in the step itself, as the tools of `self-ci.yml` (R08). The sum is from `codecov.SHA256SUM` of the CLI's release, and the signature of that file was checked by gpg with the key whose fingerprint the Codecov Uploader page names (architecture 4). The action gets the ready file by the input `binary` and downloads nothing. The version and the sum are raised by hand, together and in both wrappers, and Dependabot moves the SHAs of the actions;
  - the inputs of the action are `use_oidc`, `files` with one report, `disable_search`, `plugins: noop`, `disable_telem` and `fail_ci_if_error`, as `spec` has them;
  - `continue-on-error` — outside a pull request. A failed upload fails a pull request, so that a missing `codecov/patch` has its cause in sight, and does not fail a run of `main`, and it does not hold the caller's release.
- **What holds the merge** is `codecov/patch`, not "Go / coverage": with no upload there is no status, and the merge waits anyway. The author puts the check in the caller's ruleset of `main` after the first pull request of Dependabot with the upload, as with `spec` (the 2026-10-23 amendment to R30 spec; Д10 in RUN.md `spec`). How the caller moves is architecture 3.3.
- **The trial** — what is said above, "A change is checked by a pull request of a repository in Go that calls `go.yml` by the branch's SHA", now reads wider: or by a trial pull request of `.github` that calls `go.yml` by the local path, as `typescript.yml` (R19). This change was checked so too — pull request #80, with no merge (architecture 4):
  - both uploads went through by OIDC, and `codecov/patch` came from the Codecov app;
  - a caller's job without `id-token: write` kept the run from starting — "The nested job 'coverage' is requesting 'id-token: write', but is only allowed 'id-token: none'";
  - `ci-test` without a profile made "Go / test" red and skipped "Go / coverage".

  The trial did not show a call from another repository: the caller's first move will show it.
- **Cases** — in the suite of R28: the structure of job `coverage` and its permissions, the step "Coverage report", the inputs of the actions and the step "Codecov CLI", run with a stub of curl. The stub now knows `-fsSL`, and with `-f` and a code of 400 or more writes nothing and exits with 22, as curl does.
- **Rejected:**
  - the secret `CODECOV_TOKEN` — shared workflows take no secrets (R05), and R48 spec rejected it;
  - the CLI that the action downloads itself and checks by the key from Keybase — R48 spec rejected it: the action does not check the key's fingerprint;
  - a separate job `test` with an upload after it alone: the steps of the checkout, of the image and of the recipe would stand twice;
  - `if: !cancelled()` on the upload job: a failed `ci-test` would also give a red upload without a cause of its own;
  - `id-token: write` on the jobs of the matrix — the pull request's code would get the permission;
  - a shared upload workflow that both wrappers call — a proposal of the review. It is one more level of nested workflows, through which the OIDC permission would go further, and a check name of the form "Go / coverage / …". And that the two copies of the job are the same is held by a case of the suite.

— architecture 1, 3.1, 3.3, 3.5, 3.6, 4; RUN.md, T34; `go.yml`; `tests/`.

— *Amendment 2026-11-01:* the release came out — `v0.1.12`, the commit 4225639, immutable and Latest; `gh release verify` confirms it. The caller's job in architecture 3.3 calls `go.yml` by this SHA and gives it `id-token: write`. — architecture 3.3; RUN.md, T34.

— *Amendment 2026-11-08:* **`go.yml` has the input `same-bits`, boolean, `false` by default. With it come two more jobs in the caller's `toolchain` stage: "Go / targets" runs the tests at GOAMD64 v3, at v1 with `GODEBUG=cpu.all=off`, at `GOARCH=386` and in js/wasm through `go_js_wasm_exec`, and builds wasip1 and checks it with `go vet`; "Go / fma-diff" compares, for every package with code, the assembler built with fusion and with `-d=fmahash=n`, on the six targets that fuse, and requires its own control to differ.** Task T46, by R107 spec; the author's answers of 2026-11-08 in planning E14.
- **Why.** `learner-model` and `engine` keep the same bits on every build, and both checked it themselves — by the recipes `test-targets` and `fma-diff`, the same at both (R09 learner-model; R10 engine). R107 spec says to take the checks as an option of the shared `go.yml`: one copy instead of two.
- **How.** The scripts of the jobs are these recipes, word for word, but for the number of the decision in the message: R107 spec. Each runs in one container on stdin, `bash -s -`, so that the build cache lives from run to run. A host other than amd64 runs its build with `cpu.all=off` — for T47. The control of `fma-diff` — the three control functions of `learner-model`, `testdata/fma` — the step writes into a temporary module, `fmacontrol`, and builds it through `go -C`: the caller needs no control of its own. In three places `fma-diff` differs from the recipes, by the review of T46: the build is with `-o /dev/null`, so that the main package writes no binary into the checkout; the list of packages is made for each target, since build constraints change it from target to target; a package that does not build turns its target red but does not cut short the check of the rest. The permissions and the image are as for `check`, `timeout-minutes` is 30.
- **Decided by the author** in planning: one input, not three — both callers need all of it; the logic is in steps of `go.yml`, and the control in `.github`.

*Rejected:*
- the recipes of `spec` that `go.yml` calls, as the license recipes: a change of `spec` and waiting for its tag;
- the caller's recipes by a contract, `ci-targets` and `ci-fma`: two copies would remain, and R107 spec moves away from them;
- steps inside `ci-test`: a red "Go / test" would not say what broke — a test, a target or the fusion;
- the caller's control `testdata/fma`: each has its own copy, and the input would require a file in its repository.

Without the input `go.yml` is the same. A caller with the input removes its recipes and `testdata/fma` and puts two checks in the ruleset (architecture 3.3). — architecture 3.1, 3.3, 4; RUN.md, T46.

— *Amendment 2026-11-08:* the release came out — `v0.1.18`, the commit 6f77496, immutable and Latest; `gh release verify` confirms it. From `v0.1.17` it differs only in `go.yml` (`git diff v0.1.17 v0.1.18`). The calling text in architecture 3.3 calls `go.yml` by this SHA, and the input `same-bits` is there from it. — architecture 3.3; RUN.md, T46.

— *Amendment 2026-11-08:* **with `same-bits`, `go.yml` has also the job "Go / arm64" on `ubuntu-24.04-arm`: the caller's `ci-test`, and then the same script as "Go / targets" has — on a host other than amd64 it runs its build with `GODEBUG=cpu.all=off`, js/wasm and wasip1.** Task T47, by R107 spec.
- **Why.** `learner-model` and `engine` have such a job of their own, "Go arm64": the bits must match on an arm64 host too, where the processor has its own extensions, and the races and the coverage run on it too. R107 spec says to take it too as an option of `go.yml`.
- **How.** The runner is the free standard one for a public repository (architecture 4). The script of the runs is one for both jobs, word for word, and the suite keeps them the same. The coverage report of this `ci-test` goes nowhere: "Go / test" sends it to Codecov. `timeout-minutes` is 45: the job runs `ci-test`, which `check` gives 20 minutes, and the runs, which `targets` gives 30.

*Rejected:*
- `fma-diff` on arm64 too, as in the recipes: its output does not depend on the host, and it already runs in "Go / fma-diff";
- a separate input for arm64: both callers need all of it, and the input is one (the amendment above).
- one job `targets` with a matrix by runner instead of a copy of the script: the names of the checks would come from the matrix, and on arm64 `ci-test` runs beyond the runs. The suite keeps the copy the same;
- `ci-test` and the runs in one container, for a shared build cache: the script of the runs would diverge from its copy in `targets`. `learner-model` and `engine` have no modules in `require`, or one, and the trial took 58 s.

A caller with the input removes its job "Go arm64" and puts "Go / arm64" in the ruleset (architecture 3.3). — architecture 3.1, 3.3, 4; RUN.md, T47.

— *Amendment 2026-11-08:* the release came out — `v0.1.19`, the commit 982ffe6, immutable and Latest; `gh release verify` confirms it. From `v0.1.18` it differs only in `go.yml` (`git diff v0.1.18 v0.1.19`). The calling text in architecture 3.3 calls `go.yml` by this SHA, and "Go / arm64" is there from it. — architecture 3.3; RUN.md, T47.

— *Amendment 2026-11-08:* **with `same-bits`, `go.yml` has also the job "Go / rules": the test of the rules of code by the tool `tools/coderules/` of `.github` of the same commit as the file `go.yml`, with the caller's lists `.github/coderules.json`.** Task T48, by R107 spec; the design of the tool is R33.
- **How.** A second checkout of `.github` by `job.workflow_repository` and `job.workflow_sha` into `.shared-github`, and the step at once moves it to `RUNNER_TEMP`: in the working folder the check of nested modules would catch it. Then the caller's `toolchain` stage and one container: the module of the tool is read-only, and `go -C /tool build -o /tmp/coderules .` and `/tmp/coderules -lists .github/coderules.json .` run with the same Go as the caller's code. Without `.github/coderules.json` the step fails and names the cause. `timeout-minutes` is 20; the trial took 31 s.
- **Why of its own version.** The caller pins `go.yml` by the SHA of a release, and the tool must be of the same release: from `main` of `.github` a change of the rules would reach the caller without its reference being raised.

*Rejected:* the tool from the release as a file — a binary or an archive: it would have to be checked by `release-verify` (RULES.md, Hard rules), and built with Go for each platform. Built from the sources of the same commit, it needs no signature: its sources are part of what the caller pinned.

A caller puts in `.github/coderules.json`, removes `rules_test.go` with `testdata/coderules` and puts "Go / rules" in the ruleset (architecture 3.3). — architecture 3.1, 3.3, 4; RUN.md, T48.

— *Amendment 2026-11-08:* the release came out — `v0.1.20`, the commit f87e8da, immutable and Latest; `gh release verify` confirms it. From `v0.1.19` it differs in `go.yml` — the job "Go / rules" — and in the new `tools/coderules/` (R33), and the other shared workflows are the same. The calling text in architecture 3.3 calls `go.yml` by this SHA, and "Go / rules" is there from it. — architecture 3.3; RUN.md, T48.

— *Amendment 2026-11-09:* **the jobs of `go.yml` take the image of the `toolchain` stage from the GitHub Actions cache and build it only on a miss (R36).** What is said above about the step "Toolchain image", that it builds the image from the Dockerfile, is now about a miss. Task T52.

## The `spec` tag after the Go wrapper

**R17. `.github` is on `spec` v0.2.13: the submodule `spec/` is at this tag, the links to `spec` pinned to a tag name it, and what came from the template is as in the template v0.2.13.**
- **What the tag brings to `.github`** (`git diff v0.2.12 v0.2.13` in `spec/`, read 2026-10-21): R35 spec — the review of a task. It is one round of `/code-review high`, after which the executor does not repeat the review, and a small change it may hand in without a review, deciding so itself. The rule is in rules 6 and 8 of the template's RUN.md, and for Codex in AGENTS.md. RULES.md, `.devcontainer/` and the recipes did not change.
- **What is changed here:**
  - `spec/` — at v0.2.13, the commit ba6ac67. The links to `spec` in README.md and `profile/README.md` and the tag in CLAUDE.md and RUN.md — v0.2.13;
  - «Как пользоваться» of RUN.md and AGENTS.md already match the template v0.2.13. The change was made by the session of `.github` on the author's instruction, pull request #27 — so says the "Consequence" of R35 spec;
  - an amendment to R15.

— *Why now:* the author instructed to move to the new tag before T19, 2026-10-21. v0.2.13 is the newest release of `spec` on that date (`gh release list -R altnovatrail/spec`), it is immutable, and `gh release verify v0.2.13 -R altnovatrail/spec` confirmed it by its attestation; the tag is on the commit ba6ac67.

— *Rejected:* staying on v0.2.12. Rules 6 and 8 here already match v0.2.13, and the documents would then cite a tag where these rules do not exist yet.

— *Consequence:* the review of a task goes by R35 spec. — RUN.md, T20; CLAUDE.md; README.md; `profile/README.md`; architecture, status.

— *Amendment 2026-10-21:* `.github` is on `spec` v0.2.14 (R20). What is said above about v0.2.13 is the history of this move. — RUN.md, T23.

## The shared release

**R18. The shared release is `release.yml`. The number is given by the release recipes of `spec` by the line from the caller's workflow, and a release comes out only if the paths it is built from changed. The files are built by the caller's recipe `release-files` in the `toolchain` stage of the commit being released. Every file is signed by keyless cosign, and the signature is checked before publishing.**
- **Design** (architecture 3.1, 3.3):
  - `on: workflow_call`. Inputs: `paths` — a pathspec, what the release is built from; `publish` — `false` for a trial without publishing. Permissions — `contents: write`, `id-token: write`, `actions: read`; the queue — `queue: max`;
  - the job runs only from a green CI on a push from the repository itself or from the button on `main` after a green `ci.yml`. With `publish: false` — anywhere, in its own queue by ref: so a pull request tries out a change. The trial has the same permissions, so it does not run from a fork;
  - the number is as for a release of `.github` (R14). `release-version "$TARGET" <file>` runs through the script `$RUNNER_TEMP/toolchain`, and the file is the caller's workflow from `github.workflow_ref`: in a called workflow the `github` context is the caller's. Before it — the trial `release-refusal --dry-run`; the checks of the full SHA, of a shallow clone, of the ancestor and of tags without a release are the same as in `self-release.yml`;
  - a release comes out only if `git diff` with the previous release over `paths` finds something, and the first one always comes out. Only the commit that the run itself names, `GITHUB_SHA`, is signed: the certificate names this commit as its source, and it must match the tag's target. An older commit whose CI ended later gets no release: the release of the tip covers it;
  - the build — the tree of the commit being released without history and submodules (`git archive`), its `toolchain` stage and `just release-files "$VERSION"`. The recipe writes into `dist/` only plain files with safe names and without `.sigstore.json` of its own; `git` is not available to it, and the version comes as an argument. There are no tokens in the container;
  - the signature — cosign 3.1.4, downloaded with its sha256 sum in the file itself, as gitleaks (R08): `cosign sign-blob --yes --bundle` for each file. Then `cosign verify-blob` checks each bundle: the identity `https://github.com/<job.workflow_ref>`, the issuer GitHub Actions, the caller's repository and the commit `TARGET`. The certificate of the first file is printed to the log, and a failure of the printing does not hold the release;
  - publishing — `gh release create` with all the files and bundles, Latest on every release, as for `.github`. A refusal of the Releases API is parsed by `release-refusal`. Then `gh release verify` and `gh release verify-asset` of each file.
- **From the caller:** the recipe `release-files`, `RELEASE_LINE` in its `release.yml`, CI in `ci.yml`, immutable releases and the ruleset of tags `v*` — the condition of Т-27.
- **The trial** — pull request #33, with no merge: the number, the build, the signing and the check of three files passed, and there is no release. The certificate names the shared `release.yml` in the SAN, and the caller's workflow in the Build Config URI (architecture 4).

— *Why:* the author's decisions of 2026-10-21 (RUN.md, T16).
- A release only on a change of the paths: `module-kit` is a library, `api` and `tutor` import it, and Dependabot would offer them every tag, even after a change of documents.
- The trial is in `.github` itself and without publishing, and the side of `module-kit` is its session's, by R04 module-kit. So the first release of `module-kit` is signed by a release of `.github` already, and such a signature is what the check of Т-27 will accept.
- The rest is a proposal of the executor by the recommendations. The build in the `toolchain` stage of the commit being released runs with the Go and the tools that it pinned and that `go.yml` checked it with (R16). The check before publishing lets out no release whose signature does not pass.

— *Rejected:*
- a release of every green commit, as for `spec` — for the reason above;
- `sigstore/cosign-installer`, as canvas-api has it (R52 canvas-api). It is one more action with its own download path, and the tools of the shared workflows are pinned by a sum in the file itself (R08);
- an input with the path of the caller's workflow: `github.workflow_ref` already names it, and the wrong file cannot be passed;
- a build on the runner with `actions/setup-go`, as canvas-api has it: that would not be the Go that the caller pinned and checked with;
- a checkout of the commit being released by the event's `ref` — a commit is named only by its SHA (R12), and `git archive` gives its tree;
- signing an older commit too, as `self-release.yml` releases it: the certificate would name the tip, not the tag's target, and the check of Т-27 would not match;
- one shared code for `self-release.yml` and `release.yml` now. Their step of the number and their publishing are almost the same, but a release of `.github` has no files and no signature. They are to be merged when a third copy is needed.

— *Consequence:* architecture 2.3 is decided as to the signing, and what the consumer checks is Т-27, T37 `spec`. `module-kit` gets immutable releases and a ruleset of tags, and its session writes the calling `release.yml` and `release-files` and puts out the first release. — architecture 2.3, 3.1, 3.3, 4; RUN.md, T16; `release.yml`; `.github/actionlint.yaml`.

— *Amendment 2026-10-21:* the release came out — `v0.1.4`, the commit 11435db, immutable and Latest; `gh release verify` confirms it. `module-kit` has immutable releases on and the ruleset of tags `v*` 25559103, as `.github` has; the executor put them there, with the author's consent. The calling `release.yml`, `release-files` and the first release are its session's. — architecture 3.3; RUN.md, T16.

— *Amendment 2026-10-21:* the first release on the shared `release.yml` is `v0.1.0` of `module-kit`, the commit 7e0144a (T13 and R07 module-kit). All nine files are signed. Each bundle passes `cosign verify-blob` by the shared `release.yml` at the SHA of `v0.1.4`, the repository `module-kit` and the tag's commit, and the release passes `gh release verify`. Т-27 is decided by T37 `spec`, now on a real release. — architecture 2.3, 4; RUN.md, T16.

— *Amendment 2026-10-22:* by В18, task T25. The shared release runs the recipes of `spec` by the script `spec/tools/toolchain/toolchain.sh` from the caller's submodule, at the tag the caller pinned (the 2026-10-21 amendment to R31 spec), as `self-release.yml` does (the amendment to R10). What is said above — "runs through the script `$RUNNER_TEMP/toolchain`" — now reads as "runs through `spec/tools/toolchain/toolchain.sh`".
- **The `spec` tag at the caller** — the author's decision of 2026-10-22 (RUN.md, T25). The script is in `spec` from v0.2.17. The step of the number, right before the build of the stage, checks four things:
  - `spec/` is the submodule `altnovatrail/spec`;
  - it is checked out at the commit that the caller pinned;
  - this commit is a tag of `spec`: so every NovaTrail repository pins `spec` (RULES.md);
  - the tag has the script.

  Otherwise the run stops and names the cause: another URL, a commit without a tag or a tag without the script. The checks of the URL and of the tag were added by the review of T25: the trust below rests on them. A run of a commit older than the tip leaves earlier, without a release, as before. The caller moves to v0.2.17 before it raises the reference to this release of `.github`. Otherwise the run "Release" on `main` turns red, and the release waits for the move — the changes since the previous release are not lost. Rejected were the script from the checkout of `.github` itself by `job.workflow_sha` — against the amendment to R31 spec — and a copy of its own until the move — the copy that В18 moves away from.
- **The build of the files** is still by its own `docker build` and `docker run`, from the tree of the commit being released. The caller's code sees only its own tree and not a single token. This boundary must not depend on what the `run` of the script of the next tag comes to mount or pass — already now it gives `RUNNER_TEMP` too.
- **The script's sum.** Each container of the script gets the checkout writable, and the script itself runs on the runner. A container could rewrite the script that the runner runs next, with the step's token. The wrapper `$RUNNER_TEMP/toolchain` had no such hole: it lay in `RUNNER_TEMP`, which its containers see read-only. The review of T25 found this. So the sha256 sum of the script is taken before the first container and checked before each next call, and the publishing step gets it as an output of a step, which the containers do not write. The rest of the checkout, `.git` too, the containers can change, as before T25: that is architecture 2.12 and В24.
- **The consequence for trust.** The script itself runs on the runner, not in a container. In the steps of the number and of publishing it has `GH_TOKEN` with `contents: write` in its environment, and the job has the variables by which cosign gets an OIDC token and signs in the name of this workflow (architecture 4). Before T25 only the code of `.github` ran on the runner, and the code of `spec` and of the caller ran in containers without tokens. Now the SHA of the release of `.github` in the SAN of the signature does not pin all the code that ran with the right to sign: the script is from the commit of `spec` that the caller's submodule is at. The author accepts this. The script is NovaTrail code at a tag of `altnovatrail/spec`, the caller's commit pins it, as an action by SHA, and its sum is checked. Third-party build tools still run in a container without tokens. Whether this matters for the check of the signature (Т-27) is for `spec` to decide: it is В23 in RUN.md, «в реестр spec».
- **The trial** — pull request #49, with no merge (architecture 4). With `publish: false` the number `v0.1.6` was counted, the file built, signed and checked, and there is no release. On the submodule at v0.2.16 the check of the tag stopped the run, and with two arguments the trial did. After the review — the trial #50: on the runner the checks of the submodule passed, so the tags of `spec` are visible there. A commit of `spec` without a tag, the tag v0.2.16 and the script changed after the trial each stopped the run with its own message.

— architecture 2.12, 3.1, 3.3, 4; RUN.md, T25, В23, В24.

— *Amendment 2026-10-22:* the release is out — `v0.1.6`, commit 630924e, immutable and Latest; `gh release verify` confirms it. The caller's text in architecture 3.3 calls the shared `release.yml` by this SHA, and from it on the caller needs `spec` v0.2.17 or newer. The release notes carry the title of pull request #51 — "callers need spec v0.2.17": Dependabot's pull request will bring them to each caller. — architecture 3.3; RUN.md, T25.

— *Amendment 2026-10-22:* by the author's answer to В24, task T28 (architecture 2.12). The shared release runs `spec`'s recipes in a copy of the checkout, as `self-release.yml` does (the amendment to R10). Until T28 each container of the script got the whole checkout for writing, `.git` too. And the runner itself, after these containers, read this `.git`:
- `git diff` decided whether a release comes out;
- `git archive` gave the tree from which the files are built and signed;
- `git fetch` after a refusal went by `.git/config`;
- the post step of `actions/checkout` at the end of the job ran `git config` and `git submodule foreach` in the checkout (architecture 4).

Now:
- **the copy.** The step of the number, after the checks of the submodule and before the first container, takes a copy of the checkout — `cp -a` into `RUNNER_TEMP`, with all the history, the tags and the submodule — and runs the script from it. The submodule's paths in `.git` are relative, so the copy does without the checkout (architecture 4). Everything the runner's `git` reads is the checkout itself, and no container mounts it. What is said above in "The script's sum" — "The rest of the checkout, `.git` too, the containers may change, as before T25" — is history;
- **the script's sum** is taken in the checkout and checked in the copy before each call after a container. After a refusal, `release-refusal` runs in a new copy, taken after `git fetch`: the old one lacks the new tip, and `git fetch` in it would read a `.git/config` that a container could have changed. No container has seen the new copy, so the publishing step no longer needs the sum. What is said above — "the publishing step gets it as an output of a step" — is history;
- **"Consequence for trust"** above does not change: the script still runs on the runner, and В23 stays;
- **the release of `spec`** is built the way this one was before T28: its container gets the checkout for writing, and the runner then runs `git fetch` in it. This is В25 in RUN.md, «в реестр spec»;
- **the cost** is a copy of the checkout on the runner's disk. The checkout of `.github` is 14 MB, and `cp -a` took 0.013 s (trial #54);
- **rejected:**
  - a copy by hard links, `cp -al`: it is faster, but a file that a container changes in place would change in the checkout too;
  - `git worktree add`: such a working copy shares its `.git` with the checkout;
  - `git clone` from the checkout: from a local path git takes the objects by hard links by default, and the submodule would have to be taken anew.

  The other options of 2.12 the author rejected by choosing the copy;
- **the trial** is pull request #54, not merged (architecture 4). With `publish: false` the number `v0.1.7` was worked out, the file built, signed and checked, and there is no release. A container that broke the copy's `.git` after `release-version` hindered neither `git diff` nor `git archive`. A script changed by a container in the copy stopped the run by the check of the sum. The path of a refusal was checked locally, with stubs of docker and `gh`: `release-refusal` in the new copy sees the new tip, and in the copy before `git fetch` it does not.

— architecture 2.12, 3.1, 4; RUN.md, T28, В25.

— *Amendment 2026-10-22:* the release is out — `v0.1.7`, commit 0acbf75, immutable and Latest; `gh release verify` confirms it. The caller's text in architecture 3.3 calls the shared `release.yml` by this SHA. The release asks nothing new of the caller: the `spec` submodule is still v0.2.17 or newer. — architecture 3.3; RUN.md, T28.

— *Amendment 2026-10-22:* by R37 spec, task T27. The shared release publishes to npm the package the caller named. The input `npm-package` is a name in the scope `@altnovatrail`, and the file is the archive that `npm pack` names. It is one of the release's files, signed by the same run. Trusted publishing publishes it: npm exchanges the job's OIDC token for a publishing token if the package's trusted publisher names the caller's repository and its release workflow, and it makes the provenance itself. The input, and that there is no real publishing until T24 canvas, the author decided while planning, 2026-10-22; the rest, the executor by the recommendations (RUN.md, T27).
- **The steps** (architecture 3.1):
  - the package's name is checked on every run, as the first step;
  - cosign is downloaded by a step of its own: the signing and the rerun need it;
  - Node 24.22.1 with its npm 11.19.1 is downloaded at an exact version and with a sum from `SHASUMS256.txt` in the file itself, like cosign (R08);
  - before the GitHub release, which is immutable, the archive is checked without tokens: the file exists, everything in it is under `package/`, the name and the version are the input and the number without `v`, there is no `private`, no `publishConfig` and no `tag` of its own, and `repository` is an object with the url of this repository. Then the registry: no package — an error with `publish: true`, since the author publishes the first version; the version exists with the same `integrity` — nothing to publish; with another — an error. A version below the registry's highest non-deprecated X.Y.Z goes with the tag `previous`. A trial run of npm, `--dry-run`, must read the same file and the same `integrity`;
  - after "Verify the release" npm publishes the archive.
- **npm's isolation** is one script, `npm-isolated`. The Node step writes it, and the check and the publishing call it. An empty folder in `RUNNER_TEMP`, with neither a `package.json` nor an `.npmrc` of the project: the check's files lie apart. No user or system configuration files, no variables `npm_config_*`, `NODE_OPTIONS` or `NPM_ID_TOKEN`, the registry on the command line, no scripts. So the caller's `.npmrc` and `publishConfig` do not lead npm to another registry. This is a defence against others' settings, not against code that ran on the runner before (В23).
- **The token is for publishing only.** The check step runs without the OIDC variables, and npm's trial run, which also tries the exchange, skips it at once. npm gets a token only in the publishing step, and that step runs only with `publish: true`. Nor does the step publish after a refusal that `release-refusal` lets through.
- **The verdict is the registry, not npm's exit code.** npm can exit with 0 when the version is only staged, and fail when the version is out (npm/cli#9889). So the step asks the registry until the version appears — up to 5 minutes, and if npm failed, half a minute. It takes the packument with `?write=true`, as npm does before writing: without it the registry's CDN serves a copy up to 5 minutes old (architecture 4). Then the archive from the registry must match the file byte for byte. No provenance — a warning. npm runs with `--loglevel verbose`: it writes a refusal of the OIDC exchange only at this level.
- **The rerun** of a commit already released publishes the archive from its release. The step downloads the archive with `.sigstore.json` and checks the release's attestation and the signature. The signature's identity is this workflow at any SHA or ref of `.github`, by a regexp, with the caller's repository and `TARGET`: the button may run with another pinned version of the shared file. Whether the SHA is a release of `.github`, Т-27 decides. So the caller recovers if npm refused after the release: a restart of the run publishes the same file.
- **npm is under Artistic-2.0**, and this license is not in `spec`'s list (R12 spec). It is a CI tool, and it puts nothing of its own into the package: it sends a ready archive. Here it is named an exception, like ShellCheck in R08. That npm with Node is in every devcontainer without such an entry at `spec` is В26 in RUN.md, «в реестр spec».
- **The trust boundary.** npm trusts the caller's workflow file by name, from any of its branches: a branch with a changed `release.yml` of the caller could publish. The shared release does not publish from a pull request, and only someone with write access can write to branches. The author accepts this. An environment with a branch rule — when the repositories get other contributors with write access. Besides, npm unpacks on the runner an archive that the caller's code built, and the job always has the OIDC variables — this is next to В23.
- **Rejected:**
  - outputs of the shared `release.yml`: the step is inside it, and the callers do not need them;
  - `npm view` instead of the packument: it answers E404 both to a missing version and to a missing package;
  - an explicit `--tag latest`: it would remove npm's protection against a version below the highest;
  - `actions/setup-node`: not pinned by a sum, like cosign-installer above;
  - Node 24.21.0, as in the Dockerfile: a step with the right to publish needs the latest release with security fixes;
  - an environment with a branch rule now: the settings are at each caller, and there is one contributor with write access;
  - a real publishing of a trial package: actions outside the repository, and a version in npm cannot be undone (rule 4 of RUN.md).
- **The trial** is pull request #61, not merged (architecture 4): a positive run and seven negative ones, each with its own message, and neither a release, nor a tag, nor a version in npm. The logic of the registry, the rerun and the publishing was checked locally — by steps taken out word for word, with stubs of `curl`, `gh`, cosign and npm.
- **What stays open** — until the first real publishing, T24 canvas:
  - whether the registry accepts provenance from a reusable workflow of another repository;
  - npm/cli#9969 in repositories with an immutable subject;
  - that a new trusted publisher setting allows only staged publishing by default.

  The outcome is added to RUN.md, T27.

— architecture 3.1, 3.3, 3.5, 3.6, 4; RUN.md, T27, В23, В26; `release.yml`.

— *Amendment 2026-10-22:* the release is out — `v0.1.9`, commit 41d5144, immutable and Latest; `gh release verify` confirms it. The caller's text in architecture 3.3 calls the shared `release.yml` by this SHA. Of a caller without `npm-package` the release asks nothing new. That the cosign step, moved out on its own, broke nothing at callers without npm, the first release of `module-kit` at this SHA will confirm. — architecture 3.3; RUN.md, T27.

— *Amendment 2026-11-01:* by the move to `spec` v0.4.1 (R25), task T31. `spec` recorded the rows В23, В25 and В26 that this entry speaks of, gave the `paths` template a new rule, and showed by its own publishing to npm what the npm step waited for.
- **В23** — the 2026-10-22 addition to Т-27 and an item of T37 `spec`. The SHA of the release of `.github` in the SAN does not pin all the code that ran with the right to sign, and the check's condition is also the immutable releases of `spec` with the ruleset of its tags `v*`. What is said in "Consequence for trust" of the amendment by T25 — "Whether this matters for the check of the signature (Т-27), `spec` decides: this is В23 in RUN.md" — now reads: T37 `spec` decides, by the addition to Т-27.
- **В25** — the 2026-10-22 amendment to R31 spec: the release of `spec` runs the recipes in copies of the checkout, as this one does since T28. What is said in the amendment by T28 — "the release of `spec` is built the way this one was before T28 … This is В25" — is history.
- **В26** — the 2026-10-22 amendment to R12 spec: npm under Artistic-2.0 is a named exception, a development and CI tool, in all repositories. The item "npm is under Artistic-2.0" of the amendment by T27 now rests on it, and its words about В26 are history.
- **The `paths` template** — the 2026-10-22 amendment to R31 spec, by the row В6 `module-kit` (Д27 in RUN.md `spec`): a list of what a release is built from, by the kind of repository, and not everything but exceptions. The template of the kind go in architecture 3.3 is `*.go` without `*_test.go`, `go.mod`, `go.sum`, `justfile`, `LICENSE`, `.devcontainer/Dockerfile` and `.github/workflows/release.yml`. Exactly `*.go`, not `**/*.go`: git's pathspec without the magic `glob` reads `*` across `/` too, and `**/*.go` requires a slash and would miss a Go file in the root (architecture 4). The list of the kind typescript comes with the first release in TypeScript, at `canvas`. `release.yml` itself does not change: `paths` is an input.
- **The npm step.** Two of the three things that "What stays open" of the amendment by T27 left to the first publishing, the publishing of `spec` showed. On 2026-10-29 its `release.yml` — with the npm steps of the shared v0.1.10, carried over almost word for word — published `@altnovatrail/spec` 0.4.1 by trusted publishing, with provenance (the second 2026-10-29 amendment to R37 spec; architecture 4):
  - npm/cli#9969 did not hinder it, though the bug is open: the OIDC subject of `spec` is immutable, as at `canvas`;
  - the direct publishing was allowed by the flag `--allow-publish` of `npm trust` — the one architecture 3.3 already calls for.

  What remains is provenance from a reusable workflow of another repository: at `spec` its own `release.yml` publishes. The first publishing of `canvas` will show it (Д7 in RUN.md).
- **The unpublished number.** Carrying the steps over, T51 `spec` found a hole in the shared step and wrote to `.github` about it. A number that npm has already given out and that was unpublished passes the check before the release: npm will not take it — "Once `package@version` has been used, you can never use it again" (as the second 2026-10-29 amendment to R37 spec quotes it) — while the GitHub release will come out, and a rerun will not help. The message about another `integrity` before the release promises the next release, though every release of the line will take the same number. `spec`'s `release.yml` since T51 has both a check by the `time` of the package's document and two different messages. Carrying them into the shared step is T33 in RUN.md.

— architecture 2.3, 2.12, 3.3, 4; RUN.md, T31, T33, Д7.

— *Amendment 2026-11-01:* by В28, task T36 (R27). The second part of В28 `spec` recorded by the 2026-11-01 amendment to R31 spec: the `paths` list of each kind is kept by the template of architecture 3.3, and R31 spec gives only the rule by which it is made. Where the list in "Now" of the 2026-10-22 amendment to R31 spec differs from the template, the template is right. The price — a new base image — R31 spec now names too. What is said in the amendment above about `**/*.go` and the template stays as it is, and "the second part of В28" in R25 is closed. — architecture 3.3; RUN.md, T36.

— *Amendment 2026-11-01:* the unpublished number, task T33. The hole that the item "The unpublished number" of the amendment by T31 speaks of, the step "Check the npm package" closes the way `spec`'s `release.yml` does since T51 (the second 2026-10-29 amendment to R37 spec), and with one more case beyond it. The author's answers while planning — RUN.md, T33.
- **The unpublished number.** If the number is not in the `versions` of the package's document but is in its `time`, the run fails before the release. A version that is in `versions` but without `dist.integrity` the step takes for a version with another archive — "with the integrity none" — and not for an unpublished one. The registry keeps in `time` every number it has given out: in the `time` of `ua-parser-js` are 0.7.29, 0.8.0 and 1.0.0, and they are not in `versions` (architecture 4). And npm will not take such a number: "Once `package@version` has been used, you can never use it again. You must publish a new version even if you unpublished the old one" ([npm/documentation](https://github.com/npm/documentation/blob/c62df531ef34f168585672948b3e48f3e76bcfc3/content/policies/unpublish.mdx), commit c62df53, `content/policies/unpublish.mdx`, read 2026-11-01).
- **Two messages.** These are about the same other `integrity` and about the unpublished number. The step got `RELEASED`, the output `released` of the step of the number.
  - Before the release every release of the line will take the same number, and the message tells to raise `RELEASE_LINE` in the caller's release workflow.
  - After it — on a rerun or from the button — the next release will publish the package with a new number. So the message said before too, in both cases.
- **A package unpublished whole** — beyond `spec`'s step.
  - The registry answers such a package with 200, not 404: only `_id`, `name`, `_rev` and `time` with `unpublished`, without `versions` (architecture 4). The step recognizes it by both signs — `time.unpublished` and empty `versions`: a package published again has versions.
  - `npm view` of npm 11.19.1 reads such an answer as E404 — "Unpublished on …" ([npm/cli v11.19.1](https://github.com/npm/cli/blob/v11.19.1/lib/commands/view.js), `lib/commands/view.js`, read 2026-11-01). The step reads it the same as a 404. With `publish: true` the run fails before the release: npm takes no new versions for 24 hours — "If you entirely unpublish all versions of a package, you may not publish any new versions of that package until 24 hours have passed" (ibid., `unpublish.mdx`) — and then the next version is published by hand, like the first. Whether the trusted publisher setting survives the package, npm's documentation does not say, so the message tells to set it again if it is not there. With `false` — a notice, and npm's trial run goes on.
  - The old numbers of such a package are caught by the check of `time`, and its message then speaks of the package too: raising `RELEASE_LINE` is not enough if the package has to be brought back by hand.
  - `spec`'s step would let such a package through. The row В29 «в реестр spec» goes to it.
- **What the shared step does not need from T51 `spec`:**
  - a 404 always as an error: `.github` has `publish: false`, and trial #61 needed a package that the registry lacks;
  - a check of the bundle without the run's commit. The shared release signs only when `TARGET` is `GITHUB_SHA`: otherwise "Work out the version" gives empty `version` and `released`. So the run that signed went with `GITHUB_SHA` equal to the released commit, and a rerun publishes under the same equality, so `--certificate-github-workflow-sha "$TARGET"` is right. At `spec` the tip of `main` signs, and a commit before it can be released too;
  - the literal of the name and the folder `npm-release/` — `spec`'s arrangement.

  Otherwise the step's script is the same as `spec`'s, and edits are carried over by a `diff`.
- **Tests** — eleven cases in the suite (R28):
  - the unpublished number — before the release, after it and in a trial;
  - another `integrity` — before the release and after — and a version without `integrity`;
  - the time of other versions;
  - a package unpublished whole — before the release and after, in a trial and with old numbers;
  - `time.unpublished` next to versions.

  Breakages of the step — ten ways, and each gave a red suite. The step, taken out of the file word for word, passed against the real registry too, without a token (architecture 4).

A caller without `npm-package` sees nothing new. — architecture 3.1, 3.3, 4; RUN.md, T33, В29, Д7.

— *Amendment 2026-11-01:* the release is out — `v0.1.11`, commit c1b8487, immutable and Latest; `gh release verify` confirms it. Of the shared workflows, only `release.yml` differs in it from `v0.1.10` (`git diff v0.1.10 v0.1.11`), and the other seven are the same. Dependabot's pull requests will raise at the callers the reference to every shared workflow, not only to `release.yml`. The caller's text in architecture 3.3 calls the shared `release.yml` by this SHA. — architecture 3.3; RUN.md, T33.

— *Amendment 2026-11-02:* by the move to `spec` v0.6.2 (R30), task T38. Т-27 is closed by R77 spec, and what this entry left to it reads as follows:
- **The rerun.** "Whether the SHA is a release of `.github`, Т-27 decides" in the amendment by T27 now reads: R77 spec decided. Only the SHA of a commit of a release of `.github` no lower than v0.1.7 fits, on the history of its `main`, without a branch or a tag, and `spec`'s recipe `release-verify` checks this. The rerun step still lets in any SHA or ref of `.github` by a regexp. T39 in RUN.md fixes it — by the recipe, by the author's decision while planning E10.
- **В23.** "T37 `spec` decides, by the addition to Т-27" in the amendment by T31 reads: R77 spec decided. Given immutable releases and the ruleset of `spec`'s tags, the check trusts `spec`'s tags too, and the rest is pinned by the SHA of the release of `.github` and the caller's commit ("The check trusts the tags of `spec` too" in R77 spec).
- **The minimum.** Files signed by the shared release below v0.1.7 R77 spec rejects. Among them are the files of `module-kit` `v0.1.0`, signed by v0.1.4 (the 2026-10-21 amendment above). The files of `tutor` `v0.1.0`, signed by v0.1.11, the recipe accepts (architecture 4). The signing itself and its check before publishing do not change.

— architecture 2.3, 4; RUN.md, T38, T39; R30.

— *Amendment 2026-11-02:* the signature by `spec`'s rule, task T39. The rerun path checks the signature by `spec`'s recipe `release-verify`, and a run that publishes stops first thing if the caller's workflow is not its `release.yml` on `main` or the shared `release.yml` is pinned otherwise than by a SHA of its own path. The author's answers while planning E10 and to В31 — RUN.md, T39.
- **The rerun.** The step "The npm package of the release" downloads the archive with the bundle and checks the release's attestation on the runner, as before. Instead of `cosign verify-blob`, `release-verify` checks the signature — by the script `spec/tools/toolchain/toolchain.sh` from a fresh copy of `spec/` alone — the recipe reads nothing else —, without `GH_TOKEN`. The recipe lets in the shared `release.yml` only at a SHA of a release of `.github` no lower than v0.1.7, on the history of its `main`: of the release that the releasing run pinned, since the button may run with another. Besides, it checks the caller's `release.yml` on `main`, the tag's commit and the numeric IDs. The rerun no longer needs cosign, and its step runs only when there is something to sign. If Sigstore, GitHub or the npm registry do not answer, the recipe refuses, and the job is restarted: nothing goes to npm.
- **Where the verdict runs.** The recipe runs in the caller's `toolchain` stage, like the number (the amendment by T25), and it needs the network from there too. Its answer is the answer of code that the shared release trusts with the build anyway. The attestation, which does not depend on this stage, `gh` checks on the runner.
- **The trial.** When `npm-package` is set and a release comes out, the step "spec's release-verify, asked ahead" calls before the build a dry run of the recipe with the rerun's arguments. The recipe is in `spec` since v0.6.0, and an older tag stops this very release, not a rare rerun, and tells to move `spec/` to v0.6.0, as the message about v0.2.17 tells to move it to v0.2.17. Callers without `npm-package` do not need the new tag. The dry run checks only that the recipe exists and the call parses. What the recipe needs to work — Node in the `toolchain` stage and the repository's ID in `spec`'s table — all thirteen repositories have by the 2026-11-01 amendment to R77 spec, and the ID of a new one is added by the task of `spec` that creates it. If this turns out otherwise, the rerun will refuse even after a restart, and then the same checked file is published by hand (architecture 3.3).
- **The identity.** The step "The identity the signature will carry", with `publish: true`, runs before checkout and stops the run if:
  - `github.workflow_ref` is not `<repository>/.github/workflows/release.yml@refs/heads/main`, by the author's decision while planning E10;
  - `job.workflow_ref` is not `altnovatrail/.github/.github/workflows/release.yml@` and a SHA of 40 characters. The SHA's form is the author's answer to В31, and the path before it was added by the review of T39: it is the same check of a string, without network, and it stops a copy of the shared workflow pinned by a SHA.

  A certificate of such a run R77 spec would reject, and a release's files are immutable. The branch was held before too, by the job's condition and the button's step, and the file name and the pinning by nothing. Whether this SHA is a release, the shared release does not ask: that is a second implementation of a part of the rule, and a SHA not from a release the recipe will catch at the consumer. Dependabot offers only SHAs of releases anyway (R04).
- **Rejected:**
  - a check of its own in the step — a regexp `@<SHA>`, the tags of `.github` by `git ls-remote` and the history of `main` from 0acbf75. It is a second implementation of a part of R77 spec, and the rule itself rejected "a check of its own at each consumer";
  - the trial inside the step "Work out the version": the step would have to be given to the suite whole, with git and the submodule, for the sake of one line, while as a step of its own the trial is checked separately;
  - the recipe from the copy that the container of the step of the number has already had: a fresh copy is simpler than the script's sum, as at the publishing step. Only `spec/` is copied: a copy of the whole checkout with the history for a recipe that reads two files is a finding of the review of T39;
  - a check by the recipe of the new release's files — R30 and T39, «Не делать».
- **The trial and the suite** — architecture 4. Twelve cases in the suite: three about the steps' conditions, three about the identity, two about the trial and four about the rerun. The rerun step and the trial, taken out word for word, passed against the real recipe on the file of `tutor` v0.1.0 and on `spec` v0.5.3. There is no trial pull request: the rerun path runs only with `publish: true` and a released commit.

A caller without `npm-package` that pinned the shared `release.yml` by a SHA from its `.github/workflows/release.yml` — and all do so, by the template of architecture 3.3 — sees nothing new. — architecture 2.3, 3.1, 3.3, 4; RUN.md, T39, В31; R30.

— *Amendment 2026-11-02:* the release is out — `v0.1.13`, commit 09443e1, immutable and Latest; `gh release verify` confirms it. Of the shared workflows, only `release.yml` differs in it from `v0.1.12` (`git diff v0.1.12 v0.1.13`). The caller's text in architecture 3.3 calls the shared `release.yml` by this SHA. — architecture 3.3; RUN.md, T39.

— *Amendment 2026-11-02:* by the move to `spec` v0.6.3 (R31), task T40. `spec` recorded the rows В29, В32 and В33 that the amendments to this entry speak of (Д64 in RUN.md `spec`):
- **Т-35** is closed by the 2026-11-02 amendment to R63 spec — the author's answer, option 1′. The caller will name as an input the file of the previous release, for `modules`, `module-index.json`. Before the build, a step of the shared release downloads this file with its bundle from the release with the previous one's tag and checks it by the recipe `release-verify` on the runner. The recipe `release-files` gets the file already checked, together with the number, and to the first release the shared release says explicitly that there is no previous one. The recipe still runs in a container without git, submodules or tokens and does not go to the network. There is no input yet: T41 in RUN.md writes it, and until then the recipe gets, as before, only the number.
- **The rerun path.** The 2026-11-02 amendment to R77 spec names the last item of R77 spec fulfilled since v0.1.13 (the amendment by T39 above). `spec`'s own `release.yml` now calls the same recipe on a rerun (В32).
- **The unpublished number.** The words "`spec`'s step would let such a package through. The row В29 «в реестр spec» goes to it" in the amendment by T33 are history. Since v0.6.3 `spec`'s step reads a package unpublished whole as a 404, and a version without `dist.integrity` as another archive. Beyond the shared step it looks for the number in `time.unpublished.versions` too: in a package unpublished whole the numbers lie there, not as keys of `time` (architecture 4). The shared step does not find such a number unpublished, but finds the whole package unpublished. With `publish: true` the run fails before the release anyway, but the message speaks of a pause of 24 hours, not of the number being gone. With `publish: false` the step goes on, as with a new number. Whether to take this check into the shared step is В34 in RUN.md.

— architecture 4; RUN.md, T40, T41, В34; R31.

— *Amendment 2026-11-02:* the file of the previous release, task T41, by the 2026-11-02 amendment to R63 spec — option 1′ (R31). The shared `release.yml` has the input `previous-file`: the name of the previous release's file, for `modules`, `module-index.json`. An empty input — everything as before, and cases of the suite hold this.
- **The name** is checked by a step of its own on every run, whether a release comes out or not, like the name of `npm-package`: the rules are the same as for the names of the files of `dist/`, and not a bundle.
- **The step "The previous release's file"** runs before the build when the input is set and a release comes out. The previous one's tag is the output `previous` of the step of the number, that is, the newest release (architecture 4). From this release the step downloads the file with its bundle and checks the attestation on the runner, with `::error::` if it does not hold. The signature is checked by the recipe `release-verify` — from a new copy of `spec/` alone and without `GH_TOKEN`, as on the rerun path (the amendment by T39 above). The checked file alone goes into `$RUNNER_TEMP/previous`, and the output `handed` says what the build will get: `file`, or `none` for the first release. If the file or the bundle is missing or the check failed, the run stops before the build: failing to read the index means a refusal (R63 spec).
- **The first release** has no previous one. The step downloads nothing, but asks the recipe by a dry run of just with the arguments the next release would give, the path to the file included. Otherwise a caller on `spec` older than v0.6.0 would stop only at the second release, and the first would already be out, immutable.
- **The recipe** `release-files` gets as its second argument the path `/previous/<name>`, and the folder mounted read-only. For the first release the second argument is empty. With the input there are always two arguments, so an empty argument is an explicit "no previous one" (R63 spec). The recipe and the input change together: to a number of arguments the recipe does not expect, just answers with a refusal, and the run stops before the release (architecture 4). The recipe still needs neither the network, nor a token, nor `spec/`.
- **The build** goes by the output `handed` and does not itself work out whether this is the first release: with the input and without `handed` it stops.
- **The chain.** With the input, "Build the files" requires in `dist/` a file with the same name: the next release will take it from here, and a release's files are immutable.
- **A caller with the input** needs the `spec` submodule v0.6.0 or newer, as with `npm-package`. The text for it is architecture 3.3.

*Cost:* each release with the input has one more download and check of a signature, with a connection to Sigstore, GitHub and the npm registry. When they cannot be read, the run refuses before the build, and the job is restarted.

*Rejected:*
- a file in the commit's tree before the build: it would mix with the tree, the recipe could change it, and "no previous one" would have to be said by the absence of the file;
- a file that the recipe itself takes — the first option of Т-35 as it is: the recipe's container has no `spec/` with `release-verify` (the 2026-11-02 amendment to R63 spec);
- a separate trial step for `previous-file`: for a release with a previous one the check itself serves as the trial, and for the first, the dry run in the same step. A caller with both `npm-package` and `previous-file` will ask the recipe twice at the first release. A common trial would tie the conditions of two inputs together for the sake of one dry run;
- a shared script for this step and the rerun step, which both download a release file and check its attestation and signature by the recipe: the shared workflow would take the script's file by a second checkout of `.github` at `job.workflow_sha` (architecture 2.7), and the shared workflows keep everything in their own file. The steps are copies of one sequence, and an edit of one is carried into the other by hand.

— architecture 3.1, 3.3, 4; RUN.md, T41; R31.

— *Amendment 2026-11-02:* the release is out — `v0.1.14`, commit 96dadfe, immutable and Latest; `gh release verify` confirms it. Of the shared workflows, only `release.yml` differs in it from `v0.1.13` (`git diff v0.1.13 v0.1.14`). The caller's text in architecture 3.3 calls the shared `release.yml` by this SHA, and the input `previous-file` is there from it on. — architecture 3.3; RUN.md, T41.

— *Amendment 2026-11-02:* the number of a package unpublished whole, task T42, by В34 (the amendment by T40 above).
- **The correction.** The item "The unpublished number" of the amendment by T40 is wrong. In a package unpublished whole, `time` holds a key for every number the package held, not only `created`, `modified` and `unpublished`. In `time.unpublished.versions` lie the numbers it held last, and those unpublished earlier are only in `time` (architecture 4). The first reading lost these keys by a jq filter. The former step `(.time // {}) | has($v)` found such a number, and with `publish: true` the run failed with a message about a number that is gone and a note about the package, as a case of the suite holds since T33. The words "The shared step does not find such a number unpublished", "the message speaks of a pause of 24 hours" and "With `publish: false` the step goes on" are wrong, and В34 posed no question.
- **What was taken.** The step's jq check is the same as that of the step of `release.yml` in `spec` v0.6.3, byte for byte: `time` or `time.unpublished.versions`. The second half catches a number that `unpublished.versions` would name without a key in `time`; the registry has not answered so, and it does no harm. It was taken so that the copies of the step match and edits are carried over by a `diff` (the second 2026-10-29 amendment to R37 spec). The suite's fixture `tombstone()` stayed as it was — that is how the registry answers — and a new fixture holds the number without a key.
— architecture 4; RUN.md, T42, В34.

— *Amendment 2026-11-02:* the release is out — `v0.1.15`, commit 89d3cee, immutable and Latest; `gh release verify` confirms it. Of the shared workflows, only `release.yml` differs in it from `v0.1.14` (`git diff v0.1.14 v0.1.15`). The caller's text in architecture 3.3 calls the shared `release.yml` by this SHA. — architecture 3.3; RUN.md, T42.

— *Amendment 2026-11-08:* the npm step of the shared release published the first package — `@altnovatrail/canvas` 0.1.1. The release of `canvas` v0.1.1 did it on 2026-11-02, through the shared `release.yml` v0.1.13 (task T43, the check of Д7).
- **What the publishing showed.** npm accepts trusted publishing from a reusable workflow of another repository. The version's provenance names the caller's workflow: `.github/workflows/release.yml` of `altnovatrail/canvas` on `refs/heads/main`, — and the run calls the shared `release.yml` by the SHA 09443e1. npm/cli#9969 did not hinder the publishing. So the last thing that T27 left unchecked is checked (architecture 4, «Переход на `spec` v0.9.8»).
- **What remains.** The time to wait for the version in the registry: the step waits 5 minutes for it, and `spec` 20 (the 2026-11-02 amendment to R37 spec; Д91 in RUN.md `spec`). This is a task of its own, in table 2 of RUN.md.

Д7 is closed. — architecture 4; RUN.md, T43, Д7; T27 in [docs/plan/E7.md](plan/E7.md).

— *Amendment 2026-11-08:* **the step "Publish to npm" counts a version as out once the package's document has shown it and the registry has served its archive, and waits for both in rounds every 10 seconds, up to 20 minutes by the clock and no more than 120 rounds. A package on which npm failed is looked for during three rounds, as long as the document has not shown it. The job's `timeout-minutes` is 45.** The task T44, by Д91 in RUN.md `spec`.
- **Why.** The registry gives out a version after a check, "up to 15 minutes or more, at peak times" (the 2026-11-02 amendment to R37 spec), and the step waited 5 minutes. And the registry may serve the archive later than the document: that is how the release of `spec` v0.7.2 failed, and the step downloaded the archive by a single `curl`, which does not retry a 404 (the second 2026-11-03 amendment to R37 spec). The step of `spec` has waited this way since v0.7.2, and the copies of the step match again, as the check of the number has matched since T42.
- **How.** The rounds, the texts of the errors and the limits of the reads — the document `--max-time 30` with `--retry 3`, the archive `--max-time 60` with no retry — are as at the step of `spec` v0.9.8, for one package: the input `npm-package` names one. An archive with another `integrity` or from someone else's address is not requested at all; the check after the rounds rejects it. The limit is checked at the end of a round, so a round already under way adds no more than three to the 20 minutes: four reads of the document of 30 seconds each with the pauses of `--retry`, and a minute for the archive. A rerun of the job, if the registry is slower than even 20 minutes, finds the version by the step "Check the npm package" by `integrity` and publishes nothing. Whether the registry then serves the archive, the rerun does not wait for: the bytes of the archive are held by the `integrity` in the document, and npm checks it on install. So does the step of `spec`.
- **45 minutes.** The longest successful job of the callers by 2026-11-08 is 333 s, at `canvas`. With 20 minutes of waiting and three for the last round that is about 29 minutes, and 45 leave a margin for a slow build (architecture 4).

*Rejected:*
- only the limit, as Д91 asked, and the archive still by a single `curl`: 20 minutes of waiting for the document would not have saved a run that would fail on the archive's 404;
- `--retry-all-errors` on the archive's `curl` instead of rounds: the retries would go with no overall limit, and a package on which npm failed would be waited for as long as one that came out;
- the job limit of `spec` — 50 by the 2026-11-02 amendment to R37 spec, and now 85: beyond waiting for npm it waits until the Go module proxy serves the release's modules (the second 2026-11-03 amendment to R64 spec). The shared release does not check Go modules, and it needs no margin for that.

This requires nothing new of the caller. — architecture 3.1, 4; RUN.md, T44.

— *Amendment 2026-11-08:* the release is out — `v0.1.16`, commit ea6771c, immutable and Latest; `gh release verify` confirms it. It differs from `v0.1.15` in `release.yml` — the npm step by T44 — and in `codeql.yml` and `scorecard.yml`: `github/codeql-action` v4.39.1, Dependabot's pull requests #71–#73 (`git diff v0.1.15 v0.1.16`). The calling text in architecture 3.3 calls the shared `release.yml` by this SHA. — architecture 3.3; RUN.md, T44.

## The TypeScript wrapper

**R19. The TypeScript wrapper is a shared `typescript.yml`, after the pattern of `go.yml`: the same four recipes of the caller — `ci-lint`, `ci-test`, `ci-vuln` and `ci-licenses` —, in the `toolchain` stage of its devcontainer, the same license list, and the container with `--init` and `--ipc=host`, for tests in a browser. This is a contract: `canvas` writes the recipes of its first code by it (T08 canvas), and T22 writes the file itself, together with that code.**
- **The wrapper** (architecture 3.1):
  - as `go.yml` (R16): `on: workflow_call`, with no inputs and no secrets (R05), the permissions `contents: read`. The matrix `check: [lint, test, vuln, licenses]` with `fail-fast: false`. The checkout is without the submodule. The caller's `toolchain` stage is built with no context, and `just ci-<check>` runs in it as the runner's user, with `HOME=/tmp`; of the step's environment only `ALLOWED_LICENSES` goes into the container;
  - its own are the `docker run` flags `--init` and `--ipc=host`. This is how Playwright advises running Chromium in Docker (architecture 4), and a test in a browser runs in CI the way the tool itself advises running it;
  - the container runs with the network: `npm ci` and `npm audit` need it;
  - each of the four jobs builds the whole `toolchain` stage, with no cache, and with browsers in it — the browsers too, though only `ci-test` needs them. What this costs, the code of T08 canvas will show. T22 will measure it and decide whether a build cache or a stage of its own for `ci-test` is needed;
  - the checks are "TypeScript / lint", "TypeScript / test", "TypeScript / vuln" and "TypeScript / licenses", when the caller's job is called "TypeScript". Each is a name of its own in the ruleset `main` (R30 spec);
  - the license list is a copy of `ALLOWED_LICENSES` in `typescript.yml` itself, as in `go.yml` (architecture 2.7). From T22 `self-ci.yml` checks both copies against the list of `spec`.
- **Recipes.** What each checks is below; with what it does so and at which versions, the repository decides and pins (R16):
  - `ci-lint` — the format, the lint and the type check;
  - `ci-test` — the tests, in a browser too;
  - `ci-vuln` — the vulnerabilities of the lock file's packages by published advisories;
  - `ci-licenses` — the license of every package of the lock file, of the development tools too, by `ALLOWED_LICENSES`. An exception is by name and only for a tool that ships nowhere, each with its own decision (R12 spec).

  The recipe `ci`, which calls all four, is for the developer: the wrapper does not call it.
- **From the repository** (architecture 3.1, 3.3):
  - Node is in the `toolchain` stage, at an exact version and with the archive's sum (R34 spec), as in the Dockerfile of the repository template of `spec`. The packages are installed by npm, which comes with Node; another package manager comes at an exact version in the same stage and with its own decision;
  - the lock file lies in the repository, and `.npmrc` sets `ignore-scripts=true` and `save-exact=true`, as at `spec/tools` and at canvas-api (architecture 4);
  - the packages are installed by the recipe itself, `npm ci` from the lock file: each job runs in a new container. `ci-vuln` and `ci-licenses` need only the lock file itself;
  - the browsers for the tests are in the `toolchain` stage, at the image's build: their system packages are installed by `apt-get`, as root, and in CI the container runs as the runner's user. The path to them is set by `ENV PLAYWRIGHT_BROWSERS_PATH` in the stage itself, outside `HOME`: of the step's environment the wrapper passes only `ALLOWED_LICENSES`, and `HOME` in CI is `/tmp`;
  - the browsers' revision is the one the version of Playwright in the lock file expects: "Each version of Playwright needs specific versions of browser binaries to operate" (architecture 4). So the Playwright package and the browsers are raised by one change. How to arrange this with Dependabot, T08 canvas decides;
  - the browsers' integrity is by the rules: an archive is checked against a sum from the publisher's own list (R34 spec), an image is pinned by tag and digest (RULES.md, Hard rules). Playwright's downloads have no list of sums (architecture 4), and R34 spec cannot be applied to them as it is. Within the rules is the browsers' folder from the Playwright image, pinned by tag and digest: in it the browsers lie in `/ms-playwright` (architecture 4). A sum the repository computed itself is a departure from R34 spec, and then it is a question «в реестр spec». T08 canvas chooses;
  - the browsers do not come from the lock file, and `ci-licenses` does not see them. Their licenses are named by the decision that brings them in — as an exception for a tool that ships nowhere (RULES.md, Licenses);
  - the code and the tests do not read `spec/` (R21 spec); in `dependabot.yml` is the ecosystem `npm`, with a pause of three days (architecture 3.3).
- **The recommendations to `canvas`** are not terms of the contract:
  - `ci-vuln` — `npm audit --omit=dev --audit-level=high`, as R48 canvas-api: the advisories of level high and above about the packages the result is built from;
  - `ci-licenses` — a script of its own over the lock file, as `licenses-check` of `spec` and `web/scripts/licenses.ts` of canvas-api, until `spec` gives its check to other repositories (В20 in RUN.md).

— *Why:* the author's decisions of 2026-10-21 — two wrappers, as R03 decided, and the contract before the code of `canvas` (RUN.md, epic E5, T21). The rest is the executor's proposal by the recommendations.
- The names are the same as at `go.yml`. T08 canvas writes the recipes «так, как их позовёт обёртка», and canvas-api keeps its checks under the same names (R49 canvas-api). Then the checks are named the same in all the repositories, and their rulesets read the same.
- The type check is part of `ci-lint` and is not a check of its own. So it is at canvas-api: Biome gives the format and the lint, and TypeScript only the types (R47 canvas-api). A type check of its own would be one more job: one more build of the image and one more `npm ci`.
- `ignore-scripts` is in the repository's `.npmrc`, and the packages are installed the same way in the development container and in CI. Were the wrapper to set it through `npm_config_ignore_scripts`, CI would part from the container: on `npm run` npm then does not run the repository's own `pre`- and `post`- scripts either (architecture 4).
- `--init` and `--ipc=host` are Playwright's recommendation for Docker. Without `--ipc=host` "Chromium can run out of memory and crash" (architecture 4).

— *Rejected:*
- one wrapper for both languages, with the checks in an input: `go.yml` hardly depends on the language, but TypeScript has flags of its own for the container and a contract of its own about the packages. The author's decision is two wrappers, as R03;
- names of its own for TypeScript and a separate type check — for the reasons above;
- `npm ci` as a step of the wrapper: how to install the packages, the repository knows, and `ci-vuln` and `ci-licenses` need no packages. In the development container the recipe installs them anyway;
- `npm_config_ignore_scripts` from the wrapper — for the reason above;
- OSV-Scanner as a term of the contract. The checking tool is the repository's (R16). OSV-Scanner 2.7.0 is under Apache-2.0 and comes with sums, but it needs the network or a database downloaded beforehand (architecture 4), and `npm audit` already comes with npm;
- `--shm-size` instead of `--ipc=host`: Playwright advises `--ipc=host`, and the size of the memory would have to be chosen with no source.

— *Consequence:* by this entry `canvas` writes the recipes, `.npmrc` and the `toolchain` stage (T08 canvas), and the calling job by the text of architecture 3.3 (T23 canvas). `typescript.yml` and the check of the list's second copy in `self-ci.yml` are written by T22, once the code of T08 canvas is in a pull request. — architecture 2.7, 3.1, 3.3, 4; RUN.md, T21, T22, В20.

— *Amendment 2026-10-21:* `typescript.yml` is written (T22) — by this entry, and with one addition: `CI` goes into the container too.
- **`CI`.** Vitest takes two defaults from it: `browser.headless` — "Default: `process.env.CI`", `allowOnly` — "Default: `!process.env.CI`". GitHub sets it on every runner: "Always set to `true`" (architecture 4). Without it a test in a browser in CI would try to open a window, and `test.only` would pass unnoticed. What is said above — "of the step's environment only `ALLOWED_LICENSES` goes into the container" in "The wrapper" and "of the step's environment the wrapper passes only `ALLOWED_LICENSES`" in "From the repository" — now reads as "only `CI` and `ALLOWED_LICENSES`". `go.yml` gets no change: its recipes do not need `CI`.
- **`--ipc=host` only at the job `test`.** Only `ci-test` launches the browser. `ci-lint`, `ci-vuln` and `ci-licenses` run the pull request's code with no browser and stay in their own IPC namespace of Docker, and `--init` is at all four. So reads, too, what is said above about the flags `--init` and `--ipc=host`.
- **The trial and the release** are the author's decision of 2026-10-21 (RUN.md, T22). The trial is pull request #40 in `.github` itself, with no merge, and the release comes out at once, not waiting for the code of `canvas`. The first code in TypeScript — T08 canvas — calls the wrapper already by the release's SHA: on real code its very first pull request will check it, after the release, and the next release will fix an error. What is said above — "T22 writes the file itself, together with that code" — is history. A change of `typescript.yml` is checked from now on, too, by a trial pull request of `.github` that calls it by the local path. It is started from the commits of #40: GitHub keeps them in `refs/pull/40/head` even after the branch is deleted. So, after the review, the trial #42 repeated it (architecture 4).
- **The trial #40** is a package in TypeScript in the root, its four recipes and Chromium in the `toolchain` stage by the way recommended above: `/ms-playwright` from the Playwright image by digest and the system libraries through `apt`. All four checks "TypeScript / …" are green, the test in a browser passed in Chromium, headless by `CI`. Without the exception for `lightningcss` only "TypeScript / licenses" is red, and it names all 12 of its packages (architecture 4).
- **The cost of the browsers.** With them the `toolchain` stage builds in 49–52 seconds a job, without them in 21 seconds, though the Playwright image weighs about 986 MB and each job pulls it anew (architecture 4). Half a minute a job on a public repository, where minutes cost nothing (R16): neither a build cache nor a stage of its own for `ci-test` is needed. The cache `type=gha` moreover needs another build driver or the containerd store, and a token that a step `run:` does not get without a third-party action (architecture 4). Reconsider if the stage of `canvas` turns out noticeably dearer: T08 canvas will measure it.
- **The browsers' system libraries** are installed by `apt-get` with no exact versions: the Playwright image carries the browsers in `/ms-playwright`, and the libraries outside that folder. So did the trial. This concerns every repository in TypeScript with tests in a browser, and it is the question В21 «в реестр spec» in RUN.md. The recommendation is the Ubuntu archive at a date: `apt-get --snapshot` with the snapshot's number in an `ARG`, as a version (architecture 4). Until `spec` answers, T08 canvas decides. The version of the package `playwright` at the caller must match the image: "If the Playwright version in your Docker image does not match the version in your project/tests, Playwright will be unable to locate browser executables" (architecture 4).
- **The check of the list.** The step "The license lists of go.yml and typescript.yml" of the job "Workflows" checks both copies against the list of `spec` — and any other, if `ALLOWED_LICENSES` appears in one more workflow — and names the one that diverged (architecture 3.4).

— architecture 2.7, 3.1, 3.3, 3.4, 4; RUN.md, T22; `typescript.yml`; `self-ci.yml`.

— *Amendment 2026-10-21:* the release is out — `v0.1.5`, commit c772cc8, immutable and Latest; `gh release verify` confirms it, and `typescript.yml` is in it. The calling job in architecture 3.3 calls the wrapper by this SHA, and T08 canvas will be the first to call it. — architecture 3.3; RUN.md, T22.

— *Amendment 2026-10-21:* T23 canvas is merged into T08 canvas (pull request #14 of `canvas`, merged as 32e144a). The calling job, the checks "TypeScript / …" in the ruleset `main` of `canvas` and the first check of the wrapper on real code are all now T08 canvas, and "T23 canvas" above reads the same way. — RUN.md, T22.

— *Amendment 2026-10-21:* the wrapper has been checked by the first code in TypeScript. Pull request #18 of `canvas` (T08 canvas) calls it by the SHA of `v0.1.5`, passed all four "TypeScript / …" and was merged as 88492c4, and the ruleset `main` of `canvas` holds these checks. The wrapper needed no change. The `toolchain` stage of `canvas` builds in 65–93 seconds a job — dearer than the trial, but the argument about the cost of the browsers above stands: neither a cache nor a stage of its own for `ci-test` is needed. `canvas` installs the system libraries from a snapshot of the Ubuntu archive, as В21 recommends, and the question itself waits for `spec`. — RUN.md, T22.

— *Amendment 2026-10-21:* what else the first code of `canvas` showed — R12–R14 canvas on `main` 88492c4 and a message of the session of `canvas`. The contract itself does not change. What changes are the recommendations and how what is said above about the browser reads.
- **The browser is Google Chrome for Testing, not Chromium.** From v1.57 Playwright launches builds of Chrome for Testing: "Playwright now runs on Chrome for Testing builds rather than Chromium". In v1.64.1 both builds of the browser `chromium` — the one with a window and Chrome Headless Shell — are downloaded from `builds/cft/…` (architecture 4). `ABOUT` in the folder of Chrome Headless Shell is "Google Chrome … All rights reserved … See the Terms of Service at chrome://terms": these are Google's terms, not an open license (R13 canvas). Whether they fit "free terms for open source" (RULES.md, Licenses) is for `spec` to decide: it is В27 in RUN.md of `canvas`. `canvas` took the browser as a named exception, by the author's decision. "Chromium" above — at the trial and at the flags — reads as Playwright's browser `chromium`, that is, this build.
- **From the image, only the folder of the browser the tests launch.** The way recommended above is "the browsers' folder from the Playwright image". The trial #40 took the whole `/ms-playwright` so, and with it Firefox, WebKit, FFmpeg and the full Chromium with the proprietary `WidevineCdm`. The tests do not launch them, and the terms of each would have to be named. The recommendation is `COPY --from` of only the folder the tests launch. `canvas` copies `chromium_headless_shell-<revision>`, 273 MB, and its revision is an `ARG` by `browsers.json` of its version of Playwright (R13 canvas). The trial did not enter `main`, and `.github` has no such stage.
- **`headless: true` explicitly.** What is said in the amendment above — "Without it a test in a browser in CI would try to open a window" — is true for CI. But the development container has no `CI`, as it has no display, and `just ci` would fail there (R12 canvas). The recommendation is `browser.headless: true` in the configuration of Vitest. The wrapper still passes `CI`: by it Vitest does not let `test.only` through.
- **Dependabot** (architecture 3.3). The entry `npm` of `canvas` is by the text of 3.3, with two additions (R12 canvas):
  - the group `vitest` — `vitest` and `@vitest/*`: `@vitest/browser-playwright` requires `vitest` at an exact version, and separate pull requests would be red;
  - `ignore` of the major versions of `@types/node`: the types follow Node, and Node in the Dockerfile is raised by hand.

  It was confirmed too that Dependabot does not see the browsers. Its parsing of the Dockerfile takes only the lines `FROM` (architecture 4), and the Playwright image stands in `COPY --from`. So `playwright` comes by a pull request of its own and stays red until in that same pull request the image's tag and digest and the browser's revision are raised by hand (R13 canvas). This also settles what was left above to T08 canvas: "How to arrange this with Dependabot".
- **The cost.** The `toolchain` stage is built by five required checks, not four: by "Documents / docs-check-repo" too (3.1). On pull request #18 of `canvas`, run 39690774485, the step "Toolchain image" ran 57–67 seconds in each of the five jobs, and without the browser 18 (architecture 4). The conclusion of the amendment above is the same: no cache is needed. But the merge now depends also on `snapshot.ubuntu.com` and on the Playwright image of about 1 GB from MCR. The stage's base image came from MCR before too, and Node from nodejs.org. Reconsider if outages of these services start holding up the merge.
- **`npm` from a script by the same Node.** SonarCloud flagged `typescript:S4036` at `canvas`: `execFileSync("npm", …)` looks for the program in `PATH`. The security rating of new code became B, and the quality gate red. `canvas` fixed it so: the script runs `process.execPath` with `npm-cli.js` from the installation of the same Node (architecture 4). The recommendation to the next repositories in TypeScript is the same.
- **The ruleset of `canvas`.** Ruleset 25506234 was changed on 2026-10-21 at 23:13 UTC by the executor of `canvas`, on the author's instruction (rule 4 of RUN.md `canvas`). Only the list of required checks changed: to the five earlier ones were added the four "TypeScript / …" and "CodeQL / analyze (javascript-typescript)", all with `integration_id` 15368. The first pull request they hold is #19 of `canvas`: all ten required checks passed (architecture 4). On the code of `canvas` no errors were found in the wrapper `v0.1.5` itself.

— architecture 3.1, 3.3, 4; RUN.md, В20, В21; R12–R14 canvas.

— *Amendment 2026-10-22:* by Д16 in RUN.md `spec`, with the move to v0.2.21 (R22). The browser of the contract — Playwright's `chromium` — is a build of Google Chrome for Testing under Google's terms, free for everyone, and not under an open license. The rule of licenses accepts such terms by the 2026-10-22 amendment to R12 spec, within its two bounds:
- NovaTrail does not distribute the browser: the `toolchain` stage, where it lies, is built on every run and published nowhere;
- the platform can be built, run and deployed without it — it only runs the tests.

What is said in the amendment above — "Whether they fit 'free terms for open source' (RULES.md, Licenses) is for `spec` to decide: it is В27 in RUN.md of `canvas`" — is history: `spec` has answered. The browser is still named by the decision that brings it in — as an exception for a tool that ships nowhere, as R13 canvas does. NovaTrail does not publish an image of the `toolchain` stage with such a browser (R12 spec). — architecture 3.1; RUN.md, T26.

— *Amendment 2026-10-22:* by В20, the task T26. `ci-licenses` checks the lock file by the recipe of `spec` `licenses-check-repo` (R39 spec), and the branch `licenses` of the wrapper takes the submodule `spec` for it. So the author decided in planning, 2026-10-22 (RUN.md, T26).
- **The contract.** `ci-licenses` calls `just -f spec/justfile licenses-check-repo <lock-file> [<exceptions file>]` from the repository's root. The list and the rule of exceptions are `spec`'s, at the tag the caller pinned. The tag is v0.2.18 or newer: from it the recipe has the bound `dev` (the 2026-10-22 amendment to R39 spec). What is said above in "Recipes" — "by `ALLOWED_LICENSES`" — now reads as "by the recipe of `spec`". The recommendation to `canvas` about a script of its own, "until `spec` gives its check", is history: `spec` has given it.
- **Exceptions** are a JSON file of the repository: at each package `license` — what the lock file says, or `null` — and `reason`, with the decision. The file's name is the repository's choice, the recommended one is `licenses.json`, as in `spec/justfile`. An exception for a license outside the list holds only for a package that the lock file marks `dev`, and `devOptional` is not `dev`. It also covers the builds for platforms that the tool itself names in `optionalDependencies`, as long as they are `dev` and under the same license. An exception for `null` or `SEE LICENSE IN <file>` carries no condition `dev`. So the recipe holds what is said above: "an exception is by name and only for a tool that ships nowhere".
- **Another package manager** ("From the repository" above). `licenses-check-repo` reads only npm's lock file, so such a repository checks its lock file with a tool of its own, with its own decision.
- **The submodule only at the branch `licenses`:** `submodules: ${{ matrix.check == 'licenses' }}`. There it is the checking tool, and the code and the tests do not read `spec/`: the three other branches run without it, as R21 spec requires. The expression's value suits the input: actions/checkout compares it with `TRUE` (architecture 4). As in `documents.yml`, the checkout takes all the caller's submodules, and the repositories of NovaTrail have one — `spec`, public: a private submodule or a submodule by SSH would stop this job. The wrapper has no check of the tag:
  - on a tag older than v0.2.17 there is no recipe, and the caller's pull request itself will show it;
  - on v0.2.17 the recipe exists, but without the bound `dev`. That the tag is v0.2.18 or newer is held by the contract, not by the wrapper, as is that `ci-licenses` calls the recipe of `spec` at all: what to check and with what is the caller's business (R16). The review found this in T26, and the only caller, `canvas`, is on v0.2.18.
- **The list follows the caller's tag.** R16 rejected this for `go.yml`: `config.mjs` is an internal file of `spec`, with no interface, and the list would depend on the caller's tag. The new fact is R39 spec: the list and the check have an interface, and the rule is one for all, at `spec`. For `go.yml` the argument of R16 stands: `spec` has no license check for Go.
- **`ALLOWED_LICENSES` stays** in `typescript.yml` and goes into the container, as before — for a recipe that still checks by its own list. Such is the one at `canvas` now: `scripts/licenses.ts`, until its T32. This is the debt Д6 in RUN.md, and `self-ci.yml` checks the copy, as before.
- **Rejected:** the branch `licenses` calls the recipe itself, `toolchain.sh spec licenses-check-repo package-lock.json licenses.json`, — as T25 expected (RUN.md, T25):
  - what to check and with what is the caller's business (R16; the header of `typescript.yml`), and so the wrapper would decide it for one of the four checks;
  - the paths of the lock file and of the exceptions would enter the contract, though the wrappers have no inputs (architecture 3.1), and a repository with another package manager would not pass the check;
  - `ci-licenses` would no longer run in CI, and `just ci` would part from CI;
  - the script of `spec` from the caller's submodule would run on the runner of a pull request, and a check of the tag would be needed, as in T25;
  - `canvas` would turn red until it sets up an exceptions file.
- **The trial** is pull request #58, with no merge, on the package of #40 (architecture 4). In the positive run the recipe answered "ok — 100 packages, 1 exceptions", and `ci-lint`, `ci-test` and `ci-vuln` confirmed that they have no submodule. The negative cases:
  - without the exception — 12 refusals;
  - a lock file of version 1 — a refusal;
  - `lightningcss` without `dev` — a refusal by the bound `dev`;
  - a copy of `ALLOWED_LICENSES` that diverged — "Workflows" is red, and "TypeScript / licenses" green.

— architecture 2.7, 3.1, 3.3, 4; RUN.md, T26, Д6; `typescript.yml`.

— *Amendment 2026-10-22:* the release is out — `v0.1.8`, commit 0ab2799, immutable and Latest; `gh release verify` confirms it. The calling job in architecture 3.3 calls `typescript.yml` by this SHA. From it the caller's `ci-licenses` can call the recipe of `spec`: the job `licenses` takes the submodule. The former `ci-licenses` with `ALLOWED_LICENSES` passes on it too. — architecture 3.3; RUN.md, T26.

— *Amendment 2026-10-22:* by Д6, the task T29. `typescript.yml` no longer has `ALLOWED_LICENSES`, and it does not go into the container. Its only caller, `canvas`, has checked the lock file by the recipe of `spec` since T32 and does not read the variable: `main` 379c774, the 2026-10-22 amendment to R12 canvas (architecture 4).
- **The container's environment.** Of the step's environment only `CI` goes into the container. So now read "only `CI` and `ALLOWED_LICENSES`" of the amendment about `CI` — in "The wrapper" and in "From the repository".
- **The list.** The wrapper has no list of its own: `ci-licenses` takes the list from `spec`, at the tag of its submodule (the amendment by В20). So read "the same license list" in the entry itself and "a copy of `ALLOWED_LICENSES` in `typescript.yml` itself" in "The wrapper". The item of the amendment by В20 "`ALLOWED_LICENSES` stays" is history, and Д6 is closed.
- **The check of the list.** The step of the job "Workflows" is now called "The license lists of the workflows". Only `go.yml` is required by name to have a copy, and any other workflow with a line `ALLOWED_LICENSES:` is checked, as before. "Both copies" — in "The wrapper" ("From T22 `self-ci.yml` checks both copies against the list of `spec`") and in "The check of the list" of the amendment about T22 — are now one, the copy of `go.yml`. `go.yml` does not change: `spec` has no license check for Go (the 2026-10-22 amendment to R16).
- **The trial** is pull request #65, with no merge, on the package of the trial #58 (architecture 4). Each `ci-*` starts with `test -z "${ALLOWED_LICENSES+x}"`, and all four "TypeScript / …" are green, as is "Workflows", which checked one copy. The step of the check was also checked locally, by seven cases.
- **Rejected:** keeping the variable in the wrapper for one more release, just in case. No caller reads it, and `app` and `skill-map` will take the check already by the contract with the recipe of `spec`. A recipe that refuses without the variable, as `scripts/licenses.ts` refused, would turn red on the pull request that raises the reference. But a recipe that without it silently checks by another list or does not check at all, the wrapper will not notice. That is held by the contract, not by the wrapper, as is the tag of `spec` (the amendment by В20): `ci-licenses` checks by the recipe of `spec`, and `ALLOWED_LICENSES` is no longer in the contract.

— architecture 2.7, 3.1, 3.4, 4; RUN.md, T29, Д6; `typescript.yml`; `self-ci.yml`.

— *Amendment 2026-10-22:* the release is out — `v0.1.10`, commit f3addb7, immutable and Latest; `gh release verify` confirms it. The calling job in architecture 3.3 calls `typescript.yml` by this SHA, and from it the wrapper does not pass `ALLOWED_LICENSES`. — architecture 3.3; RUN.md, T29.

— *Amendment 2026-11-01:* by Д29 in RUN.md `spec`, the task T34. `typescript.yml` sends the tests' coverage to Codecov by OIDC the same way as `go.yml` (the 2026-11-01 amendment to R16): the job `test` hands on the report as an artifact, and the job `coverage` — the check "TypeScript / coverage" — sends it with the permission `id-token: write`. The caller's job gives `contents: read` and `id-token: write`. Its own are these.
- **The contract of `ci-test`:** the lcov report is `coverage/lcov.info`, as istanbul's reporters `lcov` and `lcovonly` name it (architecture 4). A module that no test loads is in the report with zeros, or fails the recipe. Vitest does not show such a module by itself: "By default Vitest will show only files that were imported during test run", — and `coverage.include` with the sources is needed (architecture 4). Or the recipe fails on such a module, as `just coverage` of `spec` does (the 2026-10-23 amendment to R30 spec).
- **`coverage/` is cleaned by Vitest:** with `coverage.clean`, by default, it deletes the report's folder before the tests (architecture 4). A repository with Go and TypeScript, like the trial, writes the Go profile after Vitest. It has two uploads per commit, and its `codecov.yml` sets `after_n_builds: 2`: by default Codecov sends the status by the first report (architecture 3.3, 4).
- **The coverage provider** is a package of the lock file, for example `@vitest/coverage-v8`, and `ci-licenses` checks it, like everything. It needs no exception of its own: in the trial the recipe of `spec` passed with the one earlier exception, `lightningcss`.
- **The artifact** is `typescript-coverage`, and the job `coverage` is the same as at `go.yml`, but for the artifact's name and the report's file. A case of the suite of R28 holds this, and the upload steps are checked there by the cases of `go.yml`.
- **The trial** is the same pull request #80 as for `go.yml` (RUN.md, T34; architecture 4). The package is from the commits of #65, without the browser: it has nothing to do with the upload. A module that no test loads went into the report with a zero by `coverage.include`.

— architecture 3.1, 3.3, 4; RUN.md, T34; `typescript.yml`; `tests/`.

— *Amendment 2026-11-01:* the release is out — `v0.1.12`, commit 4225639, immutable and Latest; `gh release verify` confirms it. The calling job in architecture 3.3 calls `typescript.yml` by this SHA and gives it `id-token: write`. — architecture 3.3; RUN.md, T34.

— *Amendment 2026-11-09:* **the image of the `toolchain` stage of the job `check` of `typescript.yml` is taken from the cache of GitHub Actions by the same steps as at `go.yml` (R36).** The task T52.

## The `spec` tag v0.2.14

**R20. `.github` is on `spec` v0.2.14: the submodule `spec/` is at this tag, and the links to `spec` pinned to a tag name it.**
- **What the tag brings** (`git diff v0.2.13 v0.2.14` in `spec/`, read 2026-10-21). Only the documents of `spec` and its RUN.md change: the widget protocol in architecture 3.4 spec and the sources for it, the questions О-21 — a hint at the learner's request — and Т-30 — withdrawing a version of a module or a widget from publication, — an addition to О-8 and the row E5 of `spec`. `.devcontainer/`, RULES.md, the repository template, AGENTS.md, the recipes and `tools/` did not change (`git diff --quiet`), so `.github` edits nothing here but the links to the tag.
- **What is changed here:** `spec/` is at v0.2.14, commit f5f438e; the tag is in README.md, `profile/README.md`, CLAUDE.md and at the start of RUN.md; R17 gets an amendment.

— *Why now:* the author had the executor move to the latest release of `spec`, 2026-10-21, while `canvas` works by the prompt of T22. v0.2.14 is the newest release (`gh release list -R altnovatrail/spec`), it is immutable, and `gh release verify v0.2.14 -R altnovatrail/spec` confirmed it by its attestation.

— *Rejected:* staying on v0.2.13 until the next task that needs a new tag. The move breaks nothing, and the documents would link to an outdated tag.

— *Consequence:* none. — RUN.md, T23; CLAUDE.md; README.md; `profile/README.md`.

— *Amendment 2026-10-22:* `.github` is on `spec` v0.2.17 (R21). What is said above about v0.2.14 is the history of this move. — RUN.md, T24.

## The `spec` tag v0.2.17

**R21. `.github` is on `spec` v0.2.17: the submodule `spec/` is at this tag, the links to `spec` pinned to a tag name it, and what came from the repository template is as in the template of v0.2.17.**
- **What the tag brings** (`git diff v0.2.14 v0.2.17` in `spec/`, read 2026-10-22):
  - v0.2.15 — the answers to the rows of `canvas` В6–В26: R36–R38 spec, Т-31, Т-32, П-18 and an amendment to R25 spec. R37 spec concerns `.github`: the interface packages come out to npm, in the scope `@altnovatrail`, by a step of the shared `release.yml`, and `.github` writes the step (Д13 in RUN.md `spec`). From this same tag `editDevcontainer` adds "spec" to every decision that the copy's Dockerfile cites;
  - v0.2.16 — an amendment to R30 spec. What a repository's code adds to the calling files — a job of the language, an input of CodeQL, an ecosystem of Dependabot, the release — is written by the session of the repository itself, by the texts of architecture 3.3;
  - v0.2.17 — the answers to В17–В22 of `.github` (Д15 in RUN.md `spec`):
    - R39 spec — the recipes `licenses-allowed` and `licenses-check-repo`, and the check rejects a lock file without `packages`;
    - R40 spec — the `apt` packages from a snapshot of the Ubuntu archive; the rule of exact versions in RULES.md now says so too;
    - an amendment to R31 spec — the script `tools/toolchain/toolchain.sh`;
    - an amendment to R32 spec — `.github` and hyphenated names became a suffix of a citation, and before the word too.

    The card of `.github`, architecture 3.11 spec, now names the recipes of `spec` at the wrappers, the script at the release and the npm step, and architecture 3.12 spec names the npm registry among the services;
  - `.devcontainer/` of `spec`, the repository template and AGENTS.md did not change (`git diff --quiet`).
- **What is changed here:**
  - `spec/` is at v0.2.17, commit 5195df0; the tag is in README.md, `profile/README.md`, CLAUDE.md and at the start of RUN.md;
  - in `.devcontainer/Dockerfile` — `(R34 spec)`: this is how `editDevcontainer` now builds it, and the files of `.devcontainer/` have no other differences from the repository template but the first line;
  - architecture, section 1, and CLAUDE.md follow the new card: the recipes of `spec` at the wrappers, the script at the release, the npm step and the npm registry among the services. Section 3.3 — who writes what the code adds, by the amendment to R30 spec;
  - RUN.md: В17–В22 left table 3, and the epics E6 and E7 cite the decisions of `spec` by number;
  - R20 gets an amendment.
- **What waits for its tasks:** the script — T25, the license recipes — T26, the npm step — T27. `.github` has no `apt` packages, and the rule of the snapshot does not concern it.

— *Why now:* Д15 in RUN.md `spec`: «`.github` своей задачей переходит на релиз `spec` с этими ответами … и закрывает свои строки по этому списку». The author had the executor do it 2026-10-22 (RUN.md, T24). v0.2.17 is the newest release (`gh release list -R altnovatrail/spec`), it is immutable, and `gh release verify v0.2.17 -R altnovatrail/spec` confirmed it by its attestation.

— *Rejected:* v0.2.15 or v0.2.16: they have neither the script nor the license recipes that T25 and T26 take.

— *Consequence:* T25–T27 cite the decisions of `spec` by number, and the documents check reads «R19 .github и …» as a citation of another repository's log. — RUN.md, T24; CLAUDE.md; README.md; `profile/README.md`; `.devcontainer/Dockerfile`; architecture 1, 3.3.

— *Amendment 2026-10-22:* `.github` is on v0.2.21 (R22). What is said above about v0.2.17 is history, and T26 took the license recipes together with that move. — RUN.md, T26.

## The `spec` tag v0.2.21

**R22. `.github` is on `spec` v0.2.21: the submodule `spec/` is at this tag, the links to `spec` pinned to a tag name it, and what came from the repository template is as in the template of v0.2.21.**
- **What the tag brings** (`git diff v0.2.17 v0.2.21` in `spec/` and Д16–Д20 in RUN.md `spec`, read 2026-10-22):
  - v0.2.18 — the 2026-10-22 amendments to R39 and R12 spec, the answers to the letter of `canvas` about its T08 and to its В27 and В28 (Д16, Д17):
    - at `licenses-check-repo`, an exception that accepts a license outside the list holds only a package that the lock file marks `dev`, and covers the builds for the platforms that the tool itself names in `optionalDependencies`;
    - a development or CI tool that ships nowhere may also be under terms free for everyone, within two bounds: NovaTrail does not distribute it, and the platform can be built, run and deployed without it. RULES.md, Licenses, now says so too;
    - Д16 gives `.github` an edit of its own: the browser of the wrapper's contract is a build of Chrome for Testing under these terms;
  - v0.2.19 — R41 and R42 spec (Д18): the first slice is three modules of two subjects, and the normative texts for authors are in English. The rule of language in RULES.md and rule 10 of the template's RUN.md cite R42 spec, and Д18 gives `.github` the row `modules` in the profile;
  - v0.2.20 — R43 spec and amendments to R25 and R38 spec, the answers to the rows of `tutor` (Д19). They do not concern `.github`;
  - v0.2.21 — R44 spec, a version of its own for the module format (Д20), with amendments to R21, R31 and R42 spec. This is about the versions of the format and the lines of `spec` itself: the release recipes and `tools/release` did not change, and they do not concern `.github`;
  - `.devcontainer/` of `spec`, its CLAUDE.md and AGENTS.md, `tools/toolchain/` and `tools/licenses/config.mjs` did not change since v0.2.17, and in the repository template only the README and rule 10 of RUN.md did.
- **What is changed here:**
  - `spec/` is at v0.2.21, commit 14e2a11; the tag is in README.md, `profile/README.md`, CLAUDE.md and at the start of RUN.md;
  - rule 10 of RUN.md is as in the template of v0.2.21, with R42 spec. The section «Как пользоваться» has no other differences from the repository template but the repository's name;
  - the row `modules` in `profile/README.md` — the three modules of the first slice by R41 spec instead of "Spanish A1" (Д18);
  - the browser of the wrapper's contract — by an amendment to R19 and in the row `typescript.yml` of architecture 3.1 (Д16);
  - R21 gets an amendment.
- **What the same task takes:** `licenses-allowed` — in `self-ci.yml`, and `licenses-check-repo` with the bound `dev` — in the contract of the TypeScript wrapper (the amendments to R16 and R19; RUN.md, T26).

— *Why now and in T26:* T26 needs the recipe's bound `dev`, and v0.2.18 gives it. Д16 and Д18 order `.github` edits of this same move. RULES.md (Across repositories) orders a move by a task of its own, but the author decided 2026-10-22 to move in T26 — by a separate commit and this entry (RUN.md, T26). T26 was planned for v0.2.20, and v0.2.21 came out before it began. By its «Рискам» it moved to the newest tag: the release is immutable, and `gh release verify v0.2.21 -R altnovatrail/spec` confirmed it by its attestation.

— *Rejected:*
- staying on v0.2.17: one exception `lightningcss` would not cover its builds, and the trial of T26 would turn red on 11 packages, while 12 entries instead of one were rejected by R14 canvas;
- v0.2.18–v0.2.20: v0.2.21 is the newest, and what it added does not change `.github`;
- the move by a separate task before T26: the executor recommended so, but the author decided otherwise.

— *Consequence:* the decisions of `spec` that RUN.md named in words when T26 was planned — R41 and R42 spec — are cited by number. — RUN.md, T26; CLAUDE.md; README.md; `profile/README.md`; architecture 3.1.

— *Amendment 2026-10-22:* `.github` is on v0.2.23 (R24). What is said above about v0.2.21 is history.

## The pause at a late release

**R23. A release of `.github` that came out later than its commit comes out as before, with a lightweight tag. The Dependabot pause at the callers is then shorter than three days, or even vanishes, and the author accepts this: a Dependabot pull request with such a release is held back by hand at the callers until three days have passed since the release came out.**
- **When this happens** (architecture 2.10): the button released the release after a failed run of Release, or the run stood long in the queue. The pause is counted from the date of the tag, to the day, and the date of a lightweight tag is the date of the commit (2.6).
- **How to notice it:** between the commit and the release coming out there are not minutes but hours or days. This is seen by `publishedAt` at `gh release view <tag>` and by the date of the tag's commit. Of the eleven releases `v0.1.0`–`v0.1.10`, each came out 1–33 minutes after its commit, on the same day by UTC (`gh release list` and `git log`, 2026-10-22), so there has been no such release yet.
- **What the executor does.** The task after which such a release came out names it in the report and in «Итоге после мержа», together with the day when the three days will have passed.

— *Why:* the author's answer of 2026-10-22 to В13, by the recommendation of architecture 2.10. The case is rare and is seen by the date of the release.

— *Rejected:* an annotated tag before the release, which has a date of its own. Then the tag appears earlier than the release, not together with it (R04; R31 spec), and if creating the release fails, the next run stops at "a tag without a release". For the sake of one rare case this changes how a release comes out and adds a new failure to it.

— *Consequence:* architecture 2.10 is decided, and В13 left table 3 of RUN.md. — architecture 2.6, 2.10.

## The `spec` tag v0.2.23

**R24. `.github` is on `spec` v0.2.23: the submodule `spec/` is at this tag, the links to `spec` pinned to a tag name it, and the status line in the organization's profile says about the module format the same as the README of `spec` at this tag.**
- **What the tag brings** (`git diff v0.2.21 v0.2.23` in `spec/` and RUN.md `spec`, read 2026-10-22):
  - v0.2.22 — R45 spec: the module format is JSON Schema 2020-12, and the author writes a module in YAML 1.2.2 with restrictions; Т-7 is closed. The components take the answer by Д21 in RUN.md `spec`, and it assigns `.github` nothing;
  - v0.2.23 — the format check `just format-check`: the recipes `format-check` and `format-check-test` and their place in the CI of `spec`. `ajv` 8.20.0 and `yaml` 2.9.1 came into `tools/package.json`, and `_tools`, and with it `docs-check-repo`, installs them too;
  - `.devcontainer/`, RULES.md, AGENTS.md, `repo-template/`, `tools/toolchain/`, `tools/licenses/`, `tools/release/` and `tools/new-repo/` did not change since v0.2.21 (`git diff --quiet`). The recipes that the shared workflows of `.github` and the callers call — `docs-check-repo`, `licenses-allowed`, `licenses-check-repo` and the release recipes — are as they were. In `tools/docs-check/config.mjs` only the profile of `spec` itself changed;
  - the tags have no answers to the rows of `.github` В23, В25 and В26.
- **What is changed here:**
  - `spec/` is at v0.2.23, commit ed7709c; the tag is in README.md, `profile/README.md`, CLAUDE.md and at the start of RUN.md. The release is immutable, and `gh release verify v0.2.23 -R altnovatrail/spec` confirms it;
  - the row Status in `profile/README.md` follows the README of `spec` v0.2.23: `spec` holds the documents of the platform and the beginning of the module format, whose text and conventions are written, while the schemas come in parts; the contracts between the parts of the platform come after it. The link to the text of the format is absolute, to the tag;
  - R22 gets an amendment.

— *Why now:* the author's decision of 2026-10-22, when E6 and E7 went to the archive (RUN.md, T30). v0.2.23 is the newest release of `spec`, and on v0.2.21 the documents would link to an outdated tag, which R20 rejected.

— *Rejected:*
- staying on v0.2.21 until a task that needs a new tag — for the same reason;
- v0.2.22: v0.2.23 is newer, and what it added does not change `.github`.

— *Consequence:* the decision of `spec` about the module format that RUN.md named in words when T30 was written down — R45 spec — is cited by number. — RUN.md, T30; architecture, status; `profile/README.md`.

— *Amendment 2026-11-01:* `.github` is on v0.4.1 (R25). What is said above about v0.2.23 is history.

## The `spec` tag v0.4.1

**R25. `.github` is on `spec` v0.4.1: the submodule `spec/` is at this tag, the links to `spec` pinned to a tag name it, and what came from the repository template is as in the template of v0.4.1. The README carries status badges by R48 spec, and the organization's profile does not.**
- **What the tag brings** (`git diff v0.2.23 v0.4.1` in `spec/` and RUN.md `spec`, read 2026-11-01). Between the tags are v0.2.24–v0.2.46, v0.3.0–v0.3.4 and v0.4.0; most of it is the module format, R46–R63 spec, and the answers to the rows of other repositories. For `.github`:
  - v0.2.26 — the answers to the rows В23, В25 and В26 (Д24 in RUN.md `spec`): the 2026-10-22 addition to Т-27 and the item T37 of `spec`, the 2026-10-22 amendment to R31 spec — the release of `spec` in copies of checkout — and the 2026-10-22 amendment to R12 spec — npm is named an exception. In the same place is the 2026-10-22 amendment to R31 spec by the row В6 of `module-kit`: the template of `paths` of the caller's `release.yml` is the list of what a release is built from; `.github` edits it in architecture 3.3 (Д27);
  - v0.2.27 and v0.2.28 — R48 spec: the status badges in the README, their addresses and when which one is put up — repositories 2.3 spec, — and the coverage in Codecov by OIDC, where `codecov/patch` ≥ 90 % holds the merge. `.github` puts up its badges by the move to the tag (Д28), and writes the upload of coverage into the wrappers `go.yml` and `typescript.yml` by a task of its own (Д29). The README of the repository template begins with the badges of the first day;
  - v0.2.35 — the 2026-10-26 amendments to R48 and R22 spec. In RULES.md, How we work, is the rule about tests: "Code comes with its tests: a pull request that adds or changes what code does adds or changes the tests of its automated suite too". A report of a vulnerability gets its first response within 14 days, and the session of `.github` edits SECURITY.md by a task of its own (Д34);
  - v0.3.0 — R64 spec: code takes the files of `spec` from its releases. In the `toolchain` stage of the Dockerfile of `spec` is Go 1.27.3, with checksums and `GOTOOLCHAIN=local`, and CLAUDE.md of the repository template, Environment, names "Node.js, Go and just";
  - v0.3.4–v0.4.1 — the types of the format for Go and TypeScript, R72 and R73 spec. The card of `.github`, architecture 3.11 spec: `spec` cannot call the shared release, its `release.yml` is its own — it signs with the same cosign and publishes `@altnovatrail/spec` to npm by the steps of the shared release, — and `spec` takes the Go wrapper from T50 of `spec` (the second 2026-10-29 amendment to R37 spec). Carrying the npm steps over, T51 of `spec` found a hole in the shared step and wrote to `.github` about it (the amendment to R18);
  - Д10 in RUN.md `spec`: Dependabot raises the references to `.github`, the pause holds them, and "DCO / sign-off" accepts the sign-off of its commit (architecture 2.6, 2.8);
  - the documents check, since the 2026-10-26 amendment to R32 spec, reads only the files that git tracks or does not ignore. `tools/toolchain/` and `tools/licenses/` did not change (`git diff --quiet`), and the recipes that the shared and the `self-` workflows call — `docs-check-repo`, `licenses-allowed`, `release-version` and `release-refusal` — are the same by their interface: `release-version` compares the version of the format only in `spec` itself (`justfile`). AGENTS.md and «Как пользоваться» of the repository template did not change.
- **What is changed here:**
  - `spec/` is at v0.4.1, commit 23000f3; the tag is in README.md, `profile/README.md`, CLAUDE.md and at the start of RUN.md. The release is immutable, and `gh release verify v0.4.1 -R altnovatrail/spec` confirms it;
  - `.devcontainer/Dockerfile` is as `editDevcontainer` v0.4.1 builds it for `.github`, with Go in the `toolchain` stage; the checksums of Go were compared with the list of go.dev (architecture 4). The recipe gives `devcontainer.json` and `host-network.sh` the same. CLAUDE.md, Environment, says "Node.js, Go and just", as in the repository template. `.github` has no Go code of its own, but its container is the container of `spec` (R01). The cost is the Go archive, 70,588,678 bytes for amd64, in every build of the `toolchain` stage in the CI of `.github`: in the jobs Documents and Workflows and in the release. How many seconds that is, the first run of a pull request will show;
  - README.md — the badges by repositories 2.3 spec. In the first line are CI, Release, CodeQL, the release number, Scorecard and the license, in the second the five measures of SonarCloud; the workflows are `self-ci.yml`, `self-release.yml` and `self-codeql.yml`, the project is `altnovatrail_.github`. There are no badges of a language, of coverage or of Best Practices: `.github` has no code in a language, no upload of coverage and no project on bestpractices.dev. Every badge answers with a value, not "not found" or "unknown" (architecture 4);
  - `profile/README.md` has no badges, and the row Status is about the module format by the README of `spec` v0.4.1, with the difference below;
  - В23, В25 and В26 left table 3 of RUN.md, and R18 gets an amendment about where `spec` recorded them, about the template of `paths` and about the npm step. CLAUDE.md, The component, and architecture 1 — by the new card; architecture 2.3, 2.6, 2.8, 2.12, 3.2 and 3.3 — by the tag;
  - CONTRIBUTING.md — the license exception "free terms, for open source or for everyone", as in RULES.md since v0.2.18 (the 2026-10-22 amendment to R12 spec). At the move to v0.2.21 (R22) this phrase was not edited;
  - R24 gets an amendment.
- **What tasks of their own took** (the epic E9 in RUN.md): SECURITY.md by Д34 — T32, on the same day (R26); the check of a unpublished number in the npm step — T33, and the upload of coverage in the wrappers by Д29 — T34, still wait. How the rule about tests applies to the shared workflows, which have no automated suite of tests, is architecture 2.13. The author answered В27 on the same day: the suite of the steps' tests, the task T35, before T33 and T34.

— *Why now:* the author had the executor do it 2026-11-01: «обнови spec до последней версии» (RUN.md, T31). v0.4.1 is the newest release of `spec` (`gh release list -R altnovatrail/spec`). Д24, Д27 and Д28 in RUN.md `spec` order `.github` to close its rows, edit the template and put up the badges by the move to the tag with the answers.

— *The profile without badges* is the executor's proposal: what the profile shows, `.github` decides itself (repositories 2.3 spec). A badge tells of the state of one repository, and the profile is the page of an organization with thirteen. The badges of `.github` would pass off its state as the state of the platform, and the badges of all thirteen would fill the page. The state of each repository is seen in its README.

— *The row Status of the profile.* R24 orders it to say about the format the same as the README of `spec` at the tag. But the row Status of the README of `spec` v0.4.1 — "The types of the format for Go and TypeScript come next" — has fallen behind the README itself: further down it names the types in the Go module and the npm package `@altnovatrail/spec` in the releases. The Go types are in the release v0.3.4, and the TypeScript ones in v0.4.0 (`git ls-tree`, `gh release view`). The profile says how it is, and `spec` will edit the row of the README — В28 in RUN.md, «в реестр spec».

— *Rejected:*
- moving one tag at a time — v0.2.26, v0.2.35, v0.3.0 and so on: the tags are immutable, and the newest carries everything they do;
- a devcontainer without Go — a difference from the container of `spec` that would have to be recorded as a decision, without a reason (R01);
- badges in the profile — for the reason above;
- the row Status of the profile word for word by the README of `spec` — it would call future what has already come out.

— *Consequence:* table 3 has В28, and the author decided В27 on the same day; the epic E9 has T32–T35. The decisions of `spec` that table 3 named in words — the addition to Т-27 and the amendments to R12 and R31 spec — are cited by number. The amendment to R31 spec writes the list of `paths` as `**/*.go`, and the template here is `*.go` (the amendment to R18): this is the second part of В28. — RUN.md, T31; CLAUDE.md; README.md; `profile/README.md`; CONTRIBUTING.md; `.devcontainer/Dockerfile`; R18; architecture: status, 1, 2.3, 2.6, 2.8, 2.12, 2.13, 3.2, 3.3, 4.

— *Amendment 2026-11-01:* `.github` is on v0.5.3 (R27). The difference of the row Status of the profile from the README of `spec`, recorded above, is gone: the README of `spec` v0.5.3 names the types of the format as released, and the profile again says the same as it does (R24). What is said above about v0.4.1 is history.

## SECURITY.md

**R26. SECURITY.md promises the first response to a report of a vulnerability within 14 days, and the supported version is the repository's latest release: a fix goes into `main` and comes out with the next release, and earlier releases do not get it.** The task T32, by the 2026-10-26 amendment to R22 spec (Д34 in RUN.md `spec`).
- **The term.** The first response is in the advisory that the report opens: that it has been received and is being looked into. SECURITY.md does not promise a fix within these 14 days — so does the amendment to R22 spec: «исправления в этот срок он не обещает».
- **The versions.** `spec`, `.github` and `module-kit` have releases (`gh release list`, 2026-11-01), and each comes out only from `main`: at `spec` after a green CI (R31 spec), at `.github` by its own release (R10), at the rest by the shared release (R18), which releases only the head of `main`. Nobody has maintenance branches, so a fix comes out with the next release, and the earlier ones do not get it. Whoever pinned an old release — as the callers of the shared workflows do by a SHA (R04) — gets the fix by raising the reference, and Dependabot proposes it.
- **Without a list of repositories.** The section does not list who has releases, but refers to the repository's **Releases** page: a list would go out of date with every first release.

— *Why:* the 2026-10-26 amendment to R22 spec — the OpenSSF Best Practices badge requires a term, the criterion `vulnerability_report_response`, and "No part of NovaTrail has released code yet" stopped being true with the first release of `module-kit`. The section's words about versions are the executor's proposal: the amendment orders to speak «о релизах, которые есть», and the rule is the same for all, since all release only from `main`.

— *Rejected:*
- keeping "promises no response time" — it contradicts the amendment to R22 spec and the badge;
- promising a term for a fix — the amendment does not give one, and there is one maintainer;
- fixes for earlier releases — there are no maintenance branches, and releases come out only from the head of `main`;
- a list of the repositories with releases in SECURITY.md — for the reason above.

— *Consequence:* `spec` can refer to the term in the answer to `vulnerability_report_response` of its `.bestpractices.json` — its work by Д34. — SECURITY.md; RUN.md, T32; R25.

## The `spec` tag v0.5.3

**R27. `.github` is on `spec` v0.5.3: the submodule `spec/` is at this tag, the links to `spec` pinned to a tag name it, and the row Status of the profile again says about the format and the contracts the same as the README of `spec` at this tag. В28 is closed.**
- **What the tag brings** (`git diff v0.4.1 v0.5.3` in `spec/` and Д52 in RUN.md `spec`, read 2026-11-01):
  - v0.5.0 — R74 spec: the types of the element `<novatrail-canvas>` for `canvas` and `app` in the package `@altnovatrail/spec`, the first contract between components. It assigns `.github` nothing;
  - v0.5.1 and v0.5.2 — T50 of `spec`: the job "Go" in `ci.yml` of `spec` calls the shared `go.yml` v0.1.10, with its own recipes `ci-*` over all the Go modules of `spec`, and the Go coverage goes to Codecov by its own upload, while the wrapper has no upload (the 2026-11-01 amendments to R30 and R48 spec). `ci-licenses` of `spec` checks by `ALLOWED_LICENSES`, which `go.yml` gives. So `go.yml` has two callers — `module-kit` and `spec`, — and an edit of its copy of the list, which `self-ci.yml` compares (R16), both will see;
  - v0.5.3 — the answer to В28 (Д52 in RUN.md `spec`): the row Status of the README of `spec` names the types of the format for Go — since v0.3.4, for TypeScript — since v0.4.0, and the first contract — since v0.5.0; the 2026-11-01 amendment to R31 spec gives the list of `paths` to the template of architecture 3.3 and names the cost of a new base image;
  - `.devcontainer/`, RULES.md, AGENTS.md, `repo-template/`, `tools/toolchain/`, `tools/licenses/`, `tools/new-repo/` and `tools/docs-check/` did not change (`git diff --quiet`). The recipes that the shared and the `self-` workflows call are the same word for word.
- **What is changed here:**
  - `spec/` is at v0.5.3, commit 38ce564; the tag is in README.md, `profile/README.md`, CLAUDE.md and at the start of RUN.md. The release is immutable, and `gh release verify v0.5.3 -R altnovatrail/spec` confirms it;
  - the row Status of the profile follows the README of `spec` v0.5.3: the format 0.1 and its types, the first contract since v0.5.0, the rest after it;
  - В28 left table 3; R18 and R25 get amendments;
  - architecture: status, 1, 3.1, 3.2 and 3.3 — `spec` calls `go.yml`, and the template holds the list of `paths`; section 4 — the sources.

— *Why now:* the author's decision of 2026-11-01, when `spec` answered В28 (RUN.md, T36). Д52 in RUN.md `spec` orders `.github` to close В28 by its move to the tag with the answer. v0.5.3 is the newest release of `spec`.

— *Rejected:* waiting for the next task that needs a new tag. The row would hang open, and the profile would differ from the README of `spec`, though the answer has already come out.

— *Consequence:* table 3 of RUN.md is empty. — RUN.md, T36; CLAUDE.md; README.md; `profile/README.md`; R18, R25; architecture: status, 1, 3.1–3.3, 4.

— *Amendment 2026-11-02:* `.github` is on v0.6.2 (R30). What is said above about v0.5.3 as the tag of `.github` is history, and the row Status of the profile now says the same as the README of `spec` v0.6.2.

## Tests of the workflows

**R28. The steps of the shared workflows — and of its own `self-` ones — are checked by the suite of tests `tests/`. A step, taken out of its file word for word, runs in bash on the runner, with stubs of `docker`, `gh`, `curl`, `wget`, cosign and npm, in cases where it passes and where it fails. The file is read by yq 4.54.1, downloaded by the version and checksum in `self-ci.yml`, and the suite runs as steps of the job "Workflows". An edit of a step comes with its cases.** The author's answer to В27 (architecture 2.13) and their decisions of 2026-11-01 when T35 was planned: yq; bash on the runner with a harness of its own; steps of the job "Workflows"; at once — the steps of T33 and T34 and the structure of the wrappers.
- **The design** (architecture 3.4):
  - `tests/run.sh` runs each `test_*` of `tests/*.test.sh` in a bash process of its own, with `set -euo pipefail` and `inherit_errexit`. The output of a failed test is printed indented by `  | `, and the expected `::error::` of the negative cases do not become commands of the runner;
  - `tests/lib.sh` is the harness: pick a step, give it a context, run it and check it. yq turns the file into JSON once, and jq picks the step. So `run` arrives byte for byte, and the type of a value is seen from the JSON;
  - `tests/stubs/` — the stubs of `docker`, `gh`, `curl`, `wget`, cosign and npm. By default each fails, and its call is written to a log, and the test fails on any exit code of the step. A program that the step calls by an absolute path, and git, have no stubs: a step that goes to the network through them gets stubs together with its cases. A stub that a case set up writes its arguments, and `docker` also stdin and the values of bare `--env NAME`;
  - in "Workflows", after "Lint the workflows", are three steps: "Install yq", "Lint the tests" — shellcheck of the job over `tests/` — and "Test the workflows".
- **How the harness follows GitHub:**
  - the step gets `env -i` and only what the runner would give: `PATH` with the stubs in front, `HOME`, `CI`, `GITHUB_ACTIONS`, fresh files `GITHUB_OUTPUT`, `GITHUB_ENV`, `GITHUB_PATH` and `GITHUB_STEP_SUMMARY`, `RUNNER_TEMP`, `GITHUB_WORKSPACE` as the working folder, and the OIDC variables if the job gives `id-token: write`. What a case names itself can be added. The paths of `RUNNER_TEMP` and `GITHUB_WORKSPACE` hold a space, `$`, quotes and a backquote;
  - `env` — of the workflow, then of the job, then of the step. `HOME`, `CI`, `LANG` and `LC_ALL` the step may set itself, and its value wins. `GITHUB_*` and `RUNNER_*` GitHub does not let be overridden (architecture 4), and `PATH` and the OIDC variables are the mechanics of the harness: for them there is a refusal. Each `${{ <path> }}` in a value comes from the case's context, and a value with another expression the case sets whole. What is missing and what is extra, the test stops. A value that is not a string too: GitHub would pass `0.10` as `0.1` (the amendment to R10);
  - the shell is as at GitHub: `bash -e {0}` without `shell` and `bash --noprofile --norc -eo pipefail {0}` with `shell: bash` (architecture 4);
  - a step with an expression in `run`, a step `uses:`, `working-directory`, `container`, another runner, a matrix not as a list and a write to `GITHUB_ENV` the harness does not fake, but refuses;
  - a test fails if it checked nothing or did not check the exit code of even one run — and also when that run was followed by another.
- **The first cases** — 53 tests:
  - the step `npm` of `release.yml`, "Check the npm package", — 27. These are the cases of the local trial of T27 (the amendment to R18) and those found in planning: the order of versions by numbers, no network, a response not JSON, an archive not gzip, the exact arguments of curl, the OIDC variables that the trial run of npm does not see, and the text of `if:`, shared with "Node and npm";
  - `go.yml` — 5 and `typescript.yml` — 6: the structure — permissions, matrix, job names, — "Toolchain image" and `ci-${{ matrix.check }}` for each value of the matrix;
  - the harness itself — 15: each refusal, each way to pass without a reason, and the checks of `run.sh`.
- **The rule.** An edit of a step that has cases changes them in the same pull request. An edit of a step without cases brings them itself, and of a `self-` workflow too. The first such edits are T33 and T34.
- **What the suite does not check:** the steps `uses:`; the conditions `if:` — only their text, by a case about the structure; the real docker, npm, npm registry and Sigstore — those are still tried by a pull request without a merge, as #61. The script `npm-isolated` of "Node and npm" has no cases either: they will come with an edit of that step.
- **License.** yq is MIT, in category A (R12 spec), no exception is needed. It goes only into CI, like actionlint (R08).
- **The difference from the repository template** is a phrase in CLAUDE.md, Environment, about the suite next to `docs-check-repo`. The rest of CLAUDE.md, «Как пользоваться» and `.devcontainer/` is as in the repository template (R27).

— *Why:*
- The steps run on the runner in real life too, and the tests run them there as well. The image `ubuntu-24.04` 20261026.354.1 has bash 5.2.21, git 2.56.0, jq 1.7, OpenSSL 3.0.13 and tar 1.35, exactly as in the devcontainer, so the suite runs locally too (architecture 4).
- A process of its own for each test: inside an `if` and after `||` bash does not apply `set -e` to any command of a function (architecture 4). A test in a subshell could fail and pass.
- The stubs fail by default, and `curl` knows only the step's flags. So a test does not go to the network through these programs, an unexpected call is seen even behind `|| true`, and a `-f` added to curl does not hide behind a stub.
- Every breakage of a step that the executor tried turned the suite red and named its case (the trial below).

— *Rejected:*
- parsing YAML with awk or sed — a second parser with its own errors;
- the runner's Python and PyYAML — the versions are not pinned (R08);
- Node with the package `yaml` — `.github` would get a lock file, an npm ecosystem in Dependabot and a license check;
- `spec/tools/node_modules` — an internal file of `spec` without an interface, like `config.mjs` in R16;
- Go with yaml.v3 — `.github` would become a Go repository, option 2 in architecture 2.13;
- actionlint — it gives out no parse tree;
- `node --test` in the `toolchain` stage, like `toolchain-test` of `spec`. The steps would run with the tools of the container, not of the runner, and `.github` would get JavaScript for CodeQL and SonarCloud;
- bats-core 1.14.0. Its release has no files, only source archives, and GitHub does not promise their bytes (architecture 4). A submodule at a commit is a second submodule for a small part of the harness: taking out the step, the environment and the stubs would have to be written anyway;
- the runner's yq — it is 4.54.1, but nobody pinned its version. `run.sh` takes only the yq of `YQ` and compares its version with `YQ_VERSION` of `self-ci.yml`;
- a job of its own for the suite — a new required check in the ruleset 25477399, a step of the author. "Workflows" is required anyway (R11), and shellcheck is already downloaded in it.

— *The trial* (RUN.md, T35; architecture 4):
- locally in the devcontainer — 53 tests, all `ok`, in 9 seconds; shellcheck 0.11.0 over `tests/` and actionlint 1.7.12 over all the workflows — clean;
- on the runner — pull request #77: "53 tests, 0 failed", the step of the suite — 11 seconds. The trial #76, without a merge, with `--ipc=host` at all the jobs of `typescript.yml`: "53 tests, 1 failed", and its case named;
- 21 breakages of the steps, each in a copy of its own. All 21 turned the suite red, and each named its case:
  - `--ipc=host` at all the jobs or no `--init` in `typescript.yml`;
  - `go.yml` without `--env ALLOWED_LICENSES`, with an extra `--env CI`, with another image tag, with a fifth check in the matrix;
  - in the step `npm` — another `integrity` as "already published", a reversed tag `previous`, `sort` instead of `sort -V` in each of the two places, `-f` at curl and a request without `?write=true`;
  - in the same place — the step with another `id`, without `unset` of the OIDC variables, without the check of `private`, without the check of the repository and of a single `package.json`;
  - in the same place — the check of the trial run without `integrity`, another `if:`, a 404 without an error at `publish: true` and a lost output `tag`.

  The first version of the case about the order of versions did not catch a sort of the list: there was one version in the registry. Now there are two, and by the text the higher one would be different.

— *Consequence:* T33 and T34 come with their cases in the suite. — architecture 2.13, 3.4, 3.5, 4; R10; CLAUDE.md; RUN.md, T35; `tests/`; `self-ci.yml`.

— *Amendment 2026-11-12:* **the phrase about the suite is no longer in Environment of CLAUDE.md, but in the rule of the part `.claude/rules/workflows.md`, with `paths` `.github/workflows/**` and `tests/**`: the paragraph Environment became the rules of the parts, and CLAUDE.md names them (R38; R143 spec).** The difference from the repository template is this rule, and the suite, how it is run and yq by the version and checksum of `self-ci.yml` are the same.

## Issue and pull request templates

**R29. The default issue and pull request templates are in `.github`: the forms "Bug report" and "Change proposal" and `config.yml` — in `.github/ISSUE_TEMPLATE/`, the pull request template — `.github/pull_request_template.md`. A blank issue is closed, and for a vulnerability the template chooser refers to SECURITY.md. The texts are in English, the links only absolute, and the templates do not repeat the rules.** The task T37, by the 2026-11-01 amendment to R22 spec (T36 and Д4 in RUN.md `spec`); architecture 2.11.
- **The forms:**
  - "Bug report", `type: Bug`. The opening: one may write in English or in Russian; about a vulnerability — privately, by SECURITY.md, and never in an issue; there are no learners' data either in the issue or in the attachments, and the bug is reproduced on synthetic data. The required fields are "What happened", "What you expected", "How to reproduce" and "Where": a commit, a release or a tag. Optional — "Environment" and "Logs", and the log comes into the issue as a block of code, `render: text`;
  - "Change proposal", `type: Feature`. The opening: an issue comes before a pull request, except for a typo and a broken link, and first comes the repository's decision log, by a link to "Before you start" of CONTRIBUTING. The required fields are "What should change" and "Why", optional — "Decisions it touches": the numbers of the decisions, and if a decision rejected this, then the new facts;
  - in both — a required checkbox: the issue has no learners' data and no secrets, with a link to "What every contribution keeps to" of CONTRIBUTING. The forms set no labels.
- **The template chooser** — `blank_issues_enabled: false` and the link "Report a vulnerability" to SECURITY.md of this repository.
- **The pull request template:** a line about the language, `Closes #`, the section "What changes and why" and a checklist — the DCO sign-off of every commit, tests with the code and the checks that the repository's CLAUDE.md names, no learners' data and no secrets, the licenses of new dependencies. It has no names of checks: the repositories have different ones, and the ruleset holds the merge (the 2026-11-01 amendment to R22 spec).
- **The links** go to `main` of `.github`, as in CONTRIBUTING and SECURITY (CLAUDE.md, Documents): a template is shown in another repository, where a relative link does not work. RULES.md is named without a link — "RULES.md of spec, which the repository's CLAUDE.md imports".
- **What goes beyond the prompt** — the executor's proposals:
  - the opening of "Change proposal" also speaks of a vulnerability: the fallback route of SECURITY.md, an issue asking for a contact, goes by this form. There is no blank issue, and without this phrase it is unclear which form to take for such a request;
  - the links are only in the elements `markdown` and in the labels of the checkboxes: there GitHub documents Markdown, and in the descriptions of the fields it does not (architecture 4, «Шаблоны issue и pull request»);
  - the opening of "Bug report" names the attachments too: a file can be attached in a field without `render`, and a screenshot can show a learner's data;
  - the directions of the pull request template are in HTML comments: they are seen while the description is written, and are not shown in the saved description. Seen in it are `Closes #`, the heading and the checklist.

— *Why:* the 2026-11-01 amendment to R22 spec — the author's answers when T36 of `spec` was planned, all by the recommendations of its plan. It will come into the submodule with the move to the tag, and meanwhile its text is on `main` of `spec`, commit a45ce33. GitHub's facts about where the templates live, about issue types and about Markdown in forms are in architecture 4, «Шаблоны issue и pull request».

— *Rejected:*
- a link to RULES.md on `main` of `spec`: a repository has its own rules — of the version its submodule stands on, — and CONTRIBUTING, for the same reason, sends to RULES.md in the submodule;
- links in the descriptions of the fields: Markdown is not documented there, and a link could show as text;
- the directions of the pull request template as visible text: they would have to be erased, or else they would stay in the description of every pull request.

The rest was rejected by the amendment to R22 spec itself: copies in every repository through `repo-template/`, a single bug form with a blank issue open, the form `VULNERABILITY_REPORT.yml`, Markdown templates and texts in two languages.

— *The trial:* both forms and `config.yml` were checked against the SchemaStore schemas `github-issue-forms.json` and `github-issue-config.json`, draft-07, downloaded 2026-11-01. The schemas are third-party, not GitHub's: by them all three files are valid. And a form with an extra top-level key, with an `id` with a space or with a field without `label` is not. GitHub shows the errors of a form itself, after the merge — this is «Как проверить» of T37.

— *Consequence:* architecture 2.11 is decided. Step 2 of T36 of `spec` checks the templates on `main` and closes Д4. A repository sets up no templates of its own: a form of its own or a `config.yml` of its own would cancel all the shared ones (the 2026-11-01 amendment to R22 spec). — `.github/ISSUE_TEMPLATE/`; `.github/pull_request_template.md`; README.md; `profile/README.md`; CLAUDE.md; RUN.md, T37; architecture: status, 1, 2.11, 4.

## The `spec` tag v0.6.2

**R30. `.github` is on `spec` v0.6.2: the submodule `spec/` is at this tag, the links to `spec` pinned to a tag name it, and the row Status of the profile says about the format the same as the README of `spec` at this tag. Т-27 is closed by R77 spec, and `.github` takes the rule of signatures with the recipe `release-verify` by this move. The rerun path of the shared release moves to the recipe by a task of its own, T39.**
- **What the tag brings** (`git diff v0.5.3 v0.6.2` in `spec/`; Д53, Д54 and Д59 in RUN.md `spec`; read 2026-11-01). Between the tags — v0.5.4–v0.5.8 and v0.6.0–v0.6.2. For `.github`:
  - R76 spec — the cross-repository plan, COORDINATION.md `spec` (Д53). The rows of `.github` in it are 2.2, epic E10, and 2.3, epic E11 (RUN.md, tables 1 and 2). The rule of RULES.md about language names COORDINATION.md as Russian;
  - R77 spec — the answer to Т-27 (Д54), and with it the recipes `release-verify` and `release-verify-npm` and the hard rule of RULES.md "Release files are verified". What of this falls on `.github` is the item below;
  - v0.6.0 — format 0.2 (Д59), and the row Status of the README of `spec` names it. `.github` does not read the format, and the format assigns it nothing;
  - v0.6.1 and v0.6.2 — COORDINATION.md, RUN.md and concepts 16 `spec`;
  - `.devcontainer/`, AGENTS.md, `repo-template/`, `tools/toolchain/`, `tools/licenses/`, `tools/new-repo/` and `tools/docs-check/` did not change. The recipes that the shared and `self-` workflows call are the same word for word (architecture 4).
- **The rule of signatures here.** What R77 spec demands of the one who signs, the shared release already does:
  - it signs only the commit of its own run on the caller's `main` (R18);
  - the callers call it by the SHA of a release of `.github` (R04);
  - `.github` has immutable releases and a ruleset of the tags `v*` (R10).

  The signature of a released file, as a consumer checks it, is checked at `.github` in one place — the rerun path of the shared release. It takes the file from the release and hands it to npm: this is exactly the entry of a release file into CI on which the new hard rule falls. The step departs from the rule of signatures: it lets in a SAN with any SHA, branch or tag of `.github`, and the flags of cosign check outdated fields of the certificate («Свой разбор сертификата» in R77 spec). T39 fixes it — by the recipe `release-verify`, by the author's decision when E10 was planned.

  "Sign every file" checks something else — the signature of its own run, before publishing, with the exact identity `job.workflow_ref` and the same flags of cosign. This is a check of who signs. There is no tag yet, and the recipe will not replace it. But the identity in it is what the caller pinned the shared `release.yml` by. Pinning by a branch or a tag would give immutable files that R77 spec will reject. R04 and the template of architecture 3.3 bid to pin by a SHA, but the release itself does not guard it — the question В31 in RUN.md.

  The rest that the workflows of `.github` download are not files of NovaTrail releases. These are actions by SHA, gitleaks in `secrets.yml`, actionlint, ShellCheck and yq in `self-ci.yml`, the Codecov CLI in the wrappers, cosign and Node in the shared release. The archive that "Publish to npm" downloads from the registry is only compared byte for byte with the release file and goes nowhere further. The wrappers and the release take the caller's submodule `spec` by a checkout at a tag, not as a release file.
- **What is changed here:**
  - `spec/` — at v0.6.2, commit 49d0fb6; the tag — in README.md, `profile/README.md`, CLAUDE.md and at the start of RUN.md. The release is immutable, and `gh release verify v0.6.2 -R altnovatrail/spec` confirms it;
  - the row Status of the profile — by the README of `spec` v0.6.2: format 0.1 and its types, format 0.2 since v0.6.0, the first contract since v0.5.0, the others — after it;
  - CLAUDE.md, The component, and architecture 1 — by the card 3.11 spec. What a consumer checks, R77 spec decided; one recipe checks it, and the library of `module-kit` checks no signatures;
  - architecture 2.3 — "Decided in `spec`", and in 3.1 and 3.3 the condition of the check names R77 spec. In CONTRIBUTING.md — that COORDINATION.md of `spec` is in Russian, as in RULES.md. In README.md — a line about E10;
  - amendments to R18 and R27. In RUN.md table 2 and the description of E10 cite R76 spec, R77 spec and Т-35 by number, and Д5 and Д7 are checked.
- **What remains:** В29 and В30 — `spec` v0.6.2 did not record them, and the rows stay in table 3 of RUN.md. A new row there is В31: whether to guard the pinning of the shared release by a SHA.

— *Why now:* this is the first task of epic E10 (RUN.md, T38), which the author took on 2026-11-01. The move to a tag of the line 0.6 is the first task of every repository on the way to the first application (COORDINATION.md `spec`; R76 spec), and Д53 and Д54 in RUN.md `spec` bid to take R76 and R77 spec with this tag. v0.6.2 is the newest release of `spec`.

— *Rejected:*
- v0.6.1, on which E10 was planned: tags are immutable, and v0.6.2 carries all that it does, and beyond it only documents;
- the fix of the rerun path in this same task. A fix of a shared workflow gives a release of `.github` and comes with its own cases in the suite of tests (R28), while the move is only documents. The fix has its own task, T39.

— *Consequence:* RUN.md — T38, table 2, В31, Д5 and Д7; CLAUDE.md; README.md; `profile/README.md`; CONTRIBUTING.md; R18, R27; architecture: status, 1, 2.3, 3.1, 3.3, 4.

— *Amendment 2026-11-02:* `.github` is on v0.6.3 (R31). What is said above about v0.6.2 as the tag of `.github` is history, and so is "What remains": `spec` recorded В29 and В30 in v0.6.3 together with В32 and В33 (Д64 in RUN.md `spec`), and the rows left table 3 of RUN.md. В31 left already in T39.

**R31. `.github` is on `spec` v0.6.3: the submodule `spec/` is at this tag, and the links to `spec` pinned to a tag name it. Т-35 is closed by the 2026-11-02 amendment to R63 spec — the author's answer, option 1′. The file of the previous release that an input of the shared `release.yml` names is fetched and checked by the recipe `release-verify` by a step of the shared release on the runner, and the recipe `release-files` gets the file already checked. The input is written by a task of its own, T41.**
- **What the tag brings** (`git diff v0.6.2 v0.6.3` in `spec/`; Д64 in RUN.md `spec`; read 2026-11-02). There are no tags between them. For `.github` these are the answers to the rows «в реестр spec» В29, В30, В32 and В33 (Д64):
  - В33 — the 2026-11-02 amendment to R63 spec, on every point of option 1′, and the amendment of the same day to R77 spec: in the point «Где проверяется» the words «в том шаге, который его получает» for the release of `modules` mean the step of the shared `release.yml` on the runner. Т-35 is closed;
  - В32 — the rerun path of `spec`'s own `release.yml` checks the archive by the recipe `release-verify` from the copy of the checkout, not by `cosign verify-blob` (the 2026-11-02 amendment to R77 spec);
  - В29 — the step "Check the npm package" of `spec`'s `release.yml` reads a package unpublished as a whole as 404, and a version without `dist.integrity` as another archive. Beyond the shared step it also looks for the number in `time.unpublished.versions` — this is В34 in RUN.md (the 2026-11-02 amendment to R18);
  - В30 — the card 3.11 spec names the wrappers «с проверкой лицензий и загрузкой покрытия тестов в Codecov по OIDC», and the Codecov row in architecture 3.12 spec names the wrappers' upload since v0.1.12. Д29 in RUN.md `spec` says that the part of `.github` is done, and names the order of the caller's move, the names of the artifacts and `after_n_builds: 2` at `spec`. The Codecov CLI in `spec`'s `ci.yml` is v11.3.2, as at the wrappers.
- **What else is in the tag:**
  - Д55 in RUN.md `spec` is closed: the `SHA256SUMS` of the release `tutor` v0.1.0 with its bundle is now a fixture of the tests of `release-verify` (the 2026-11-02 amendment to R77 spec);
  - in COORDINATION.md `spec` row 2.2, E10, is done, and row 2.3 is E11, T40 and T41, by option 1′. Row 3.7, the second release of `modules`, waits for T41 to say how the index reaches the recipe `release-files`;
  - R78–R80 spec, privacy and concepts assign `.github` nothing. R79 spec gives the kind `typescript` of the repository template the stage `toolchain` with a browser for tests. The TypeScript wrapper builds this stage from the caller's Dockerfile, as before, and the devcontainer of `.github` is a copy of `spec`'s, where `.devcontainer/` did not change;
  - `.devcontainer/`, RULES.md, AGENTS.md, README.md, `justfile`, `tools/toolchain/`, `tools/licenses/` and `tools/docs-check/` did not change. In `tools/release/` only the tests changed, so the recipes that the shared and `self-` workflows call, `release-verify` among them, are the same word for word. `repo-template/` and `tools/new-repo/` changed (R79 spec) — the workflows of `.github` do not call them — and so did the README of `spec`'s npm package (architecture 4).
- **What is changed here:**
  - `spec/` — at v0.6.3, commit 8460f11; the tag — in README.md, `profile/README.md`, CLAUDE.md and at the start of RUN.md. The release is immutable, and `gh release verify v0.6.3 -R altnovatrail/spec` confirms it;
  - the row Status of the profile does not change: the README of `spec` v0.6.3 is the same as that of v0.6.2;
  - amendments to R18 and R30. In RUN.md the rows В29, В30, В32 and В33 left table 3, and T41 and the description of E11 cite the 2026-11-02 amendment to R63 spec. In README.md — a line about E11; architecture — the status and section 4.
- **What remains:** В34 in RUN.md — whether to take into the shared npm step the check of `time.unpublished.versions`, as at the step of `spec`.

— *Why now:* this is the first task of epic E11 (RUN.md, T40). T41 writes the input of the shared release by option 1′ and cites the entry of `spec` by number, and the entry came with the tag (RULES.md, Across repositories). v0.6.3 is the newest release of `spec` and the first with the answer to Т-35.

— *Rejected:* taking the check of `time.unpublished.versions` into the shared step by this same task. A fix of a shared workflow gives a release of `.github` and comes with its own cases in the suite of tests (R28), while the move is only documents. Where to make it, the author will decide — В34.

— *Consequence:* RUN.md — T40, T41, the description of E11, tables 2 and 3; CLAUDE.md; README.md; `profile/README.md`; R18, R30; architecture: status, 4.

— *Amendment 2026-11-02:* В34, of which the item about В29 and "What remains" speak, is closed in T42. The check of `time.unpublished.versions` at the step of `spec` catches only a number that the registry would name without a key in `time`, and the number of a package unpublished as a whole both steps found before too (the amendment by T42 to R18). Since T42 the check of the shared step is the same as that of `spec`.

— *Amendment 2026-11-08:* `.github` is on v0.9.8 (R32). What is said above about v0.6.3 as the tag of `.github` is history.

## The `spec` tag v0.9.8

**R32. `.github` is on `spec` v0.9.8: the submodule `spec/` is at this tag, and the links to `spec` pinned to a tag name it. The devcontainer is a copy of the container of `spec` at this tag, with buf. What the tag orders to take by the move is taken here as well: the `paths` list of the kind modules in the template of architecture 3.3 and the eval-set organizer in CONTRIBUTING.md. What it orders to do by a task or a release of its own — the fix of the npm step, the Dependabot group and the options of `go.yml` — waits for its epic in table 2 of RUN.md.**
- **What the tag brings** (`git diff v0.6.3 v0.9.8` in `spec/`; RUN.md `spec`, table 4; read 2026-11-08). Between the tags there are 29 releases, from v0.6.4 to v0.9.7. For `.github` these are:
  - `.devcontainer/Dockerfile`: the base image 3.0.12 instead of 3.0.10 and buf 1.75.0 (R83 spec). In the repository template, Environment of CLAUDE.md names buf beside Go;
  - RULES.md: the session of `spec` finds the rows «в реестр spec» itself, in table 3 on `main`, and the question of a row opens with the mark «В реестр spec» (R81 spec). Rule 2 of the template's RUN.md says the same. The new hard rule about production images (R105 spec) does not concern `.github`: `.github` builds and publishes no images, and the release of a service is its binary and `Dockerfile`, files of the caller's recipe `release-files`;
  - the answer to В35 — Д69 in RUN.md `spec`: the comment of the step of `spec` is fixed, and the row goes;
  - Д80 in RUN.md `spec` — the `paths` list of the kind modules in the template and the eval-set organizer in CONTRIBUTING.md (the 2026-11-02 amendment to R25 spec; concepts 15 spec), both «своим переходом»;
  - Д88, Д91 and Д114 in RUN.md `spec` — a `groups` group for the references `altnovatrail/.github/*` in the template `dependabot.yml`; the wait for the version in the npm step up to 20 minutes (the 2026-11-02 amendment to R37 spec); the options of the shared `go.yml` for runs on targets, `fma-diff`, a job on `ubuntu-24.04-arm` and the shared test of the rules of code (R107 spec). `spec` orders to do them by a task or a release of its own;
  - the README of `spec` — format 0.3 since v0.9.0. the row Status of the profile says the same;
  - the card 3.11 spec — only the part about `infra` changed (R105, R106 spec).
- **What did not change.** The recipes that the shared and `self-` workflows call have the same parameters, and `tools/toolchain/` and `tools/docs-check/` did not change. `release-verify` accepts the file of `tutor` v0.1.0, as on v0.6.3 (architecture 4). So no workflow is changed, and the move gives no release of `.github`.
- **What is changed here:**
  - `spec/` — at v0.9.8, commit b1fbc61; the tag — in README.md, `profile/README.md`, CLAUDE.md and at the start of RUN.md. The release is immutable, and `gh release verify v0.9.8 -R altnovatrail/spec` confirms it;
  - `.devcontainer/Dockerfile` — the file of `spec` v0.9.8. The differences are as before: the heading and the suffix "spec" on the decisions that the comments cite — `R34`, `R64` and `R83`. In Environment of CLAUDE.md — buf;
  - rule 2 of RUN.md — by the template;
  - architecture 3.3 — the `paths` list of the kind modules, with the reason why `.devcontainer/Dockerfile` is not in it. The list is the same as in `release.yml` of `modules` and in architecture 3.3 modules;
  - CONTRIBUTING.md: once samples for eval sets start to be accepted, a volunteer hands the file to the eval-set organizer, a maintainer of `modules`, outside GitHub, and only the organizer adds a sample (concepts 15 spec). While П-16 is open, the ban stays;
  - the row Status of the profile — by the README of `spec` v0.9.8, with format 0.3;
  - In RUN.md В35 left table 3, Д5 is checked, and Д7 is closed: the first publication of `canvas` by the npm step went through with provenance (the 2026-11-08 amendment to R18). Table 2 — the epics E13, from Д88 and Д91, and E14, from Д114.
- **What remains.** There is still no list of the kind typescript in the template, while `canvas` already has releases. It goes into E13 of table 2.

— *Why now:* on 2026-11-08 the author had the repository move to the newest tag of `spec`. v0.9.8 is the newest release, and since v0.6.3 `spec` has assigned `.github` five rows of table 4 (RULES.md, Across repositories).

— *Rejected:*
- the fix of the npm step, the Dependabot group and `go.yml` in this same task. A fix of a shared workflow gives a release of `.github` and comes with its own cases in the suite of tests (R28), and the options of `go.yml` have yet to be planned: their conditions are set by `learner-model` and `engine` (R107 spec). The move, though, is only documents and a copy of the container;
- keeping the previous Dockerfile: by CLAUDE.md, Environment, the container of `.github` is the container of `spec`, and the template of the tag already names buf in it. The copy would lag behind the tag the repository is on.

— *Consequence:* RUN.md — E12, T43, rule 2, tables 2–4; CLAUDE.md; README.md; `profile/README.md`; CONTRIBUTING.md; `.devcontainer/Dockerfile`; R18, R31; architecture: status, 3.3, 4.
— *Amendment 2026-11-08:* `.github` is on v0.9.9 (R34). What is said above about v0.9.8 as the tag of `.github` is history.

## The Go code of `.github`

**R33. `.github` has Go code of its own: the CI tool `tools/coderules/`, the test of the rules of code that hold the bits the same on every build. The shared `go.yml` with `same-bits` runs it, "Go / rules", and the caller gives the lists in `.github/coderules.json`. `.github` checks its own code by the shared `go.yml` from `self-ci.yml`, with coverage in Codecov and CodeQL for Go, and a change of the tool gives a release.** Task T48, by R107 spec; the author's answers of 2026-11-08 when it was planned.
- **What it is.** `learner-model` and `engine` each kept the test of the rules of code on `go/types` in their own `rules_test.go`, and the copy of `engine` is a port of the copy of `learner-model` with lists of its own (R09 learner-model; R10 engine). The tool is the copy of `engine`, a superset, turned into a command: `coderules -lists <file> <module root>`. It prints `<file>:<line>: <rule>: <message>` and exits with 1 on findings, with 2 when it cannot check, and with 0 otherwise. The module is `github.com/altnovatrail/.github/tools/coderules`, with no `require`, `go 1.27`: not above the callers' Go, 1.27.3.
- **What is in the tool and what is in the lists.** The rules — `import`, `cgo`, `asm`, `linkname`, `buildtag`, `require`, `replace`, `nested`, `math`, `fused`, `assignop`, `complex`, `typeparam`, `maprange`, `unicode`, `goroutine` — and what they allow everyone from `math`, `strings` and `strconv` are the same for all. The lists are what the copies differed in: `code-imports`, `test-imports`, `test-math`, `requires` and `nested-modules`. The last one is beyond the plan of T48: both copies exempted `.devcontainer/gopls/go.mod`, and that is particular to a repository. The numbers of the rules in each repository are its documents, and a finding names the rule by a word.
- **The lists** are JSON, the caller's `.github/coderules.json`, at the author's word. The tool reads them by `encoding/json` with `DisallowUnknownFields`: a field with a typo is an error, not an empty list. Without the file "Go / rules" fails and names the reason.
- **One check.** The copies ran inside `ci-test` on every target where a test can call the command `go`. The rules forbid build tags, so the code is the same on all targets, and the host is enough for the tool. The importer is `source`, as at `engine`: it also checks a module that is allowed in `requires`.
- **The controls** are `tools/coderules/testdata/learner-model` and `testdata/engine`: the `testdata/coderules` of both, each with its own lists in `coderules.json` and its `go.mod` in `go.mod.control`. The test matches the findings exactly against the comments `// want <rule>`, and every rule is broken by at least one control. Beyond the copies, `engine` has a nested module for the rule `nested`, and `learner-model` the allowed `.devcontainer/gopls`.
- **Its own CI**, at the author's word, is as at all the callers: a root `justfile` with four recipes on the module by `go -C`; the job "Go" of `self-ci.yml` by a local path; `.github/codecov.yml` by the template of architecture 3.3 and `coverage/` in `.gitignore`; CodeQL with `go` (the amendment to R09); `gomod` in Dependabot for `/tools/coderules`. govulncheck and go-licenses are the versions of `engine`; go-licenses skips the module itself by its name: its LICENSE is the root one, Apache-2.0.
- **A release** is given by a change of `tools/coderules/` too (the amendment to R10): `go.yml` builds the tool of its own commit.
- **After the review of T48** the tool prints the findings gathered before a type error, together with the reason: a type error on the host is a frequent consequence of a broken rule `buildtag`. An import cycle is an error, and an empty block `require ()` is not a module. The tool, like the copies, does not read the `ignore` directive of `go.mod`, and it checks the types of the module twice. The callers have no `ignore`, and on their code the check takes a second.
- **What had to be worked around.** actionlint 1.7.12 does not know `job.workflow_repository` and `job.workflow_sha`, and the exception is only these two complaints, only for `go.yml`. SonarCloud counted the two controls as duplicates, 14.1% of the new lines against a threshold of 3%, and `sonar.cpd.exclusions` removes `tools/coderules/testdata/**` from the search for duplicates — not from the analysis.

— *Why:* R107 spec: the test of the rules of code becomes a shared tool of `.github` with lists per repository, instead of two copies. The two copies have already drifted apart — `engine` has the rule `replace` and the parsing of the blocks of `go.mod`, which `learner-model` lacks — and would drift further.

— *Rejected:*
- two tasks, the tool and the job — the author kept one;
- the lists as a Go file at the caller, which the tool would read through `go/ast`: the file would get into the build or would live in `testdata/`; and as multi-line inputs of `go.yml`: long lists in `ci.yml`, and changing them is changing a workflow;
- a job of its own in `self-ci.yml` with `gofmt`, `go vet` and `go test`, without Codecov: it would depart from R48 spec and from how the code of everyone is checked;
- the tool in `spec`, beside its recipes: R107 spec gave it to `.github`;
- a check on every target, as in the copies: the code is the same on all targets, and the runs "Go / targets" already build it;
- `fixes` in `codecov.yml`: Go accepts the module path with `.github`, and the default rule of Codecov matched the paths.

— *Consequence:* `tools/coderules/`; `justfile`; `.gitignore`; `.github/codecov.yml`, `.github/actionlint.yaml`, `.github/dependabot.yml`, `.sonarcloud.properties`; `go.yml`, `self-ci.yml`, `self-codeql.yml`, `self-release.yml`; `tests/`; R09, R10, R16; architecture 1, 3.1, 3.3, 3.4, 4; RUN.md, T48, В36. At `learner-model` and `engine` — their move to the release of T48: the lists, and `rules_test.go` with `testdata/coderules` go.

## The `spec` tag v0.9.9

**R34. `.github` is on `spec` v0.9.9: the submodule `spec/` is at this tag, and the links to `spec` pinned to a tag name it. The tag answers В36: the card architecture 3.11 spec names the input `same-bits` and the tool of `.github` with the caller's lists, and the row leaves table 3 of RUN.md. The move changes neither a workflow nor the devcontainer, and it gives no release of `.github`.** Task T51.
- **What the tag brings** (`git diff v0.9.8 v0.9.9` in `spec/`; RUN.md `spec`, table 4; read 2026-11-08). The tag is the next one after v0.9.8. For `.github` these are:
  - Д116 in RUN.md `spec`: the answer to В36. The item "for code" of the card 3.11 spec names the input `same-bits` of the Go wrapper — the runs on targets, `fma-diff`, the run on arm64 and the test of the rules of code by the tool of `.github` with the caller's lists in `.github/coderules.json` (R107 spec; the 2026-11-08 amendments to R16), — and orders `.github` to close the row;
  - the 2026-11-08 amendment to R32 spec: the name of a NovaTrail repository after a number or a section is the suffix of a citation wherever a word boundary follows it. The trial run of `spec` found five places at `.github` where a citation of another repository's log was checked against its own. With the tag they read as another's, and `docs-check-repo` is ok, as before the move.
- **What did not change.** `.devcontainer/`, RULES.md, `justfile` and `tools/toolchain/` are the same as on v0.9.8, and in `tools/docs-check/` only the reading of citations changed. The recipes that the shared and `self-` workflows call have the same parameters.
- **What is changed here:** `spec/` — at v0.9.9, commit fa5da0b; the tag — in README.md, `profile/README.md`, CLAUDE.md and at the start of RUN.md. The release is immutable, and `gh release verify v0.9.9 -R altnovatrail/spec` confirms it. В36 left table 3.

— *Why now:* on 2026-11-08 the author had the repository move to the newest tag of `spec`, and v0.9.9 is the newest release. While `.github` is on a tag without the answer, В36 is open (Д116 in RUN.md `spec`).

— *Rejected:* waiting for the next tag — the move changes nothing but documents, and the answer to В36 has already come out.

— *Consequence:* RUN.md — E16, T51, tables 2 and 3; CLAUDE.md; README.md; `profile/README.md`; R32; architecture: status, 4.

— *Amendment 2026-11-08:* **there is no epic E16 and no body of T51 in RUN.md: the author had them removed — a small task gets no epic.** What is said above about E16 and about the body of T51 in RUN.md is history; the number T51 is taken, and what the task did is recorded here and in architecture 4.

— *Amendment 2026-11-09:* `.github` is on v0.12.0 (R35). What is said above about v0.9.9 as the tag of `.github` is history. The replacement of the tag in README.md also rewrote the phrase about E12 that names v0.9.8, the tag of E12; R35 put v0.9.8 back in it.

## The `spec` tag v0.12.0

**R35. `.github` is on `spec` v0.12.0: the submodule `spec/` is at this tag, and the links to `spec` pinned to a tag name it. The move changes neither a workflow nor the devcontainer, and it gives no release of `.github`. The image cache of the `toolchain` stage in the shared workflows, which the tag assigns to `.github`, is a task of its own with a release, not part of the move.** With no epic and no task in RUN.md, at the author's word.
- **What the tag brings** (`git diff v0.9.9 v0.12.0` in `spec/`, 56 commits, the releases v0.9.10–v0.12.0; COORDINATION.md and RUN.md `spec`; read 2026-11-09). The tag is the newest release of `spec`: format 0.4 since v0.10.0, the part `deployment/` — the configuration of a deployment — since v0.11.0, the admission table 0.2 since v0.12.0. For `.github` these are:
  - the 2026-11-09 amendment to R31 spec and Д146 in RUN.md `spec`, row 2.4 of COORDINATION.md: the image of the `toolchain` stage in CI is taken from the cache of GitHub Actions by the key `toolchain-<OS>-<architecture>-<sha256 .devcontainer/Dockerfile>`. `.github` gets this «своей задачей и релизом»: in `go.yml` and `typescript.yml` — steps of `actions/cache` around its own build of the image, in `documents.yml` — around `toolchain.sh build` of the tag of `spec` with T104 `spec`, and the shared `release.yml` takes no cache. On v0.12.0 T104 `spec` is still waiting, and `tools/toolchain/` is the same as on v0.9.9;
  - the 2026-11-09 amendment to R77 spec: the fifth kind of file of `spec` is `deployment-<version>.tar.gz`, and `release-verify` accepts it. The files that the shared `release.yml` checks are the caller's, and the recipe is called with the same parameters;
  - the kind `go` of the repository template gives gopls from a lock file, by the key `devcontainer` in `repo-template/kinds.json` (R102 spec, В19 and the 2026-11-08 amendment). The container of `.github` is the container of `spec`, not of the kind `go`, and the Go of the code of `tools/coderules/` is the Go of this container (R33), so `.github` does not take it.
- **What did not change.** `.devcontainer/`, RULES.md, `tools/toolchain/`, `tools/docs-check/` and `tools/licenses/` are the same as on v0.9.9. In `justfile` — new recipes `deployment-check`, `report-check` and their tests and fixes of the release recipes of `spec`, and the recipes that the shared and `self-` workflows call — `docs-check-repo`, `licenses-allowed`, `release-version`, `release-refusal`, `release-verify` — have the same parameters. The item of `.github` in the card 3.11 spec did not change.
- **What is changed here:** `spec/` — at v0.12.0, commit 5b4640a; the tag — in README.md, `profile/README.md`, CLAUDE.md and at the start of RUN.md. The profile names format 0.4 since v0.10.0. The release is immutable, and `gh release verify v0.12.0 -R altnovatrail/spec` confirms it.

— *Why now:* on 2026-11-09 the author had the repository move to the newest tag of `spec`, and v0.12.0 is the newest release.

— *Rejected:* taking the image cache by the same move — it is a change of three shared workflows, of their tests and a release of `.github`, and the author bid to move without an epic and a task; besides, the cache of `documents.yml` waits for T104 `spec`. Row 2.4 is a task of its own: epic E17, which the author started on 2026-11-09: «заводи эпик».

— *Consequence:* RUN.md — the tag, tables 1 and 2, epic E17; CLAUDE.md; README.md; `profile/README.md`; R34; architecture: status, 4.

— *Amendment 2026-11-10:* `.github` is on v0.13.0 (R37). What is said above about v0.12.0 as the tag of `.github` is history.

## The image cache of the `toolchain` stage

**R36. The jobs of the shared `go.yml` and `typescript.yml` that build the image of the caller's `toolchain` stage take it from the cache of GitHub Actions: the step "Toolchain image from the cache" (`actions/cache/restore`) restores a file of `docker save` by the key `toolchain-${{ runner.os }}-${{ runner.arch }}-${{ hashFiles('.devcontainer/Dockerfile') }}`, the step "Toolchain image" loads it by `docker load` and checks that the image `toolchain` is there, and without the file builds the image from the Dockerfile and writes the file, and the step "Toolchain image into the cache" (`actions/cache/save`) saves it right after the build, only on a miss. The file is `${{ runner.temp }}/toolchain.tar`, outside the caller's checkout, and the image is named, as before, `toolchain`. The releases — the shared `release.yml` and `self-release.yml` — take no cache.** Task T52, epic E17; by the 2026-11-09 amendment to R31 spec and Д146 in RUN.md `spec`, as R57 canvas.
- **Where.** The steps stand in every job that builds the stage: in `go.yml` — `check`, `targets`, `fma-diff`, `arm64` and `rules`, in `typescript.yml` — `check`; the three steps are the same in all, and the suite (R28) holds them the same, and the build step as one script for all the jobs. The key takes the OS and the architecture of the runner, so `arm64` on `ubuntu-24.04-arm` keeps an entry of its own.
- **Without the network.** The Dockerfile pins everything it installs by exact versions and sums (R34 spec, R40 spec), so the image from the cache is the one it would have built. On a hit the Dockerfile is not run, and nodejs.org, GitHub and the snapshot of the Ubuntu archive are not needed. A change of the Dockerfile gives a new key.
- **Failures cost speed, not the verdict.** A file that did not load or gave no image `toolchain` the step deletes with a warning and builds the image; a `docker save` that failed is a warning, and a half-written file is deleted. A failure of saving by `actions/cache/save` does not fail the job (`src/saveImpl.ts` v6.1.0; architecture 4). A failure of `docker build` is red, as before. An entry in the cache is immutable, and a file from it is a hit, on which the save step does not run, so after a build on a hit the step writes no file. A corrupted entry that hits is read by every run, and it does not age: the runs build the image from the network, with a warning, until the Dockerfile changes or the entry is deleted — `gh cache delete <key> -R <repository>`.
- **Scopes.** The cache is the caller's: the entry of a pull request is seen only by its reruns, and the entry of `main`, which every pull request reads, is saved by the caller's CI run on a push to `main` (the 2026-11-09 amendment to R31 spec). For the run of a pull request from a fork the cache is read-only, and the save warns, and the job goes on (README of `actions/cache`, "Read-only access"). The image from the cache is checked by nothing: the entry of `main` is held by the same as the code on `main` — review and actions by SHA, as at R57 canvas.
- **An entry of its own.** The key is the one that R31 spec orders, but an entry is the key, the version and the branch, and the version is a hash of the path and of the compression method (README of `actions/cache`, "Cache scopes", "Cache Version"). The path here is its own, not the one that `toolchain.sh` of T104 `spec` will give, so the entry of `documents.yml` will not collide with this one, even if the image name in its file is `novatrail-toolchain`. Whether they will share an entry, T53 decides. The key of R31 spec does not know how the step builds the image, so a change of the build — another `--target`, another image name — takes a new path too: the entries of the old path will not hit it.
- **The matrix.** On a miss every job builds the image itself and tries to save it: one saves, and the others write "Unable to reserve cache … another job may be creating this cache" and go on (pull request #109; architecture 4). A separate warm-up job would lengthen every run.
- **The license.** `actions/cache` v6.1.0, commit 55cc834, is MIT, category A (R12 spec): a CI action, it ships nowhere. Like the other actions, a SHA pins it, and Dependabot moves it.
- **The measurement** (architecture 4): the build of the stage in the run of `self-ci.yml` 42500504949 — 20–26 s per job, at `canvas` in the CI run 42704340930 — 60–76 s on each of the four jobs of `typescript.yml`.

— *Why:* the author started epic E17 on 2026-11-09 and, when T52 was planned, chose an entry of the cache of its own, this decision and a live check by a draft pull request (RUN.md, T52). The build failed at `canvas` and `spec` on the network: «`curl: (22) The requested URL returned error: 504` после трёх повторов» (the 2026-11-09 amendment to R31 spec).

— *Rejected:*
- a shared entry with `toolchain.sh` right now: the path and the image name would have to be guessed before T104 `spec` chooses them;
- a warm-up job that alone builds and saves the image while the others wait for it: on a hit it would lengthen every run;
- buildx with the cache `type=gha` — two actions `docker/*` instead of one, as R57 canvas rejected too;
- the cache in the releases — the image of a job with the right to sign would be held by an entry of the cache, not by the Dockerfile (the 2026-11-09 amendment to R31 spec);
- the file in the caller's checkout, as `build/` at `canvas`: the recipes and `git status` would see it;
- a composite action of its own: Dependabot `github-actions` with `directory: /` looks at `.github/workflows`, as the argument of R57 canvas;
- YAML anchors for the three steps instead of six copies (a finding of the review of T52): that the suite's yq, actionlint and Dependabot read them the same way is not checked, and the suite holds the copies the same.

— *Consequence:* `go.yml`, `typescript.yml`; `tests/` — a stub `docker` with an exit code per subcommand (`stub_exit_on`) and a file of `docker save`; R16, R19; architecture 3.1, 4; RUN.md, T52. The callers need change nothing: the steps ask for neither permissions nor inputs.

— *Amendment 2026-11-10:* **the image of the stage is taken from the cache by `documents.yml` too — the job `docs-check-repo` — and by the own job "Workflows" of `self-ci.yml`, around `toolchain.sh build`: the variable `TOOLCHAIN_IMAGE_FILE` names the file, the path is `${{ runner.temp }}/novatrail-toolchain.tar`.** Task T53, by Д146 in RUN.md `spec` and T104 `spec` (the second 2026-11-09 amendment to R31 spec; R37).
- **How.** The same three steps as above, but the build and the file are run by the script of the `spec` submodule: with the file — `docker load` and `docker image inspect novatrail-toolchain`, the file deleted, no build; the file did not load — deleted, `::warning::`, a build without the file; no file — a build and `docker save`. The step "Documents" is split into "Toolchain image" and "Documents", so that the save runs right after the build (the 2026-11-10 amendment to R08).
- **A path of its own.** The script names the image `novatrail-toolchain`, and `go.yml` names it `toolchain`, so the file of the script has a path of its own, the one that `spec`'s `ci.yml` gives it, and the entry under the same key is another one. `documents.yml` and "Workflows" in the repository `.github` have one entry: the script and the image are the same.
- **Tags older than v0.13.0.** The step always sets the variable: the earlier script does not notice it and builds the image as before, and the save without a file warns and does not fail the job. There is no need to check the tag, and such a caller will get the cache with its move to the tag.
- **What the key does not know.** The key of R31 spec is the OS, the architecture and the Dockerfile, not the script of `spec` that builds the stage: a tag of `spec` that would build the stage otherwise would, with the same Dockerfile, hit the entry of the earlier tag. Today the script builds only `docker build --target toolchain` by the Dockerfile, and `spec`'s `ci.yml` keeps the same key; a change of the build in the script is a change of `spec`, and it is that change that alters the path of its file or the key (a finding of the review of T53).
- **Two entries at a caller with code** — `toolchain.tar` of `go.yml` and `novatrail-toolchain.tar` of `documents.yml`, ~383 MB each at `.github` (architecture 4), against the limit "10 GB per repository". One entry would require the image `novatrail-toolchain` and the file of the script in every job of `go.yml` and `typescript.yml`, against the entry of its own that the author chose in T52; this can be taken later, by a task of its own.

— *Rejected:* a copy of the script of `spec` v0.12.0 in the suite for the case of an old tag — in CI the submodule comes without history, and a copy is one more file to look after; the suite takes a short stub of the same shape. A check of the submodule's tag before the cache steps — the variable does not require it (T104 `spec`, «Решено автором»).

— *Consequence:* `documents.yml`, `self-ci.yml`; `tests/documents.test.sh`; R08; architecture 3.1, 3.4, 4; RUN.md, T53.

— *Amendment 2026-11-10:* the release came out — `v0.1.22`, commit c023405, the merge commit of pull request 109 of the branch `e17`, immutable and Latest; `gh release verify` confirms it. From `v0.1.21` it differs in `go.yml`, `typescript.yml` and `documents.yml` — the image cache — and `release.yml` is the same (`git diff v0.1.21 v0.1.22`). The template of architecture 3.3 calls `go.yml` and `typescript.yml` by this SHA; the shared calling files — `documents.yml` among them — the template still keeps at `v0.1.0`, and Dependabot raises the callers. On `main` after the merge the CI run saved both entries — `toolchain.tar` and `novatrail-toolchain.tar`, ~383 MB each, the scope `refs/heads/main` — and every pull request of `.github` reads them.

## The `spec` tag v0.13.0

**R37. `.github` is on `spec` v0.13.0: the submodule `spec/` is at this tag, and the links to `spec` pinned to a tag name it. The tag carries T104 `spec` — the image cache in `toolchain.sh build` by the variable `TOOLCHAIN_IMAGE_FILE` — which T53 waited for. The move changes neither a workflow nor the devcontainer.** With no epic and no task, as R35; a commit on the branch `e17` of epic E17.
- **What the tag brings** (`git diff v0.12.0 v0.13.0` in `spec/`; RUN.md `spec`, T104 and Д146; read 2026-11-10). For `.github` these are:
  - the second 2026-11-09 amendment to R31 spec, T104 `spec`: `toolchain.sh build` with `TOOLCHAIN_IMAGE_FILE` — the full path of the file of `docker save`. Without the variable or with an empty one — a build, as before. The file is there — `docker load --quiet --input <file>` and `docker image inspect novatrail-toolchain`, the file deleted, no build. The file did not load or gave no image — deleted, `::warning::`, a build and no file: this is a hit, and the entry will not change. No file — a build and `docker save --output <file> novatrail-toolchain`, and a failed `save` is `::warning::` and code 0. All this is what `.github` asked for for T53, and it is decided «по рекомендациям и просьбе `.github` (E17, pull request 109)»: a variable, not an argument, because the earlier script refuses any argument and does not notice a variable;
  - `spec`'s `ci.yml` takes the cache with the file `${{ runner.temp }}/novatrail-toolchain.tar` and the same key as R36; `spec`'s `release.yml` takes no cache;
  - row 2.4 of COORDINATION.md: «E17: T52 сделана, T53 ждёт», in `documents.yml` and `self-ci.yml` — around `toolchain.sh build` of the tag of `spec` with T104, `v0.13.0`.
- **What did not change.** `.devcontainer/`, RULES.md and `tools/licenses/` are the same as on v0.12.0. In `justfile` — new recipes of the parts of `spec` and fixes of its own release paths, and the recipes that the shared and `self-` workflows call have the same parameters. In `tools/docs-check/` — a new document of `spec`, `docs/dpia.md`. The suite of tests of `.github` with the new script of the submodule is green: without the variable the script behaves as before.
- **What is changed here:** `spec/` — at v0.13.0, commit 59fd14f; the tag — in README.md, `profile/README.md`, CLAUDE.md and at the start of RUN.md; T53 in RUN.md — with no waiting and with the variable `TOOLCHAIN_IMAGE_FILE`. The release is immutable, and `gh release verify v0.13.0 -R altnovatrail/spec` confirms it.

— *Why now:* on 2026-11-10 the author had the repository move to the newest tag — the one that answered the request of `.github`; v0.13.0 is the newest release of `spec`.

— *Rejected:* waiting until T104 also closes its live check on a pull request of the branch `e4` of `spec`: that check is about `spec`'s `ci.yml`, while `.github` takes only the script, and its behaviour is held by `just toolchain-test` of `spec` and by the suite of `.github`.

— *Consequence:* RUN.md — the tag, T53; CLAUDE.md; README.md; `profile/README.md`; R35; architecture: status, 4.

— *Amendment 2026-11-12:* `.github` is on v0.16.3 (R38). What is said above about v0.13.0 as the tag of `.github` is history.

## The `spec` tag v0.16.3

**R38. `.github` is on `spec` v0.16.3: the submodule `spec/` is at this tag, and the links to `spec` pinned to a tag name it. With the tag `.github` takes the order of work of E10 `spec` (R143 spec, R145 spec): one task is one session, and `.claude/settings.json` by the repository template — the hook `UserPromptSubmit` from `spec/tools/session/`, compaction at 400 thousand, the claude.ai connectors off; the rules of the parts `.claude/rules/` instead of the paragraph Environment of CLAUDE.md; the rules of RUN.md by the template and table 4 in a file of its own, `DEBT.md`. The rebuilding and the translation of the documents are done by the tasks T55–T57 of epic E18. The move changes neither the shared workflows nor their tests, and it gives no release of `.github`; the container gets Go 1.27.4, as at `spec`.** Task T54, epic E18; row 7.2 of COORDINATION.md `spec`.
- **What the tag brings** (`git diff v0.13.0 v0.16.3` in `spec/`, 77 commits; RULES.md, COORDINATION.md and DEBT.md `spec`, the body of T123 in `docs/plan/E10.md` `spec`; read 2026-11-12). For `.github` these are:
  - RULES.md: the documents of `docs/`, but for the archives `docs/plan/`, are read by a session of Claude Code; one task is one session, and the hook stops a prompt that starts another; a decision that changes the text of another entry puts an amendment on it; the records of sources are in `docs/sources.md`, the results of measurements in `docs/measurements.md`; the documents of `docs/` are in English, and a document in Russian stays so until a task of its own translates it (R143 spec and its 2026-11-12 amendments);
  - row 7.2 of COORDINATION.md and the shared text of T123 `spec` with a table of differences. For `.github` — «подмодуль на `v0.13.0` — через три линии; хука нет; «Источники» и замеры — больше всего, с `infra`, `canvas` и `tutor`; запись R18 — 66 КБ: перевод её сжимает, что останется сверх 40 КБ — пределом в `docs-budgets.json`». Rows 7.2–7.12 wait for the pilot, row 7.1 of `module-kit`, and the submodule of `module-kit` on `main` is still at `v0.15.0` (the GitHub API);
  - Д215 spec: the submodule carries the rules of the parts `spec/.claude/rules/`, and Claude Code would load a rule of `spec` into a session of `.github` as soon as it reads a file of its part in `spec/`. The line `"**/.github/spec/.claude/rules/**"` in `claudeMdExcludes` keeps them out;
  - Д134 spec: `infra` has OpenTofu, not Terraform (the 2026-11-08 amendment to R11 spec), and the line of `infra` in the profile is "OpenTofu";
  - `.devcontainer/Dockerfile` of `spec`: Go 1.27.4 instead of 1.27.3, with the sums of both archives; the sums match go.dev (architecture 4);
  - `docs-check` reads the rules `.claude/rules/` and table 4 in `DEBT.md`, and measures the budgets of size when the root holds `docs-budgets.json` (R145 spec). The new recipes are `translation-check`, `translation-anchors` and `tokens-report`;
  - `release-verify` also accepts `consent-age-<version>.tar.gz` and `export-<version>.tar.gz` (R134 spec, R135 spec). The files that the shared `release.yml` checks are the caller's, and the recipe is called with the same parameters;
  - Д213 spec: in "Go / targets" and "Go / arm64" of the shared `go.yml` wasip1 is `go test -exec` with an executor of its own on `node:wasi` instead of a single build (the 2026-11-11 amendment to R107 spec), and `.github` does this «своей задачей и релизом» — epic E19 of table 2 of RUN.md;
  - Д217 spec: WebKit and Firefox in the stage of the kind `typescript`, and for `.github` — the browsers of the contract of the TypeScript wrapper (R19). It is made by T141 `spec`, which is not in the tag yet.
- **What did not change.** `tools/toolchain/` is the same as on v0.13.0. The recipes that the shared and `self-` workflows call — `docs-check-repo`, `licenses-allowed`, `licenses-check-repo`, `release-version`, `release-refusal`, `release-verify` — have the same parameters, and in `tools/licenses/config.mjs` only the exception `elkjs` of `spec` itself changed. The card 3.11 spec is translated into English (T137 `spec`), and before the translation only the link to the source changed in the item of `.github` — `sources 6.1` instead of `раздел 8`.
- **What is changed here:**
  - `spec/` — at v0.16.3, commit 664398e; the tag — in README.md, `profile/README.md`, CLAUDE.md and at the start of RUN.md. The release is immutable, and `gh release verify v0.16.3 -R altnovatrail/spec` confirms it;
  - `.claude/settings.json` — by the template `spec/repo-template/files/.claude/settings.json`, with the folder name `.github`. There are no keys of the plugin `gopls-lsp`: they belong to the kind `go`, and the container of `.github` is the container of `spec`, without gopls (R35);
  - CLAUDE.md is thin: the paragraph Environment — the items about `docs-check-repo`, about the settings of the session and about the rules of the parts, and the checks of the parts are in the rules `.claude/rules/workflows.md` — the suite of the steps' tests (the 2026-11-12 amendment to R28) — and `.claude/rules/go.md` — `tools/coderules/` and the justfile (R33). In Documents — the language of the documents, DEBT.md, and the phrase about table 1 moved to RUN.md. The paragraph The component is without the retelling by releases, "from the release that T… brings", which architecture 1 and 3.1 and the log hold: with the rules of the parts CLAUDE.md is 10.5 KB, 10,742 bytes, against the limit of 12 KB of the block `repository` (R145 spec), and with only the edits of Environment and Documents it came to 12.2;
  - RUN.md — «Как пользоваться» and «Как устроен план» by the template of v0.16.3; table 4 — in `DEBT.md`, with the next number Д8, as before; epic E18 and the row E19 in table 2;
  - AGENTS.md — the item "Rules by path", as in the template: CLAUDE.md names the rules of the parts;
  - the profile — "OpenTofu" and the documents of `spec` "in English"; CONTRIBUTING.md — what is in which language, by RULES.md spec; README.md — the status, the language of the documents and DEBT.md;
  - `.devcontainer/Dockerfile` — Go 1.27.4 and its sums, as at `spec`. The differences from the file of `spec` are as before: the heading and the suffix "spec" on the decisions that the comments cite.
- **The differences from the template**, as R46 canvas-api: the rules of the parts are its own, `workflows` and `go`; in RUN.md — the opening with a link to `docs/plan/history.md`, the line «Сделанные эпики» with E16 and the next task number, and the phrase of rule 10 about the documents that are still in Russian; in DEBT.md — a link to the closed Д1–Д7. In CLAUDE.md — its own Your role, The component and the list of the documents of `.github`, as before, and beyond them: Environment — in items, as in CLAUDE.md of `spec`, with an item about `.claude/settings.json`; the budgets of `docs-check-repo` — with the proviso that they are measured by the `docs-budgets.json` of T57; in Documents — a phrase about the documents that E18 has not translated yet, and `docs/sources.md` with `docs/measurements.md` — a phrase beside architecture, until T55 starts them. These differences, but for the items of Environment and its own sections, are removed by T55–T57. «Как пользоваться» and `.claude/settings.json` are as in the template, but for the name.

— *Why now:* on 2026-11-12 the author had the repository move to the newest tag of `spec`, and then chose to take the whole row 7.2 without waiting for the pilot — by four tasks, by rule 11 of RUN.md. v0.16.3 is the newest release of `spec`, and it is not older than `v0.16.1`, as the shared text of T123 `spec` orders.

— *Rejected:*
- only the move to the tag, as R35 and R37, and the rebuilding and the translation later: the author chose the whole row;
- waiting for the pilot of `module-kit`: the author chose not to wait;
- one task, as in the shared text of T123 `spec`: at `.github` that is more than one check — ≈ 297 KB of architecture — 228 thousand characters — and ≈ 364 KB of the log — 249 thousand;
- seven tasks — the translation of architecture, sources and the log in parts: the author chose four;
- tasks outside an epic, as the one task in the shared text: the body of a done task outside an epic goes to the archive of the current epic (rule 9 of RUN.md), and `.github` has none;
- the plugin `gopls-lsp`: it is for the kind `go`, and there is no gopls in the container of `.github`.

— *Consequence:* RUN.md — the tag, the rules, tables 1, 2 and 4, epic E18; DEBT.md; `docs/plan/E18.md`; CLAUDE.md; AGENTS.md; `.claude/settings.json` and `.claude/rules/`; README.md; `profile/README.md`; CONTRIBUTING.md; `.devcontainer/Dockerfile`; R28, R37; architecture: status, 4.

— *Amendment 2026-11-12:* **"Sources", architecture 4, are sorted out by source: the records of external facts are in `docs/sources.md`, 13 topics and 62 records, the results of measurements in `docs/measurements.md`, 10 topics and 32 records, and in the place of section 4 there is the pointer "Sources and measurements" with a table "group → records". The claims of architecture 1–3, CLAUDE.md, README.md and the comments of the workflows and the tests cite the records — `sources 2.1`, `measurements 5.2`; the log and the archives `docs/plan/` are not edited.** The author's decisions of 2026-11-12 when T55 was planned, by the recommendations (RULES.md spec, The bar; the 2026-11-12 amendment to R143 spec).
- **Topics — by subject:** GitHub Actions; GitHub — rulesets, releases and the organization; Dependabot; CodeQL; Scorecard; Sigstore; npm; Node, browsers and TypeScript tests; Go, go-licenses and Codecov; the tools of the checks; the tags of `spec`; other NovaTrail repositories; MathTrail and samples. A record is one source: the pages of one publisher on one subject, the code of one project, a tag of `spec`; in it are readings by date, each with its date and decision (sources 1).
- **Read goes to sources, run goes to measurements.** In sources — documentation, code at a commit, the answers of the API and of the registry, files of other repositories and sums checked against the downloaded file; in measurements — trial pull requests, steps taken out of their files, the suite and its breakages, durations, sizes and trials of a tool's behaviour. An item where a trial stood beside a quote is cut, and both parts cite each other: there are 20 such items.
- **The pointer** is "Sources and measurements": the log and the archives cite "architecture 4" and the groups by name — "architecture 4, «Публикация в npm»" — and the table leads from a group to its records.
- **The comments of the shared workflows** — `go.yml`, `release.yml` and `scorecard.yml` — are pointed at the records too, though epic E18 did not touch the shared workflows: a change of their files gives, after the merge, the release of `.github` `v0.1.23` with comments alone, and the callers will get a Dependabot pull request. So the author decided when T55 found this contradiction with the task.
- **Readings in the text** — «(API GitHub, 2026-10-20)» in architecture 2.9 and «(API GitHub, 2026-10-21)» in 3.3 — became a record too, sources 13.6, as they stood: they have no answers of the API.
- **Without losses.** A script checked the former section against the new files and the pointer: not one address, quote, date, commit, number or code was lost, and none occurs less often than before (measurements 10.1).

— *Rejected:* topics by publisher — the topics of GitHub and of open projects would come out big; topics by workflow — one source, checkout or npm, would stand in several topics; a trial with its source — sources would hold runs; only numbers in measurements — the trials without numbers would remain in sources; a pointer "Sources" without a table, as architecture 8 spec — a link of the log to a group would lead only to the file; the comments of the shared workflows — as a debt until the task that changes each file, with no release.

— *Consequence:* `docs/sources.md`, `docs/measurements.md`; architecture: status, the opening, 1–3, 4; CLAUDE.md; README.md; `go.yml`, `release.yml`, `scorecard.yml`; `tests/lib.sh`, `tests/release.test.sh`; RUN.md, T55.

— *Amendment 2026-11-13:* **the decision log is in English, and the size of the documents is checked: `docs-budgets.json` at the root raises over the block `repository` of `spec/tools/docs-check/budgets.json` only the limit of an entry, to 50 KB, for R18, and that of architecture 3.3, to 37 KB. RUN.md drops the section «Задачи вне эпика» and what else its executor does not need. Epic E18 is done.** Task T57; the author's word of 2026-11-13 for RUN.md (R143 spec, R145 spec).
- **The translation** — by `spec/tools/translation/README.md`, as T56: 19 pieces, seven subagents, each piece clean by `pair`; the entries and their amendments are translated as they are, and a quote of the log's own text is the English of the passage it quotes. `translation-check` against 29e539d, the merge commit of T56, is clean, and the blind reading of six stretches found no difference of meaning: one word added and three wordings that could be misread are fixed. The headings are renamed, and no link of the repository led to them.
- **The budgets** (measurements 11.1). After the rebuilding and the translations only two things are over the block: architecture 3.3 and R18. The block has no limit for one entry, so the 50 KB of R18 hold every entry of the log; a limit of its own for an entry is row В38 of RUN.md, «в реестр spec».
- **RUN.md**: without the section «Задачи вне эпика» and the item of rule 9 on such a task, by the author's word: the plan holds a task only in an epic. Shorter, with the numbers of the rules kept, which the documents cite: the opening — the pointers alone; rule 6 — without the list of what `docs-check-repo` checks, which CLAUDE.md holds; rule 10 — without the sentence on the documents still in Russian; without the paragraph «Ссылки», which RULES.md spec, Citations, holds; the openings of tables 2–4 — one sentence each. These are differences from the repository template too.
- **The measurement** "after" — measurements 11.2: four sessions of T54–T57, the context of a call of the main session 188.8 thousand tokens against 397.5 before the epic.
- CLAUDE.md and README.md no longer name the log as Russian; architecture: the status.

— *Rejected:* a limit of 50 KB for R18 alone — the block has no such key, and an entry is never rewritten to be shorter; raising the limit of a section for all — only 3.3 is over; keeping the section «Задачи вне эпика» as the repository template has it — the author removed it.

— *Consequence:* `docs/decisions.md`; `docs-budgets.json`; measurements 11; CLAUDE.md; README.md; RUN.md; `docs/plan/E18.md`; architecture: status.
