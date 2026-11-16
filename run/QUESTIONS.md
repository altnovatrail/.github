# QUESTIONS.md — questions to the author of `.github`

Table 3 of [RUN.md](../RUN.md): the author's open questions from tasks' «Открыто» (R153 spec, R154 spec).

- Never read whole: take the rows the task and its sections name — `grep -n '^| В39 ' run/QUESTIONS.md`.
- A row comes from a task's «Открыто» (RUN.md rule 9). Record the author's answer where it belongs — the task, a document or [DEBT.md](DEBT.md) — and delete the row; where it went goes at the end of its section of [docs/plan/history.md](../docs/plan/history.md).
- A row whose question opens with the mark «В реестр spec» is for `spec`: its session finds it on `main` (R81 spec; RULES.md, Across repositories). It leaves once `spec` has recorded it: the task that rests on it names its number.

## Table 3. Questions to the author

Numbers are not reused: next — В42.

| ID | Question | From | Options | Recommendation |
|---|---|---|---|---|
| В41 | «В реестр spec»: the card architecture 3.11 spec names, of `.github`'s CI, the shared workflows alone, released and pinned by a SHA (R03–R05 .github). With R49 `.github` also ships a shared composite action, `.github/actions/toolchain` — the image of the stage `toolchain` and the caches of Go for a caller's own job —, released and pinned the same way, which `go.yml`'s job `arm64` takes too and row 2.5 of COORDINATION.md spec asked for. Does the card name it? | T69 | 1) a line in the card under "the shared workflows": the composite action `toolchain` for a caller's own job in the stage `toolchain`, pinned by the SHA of a release and moved by Dependabot with the workflows (R49 .github); 2) no change: the card's "shared workflows" covers it, and the detail stays in architecture 3.1 .github | 1: what a component ships is the card's, and a caller writing its own job reads the card first |
