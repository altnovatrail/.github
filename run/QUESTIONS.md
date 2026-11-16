# QUESTIONS.md — questions to the author of `.github`

Table 3 of [RUN.md](../RUN.md): the author's open questions from tasks' «Открыто» (R153 spec, R154 spec).

- Never read whole: take the rows the task and its sections name — `grep -n '^| В39 ' run/QUESTIONS.md`.
- A row comes from a task's «Открыто» (RUN.md rule 9). Record the author's answer where it belongs — the task, a document or [DEBT.md](DEBT.md) — and delete the row; where it went goes at the end of its section of [docs/plan/history.md](../docs/plan/history.md).
- A row whose question opens with the mark «В реестр spec» is for `spec`: its session finds it on `main` (R81 spec; RULES.md, Across repositories). It leaves once `spec` has recorded it: the task that rests on it names its number.

## Table 3. Questions to the author

Numbers are not reused: next — В40.

| ID | Question | From | Options | Recommendation |
|---|---|---|---|---|
| В39 | «В реестр spec»: from v0.18.4 the template's `.devcontainer/Dockerfile` gives every copy the comment of spec's own `toolchain` stage — "spec's tests need nothing the core lacks, so here the stage adds nothing. A copy's kind adds its lines at the end of this stage (repo-template/kinds.json)" —, and in a copy there is no `repo-template/`, and the tests are the copy's (R46) | T67, `.devcontainer/Dockerfile` | (a) `tools/new-repo/` writes a copy's own comment there: what its kind adds, or that the kind `docs` adds nothing; (b) a comment that holds for spec and copies alike, in spec's Dockerfile; (c) leave it: the stage is empty and the comment harmless | (a): a copy's text then speaks of the copy, and a kind that adds lines says so where it adds them |
