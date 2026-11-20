# QUESTIONS.md — questions to the author of `.github`

Table 3 of [RUN.md](../RUN.md): the author's open questions that tasks leave (R153 spec, R154 spec, R160 spec).

- Never read whole: take the rows the task and its sections name — `grep -n '^| В39 ' run/QUESTIONS.md`.
- A row is a question a task leaves open (RUN.md rule 9). Record the author's answer where it belongs — the task, a document or [DEBT.md](DEBT.md) — and delete the row; where it went goes at the end of its section of [docs/plan/history.md](../docs/plan/history.md).
- A row whose question opens with the mark «В реестр spec» is for `spec`: its session finds it on `main` (R81 spec; RULES.md, Across repositories). It leaves once `spec` has recorded it: the task that rests on it names its number.

## Table 3. Questions to the author

Numbers are not reused: next — В46.

| ID | Question | From | Options | Recommendation |
|---|---|---|---|---|
| В45 | «В реестр spec»: row Д217 of `run/DEBT.md` spec names "Pending: `skill-map`" alone since T218 (В73), by option 1 of В44, but its column "When to return" still reads "`skill-map` and `.github` moves to a tag with T141" (sources 12.18). Drop `.github` from that column too? | T82 | 1) yes: "`skill-map` moves to a tag with T141"; 2) no change | 1: `grep -n '`.github`' spec/run/DEBT.md` of every move still finds Д217 and sends the session to read it again, as В44 found |
