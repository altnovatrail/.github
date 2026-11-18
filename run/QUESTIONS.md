# QUESTIONS.md — questions to the author of `.github`

Table 3 of [RUN.md](../RUN.md): the author's open questions from tasks' «Открыто» (R153 spec, R154 spec).

- Never read whole: take the rows the task and its sections name — `grep -n '^| В39 ' run/QUESTIONS.md`.
- A row comes from a task's «Открыто» (RUN.md rule 9). Record the author's answer where it belongs — the task, a document or [DEBT.md](DEBT.md) — and delete the row; where it went goes at the end of its section of [docs/plan/history.md](../docs/plan/history.md).
- A row whose question opens with the mark «В реестр spec» is for `spec`: its session finds it on `main` (R81 spec; RULES.md, Across repositories). It leaves once `spec` has recorded it: the task that rests on it names its number.

## Table 3. Questions to the author

Numbers are not reused: next — В45.

| ID | Question | From | Options | Recommendation |
|---|---|---|---|---|
| В44 | «В реестр spec»: row Д217 of `run/DEBT.md` spec still names `.github` as pending — "`.github` — its wrapper contract's browsers (R19 .github)", to return on "`skill-map` and `.github` moves to a tag with T141" —, and `.github` did it in T64: `typescript.yml` names Chrome Headless Shell, WebKit and Firefox as the browsers of its contract, with the input `engines` (the 2026-11-16 amendment to R19 .github), and it is on a tag with T141 since v0.18.3. Drop `.github` from Д217? | T76 | 1) yes: `.github` leaves Д217, which keeps `skill-map` alone; 2) no change | 1: a pending list that names a done repository sends the next session to look again, as В43 found |
