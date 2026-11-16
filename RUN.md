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
- **Done epics:** E1–E15 and E17–E21, each archived in `docs/plan/E<number>.md`, but for E15, which has none. E16 is taken by the move to v0.9.9, whose epic was deleted (the 2026-11-08 amendment to R34). Task numbers are taken through T69: next — T70.

## Table 1. Current epic — E22. Составное действие `toolchain`

**Результат:** релиз `.github` с составным действием `.github/actions/toolchain` — образ стадии `toolchain` и кеши Go для своего job вызывающего, тем же действием, что берёт job `arm64` общего `go.yml`. Его ждёт строка 3.11 COORDINATION.md spec — переход `module-kit`.

| Статус | ID | Задача | Кто | План | Зависит от |
|---|---|---|---|---|---|
| [ ] | T69 | Составное действие: образ `toolchain` и кеши Go для своего job вызывающего | Claude | да | — |

**Почему эпик такой.** Строка 2.5 COORDINATION.md spec — по тексту T172 spec и ответу автора на строку `module-kit` В36: вариант 1, составное действие; отвергнуты копия со стражем в каждом вызывающем и вход `go.yml`. Прогон всего «Порядка» оркестратором (R156 spec; слово автора 2026-11-16): одна задача — один релиз.

**Не входит:** переход `module-kit` на действие — строка 3.11, задача `module-kit`; `typescript.yml` и `documents.yml` действие не берут.

#### T69. Составное действие: образ `toolchain` и кеши Go для своего job вызывающего

- **Цель:** job вызывающего репозитория, что идёт в стадии `toolchain`, берёт образ и кеши Go тем же шагом, что общий `go.yml`, а не копией его шагов; pull request Dependabot группы `shared-workflows` проходит сам.
- **Почему:** строка `module-kit` В36, R76 `spec`, строка 2.5 COORDINATION.md `spec`; T172 `spec`. «Binaries / build» `module-kit` копирует шесть шагов job `arm64` общего `go.yml`, и страж держит копию у закреплённого `go.yml` (R58, R61 module-kit): переход `.github`, что их меняет, красит обязательную проверку, пока сессия не поправит копию.
- **Сделать:** составное действие в `.github` — образ `toolchain` из кеша по ключу общих workflow, кеши Go (`GOMODCACHE`, `GOCACHE`) из кеша, их сохранение только на push в `main`; общий `go.yml` сам берёт это действие, чтобы шаги не расходились; вызывающий берёт его по SHA, и Dependabot двигает его в группе `shared-workflows`; решение в журнале `.github`; релиз.
- **Как проверить:** проверки `.github` по его RUN.md; пробный вызов из репозитория с своим job в `toolchain` — зелёный, кеши попадают.
- **Разделы:** строка 2.5 COORDINATION.md `spec`; R31, R48, R76 `spec`; строка `module-kit` В36.
- **Выяснилось при планировании:**
  - составное действие не знает шага `post` (sources 2.12): сохранение кешей Go — второй вызов того же действия в конце job, с `save: "true"`;
  - `go.yml` берёт действие своего же коммита ссылкой `$/` — она указывает на репозиторий файла, где стоит, на выполняемом коммите, и checkout не нужен (sources 2.12); политика организации `sha_pinning_required` её пропускает, actionlint 1.7.12 её не знает, Scorecard v5.6.0 считает закреплённой (measurements 12.2; sources 6.4);
  - Dependabot читает `action.yml` только в названных каталогах (sources 4.1), а dependabot-core зовёт ссылку вызывающего `altnovatrail/.github/.github/actions/toolchain` — её берёт группа `shared-workflows` (sources 4.2).
- **Решено при планировании** (исполнитель оркестратора; документы не отдают этого автору — R156 spec): действие `.github/actions/toolchain` со входами `check` и `save`; на действии — только job `arm64`, остальные job `go.yml` берут образ артефактом job `toolchain`, и набор держит их шаги равными шагам действия; сохранение заново спрашивает кеш по тому же ключу без скачивания; отвергнуты checkout `.github` в рабочую папку, JavaScript-действие с `post` и передача ключа файлом (R49).
- **Сделано (2026-11-16):**
  - [.github/actions/toolchain/action.yml](.github/actions/toolchain/action.yml) — «Toolchain image and Go caches»: без `save` — образ `toolchain` из кеша или сборка с сохранением только на push в `main`, кеши Go по ключу с `check` и `go mod verify`; с `save: "true"` — на push в `main` поиск того же ключа без скачивания и сохранение при промахе. Скрипты — байт в байт шаги `go.yml`;
  - [go.yml](.github/workflows/go.yml): job `arm64` — действие `$/.github/actions/toolchain` с `check: arm64` вместо шести шагов и им же сохранение; ключи и записи прежние. [self-release.yml](.github/workflows/self-release.yml) выпускает релиз и на изменение `.github/actions/`; [dependabot.yml](.github/dependabot.yml) читает каталог действия и группирует по зависимости; [actionlint.yaml](.github/actionlint.yaml) снимает жалобу на `$/` в `go.yml`;
  - набор (R28): `use_action` в `tests/lib.sh`; 221 тест, 4 новых и 6 изменённых; десять поломок — каждая красная (measurements 12.2); actionlint 1.7.12 и ShellCheck 0.11.0 — чисто;
  - пробный pull request [#137](https://github.com/altnovatrail/.github/pull/137), не для мержа: `go.yml` по SHA с `same-bits` — `$/` разрешился в действие того же коммита, `arm64` собрал образ и прошёл `ci-test` с кешами; два своих job по SHA действия — попадание образа main, во втором попадание кешей Go, `go mod verify`, сборка без компиляции (measurements 12.2);
  - решение [R49](docs/decisions.md) и поправки к R04, R10, R28, R41, R42; architecture 1, 3.1, 3.4, 3.5; sources 2.12, 4.1, 4.2, 6.4; CLAUDE.md и правило `.claude/rules/workflows.md`; строка В41 «в реестр spec» — карточка architecture 3.11 spec.
- **Открыто:**
  - после мержа релиз выходит сам (R10), ожидается `v0.1.32`: его тег и SHA — поправкой к R49 и в тексте architecture 3.1; затем T69 — `[x]`, тело — в архив E22, эпик E22 — в архив. Этот релиз ждёт строка 3.11 COORDINATION.md spec (`module-kit`);
  - сохранение кешей вторым вызовом идёт только на push в `main`: его впервые прогонит первый push в `main` вызывающего с `same-bits` или `module-kit` после строки 3.11;
  - В41 — «в реестр spec».
