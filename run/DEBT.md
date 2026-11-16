# DEBT.md — technical debt of `.github`

Table 4 of [RUN.md](../RUN.md): what was put off on purpose, its risk, when to return (R153 spec, R154 spec).

- Never read whole: take the rows the task and its sections name — `grep -n '^| Д9 ' run/DEBT.md` — and those `grep -n` finds by the paths and parts it changes (RUN.md rule 2).
- A row comes from a task's «Открыто» (RUN.md rule 9) and holds only what is open: drop a closed part, delete the row once closed, and note where it went at the end of its section of [docs/plan/history.md](../docs/plan/history.md).

## Table 4. Technical debt

Numbers are not reused: next — Д11.

| ID | Debt | From | Risk while open | When to return |
|---|---|---|---|---|
| Д9 | The miss of R42 is measured at `.github` alone, whose image holds Go: at `canvas`, whose image holds the browsers, the job `toolchain` and its artifact against a build in each job are not measured | T61 | a miss slower than the builds it replaced goes unnoticed where the image is large | once `canvas` takes the release of T61, row 7.23 of COORDINATION.md spec |
| Д10 | The gain of R43 is measured on the trial module of `.github` alone, where the load of the image is most of each job and the matrix is no faster than one job `targets`: on a caller whose tests take the time, as `sim`'s js/wasm 134 s, the five jobs against one are not measured | T62 | the matrix costs four loads of the image a run where it gains nothing | once `sim` takes the release of T62, row 7.19 of COORDINATION.md spec |
