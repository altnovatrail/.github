# .github — measurements

> The results of `.github`'s measurements: what was measured, how, on what, and the numbers that came out — trial pull requests and their runs, steps taken out of their files and run on their own, the suite of tests of the steps and its breakages, durations and sizes. The document that describes the design, [architecture.md](architecture.md), cites this file and holds no numbers of measurements itself, and a new entry of the decision log names the measurement, not its numbers (R143 spec). The numbers that entries of the log held before T55 stay in them: a decision is never rewritten. A measurement is cited by its section, like any document: `measurements 1.1`, and from another repository `measurements 1.1 .github`.
>
> The external fact a measurement stands on is a record of [sources.md](sources.md), and the measurement names it. Each measurement is a paragraph "Measured <date> (<decision or task>):" and the items under it. Measurements 1.1–9.1 come from the former section "Sources", architecture 4, on 2026-11-12 (T55), word for word, and 10.1 is the comparison of T55 itself; on 2026-11-13 T56 translated the file into English, and the quotes are in the language of their source; a new measurement is a record at the end of its topic, a new topic goes at the end of the file, and a record's number never changes.

## 1. The shared checks

### 1.1. CodeQL: the trials #9 and #10

Measured 2026-10-20 (R09):
- **the CodeQL bundle** (sources 5.1) — the run on pull request #10: "'tools: linked' was requested, so using CodeQL version 2.27.2, the version shipped with the Action";
- **the check of findings** (sources 5.2) — on pull request #10 this check is named "CodeQL", and the app `github-advanced-security` (id 57789) sets it: "No new alerts in code changed by this pull request";
- **the checks of a skipped matrix** — the trial pull request #9: `self-codeql.yml` passed `go`, "CodeQL / languages" failed, and for the analyses one check came, "CodeQL / analyze (${{ matrix.language }})", skipped; there was no check "CodeQL / analyze (actions)".

### 1.2. CodeQL exclusions: the trials #19 and #20

Measured 2026-10-20 (the amendment to R09, T14):
- **the Actions extractor and `paths-ignore`** (sources 5.3) — in the first run of the trial #19 the job of the `actions` analysis wrote "LGTM_INDEX_FILTERS set. Using the default filters together with the user-provided filters". So `codeql.yml` gives `config` only to the analyses of the caller's languages;
- **the trial pull request #19**, not merged. `self-codeql.yml` passed `javascript-typescript` and `paths-ignore: trial/**`, and `trial/sample.html` held a DOM XSS:
  - when all the JavaScript was in the excluded folder, the analysis failed: "CodeQL could not process any code written in JavaScript/TypeScript";
  - with a file outside `trial/` and with the input, the JavaScript analysis gave 0 results;
  - without the input, a finding `js/xss` of level high in `trial/sample.html`, and the check "CodeQL" of GitHub Advanced Security turned red;
- **the trial pull request #20**, not merged — the same after `config` stopped reaching the `actions` analysis. The comment line was skipped, the configuration was `paths-ignore: ["trial/**"]`, and the JavaScript analysis gave 0 results. The `actions` analysis wrote "LGTM_INDEX_FILTERS not set. Using the default filters": it got no configuration.

### 1.3. Go in CodeQL: the trial #30

Measured 2026-10-21 (the amendment to R09, T19):
- **the trial pull request #30**, not merged: `codeql.yml` of the branch of T19, `self-codeql.yml` with `languages: go`, Go 1.27.3 in the `toolchain` stage, as in `module-kit`, and a Go module at the root. With a command taken from the request, "CodeQL / analyze (go)" passed — the log names `go version go1.27.3 linux/amd64` — and the check "CodeQL" of GitHub Advanced Security failed on a finding go/command-injection of level critical, `trial/main.go:11`. With a constant command, the Go analysis gave 0 results, and "CodeQL" is green.

### 1.4. gitleaks without `--log-opts`

Measured 2026-10-20 (R08):
- **gitleaks without `--log-opts`** reads all branches, not only the history of the commit it checks: a local trial on 2026-10-20 — a key in another branch was found without `--log-opts` and was not found with `--log-opts=HEAD`.

## 2. The Go wrapper

### 2.1. The license list: go-licenses and the step of `self-ci.yml`

Measured 2026-10-21 (R16):
- **`--allowed_licenses`** (sources 10.2) — a local trial on 2026-10-21, by the recipe `ci-licenses` of the repository template of `module-kit`, with go-licenses v2.0.1: with the list `ALLOWED_LICENSES`, green; with a list of MIT alone, "Not allowed license 'Apache-2.0' found for library 'github.com/altnovatrail/module-kit/cmd/module-kit'"; without a list, the recipe stops by itself;
- **the list of `spec`** (sources 12.2) — a trial of the step "The license list of go.yml" on 2026-10-21: with this list, green; without Unlicense and with an extra MPL-2.0, red, with the difference.

### 2.2. The pathspec of the `paths` list

Measured 2026-11-01 (R25, T31):
- **the pathspec of `paths`** — git 2.56.0, a trial in a temporary repository: `git diff --name-only` with `'*.go' ':(exclude)*_test.go'` and the rest of the list of the kind go found `main.go` at the root and `cmd/x/a.go`, without `*_test.go`, `docs/` and `ci.yml`. With `'**/*.go'`, only `cmd/x/a.go`: without the `glob` magic, `*` in a pathspec matches `/` too, and `**/` requires a slash.

### 2.3. The input `same-bits`: the trial #97

Measured 2026-11-08 (the 2026-11-08 amendment to R16, T46):
- **locally**, with the devcontainer's Go 1.27.3 and Node 24.21.0, on a clone of `learner-model` at 50f1b51: the script `targets`, taken out of `go.yml` by yq — six runs, all "ok", 27 s; and with a package whose test requires a 64-bit `uint`, "FAIL" at `GOARCH=386` and exit 1. The script `fma-diff` — "ok" on six targets, 27 s; and with a package `a*b + c`, "the compiler fuses in …/zzfused" on each and exit 1;
- **the trial** — pull request [#97](https://github.com/altnovatrail/.github/pull/97), not merged: `go.yml` by a local path with `same-bits: true` on a trial module. With a package where each product goes through `float64()`, all seven "Go / …" are green, "Go / targets" 1 min 8 s, "Go / fma-diff" 30 s. With a package `a*b + c` and a test of a 64-bit `uint`, "Go / targets" is red at `GOARCH=386`, "Go / fma-diff" names the package on six targets, and the five earlier checks are green;
- **the suite** (R28) — 125 tests, 11 of them new, with a stub of `go`. The step was broken in ten ways — without GOAMD64 v3, without `cpu.all=off`, without `go vet` for wasip1, without "fmahash triggered", without the comparison of the assembler, without a target, without the control, the control without fusion, the job without the condition on the input, `docker run` without `-i` — and each breakage turned the suite red. ShellCheck 0.11.0 and actionlint 1.7.12 — clean;
- **after the review**, `fma-diff` differs from the recipes in three places. The build runs with `-o /dev/null`: without it, `go build` of a main package writes a binary into the checkout and fails if a folder of its name is there — a trial on Go 1.27.3: "build output … already exists and is a directory" without `-o`, the assembler and exit 0 with it, for a main package and for a library. The list of packages is given by `go list` for each target, after `GOOS` and `GOARCH`: build constraints may leave a package out of a target. And a package that does not build turns its target red, but the other packages and targets are still checked. On the clone of `learner-model` the fixed script gives "ok" on six targets. Three more breakages — without `-o /dev/null`, a build that cuts the script short, without the control after the fix — turned the suite red too.

### 2.4. The job `arm64`: the trial #99

Measured 2026-11-08 (the 2026-11-08 amendment to R16, T47):
- **the trial** — pull request [#99](https://github.com/altnovatrail/.github/pull/99), not merged, as #97. With a clean module all eight "Go / …" are green, "Go / arm64" 58 s: the `toolchain` stage was built for aarch64 — the sums of Node, just, Go and buf for arm64 matched — and then `ci-test`, `GODEBUG=cpu.all=off`, js/wasm and wasip1. With a test that fails only when `runtime.GOARCH == "arm64"`, only "Go / arm64" is red, at `ci-test`;
- **the suite** (R28) — 128 tests, 3 of them new. The harness accepts `ubuntu-24.04-arm` too: steps with stubs do not depend on the machine's architecture. Breakages — the job on `ubuntu-24.04`, without the condition on the input, another recipe instead of `ci-test` — each turned the suite red.

### 2.5. The tool of the rules of code: the trials #103 and #104

Measured 2026-11-08 (R33, T48):
- **the module path** `github.com/altnovatrail/.github/tools/coderules` — `go mod init` accepts it, Go 1.27.3, and the coverage profile names the files by this path: "github.com/altnovatrail/.github/tools/coderules/check.go:…". On pull request #103 `codecov/patch` came green, Codecov's default rule matched the paths, and `fixes` are not needed;
- **locally**, Go 1.27.3: the tool on clones of `learner-model` and `engine`, with the lists from their `rules_test.go` and `nested-modules: [".devcontainer/gopls"]` — 0 findings, a second each. With a file that has an import of `os`, `a*b + c` and a goroutine — three findings and exit 1;
- **the tool's Go suite** — `TestControls` over both controls, `TestEveryRuleIsBroken`, `TestTheListsDecide` and `TestTheCodeImportsDecide`, the reading of the lists, `run`, modules that cannot be read, and findings before an error. Coverage — 94.6%. After the review: findings gathered before a type error are printed together with the cause, and a type error on the host is a frequent consequence of a violation of the rule `buildtag`; a cycle of imports is an error, not an endless recursion; `require ()` is an empty block, not a module. Five breakages — without `test-math`, without `requires`, without the check of nested modules, without `nested-modules`, imports of tests in the code — fail the tests;
- **the suite of the steps** (R28) — 135 tests: cases of the job `rules` and of the step "Work out the version" of `self-release.yml`, with a stub of `gh release view`. Breakages — without moving the checkout, without the check of the lists, the tool from `main`, the tool's volume writable, the tool without a release — each fails the suite;
- **actionlint 1.7.12** does not know `job.workflow_repository` and `job.workflow_sha`: "property "workflow_repository" is not defined in object type". GitHub's documentation describes both contexts (sources 2.2). The exception in `.github/actionlint.yaml` covers only these two complaints and only for `go.yml`, as the one of `job.workflow_ref` does for `release.yml`;
- **go-licenses 2.0.1** without an exception: "Did not find license for library 'github.com/altnovatrail/.github/tools/coderules'"; with `--ignore` of the module, exit 0;
- **SonarCloud** on #103 at first held the merge: "new_duplicated_lines_density" 14.1% against a threshold of 3%, and only `control.go` and `control_test.go` of the two controls were duplicated, 96 and 19 lines. With `sonar.cpd.exclusions=tools/coderules/testdata/**`, green;
- **the trial** — pull request [#104](https://github.com/altnovatrail/.github/pull/104), not merged: `go.yml` by a local path with `same-bits` on a trial module with its own `.github/coderules.json`. With code that keeps the rules, all "Go / …" are green, "Go / rules" 31 s, with the tool of the same commit. With code that has an import of `os`, `a*b + math.Exp(c)` and a goroutine, "Go / rules" is red, with exactly four findings: `import`, `fused`, `math`, `goroutine`. On #103, `.github` itself passed "Go / lint", "Go / test", "Go / vuln", "Go / licenses", "Go / coverage", "CodeQL / analyze (go)" — the `go.mod` files of the controls did not hinder Go's autobuild — and `codecov/patch`.

### 2.6. wasip1 in `node:wasi`: the trial #115

Measured 2026-11-13 (R39, T58):
- **locally**, with the devcontainer's Go 1.27.3 and Node v24.21.0 — the `toolchain` stage of CI has Go 1.27.4, whose files that R39 reads are the same (sources 10.1) — on a trial module: the executor of R39 under `go test -exec` — a test that reads `go.mod` from the folder above its package, "ok"; a test that fails on wasip1, "FAIL" and exit 1. The executor run by a line `#!/usr/bin/env node` printed "(node:…) ExperimentalWarning: WASI is an experimental feature and might change at any time" in front of the failure, and with `node --disable-warning=ExperimentalWarning` in `-exec` nothing; a WASI command written by hand, whose `_start` calls `proc_exit(3)`, ends the process with 3 (sources 9.1);
- **on clones** of `learner-model` at 45ae4d6 and `engine` at 7c35596, in a temporary folder: the script of `targets`, taken out of `go.yml` by yq and run as it stands, with a fresh module cache — every run "ok", exit 0. On wasip1 `learner-model` took 10.6 s and `detmath` 0.9 s, `engine` 0.8 s; the whole script 100 s and 52 s. No test fell on the stack. After the review, with `--stack-size=8192`: `learner-model` 4.8 s and 0.5 s, `engine` 0.6 s on wasip1, and the whole script "ok" again;
- **the suite** (R28) — 158 tests, 2 of them new, and the step's cases changed: wasip1 is `go test` with `-exec` on the executor, which lies in a folder of `mktemp -d`, not in the checkout, holds the options of R39, and in the Node of the runner ends with the code of a WASI command's `proc_exit` — 0 and 3 — and prints nothing; a failed test on wasip1 stops the script before `go vet`. After the review the case of a host other than amd64 checks its wasip1 call too. Eight breakages, each in both jobs — `go build` in place of `go test`, without `returnOnExit`, the code of `wasi.start` not handed to the process, the executor in the checkout, without `--disable-warning`, without `--stack-size`, without `preopens`, without `env` — each turned the suite red. In the job Workflows the suite passed on the runner's own Node too. ShellCheck 0.11.0 and actionlint 1.7.12 — clean;
- **the trial** — pull request [#115](https://github.com/altnovatrail/.github/pull/115), not merged: `go.yml` by a local path with `same-bits: true` on a trial module, with `.github/coderules.json` of its own. With a clean module every "Go / …" is green, "Go / targets" 1 min 20 s and "Go / arm64" 1 min 34 s; in both wasip1 ran `go test` on the executor, "ok" — 0.093 s on amd64 and 0.112 s on arm64. With a test that fails only when `runtime.GOOS == "wasip1"`, only "Go / targets" and "Go / arm64" are red, each at wasip1 — "--- FAIL: TestNotOnWasip1", "FAIL trial/trial/wasip1" and exit 1, with no warning of Node — after "ok" on every other target, js/wasm among them, and the other "Go / …" are green;
- **the stack**, found by the review: locally, a test that recurses 100,000 deep, with an array of eight `int64` in each call — on wasip1 on Node's default stack "RangeError: Maximum call stack size exceeded" and "FAIL"; on js/wasm by `go_js_wasm_exec` "ok"; on wasip1 with `--stack-size=8192` "ok". The trial pull request [#116](https://github.com/altnovatrail/.github/pull/116), not merged, with that test and the flag: every "Go / …" green, and on wasip1 "ok" — 0.127 s in "Go / targets" and 0.160 s in "Go / arm64". #115 ran before the flag.

### 2.7. The targets at once: the trial #125

Measured 2026-11-16 (R43, T62):
- **locally**, in the devcontainer, 20 cores, Go 1.27.4 and Node v24.21.0, on a clone of `learner-model` at 26be23c, each run with an empty `GOCACHE`: the script of `fma-diff` of `v0.1.26`, taken out of `go.yml` by yq, 83 s, and the new one, its targets at once, 32 s, both "ok" on the six targets in their order. The script of the targets with one target in `TARGETS`: `amd64-v3` 16 s, `cpu-off` 17 s, `386` 19 s, `js-wasm` 22 s, `wasip1` 23 s, each exit 0; with all five, one after another, 86 s; with an empty `TARGETS`, "targets: TARGETS names no target" and exit 1. ShellCheck 0.11.0 over both scripts as the container gets them — clean;
- **the suite** (R28) — 177 tests, 172 before: the shape of the matrix and of the gate; the gate red on `failure`, `cancelled`, `skipped` and an empty result; each target of the matrix with its own calls of `go`; `arm64` with `cpu-off js-wasm wasip1`; `amd64-v3` and `386` refused on an arm64 host; no target and an unknown one; the first target that fails stops the script; `fma-diff` with its targets at once, by `stub/go.waits`, its output whole and in the order of the targets, and a target that stops while the others are checked. The calls of the stand-in `go` from six processes at once are numbered under `flock`. Breakages, each red: the targets of `fma-diff` one after another, the status of `wait` ignored, the files printed in another order, the gate with `!cancelled()`, the gate green on anything but `failure`, a target out of the matrix, `wasip1` out of `arm64`'s `TARGETS`, no check of the host, one key of the Go caches for every target, `fail-fast: true`, `TARGETS` not handed to the container. actionlint 1.7.12 with ShellCheck 0.11.0 — clean;
- **the trial** — pull request [#125](https://github.com/altnovatrail/.github/pull/125), never merged: `go.yml` by a local path with `same-bits: true` on the trial module of #120. The run 43826697395, with the entry of the image of `main` and a miss of every Go cache, the keys of the targets being new: all green; the five jobs "Go / target …" started 07:51:12–07:51:47, the last of them waiting for a runner, and "Go / targets" ended at 07:52:39, its step 2 s. In each job of the matrix "Toolchain image" took 13–31 s and "Tests on the targets" 5–10 s; `fma-diff`'s step 17 s, `arm64`'s targets 17 s. On a module this small the matrix is not faster than `targets` was — 64 s cold and 37 s warm in #120 —: the load of the image is most of each job. In the CI run of the same commit, `go.yml` without `same-bits`, "Go / targets", `Go / target ${{ matrix.target }}` and the other jobs of the input are skipped, as before;
- **the trial with breakages** — the run 43827084005, with a package `trial/bits` whose test needs a 64-bit `uint` and whose `MulAdd` is `a*b + c`: only "Go / target 386" of the matrix red — "--- FAIL: TestSize", "FAIL trial/trial/bits" —, the four others green, "Go / target amd64-v3" ending last and green; "Go / targets" red, "##[error]The targets are failure, not success". So the result of the matrix in `needs` is `failure` when one of its jobs fails, and not the result of the job that ended last. "Go / fma-diff" red, its six blocks "fma-diff: <target>: the compiler fuses in trial/trial/bits", each with its diff under it, in the order of the targets; "Go / rules" red by the same product. No entry of the cache was saved (`gh api …/actions/caches?ref=refs/pull/125/merge`, `total_count` 0).

## 3. The TypeScript wrapper

### 3.1. The trials #40 and #42

Measured 2026-10-21 (R19):
- **the trial pull request #40**, not merged, runs 39660777454 and 39661168027. `self-typescript-trial.yml` called `typescript.yml` by a local path on a package at the root: TypeScript 7.0.2, Vitest 5.0.5 with `@vitest/browser-playwright` 5.0.5 and Playwright 1.64.1; a lock file of version 3, 100 packages, built by npm 11.19.0. The `toolchain` stage — with `/ms-playwright` from Playwright's image (sources 9.2) and 24 `apt` packages: 21 libraries of Chromium and `libfontconfig1`, `libfreetype6`, `fonts-liberation`. The result:
  - "TypeScript / lint", "/ test", "/ vuln" and "/ licenses" are green. `tsc --noEmit` passed. In Node 1 test passed, in "browser (chromium)" 1 test: a drawing on `<canvas>` was read pixel by pixel. `npm audit` answered "found 0 vulnerabilities", the license check "100 packages, 0 refused", with an exception for `lightningcss` and its 11 builds for platforms — MPL-2.0, dev;
  - without the exception "TypeScript / licenses" is red — "100 packages, 12 refused" — and the other three are green;
  - the step "Toolchain image" with the browsers took 49–52 seconds in each of the four jobs. Without the browsers the same step takes 21 seconds: the job "Documents", the CI run 39649619270 on `main`;
  - "Documents / docs-check-repo" passed on the stage with the browsers too;
- **the trial #42**, not merged, run 39664766549: the commits of #40 from `refs/pull/40/head` and the wrapper after the review, where only the job `test` has `--ipc=host`. All four "TypeScript / …" are green, the test passed in headless Chromium, and the stage with the browsers was built in 46–56 seconds per job. The job "Workflows", the CI run 39664737696, found both copies of the list equal to the list of `spec`.

### 3.2. The step "Toolchain image" in `canvas`

Measured 2026-10-21 (the amendment to R19):
- **the cost** — the CI run 39690774485, pull request #18 of `canvas`, commit 5d118a4 (the GitHub API). The step "Toolchain image" — 57 seconds in "TypeScript / test" and "/ vuln", 59 in "/ lint", 61 in "Documents / docs-check-repo" and 67 in "/ licenses". Without the browser the same step takes 18 seconds, in Documents on `main` of `canvas` at 7756744 (R13 canvas).

### 3.3. The license recipes of `spec`: the trial #58

Measured 2026-10-22 (R22, the amendments to R16 and R19, T26):
- **the recipe's code on the lock file of the trial #40**, 100 packages. With the one exception `lightningcss`, `main.mjs` v0.2.17 answers "11 problems", and v0.2.18 "ok — 100 packages, 1 exceptions". Without the exception both answer "12 problems";
- **the trial #58**, not merged: the branch of T26 and the package of #40 from `refs/pull/40/head`, where `ci-licenses` is `just -f spec/justfile licenses-check-repo package-lock.json licenses.json`, and `licenses.json` holds the one exception `lightningcss`.
  - Runs 39724151192 and 39724151255 — all green. In the job `licenses` the checkout ran `git submodule update --init --force --depth=1`, and the recipe answered "licenses-check: package-lock.json: ok — 100 packages, 1 exceptions". In the jobs `lint`, `test` and `vuln`, `test ! -e spec/justfile` passed. "Workflows": "go.yml allows the 10 licenses spec allows." and "typescript.yml allows the 10 licenses spec allows.", and the step "Toolchain image" with the trial's stage, with the browsers, took 47 seconds;
  - 39724390663, `licenses.json` empty: "licenses-check: package-lock.json: 12 problems", the first "lightningcss@1.33.0: MPL-2.0 is not on the allowed list";
  - 39724578660, a lock file of version 1: "the lock file has no packages, lockfileVersion 1: a lock file of npm 7 or later is read, one of npm 5 or 6 is refused";
  - 39724757498, a copy of the lock file where `lightningcss` is not `dev`: "lightningcss@1.33.0: the exception takes MPL-2.0 for a tool of development, and the lock file does not mark this package dev", 12 refusals in all;
  - 39725131862, `ALLOWED_LICENSES` of `typescript.yml` lacks `0BSD`: "ALLOWED_LICENSES in typescript.yml is not the list spec's licenses-allowed prints.", and the difference shows "< 0BSD". "TypeScript / licenses" in the run 39725131895 is green meanwhile: "ok — 100 packages, 1 exceptions";
- **locally** — the step "The license lists of go.yml and typescript.yml", taken out of the file word for word, with a stub for docker that runs the command in the folder mounted at `/work`. Equal copies — green. A copy that diverged, and a copy without the line `ALLOWED_LICENSES` — red with the file's name. An empty output of the recipe, a line that is not an identifier, and a failed recipe — red too.

### 3.4. Without a copy of the list: the trial #65

Measured 2026-10-22 (the amendment to R19, T29):
- **the trial #65**, not merged: the branch of T29 and the package of the trial #58 from 9027580, and each `ci-*` begins with `test -z "${ALLOWED_LICENSES+x}"`. Runs 39817202719 and 39817202674 — all green. `docker run` in all four jobs is with `--env HOME=/tmp --env CI`, and the check of the variable passed in each. `ci-licenses` answered "licenses-check: package-lock.json: ok — 100 packages, 1 exceptions", and `lint`, `test` and `vuln` passed `test ! -e spec/justfile` too. "Workflows" compared one copy: "go.yml allows the 10 licenses spec allows.";
- **locally** — the step "The license lists of the workflows", taken out of the file word for word, with a stub for docker as in T26, seven cases:
  - as it is — green, and only `go.yml` is compared;
  - a copy in `go.yml` that diverged, and `go.yml` without the line — red, with the name `go.yml`;
  - one more workflow with a copy that diverged, and the same kind of copy written into `typescript.yml` again — red, with the file's name;
  - an empty output of the recipe and a failed recipe — red.

  The trial's recipe `ci-licenses`, with `ALLOWED_LICENSES` in the environment, stops at the check of the variable, and without it passes.

## 4. The upload of coverage

### 4.1. The trial #80

Measured 2026-11-01 (the 2026-11-01 amendments to R16 and R19, T34):
- **permissions in a reusable workflow** (sources 2.1) — the trial #80 showed that the run does not start at all: `startup_failure`, not a single job. The job "TypeScript" of the same workflow, which had the permission, did not run either. The cause is on the page of the run 41345286177: "The nested job 'coverage' is requesting 'id-token: write', but is only allowed 'id-token: none'.";
- **a Go package without tests** (sources 10.1) — in the trial the package `untested`, without tests, went into the profile with zero;
- **paths in Codecov** — the trial confirmed the default rule for Go import paths (sources 10.3): that is how `sum.go` and `untested/untested.go` landed, below, in "the trial #80";
- **the trial #80** — a pull request not merged, closed 2026-11-01:
  - b5cf941 — a Go module `github.com/altnovatrail/trial` and a TypeScript package from the commits of #65, without a browser, at the root. One `justfile` for both wrappers and `self-coverage-trial.yml`, which calls them by a local path with `id-token: write`. Run 41345104353: all checks green, and the jobs `coverage` took 7–8 seconds each. Both uploads got an OIDC token — "Upload queued for processing complete". `codecov/patch` came from the Codecov app, `app id` 254, as a success — "No report found to compare against": `main` of `.github` has no report. Codecov combined both reports into one, of 4 files: `sum.go` and `untested/untested.go` from the import paths, `trial/sum.ts` and `trial/untested.ts` from lcov, and the uncovered ones with zero (the Codecov API);
  - b3ca2c8 — the job "Go" without `id-token: write`: `startup_failure`, above;
  - 309a6ff — `ci-test` without a Go profile. "Go / test" is red: "No files were found with the provided path: coverage/go.out. No artifacts will be uploaded." "Go / coverage" was skipped, and the TypeScript side uploaded by its own path.

## 5. The shared release

### 5.1. Calling just's recipes

Measured 2026-10-20 (R14):
- **`just --dry-run`** (sources 11.4) — a trial on 2026-10-20 on `spec/justfile` v0.2.11: a call of `release-refusal` with three arguments exits with 0 and runs nothing. The same call to a copy of the justfile where the recipe is named otherwise or expects four parameters exits with 1: "justfile does not contain recipe `release-refusal`" and "recipe `release-refusal` got 3 positional arguments but takes 4". The step of the number of `self-release.yml`, taken out word for word and run with these copies, answers the same.

Measured 2026-11-02 (the 2026-11-02 amendment to R18, T41):
- **just** 1.58.0, the recipe `release-files version previous:`: `just release-files v0.1.9 ""` — "version=[v0.1.9] previous=[]"; `just release-files v0.1.9` — "error: recipe `release-files` got 1 positional argument but takes 2". The recipe `release-files version:` on `just release-files v0.1.9 ""` — "error: justfile does not contain recipe ``", and on `just release-files v0.1.9 /previous/module-index.json` — "error: justfile does not contain recipe `/previous/module-index.json`".

### 5.2. The trial #33 and the first release of `module-kit`

Measured 2026-10-21 (R18):
- **the trial pull request #33**, not merged, run 39618440702. `self-release-trial.yml` called the shared `release.yml` with `publish: false`: the number `v0.1.4`; the files `SHA256SUMS` and a trial program for linux amd64 and arm64, built in the `toolchain` stage; all three bundles "Verified OK"; no release. The certificate:
  - SAN and Build Signer URI (1.3.6.1.4.1.57264.1.9) — `https://github.com/altnovatrail/.github/.github/workflows/release.yml@refs/pull/33/merge`;
  - Build Config URI (1.18) — `…/.github/workflows/self-release-trial.yml@refs/pull/33/merge`, that is, the caller's workflow;
  - Source Repository URI (1.12) — `https://github.com/altnovatrail/.github`;
  - Build Signer Digest (1.10), Source Repository Digest (1.13) and Build Config Digest (1.19) — the run's commit, `GITHUB_SHA`;
  - Build Trigger (1.20) — `pull_request`.

  For a run by `workflow_run`, `GITHUB_SHA` is the tip of the default branch (sources 2.2, "the `workflow_run` context"), and Source Repository Digest would name it, not the release's commit, if the release were an older commit. So `release.yml` signs only a `TARGET` equal to `GITHUB_SHA`, and `verify-blob` checks this by the flag `--certificate-github-workflow-sha`.
- **the first release of `module-kit`**, `v0.1.0`, run 39636884292, commit 7e0144a. Its `release.yml` calls the shared one by the SHA of `v0.1.4`. Nine files, each with its own bundle; `cosign verify-blob` 3.1.4 — "Verified OK" for all, `gh release verify` and `verify-asset` pass. The certificate of the bundle of `SHA256SUMS`:
  - SAN and Build Signer URI (1.9) — `https://github.com/altnovatrail/.github/.github/workflows/release.yml@11435dbe61d3d4885c9a8dd30686e8111e26cabb`, that is, the shared workflow by the SHA of a release of `.github`;
  - Build Signer Digest (1.10) — 11435db, a commit of `.github`;
  - Source Repository URI (1.12) — `https://github.com/altnovatrail/module-kit`;
  - Source Repository Digest (1.13) and Build Config Digest (1.19) — 7e0144a, the tag's commit;
  - Build Config URI (1.18) — `https://github.com/altnovatrail/module-kit/.github/workflows/release.yml@refs/heads/main`;
  - Build Trigger (1.20) — `workflow_run`; Run Invocation URI (1.21) — `https://github.com/altnovatrail/module-kit/actions/runs/39636884292/attempts/1`.

### 5.3. The script of `spec` in the releases: the trials #49 and #50

Measured 2026-10-22 (the amendments to R10 and R18, T25):
- **the trial #49**, not merged, runs 39703233909, 39703354477 and 39703423312. `self-release-trial.yml` called the shared `release.yml` of T25 by a local path with `publish: false`, and a `justfile` at the root gave a `release-files` that writes one file:
  - 39703233909: the script built `novatrail-toolchain`; "version=v0.1.6", "previous=v0.1.5", "releasing v0.1.6 at 9b068dd…"; the file was built in its own `release-toolchain`, its bundle "Verified OK"; the publishing and the verification of the release were skipped;
  - 39703354477, the submodule at v0.2.16: "The spec submodule, pinned at ead6aea85be4, has no executable tools/toolchain/toolchain.sh" — before the stage was built;
  - 39703423312, the trial with two arguments: "error: recipe `release-refusal` got 2 positional arguments but takes 3", then the trial's message;
  - the trial created no release and no tag `v0.1.6` (`gh release list`, `git ls-remote --tags`);
- **the trial #50**, not merged, after the review of T25: the shared `release.yml` with the check of the submodule and the check of the script's sum.
  - Run 39704897047: the checks of the submodule passed on the runner — so the tags of `spec` are visible in its clone of the submodule. The number is `v0.1.6`, the file is signed, its bundle "Verified OK", no release;
  - 39704997453, the submodule at 49c708c, where the script is there but no tag: "The spec submodule is pinned at 49c708ca1a8c, which is no tag of spec", before the build;
  - 39705031751, the submodule at v0.2.16: "spec v0.2.16 has no executable tools/toolchain/toolchain.sh", before the build;
  - 39705086745, the script appended to after the trial, as a container could do: "spec/tools/toolchain/toolchain.sh changed while the release ran", before `release-version`.

  The trial on the runner did not test the check of the URL in `.gitmodules`: with a foreign URL the checkout would have failed before it. It was tested locally, on a copy with the submodule, together with three other refusals.

### 5.4. The copy of the checkout: the trial #54

Measured 2026-10-22 (the amendments to R10 and R18, T28):
- **the post step of `actions/checkout`** (sources 2.7) — in the log of the trial #54, after the job stands "git submodule foreach --recursive sh -c "git config --local --name-only --get-regexp 'core\.sshCommand' && …";
- **the submodule in the runner's checkout** — run 39713588141 of the trial #54, git 2.55.0. `spec/.git` is "gitdir: ../.git/modules/spec", the submodule's `core.worktree` is "../../../spec", and the folder `.git/objects/info` is empty, that is, there are no `alternates`. The copy's `spec` leads into its own `.git`: "/home/runner/work/_temp/checkout/.git/modules/spec";
- **the trial #54**, not merged: `self-release-trial.yml` and `justfile` as in #49, and the shared `release.yml` of T28.
  - 39713033296: "version=v0.1.7", "previous=v0.1.6", "releasing v0.1.7 at bab5bbb…". The file was built, its bundle "Verified OK"; the publishing and the verification of the release were skipped;
  - 39713181646: after `release-version`, the script's container appended the line `[core` to the copy's `.git/config` and deleted its objects, and its `git rev-parse HEAD` answered "fatal: bad config line 14 in file .git/config". The run went on: "releasing v0.1.7 at d3c3c0c…", a tree from `git archive`, "Verified OK". The checkout is "14M" by `du -sh`, and its copy takes "real 0m0.013s";
  - 39713312237: a container appended a line to the copy's script after the trial, and the run stopped before `release-version`: "spec/tools/toolchain/toolchain.sh changed in the copy of the checkout while the release ran";
  - 39713588141 — the submodule, as above; the number, the build and the verification as in the first run;
  - the trial created no release and no tag `v0.1.7` (`gh release list`, `git ls-remote --tags`);
- **locally** — the steps of the number and of the publishing of both releases, taken out of the files word for word. docker is replaced by a stub: the command runs in the folder that is mounted at `/work`. `gh` is replaced too.
  - No container got the checkout itself;
  - corrupting the copy's `.git` after `release-version` does not change the result, and a script changed in the copy after the trial stops the step;
  - after a 404 refusal to a commit that is no longer the tip, `release-refusal` in a new copy sees the new tip, and in a copy taken before `git fetch`, "fatal: Needed a single revision". A refusal to the tip and a 422 refusal fail the step;
  - the step of the number of `main` before T28 fails under the same corruption: "fatal: bad config line 15 in file .git/config", then "git diff could not compare".

### 5.5. Publishing to npm: the trial #61

Measured 2026-10-22 (the amendment to R18, T27):
- **the output of `npm publish --dry-run --json`** (sources 8.2) — an object keyed by the package's name, with `filename` and `integrity` (checked on 11.19.1);
- **the trial #61**, not merged: `self-release-trial.yml` called the shared `release.yml` of T27 by a local path with `publish: false` and `npm-package: "@altnovatrail/release-trial"`. `release-files` at the root does `npm version` and `npm pack`.
  - 39809838271 — the positive run. "releasing v0.1.9 at d5c7ffd…"; "@altnovatrail/release-trial is not in the npm registry yet, which matters not with publish false"; "@altnovatrail/release-trial@0.1.9: sha512-4XiS…, publish". npm's dry run read the same archive, the signature "Verified OK", and "Publish to npm" was skipped. The log has no line about the OIDC exchange: without the variables it is skipped at the level silly. Node and npm downloaded in 2 seconds, the check took a second;
  - 39809875797, without `npm-package`: the npm steps are skipped, and the release runs as before;
  - 39809901530, no archive: "The release's files hold no altnovatrail-release-trial-missing-0.1.9.tgz …";
  - 39809926354, the archive holds version 0.0.0: "… holds @altnovatrail/release-trial@0.0.0, not @altnovatrail/release-trial@0.1.9 …";
  - 39809954130, a name without a scope: "npm-package is "release-trial", which is no package of the @altnovatrail scope …" — by the first step, before the number;
  - 39809980143, a foreign repository: "… names its repository as "https://github.com/altnovatrail/canvas" …";
  - 39810006148 and 39810040394, `publishConfig` and `private`: "… is private, or has a publishConfig or a tag of its own …";
  - after the review the step was rewritten: `npm-isolated` is one script, the packument is fetched with `?write=true`, the files of the check lie apart from npm's folder. The trial was repeated on it. 39812944031 — the positive run: "v24.22.1", "npm 11.19.1", npm runs with `--prefix /home/runner/work/_temp/npm`, "@altnovatrail/release-trial@0.1.9: sha512-ZUTE…, publish", "Verified OK". 39813134293 — no archive: "The release's files hold no altnovatrail-release-trial-missing-0.1.9.tgz …";
  - in all the negative runs it came to neither the signing nor the release. There is no release and no tag `v0.1.9` (`gh release list`, `git ls-remote --tags`), and the registry answers 404 for `@altnovatrail/release-trial`;
- **locally** — the steps, taken out of the file word for word. The check ran with a real npm 11.19.1, and the registry, `gh`, cosign and the publishing itself were replaced by stubs. The cases passed:
  - **the check:** no package, with `publish` true and false; the version exists with the same bytes and with other bytes; a version below the highest — the tag `previous`; deprecated versions and prereleases do not count; the registry answers 500; `publishConfig`, `tag`, `private`, entries outside `package/`, a foreign name, the version, `repository` as a string, and a foreign repository;
  - **the trial's environment:** npm's dry run has no OIDC variables, no `npm_config_*` and no `NODE_OPTIONS`. npm runs in an empty folder, and the files of the check lie apart. A packument without `versions` does not fail the step;
  - **the rerun:** the archive and the bundle from the release, a refusal of `verify-asset` and of cosign;
  - **the publishing:** the version is already there; it came out; exit 0 without the version — "probably staged"; a refusal without the version — with the setting that is needed, after three attempts, and exit 0 without the version — after thirty; a refusal, but the version is there — a warning; another `integrity`; no provenance; the tag `previous`; an archive not from `registry.npmjs.org`.

### 5.6. An unpublished version number in the npm step

Measured 2026-11-01 (the 2026-11-01 amendment to R18, T33):
- **the local run** — 63 tests, all `ok`. shellcheck 0.11.0 over `tests/` and actionlint 1.7.12 over all workflows — clean. The step was broken in ten ways, and each breakage turned the suite red with its own cases:
  - no check of `time`;
  - the messages before the release and after it swapped;
  - the number is looked up in `versions`, not in `time`;
  - no branch for a package unpublished whole;
  - this branch comes before the check of the number;
  - it is always read as a trial;
  - the step has no `RELEASED`;
  - a package unpublished whole is recognized without empty `versions`;
  - a version without `integrity` counts as unpublished;
  - the message about an old number of such a package says nothing of the package;
- **against the real registry** — the step's script, taken out of the file word for word by yq and jq, in `bash --noprofile --norc -eo pipefail`, with a real curl 8.5.0, without a token. The archives are synthetic, `npm-isolated` is replaced by a stub:
  - `ua-parser-js` 0.7.29 — "… was in the npm registry and was unpublished …" and "raise RELEASE_LINE …". With `RELEASED` — "The next release, with a new number, publishes the package";
  - `ua-parser-js` 0.7.28 — "… is in the npm registry with the integrity sha512-6Gurc1n…", with the same request about `RELEASE_LINE`;
  - `asdasd` 1.0.0 with `publish: false` — an unpublished version number, and after it, that the package is unpublished whole;
  - `asdasd` 2.0.0 — "… was unpublished from the npm registry as a whole …" with `publish: true`, and with `false`, a notice and a trial run, `action=publish`;
  - `@altnovatrail/spec` 0.4.2 — `--tag previous`. 0.5.5 at 19:05 UTC — `publish` without a tag, and at 19:12 another `integrity`: at 19:06:53 `spec` released 0.5.5 itself. 0.9.0 at the same time — `publish` without a tag;
- **on the runner** — run 41340770056, pull request #78: "63 tests, 0 failed". The step "Test the workflows" took 10 seconds, the job "Workflows" 43. SonarCloud on #78 — 0 findings.

### 5.7. The signature on a rerun of the shared release

Measured 2026-11-02 (the 2026-11-02 amendment to R18, T39):
- **the step of the rerun**, taken out word for word (yq from `release.yml`), was run here, without docker. A stub for `docker` ran the command of `toolchain.sh` in the folder that the script mounts at `/work`: the devcontainer's just 1.58.0, Node 24.21.0 and git 2.56.0 — the Node the same as in the `toolchain` stage. `gh` 2.101.0 was real and only read the release `tutor` v0.1.0 — `release download` and `release verify-asset`. As the package's archive went `SHA256SUMS` of this release, under the name `x-0.1.0.tgz`: the certificate does not name the file's name.
  - With its bundle: the attestation — "Verification succeeded! x-0.1.0.tgz is present in release v0.1.0", the recipe — "x-0.1.0.tgz: tutor v0.1.0, signed by the shared release.yml of .github v0.1.11", exit 0.
  - With the bundle of `tutor_v0.1.0_source.tar.gz`: "release-verify: the signature does not hold for the file: signature verification failed", then the step's message, exit 1.
  - In both cases `GH_TOKEN` did not reach the stub for `docker`;
- **the trial**, taken out the same way. On the submodule at v0.6.2 the dry run printed the recipe with `_tools` and ran nothing, exit 0. On a copy of `spec` v0.5.3 — "error: justfile does not contain recipe `release-verify`", then the step's message, exit 1;
- **the suite** (R28) — 83 tests, 12 of them new, with yq 4.54.1, ShellCheck 0.11.0 and actionlint 1.7.12 by the versions and sums of `self-ci.yml`. The steps were broken in thirteen ways — without `env -u GH_TOKEN`, the recipe or the trial in the checkout itself, the trial not a dry run, a refusal of the recipe or of the trial skipped, the full name of the repository to the recipe, without the check of the file's name or with any branch, a SHA of any form or of seven characters, the former condition of cosign, without the attestation — and each breakage turned the suite red. After the review, in four more: the whole copy of the checkout in the trial or in the rerun, any owner or any file in the pinning — and the suite was red too, and the live runs above were repeated on the fixed file.

### 5.8. `release-verify` on a file of the release `tutor` v0.1.0

Measured 2026-11-02 (R30, T38):
- **the recipe on a real file** (2026-11-02) — `just -f spec/justfile release-verify tutor v0.1.0 SHA256SUMS`, with the file and the bundle from the release `tutor` v0.1.0: "SHA256SUMS: tutor v0.1.0, signed by the shared release.yml of .github v0.1.11". `tutor` calls the shared `release.yml` by the SHA of v0.1.11, c1b8487 (the GitHub API).

Measured 2026-11-02 (R31, T40):
- **the recipe on a real file** (2026-11-02) — `just -f spec/justfile release-verify tutor v0.1.0 SHA256SUMS` from the submodule at v0.6.3, with the file and the bundle from the release `tutor` v0.1.0: "SHA256SUMS: tutor v0.1.0, signed by the shared release.yml of .github v0.1.11".

Measured 2026-11-08 (R32, T43):
- **the recipe on a real file** (T43) — `just -f spec/justfile release-verify tutor v0.1.0 SHA256SUMS` from the submodule at v0.9.8, with the file and the bundle from the release `tutor` v0.1.0 — "SHA256SUMS: tutor v0.1.0, signed by the shared release.yml of .github v0.1.11".

### 5.9. The previous release's file

Measured 2026-11-02 (the 2026-11-02 amendment to R18, T41):
- **the step**, taken out word for word (yq from `release.yml`), was run here the same way as the step of the rerun in T39: a stub for `docker` ran the command of `toolchain.sh` in the folder that the script mounts at `/work`, and `gh` 2.101.0 was real. The input is `SHA256SUMS`, the previous release `tutor` v0.1.0.
  - With its bundle: the attestation — "Verification succeeded! SHA256SUMS is present in release v0.1.0", the recipe — "SHA256SUMS: tutor v0.1.0, signed by the shared release.yml of .github v0.1.11", exit 0, the step's output `handed=file`, and one `SHA256SUMS` landed in `previous/`.
  - With the bundle of `tutor_v0.1.0_source.tar.gz`: "release-verify: the signature does not hold for the file: signature verification failed", then the step's message, exit 1, neither the output `handed` nor the folder `previous/`.
  - The branch of the first release: on the submodule at v0.6.3 the dry run printed the recipe with the path that the next release would give, then a notice, exit 0 and `handed=none`; on the tree of `spec` v0.5.3 — "error: justfile does not contain recipe `release-verify`", then the step's message, exit 1.
  - In all runs `GH_TOKEN` did not reach the stub for `docker`. The first run of the branch of the first release showed that the dry run went with the token: `toolchain.sh` does not pass it to the container, but the script, as on the rerun path, now starts without it, and a case of the suite holds this;
- **the suite** (R28) — 98 tests, 15 of them new, with yq 4.54.1, ShellCheck 0.11.0 and actionlint 1.7.12 by the versions and sums of `self-ci.yml`. The steps were broken in twenty ways, and each breakage turned the suite red:
  - without `env -u GH_TOKEN` for the recipe or for the dry run; the whole copy of the checkout; a refusal of the recipe skipped; without the attestation; the file handed over before the check; the bundle not required;
  - the tag is the number of the new release; without the dry run for the first release, or with the runner's path in it;
  - `/` or `.sigstore.json` in the name;
  - without `:ro`; the mount for the first release too; without the empty argument; the runner's path instead of `/previous/`; without the guard of the chain;
  - without `handed=file` or `handed=none`; a build that runs without `handed`.

### 5.10. The number of a package unpublished whole

Measured 2026-11-02 (the 2026-11-02 amendment to R18, T42):
- **the suite** (R28) — 98 tests. The fixture `tombstone()` is as the registry answers, with the keys of the numbers in `time`, and `tombstone_without_its_time()` is a number without a key, which the registry has not shown. Breakages: without `unpublished.versions`, 1 red case; without the keys of `time`, 4.

### 5.11. Waiting for the registry in the npm step

Measured 2026-11-08 (the 2026-11-08 amendment to R18, T44):
- **the job's duration** — the longest job of the shared release among the last 12 successful runs of `release.yml` of each caller, the trials on pull requests too, the GitHub API: `module-kit` 285 s, `modules` 81 s, `canvas` 333 s, `tutor` 77 s. The step "Publish to npm" in `canvas` (run 41395016624) — 05:38:39–05:39:45 UTC 2026-11-02. With 20 minutes of waiting and three for the round under way, that is about 29 minutes, and `timeout-minutes` is 45 instead of 30;
- **the suite** (R28) — 114 tests, 16 of them new; the step "Publish to npm" had none before. The stub of `curl` answers each address with its own queue of answers, and `sleep` is a stub that only records the call. The step was broken in seven ways — the archive without waiting, 30 rounds instead of 120, without `--max-time` for the document or for the archive, without the three rounds after npm's refusal, three rounds even after the document showed the version, the former `timeout-minutes` — and each breakage turned the suite red. The cases do not test the deadline by `SECONDS`: the stub does not move the clock, and in the suite the bound of 120 ends the rounds. So the suite compares the line of the deadline and the line of the exit by it with the step word for word. After the review the suite gained a case of the tag `previous` and a check that `npm-isolated` gets the OIDC variables. Four more breakages — the deadline reversed or removed, the OIDC variables removed before `npm publish`, the tag not passed — turned the suite red too. The whole suite runs 23–27 s. ShellCheck 0.11.0 and actionlint 1.7.12 by the sums of `self-ci.yml` — clean.

## 6. The suite of tests of the steps

### 6.1. The basis of the suite

Measured 2026-11-01 (R28, T35):
- **how yq turns YAML into JSON** — a trial on v4.54.1. The key `on` and the value `on` stay strings. `0.10` and `010` are numbers, `true` a boolean, an empty value `null`. A block `|` is a string byte for byte, with one newline at the end.
- **curl, jq and tar on a bad answer** — the devcontainer's tools:
  - curl 8.5.0 without `-f`: on the registry's 404 it writes the body to `-o`, prints `404` and exits with 0. If it cannot connect, it prints `000` and exits with 7;
  - jq 1.7 on a text that is not JSON — "jq: parse error", exit 5;
  - GNU tar 1.35 on a file that is not gzip — exit 2.
- **the local run** — 53 tests, all `ok`, in 9 seconds; shellcheck 0.11.0 over `tests/` and actionlint 1.7.12 over all workflows — clean. Of 21 breakages of the steps, each turned the run red (R28).
- **on the runner** — run 41337182817, pull request #77: "53 tests, 0 failed". The step "Test the workflows" took 11 seconds, the job "Workflows" 42, and the runner's `id -u` and `id -g` are 1001. Run 41337180022, the trial #76, not merged: with `--ipc=host` on all jobs of `typescript.yml` — "53 tests, 1 failed". `test_typescript_runs_each_recipe_with_ci_and_the_test_job_alone_with_the_hosts_ipc` failed, and the next steps of the job were skipped.

### 6.2. `documents.yml` by the script of `spec`

Measured 2026-11-08 (the 2026-11-08 amendment to R08):
- **the suite** (R28) — 140 tests, 5 of them new: the real script of `.github`'s submodule with a stub of `docker`. Without the check that the script is executable — the suite is red.

## 7. The cache of the image of the `toolchain` stage

### 7.1. `go.yml` and `typescript.yml`

Measured 2026-11-09 (R36, T52):
- **the measurement** — the step "Toolchain image" before the cache: in the run of `self-ci.yml` 42500504949 on `main` on 2026-11-08, the jobs "Go / lint", "Go / test", "Go / vuln" and "Go / licenses" — 20–26 s; in `canvas`, in the CI run 42704340930 on `main` on 2026-11-09, the four jobs of `typescript.yml` — 60–76 s. With the cache, the draft pull request #109, the run of `self-ci.yml` 42715578341: on a miss, the build with `docker save` — 36–46 s, and one job of four saved the cache entry, three got "Failed to save: Unable to reserve cache with key …, another job may be creating this cache", and the jobs are green; on a hit, by a re-run attempt, the restore of a cache entry of ~383 MB in 4–7 s and `docker load` in 20–29 s, without `docker build`;
- **the suite** (R28) — the step's cases: no file; the file loaded and gave the image `toolchain`; the file did not load; it loaded, but without the image `toolchain`; it did not load, and the build failed; the build failed; `docker save` failed. A check by the text holds the three steps the same in six jobs, and `release.yml` and `self-release.yml` without `actions/cache`. Breakages — without deleting a corrupt file, saving without the condition of a miss, without `docker save`, without deleting a half-written file, without checking the image, `docker save` after a file from the cache — each turned the suite red.

### 7.2. `documents.yml`

Measured 2026-11-10 (the 2026-11-10 amendment to R36, T53):
- **the suite** (R28) — the cases of the step "Toolchain image" on the real script of the submodule: a miss, a hit, the file did not load, a file with another image, the build failed, a script of the former shape without the variable, no script, the script not executable; a check by the text — the cache steps of `documents.yml` and of the job "Workflows" of `self-ci.yml` are the same as those of `go.yml`, but for the path, and the variable names the same file. Breakages — without the variable, saving without the condition of a miss, another path in the variable, the build and the check in one step — each turned the suite red;
- **live** — pull request 109, the run of `self-ci.yml` 42732255328: on a miss "Documents / docs-check-repo" saved the cache entry `novatrail-toolchain.tar`, ~383 MB, and "Workflows" got "Unable to reserve cache", and both are green; the build took 30 s in one and 2 min 51 s in the other, where the step `RUN` with the downloads ran 143 s. On a re-run attempt both got "Cache restored from key" in 5–6 s and `docker load` in 28–31 s, without a build. A new run of the same pull request found the cache entry `toolchain.tar` of `go.yml` too.

### 7.3. One file and the job `toolchain`: the trial #123

Measured 2026-11-16 (R42, T61):
- **before** — the cache of `.github` on 2026-11-16: 14 entries of the image, 5 621 MB, 8 of them of pull requests, of 18 entries and 5 790 MB in all (`gh api repos/altnovatrail/.github/actions/caches` and `…/actions/cache/usage`). Each key of `main` has two entries, of 409 050 179 B and 408 703 077 B: the files `novatrail-toolchain.tar` of `documents.yml` and "Workflows" and `toolchain.tar` of `go.yml`;
- **the suite** (R28) — 172 tests: the step "Toolchain image" on a miss of the job `toolchain`, which writes the file, and with a save that fails; with a file, loaded without a build; without a file in a job after `toolchain`, a build and no file; a file that does not load, and one without the image `novatrail-toolchain`; the build that fails, with a file that did not load too; `arm64` writing the file with `SAVE` `true` alone, and none after a file of the cache that did not load. By the text: the steps and outputs of the job `toolchain` in both files; `needs`, `!cancelled()` and the three steps of every job after it, which save no image; `arm64` on its own with the save of `main`; one script and one SHA of `actions/cache` in the eight jobs that build the stage, every container in the image `novatrail-toolchain`, no path but `novatrail-toolchain.tar`; `documents.yml` and "Workflows" with the restore and the save of `arm64`, one script, and on a miss of a run that saves nothing a build without a file. Nineteen breakages each turned the suite red — no `lookup-only`; `check` of either file without `!cancelled()`; `rules` without `needs`; `SAVE` `true` after `toolchain`; `docker save` without `SAVE`; no `overwrite`; no `compression-level`; the download by name; the save of `arm64` or of `documents.yml` without `main`; the save of the job `toolchain` without the build's outcome; the download into another path; a container of the image `toolchain`, of `ci-` or of the targets; "Workflows" or `documents.yml` handing the variable on every run; after the review, the job `toolchain` without its sparse checkout, and "Workflows" whose build is no longer the end of `documents.yml`'s. actionlint 1.7.12 with ShellCheck 0.11.0 — clean;
- **a miss** — pull request [#123](https://github.com/altnovatrail/.github/pull/123), never merged: `go.yml` with `same-bits` and `typescript.yml` by a local path, on the trial module of #120, with a comment more in the Dockerfile. The run 43819610180, `compression-level: 0`: "Go / toolchain" 52 s — the build with `docker save` 30 s, the upload 15 s —, "TypeScript / toolchain" 56 s; the artifact 1 293 051 552 B, against 409 MB of an entry of the cache, which `actions/cache` compresses. The jobs after them started 2 s after their `toolchain` ended; the downloads took 12–91 s and `docker load` 8–39 s; `arm64` built its own in 21 s and saved nothing. In the CI run 43819610189 `documents.yml` and "Workflows" built their own, 29 s and 21 s, and saved nothing; "Go / toolchain" of `self-ci.yml` built a third image, and its jobs downloaded theirs in 13–69 s. Re-running "Go / lint" alone, attempt 2: it downloaded the artifact of attempt 1 in 27 s and passed, and "Go / coverage" ran again after it. "TypeScript / test" and "TypeScript / licenses" were red, as the trial expects: `.github`'s Go recipes write no lcov report and get no `ALLOWED_LICENSES` from `typescript.yml`;
- **a miss at level 1** — the run 43820285813, another comment and `compression-level: 1`: the artifacts 489 208 258 B and 489 199 042 B, the uploads 16 s and 20 s, the downloads 8–44 s, half of them within 20 s; the jobs `toolchain` 56–66 s. Neither pull request saved an entry: `gh api …/actions/caches?ref=refs/pull/123/merge` gives `total_count` 0. Where the downloads of the Dockerfile are fast, as at `.github`, a miss now takes longer than every job building its own: the job `toolchain` and a download stand where one build of 21–44 s stood;
- **a hit** — the run 43820773569, without the comment: "Go / toolchain" and "TypeScript / toolchain" 6 s and 7 s — "Cache found and can be restored from key" —, and the jobs after them started 8–9 s after they did. Each restored the entry of `main` of 409 050 179 B, the one `toolchain.sh` saved, and loaded it as `novatrail-toolchain` in 12–35 s; `arm64` found no entry of its architecture for this Dockerfile and built in 21 s. In the CI run 43820773564 `documents.yml` and "Workflows" restored the same entry.;
- **a hit after the review** — the run 43821819346, with the sparse checkout of the job `toolchain`: the jobs `toolchain` 6 s and 10 s, the checkout in them 2 s and 4 s, against 1–5 s for the full checkouts of the jobs after them, and those jobs started 8–14 s after `toolchain` did, `fma-diff` 29 s after. In the CI run 43821819330 "Go / toolchain" took 12 s, and its four jobs started 30–36 s after it ended: the trial does not tell their wait for a runner from the rest.

## 8. The issue and pull request templates

### 8.1. The trial against the schemas

Measured 2026-11-01 (R29, T37):
- **the trial against the schemas** — SchemaStore's `github-issue-forms.json` and `github-issue-config.json`, draft-07, from www.schemastore.org; js-yaml 4.1.0 and Ajv 8.17.1 in a temporary folder, not in the repository. All three files are valid against the schemas. A breakage — an extra top-level key, an `id` with a space, a field without `label` — gives a refusal each time (R29).

## 9. Moves to tags of `spec`

### 9.1. The checks on a new tag

Measured 2026-11-08 (R34, T51):
- **the documents check** — `docs-check-repo` on v0.9.9 ok both before the edits and after.

Measured 2026-11-09 (R35):
- **the documents check** — `docs-check-repo` on v0.12.0 ok both before the edits and after.

Measured 2026-11-10 (R37):
- **the checks** — the suite `tests/run.sh` with the submodule's new script — 149 tests, 0 failed; `docs-check-repo` on v0.13.0 ok both before the edits and after.

Measured 2026-11-12 (R38, T54):
- **the hook** — `spec/tools/session/main.mjs` on a trial transcript with the prompt «Выполни задачу T54 из RUN.md»: a prompt with T55 — `"decision":"block"` and "This prompt starts T55, and this session has led T54: one task is one session (RULES.md, How we work). Run /clear, or open a new session, and send the prompt there."; the same task and a prompt with no task pass;
- **the checks** — the suite `tests/run.sh` with the script of the submodule at v0.16.3 and yq 4.54.1 by the sum of `self-ci.yml` — 156 tests, 0 failed; `docs-check-repo` on v0.16.3 ok both before the edits and after.

Measured 2026-11-16 (R40, T59):
- **the checks** — the suite `tests/run.sh` with the submodule at v0.18.3 and yq 4.54.1 by the sum of `self-ci.yml` — 158 tests, 0 failed; `docs-check-repo` on v0.18.3 ok before the edits, with RUN.md and `DEBT.md` read from their old place, and after, with `run/`;
- **the budgets** — with `"entries": {"R18": 50}` in place of `"entry": 50`, nothing over: every other entry keeps within the 40 KB of the block `repository`.

## 10. The restructuring of the documents

### 10.1. The "lossless" comparison («без потерь») of T55

Measured 2026-11-12 (the 2026-11-12 amendment to R38, T55):
- **on what** — the former section "Sources", architecture 4 on `main` at d5c57ae, from "## 4." to the end of the file, against `docs/sources.md`, `docs/measurements.md` and the pointer architecture 4 of T55. The pointer is in the comparison: its table now holds the names of the groups, and the builder of the files fixed ten places of the items — the section's links to its own sections and groups, "(2.8)" or «ниже, «<группа>»», are named by a document and a record's number;
- **how** — a node script in the session's scratchpad, like the comparison T133 `spec`: in the former section and in the new files it gathers URLs, quotes «…» — the outer ones, by depth — dates, commits, the numbers R, О-, П-, Т-, «Д», «В» and T, and code in backticks, and for each kind counts how many distinct values went missing and how many occur less often than before. The builder of the files also checked that each of the 273 items of the section was taken exactly once — whole or in parts;
- **the numbers** — distinct values: URLs 105, quotes 413, dates 44, commits 79, numbers 104, code 950. Missing 0, less often than before 0. Without the pointer one quote goes missing — «Интерфейс релиза `spec` и суммы архивов», a link to a group that became a record's number — and `go.yml` occurs 24 times instead of 25: only the table holds two names of groups with it.

## 11. The cost of the sessions

### 11.1. The budgets of size of T57

Measured 2026-11-13 (the 2026-11-13 amendment to R38, T57), by `just -f spec/justfile docs-check-repo` with `docs-budgets.json` at the root, after the rebuilding of T55 and the translations of T56 and T57:
- **with `{}`**, the limits of the block `repository` of `spec/tools/docs-check/budgets.json` alone: two things over — architecture 3.3 — 37,544 bytes, over the 24 KB of a section, and the entry R18 — 50,915 bytes, over the 40 KB of an entry. The probe of T54, before the rebuilding and the translations, had four over: architecture 3.1 — 26,962 bytes, 3.3 — 46,089, section 4 — 166,487, and R18 — 67,923;
- **with the file of T57** — `"entry": 50`, and 37 KB for architecture 3.3 under `sections` — nothing over, 194 things measured. The block has no limit for one entry, so the limit of 50 KB holds every entry of the log;
- **the decision log** — 388,566 bytes in Russian, 299,763 in English after the join of the 19 pieces.

### 11.2. The sessions of epic E18

Measured 2026-11-13 (T57), by `just -f spec/justfile tokens-report --since 2026-11-12T14:27 --row`, from the end of the window "before", the row `-workspaces--github` of measurements 1.9 spec. The table is that of measurements 1.9 spec; a row is added at the archive of each epic (RUN.md, «Как устроен план: эпики»).

| Project | Window, UTC | Sessions | Calls, main / subagents | Context of a call, k, main / subagents | Compactions | Cost at API prices |
|---|---|---|---|---|---|---|
| `-workspaces--github` — before E18, measurements 1.9 spec | 2026-10-13T00:00 … 2026-11-12T14:27 | 14 | 4,196 / 2,565 | 397.5 / 124.0 | 10 | $739.31 |
| `-workspaces--github` — E18, T54 to T57 | 2026-11-12T14:27 … 2026-11-13T04:44 | 4 | 410 / 353 | 188.8 / 78.5 | 1 | $49.77 |
| `-workspaces--github` — E19, T58 | 2026-11-13T04:44 … 2026-11-13T05:35 | 2 | 171 / 30 | 170.2 / 70.2 | 0 | $11.31 |
| `-workspaces--github` — E20, T59 | 2026-11-13T05:35 … 2026-11-16T02:52 | 2 | 90 / 16 | 157.3 / 71.1 | 0 | $6.46 |

- The context of a call of the main session fell from 397.5 to 188.8 thousand tokens, of a subagent from 124.0 to 78.5. The window "before" holds a month of the tasks of every kind, and the row of E18 four tasks of documents, so the comparison across the sessions after the epic is T124 `spec`'s;
- the session of T57 was measured while it ran: what it spent after 04:44 — the review, the epic E19 and the merge — is in the next row;
- the row of E19 is by `tokens-report --since 2026-11-13T04:44 --row`, measured 2026-11-13 at the archive of E19, while the session of T58 ran: its two sessions are the end of T57's and T58's, and what T58 spent after 05:35 — the record of the release and the archive — goes into the next row. The threshold of R145 spec is not reached: 171 main calls, fewer than 300, and no budget was raised in the epic; so no epic of analysis goes into table 2 of RUN.md.
- the row of E20 is by `tokens-report --since 2026-11-13T05:35 --row`, measured 2026-11-16 at the archive of E20, while the session of T59 ran, after its review and before the fixes and the pull request: its two sessions are the end of T58's — the record of the release and the archive of E19 — and T59's. The threshold of R145 spec is not reached: 90 main calls, and no budget was raised — the key `entries` narrowed one (R40). From T59 the rule for this row is in RUN.md, Epics, and an epic of analysis goes to `run/EPICS.md`.

## 12. The Go caches

### 12.1. `go.yml`: the trial #120

Measured 2026-11-16 (R41, T60):
- **locally**, in the devcontainer, 20 cores, Go 1.27.4 — the Go of the `toolchain` stage —, on clones of `learner-model` at cb8c5e0 and `tutor` at 143321f, each with empty `GOMODCACHE` and `GOCACHE` of its own, `go test -race -count=1 -covermode=atomic ./...` twice. `learner-model`, which requires no module: 46 s cold, 35 s warm, a `GOCACHE` of 128 MiB, 33.6 MB as a `.tar.gz`. `tutor`: 437 s cold and 430 s warm — the time is its tests', `cmd/tutor-eval` and `internal/evalsample` under `-race`, as measurements 3.1 spec says —, `GOMODCACHE` 170 MiB and `GOCACHE` 906 MiB, after `go vet ./...` too 313.6 MB as a `.tar.gz`; `go mod verify` — "all modules verified", 2 s. With 20 cores the compile is a small part of the run; an arm64 runner has 4 (sources 2.6), and so had `sim`'s, by its `nproc` (measurements 3.1 spec);
- **the assembler from the cache** — a module of one function `a*b + c`, `GOARCH=arm64 go build -o /dev/null -gcflags="-S -d=fmahash=n" .` twice with one `GOCACHE`: 24 lines of output both times, and "fmahash triggered [DISABLED] …" both times: the build cache replays the compiler's output, and `fma-diff` reads the same with a warm cache as with a cold one;
- **the suite** (R28) — 165 tests, 7 of them new: on a miss the three folders and no `docker`; a restore verified by `go mod verify` in the modules at the root and in `tools/x`, and not in `testdata/`, `vendor/`, `.devcontainer/`, `_old/` or a folder git does not track, and then the files of `build` and `lint`, ten days old, touched, and those of `mod` not; the script stops at the first module that fails; a verify that fails deletes a module cache of read-only folders, warns and goes on; a workspace git cannot list does the same; a restore with no module keeps the caches; a check by the text holds the three steps the same in the five jobs, the key with the job's check and no restore key, the save last, with its condition, and every `docker run` of the work with the mount and the three variables. The cases of `typescript.yml` and `documents.yml` that compared their steps with `go.yml`'s now pick the toolchain's and the report's by name. Eleven breakages — without `|| exit` in the script of verify, without `chmod` before `rm`, `testdata/` or the dot folders not left out, no folders on a miss, a save from a pull request, a save on a hit, a key without `go.sum`, `targets` without the mount, the warning path reported as verified, a restore key, and after the review the builds not touched — each turned the suite red. actionlint 1.7.12 with ShellCheck 0.11.0 — clean;
- **the trial** — pull request [#120](https://github.com/altnovatrail/.github/pull/120), never merged, before the review took the restore key out and added the touch of the builds — its restores were by the exact key: `go.yml` by a local path with `same-bits: true` on a trial module at the root that requires `golang.org/x/mod` v0.43.0, with `.github/coderules.json` of its own. The run 43811894346: every "Go / …" green, every "Go caches from the cache" missed, "Go caches" made the folders, and "Go caches into the cache" was skipped in all eight jobs — a pull request does not save; 25 lines "go: downloading". A trial commit let a pull request save: the run 43812454548 saved eight entries, from 18.3 MB (`rules`) to 78.0 MB (`licenses`), `arm64`'s under `go-Linux-ARM64-arm64-…`. Its second attempt restored each by its exact key, "all modules verified" twice — the root module and `tools/coderules` — and the save skipped; no "go: downloading"; the tests ran, "ok trial/trial/dep" on every target, none "(cached)". The work steps, cold → warm: `ci-test` 28 s → 11 s, `ci-vuln` 16 → 2, `ci-licenses` 16 → 1, `ci-lint` 10 → 0, "Tests on the targets" 30 → 1, the assembler 16 → 1, the rules of code 9 → 1, and in `arm64` `ci-test` 32 → 17 and the targets 17 → 2; the restore and the check took 0–8 s. The jobs as a whole are dominated by `docker load` of the image (R36): "Go / test" 76 s → 51 s, "Go / targets" 64 → 37, "Go / arm64" 90 → 51. In `rules` the key's hash of `go.sum` differed from the other jobs': the second checkout, `.shared-github`, is the trial's commit, which has a `go.sum` at its root, and `hashFiles('**/go.sum')` reads it; a release of `.github` has no `go.sum`.
- **the trial after the review** — pull request [#121](https://github.com/altnovatrail/.github/pull/121), never merged: the commits of #120 on the code after the review, with no restore key and the builds touched. The run 43814843057: green, eight entries saved under the scope `refs/pull/121/merge`, 18.3–78.0 MB, beside the image's of `arm64`, 392.7 MB. Its second attempt: every "Go caches" printed "…, its modules verified." — eight — and no warning, no "go: downloading", "ok trial/trial/dep" on every target; the step took 1–4 s, and the work steps 0–1 s but `ci-test`, 15 s, and `arm64`'s `ci-test`, 17 s. The entries of both trials were deleted by `gh cache delete` once measured.
