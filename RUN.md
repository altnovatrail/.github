# RUN.md — work plan of .github

What .github does, does not do and has still to decide — [docs/architecture.md](docs/architecture.md); why — [docs/decisions.md](docs/decisions.md). The platform is in `spec/`, a submodule at tag v0.19.12: the component's card — architecture 3.11 spec; the platform's decisions — spec's log. Small tasks, one at a time, each reviewed by the author; only the current epic is in detail (R19 spec). Other tables, each a file opening with its rules (R153 spec): 2, epics for later — [run/EPICS.md](run/EPICS.md); 3, questions to the author — [run/QUESTIONS.md](run/QUESTIONS.md); 4, debt — [run/DEBT.md](run/DEBT.md).

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
9. When done: table 1 `[ ]` → `[x]`; append to the body «Сделано (дата)» — one line, what was done and its pull request, which says how it was checked; where the author commits after review, the report says it. What stays open is rows, not text: a question for the author, of [run/QUESTIONS.md](run/QUESTIONS.md); what is put off, of [run/DEBT.md](run/DEBT.md) (R160 spec).
   - Then move the body verbatim, relative links fixed, to the epic archive `docs/plan/<epic>.md`, with a gist sentence — an unheaded list item at the start of the receiving section: «T01 — сделана <дата>: <итог одной фразой>». Neither stays here, and a search by heading finds one body, in the archive (R153 spec).
   - A task lives only in an epic: there are no tasks outside an epic and no `run/TASKS.md` (R40).
10. Language (RULES.md spec, Hard rules; R154 spec): this plan and `run/` in English, the bodies of tasks, the epic archives `docs/plan/` and the reports in Russian; `docs/` in English; README, CLAUDE.md, AGENTS.md, code, comments, schema descriptions, prompts and normative texts for authors in English; commit messages and a pull request's title and description in English and terse, for the session, never a copy of the report.
11. A task larger than one review (≈ 30–60 minutes of reading): propose a split before starting.
12. Before a new task, close the findings on the previous one by SonarCloud, CodeQL and Scorecard (R30 spec); an allowed departure from rule 1. SonarCloud sees merged code: its verdict on the previous task is in [New Code](https://sonarcloud.io/summary/new_code?id=altnovatrail_.github); CodeQL and Scorecard — `gh api 'repos/altnovatrail/.github/code-scanning/alerts?state=open'`. Fix in code first; "false positive" is the last resort, with the reason in words; what a change cannot close stays open — shared reasons in R33 spec, own ones in the log, like R51 canvas-api. Never skip silently. Report these fixes in a separate paragraph: the author commits them apart from the task.

**Statuses:** `[ ]` not started; `[x]` done, the executor marks it; `[-]` not done — the author's decision, reason in the task; `[?]` deferred — the author's decision, reason and when to return in the task. A task that fails the author's review returns to `[ ]` with what to fix.

**Who:** «Claude» — the executor does it, the author reviews; «Claude, проверяю я» — texts the author reads line by line; «я + Claude» — the author does some steps: decisions, sign-ins, GitHub settings, confirmations by rule 4.

**Plan:** «да» — plan mode first: decisions missing from the documents, or larger than one review (rule 11); «—» — run at once.

**Task body** (Russian): «Цель», «Сделать», «Как проверить», «Разделы»; as needed «Не делать», «Решить при планировании», «Мой шаг», «Стоимость», «Риски»; from planning «Почему», «Решено автором (дата)», «Выяснилось при планировании»; when done «Сделано (дата)» (rule 9).

**Citations** — RULES.md spec, Citations: a task's number stands only here, in `run/` and in `docs/plan/` (R171 spec). Own sections — `architecture 2`, own decisions — `R03`; spec's sections and decisions — «architecture 3.5 spec», «R18 spec», its open questions — «Т-22», «П-7», «О-2»: the repository keeps no registers; other NovaTrail repositories' decisions — «R03 api»; MathTrail's — «R44 canvas-api», «R163 standalone», in a list «canvas-api: R44, R59». Each log numbers its own: «R19 spec» and `R19` of this log differ. A task — «T03», from another repository «T03 .github»; one not here is in an archive: `grep -n '^#### T03\.' RUN.md docs/plan/*.md`. Task numbers are global and never reused: take the one free when writing it down.

## Epics

- **Table 1** is the current epic: its tasks in detail, run one at a time.
- **Next epic.** Once table 1 is all checked, the author picks the next epic from [run/EPICS.md](run/EPICS.md) and splits it with Claude in plan mode into tasks of one review each, into table 1 and this file.
- **A done epic** goes to `docs/plan/<epic>.md` (R59 canvas-api): bodies and gist sentences are there already (rule 9); move its description and table of tasks verbatim; questions and debt stay in `run/`; until the next epic, table 1 reads «Current epic — none» and names the last done epic; measure the epic's sessions — `just -f spec/justfile tokens-report --since <first day of the epic> --row` — as a row of measurements 11.2; past the threshold of R145 spec, an epic of analysis into [run/EPICS.md](run/EPICS.md). Never read an archive whole: take the task cited.
- **Done epics:** E1–E15 and E17–E28, each archived in `docs/plan/E<number>.md`, but for E15, which has none. E16 is taken by the move to v0.9.9, whose epic was deleted (R34). Task numbers are taken through T94: next — T95.

## Table 1. Current epic — E29. Теги `spec` v0.19.11 и v0.19.12, ссылки по R171 spec

**Результат:** `.github` на теге `spec` v0.19.12 и ссылается по правилу ссылок R171 spec (строка 7.38 COORDINATION.md spec).

| Статус | ID | Задача | Кто | План | Зависит от |
|---|---|---|---|---|---|
| [x] | T83 | Переход на тег `spec` v0.19.11 | Claude | — | — |
| [x] | T84 | Ссылки по R171 spec: план, CLAUDE.md, `.claude/rules/`, комментарии кода (часть 1 из 9) | Claude | да | T83 |
| [x] | T93 | Переход на тег `spec` v0.19.12 | Claude | — | T84 |
| [x] | T94 | Ссылки по строгому правилу R171 spec: проход по первой части | Claude | — | T93 |
| [ ] | T85 | Ссылки по R171 spec: вводная журнала и R01–R12 (часть 2) | Claude | — | T84 |
| [ ] | T86 | Ссылки по R171 spec: журнал, R13–R18 (часть 3) | Claude | — | T85 |
| [ ] | T87 | Ссылки по R171 spec: журнал, R19–R29 (часть 4) | Claude | — | T86 |
| [ ] | T88 | Ссылки по R171 spec: журнал, R30–R41 (часть 5) | Claude | — | T87 |
| [ ] | T89 | Ссылки по R171 spec: журнал, R42–R51 (часть 6) | Claude | — | T88 |
| [ ] | T90 | Ссылки по R171 spec: `docs/architecture.md` и `docs/README.md` (часть 7) | Claude | — | T89 |
| [ ] | T91 | Ссылки по R171 spec: `docs/sources.md` (часть 8) | Claude | — | T90 |
| [ ] | T92 | Ссылки по R171 spec: `docs/measurements.md` и ключ `"citations": true` (часть 9) | Claude | — | T91 |

## Epic E29. Теги `spec` v0.19.11 и v0.19.12, ссылки по R171 spec

**Почему эпик такой.** Прогон «Сделай эпик E22» `spec` (R156 spec): задачи дал оркестратор (правило 6 COORDINATION.md spec), пачкой на ветке `e22-github` с одним pull request (R159 spec). Задача живёт только в эпике (R40), а текущего эпика не было: E28 в архиве. Первая задача — переход на тег, волна 0; вторая — ссылки по R171 spec, T84, — по тексту оркестратора; правило 11 разбило её на девять частей, T84–T92, одна за другой, и последняя включает ключ `"citations": true`. Вслед за ними `spec` выпустил v0.19.12 со строгим правилом ссылок: T93 — переход на него, первая задача второй пачки, на ветке `e22-github-2`; остальные задачи этой пачки — проход по T84 и части T85–T92 по строгому правилу — даёт оркестратор (Д15).

**Не входит в переходы:** правки заготовки `spec/repo-template/` v0.19.11 и v0.19.12 по R171 spec — строки CLAUDE.md и RUN.md о ссылках, вводные `docs/decisions.md`, `docs/sources.md` и таблиц `run/`, `docs-budgets.json` с `"citations": true`: их берут задачи ссылок.

**Части T84.** T85–T92 — остальные части задачи T84, разбитой по её шагу 9 (правило 11): её тело и «Решено при планировании» — в [docs/plan/E29.md](docs/plan/E29.md), `grep -n '^#### T84\.' docs/plan/E29.md`. Каждая часть правит ссылки по шагам 4–8 T84 и только в своём месте; пока ключа нет, она проверяет себя ключом, включённым на время прогона, по строкам своего места.

#### T85. Ссылки по R171 spec: вводная журнала и R01–R12

- **Цель:** вводная `docs/decisions.md` и записи R01–R12 — разделы `##` от «The `spec` tag» до «Shared workflows — the files» включительно — ссылаются по R171 spec, без датированных поправок.
- **Почему:** часть 2 задачи T84 (её шаг 9): журнал — частями по своим разделам `##`, каждая — одно ревью.
- **Сделать:**
  1. Вводная — по `spec/repo-template/files/docs/decisions.md`: правило записи без датированных поправок (R160 spec), хвост «— *Consequence:*» по R171 spec.
  2. R01–R12 — по шагам 4–7 T84: каждая поправка свёрнута в действующий текст записи на месте, «Почему», отвергнутое и цитаты источников сохранены; хвост «— *Consequence:*» — файлы и разделы, без номеров задач; ссылка на поправку записи `spec` — на запись.
  3. Противоречие при свёртке или настоящее сомнение в ссылке — строка `run/QUESTIONS.md` (шаг 7 T84).
  4. В описании pull request — таблица «поправка → место в новом тексте».
- **Как проверить:** `docs-check-repo` с ключом `"citations": true`, включённым на время, — ни одной находки в строках вводной и R01–R12; без ключа — зелёный; `/code-review high`, один круг; в отчёте — ссылок и поправок в `docs/decisions.md` было и стало, командой measurements 1.18.4 spec.
- **Разделы:** T84; R171 spec, R160 spec; RULES.md spec — The bar и Citations; `spec/repo-template/files/docs/decisions.md`; свой `docs/decisions.md`, R01–R12.

#### T86. Ссылки по R171 spec: журнал, R13–R18

- **Цель:** записи R13–R18 — разделы `##` от «The `spec` tag after the shared workflows» до «The shared release» включительно — ссылаются по R171 spec, без датированных поправок.
- **Почему:** часть 3 задачи T84 (её шаг 9).
- **Сделать:** как пункты 2–4 T85, для R13–R18.
- **Как проверить:** как T85, по строкам R13–R18.
- **Разделы:** T84, T85; R171 spec, R160 spec; RULES.md spec — Citations; свой `docs/decisions.md`, R13–R18.

#### T87. Ссылки по R171 spec: журнал, R19–R29

- **Цель:** записи R19–R29 — разделы `##` от «The TypeScript wrapper» до «Issue and pull request templates» включительно — ссылаются по R171 spec, без датированных поправок.
- **Почему:** часть 4 задачи T84 (её шаг 9).
- **Сделать:** как пункты 2–4 T85, для R19–R29.
- **Как проверить:** как T85, по строкам R19–R29.
- **Разделы:** T84, T85; R171 spec, R160 spec; RULES.md spec — Citations; свой `docs/decisions.md`, R19–R29.

#### T88. Ссылки по R171 spec: журнал, R30–R41

- **Цель:** записи R30–R41 — разделы `##` от «The `spec` tag v0.6.2» до «The Go caches» включительно — ссылаются по R171 spec, без датированных поправок.
- **Почему:** часть 5 задачи T84 (её шаг 9).
- **Сделать:** как пункты 2–4 T85, для R30–R41.
- **Как проверить:** как T85, по строкам R30–R41.
- **Разделы:** T84, T85; R171 spec, R160 spec; RULES.md spec — Citations; свой `docs/decisions.md`, R30–R41.

#### T89. Ссылки по R171 spec: журнал, R42–R51

- **Цель:** записи R42–R51 — разделы `##` от «One file of the image of the `toolchain` stage» до конца журнала — ссылаются по R171 spec, без датированных поправок; во всём `docs/decisions.md` не остаётся находок проверки.
- **Почему:** часть 6 задачи T84 (её шаг 9).
- **Сделать:** как пункты 2–4 T85, для R42–R51; запись, добавленная в журнал после T84, — тоже.
- **Как проверить:** как T85, по всему `docs/decisions.md`.
- **Разделы:** T84, T85; R171 spec, R160 spec; RULES.md spec — Citations; свой `docs/decisions.md`, R42 и дальше.

#### T90. Ссылки по R171 spec: `docs/architecture.md` и `docs/README.md`

- **Цель:** `docs/architecture.md` и `docs/README.md` ссылаются по R171 spec: без номеров задач, без ссылок на поправки, не больше двух ссылок в скобке, без цепочек.
- **Почему:** часть 7 задачи T84 (её шаг 9).
- **Сделать:**
  1. Ссылки — по шагу 4 T84; ссылка на поправку своего журнала или `spec` — на запись; номер задачи — на файл или решение.
  2. Файлы вызывающих, которые архитектура цитирует блоками кода, — их комментарии по шагу 5 T84, как комментарии кода `.github`.
  3. Смысл не менять (шаг 7 T84).
- **Как проверить:** `docs-check-repo` с ключом, включённым на время, — ни одной находки в этих двух файлах; без ключа — зелёный; `/code-review high`, один круг; в отчёте — ссылок было и стало, командой measurements 1.18.4 spec.
- **Разделы:** T84; R171 spec; RULES.md spec — The bar и Citations; свои `docs/architecture.md`, `docs/README.md`.

#### T91. Ссылки по R171 spec: `docs/sources.md`

- **Цель:** `docs/sources.md` ссылается по R171 spec: заголовок записи называет тему и дату, не задачу; без номеров задач и ссылок на поправки; не больше двух ссылок в скобке.
- **Почему:** часть 8 задачи T84 (её шаг 9).
- **Сделать:**
  1. Вводная — по `spec/repo-template/files/docs/sources.md`.
  2. Номер задачи в заголовке и тексте записи — убрать, дату оставить; ссылки — по шагу 4 T84. Цитаты источников — как есть.
  3. Ссылки других документов на записи не меняются: номера записей остаются.
- **Как проверить:** `docs-check-repo` с ключом, включённым на время, — ни одной находки в `docs/sources.md`; без ключа — зелёный; `/code-review high`, один круг; в отчёте — ссылок было и стало.
- **Разделы:** T84; R171 spec; RULES.md spec — Citations; `spec/repo-template/files/docs/sources.md`; свой `docs/sources.md`.

#### T92. Ссылки по R171 spec: `docs/measurements.md` и ключ `"citations": true`

- **Цель:** `docs/measurements.md` ссылается по R171 spec, и `docs-budgets.json` несёт `"citations": true`, как `spec/repo-template/files/docs-budgets.json`: `docs-check-repo` с ключом — зелёный.
- **Почему:** часть 9, последняя, задачи T84 (её шаг 9): ключ включает последняя часть.
- **Сделать:**
  1. `docs/measurements.md` — как пункт 2 T91: номер задачи в заголовке и тексте записи — убрать, дату оставить; ссылки — по шагу 4 T84.
  2. `docs-budgets.json` — `"citations": true`; остальные находки проверки во всём репозитории, если есть, — по шагам 4–7 T84.
  3. Замер «после» — командами measurements 1.18.4 spec, по видам, против замера «до» в «Сделано» T84.
- **Как проверить:** `docs-check-repo` — зелёный с ключом; `/code-review high`, один круг; в отчёте — ссылок было и стало, по видам, для всего репозитория.
- **Разделы:** T84; R171 spec, R32 spec; RULES.md spec — Citations; `spec/repo-template/files/docs-budgets.json`; свои `docs/measurements.md`, `docs-budgets.json`.
