# .github — архитектура

> Статус: 2026-10-20, эпик E1 закончен (T01–T05), идёт эпик E2. Пункт, который карточка оставила детализации, решён — общие и свои workflow (R03–R05, раздел 3). Что ещё открыто — раздел 2: 2.4–2.6 решены (R10), 2.7 — для gitleaks (R08), а список лицензий по 2.7 положит E3; 2.9 автор решил при планировании E2, и в раздел 3 его переносит T10. У 2.2 пройден первый шаг (R09), второй шаг и 2.8 проверит T17 `spec`; 2.3 — Т-27 `spec`, вместе с эпиком E3. Общие проверки эпика E2 — секреты, DCO и документы (T07), CodeQL и Scorecard (T08) — и релиз `.github` (T09) уже есть, ruleset `main` — T10; workflow для кода — эпик E3.
>
> Что делает компонент, чего не делает и что о нём ещё предстоит решить. Это подробности его карточки — architecture 3.11 spec. Карточка остаётся сводкой: если подробности меняют то, что в ней сказано, она правится в `spec` тем же путём, что и вопросы в его реестры (RULES.md, Across repositories).
>
> Почему решено так, а не иначе, — в [decisions.md](decisions.md); план работ — в [RUN.md](../RUN.md). Понятия — concepts spec. Документы и решения `spec` лежат в `spec/docs/` и цитируются с суффиксом «spec».

## 1. Назначение и границы

**Делает:**
- держит профиль организации — `profile/README.md`. GitHub показывает его на странице github.com/altnovatrail (architecture 3.11 spec);
- держит файлы сообщества по умолчанию — CONTRIBUTING, SECURITY и кодекс поведения. GitHub показывает их в каждом репозитории организации, у которого нет своих, если `.github` публичный; публичны и все репозитории организации (architecture 3.11 spec, architecture 8 spec; R18 spec; R22 spec);
- получает общие workflow CI, с actions, закреплёнными по SHA (architecture 3.11 spec; R03, раздел 3.1):
  - общие проверки — поиск секретов, DCO, CodeQL, Scorecard и проверку документов. Их берут все репозитории, и `spec` тоже, ещё до своего кода (repositories 1, 2.1 spec; R30 spec); проверка документов у `spec` своя, `just docs-check`. Scorecard общий, если сервер Scorecard примет результат общего workflow, а иначе — копия в каждом репозитории (2.2; architecture 3.11 spec). Подключают их T17 и T16 `spec`;
  - для кода — Go и TypeScript, обёртки над рецептами репозитория с проверкой лицензий внутри, и релиз с подписью — вместе с первым кодом `module-kit`, с которого начинается код платформы (R03; repositories 6 spec);
- общий workflow релиза подписывает и пакеты модулей, а проверяет подпись `module-kit` (architecture 3.7 spec; R17 spec).

**Не делает:**
- не заменяет файлы, которые у репозитория есть свои: GitHub берёт файл по умолчанию, только когда своего нет (R22 spec);
- не даёт лицензию за другие репозитории: LICENSE по умолчанию не бывает, у каждого репозитория — свой (R20 spec; R22 spec);
- не повторяет правила: CONTRIBUTING ведёт на `RULES.md` и CLAUDE.md репозитория, а копия разошлась бы с ними (R21 spec; R22 spec);
- не держит кода платформы: во время её работы к `.github` никто не обращается, на общей схеме его нет (architecture 2 spec).

**Данные и связи:**
- данных учеников и секретов нет, как ни в одном репозитории (RULES.md, Hard rules);
- при сборке ни от чего не зависит, кроме `spec`, как все (repositories 2.1 spec);
- общие проверки CI будут брать все репозитории, и `spec` тоже, ещё до кода (repositories 1, 2.1, 3 spec; R30 spec). В репозиторий из заготовки проверки языка, justfile и подписанные релизы приходят вместе с его кодом (repositories 1 spec). Первыми общие workflow подключат `spec` и `module-kit` (T17 `spec`);
- его сервисы — GitHub и Sigstore: CI, релизы, подписи без ключей (architecture 3.12 spec);
- этап 0, вместе со `spec` (repositories 2.1 spec).

## 2. Решить при детализации

Пункты «Решить при детализации» из карточки — по подразделу на пункт, и дыры, которые нашлись по дороге. Каждый пункт называет, где он решится: задачу в [RUN.md](../RUN.md) или эпик, который её принесёт. Решённый пункт называет запись журнала, а само решение переезжает в раздел 3. Вопрос, который выходит за этот репозиторий, уходит «в реестр spec» (RULES.md, Across repositories).

### 2.1. Общие и свои workflow

- **Суть:** какие workflow CI живут в `.github` и вызываются всеми репозиториями, а какие у каждого репозитория свои — пункт «Решить при детализации» карточки (architecture 3.11 spec).
- **Решено:** R03, R04 и R05, задача T01. Устройство — раздел 3.

### 2.2. Scorecard из общего workflow

- **Суть:** Scorecard с публикацией результатов ставит ограничения тому workflow, который его запускает, и сервер Scorecard может отклонить результат (раздел 4). Reusable workflow сервер принимает, а по какому файлу он сверяет ограничения — по вызывающему или общему, — не сказано.
- **Что известно:**
  - проверку ветки сервер ведёт по вызывающему репозиторию (scorecard-webapp, PR #778), и Scorecard в reusable workflow он поддерживает — это говорит за то, что ограничения он сверяет по общему файлу. Прямо это не сказано;
  - общий `scorecard.yml` ограничения держит. Вызывающий файл держать их не может: у его job — `uses:` общего workflow вместо шагов и `id-token: write`, а «Only the job with `ossf/scorecard-action` can use `id-token: write` permissions» (раздел 4). Если сервер сверяет вызывающий файл, он отклонит результат, и нужен запасной путь.
- **Как решится:** в два шага. Первый — прогон `self-scorecard.yml` в эпике E2: у его job тоже `uses:` и `id-token: write`, так что, если сервер сверяет вызывающий файл, он отклонит уже этот результат — принят ли он, проверяет сам эпик. Второй — первый вызов из другого репозитория по полному пути, как и 2.8: проверка ветки по вызывающему (PR #778) касается именно такого вызова. Зелёный job ничего не доказывает: при отказе сервера scorecard-action v2.5.0 только предупреждает и возвращает успех, а входа `fail_on_publish_error`, который валит шаг, в v2.5.0 ещё нет (раздел 4; так же записала T17 `spec`). Принят ли результат, видно только на сервере Scorecard; с релизом, где вход есть, его стоит включить. Отклонит — запасной путь R03: одинаковая копия `scorecard.yml` в каждом репозитории.
- **Первый шаг пройден** 2026-10-20 (поправка к R09): API Scorecard отдаёт результат `self-scorecard.yml` для коммита `main` 53b829f, оценка 5.4, а журнал прогона не предупреждает об отказе. Вызывающий файл с `uses:` и `id-token: write` сервер принял.
- **Задача:** первый шаг — T08, сделан; второй — первый вызов в T17 `spec`.

### 2.3. Подпись общего релиза: чья идентичность

- **Суть:** подпись без ключей из общего workflow релиза получит идентичность того workflow, который её ставит. Проверка подписи, как R52 canvas-api, сверяет точную идентичность `release.yml@refs/heads/main` вызывающего репозитория, а у общего релиза она будет другой.
- **Что известно:** сертификат Sigstore для job из reusable workflow называет идентичностью (SAN) общий workflow, а вызывающий workflow и его репозиторий несёт в своих расширениях — Build Config URI и Source Repository URI (раздел 4). Проверяет подпись пакета `module-kit` (architecture 3.7 spec; R17 spec), а образ и сборки — `infra` (Т-19).
- **Как решится:** с первым релизом `module-kit` (E2 `spec`), вместе с общим workflow релиза: что именно проверяют `module-kit` и `infra` — идентичность общего workflow, репозиторий и workflow вызывающего или то и другое. Вызывающий закрепляет общий workflow по SHA (R04), так что SAN кончается на `@<sha>`, а не на теге, и проверка должна убедиться, что этот SHA — релиз `.github`. Варианты и рекомендация — Т-27: `spec` записал вопрос и рекомендацию `.github` — проверять то и другое, SAN по SHA одного из релизов `.github`.
- **Задача:** эпик E3, с первым релизом `module-kit`; сам вопрос — Т-27, его решают вместе с `module-kit` и `infra`, которые проверяют подпись.

### 2.4. Какие коммиты `main` получают релиз

- **Суть:** R04 выпускает общие workflow релизами, как R31 spec. Но `spec` выпускает каждый зелёный коммит `main`, а у `.github` есть коммиты, которые общих workflow не трогают: профиль, файлы сообщества, свои `self-` workflow, документы.
- **Решено:** R10, задача T09: релиз получает коммит, который с прошлого релиза меняет общий workflow, а первый релиз выходит всегда. Устройство — раздел 3.5.

### 2.5. Как `.github` считает номер релиза

- **Суть:** у `spec` номер считает `tools/release/version.mjs` с тестами, а рецепт `release-version` подаёт ему три списка тегов `v*`: все теги, теги из истории `HEAD` и теги на самом `HEAD` (justfile `spec`; R31 spec). Своего кода у `.github` нет.
- **Решено:** R10, задача T09: функции `version.mjs` из подмодуля, а линия `0.1` — в самом `self-release.yml`. Устройство — раздел 3.5.

### 2.6. Пауза `cooldown` для ссылок на `.github`

- **Суть:** Dependabot ждёт три дня после выхода версии, прежде чем её предложить, — так записано в `dependabot.yml` `spec` для каждой экосистемы (R30 spec). Ссылки на общие workflow он поднимает в той же экосистеме `github-actions`; что пауза действует и на них, документация отдельно не говорит.
- **Решено:** R10, задача T09: три дня, как для всего. Устройство — разделы 3.3 и 3.5. Держит ли пауза ссылки на `.github`, проверит первый подъём ссылки в T17 `spec`, вместе с 2.8.

### 2.7. Как общий workflow читает файлы `.github` своей версии

- **Суть:** общему workflow могут понадобиться данные — список лицензий (3.1), версия и сумма gitleaks. `actions/checkout` в нём берёт вызывающий репозиторий, а не `.github` (раздел 4).
- **Что известно:** GitHub описывает, как reusable workflow берёт свой репозиторий своей версии: `actions/checkout` с `repository: ${{ job.workflow_repository }}` и `ref: ${{ job.workflow_sha }}` (раздел 4).
- **Варианты:** держать данные прямо в файле общего workflow — список в десяток идентификаторов SPDX, версию и сумму; держать их отдельными файлами `.github` и брать вторым checkout по `job.workflow_repository` и `job.workflow_sha`.
- **Рекомендация:** в самом файле, пока данные так малы. Тогда правка данных — правка общего workflow, она и даёт релиз (2.4), а вызывающий получает данные той версии, на которой закреплён. Отдельный файл — когда данных станет больше, с checkout по `job.workflow_sha`.
- **Задача:** эпик E2 — для gitleaks, эпик E3 — для списка лицензий.
- **Решено для gitleaks:** R08, устройство — раздел 3.1. Для списка лицензий пункт открыт до E3.

### 2.8. Общие workflow из репозитория с именем `.github`

- **Суть:** R03 кладёт общие workflow в `altnovatrail/.github`. Что GitHub вызывает workflow из репозитория с таким именем, а Dependabot поднимает ссылки на него, подтверждает пример `nodenv/.github`, а не документация (раздел 4).
- **Варианты:** оставить в `.github` и проверить первым вызовом; сразу завести отдельный репозиторий для общих workflow — это правка списка репозиториев R18 spec, «в реестр spec».
- **Рекомендация:** оставить в `.github`: пример работает, и Dependabot поднимает его ссылку (issue #12489 dependabot-core, раздел 4), а карточка 3.11 spec кладёт общие workflow сюда. Подтвердит первый вызов по полному пути — из `spec` в T17 `spec`. Если он не пройдёт — отдельный репозиторий, «в реестр spec».
- **Задача:** T17 `spec`, первый вызов.

### 2.9. Кто ставит ruleset `main` самого `.github`

- **Суть:** у каждого репозитория — свой ruleset `main` по R30 spec: только через pull request, обязательны все проверки, кроме Scorecard. T16 `spec` ставит его в остальных репозиториях этапов 0–2, а `.github` — один из них. Но свои workflow `.github` пишет он сам (R03), и имена его проверок появятся в эпике E2.
- **Варианты:** в эпике E2 — вместе с ruleset тегов `v*` (R04), шагом автора по правилу 4; в T16 `spec`, как у остальных.
- **Рекомендация:** в эпике E2: обязательные проверки называются по job, а job `.github` пишет E2. Тогда T16 `spec` `.github` пропускает: что решено, она читает в журнале `.github`, а если ruleset не поставлен, ставит его сама (T16 `spec`). Автор принял рекомендацию при планировании E2 (RUN.md, «Решено автором» эпика), а запись в журнале и сам ruleset делает T10.
- **Задача:** эпик E2.

## 3. Устройство

Решено по 2.1: R03 — какие workflow общие, а какие свои; R04 — как они версионируются; R05 — секреты и форки. Файлы общих проверок пишет эпик E2, workflow для кода — эпик E3 (таблица 2 [RUN.md](../RUN.md)), а подключают их T17 `spec` — в `spec` и `module-kit` — и T16 `spec` — в остальных репозиториях. Внешние факты, на которых это стоит, — в разделе 4.

### 3.1. Общие workflow

Общий workflow лежит прямо в `.github/workflows/` этого репозитория, запускается только через `on: workflow_call` и вызывается как `altnovatrail/.github/.github/workflows/<файл>@<sha> # vX.Y.Z` (R04). Права даёт вызывающий job, а общий workflow их только понижает; `actions/checkout` в нём берёт вызывающий репозиторий. Секретов общий workflow не принимает (R05).

**До кода — у всех репозиториев, и у `spec`:**

| Workflow | Что делает | Кто вызывает | Входы | Права от вызывающего | Что нужно от репозитория | Проверка в ruleset |
|---|---|---|---|---|---|---|
| `secrets.yml` | job `gitleaks`: поиск секретов gitleaks 8.30.1 по всей истории проверяемого коммита (`--log-opts=HEAD`), как R49 canvas-api, с `--redact`; архив сверяется с суммой sha256 в самом файле (R08) | все | нет | `contents: read` | `.gitleaks.toml` со своими исключениями — по желанию: gitleaks читает его из сканируемой папки (раздел 4). В нём — `[extend]` с `useDefault = true`, иначе он заменил бы правила gitleaks, и проверка на таком файле падает. На pull request и он, и `.gitleaksignore` берутся из базы, а комментарии `gitleaks:allow` не действуют: pull request не ослабит скан своих коммитов | «Secrets / gitleaks», держит мерж |
| `dco.yml` | job `sign-off`: у каждого коммита pull request, кроме merge-коммитов, есть `Signed-off-by` его автора, по имени и адресу (R30 spec); коммиты — `git rev-list` между родителями merge-коммита pull request, `HEAD^1..HEAD^2`, из checkout с полной историей, без API; на другом событии падает | все, job вызывающего — только на pull request | нет | `contents: read` | обязательная подпись веб-коммитов: коммит, сделанный на github.com, получает её только так. У организации она включена (R22 spec) | «DCO / sign-off», держит мерж |
| `documents.yml` | job `docs-check-repo`: собирает стадию `toolchain` из `.devcontainer/Dockerfile` вызывающего, берёт checkout с подмодулем и запускает в ней `just -f spec/justfile docs-check-repo` (R32 spec) | все, кроме `spec`: у него свой `just docs-check` | нет | `contents: read` | `.devcontainer/Dockerfile` со стадией `toolchain` и подмодуль `spec/` — оба из заготовки | «Documents / docs-check-repo», держит мерж |
| `codeql.yml` | CodeQL advanced setup (R09): job `languages` собирает список — `actions` всегда и языки вызывающего, каждый один раз; другой язык останавливает проверку с причиной. Job `analyze` на язык — `build-mode: none`, `tools: linked`, набор `security-extended`, `category` — `/language:<язык>`. Зелёный анализ значит, что CodeQL прошёл, а не что он ничего не нашёл: находки держит правило ruleset `code_scanning` или обязательная проверка «CodeQL» от GitHub Advanced Security, и что из них — решит `spec` (В7) | все | `languages` — языки репозитория сверх `actions`, через пробел, запятую или строку; пока только `javascript-typescript`. До кода — пусто, у `spec` — `javascript-typescript` для `tools/` (T17 spec) | `contents: read`, `security-events: write` | для компилируемого языка — сборка, с кодом (E3); default setup code scanning выключен | «CodeQL / analyze (<язык>)», держит мерж. «CodeQL / languages» не обязательна: если она упадёт, анализов не будет вовсе, и мерж ждёт их, а она называет причину |
| `scorecard.yml` | job `scorecard`: OpenSSF Scorecard с публикацией результатов, SARIF — в code scanning; в job только одобренные actions и ни одного своего скрипта (R09) | все, на push в `main` и по расписанию | нет | на job — `contents: read`, `security-events: write` и `id-token: write`; на уровне workflow — только чтение | вызывающий — отдельный маленький файл без `env` и `defaults` (2.2) | «Scorecard / scorecard», мерж не держит (R30 spec) |

Dependabot подписывает коммит не тем адресом, каким назван автор. У `spec` в коммите c6b3cb5 автор — `dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>`, а подпись — `Signed-off-by: dependabot[bot] <support@github.com>`. Поэтому `dco.yml` сверяет подпись с автором по имени и адресу, а для `dependabot[bot]` принимает эту подпись названным исключением. Иначе каждый pull request Dependabot был бы красным, а T17 `spec` ждёт обратного. Исключение действует, только если pull request открыл `dependabot[bot]`, а коммиттер — `GitHub <noreply@github.com>`: автора коммита задаёт кто угодно, а автора pull request — нет.

**С первым кодом — у репозиториев с кодом** (эпик E3 — вместе с эпиком E2 `spec` и первым кодом `module-kit`):

| Workflow | Что делает | Кто вызывает | Входы | Права от вызывающего | Что нужно от репозитория | Держит мерж |
|---|---|---|---|---|---|---|
| `go.yml` | собирает стадию `toolchain` вызывающего и запускает его рецепты `just` с условленными именами — проверки языка, тесты, уязвимости, лицензии | репозитории вида go | с первым кодом `module-kit` | `contents: read` | рецепты с этими именами; исключения проверки лицензий — свои, каждое с решением, как R48 canvas-api | да |
| `typescript.yml` | то же для TypeScript | репозитории вида typescript | с первым кодом | `contents: read` | то же | да |
| `release.yml` | релиз с подписью без ключей: подписывает каждый файл, как R52 canvas-api, и пакеты модулей (R17 spec) | `module-kit` первым, затем `modules` и остальные репозитории с релизами | с первым релизом `module-kit` | `contents: write` и `id-token: write` — для релиза и подписи без ключей, как у релиза canvas-api (R52 canvas-api); остальное — с первым релизом | рецепт, который собирает файлы релиза | нет: это не проверка pull request |

Список лицензий для `go.yml` и `typescript.yml` один на всех — категория A политики ASF, как у проверки `spec` (поправка к R12 spec). Где он лежит — 2.7. Точные входы и имена рецептов — с первым кодом `module-kit`. Идентичность подписи — 2.3.

Имена job в общих workflow и в вызывающих файлах одни на все репозитории: обязательная проверка называется «`<job name> / <reusable job name>`» (раздел 4), и ruleset `main` у всех репозиториев перечисляет одни и те же имена (R30 spec) — кроме CodeQL, у которого по проверке на язык репозитория. Job вызывающего называется по проверке — «Secrets», «DCO», «Documents», — а job общего workflow — по тому, что он запускает (R08).

### 3.2. Свои workflow репозиториев

Своё — то, что знает только один репозиторий (R30 spec). Свои проверки идут в стадии `toolchain` его devcontainer, как у `spec`.

| Репозиторий | Свои workflow и проверки |
|---|---|
| `spec` | `ci.yml` — «Documents and tools»: `docs-check`, тесты `tools/`, проверка лицензий `tools/`, номер релиза (R30 spec); `release.yml` — свой релиз (R31 spec); позже валидатор схем (E2 `spec`) |
| `.github` | `self-ci.yml`, `self-release.yml`, `self-codeql.yml` и `self-scorecard.yml` — раздел 3.4 |
| `modules` | проверка пакетов CLI `module-kit` и стенд `sim` по тегам; с этапа 2 — eval с ключом платформы (R24 spec), по правилу R05 (repositories 4 spec) |
| `learner-model`, `engine` | гейт `sim` по тегу через `go.work` (repositories 1, 4 spec) |
| `canvas` | сборка страницы образцов с CLI `module-kit` и релизом `modules` по тегу (R25 spec) |
| `api` | SDK поставщиков ИИ приходят только через `tutor` (R15 spec) |
| `module-kit`, `engine`, `sim` и виджеты | тест-векторы генератора случайности и вывода зёрен (Т-18) |

SonarCloud — не workflow: анализ автоматический, а его проверку ставит приложение SonarQube Cloud (R30 spec).

### 3.3. Вызывающие файлы

В каждом репозитории компонента — одни и те же файлы; различаются они только входом CodeQL и своими job. У `spec` и `.github` — отличия ниже.
- `.github/workflows/ci.yml` — на pull request и push в `main`: вызывает `secrets.yml`, `dco.yml` (на pull request) и `documents.yml` (кроме `spec`), а рядом — свои job;
- `.github/workflows/codeql.yml` — на pull request и push в `main`: вызывает `codeql.yml` со своими языками. Раз в неделю его не запускают: бандл CodeQL закреплён вместе с action (R09);
- `.github/workflows/scorecard.yml` — на push в `main` и раз в неделю: вызывает `scorecard.yml`;
- `.github/dependabot.yml` — раз в неделю, как у `spec`: `github-actions` в `/`, он поднимает и ссылки на общие workflow, и `docker` в `/.devcontainer`; экосистемы языков — с кодом (repositories 2.2 spec, шаг 5). У каждой экосистемы — пауза `cooldown` в три дня, в том числе у `github-actions`, которая поднимает и ссылки на `.github` (R10); базовый образ она не держит, а держит ли ссылки — раздел 3.5;
- `.sonarcloud.properties` — без `spec/**` (Д7 в RUN.md `spec`).

Отличия:
- у `spec` в `ci.yml` нет `documents.yml` — рядом его свой job «Documents and tools», — а в `.sonarcloud.properties` нет исключения `spec/**`: подмодуля у него нет;
- у `.github` вызывающие файлы свои, с префиксом `self-` (раздел 3.4): имена `codeql.yml` и `scorecard.yml` здесь заняты самими общими workflow.

Файлы репозиториев компонентов и `spec` пишет сессия `spec` — через `.repos/<имя>`, как при заведении репозитория (R30 spec).

### 3.4. Свой CI `.github`

Свои workflow `.github` лежат рядом с общими и начинаются с `self-`; у общих префикса нет, и запускаются они только через `workflow_call`:
- `self-ci.yml`, `name: CI`, — на pull request и push в `main`. Job «Secrets», «DCO» (только на pull request) и «Documents» вызывают общие workflow по локальному пути `./.github/workflows/<файл>`, так что pull request проверяет ту версию, которую сам и меняет. Job «Workflows» — actionlint 1.7.12 по всем workflow, с shellcheck 0.11.0 по скриптам в них: их код живёт здесь. actionlint и shellcheck, как и gitleaks, скачиваются по точной версии и сверяются с суммой sha256 в самом файле, а в devcontainer их нет (R08); shellcheck раннера actionlint не берёт. Отказы actionlint, каждый с причиной, — в `.github/actionlint.yaml`;
- `self-release.yml`, `name: Release`, — свой релиз, как у `spec` (R31 spec; R10): после зелёного `self-ci.yml` на `main`, только от push из самого репозитория, и кнопкой — на `main`, после зелёного CI. Прогоны идут очередью, `queue: max`. Checkout — коммит, на котором прошёл CI, со всей историей и подмодулем; номер считается в стадии `toolchain`, релиз выходит, если изменился общий workflow, а проверяет его `gh release verify`. Отказ 404 или 403 «Resource not accessible by integration» для коммита, который уже не вершина `main`, пропускается: его правку покроет релиз вершины (раздел 4);
- `self-codeql.yml`, `name: CodeQL`, — на pull request и push в `main`; `self-scorecard.yml`, `name: Scorecard`, — на push в `main` и раз в неделю. Оба вызывают общие по локальному пути, `.github` не называет языков сверх `actions` (R09); `dependabot.yml` и `.sonarcloud.properties` — как в 3.3.

### 3.5. Версии и обновления

По R04 и R10:
- **релиз `.github`** выходит сам после зелёного CI на `main`, как R31 spec, но только у коммита, который с прошлого релиза меняет общий workflow — файл `.github/workflows/` без префикса `self-`; первый релиз выходит всегда. Номер — следующий патч линии `RELEASE_LINE` из `self-release.yml`, сейчас `0.1`. Его считают функции `readLine`, `readTags` и `nextVersion` из `spec/tools/release/version.mjs` подмодуля по тегам `.github`. Каждый релиз — Latest, неизменяемый, с аттестацией, а теги `v*` — под ruleset `v-tags`;
- **вызывающие** закрепляют общий workflow по SHA с комментарием версии на той же строке. Их Dependabot поднимает и SHA, и комментарий, если на коммите есть тег (раздел 4);
- **actions внутри общих workflow** закреплены так же, и их поднимает Dependabot самого `.github`. Слитое обновление выходит релизом, а за ним Dependabot вызывающих поднимает ссылку;
- **пауза `cooldown`** — три дня у каждой экосистемы Dependabot, у `.github` и у вызывающих, в том числе у `github-actions`, которая поднимает ссылки на `.github`: ошибка релиза должна успеть обнаружиться раньше, чем её разнесут двенадцать pull request. Базовый образ devcontainer пауза не держит: реестр Microsoft не сообщает дату релиза, и Dependabot предложил новый образ сразу — у `spec` и у canvas-api (T15 spec). Держит ли она ссылки на reusable workflow, документация не говорит (2.6), и это не проверено: видно будет на первом подъёме ссылки в T17 `spec`;
- **инструменты, которых Dependabot не видит**, — gitleaks, actionlint и shellcheck с суммами sha256 их архивов — поднимаются руками, как `ARG` в Dockerfile `spec` (R30 spec);
- **закрепление по SHA** держит правило Exact versions: требование организации закреплять по SHA к ссылке на reusable workflow не относится (раздел 4).

### 3.6. Секреты и форки

По R05 — для всех репозиториев `spec` записал его правило поправкой к R24 spec:
- общий workflow секретов не принимает: в его `workflow_call` нет `secrets`, а вызывающий не передаёт `secrets: inherit`. У него только `GITHUB_TOKEN` с правами, которые дал вызывающий;
- `pull_request_target` нет нигде; `workflow_run` не берёт код pull request с секретами или правом на запись, как у релиза `spec` (R31 spec);
- свой job с секретом идёт только на push в `main` и на pull request из ветки самого репозитория. Pull request с форка проходит общие проверки без секретов;
- на pull request с форка такой job не пропускается, а падает и называет причину. Пропущенный job засчитывается обязательной проверке как успех и мерж не держит (раздел 4), а упавший держит, пока правку не перенесли в ветку репозитория;
- pull request Dependabot идёт из ветки репозитория, но секретов Actions не получает — только секреты Dependabot (раздел 4). Как с ним поступает job с секретом, решается вместе с этим job, а для eval — в Т-28;
- где лежит ключ для eval — Т-28: секрет окружения в репозиториях с eval или Secret Manager `infra` через Workload Identity Federation; решается с eval на этапе 2. Сам вопрос открыл R24 spec.

## 4. Источники

Внешний факт — условия поставщика, цена, закон, документация библиотеки — встаёт сюда с источником и датой прочтения (RULES.md, The bar). Всё ниже прочитано 2026-10-19; цитаты дословные.

**Reusable workflows** (R03):
- **вызов и закрепление** — [GitHub Docs, Reuse workflows](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows), раздел Calling a reusable workflow: «`{owner}/{repo}/.github/workflows/{filename}@{ref}` for reusable workflows in public and private repositories» и «Using the commit SHA is the safest option for stability and security»;
- **папка** — там же, раздел Creating a reusable workflow: «Subdirectories of the `workflows` directory are not supported»;
- **лимиты** — [GitHub Docs, Reusing workflow configurations](https://docs.github.com/en/actions/reference/workflows-and-actions/reusing-workflow-configurations), раздел Limitations of reusable workflows: «You can connect up to ten levels of workflows» и «You can call a maximum of 50 unique reusable workflows from a single workflow file»;
- **права** — там же, раздел Supported keywords for jobs that call a reusable workflow: «If `jobs.<job_id>.permissions` is not specified in the calling job, the called workflow will have the default permissions for the `GITHUB_TOKEN`» и «The `GITHUB_TOKEN` permissions passed from the caller workflow can be only downgraded (not elevated) by the called workflow»;
- **контекст** — там же, раздел `github` context: «When a reusable workflow is triggered by a caller workflow, the `github` context is always associated with the caller workflow»;
- **checkout** — [GitHub Docs, Reusing workflow configurations](https://docs.github.com/en/actions/concepts/workflows-and-actions/reusing-workflow-configurations) (Concepts), раздел Reusable workflows: «if the called workflow uses `actions/checkout`, the action checks out the contents of the repository that hosts the caller workflow, not the called workflow»;
- **свои файлы общего workflow** — [GitHub Docs, Contexts reference](https://docs.github.com/en/actions/reference/workflows-and-actions/contexts), раздел `job` context: `job.workflow_sha` — «The commit SHA of the workflow file that defines the current job», `job.workflow_repository` — «The `owner/repo` of the repository containing the workflow file that defines the current job»; пример там же: «This example reusable workflow uses `job.workflow_repository` and `job.workflow_sha` to check out its own source code, rather than the caller's repository»;
- **имя проверки** в ruleset — «`<job name> / <reusable job name>`», цитата GitHub Docs в R30 spec;
- **репозиторий с именем `.github`** документация как место общих workflow не называет. Так устроен [nodenv/.github](https://github.com/nodenv/.github) (коммит 01e040a): `nodenv/nodenv` вызывает `uses: nodenv/.github/.github/workflows/release.yml@bd27009d5f178c0a88d42f7b07e6a3c7623ed768 # v7.0.8`, а README объясняет: «GitHub doesn't allow them to live in any other directory, so the reusable workflows are all in the same location as the workflows _for this repository. To distinguish them, the workflows for this repository are prefixed with `.github_`». Что Dependabot такую ссылку поднимает, мейнтейнер dependabot-core показал в [issue #12489](https://github.com/dependabot/dependabot-core/issues/12489), 2025-12-29: «issue is not reproducible. Attaching screenshots below for a bump PR to version 7.0.5». Окончательно это подтвердит первый вызов общего workflow (T17 `spec`).

**Закрепление по SHA и Dependabot** (R04):
- [GitHub Docs, Disabling or limiting GitHub Actions for your organization](https://docs.github.com/en/organizations/managing-organization-settings/disabling-or-limiting-github-actions-for-your-organization), раздел Managing GitHub Actions permissions for your organization: «When you enable **Require actions to be pinned to a full-length commit SHA**, all actions must be pinned to a full-length commit SHA to be used. This includes actions from your organization and actions authored by GitHub. Reusable workflows can still be referenced by tag»;
- [GitHub Docs, About Dependabot version updates](https://docs.github.com/en/code-security/concepts/supply-chain-security/dependabot-version-updates), раздел Updates for actions: «Dependabot also checks workflow files for uses of reusable workflows, and updates the Git reference for these called reusable workflows»;
- [GitHub Docs, Supported ecosystems and repositories](https://docs.github.com/en/code-security/reference/supply-chain-security/supported-ecosystems-and-repositories), раздел GitHub Actions: «If the commit you use is not associated with any tag, Dependabot will update the GitHub Actions to the latest commit (which might differ from the latest release)» и «Dependabot will ignore actions or reusable workflows referenced locally (for example, `./.github/actions/foo.yml`)». Комментарий версии он обновляет, если тот на той же строке, — цитата в R30 spec.

**CodeQL** (R03):
- [codeql-action, README](https://github.com/github/codeql-action), раздел Workflow Permissions: «All advanced setup code scanning workflows must have the `security-events: write` permission»;
- [GitHub Docs, Workflow configuration options](https://docs.github.com/en/code-security/reference/code-scanning/workflow-configuration-options), раздел Analysis category: «If you don't specify a `category` parameter in your workflow, GitHub will generate a category name for you, based on the name of the workflow file triggering the action, the action name, and any matrix variables». У общего workflow имя файла одно на все репозитории, поэтому `category` задаётся явно;
- default setup и свой workflow вместе не работают — цитата в T15 `spec`, «Выяснилось при планировании».

**Scorecard** (R03; раздел 2.2):
- [scorecard-action v2.5.0, README](https://github.com/ossf/scorecard-action/blob/v2.5.0/README.md), раздел Workflow Restrictions: «The workflow can't contain top level env vars or defaults», «No workflow level write permissions», «Only the job with `ossf/scorecard-action` can use `id-token: write` permissions», а для его job — «The steps running in this job must belong to this approved list of GitHub actions:» `actions/checkout`, `actions/upload-artifact`, `github/codeql-action/upload-sarif`, `ossf/scorecard-action`, `step-security/harden-runner`. Триггеры — `push` и `schedule` на основной ветке, цитата в R30 spec;
- [scorecard-webapp, PR #778](https://github.com/ossf/scorecard-webapp/pull/778) «Fix default branch verification», слит 2025-04-16: «This PR modifies the verification procedure to use the repository of the **calling** workflow instead»;
- что сервер результат отклонил, v2.5.0 не считает ошибкой: [`signing/signing.go`](https://github.com/ossf/scorecard-action/blob/fa7117db83c52d787ae5a89f350999701505d78e/signing/signing.go), функция `ProcessSignature`, на неудачной публикации пишет `::warning::Unable to POST scorecard results to webapp` и возвращает `nil`. Коммит fa7117d — тег v2.5.0; прочитано 2026-10-20;
- входа `fail_on_publish_error` в v2.5.0 нет: ни README, ни `action.yaml` этого тега его не называют. В `main` он есть с 2026-10-14 (коммит 1dfaf3539e, #1721): «Fail the step when the Scorecard API rejects published results». Придёт со следующим релизом.

**Секреты и форки** (R05):
- [GitHub Docs, Using secrets in GitHub Actions](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets), раздел Using secrets in a workflow: «With the exception of `GITHUB_TOKEN`, secrets are not passed to the runner when a workflow is triggered from a forked repository»;
- [GitHub Docs, Securely using pull_request_target](https://docs.github.com/en/actions/reference/security/securely-using-pull_request_target), раздел Risks of `pull_request_target`: «Workflows triggered by `pull_request_target` run with elevated trust: the job receives the base repository's `GITHUB_TOKEN` and access to repository and organization secrets»; там же: «Workflows triggered by this event should not check out, build, or run code from an untrusted pull request with access to repository secrets or a privileged `GITHUB_TOKEN`»;
- [GitHub Docs, Status checks](https://docs.github.com/en/pull-requests/reference/status-checks): «A job that is skipped will report its status as "Success". It will not prevent a pull request from merging, even if it is a required check»;
- [GitHub Docs, Dependabot on GitHub Actions](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-on-actions), раздел Restrictions when Dependabot triggers events: «Secrets are populated from Dependabot secrets. GitHub Actions secrets are not available».

**gitleaks** (R03): API GitHub — `repos/gitleaks/gitleaks/releases/latest`: v8.30.1, 2026-03-21, файлы — архивы под платформы и `gitleaks_8.30.1_checksums.txt`, подписи и аттестации нет; `repos/gitleaks/gitleaks/license`: MIT.

**CodeQL и Scorecard** (R09; прочитано 2026-10-20):
- **github/codeql-action** v4.39.0 — новейший тег `v4.*` по `git ls-remote --tags https://github.com/github/codeql-action` (выпущен 2026-10-15, API GitHub, `repos/github/codeql-action/releases/tags/v4.39.0`). Последний «релиз» репозитория — бандл CodeQL, а не версия action. Тег аннотированный, 48870fd, и указывает на коммит `6f2ac81f5cd81fe351a197ba0b00d91d03cd2aee` (`repos/github/codeql-action/git/tags/48870fdd6b42ee6474ec4207209ff87609271a5e`). Входы `init` этой версии — `languages`, `build-mode`, `queries` (`init/action.yml` на теге v4.39.0);
- **actions/upload-artifact** v7.0.2 — последний релиз (2026-10-07, `repos/actions/upload-artifact/releases/latest`), тег указывает на коммит `cf430e030ddbb5b0abf93d22962f4752f3646cd9` (`repos/actions/upload-artifact/git/refs/tags/v7.0.2`);
- **бандл CodeQL** — `init/action.yml` на коммите 6f2ac81, вход `tools`: «A special value `linked` which uses the version of the CodeQL tools that the Action has been bundled with», а без входа — «the Action will check in several places until it finds the CodeQL tools». В `src/setup-codeql.ts` того же коммита без входа берётся `defaultCliVersion.enabledVersions[0]` — версия из флагов GitHub, а с `linked` — версия из `src/defaults.json`, `"cliVersion": "2.27.2"`. Прогон на pull request #10 это подтвердил: «'tools: linked' was requested, so using CodeQL version 2.27.2, the version shipped with the Action»;
- **находки и мерж** — [GitHub Docs, Triaging code scanning alerts in pull requests](https://docs.github.com/en/code-security/how-tos/manage-security-alerts/manage-code-scanning-alerts/triage-alerts-in-pull-requests): «the check that contains the results of code scanning is: Code scanning results» и «If the code scanning results check finds any problems with a severity of `error`, `critical`, or `high`, the check fails». На pull request #10 эта проверка называется «CodeQL», её ставит приложение `github-advanced-security` (id 57789): «No new alerts in code changed by this pull request». Правило ruleset — [GitHub Docs, Available rules for rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets), раздел Require code scanning results: мерж не пройдёт, если «A required tool finds a code scanning alert of a severity that is defined in the ruleset», «A required tool's analysis is still in progress» или «A required tool is not configured for the repository». У canvas-api это правило `code_scanning` с инструментом CodeQL, порогами `errors` и `high_or_higher` (API GitHub, `repos/mathtrail/canvas-api/rulesets/25036747`);
- **проверки пропущенной матрицы** — пробный pull request #9: `self-codeql.yml` передал `go`, «CodeQL / languages» упала, а за анализы пришла одна проверка, «CodeQL / analyze (${{ matrix.language }})», пропущенная; проверки «CodeQL / analyze (actions)» не было;
- **сборка для CodeQL** — [GitHub Docs, CodeQL build options and steps for compiled languages](https://docs.github.com/en/code-security/reference/code-scanning/codeql/build-options-for-compiled-languages), раздел Building Go: «CodeQL supports build modes `autobuild` or `manual` for Go code» — без сборки, `none`, Go не разбирается;
- **API Scorecard** — `https://api.scorecard.dev/projects/github.com/<владелец>/<репозиторий>`: принятый результат приходит с датой, коммитом репозитория и оценкой — поля `date`, `repo.commit`, `score` в ответе для `ossf/scorecard`; у репозитория без опубликованного результата — 404, как у `spec`.

**Релиз `.github`** (R10; прочитано 2026-10-20):
- **Dangerous-Workflow у Scorecard** — [`checks/raw/dangerous_workflow.go`](https://github.com/ossf/scorecard/blob/61e84743356275f6ffca23b1b2f2cb945e19eb96/checks/raw/dangerous_workflow.go) на коммите 61e8474, той версии Scorecard, v5.6.0, которой сервер посчитал `.github` (поле `scorecard` в ответе API Scorecard). В workflow с триггером `pull_request_target` или `workflow_run` функция `checkJobForUntrustedCodeCheckout` отмечает checkout, у которого `ref` содержит `github.event.pull_request` или `github.event.workflow_run`; условие `if` job она не читает;
- **неизменяемые релизы** — API GitHub: `PUT repos/altnovatrail/.github/immutable-releases` ответил 204, а `GET` того же пути — `{"enabled":true,"enforced_by_owner":false}`, как у `spec`. Ruleset `v-tags` — `POST repos/altnovatrail/.github/rulesets` с правилами `update`, `deletion` и `non_fast_forward` на `refs/tags/v*`, без обхода; образец — ruleset `spec` 25426896;
- **отказ Releases API** коммиту, который уже не вершина `main`, — [GitHub Docs, REST API endpoints for releases](https://docs.github.com/en/rest/releases/releases), Create a release: «If the commit identified by target_commitish … adds or modifies any file under .github/workflows/ relative to the repository's default branch, the authenticating token must be authorized to modify workflows. Otherwise, this endpoint returns 404 Not Found; some authentication paths surface 403 Resource not accessible by integration instead», и «The GITHUB_TOKEN available to GitHub Actions cannot be authorized for this». У `release.yml` `spec` на v0.2.6 пропускается только 404;
- **оболочка шага** — без `shell` шаг на Linux идёт как `bash -e {0}`, а с `shell: bash` — как `bash --noprofile --norc -eo pipefail {0}`: [GitHub Docs, Workflow syntax](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax), раздел `defaults.run.shell`.

**Инструменты общих проверок** (R08; прочитано 2026-10-20):
- **gitleaks** — [README v8.30.1](https://github.com/gitleaks/gitleaks/blob/v8.30.1/README.md), раздел Load Configuration: «The order of precedence is:», и четвёртым — «A `.gitleaks.toml` file within the target path». Сумма архива `gitleaks_8.30.1_linux_x64.tar.gz` — из `gitleaks_8.30.1_checksums.txt` того же релиза: `551f6fc83ea457d62a0d98237cbad105af8d557003051f41f3e7ca7b3f2470eb`;
- **actionlint** 1.7.12 — последний релиз (API GitHub, `repos/rhysd/actionlint/releases/latest`, 2026-03-30); сумма архива `actionlint_1.7.12_linux_amd64.tar.gz` — из `actionlint_1.7.12_checksums.txt`: `8aca8db96f1b94770f1b0d72b6dddcb1ebb8123cb3712530b08cc387b349a3d8`;
- **shellcheck** 0.11.0 — последний релиз (API GitHub, `repos/koalaman/shellcheck/releases/latest`, 2025-08-04), лицензия — GPL-3.0 (`repos/koalaman/shellcheck/license`); файлов сумм в нём нет, поэтому сумма `shellcheck-v0.11.0.linux.x86_64.tar.xz` посчитана по скачанному архиву: `8c3be12b05d5c177a04c29e3c78ce89ac86f1595681cab149b65b97c4e227198`;
- **gitleaks без `--log-opts`** читает все ветки, а не только историю проверяемого коммита: локальная проба 2026-10-20 — ключ в другой ветке нашёлся без `--log-opts` и не нашёлся с `--log-opts=HEAD`;
- **actions/checkout** v7.0.1 — последний релиз (2026-07-20); тег стоит на коммите `3d3c42e5aac5ba805825da76410c181273ba90b1` (API GitHub, `repos/actions/checkout/git/refs/tags/v7.0.1`).

**Подпись без ключей из reusable workflow** (раздел 2.3):
- [Fulcio, OIDC usage](https://github.com/sigstore/fulcio/blob/main/docs/oidc.md), раздел Case study: GitHub Actions: «GitHub Actions uses the `job_workflow_ref` as its SAN»;
- [Fulcio, OID information](https://github.com/sigstore/fulcio/blob/main/docs/oid-info.md), раздел Mapping OIDC token claims to Fulcio OIDs: `job_workflow_ref` — это Build Signer URI, «Reference to specific build instructions that are responsible for signing. Can be the same as Build Config URI. For example a reusable workflow in GitHub Actions or a Circle CI Orbs»; `workflow_ref` — Build Config URI, «A reference to the initiating build instructions»; `repository` — Source Repository URI;
- [GitHub Docs, OpenID Connect reference](https://docs.github.com/en/actions/reference/security/oidc), раздел Custom claims provided by GitHub, `job_workflow_ref`: «For jobs using a reusable workflow, the ref path to the reusable workflow».

  Значит, подпись общего релиза называет общий workflow, а вызывающий workflow и его репозиторий — в Build Config URI и Source Repository URI.

**canvas-api** (R03): `.github/workflows/` на коммите [0901af0](https://github.com/MathTrail/canvas-api/tree/0901af0439280334b3da33ffc4cc5c853e4403ff/.github/workflows) — `ci.yml`, `codeql.yml`, `scorecard.yml`, `release.yml` и `deploy.yml`. Единственный reusable workflow — `deploy.yml`, и его вызывает только `release.yml` того же репозитория; workflow других репозиториев canvas-api не вызывает. Проверка лицензий — R48 canvas-api, подпись — R52 canvas-api, CI в образе тулчейна — R49 canvas-api.
