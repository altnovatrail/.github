# RUN.md — work plan of .github

What .github does, does not do and has still to decide — [docs/architecture.md](docs/architecture.md); why — [docs/decisions.md](docs/decisions.md). The platform is in `spec/`, a submodule at tag v0.18.3: the component's card — architecture 3.11 spec; the platform's decisions — spec's log. Small tasks, one at a time, each reviewed by the author; only the current epic is in detail (R19 spec). Other tables, each a file opening with its rules (R153 spec): 2, epics for later — [run/EPICS.md](run/EPICS.md); 3, questions to the author — [run/QUESTIONS.md](run/QUESTIONS.md); 4, debt — [run/DEBT.md](run/DEBT.md).

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
- **Done epics:** E1–E15 and E17–E20, each archived in `docs/plan/E<number>.md`, but for E15, which has none. E16 is taken by the move to v0.9.9, whose epic was deleted (the 2026-11-08 amendment to R34). Task numbers are taken through T66: next — T67.

## Table 1. Current epic — E21. Скорость CI общих workflow

**Результат:** релизы общих workflow по строке 7.13 COORDINATION.md spec — кеш Go в `go.yml`, один файл образа стадии `toolchain`, «Go / targets» матрицей и «Go / fma-diff» параллельно, сверка и подписи `release.yml` параллельно, вход `typescript.yml` для WebKit и Firefox и браузеры договора обёртки (Д217 spec), CodeQL (go) без сборки образа, и последним — стадия `toolchain-core` с тегом `spec` строки 7.14. У каждой задачи — случаи шагов (R28), пробный pull request и решение журнала; вызывающие берут релизы Dependabot или своими задачами строк 7.15–7.25.

| Статус | ID | Задача | Кто | План | Зависит от |
|---|---|---|---|---|---|
| [ ] | T60 | Кеш Go в `go.yml` | Claude | — | — |
| [ ] | T61 | Один файл образа `toolchain` во всех workflow | Claude | да | T60 |
| [ ] | T62 | «Go / targets» матрицей, «Go / fma-diff» параллельно | Claude | — | T61 |
| [ ] | T63 | Сверка и подписи `release.yml` параллельно | Claude | — | — |
| [ ] | T64 | WebKit и Firefox — своей проверкой `typescript.yml` | Claude | да | T61 |
| [ ] | T65 | CodeQL (go) — Go из архива Dockerfile, без образа | Claude | да | — |
| [ ] | T66 | Стадия `toolchain-core` в релизе и проверках | Claude | да | T60–T65; строка 7.14 COORDINATION.md spec |

**Почему такой порядок.** Каждый мерж, что меняет общий workflow, выпускает релиз сам (R10), поэтому порядок задач — порядок релизов. Первым — кеш Go: его ждут строки 7.15–7.21, все репозитории с Go. Затем образ — строки 7.23–7.25, и он меняет те же шаги `go.yml`, что T60, и шаги `typescript.yml`, что T64. Затем цели — строка 7.19 `sim`; сверка релиза — строка 7.15 `api`; движки — строки 7.22 и 7.23, которые ждут и строку 7.14; CodeQL не ждёт никто. `toolchain-core` — последней: её ждёт строка 7.14, T166 spec, которая идёт параллельно.

## Epic E21. Скорость CI общих workflow

**Почему эпик такой.** Слово автора 2026-11-16 (прогон «Сделай эпик» `spec`, T171; R156 spec): ускорение CI — сейчас. Строка 7.13 COORDINATION.md spec, по замеру measurements 3.1 spec, просит у `.github` релиз общих workflow, а Д217 spec — браузеры договора обёртки TypeScript (R19); эпик E21 в `run/EPICS.md` их соединил (R40). Задача — одна проверка из строки 7.13 и одно ревью (правило 11).

**Для каждой задачи.** После мержа релиз выходит сам (R10). Запись о нём — поправкой «the release came out» к решению задачи и SHA в шаблоне architecture 3.3 — первым шагом следующей задачи эпика, а после последней — с архивом эпика. `.devcontainer/` эпик не меняет.

**Не входит:** изменения вызывающих — строки 7.15–7.25 COORDINATION.md spec, задачи их репозиториев; стадия `toolchain-core` в Dockerfile — строка 7.14, T166 spec.

#### T60. Кеш Go в `go.yml`

- **Цель:** job `go.yml` не компилируют зависимости и стандартную библиотеку заново в каждом прогоне: `GOMODCACHE`, `GOCACHE` и `GOLANGCI_LINT_CACHE` приходят из кеша GitHub Actions вызывающего. Это первый релиз эпика: его ждут строки 7.15–7.21 COORDINATION.md spec.
- **Почему:** строка 7.13 COORDINATION.md spec; measurements 3.1 spec — время уходит в компиляцию с пустым `GOCACHE`: домашняя папка контейнера — `/tmp`, и она пропадает с каждым job; `go vet` у `api` — около 80 с, golangci-lint у `tutor` — 36 с холодным и 0,4 с тёплым, а скачивание модулей — секунды.
- **Сделать:**
  1. В каждом job `go.yml`, что строит стадию `toolchain`, — `check`, `targets`, `fma-diff`, `arm64` и `rules` — шаги кеша Go: папка `${{ runner.temp }}/go-cache` восстанавливается по ключу из ОС и архитектуры раннера, проверки, хеша `.devcontainer/Dockerfile` и хеша `go.sum`, а запасной ключ — тот же без `go.sum`. Папка идёт томом в каждый `docker run` job, а `GOMODCACHE`, `GOCACHE` и `GOLANGCI_LINT_CACHE` указывают на её подпапки.
  2. После восстановления — `go mod verify` в каждом модуле вызывающего. Отказ удаляет восстановленное с предупреждением, и job идёт без кеша: сбой стоит скорости, а не вердикта, как у образа (R36).
  3. Сохраняет только push в `main`, после зелёного рецепта и только при промахе точного ключа; pull request и прочие события только читают. `release.yml` кеша не берёт.
  4. Случаи шагов в `tests/go.test.sh` (R28) — с поломками; решение журнала и поправки к R16 и R36; architecture 3.1; measurements — замер на клонах вызывающих и пробный pull request.
- **Как проверить:** `YQ=… bash tests/run.sh` — зелёный; actionlint и shellcheck — job Workflows `self-ci.yml`; пробный pull request, не для мержа: `go.yml` по локальному пути с `same-bits` — промах, затем попадание, `go mod verify` и время job; `just -f spec/justfile docs-check-repo`; `/code-review high`, один круг.
- **Разделы:** строка 7.13 COORDINATION.md spec; measurements 3.1 spec; R16, R36, R39; architecture 3.1.

#### T61. Один файл образа `toolchain` во всех workflow

- **Цель:** у файла образа стадии `toolchain` — один путь и один тег во всех общих и `self-` workflow, те, что даёт скрипт `spec/tools/toolchain/toolchain.sh`: `${{ runner.temp }}/novatrail-toolchain.tar` и образ `novatrail-toolchain`. Pull request файл не сохраняет, а при промахе образ строит один job.
- **Почему:** строка 7.13 COORDINATION.md spec; measurements 3.1 spec — у `app` и `canvas` кеш у предела в 10 ГБ: один ключ сохранён под тремя путями, и сохраняют pull request; у `canvas` при промахе образ строят все job CI разом. Одну запись поправка 2026-11-10 к R36 оставила «своей задачей».
- **Сделать:** `go.yml`, `typescript.yml`, `documents.yml` и `self-ci.yml` — один путь и тег; сохраняет только push в `main`; при промахе — один job строит образ, остальные берут его у него. Разогревающий job R36 отверг — пересмотреть по measurements 3.1 spec поправкой к R36. Случаи шагов (R28); пробный pull request; architecture 3.1, 3.4.
- **Решить при планировании:** как образ доходит до остальных job при промахе в pull request, где сохранять нельзя, — артефакт, ожидание или своя сборка; что делают `documents.yml` и `go.yml`, разные вызовы одного CI, при общем промахе.
- **Как проверить:** как T60.
- **Разделы:** строка 7.13 COORDINATION.md spec; measurements 3.1 spec; R36 и её поправки; R31 spec; architecture 3.1, 3.4.

#### T62. «Go / targets» матрицей, «Go / fma-diff» параллельно

- **Цель:** с `same-bits` цели `targets` — amd64 v3, amd64 v1 с `cpu.all=off`, 386, js/wasm и wasip1 — идут матрицей job, по job на цель, а цели `fma-diff` — параллельно в одном job. Проверка вызывающего «Go / targets» остаётся одна, и наборы правил вызывающих не меняются.
- **Почему:** строка 7.13 COORDINATION.md spec; measurements 3.1 spec — у `sim` цели идут одна за другой, js/wasm — 134 с; строка 7.19 `sim` ждёт эту задачу: без неё релиз `v0.1.24` удлиняет targets тестами wasip1 (R39).
- **Сделать:** матрица и job после неё под именем `targets`, который красный, если красна хоть одна цель; скрипт целей — один для матрицы и `arm64` (R39); `fma-diff` — цели фоновыми процессами, вывод каждой — целиком и по порядку целей; случаи (R28) с поломками; пробный pull request по образцу measurements 2.6; поправка к R39 или своё решение; architecture 3.1.
- **Как проверить:** как T60.
- **Разделы:** строки 7.13 и 7.19 COORDINATION.md spec; R107 spec; R39; architecture 3.1.

#### T63. Сверка и подписи `release.yml` параллельно

- **Цель:** `release.yml` сверяет файлы релиза — `gh release verify-asset` — одним вызовом или параллельно, а подписывает и проверяет подписи — `cosign sign-blob` и `verify-blob` — параллельно. Вердикт тот же: отказ на любом файле — красный шаг с именем файла.
- **Почему:** строка 7.13 COORDINATION.md spec; measurements 3.1 spec — у `api` 282 вызова `gh release verify-asset` подряд, 633 с, и 141 `cosign sign-blob`, около 1,4 с каждый.
- **Сделать:** шаги «Sign every file» и «Verify the release»; берёт ли `gh` раннера много файлов одним вызовом и какой параллелизм выдерживают Sigstore и API GitHub — записи sources по первоисточнику; иначе `xargs -P` с пределом; случаи (R28) с поломками; пробный pull request по образцу measurements 5.3; поправка к R18; architecture 3.1.
- **Как проверить:** как T60.
- **Разделы:** строка 7.13 COORDINATION.md spec; R18; R77 spec; architecture 3.1; measurements 5.

#### T64. WebKit и Firefox — своей проверкой `typescript.yml`

- **Цель:** вход `typescript.yml` включает job движков: тесты вызывающего в WebKit и Firefox — своей проверкой рядом с «TypeScript / test», где Chromium и покрытие. Договор обёртки (R19) называет все три браузера стадии вида `typescript`. Без входа workflow — прежний.
- **Почему:** строка 7.13 COORDINATION.md spec; Д217 spec — WebKit и Firefox в стадии вида `typescript` (T141 spec), а у `.github` — браузеры договора обёртки (R19); measurements 3.1 spec — у `app` два прогона Vitest подряд, 88 с и 120 с; строки 7.22 и 7.23 ждут этот вход.
- **Сделать:** вход, job и рецепт вызывающего для движков; поправка к R19 — договор и браузеры; случаи (R28); пробный pull request по образцу measurements 3.1; architecture 3.1, 3.3.
- **Решить при планировании:** имена входа, проверки и рецепта — договор с `app` и `canvas`; берёт ли job движков `--ipc=host`, как test.
- **Как проверить:** как T60.
- **Разделы:** строка 7.13 COORDINATION.md spec; Д217 spec; R19; architecture 3.1, 3.3.

#### T65. CodeQL (go) — Go из архива Dockerfile, без образа

- **Цель:** анализ go в `codeql.yml` берёт Go из архива go.dev, который называет Dockerfile вызывающего, и проверяет его по sha256 оттуда же, без `docker build` стадии `toolchain`.
- **Почему:** строка 7.13 COORDINATION.md spec; шаг «Go of the caller's toolchain stage» строит всю стадию ради папки `/usr/local/go`, а стадия с браузерами строится 75–85 с (measurements 3.1 spec).
- **Сделать:** версия и сумма — из `ARG GO_VERSION`, `ARG GO_SHA256_AMD64` и `ARG GO_SHA256_ARM64` Dockerfile, имён шаблона `spec/repo-template/kinds/go/`; без них — ошибка с причиной; переменные `GO*` и `CGO_*` из `ENV` стадии — как их брать без образа; случаи (R28); пробный pull request по образцу measurements 1.3; поправка к записи о Go в CodeQL; architecture 3.1.
- **Решить при планировании:** что из `ENV` стадии нужно сборке анализа; Dockerfile, где Go ставится иначе.
- **Как проверить:** как T60.
- **Разделы:** строка 7.13 COORDINATION.md spec; R09 и её поправка 2026-11-08; measurements 1.3; architecture 3.1.

#### T66. Стадия `toolchain-core` в релизе и проверках

- **Цель:** `release.yml` строит стадию `toolchain-core` Dockerfile вызывающего, без кеша, а проверки без браузера и Go-тестов — lint, vuln, licenses и документы — идут в ней; у Dockerfile без этой стадии — как прежде.
- **Почему:** строка 7.13 COORDINATION.md spec — «с тегом `spec` строки 7.14»; строка 7.14 — стадия `toolchain-core` в Dockerfile `spec` и шаблона, T166 spec; measurements 3.1 spec — снимок Ubuntu: «Work out the version» `app` — 391 с, а сборка стадии в релизе `canvas` — 826 с.
- **Сделать:** что даёт тег `spec` строки 7.14 — имя стадии, что в ней, поправка к R31 spec; если `.github` нужен сам тег — переход своей задачей перед этой (RULES.md spec, Across repositories); шаги `release.yml`, `go.yml`, `typescript.yml` и `documents.yml`; ключ и файл образа стадии — по T61; случаи (R28); пробные pull request; решение журнала; architecture 3.1.
- **Решить при планировании:** узнаёт ли workflow стадию по Dockerfile или по входу; какие проверки идут в ней у Go и у TypeScript.
- **Как проверить:** как T60.
- **Разделы:** строки 7.13 и 7.14 COORDINATION.md spec; R31 spec; R18, R36; architecture 3.1.
