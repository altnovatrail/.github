# DEBT.md — technical debt of `.github`

Table 4 of [RUN.md](../RUN.md): what was put off on purpose, its risk, when to return (R153 spec, R154 spec).

- Never read whole: take the rows the task and its sections name — `grep -n '^| Д9 ' run/DEBT.md` — and those `grep -n` finds by the paths and parts it changes (RUN.md rule 2).
- A row is what a task leaves open (RUN.md rule 9) and holds only what is open: drop a closed part, delete the row once closed, and note where it went at the end of its section of [docs/plan/history.md](../docs/plan/history.md).

## Table 4. Technical debt

Numbers are not reused: next — Д16.

| ID | Debt | From | Risk while open | When to return |
|---|---|---|---|---|
| Д12 | With `same-bits` the matrix of R43 does not shorten a caller's run yet: at `sim` the run ends with "Go / arm64", whose targets `cpu-off js-wasm wasip1` run one after another, 366–384 s; at `learner-model` and `engine`, whose tests on the targets take seconds, the five jobs cost four loads of the image and wait for runners (measurements 2.8) | T73 | the runs of `sim` stay as long as before R43, and the matrix takes four runners a run from the organization where it gains nothing | a task of the speed of CI, a row of COORDINATION.md spec or the author's word |
| Д14 | The entries of the log on moves to tags of `spec` — R38, R46, R48, R50, R51 and those before them — say which tag `.github` is on and what `docs-budgets.json` holds, as of their day; the tag is in CLAUDE.md and RUN.md, the limits in the file, and a move is no entry (R160 spec). The amendment 2026-11-16 to R38 and R46 cite R40 for the move to v0.18.3, which R40, the layout of the plan and the differences from the template, no longer holds; R51 lost only its rejection of the Dockerfile's comment, which T82 took | T77, T82 | a session that reads such an entry takes a past tag or limit for the current one | the task that touches such an entry rewrites it in place, by R160 spec |
| Д15 | The strict rule of citations of `spec` v0.19.12 — outside the plan and `docs/plan/` no number of a decision, no section, no task — is not yet in the rest of `docs/` of `.github`: the log from R13 on, `docs/architecture.md`, `docs/sources.md` and `docs/measurements.md` still cite decisions, sections and tasks, the lines of the template v0.19.12 on citations in RUN.md and the openings of the rest of `docs/` and of `run/` are not taken, and T85–T92 are written by the rule of v0.19.11 | T93, T94, T85 | a session takes the cited numbers for the rule in force; `"citations": true` stays off | the next tasks of the batch on `e22-github-2`, which the orchestrator gives: T85–T92 by the strict rule |
