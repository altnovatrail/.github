# RUN.md — work plan of .github

What .github does, does not do and has still to decide — [docs/architecture.md](docs/architecture.md); why — [docs/decisions.md](docs/decisions.md). The platform is in `spec/`, a submodule at tag v0.19.20: the component's card — architecture 3.11 spec; the platform's decisions — spec's log. Small tasks, one at a time, each reviewed by the author; only the current epic is in detail (R19 spec). Other tables, each a file opening with its rules (R153 spec): 2, epics for later — [run/EPICS.md](run/EPICS.md); 3, questions to the author — [run/QUESTIONS.md](run/QUESTIONS.md); 4, debt — [run/DEBT.md](run/DEBT.md).

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
5. A fact no run checks — a law, terms, a price, a license, a page or an answer of an API with no version — from the primary source, with quote and date read, as a record of `docs/sources.md`, kept by its opening (RULES.md); documentation or code at a version or commit — a link beside the claim; a behaviour a test or a measurement checks — they are its evidence; spec's tags and NovaTrail's and MathTrail's files — git at a commit. What is not confirmed is not stated: it becomes an open question.
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

**Citations** — by `spec/RULES.md`: a task's number and a dated line stand only here, in `run/` and in `docs/plan/`; outside them a text cites no decision and no section, and only a fact no run checks, or a measurement, cites its record — `sources 2.1` or `measurements 1.1`, spec's `sources 2.3 spec`. spec's open questions — «Т-22», «П-7», «О-2» — stand anywhere: the repository keeps no registers. A task — «T03», from another repository «T03 .github»; one not here is in an archive: `grep -n '^#### T03\.' RUN.md docs/plan/*.md`. Task numbers are global and never reused: take the one free when writing it down.

## Epics

- **Table 1** is the current epic: its tasks in detail, run one at a time.
- **Next epic.** Once table 1 is all checked, the author picks the next epic from [run/EPICS.md](run/EPICS.md) and splits it with Claude in plan mode into tasks of one review each, into table 1 and this file.
- **A done epic** goes to `docs/plan/<epic>.md` (R59 canvas-api): bodies and gist sentences are there already (rule 9); move its description and table of tasks verbatim; questions and debt stay in `run/`; until the next epic, table 1 reads «Current epic — none» and names the last done epic; measure the epic's sessions — `just -f spec/justfile tokens-report --since <first day of the epic> --row` — as a row of measurements 11.2; past the threshold of R145 spec, an epic of analysis into [run/EPICS.md](run/EPICS.md). Never read an archive whole: take the task cited.
- **Done epics:** E1–E15 and E17–E30, each archived in `docs/plan/E<number>.md`, but for E15, which has none. E16 is taken by the move to v0.9.9, whose epic was deleted (R34). Task numbers are taken through T99: next — T100.

## Table 1. Current epic — E31. Тег `spec` v0.19.20 и записи `sources` по его правилу

**Результат:** `.github` на теге `spec` v0.19.20, и `docs/sources.md` — по правилу записей его `spec/RULES.md`: запись — только у того, что прогон не проверит или у чего нет версии; остальное — ссылка на месте с версией или коммитом, тест или `measurements`; теги `spec` и файлы репозиториев NovaTrail и MathTrail — git (строка 7.62 COORDINATION.md spec).

| Статус | ID | Задача | Кто | План | Зависит от |
|---|---|---|---|---|---|
| [x] | T96 | Тег `spec` v0.19.20; `sources`: вводная, теги `spec`, файлы репозиториев, ссылки на записи `spec` | Claude | — | — |
| [x] | T97 | `sources` по правилу записей, часть 2: GitHub Actions | Claude | — | T96 |
| [x] | T98 | `sources` по правилу записей, часть 3: GitHub, Dependabot, CodeQL, Scorecard, Sigstore | Claude | — | T97 |
| [ ] | T99 | `sources` по правилу записей, часть 4: npm, Node и браузеры, Go и Codecov, инструменты проверок | Claude | — | T98 |

**Почему эпик такой.** Задача живёт только в эпике (R40), а текущего эпика не было: E30 в архиве. Текст задачи дал оркестратор по строке 7.62 COORDINATION.md spec, по тексту T291 `spec`; пересмотр `docs/sources.md` (1000 строк, 162 КБ, около 300 ссылок на записи вне `docs/plan/`) больше одного ревью, и по правилу 11 его остаток разбит по темам на T97–T99. Строка 7.62 ждёт всех четырёх. T97–T99 — одного репозитория подряд и не ждут другого: могут идти пачкой на одной ветке с одним pull request, как их даст оркестратор.

**Общее для T97–T99** — правило записей `spec/RULES.md` («The bar», «Citations») и раздел 1 `docs/sources.md`; R171 `spec`:
- свернуть повторные чтения записей своих тем до текущего: текст тот же — одна дата; другой — утверждения и решения переписать в той же правке, а где решение ждёт автора — строка `run/QUESTIONS.md`, и оба чтения стоят;
- запись остаётся у условий, политик, лицензий, у страницы без версии и ответа API или реестра, которых прогон не проверит, у открытого issue и чужой практики;
- документация GitHub — ссылка на месте на `github/docs` на коммите (файл `content/…`, проверить, что текст держит утверждение); документация и код действий и инструментов — ссылка на тег или коммит, который запись уже называет; поведение под тестом `tests/` или записью `measurements` — ссылка на них; запись удалить;
- перед удалением записи — `git grep -nE "sources N\.M\b" -- . ':!docs/plan' ':!spec'` пусто; номера не переиспользовать, у темы — строка, где теперь её факты; архивы `docs/plan/` не трогать; смысл утверждений не менять;
- бюджет записи журнала, которую ссылки удлинили, — `docs-budgets.json`, с причиной в коммите.

#### T99. `sources` по правилу записей, часть 4: npm, Node и браузеры, Go и Codecov, инструменты проверок

- **Цель:** записи тем 8–11 `docs/sources.md` (8.1–11.5, около 70 ссылок вне `docs/plan/`) — по правилу записей `spec/RULES.md` тега v0.19.20; на ней строка 7.62 «Порядка» сделана.
- **Сделать:** по «Общему для T97–T99» выше, для тем 8–11: документация и код npm, ответы реестра npm, открытые баги `npm/cli`; Node, Playwright, Vitest и istanbul, OSV-Scanner, Docker, Ubuntu Snapshot; Go, go-licenses, Codecov; gitleaks, actionlint и ShellCheck, yq и bats-core, just, git. Лицензии и условия — записи; ответы реестра, которых прогон не проверит, — запись; sha256 архивов держит `ARG` Dockerfile, который их проверяет.
- **Как проверить:** `just -f spec/justfile docs-check-repo` и проверки частей, чьи файлы задеты, — зелёные; размер `docs/sources.md` до и после — в отчёт, и от начала эпика — 162 318 байт до T96.
- **Разделы:** `spec/RULES.md`, «The bar» и «Citations»; R171 `spec`; раздел 1 и темы 8–11 `docs/sources.md`; строка 7.62 «Порядка» COORDINATION.md spec.
