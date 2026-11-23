# QUESTIONS.md — questions to the author of `.github`

Table 3 of [RUN.md](../RUN.md): the author's open questions that tasks leave (R153 spec, R160 spec).

- Never read whole: take the rows the task and its sections name — `grep -n '^| В39 ' run/QUESTIONS.md`.
- A row is a question a task leaves open (RUN.md rule 9). Record the author's answer where it belongs — the task, a document or [DEBT.md](DEBT.md) — and delete the row; where it went goes at the end of its section of [docs/plan/history.md](../docs/plan/history.md).
- A row whose question opens with the mark «В реестр spec» is for `spec`: its session finds it on `main` (R81 spec; RULES.md, Across repositories). It leaves once `spec` has recorded it: the task that rests on it names its number.

## Table 3. Questions to the author

Numbers are not reused: next — В47.

| ID | Question | From | Options | Recommendation |
|---|---|---|---|---|
| В46 | «В реестр spec»: the author wants no Russian text in the documents of `docs/`. Two kinds remain in `.github`, and both rest on `spec`'s rules: (1) the mark «В реестр spec» itself, which RULES.md, the template's RUN.md and every repository's table 3 write in Russian, and the documents name; (2) verbatim quotes of `spec`'s Russian texts — COORDINATION.md's «Порядок», older decisions, task bodies — in the records of `docs/sources.md`, which RULES.md keeps in their own language. Shall `spec` change both, for every repository? | author, 2026-11-23 | (a) an English mark, e.g. "For spec's registers", in RULES.md, the template and each repository's tables and documents; a quote of a Russian text of `spec` is replaced by the English text `spec` holds now, or else by a paraphrase marked as such; (b) only the mark; (c) neither: the mark is a fixed token, and a record quotes its source verbatim | (a): the mark is a token that English carries as well; where `spec` has since translated a quoted text, the English one is its current state, and where it has not, a marked paraphrase keeps the record honest |
