# RUN.md — work plan of .github

What .github does, does not do and has still to decide — [docs/architecture.md](docs/architecture.md); why — [docs/decisions.md](docs/decisions.md). The platform is in `spec/`, a submodule at tag v0.18.34: the component's card — architecture 3.11 spec; the platform's decisions — spec's log. Small tasks, one at a time, each reviewed by the author; only the current epic is in detail (R19 spec). Other tables, each a file opening with its rules (R153 spec): 2, epics for later — [run/EPICS.md](run/EPICS.md); 3, questions to the author — [run/QUESTIONS.md](run/QUESTIONS.md); 4, debt — [run/DEBT.md](run/DEBT.md).

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
   - A task lives only in an epic: there are no tasks outside an epic and no `run/TASKS.md` (the 2026-11-13 amendment to R38; R40).
10. Language (R14 spec, R42 spec, R143 spec, R154 spec): this plan and `run/` in English, the bodies of tasks, the epic archives `docs/plan/` and the reports in Russian; `docs/` in English; README, CLAUDE.md, AGENTS.md, code, comments, schema descriptions, prompts and normative texts for authors in English; commit messages and a pull request's title and description in English and terse, for the session, never a copy of the report.
11. A task larger than one review (≈ 30–60 minutes of reading): propose a split before starting.
12. Before a new task, close the findings on the previous one by SonarCloud, CodeQL and Scorecard (R30 spec); an allowed departure from rule 1. SonarCloud sees merged code: its verdict on the previous task is in [New Code](https://sonarcloud.io/summary/new_code?id=altnovatrail_.github); CodeQL and Scorecard — `gh api 'repos/altnovatrail/.github/code-scanning/alerts?state=open'`. Fix in code first; "false positive" is the last resort, with the reason in words; what a change cannot close stays open — shared reasons in R33 spec, own ones in the log, like R51 canvas-api. Never skip silently. Report these fixes in a separate paragraph: the author commits them apart from the task.

**Statuses:** `[ ]` not started; `[x]` done, the executor marks it; `[-]` not done — the author's decision, reason in the task; `[?]` deferred — the author's decision, reason and when to return in the task. A task that fails the author's review returns to `[ ]` with what to fix.

**Who:** «Claude» — the executor does it, the author reviews; «Claude, проверяю я» — texts the author reads line by line; «я + Claude» — the author does some steps: decisions, sign-ins, GitHub settings, confirmations by rule 4.

**Plan:** «да» — plan mode first: decisions missing from the documents, or larger than one review (rule 11); «—» — run at once.

**Task body** (Russian): «Цель», «Сделать», «Как проверить», «Разделы»; as needed «Не делать», «Решить при планировании», «Мой шаг», «Стоимость», «Риски»; from planning «Почему», «Решено автором (дата)», «Выяснилось при планировании»; when done «Сделано (дата)» (rule 9).

**Citations.** As RULES.md spec, Citations. A task — «T03», from another repository «T03 .github»; one not here is in an archive: `grep -n '^#### T03\.' RUN.md docs/plan/*.md`. Task numbers are global and never reused: take the one free when writing it down.

## Epics

- **Table 1** is the current epic: its tasks in detail, run one at a time.
- **Next epic.** Once table 1 is all checked, the author picks the next epic from [run/EPICS.md](run/EPICS.md) and splits it with Claude in plan mode into tasks of one review each, into table 1 and this file.
- **A done epic** goes to `docs/plan/<epic>.md` (R59 canvas-api): bodies and gist sentences are there already (rule 9); move its description and table of tasks verbatim; questions and debt stay in `run/`; until the next epic, table 1 reads «Current epic — none» and names the last done epic; measure the epic's sessions — `just -f spec/justfile tokens-report --since <first day of the epic> --row` — as a row of measurements 11.2; past the threshold of R145 spec, an epic of analysis into [run/EPICS.md](run/EPICS.md). Never read an archive whole: take the task cited.
- **Done epics:** E1–E15 and E17–E26, each archived in `docs/plan/E<number>.md`, but for E15, which has none. E16 is taken by the move to v0.9.9, whose epic was deleted (the 2026-11-08 amendment to R34). Task numbers are taken through T81: next — T82.

## Table 1. Current epic — E27. Тексты без истории (R160 spec)

**Результат:** `.github` на теге `spec` v0.18.34 и пишет по R160 spec: план, документы и комментарии кода держат текущее состояние, а не историю; `docs-check-repo` проверяет предел записи журнала 12 КБ и номера решений в комментариях кода.

| Статус | ID | Задача | Кто | План | Зависит от |
|---|---|---|---|---|---|
| [x] | T77 | Тексты без истории (R160 spec) и тег `spec` v0.18.34 | Claude | да | — |
| [ ] | T78 | Документы без истории: вводная и разделы 1–2 `docs/architecture.md`, README, CLAUDE.md | Claude | — | T77 |
| [ ] | T79 | Документы без истории: разделы 3–4 `docs/architecture.md` | Claude | — | T78 |
| [ ] | T80 | Комментарии общих workflow, действия `toolchain` и `tools/coderules/`, проверка номеров решений | Claude | — | T77 |
| [ ] | T81 | Комментарии `tests/`, `self-` workflow, `justfile` и файлов настроек | Claude | — | T80 |

## Epic E27. Тексты без истории (R160 spec)

**Почему эпик такой.** Строка 7.26 COORDINATION.md spec (R160 spec, R76 spec, R156 spec): текст задачи дал оркестратор (правило 6 COORDINATION.md spec), и правило 11 разделило его на пять задач по одному ревью. Задача живёт только в эпике (R40), поэтому части T77 — задачи этого эпика, а не `run/TASKS.md`: оркестратор берёт их из таблицы 1 после мержа T77. Файлы, после которых выходит релиз (R10), — общие workflow, `.github/actions/` и `tools/coderules/` — меняет одна T80, и с ней включается проверка номеров решений в комментариях: правка номеров и правка комментариев выходят одним релизом, а не двумя (architecture 3.5).

**Не входит:** записи журнала, которые задачи не меняют, — их переписывает задача, что их коснётся (R160 spec; Д14); `.devcontainer/` — копия шаблона (Д13).

#### T78. Документы без истории: вводная и разделы 1–2 `docs/architecture.md`, README, CLAUDE.md

- **Цель:** вводная и разделы 1–2 `docs/architecture.md`, README.md, CLAUDE.md, `docs/README.md`, `profile/README.md` и CONTRIBUTING.md держат текущее устройство, без хроник версий, статусов и повышений (R160 spec).
- **Почему:** строка 7.26 COORDINATION.md spec; R160 spec, «One home» и «A done task»; часть T77 по правилу 11.
- **Сделать:**
  - абзац «Status» `docs/architecture.md` — без хроники эпиков и тегов; документ называет файл, где задано значение — подмодуль `spec/`, `RELEASE_LINE` в `self-release.yml`, теги релизов, — а не значение;
  - архитектура описывает текущее устройство и ссылается на решение номером, не пересказывая его и его поправки;
  - ссылка на поправку записи `spec`, которую тег переписал на месте (R143, R145, R154, R155 spec и те, что перепишут задачи E16 `spec`), — на запись;
  - запись журнала, которую правка меняет, — переписать на месте целиком, поправки внутрь (R160 spec); её предел в `docs-budgets.json` — по новому размеру или убрать, если она уложилась в 12 КБ.
- **Как проверить:** `just -f spec/justfile docs-check-repo`; `/code-review high`.
- **Разделы:** R160 spec; RULES.md spec — The bar; architecture 1, 2.

#### T79. Документы без истории: разделы 3–4 `docs/architecture.md`

- **Цель:** разделы 3 и 4 `docs/architecture.md` — устройство, вызывающие файлы и указатель источников — держат текущее устройство, без хроник версий, статусов и повышений (R160 spec).
- **Почему:** строка 7.26 COORDINATION.md spec; R160 spec; часть T77 по правилу 11.
- **Сделать:** как T78 — для разделов 3 и 4; комментарии вызывающих файлов раздела 3.3 — по R160 spec, «Comments», как комментарии кода; предел раздела 3.3 в `docs-budgets.json` — по новому размеру или убрать.
- **Как проверить:** как T78.
- **Разделы:** R160 spec; architecture 3, 4.

#### T80. Комментарии общих workflow, действия `toolchain` и `tools/coderules/`, проверка номеров решений

- **Цель:** комментарии файлов, после которых выходит релиз, — общих workflow `.github/workflows/` без приставки `self-`, `.github/actions/` и `tools/coderules/` — по R160 spec, «Comments»; в `docs-budgets.json` — `"comments": true`, как в `spec/repo-template/files/docs-budgets.json`, и `docs-check-repo` проверяет номера решений в комментариях кода (R32 spec).
- **Почему:** строка 7.26 COORDINATION.md spec; R160 spec; R32 spec; часть T77 по правилу 11. Номера решений `spec` в этих файлах записаны как `R107 in spec`, и проверка читает их как записи своего журнала: включённая в T77, она дала бы релиз ради одной правки номеров (R10; architecture 3.5).
- **Сделать:**
  - комментарий говорит только то, чего не скажет код: почему, ограничение, ловушка, договор входов и выходов общего workflow и действия; без пересказа кода, истории, номеров задач и разделов документов; номер решения — якорем в конце, `(R25)`, номер `spec` — `(R107 spec)`;
  - каждое `R… in spec` — по `git grep -nE 'R[0-9]+ in spec'`, не по проверке: номер, который есть и в своём журнале, — `R31 in spec`, `R48 in spec`, — она читает как свою запись и пропускает; в строках сообщений `::error::` — та же форма, хоть проверка строк не читает;
  - `tools/coderules/testdata/` — образцы, по которым тесты ждут находки по строкам: правка комментария не меняет числа строк, иначе — и ожидания тестов;
  - `"comments": true` в `docs-budgets.json`;
  - тесты `tests/` берут шаг из файла дословно (R28): набор зелёный;
  - после мержа релиз выходит сам (R10).
- **Как проверить:** `just -f spec/justfile docs-check-repo`; `bash tests/run.sh` с yq по `self-ci.yml` (`.claude/rules/workflows.md`); `ci-lint`, `ci-test`, `ci-vuln` и `ci-licenses` (`.claude/rules/go.md`); `/code-review high`.
- **Разделы:** R160 spec, «Comments»; R32 spec; R10, R28, R33; architecture 3.5.

#### T81. Комментарии `tests/`, `self-` workflow, `justfile` и файлов настроек

- **Цель:** комментарии `tests/`, `.github/workflows/self-*.yml`, `justfile`, `.github/codecov.yml`, `.github/dependabot.yml`, `.github/actionlint.yaml` и `.sonarcloud.properties` — по R160 spec, «Comments»; эти файлы релиза не дают (R10).
- **Почему:** строка 7.26 COORDINATION.md spec; R160 spec; часть T77 по правилу 11.
- **Сделать:** как T80, без релиза: без номеров задач в заголовках случаев `tests/` — «The tests of same-bits (T46 and T47 …)», «the steps T39 changed» —, без пересказа шагов, которые случай проверяет; `R… in spec` в строках — с ожиданиями тестов, что их ищут.
- **Как проверить:** `just -f spec/justfile docs-check-repo`; `bash tests/run.sh` с yq по `self-ci.yml`; `ci-lint`, `ci-test`, `ci-vuln` и `ci-licenses`; `/code-review high`.
- **Разделы:** R160 spec, «Comments»; R28, R33.
