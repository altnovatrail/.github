# DEBT.md — technical debt of `.github`

Table 4 of [RUN.md](../RUN.md): what was put off on purpose, its risk, when to return (R153 spec, R154 spec).

- Never read whole: take the rows the task and its sections name — `grep -n '^| Д9 ' run/DEBT.md` — and those `grep -n` finds by the paths and parts it changes (RUN.md rule 2).
- A row comes from a task's «Открыто» (RUN.md rule 9) and holds only what is open: drop a closed part, delete the row once closed, and note where it went at the end of its section of [docs/plan/history.md](../docs/plan/history.md).

## Table 4. Technical debt

Numbers are not reused: next — Д9.

| ID | Debt | From | Risk while open | When to return |
|---|---|---|---|---|
