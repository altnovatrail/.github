# RUN.md — work plan of .github

What .github does, does not do and has still to decide — [docs/architecture.md](docs/architecture.md); why — [docs/decisions.md](docs/decisions.md). The platform is in `spec/`, a submodule at tag v0.18.6: the component's card — architecture 3.11 spec; the platform's decisions — spec's log. Small tasks, one at a time, each reviewed by the author; only the current epic is in detail (R19 spec). Other tables, each a file opening with its rules (R153 spec): 2, epics for later — [run/EPICS.md](run/EPICS.md); 3, questions to the author — [run/QUESTIONS.md](run/QUESTIONS.md); 4, debt — [run/DEBT.md](run/DEBT.md).

Language (R154 spec): rules and tables in English, terse, for the session; the bodies of tasks in table 1 in Russian — the author writes and reviews them.

## Rules

A task starts with «Выполни задачу T01 из RUN.md» in a new session in the devcontainer. One task — one session (R143 spec): the hook `UserPromptSubmit` of [.claude/settings.json](.claude/settings.json) — `spec/tools/session/` — stops «Выполни задачу T…» or «планируй T…» of another task in the same session and names `/clear`; the same task passes.

1. Do only the named task; touch other tasks' files only where it requires.
2. Read first: [CLAUDE.md](CLAUDE.md) with the rules it imports (RULES.md of `spec/`), the task in table 1, the sections it cites — its own and spec's —, [docs/decisions.md](docs/decisions.md).
   - Conflict with the documents or something missing — stop and ask; never guess.
   - A gap in the component itself — a subsection of [docs/architecture.md](docs/architecture.md), section 2. A gap across repositories — a row of [run/QUESTIONS.md](run/QUESTIONS.md) whose question opens with the mark «В реестр spec»: spec's session finds it on `main`, and it gets its О-, П- or Т- number once the author decides it there (R81 spec; RULES.md, Across repositories).
   - From `run/DEBT.md` and `run/QUESTIONS.md` take only the rows the task and its sections name and those `grep -n` finds by the paths and parts it changes (R143 spec).
3. **Devcontainer only.** If `NOVATRAIL_DEVCONTAINER` is not `1`, stop before the first edit and ask to reopen in the container; "only documents" is no reason to go on. If `spec/` is empty, ask for `git submodule update --init`. Exception: a cloud session the author started for the task runs the checks it can reach, and its report names each one that did not run.
4. Outside this repository — editing `spec` or other repositories, their settings, anything that costs money — only after a warning (what, where, cost) and the author's confirmation. `spec/` is read only here; a task of its own moves it to a new tag.
   - Exception, no confirmation: the task's checks by R146 spec — browser: Playwright in the devcontainer, custom-token sign-in of a stand-in user on the dev project; AI: the `tutor` stub in `api` dev mode. A real AI call only where the task checks the model's words: dev key under the author's spend limit at the provider, within the task's ceiling, or with confirmation where it has none; «Сделано» names the provider, the calls and the cost.
   - Nothing on devices: engines are Chromium, WebKit and Firefox in CI; what only a device shows — pen, device voices, VoiceOver and TalkBack, the home screen — stays a row of [run/DEBT.md](run/DEBT.md) until the author decides otherwise.
5. Facts on AI providers, laws, prices and other platforms — from the primary source, a record of `docs/sources.md` (RULES.md). What is not confirmed is not stated: it becomes an open question.
6. End with the checks of what the task changed: documents — `just -f spec/justfile docs-check-repo` (CLAUDE.md, Environment); a part — by its rule `.claude/rules/`.

   Then `/code-review high`, one round: fix the findings, do not rerun. A small change may skip the review even if «Как проверить» names it.
7. Do not commit: the author commits after review. A run of spec's orchestrator, «Сделай эпик E…», is the author's word otherwise: its executor works by the contract `spec/tools/orchestrator/executor.md` — commits, pushes and opens the pull request, never merges (R156 spec).
8. End with a short report in Russian: what was done, files, how to check, what the review found or why there was none, what is open and what goes «в реестр spec».
9. When done: table 1 `[ ]` → `[x]`; append to the body «Сделано (дата)» — what was done, how checked — and «Открыто». A question for the author from «Открыто» is also a row of [run/QUESTIONS.md](run/QUESTIONS.md); what is put off, a row of [run/DEBT.md](run/DEBT.md).
   - Then move the body verbatim, relative links fixed, to the epic archive `docs/plan/<epic>.md`, with a gist sentence — an unheaded list item at the start of the receiving section: «T01 — сделана <дата>: <итог одной фразой>». Neither stays here, and a search by heading finds one body, in the archive (R153 spec).
   - A task lives only in an epic: there are no tasks outside an epic and no `run/TASKS.md` (the 2026-11-13 amendment to R38; R40).
10. Language (R14 spec, R42 spec, R143 spec, R154 spec): this plan and `run/` in English, the bodies of tasks, the epic archives `docs/plan/` and the reports in Russian; `docs/` in English; README, CLAUDE.md, AGENTS.md, code, comments, schema descriptions, prompts and normative texts for authors in English.
11. A task larger than one review (≈ 30–60 minutes of reading): propose a split before starting.
12. Before a new task, close the findings on the previous one by SonarCloud, CodeQL and Scorecard (R30 spec); an allowed departure from rule 1. SonarCloud sees merged code: its verdict on the previous task is in [New Code](https://sonarcloud.io/summary/new_code?id=altnovatrail_.github); CodeQL and Scorecard — `gh api 'repos/altnovatrail/.github/code-scanning/alerts?state=open'`. Fix in code first; "false positive" is the last resort, with the reason in words; what a change cannot close stays open — shared reasons in R33 spec, own ones in the log, like R51 canvas-api. Never skip silently. Report these fixes in a separate paragraph: the author commits them apart from the task.

**Statuses:** `[ ]` not started; `[x]` done, the executor marks it; `[-]` not done — the author's decision, reason in the task; `[?]` deferred — the author's decision, reason and when to return in the task. A task that fails the author's review returns to `[ ]` with what to fix.

**Who:** «Claude» — the executor does it, the author reviews; «Claude, проверяю я» — texts the author reads line by line; «я + Claude» — the author does some steps: decisions, sign-ins, GitHub settings, confirmations by rule 4.

**Plan:** «да» — plan mode first: decisions missing from the documents, or larger than one review (rule 11); «—» — run at once.

**Task body** (Russian): «Цель», «Сделать», «Как проверить», «Разделы»; as needed «Не делать», «Решить при планировании», «Мой шаг», «Стоимость», «Риски»; from planning «Почему», «Решено автором (дата)», «Выяснилось при планировании»; when done «Сделано (дата)», «Открыто» (rule 9).

**Citations.** As RULES.md spec, Citations. A task — «T03», from another repository «T03 .github»; one not here is in an archive: `grep -n '^#### T03\.' RUN.md docs/plan/*.md`. Task numbers are global and never reused: take the one free when writing it down.

## Epics

- **Table 1** is the current epic: its tasks in detail, run one at a time.
- **Next epic.** Once table 1 is all checked, the author picks the next epic from [run/EPICS.md](run/EPICS.md) and splits it with Claude in plan mode into tasks of one review each, into table 1 and this file.
- **A done epic** goes to `docs/plan/<epic>.md` (R59 canvas-api): bodies and gist sentences are there already (rule 9); move its description and table of tasks verbatim; questions and debt stay in `run/`; until the next epic, table 1 reads «Current epic — none» and names the last done epic; measure the epic's sessions — `just -f spec/justfile tokens-report --since <first day of the epic> --row` — as a row of measurements 11.2; past the threshold of R145 spec, an epic of analysis into [run/EPICS.md](run/EPICS.md). Never read an archive whole: take the task cited.
- **Done epics:** E1–E15 and E17–E20, each archived in `docs/plan/E<number>.md`, but for E15, which has none. E16 is taken by the move to v0.9.9, whose epic was deleted (the 2026-11-08 amendment to R34). Task numbers are taken through T68: next — T69.

## Table 1. Current epic — E21. Скорость CI общих workflow

**Результат:** релизы общих workflow по строке 7.13 COORDINATION.md spec — кеш Go в `go.yml`, один файл образа стадии `toolchain`, «Go / targets» матрицей и «Go / fma-diff» параллельно, сверка и подписи `release.yml` параллельно, вход `typescript.yml` для WebKit и Firefox и браузеры договора обёртки (Д217 spec), CodeQL (go) без сборки образа, и последним — стадия `toolchain-core` с тегом `spec` строки 7.14. У каждой задачи — случаи шагов (R28), пробный pull request и решение журнала; вызывающие берут релизы Dependabot или своими задачами строк 7.15–7.25.

| Статус | ID | Задача | Кто | План | Зависит от |
|---|---|---|---|---|---|
| [x] | T60 | Кеш Go в `go.yml` | Claude | — | — |
| [x] | T61 | Один файл образа `toolchain` во всех workflow | Claude | да | T60 |
| [x] | T62 | «Go / targets» матрицей, «Go / fma-diff» параллельно | Claude | — | T61 |
| [x] | T63 | Сверка и подписи `release.yml` параллельно | Claude | — | — |
| [x] | T64 | WebKit и Firefox — своей проверкой `typescript.yml` | Claude | да | T61 |
| [x] | T65 | CodeQL (go) — Go из архива Dockerfile, без образа | Claude | да | — |
| [x] | T67 | Переход на тег `spec` v0.18.4 | Claude | — | — |
| [x] | T66 | Стадия `toolchain-core` в релизе и проверках | Claude | да | T60–T65, T67; строка 7.14 COORDINATION.md spec |
| [x] | T68 | Переход на тег `spec` v0.18.6 | Claude | — | T66 |

**Почему такой порядок.** Каждый мерж, что меняет общий workflow, выпускает релиз сам (R10), поэтому порядок задач — порядок релизов. Первым — кеш Go: его ждут строки 7.15–7.21, все репозитории с Go. Затем образ — строки 7.23–7.25, и он меняет те же шаги `go.yml`, что T60, и шаги `typescript.yml`, что T64. Затем цели — строка 7.19 `sim`; сверка релиза — строка 7.15 `api`; движки — строки 7.22 и 7.23, которые ждут и строку 7.14; CodeQL не ждёт никто. `toolchain-core` — последней: её ждёт строка 7.14, T166 spec, которая шла параллельно; её тег v0.18.4 `.github` берёт перед ней, T67. T68 — переход на v0.18.6, волна 0 прогона всего «Порядка» COORDINATION.md spec, после T66.

## Epic E21. Скорость CI общих workflow

**Почему эпик такой.** Слово автора 2026-11-16 (прогон «Сделай эпик» `spec`, T171; R156 spec): ускорение CI — сейчас. Строка 7.13 COORDINATION.md spec, по замеру measurements 3.1 spec, просит у `.github` релиз общих workflow, а Д217 spec — браузеры договора обёртки TypeScript (R19); эпик E21 в `run/EPICS.md` их соединил (R40). Задача — одна проверка из строки 7.13 и одно ревью (правило 11).

**Для каждой задачи.** После мержа релиз выходит сам (R10). Запись о нём — поправкой «the release came out» к решению задачи и SHA в шаблоне architecture 3.3 — первым шагом следующей задачи эпика, а после последней — с архивом эпика. `.devcontainer/` эпик меняет только переходами на тег `spec` — T67, на v0.18.4, и T68, на v0.18.6 (слово автора 2026-11-16).

**Не входит:** изменения вызывающих — строки 7.15–7.25 COORDINATION.md spec, задачи их репозиториев; стадия `toolchain-core` в Dockerfile — строка 7.14, T166 spec; `.github` берёт её из шаблона переходом на тег, T67.
