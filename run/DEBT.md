# DEBT.md — technical debt of `.github`

Table 4 of [RUN.md](../RUN.md): what was put off on purpose, its risk, when to return (R153 spec, R154 spec).

- Never read whole: take the rows the task and its sections name — `grep -n '^| Д9 ' run/DEBT.md` — and those `grep -n` finds by the paths and parts it changes (RUN.md rule 2).
- A row comes from a task's «Открыто» (RUN.md rule 9) and holds only what is open: drop a closed part, delete the row once closed, and note where it went at the end of its section of [docs/plan/history.md](../docs/plan/history.md).

## Table 4. Technical debt

Numbers are not reused: next — Д13.

| ID | Debt | From | Risk while open | When to return |
|---|---|---|---|---|
| Д12 | With `same-bits` the matrix of R43 does not shorten a caller's run yet: at `sim` the run ends with "Go / arm64", whose targets `cpu-off js-wasm wasip1` run one after another, 366–384 s; at `learner-model` and `engine`, whose tests on the targets take seconds, the five jobs cost four loads of the image and wait for runners (measurements 2.8) | T73 | the runs of `sim` stay as long as before R43, and the matrix takes four runners a run from the organization where it gains nothing | a task of the speed of CI, a row of COORDINATION.md spec or the author's word |
