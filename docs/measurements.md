# .github — замеры

> Итоги замеров `.github`: что измерено, как, на чём и какие вышли числа — пробные pull request и их прогоны, шаги, вынутые из файлов и прогнанные отдельно, набор тестов шагов и его порчи, длительности и размеры. Документ, который описывает устройство, — [architecture.md](architecture.md) — ссылается сюда и сам чисел замеров не держит, а новая запись журнала называет замер, а не его числа (R143 spec). Числа, которые записи журнала держали до T55, остаются в них: решение не переписывается. Замер цитируется по разделу, как любой документ: `measurements 1.1`, а из другого репозитория — `measurements 1.1 .github`.
>
> Внешний факт, на котором стоит замер, — запись [sources.md](sources.md), и замер её называет. Каждый замер — абзац «Измерено <дата> (<решение или задача>):» и пункты под ним. Замеры 1.1–9.1 — из прежнего раздела «Источники», architecture 4, 2026-11-12 (T55), дословно, а 10.1 — сверка самой T55; новый замер — запись в конце своей темы, новая тема — в конце файла, и номер записи не меняется.

## 1. Общие проверки

### 1.1. CodeQL: пробы #9 и #10

Измерено 2026-10-20 (R09):
- **бандл CodeQL** (sources 5.1) — прогон на pull request #10: «'tools: linked' was requested, so using CodeQL version 2.27.2, the version shipped with the Action»;
- **проверка находок** (sources 5.2) — на pull request #10 эта проверка называется «CodeQL», её ставит приложение `github-advanced-security` (id 57789): «No new alerts in code changed by this pull request»;
- **проверки пропущенной матрицы** — пробный pull request #9: `self-codeql.yml` передал `go`, «CodeQL / languages» упала, а за анализы пришла одна проверка, «CodeQL / analyze (${{ matrix.language }})», пропущенная; проверки «CodeQL / analyze (actions)» не было.

### 1.2. Исключения CodeQL: пробы #19 и #20

Измерено 2026-10-20 (поправка к R09, T14):
- **экстрактор Actions и `paths-ignore`** (sources 5.3) — в первом прогоне пробы #19 job анализа `actions` писал «LGTM_INDEX_FILTERS set. Using the default filters together with the user-provided filters». Поэтому `codeql.yml` отдаёт `config` только анализам языков вызывающего;
- **пробный pull request #19**, без мержа. `self-codeql.yml` передал `javascript-typescript` и `paths-ignore: trial/**`, а в `trial/sample.html` лежал DOM XSS:
  - когда весь JavaScript был в исключённой папке, анализ упал: «CodeQL could not process any code written in JavaScript/TypeScript»;
  - с файлом вне `trial/` и со входом анализ JavaScript дал 0 результатов;
  - без входа — находку `js/xss` уровня high в `trial/sample.html`, и проверка «CodeQL» от GitHub Advanced Security стала красной;
- **пробный pull request #20**, без мержа, — то же после того, как `config` перестал доходить до анализа `actions`. Строка-комментарий пропущена, конфигурация — `paths-ignore: ["trial/**"]`, а анализ JavaScript дал 0 результатов. Анализ `actions` писал «LGTM_INDEX_FILTERS not set. Using the default filters»: конфигурации он не получил.

### 1.3. Go в CodeQL: проба #30

Измерено 2026-10-21 (поправка к R09, T19):
- **пробный pull request #30**, без мержа: `codeql.yml` ветки T19, `self-codeql.yml` с `languages: go`, Go 1.27.3 в стадии `toolchain`, как у `module-kit`, и модуль Go в корне. С командой из запроса «CodeQL / analyze (go)» прошёл — журнал называет `go version go1.27.3 linux/amd64`, — а проверка «CodeQL» от GitHub Advanced Security упала на находке go/command-injection уровня critical, `trial/main.go:11`. С постоянной командой анализ Go дал 0 результатов, и «CodeQL» зелёная.

### 1.4. gitleaks без `--log-opts`

Измерено 2026-10-20 (R08):
- **gitleaks без `--log-opts`** читает все ветки, а не только историю проверяемого коммита: локальная проба 2026-10-20 — ключ в другой ветке нашёлся без `--log-opts` и не нашёлся с `--log-opts=HEAD`.

## 2. Обёртка Go

### 2.1. Список лицензий: go-licenses и шаг `self-ci.yml`

Измерено 2026-10-21 (R16):
- **`--allowed_licenses`** (sources 10.2) — локальная проба 2026-10-21, рецептом `ci-licenses` заготовки `module-kit` с go-licenses v2.0.1: со списком `ALLOWED_LICENSES` — зелёный, со списком из одной MIT — «Not allowed license 'Apache-2.0' found for library 'github.com/altnovatrail/module-kit/cmd/module-kit'», без списка рецепт останавливается сам;
- **список `spec`** (sources 12.2) — проба шага «The license list of go.yml» 2026-10-21: с этим списком — зелёный, без Unlicense и с лишней MPL-2.0 — красный, с разницей.

### 2.2. pathspec перечня `paths`

Измерено 2026-11-01 (R25, T31):
- **pathspec `paths`** — git 2.56.0, проба во временном репозитории: `git diff --name-only` с `'*.go' ':(exclude)*_test.go'` и остальным перечнем вида go нашёл `main.go` в корне и `cmd/x/a.go`, без `*_test.go`, `docs/` и `ci.yml`. С `'**/*.go'` — только `cmd/x/a.go`: без магии `glob` `*` в pathspec совпадает и с `/`, а `**/` требует косой черты.

### 2.3. Вход `same-bits`: проба #97

Измерено 2026-11-08 (поправка 2026-11-08 к R16, T46):
- **локально**, Go 1.27.3 и Node 24.21.0 devcontainer, на клоне `learner-model` 50f1b51: скрипт `targets`, вынутый yq из `go.yml`, — шесть прогонов, все «ok», 27 с, а с пакетом, чей тест требует 64-битного `uint`, — «FAIL» при `GOARCH=386` и выход 1. Скрипт `fma-diff` — «ok» на шести целях, 27 с, а с пакетом `a*b + c` — «the compiler fuses in …/zzfused» на каждой и выход 1;
- **проба** — pull request [#97](https://github.com/altnovatrail/.github/pull/97), без мержа: `go.yml` по локальному пути с `same-bits: true` на пробном модуле. С пакетом, где каждое произведение идёт через `float64()`, — все семь «Go / …» зелёные, «Go / targets» — 1 мин 8 с, «Go / fma-diff» — 30 с. С пакетом `a*b + c` и тестом 64-битного `uint` — «Go / targets» красная на `GOARCH=386`, «Go / fma-diff» называет пакет на шести целях, а пять прежних проверок зелёные;
- **набор** (R28) — 125 тестов, из них 11 новых, со стабом `go`. Шаг испорчен десятью способами — без GOAMD64 v3, без `cpu.all=off`, без `go vet` wasip1, без «fmahash triggered», без сравнения ассемблера, без цели, без контроля, контроль без объединения, job без условия входа, `docker run` без `-i`, — и каждая порча дала красный набор. ShellCheck 0.11.0 и actionlint 1.7.12 — чисто;
- **после ревью** `fma-diff` отличается от рецептов в трёх местах. Сборка идёт с `-o /dev/null`: без него `go build` главного пакета пишет бинарник в checkout и падает, если там папка с его именем, — проба на Go 1.27.3: «build output … already exists and is a directory» без `-o`, ассемблер и выход 0 с ним, у главного пакета и у библиотеки. Список пакетов `go list` даёт для каждой цели, после `GOOS` и `GOARCH`: ограничения сборки могут убрать пакет из цели. А пакет, который не собирается, красит свою цель, но остальные пакеты и цели проверяются дальше. На клоне `learner-model` исправленный скрипт — «ok» на шести целях. Ещё три порчи — без `-o /dev/null`, сборка, которая обрывает скрипт, без контроля после правки, — тоже дали красный набор.

### 2.4. Job `arm64`: проба #99

Измерено 2026-11-08 (поправка 2026-11-08 к R16, T47):
- **проба** — pull request [#99](https://github.com/altnovatrail/.github/pull/99), без мержа, как #97. С чистым модулем все восемь «Go / …» зелёные, «Go / arm64» — 58 с: стадия `toolchain` собрана под aarch64 — суммы Node, just, Go и buf для arm64 сошлись, — а затем `ci-test`, `GODEBUG=cpu.all=off`, js/wasm и wasip1. С тестом, который падает только при `runtime.GOARCH == "arm64"`, красная одна «Go / arm64», на `ci-test`;
- **набор** (R28) — 128 тестов, из них 3 новых. Харнесс принимает и `ubuntu-24.04-arm`: шаги со стабами от архитектуры машины не зависят. Порча — job на `ubuntu-24.04`, без условия входа, другой рецепт вместо `ci-test` — каждая дала красный набор.

### 2.5. Инструмент правил кода: пробы #103 и #104

Измерено 2026-11-08 (R33, T48):
- **путь модуля** `github.com/altnovatrail/.github/tools/coderules` — `go mod init` его принимает, Go 1.27.3, а профиль покрытия называет файлы этим путём: «github.com/altnovatrail/.github/tools/coderules/check.go:…». На pull request #103 `codecov/patch` пришёл зелёным, правило Codecov по умолчанию сопоставило пути, и `fixes` не нужны;
- **локально**, Go 1.27.3: инструмент на клонах `learner-model` и `engine` со списками из их `rules_test.go` и `nested-modules: [".devcontainer/gopls"]` — 0 находок, по секунде каждый. С файлом, где импорт `os`, `a*b + c` и горутина, — три находки и выход 1;
- **набор Go инструмента** — `TestControls` по обоим контролям, `TestEveryRuleIsBroken`, `TestTheListsDecide` и `TestTheCodeImportsDecide`, чтение списков, `run`, модули, которые не прочесть, и находки до ошибки. Покрытие — 94,6 %. После ревью: находки, собранные до ошибки типов, печатаются вместе с причиной, а ошибка типов на хосте частое следствие нарушенного правила `buildtag`; цикл импортов — ошибка, а не бесконечная рекурсия; `require ()` — пустой блок, а не модуль. Пять порч — без `test-math`, без `requires`, без проверки вложенных модулей, без `nested-modules`, импорты тестов в коде — роняют тесты;
- **набор шагов** (R28) — 135 тестов: кейсы job `rules` и шага «Work out the version» `self-release.yml`, со стабом `gh release view`. Порча — без переноса checkout, без проверки списков, инструмент с `main`, том инструмента с записью, инструмент без релиза — каждая роняет набор;
- **actionlint 1.7.12** не знает `job.workflow_repository` и `job.workflow_sha`: «property "workflow_repository" is not defined in object type». Оба контекста описывает документация GitHub (sources 2.2). Исключение в `.github/actionlint.yaml` — только эти две жалобы и только для `go.yml`, как у `job.workflow_ref` для `release.yml`;
- **go-licenses 2.0.1** без исключения: «Did not find license for library 'github.com/altnovatrail/.github/tools/coderules'»; с `--ignore` модуля — выход 0;
- **SonarCloud** на #103 сначала держал мерж: «new_duplicated_lines_density» 14,1 % при пороге 3 %, а дублировались только `control.go` и `control_test.go` двух контролей, 96 и 19 строк. С `sonar.cpd.exclusions=tools/coderules/testdata/**` — зелёный;
- **проба** — pull request [#104](https://github.com/altnovatrail/.github/pull/104), без мержа: `go.yml` по локальному пути с `same-bits` на пробном модуле со своими `.github/coderules.json`. С кодом, который держит правила, — все «Go / …» зелёные, «Go / rules» — 31 с, с инструментом того же коммита. С кодом, где импорт `os`, `a*b + math.Exp(c)` и горутина, — «Go / rules» красная, ровно с четырьмя находками: `import`, `fused`, `math`, `goroutine`. На #103 сам `.github` прошёл «Go / lint», «Go / test», «Go / vuln», «Go / licenses», «Go / coverage», «CodeQL / analyze (go)» — автосборке Go не помешали `go.mod` контролей — и `codecov/patch`.

## 3. Обёртка TypeScript

### 3.1. Пробы #40 и #42

Измерено 2026-10-21 (R19):
- **пробный pull request #40**, без мержа, прогоны 39660777454 и 39661168027. `self-typescript-trial.yml` позвал `typescript.yml` по локальному пути на пакете в корне: TypeScript 7.0.2, Vitest 5.0.5 с `@vitest/browser-playwright` 5.0.5 и Playwright 1.64.1; lock-файл версии 3, 100 пакетов, построен npm 11.19.0. Стадия `toolchain` — с `/ms-playwright` из образа Playwright (sources 9.2) и 24 пакетами `apt`: 21 библиотекой Chromium и `libfontconfig1`, `libfreetype6`, `fonts-liberation`. Итог:
  - «TypeScript / lint», «/ test», «/ vuln» и «/ licenses» зелёные. `tsc --noEmit` прошёл. В Node прошёл 1 тест, в «browser (chromium)» — 1 тест: рисунок на `<canvas>` прочитан по пикселю. `npm audit` ответил «found 0 vulnerabilities», проверка лицензий — «100 packages, 0 refused», с исключением для `lightningcss` и 11 его сборок под платформы — MPL-2.0, dev;
  - без исключения «TypeScript / licenses» красная — «100 packages, 12 refused», — а остальные три зелёные;
  - шаг «Toolchain image» с браузерами занял 49–52 секунды в каждом из четырёх job. Без браузеров тот же шаг — 21 секунда: job «Documents», прогон CI 39649619270 на `main`;
  - «Documents / docs-check-repo» прошла и на стадии с браузерами;
- **проба #42**, без мержа, прогон 39664766549: коммиты #40 из `refs/pull/40/head` и обёртка после ревью, где `--ipc=host` есть только у job `test`. Все четыре «TypeScript / …» зелёные, тест прошёл в Chromium headless, а стадия с браузерами собралась за 46–56 секунд на job. Job «Workflows», прогон CI 39664737696, нашёл обе копии списка равными списку `spec`.

### 3.2. Шаг «Toolchain image» у `canvas`

Измерено 2026-10-21 (поправка к R19):
- **цена** — прогон CI 39690774485, pull request #18 `canvas`, коммит 5d118a4 (API GitHub). Шаг «Toolchain image» — 57 секунд у «TypeScript / test» и «/ vuln», 59 — у «/ lint», 61 — у «Documents / docs-check-repo» и 67 — у «/ licenses». Без браузера тот же шаг — 18 секунд, у Documents на `main` `canvas` 7756744 (R13 canvas).

### 3.3. Рецепты лицензий `spec`: проба #58

Измерено 2026-10-22 (R22, поправки к R16 и R19, T26):
- **код рецепта на lock-файле пробы #40**, 100 пакетов. С одним исключением `lightningcss` `main.mjs` v0.2.17 отвечает «11 problems», а v0.2.18 — «ok — 100 packages, 1 exceptions». Без исключения оба отвечают «12 problems»;
- **проба #58**, без мержа: ветка T26 и пакет #40 из `refs/pull/40/head`, где `ci-licenses` — `just -f spec/justfile licenses-check-repo package-lock.json licenses.json`, а в `licenses.json` — одно исключение `lightningcss`.
  - Прогоны 39724151192 и 39724151255 — всё зелёное. В job `licenses` checkout сделал `git submodule update --init --force --depth=1`, и рецепт ответил «licenses-check: package-lock.json: ok — 100 packages, 1 exceptions». В job `lint`, `test` и `vuln` прошёл `test ! -e spec/justfile`. «Workflows»: «go.yml allows the 10 licenses spec allows.» и «typescript.yml allows the 10 licenses spec allows.», а шаг «Toolchain image» со стадией пробы, с браузерами, занял 47 секунд;
  - 39724390663, `licenses.json` пустой: «licenses-check: package-lock.json: 12 problems», первая — «lightningcss@1.33.0: MPL-2.0 is not on the allowed list»;
  - 39724578660, lock-файл версии 1: «the lock file has no packages, lockfileVersion 1: a lock file of npm 7 or later is read, one of npm 5 or 6 is refused»;
  - 39724757498, копия lock-файла, где `lightningcss` не `dev`: «lightningcss@1.33.0: the exception takes MPL-2.0 for a tool of development, and the lock file does not mark this package dev», всего 12 отказов;
  - 39725131862, в `ALLOWED_LICENSES` `typescript.yml` нет `0BSD`: «ALLOWED_LICENSES in typescript.yml is not the list spec's licenses-allowed prints.», в разнице — «< 0BSD». «TypeScript / licenses» в прогоне 39725131895 при этом зелёная: «ok — 100 packages, 1 exceptions»;
- **локально** — шаг «The license lists of go.yml and typescript.yml», вынутый из файла дословно, с подменой docker, которая запускает команду в папке, смонтированной в `/work`. Равные копии — зелёный. Копия, которая разошлась, и копия без строки `ALLOWED_LICENSES` — красный с именем файла. Пустой вывод рецепта, строка не идентификатора и упавший рецепт — тоже красный.

### 3.4. Без копии списка: проба #65

Измерено 2026-10-22 (поправка к R19, T29):
- **проба #65**, без мержа: ветка T29 и пакет пробы #58 из 9027580, а каждый `ci-*` начинается с `test -z "${ALLOWED_LICENSES+x}"`. Прогоны 39817202719 и 39817202674 — всё зелёное. `docker run` во всех четырёх job — с `--env HOME=/tmp --env CI`, и проверка переменной прошла в каждом. `ci-licenses` ответил «licenses-check: package-lock.json: ok — 100 packages, 1 exceptions», а `lint`, `test` и `vuln` прошли и `test ! -e spec/justfile`. «Workflows» сверила одну копию: «go.yml allows the 10 licenses spec allows.»;
- **локально** — шаг «The license lists of the workflows», вынутый из файла дословно, с подменой docker, как в T26, семь случаев:
  - как есть — зелёный, и сверяется только `go.yml`;
  - копия `go.yml`, которая разошлась, и `go.yml` без строки — красный, с именем `go.yml`;
  - ещё один workflow с копией, которая разошлась, и такая же копия, снова вписанная в `typescript.yml`, — красный, с именем файла;
  - пустой вывод рецепта и упавший рецепт — красный.

  Рецепт `ci-licenses` пробы с `ALLOWED_LICENSES` в окружении останавливается на проверке переменной, а без неё проходит.

## 4. Загрузка покрытия

### 4.1. Проба #80

Измерено 2026-11-01 (поправки 2026-11-01 к R16 и R19, T34):
- **права в reusable workflow** (sources 2.1) — проба #80 показала, что прогон не стартует вовсе: `startup_failure`, ни одного job. Не пошёл и job «TypeScript» того же workflow, у которого право было. Причина — на странице прогона 41345286177: «The nested job 'coverage' is requesting 'id-token: write', but is only allowed 'id-token: none'.»;
- **пакет Go без тестов** (sources 10.1) — в пробе пакет `untested` без тестов лёг в профиль с нулём;
- **пути в Codecov** — правило по умолчанию для путей импорта Go (sources 10.3) проба подтвердила: так легли `sum.go` и `untested/untested.go` ниже, в «проба #80»;
- **проба #80** — pull request без мержа, закрыт 2026-11-01:
  - b5cf941 — модуль Go `github.com/altnovatrail/trial` и пакет TypeScript с коммитов #65, без браузера, в корне. Один `justfile` на обе обёртки и `self-coverage-trial.yml`, который зовёт их по локальному пути с `id-token: write`. Прогон 41345104353: все проверки зелёные, а job `coverage` шли по 7–8 секунд. Обе загрузки получили токен OIDC — «Upload queued for processing complete». `codecov/patch` пришёл от приложения Codecov, `app id` 254, успехом — «No report found to compare against»: на `main` `.github` отчёта нет. Codecov слил оба отчёта в один, на 4 файла: `sum.go` и `untested/untested.go` — из путей импорта, `trial/sum.ts` и `trial/untested.ts` — из lcov, а непокрытые — с нулём (API Codecov);
  - b3ca2c8 — job «Go» без `id-token: write`: `startup_failure`, выше;
  - 309a6ff — `ci-test` без профиля Go. «Go / test» красная: «No files were found with the provided path: coverage/go.out. No artifacts will be uploaded.» «Go / coverage» пропущен, а сторона TypeScript загрузилась своим путём.

## 5. Общий релиз

### 5.1. Вызов рецептов just

Измерено 2026-10-20 (R14):
- **`just --dry-run`** (sources 11.4) — проба 2026-10-20 на `spec/justfile` v0.2.11: вызов `release-refusal` с тремя аргументами выходит с 0 и ничего не запускает. Тот же вызов к копии justfile, где рецепт назван иначе или ждёт четыре параметра, выходит с 1: «justfile does not contain recipe `release-refusal`» и «recipe `release-refusal` got 3 positional arguments but takes 4». Так же отвечает шаг номера `self-release.yml`, вынутый дословно и запущенный с этими копиями.

Измерено 2026-11-02 (поправка 2026-11-02 к R18, T41):
- **just** 1.58.0, рецепт `release-files version previous:`: `just release-files v0.1.9 ""` — «version=[v0.1.9] previous=[]»; `just release-files v0.1.9` — «error: recipe `release-files` got 1 positional argument but takes 2». Рецепт `release-files version:` на `just release-files v0.1.9 ""` — «error: justfile does not contain recipe ``», а на `just release-files v0.1.9 /previous/module-index.json` — «error: justfile does not contain recipe `/previous/module-index.json`».

### 5.2. Проба #33 и первый релиз `module-kit`

Измерено 2026-10-21 (R18):
- **пробный pull request #33**, без мержа, прогон 39618440702. `self-release-trial.yml` позвал общий `release.yml` с `publish: false`: номер — `v0.1.4`; файлы — `SHA256SUMS` и пробная программа для linux amd64 и arm64, собранные в стадии `toolchain`; все три bundle — «Verified OK»; релиза нет. Сертификат:
  - SAN и Build Signer URI (1.3.6.1.4.1.57264.1.9) — `https://github.com/altnovatrail/.github/.github/workflows/release.yml@refs/pull/33/merge`;
  - Build Config URI (1.18) — `…/.github/workflows/self-release-trial.yml@refs/pull/33/merge`, то есть workflow вызывающего;
  - Source Repository URI (1.12) — `https://github.com/altnovatrail/.github`;
  - Build Signer Digest (1.10), Source Repository Digest (1.13) и Build Config Digest (1.19) — коммит прогона, `GITHUB_SHA`;
  - Build Trigger (1.20) — `pull_request`.

  У прогона по `workflow_run` `GITHUB_SHA` — вершина основной ветки (sources 2.2, «контекст `workflow_run`»), и Source Repository Digest назвал бы её, а не коммит релиза, если бы релизом был более старый коммит. Поэтому `release.yml` подписывает только `TARGET`, равный `GITHUB_SHA`, и `verify-blob` сверяет это флагом `--certificate-github-workflow-sha`.
- **первый релиз `module-kit`**, `v0.1.0`, прогон 39636884292, коммит 7e0144a. Его `release.yml` зовёт общий по SHA `v0.1.4`. Девять файлов, у каждого свой bundle; `cosign verify-blob` 3.1.4 — «Verified OK» у всех, `gh release verify` и `verify-asset` проходят. Сертификат bundle `SHA256SUMS`:
  - SAN и Build Signer URI (1.9) — `https://github.com/altnovatrail/.github/.github/workflows/release.yml@11435dbe61d3d4885c9a8dd30686e8111e26cabb`, то есть общий workflow по SHA релиза `.github`;
  - Build Signer Digest (1.10) — 11435db, коммит `.github`;
  - Source Repository URI (1.12) — `https://github.com/altnovatrail/module-kit`;
  - Source Repository Digest (1.13) и Build Config Digest (1.19) — 7e0144a, коммит тега;
  - Build Config URI (1.18) — `https://github.com/altnovatrail/module-kit/.github/workflows/release.yml@refs/heads/main`;
  - Build Trigger (1.20) — `workflow_run`; Run Invocation URI (1.21) — `https://github.com/altnovatrail/module-kit/actions/runs/39636884292/attempts/1`.

### 5.3. Скрипт `spec` в релизах: пробы #49 и #50

Измерено 2026-10-22 (поправки к R10 и R18, T25):
- **проба #49**, без мержа, прогоны 39703233909, 39703354477 и 39703423312. `self-release-trial.yml` позвал общий `release.yml` T25 по локальному пути с `publish: false`, а `justfile` в корне дал `release-files`, который пишет один файл:
  - 39703233909: скрипт собрал `novatrail-toolchain`; «version=v0.1.6», «previous=v0.1.5», «releasing v0.1.6 at 9b068dd…»; файл собран в своём `release-toolchain`, его bundle — «Verified OK»; публикация и сверка релиза пропущены;
  - 39703354477, подмодуль на v0.2.16: «The spec submodule, pinned at ead6aea85be4, has no executable tools/toolchain/toolchain.sh» — до сборки стадии;
  - 39703423312, проба с двумя аргументами: «error: recipe `release-refusal` got 2 positional arguments but takes 3», затем сообщение пробы;
  - релиза и тега `v0.1.6` проба не создала (`gh release list`, `git ls-remote --tags`);
- **проба #50**, без мержа, после ревью T25: общий `release.yml` с проверкой подмодуля и сверкой суммы скрипта.
  - Прогон 39704897047: проверки подмодуля прошли на раннере — значит, теги `spec` в его клоне подмодуля видны. Номер — `v0.1.6`, файл подписан, его bundle — «Verified OK», релиза нет;
  - 39704997453, подмодуль на 49c708c, где скрипт есть, а тега нет: «The spec submodule is pinned at 49c708ca1a8c, which is no tag of spec», до сборки;
  - 39705031751, подмодуль на v0.2.16: «spec v0.2.16 has no executable tools/toolchain/toolchain.sh», до сборки;
  - 39705086745, скрипт дописан после пробы, как мог бы контейнер: «spec/tools/toolchain/toolchain.sh changed while the release ran», до `release-version`.

  Проверку URL в `.gitmodules` проба на раннере не проверяла: с чужим URL checkout упал бы раньше неё. Её проверили локально, на копии с подмодулем, вместе с тремя другими отказами.

### 5.4. Копия checkout: проба #54

Измерено 2026-10-22 (поправки к R10 и R18, T28):
- **post-шаг `actions/checkout`** (sources 2.7) — в журнале пробы #54 после job стоит «git submodule foreach --recursive sh -c "git config --local --name-only --get-regexp 'core\.sshCommand' && …»;
- **подмодуль в checkout раннера** — прогон 39713588141 пробы #54, git 2.55.0. `spec/.git` — «gitdir: ../.git/modules/spec», `core.worktree` подмодуля — «../../../spec», а папка `.git/objects/info` пуста, то есть `alternates` нет. `spec` копии ведёт в её собственный `.git`: «/home/runner/work/_temp/checkout/.git/modules/spec»;
- **проба #54**, без мержа: `self-release-trial.yml` и `justfile` — как в #49, а общий `release.yml` — T28.
  - 39713033296: «version=v0.1.7», «previous=v0.1.6», «releasing v0.1.7 at bab5bbb…». Файл собран, его bundle — «Verified OK»; публикация и сверка релиза пропущены;
  - 39713181646: после `release-version` контейнер скрипта дописал в `.git/config` копии строку `[core` и удалил её объекты, и его `git rev-parse HEAD` ответил «fatal: bad config line 14 in file .git/config». Прогон пошёл дальше: «releasing v0.1.7 at d3c3c0c…», дерево из `git archive`, «Verified OK». Checkout — «14M» по `du -sh`, а его копия — «real 0m0.013s»;
  - 39713312237: контейнер дописал строку в скрипт копии после пробы, и прогон остановился до `release-version`: «spec/tools/toolchain/toolchain.sh changed in the copy of the checkout while the release ran»;
  - 39713588141 — подмодуль, как выше; номер, сборка и сверка — как в первом прогоне;
  - релиза и тега `v0.1.7` проба не создала (`gh release list`, `git ls-remote --tags`);
- **локально** — шаги номера и публикации обоих релизов, вынутые из файлов дословно. docker подменён: команда идёт в той папке, которую монтируют в `/work`. Подменён и `gh`.
  - Ни один контейнер не получил сам checkout;
  - порча `.git` копии после `release-version` итога не меняет, а скрипт, изменённый в копии после пробы, останавливает шаг;
  - после отказа 404 коммиту, который уже не вершина, `release-refusal` в новой копии видит новую вершину, а в копии, снятой до `git fetch`, — «fatal: Needed a single revision». Отказ вершине и отказ 422 валят шаг;
  - шаг номера `main` до T28 при той же порче падает: «fatal: bad config line 15 in file .git/config», затем «git diff could not compare».

### 5.5. Публикация в npm: проба #61

Измерено 2026-10-22 (поправка к R18, T27):
- **вывод `npm publish --dry-run --json`** (sources 8.2) — объект по имени пакета, с `filename` и `integrity` (проверено на 11.19.1);
- **проба #61**, без мержа: `self-release-trial.yml` позвал общий `release.yml` T27 по локальному пути с `publish: false` и `npm-package: "@altnovatrail/release-trial"`. `release-files` в корне делает `npm version` и `npm pack`.
  - 39809838271 — положительный прогон. «releasing v0.1.9 at d5c7ffd…»; «@altnovatrail/release-trial is not in the npm registry yet, which matters not with publish false»; «@altnovatrail/release-trial@0.1.9: sha512-4XiS…, publish». Пробный прогон npm прочёл тот же архив, подпись — «Verified OK», а «Publish to npm» пропущен. В журнале нет строки об обмене OIDC: без переменных он пропущен на уровне silly. Node и npm скачались за 2 секунды, проверка заняла секунду;
  - 39809875797, без `npm-package`: шаги npm пропущены, а релиз идёт как прежде;
  - 39809901530, архива нет: «The release's files hold no altnovatrail-release-trial-missing-0.1.9.tgz …»;
  - 39809926354, в архиве версия 0.0.0: «… holds @altnovatrail/release-trial@0.0.0, not @altnovatrail/release-trial@0.1.9 …»;
  - 39809954130, имя без области: «npm-package is "release-trial", which is no package of the @altnovatrail scope …» — первым шагом, до номера;
  - 39809980143, чужой репозиторий: «… names its repository as "https://github.com/altnovatrail/canvas" …»;
  - 39810006148 и 39810040394, `publishConfig` и `private`: «… is private, or has a publishConfig or a tag of its own …»;
  - после ревью шаг переписан: `npm-isolated` — один скрипт, packument — с `?write=true`, файлы проверки — отдельно от папки npm. На нём проба повторена. 39812944031 — положительный прогон: «v24.22.1», «npm 11.19.1», npm идёт с `--prefix /home/runner/work/_temp/npm`, «@altnovatrail/release-trial@0.1.9: sha512-ZUTE…, publish», «Verified OK». 39813134293 — архива нет: «The release's files hold no altnovatrail-release-trial-missing-0.1.9.tgz …»;
  - во всех отрицательных прогонах до подписи и релиза дело не дошло. Релиза и тега `v0.1.9` нет (`gh release list`, `git ls-remote --tags`), а реестр отвечает на `@altnovatrail/release-trial` 404;
- **локально** — шаги, вынутые из файла дословно. Проверка шла с настоящим npm 11.19.1, а реестр, `gh`, cosign и сама публикация подменены. Пройдены случаи:
  - **проверка:** пакета нет при `publish` true и false; версия есть с теми же и с другими байтами; версия ниже старшей — тег `previous`; устаревшие версии и prerelease в счёт не идут; реестр отвечает 500; `publishConfig`, `tag`, `private`, записи вне `package/`, чужое имя, версия, `repository` строкой и чужой репозиторий;
  - **окружение пробы:** у пробного прогона npm нет ни переменных OIDC, ни `npm_config_*`, ни `NODE_OPTIONS`. npm идёт в пустой папке, а файлы проверки лежат отдельно. Packument без `versions` шаг не роняет;
  - **повтор:** архив и bundle из релиза, отказ `verify-asset` и cosign;
  - **публикация:** версия уже есть; вышла; выход 0 без версии — «probably staged»; отказ без версии — с настройкой, которая нужна, после трёх попыток, а выход 0 без версии — после тридцати; отказ, но версия есть — предупреждение; другая `integrity`; нет provenance; тег `previous`; архив не с `registry.npmjs.org`.

### 5.6. Снятый номер в шаге npm

Измерено 2026-11-01 (поправка 2026-11-01 к R18, T33):
- **локальный прогон** — 63 теста, все `ok`. shellcheck 0.11.0 по `tests/` и actionlint 1.7.12 по всем workflow — чисто. Шаг испорчен десятью способами, и каждая порча дала красный набор со своими случаями:
  - нет проверки `time`;
  - сообщения до релиза и после перепутаны;
  - номер ищется в `versions`, а не в `time`;
  - нет ветки пакета, снятого целиком;
  - эта ветка идёт раньше проверки номера;
  - она всегда читается как проба;
  - у шага нет `RELEASED`;
  - пакет, снятый целиком, узнаётся без пустых `versions`;
  - версия без `integrity` считается снятой;
  - сообщение о старом номере такого пакета молчит о пакете;
- **по настоящему реестру** — скрипт шага, вынутый yq и jq из файла дословно, в `bash --noprofile --norc -eo pipefail`, с настоящим curl 8.5.0, без токена. Архивы синтетические, `npm-isolated` подменён:
  - `ua-parser-js` 0.7.29 — «… was in the npm registry and was unpublished …» и «raise RELEASE_LINE …». С `RELEASED` — «The next release, with a new number, publishes the package»;
  - `ua-parser-js` 0.7.28 — «… is in the npm registry with the integrity sha512-6Gurc1n…», с той же просьбой о `RELEASE_LINE`;
  - `asdasd` 1.0.0 с `publish: false` — снятый номер, а вслед — то, что пакет снят целиком;
  - `asdasd` 2.0.0 — «… was unpublished from the npm registry as a whole …» с `publish: true`, а с `false` — notice и пробный прогон, `action=publish`;
  - `@altnovatrail/spec` 0.4.2 — `--tag previous`. 0.5.5 в 19:05 UTC — `publish` без тега, а в 19:12 — другая `integrity`: в 19:06:53 `spec` выпустил 0.5.5 сам. 0.9.0 тогда же — `publish` без тега;
- **на раннере** — прогон 41340770056, pull request #78: «63 tests, 0 failed». Шаг «Test the workflows» шёл 10 секунд, job «Workflows» — 43. У SonarCloud на #78 — 0 находок.

### 5.7. Подпись на повторе общего релиза

Измерено 2026-11-02 (поправка 2026-11-02 к R18, T39):
- **шаг повтора**, вынутый дословно (yq из `release.yml`), прогнан здесь, без docker. Подмена `docker` запускала команду `toolchain.sh` в папке, которую тот монтирует в `/work`: just 1.58.0, Node 24.21.0 и git 2.56.0 devcontainer — Node тот же, что в стадии `toolchain`. `gh` 2.101.0 был настоящим и только читал релиз `tutor` v0.1.0 — `release download` и `release verify-asset`. Архивом пакета шёл `SHA256SUMS` этого релиза под именем `x-0.1.0.tgz`: имени файла сертификат не называет.
  - С его bundle: аттестация — «Verification succeeded! x-0.1.0.tgz is present in release v0.1.0», рецепт — «x-0.1.0.tgz: tutor v0.1.0, signed by the shared release.yml of .github v0.1.11», выход 0.
  - С bundle `tutor_v0.1.0_source.tar.gz`: «release-verify: the signature does not hold for the file: signature verification failed», затем сообщение шага, выход 1.
  - В обоих случаях `GH_TOKEN` до подмены `docker` не дошёл;
- **проба**, вынутая так же. На подмодуле v0.6.2 dry run напечатал рецепт с `_tools` и ничего не запустил, выход 0. На копии `spec` v0.5.3 — «error: justfile does not contain recipe `release-verify`», затем сообщение шага, выход 1;
- **набор** (R28) — 83 теста, из них 12 новых, с yq 4.54.1, ShellCheck 0.11.0 и actionlint 1.7.12 по версиям и суммам `self-ci.yml`. Шаги испорчены тринадцатью способами — без `env -u GH_TOKEN`, рецепт или проба в самом checkout, проба не dry run, отказ рецепта или пробы пропущен, полное имя репозитория рецепту, без проверки имени файла или с любой веткой, SHA любой формы или из семи знаков, прежнее условие cosign, без аттестации, — и каждая порча дала красный набор. После ревью — ещё четырьмя: вся копия checkout в пробе или в повторе, любой владелец или любой файл в закреплении, — и тоже красный набор, а живые прогоны выше повторены на исправленном файле.

### 5.8. `release-verify` на файле релиза `tutor` v0.1.0

Измерено 2026-11-02 (R30, T38):
- **рецепт на настоящем файле** (2026-11-02) — `just -f spec/justfile release-verify tutor v0.1.0 SHA256SUMS`, с файлом и bundle из релиза `tutor` v0.1.0: «SHA256SUMS: tutor v0.1.0, signed by the shared release.yml of .github v0.1.11». `tutor` зовёт общий `release.yml` по SHA v0.1.11, c1b8487 (API GitHub).

Измерено 2026-11-02 (R31, T40):
- **рецепт на настоящем файле** (2026-11-02) — `just -f spec/justfile release-verify tutor v0.1.0 SHA256SUMS` из подмодуля v0.6.3, с файлом и bundle из релиза `tutor` v0.1.0: «SHA256SUMS: tutor v0.1.0, signed by the shared release.yml of .github v0.1.11».

Измерено 2026-11-08 (R32, T43):
- **рецепт на настоящем файле** (T43) — `just -f spec/justfile release-verify tutor v0.1.0 SHA256SUMS` из подмодуля v0.9.8, с файлом и bundle из релиза `tutor` v0.1.0, — «SHA256SUMS: tutor v0.1.0, signed by the shared release.yml of .github v0.1.11».

### 5.9. Файл прошлого релиза

Измерено 2026-11-02 (поправка 2026-11-02 к R18, T41):
- **шаг**, вынутый дословно (yq из `release.yml`), прогнан здесь так же, как шаг повтора в T39: подмена `docker` запускала команду `toolchain.sh` в папке, которую тот монтирует в `/work`, а `gh` 2.101.0 был настоящим. Вход — `SHA256SUMS`, прошлый — `tutor` v0.1.0.
  - С его bundle: аттестация — «Verification succeeded! SHA256SUMS is present in release v0.1.0», рецепт — «SHA256SUMS: tutor v0.1.0, signed by the shared release.yml of .github v0.1.11», выход 0, выход шага — `handed=file`, и в `previous/` лёг один `SHA256SUMS`.
  - С bundle `tutor_v0.1.0_source.tar.gz`: «release-verify: the signature does not hold for the file: signature verification failed», затем сообщение шага, выход 1, ни выхода `handed`, ни папки `previous/`.
  - Ветка первого релиза: на подмодуле v0.6.3 dry run напечатал рецепт с путём, который дал бы следующий релиз, затем notice, выход 0 и `handed=none`; на дереве `spec` v0.5.3 — «error: justfile does not contain recipe `release-verify`», затем сообщение шага, выход 1.
  - Во всех прогонах `GH_TOKEN` до подмены `docker` не дошёл. Первый прогон ветки первого релиза показал, что dry run шёл с токеном: контейнеру `toolchain.sh` его не передаёт, но скрипт, как на пути повтора, теперь запускается без него, и это держит случай набора;
- **набор** (R28) — 98 тестов, из них 15 новых, с yq 4.54.1, ShellCheck 0.11.0 и actionlint 1.7.12 по версиям и суммам `self-ci.yml`. Шаги испорчены двадцатью способами, и каждая порча дала красный набор:
  - без `env -u GH_TOKEN` у рецепта или у dry run; вся копия checkout; пропущенный отказ рецепта; без аттестации; файл отдан до проверки; bundle не нужен;
  - тег — номер нового релиза; без dry run у первого релиза или с путём раннера в нём;
  - `/` или `.sigstore.json` в имени;
  - без `:ro`; монтирование и у первого релиза; без пустого аргумента; путь раннера вместо `/previous/`; без охраны цепочки;
  - без `handed=file` или `handed=none`; сборка, которая идёт без `handed`.

### 5.10. Номер пакета, снятого целиком

Измерено 2026-11-02 (поправка 2026-11-02 к R18, T42):
- **набор** (R28) — 98 тестов. Заготовка `tombstone()` — как реестр отвечает, с ключами номеров в `time`, а `tombstone_without_its_time()` — номер без ключа, которого реестр не показал. Порча: без `unpublished.versions` — 1 красный случай, без ключей `time` — 4.

### 5.11. Ожидание реестра в шаге npm

Измерено 2026-11-08 (поправка 2026-11-08 к R18, T44):
- **длительность джоба** — самый долгий джоб общего релиза среди 12 последних успешных прогонов `release.yml` каждого вызывающего, пробы pull request тоже, API GitHub: `module-kit` — 285 с, `modules` — 81 с, `canvas` — 333 с, `tutor` — 77 с. Шаг «Publish to npm» у `canvas` (прогон 41395016624) — 05:38:39–05:39:45 UTC 2026-11-02. С 20 минутами ожидания и тремя на раунд, который идёт, это около 29 минут, и `timeout-minutes` — 45 вместо 30;
- **набор** (R28) — 114 тестов, из них 16 новых, у шага «Publish to npm» их раньше не было. Стаб `curl` отвечает на каждый адрес своей очередью ответов, а `sleep` — стаб, который только записывает вызов. Шаг испорчен семью способами — архив без ожидания, 30 раундов вместо 120, без `--max-time` у документа или у архива, без трёх раундов после отказа npm, три раунда и после того, как документ показал версию, прежний `timeout-minutes`, — и каждая порча дала красный набор. Срок по `SECONDS` кейсы не проверяют: стаб часов не двигает, и в наборе раунды кончает граница в 120. Поэтому строку срока и строку выхода по нему набор сверяет с шагом дословно. После ревью к набору добавились кейс тега `previous` и проверка, что `npm-isolated` получает переменные OIDC. Ещё четыре порчи — срок перевёрнут или снят, переменные OIDC сняты перед `npm publish`, тег не передан — тоже дали красный набор. Весь набор идёт 23–27 с. ShellCheck 0.11.0 и actionlint 1.7.12 по суммам `self-ci.yml` — чисто.

## 6. Набор тестов шагов

### 6.1. Основа набора

Измерено 2026-11-01 (R28, T35):
- **как yq переводит YAML в JSON** — проба на v4.54.1. Ключ `on` и значение `on` остаются строками. `0.10` и `010` — числа, `true` — булево, пустое значение — `null`. Блок `|` — строка байт в байт, с одним переводом строки в конце.
- **curl, jq и tar на плохом ответе** — инструменты devcontainer:
  - curl 8.5.0 без `-f`: на 404 реестра пишет тело в `-o`, печатает `404` и выходит с 0. Если соединиться не может, печатает `000` и выходит с 7;
  - jq 1.7 на тексте не JSON — «jq: parse error», выход 5;
  - GNU tar 1.35 на файле не gzip — выход 2.
- **локальный прогон** — 53 теста, все `ok`, за 9 секунд; shellcheck 0.11.0 по `tests/` и actionlint 1.7.12 по всем workflow — чисто. Из 21 порчи шагов каждая дала красный прогон (R28).
- **на раннере** — прогон 41337182817, pull request #77: «53 tests, 0 failed». Шаг «Test the workflows» шёл 11 секунд, job «Workflows» — 42, а `id -u` и `id -g` раннера — 1001. Прогон 41337180022, проба #76 без мержа: с `--ipc=host` у всех job `typescript.yml` — «53 tests, 1 failed». Упал `test_typescript_runs_each_recipe_with_ci_and_the_test_job_alone_with_the_hosts_ipc`, а следующие шаги job пропущены.

### 6.2. `documents.yml` скриптом `spec`

Измерено 2026-11-08 (поправка 2026-11-08 к R08):
- **набор** (R28) — 140 тестов, из них 5 новых: настоящий скрипт подмодуля `.github` со стабом `docker`. Без проверки, что скрипт исполняемый, — красный набор.

## 7. Кеш образа стадии `toolchain`

### 7.1. `go.yml` и `typescript.yml`

Измерено 2026-11-09 (R36, T52):
- **замер** — шаг «Toolchain image» до кеша: в прогоне `self-ci.yml` 42500504949 на `main` 2026-11-08 job «Go / lint», «Go / test», «Go / vuln» и «Go / licenses» — 20–26 с; у `canvas` в прогоне CI 42704340930 на `main` 2026-11-09 четыре job `typescript.yml` — 60–76 с. С кешем, черновой pull request #109, прогон `self-ci.yml` 42715578341: на промахе сборка с `docker save` — 36–46 с, а сохранил запись один job из четырёх, у трёх — «Failed to save: Unable to reserve cache with key …, another job may be creating this cache», и job зелёные; на попадании, повторной попыткой, — восстановление записи ~383 МБ за 4–7 с и `docker load` за 20–29 с, без `docker build`;
- **набор** (R28) — случаи шага: файла нет; файл загрузился и дал образ `toolchain`; файл не загрузился; загрузился, но без образа `toolchain`; не загрузился, и сборка упала; сборка упала; `docker save` упал. Проверка по тексту держит три шага одинаковыми в шести job, а `release.yml` и `self-release.yml` — без `actions/cache`. Порча — без удаления испорченного файла, сохранение без условия промаха, без `docker save`, без удаления недописанного файла, без сверки образа, `docker save` после файла из кеша — каждая дала красный набор.

### 7.2. `documents.yml`

Измерено 2026-11-10 (поправка 2026-11-10 к R36, T53):
- **набор** (R28) — случаи шага «Toolchain image» на настоящем скрипте подмодуля: промах, попадание, файл не загрузился, файл с другим образом, сборка упала, скрипт прежнего вида без переменной, нет скрипта, скрипт не исполняемый; проверка по тексту — шаги кеша `documents.yml` и job «Workflows» `self-ci.yml` те же, что у `go.yml`, кроме пути, а переменная называет тот же файл. Порча — без переменной, сохранение без условия промаха, другой путь в переменной, сборка и проверка одним шагом — каждая дала красный набор;
- **вживую** — pull request 109, прогон `self-ci.yml` 42732255328: на промахе «Documents / docs-check-repo» сохранил запись `novatrail-toolchain.tar`, ~383 МБ, а «Workflows» — «Unable to reserve cache», и оба зелёные; сборка — 30 с у одного и 2 мин 51 с у другого, где шаг `RUN` с загрузками шёл 143 с. На повторной попытке оба — «Cache restored from key» за 5–6 с и `docker load` за 28–31 с, без сборки. Запись `toolchain.tar` `go.yml` новый прогон того же pull request тоже нашёл.

## 8. Шаблоны issue и pull request

### 8.1. Проба по схемам

Измерено 2026-11-01 (R29, T37):
- **проба по схемам** — `github-issue-forms.json` и `github-issue-config.json` SchemaStore, draft-07, с www.schemastore.org; js-yaml 4.1.0 и Ajv 8.17.1 — во временной папке, не в репозитории. Все три файла по схемам верны. Порча — лишний ключ верхнего уровня, `id` с пробелом, поле без `label` — каждый раз даёт отказ (R29).

## 9. Переходы на теги `spec`

### 9.1. Проверки на новом теге

Измерено 2026-11-08 (R34, T51):
- **проверка документов** — `docs-check-repo` на v0.9.9 ok и до правок, и после.

Измерено 2026-11-09 (R35):
- **проверка документов** — `docs-check-repo` на v0.12.0 ok и до правок, и после.

Измерено 2026-11-10 (R37):
- **проверки** — набор `tests/run.sh` с новым скриптом подмодуля — 149 тестов, 0 упало; `docs-check-repo` на v0.13.0 ok и до правок, и после.

Измерено 2026-11-12 (R38, T54):
- **хук** — `spec/tools/session/main.mjs` на пробном журнале с репликой «Выполни задачу T54 из RUN.md»: реплика с T55 — `"decision":"block"` и «This prompt starts T55, and this session has led T54: one task is one session (RULES.md, How we work). Run /clear, or open a new session, and send the prompt there.»; та же задача и реплика без задачи проходят;
- **проверки** — набор `tests/run.sh` со скриптом подмодуля v0.16.3 и yq 4.54.1 по сумме `self-ci.yml` — 156 тестов, 0 упало; `docs-check-repo` на v0.16.3 ok и до правок, и после.

## 10. Перестройка документов

### 10.1. Сверка «без потерь» T55

Измерено 2026-11-12 (поправка 2026-11-12 к R38, T55):
- **на чём** — прежний раздел «Источники», architecture 4 на `main` d5c57ae, от «## 4.» до конца файла, против `docs/sources.md`, `docs/measurements.md` и указателя architecture 4 T55. Указатель — в сверке: имена групп держит теперь его таблица, а десять мест пунктов сборщик поправил — ссылки раздела на свои разделы и группы, «(2.8)» или «ниже, «<группа>»», названы документом и номером записи;
- **как** — скрипт node в scratchpad сессии, как сверка T133 `spec`: в прежнем разделе и в новых файлах он собирает адреса, цитаты «…» — внешние, по глубине, — даты, коммиты, номера R, О-, П-, Т-, Д, В и T и код в обратных кавычках и для каждого вида считает, сколько разных значений пропало и сколько встречается реже прежнего. Сборщик файлов ещё проверил, что каждый из 273 пунктов раздела взят ровно один раз — целиком или частями;
- **числа** — разных значений: адресов 105, цитат 413, дат 44, коммитов 79, номеров 104, кода 950. Пропало 0, реже прежнего — 0. Без указателя пропадает одна цитата — «Интерфейс релиза `spec` и суммы архивов», ссылка на группу, ставшая номером записи, — и `go.yml` встречается 24 раза вместо 25: два имени групп с ним держит только таблица.
