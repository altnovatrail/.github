# .github — архитектура

> Статус: 2026-10-20, эпик E1 закончен (T01–T05), идёт эпик E2. Пункт, который карточка оставила детализации, решён — общие и свои workflow (R03–R05, раздел 3). Что ещё открыто — раздел 2: 2.4–2.6, 2.9 и 2.7 — где общий workflow держит данные — автор решил при планировании E2, и в раздел 3 их переносят задачи E2, а список лицензий по 2.7 положит E3; 2.2 и 2.8 проверят E2 и T17 `spec`; 2.3 — Т-27 `spec`, вместе с эпиком E3. Файлов workflow ещё нет: общие проверки пишет эпик E2, workflow для кода — эпик E3.
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
- **Задача:** эпик E2 — общий `scorecard.yml` и первый шаг; второй — первый вызов в T17 `spec`.

### 2.3. Подпись общего релиза: чья идентичность

- **Суть:** подпись без ключей из общего workflow релиза получит идентичность того workflow, который её ставит. Проверка подписи, как R52 canvas-api, сверяет точную идентичность `release.yml@refs/heads/main` вызывающего репозитория, а у общего релиза она будет другой.
- **Что известно:** сертификат Sigstore для job из reusable workflow называет идентичностью (SAN) общий workflow, а вызывающий workflow и его репозиторий несёт в своих расширениях — Build Config URI и Source Repository URI (раздел 4). Проверяет подпись пакета `module-kit` (architecture 3.7 spec; R17 spec), а образ и сборки — `infra` (Т-19).
- **Как решится:** с первым релизом `module-kit` (E2 `spec`), вместе с общим workflow релиза: что именно проверяют `module-kit` и `infra` — идентичность общего workflow, репозиторий и workflow вызывающего или то и другое. Вызывающий закрепляет общий workflow по SHA (R04), так что SAN кончается на `@<sha>`, а не на теге, и проверка должна убедиться, что этот SHA — релиз `.github`. Варианты и рекомендация — Т-27: `spec` записал вопрос и рекомендацию `.github` — проверять то и другое, SAN по SHA одного из релизов `.github`.
- **Задача:** эпик E3, с первым релизом `module-kit`; сам вопрос — Т-27, его решают вместе с `module-kit` и `infra`, которые проверяют подпись.

### 2.4. Какие коммиты `main` получают релиз

- **Суть:** R04 выпускает общие workflow релизами, как R31 spec. Но `spec` выпускает каждый зелёный коммит `main`, а у `.github` есть коммиты, которые общих workflow не трогают: профиль, файлы сообщества, свои `self-` workflow, документы.
- **Что известно:** Dependabot вызывающих поднимает ссылку до нового тега (R04). Релиз без изменений в общих workflow дал бы по pull request в каждом из двенадцати вызывающих репозиториев — `.github` вызывает свои общие workflow по локальному пути, и Dependabot их не трогает (раздел 4), — на workflow, который не менялся. Расписание Dependabot у вызывающих — раз в неделю (раздел 3.3), так что в неделю таких pull request не больше одного на репозиторий.
- **Варианты:** каждый зелёный коммит, как у `spec`; только коммит, который меняет общий workflow — файл в `.github/workflows/` без префикса `self-` или файл, который общий workflow читает из `.github` (2.7).
- **Рекомендация:** только коммит, который меняет общий workflow или то, что он читает. Номер версии тогда значит «изменились общие workflow», и pull request Dependabot у вызывающих приходит только с правкой, которая их касается.
- **Задача:** эпик E2, вместе с `self-release.yml`.

### 2.5. Как `.github` считает номер релиза

- **Суть:** у `spec` номер считает `tools/release/version.mjs` с тестами, а рецепт `release-version` подаёт ему три списка тегов `v*`: все теги, теги из истории `HEAD` и теги на самом `HEAD` (justfile `spec`; R31 spec). Своего кода у `.github` нет.
- **Варианты:** тот же `spec/tools/release/version.mjs` из подмодуля, а на вход — списки тегов самого `.github`; своя копия рецепта и скрипта.
- **Рекомендация:** скрипт из подмодуля: те же правила номера, что у `spec`, и те же тесты, без второй копии. Рецепт `release-version` из `spec/justfile` как есть не годится: он перечисляет теги того репозитория, где запущен, — проверить, где запускает рецепты just, в задаче, которая пишет `self-release.yml`.
- **Задача:** эпик E2.

### 2.6. Пауза `cooldown` для ссылок на `.github`

- **Суть:** Dependabot ждёт три дня после выхода версии, прежде чем её предложить, — так записано в `dependabot.yml` `spec` для каждой экосистемы (R30 spec). Ссылки на общие workflow он поднимает в той же экосистеме `github-actions`; что пауза действует и на них, документация отдельно не говорит.
- **Варианты:** оставить три дня, как для всего; ссылки на `altnovatrail/.github` поднимать без паузы — если `cooldown` позволяет исключить зависимость, это сверить с документацией Dependabot.
- **Рекомендация:** оставить три дня. Релиз `.github` уже прошёл свой CI, где общие workflow вызваны по локальному пути (раздел 3.4), но три дня дают заметить ошибку до того, как её разнесут двенадцать pull request. Срочную правку можно поднять в репозиториях и руками.
- **Задача:** эпик E2 решает и записывает в разделе 3.3; в `dependabot.yml` вызывающих это переносят T17 и T16 `spec`, которые пишут их файлы.

### 2.7. Как общий workflow читает файлы `.github` своей версии

- **Суть:** общему workflow могут понадобиться данные — список лицензий (3.1), версия и сумма gitleaks. `actions/checkout` в нём берёт вызывающий репозиторий, а не `.github` (раздел 4).
- **Что известно:** GitHub описывает, как reusable workflow берёт свой репозиторий своей версии: `actions/checkout` с `repository: ${{ job.workflow_repository }}` и `ref: ${{ job.workflow_sha }}` (раздел 4).
- **Варианты:** держать данные прямо в файле общего workflow — список в десяток идентификаторов SPDX, версию и сумму; держать их отдельными файлами `.github` и брать вторым checkout по `job.workflow_repository` и `job.workflow_sha`.
- **Рекомендация:** в самом файле, пока данные так малы. Тогда правка данных — правка общего workflow, она и даёт релиз (2.4), а вызывающий получает данные той версии, на которой закреплён. Отдельный файл — когда данных станет больше, с checkout по `job.workflow_sha`.
- **Задача:** эпик E2 — для gitleaks, эпик E3 — для списка лицензий.

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

| Workflow | Что делает | Кто вызывает | Входы | Права от вызывающего | Что нужно от репозитория | Держит мерж |
|---|---|---|---|---|---|---|
| `secrets.yml` | поиск секретов gitleaks по всей истории, как R49 canvas-api; бинарник по точной версии, архив сверяется с закреплённой суммой sha256 | все | нет | `contents: read` | `.gitleaks.toml` со своими исключениями — по желанию | да |
| `dco.yml` | у каждого коммита pull request, кроме merge-коммитов, есть `Signed-off-by` его автора (R30 spec); коммиты берёт `git log` диапазона pull request из checkout с полной историей, без API | все, на pull request | нет | `contents: read` | — | да |
| `documents.yml` | собирает стадию `toolchain` из `.devcontainer/Dockerfile` вызывающего, берёт checkout с подмодулем и запускает `just -f spec/justfile docs-check-repo` (R32 spec) | все, кроме `spec`: у него свой `just docs-check` | нет | `contents: read` | `.devcontainer/Dockerfile` со стадией `toolchain` и подмодуль `spec/` — оба из заготовки | да |
| `codeql.yml` | CodeQL advanced setup: язык `actions` всегда, языки репозитория — входом, `category` по языку явно | все | языки репозитория сверх `actions`; до кода — пусто, у `spec` — `javascript-typescript` для `tools/` (T17 spec) | `contents: read`, `security-events: write` | для компилируемого языка — сборка, с кодом | да |
| `scorecard.yml` | OpenSSF Scorecard с публикацией результатов | все, на push в `main` и по расписанию | нет | на job — `security-events: write` и `id-token: write`; на уровне workflow — только чтение | вызывающий — отдельный маленький файл без `env` и `defaults` (2.2) | нет (R30 spec) |

Dependabot подписывает коммит не тем адресом, каким назван автор. У `spec` в коммите c6b3cb5 автор — `dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>`, а подпись — `Signed-off-by: dependabot[bot] <support@github.com>`. Поэтому `dco.yml` сверяет подпись с автором по имени и адресу, а для `dependabot[bot]` принимает эту подпись названным исключением. Иначе каждый pull request Dependabot был бы красным, а T17 `spec` ждёт обратного.

**С первым кодом — у репозиториев с кодом** (эпик E3 — вместе с эпиком E2 `spec` и первым кодом `module-kit`):

| Workflow | Что делает | Кто вызывает | Входы | Права от вызывающего | Что нужно от репозитория | Держит мерж |
|---|---|---|---|---|---|---|
| `go.yml` | собирает стадию `toolchain` вызывающего и запускает его рецепты `just` с условленными именами — проверки языка, тесты, уязвимости, лицензии | репозитории вида go | с первым кодом `module-kit` | `contents: read` | рецепты с этими именами; исключения проверки лицензий — свои, каждое с решением, как R48 canvas-api | да |
| `typescript.yml` | то же для TypeScript | репозитории вида typescript | с первым кодом | `contents: read` | то же | да |
| `release.yml` | релиз с подписью без ключей: подписывает каждый файл, как R52 canvas-api, и пакеты модулей (R17 spec) | `module-kit` первым, затем `modules` и остальные репозитории с релизами | с первым релизом `module-kit` | `contents: write` и `id-token: write` — для релиза и подписи без ключей, как у релиза canvas-api (R52 canvas-api); остальное — с первым релизом | рецепт, который собирает файлы релиза | нет: это не проверка pull request |

Список лицензий для `go.yml` и `typescript.yml` один на всех — категория A политики ASF, как у проверки `spec` (поправка к R12 spec). Где он лежит — 2.7. Точные входы и имена рецептов — с первым кодом `module-kit`. Идентичность подписи — 2.3.

Имена job в общих workflow и в вызывающих файлах одни на все репозитории: обязательная проверка называется «`<job name> / <reusable job name>`» (раздел 4), и ruleset `main` у всех репозиториев перечисляет одни и те же имена (R30 spec). Сами имена задают файлы.

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
- `.github/workflows/codeql.yml` — на pull request, push в `main` и раз в неделю: вызывает `codeql.yml` со своими языками;
- `.github/workflows/scorecard.yml` — на push в `main` и раз в неделю: вызывает `scorecard.yml`;
- `.github/dependabot.yml` — раз в неделю, как у `spec`: `github-actions` в `/`, он поднимает и ссылки на общие workflow, и `docker` в `/.devcontainer`; экосистемы языков — с кодом (repositories 2.2 spec, шаг 5);
- `.sonarcloud.properties` — без `spec/**` (Д7 в RUN.md `spec`).

Отличия:
- у `spec` в `ci.yml` нет `documents.yml` — рядом его свой job «Documents and tools», — а в `.sonarcloud.properties` нет исключения `spec/**`: подмодуля у него нет;
- у `.github` вызывающие файлы свои, с префиксом `self-` (раздел 3.4): имена `codeql.yml` и `scorecard.yml` здесь заняты самими общими workflow.

Файлы репозиториев компонентов и `spec` пишет сессия `spec` — через `.repos/<имя>`, как при заведении репозитория (R30 spec).

### 3.4. Свой CI `.github`

Свои workflow `.github` лежат рядом с общими и начинаются с `self-`; у общих префикса нет, и запускаются они только через `workflow_call`:
- `self-ci.yml` вызывает общие workflow по локальному пути `./.github/workflows/<файл>`, так что pull request проверяет ту версию, которую сам и меняет. Кроме них — actionlint по всем workflow: их код живёт здесь;
- `self-release.yml` — свой релиз, как у `spec` (R31 spec): после зелёного `self-ci.yml` на `main` — следующий патч линии, неизменяемый релиз с аттестацией, теги `v*` под ruleset (R04);
- `self-codeql.yml` и `self-scorecard.yml` вызывают общие CodeQL и Scorecard, тоже по локальному пути; `dependabot.yml` и `.sonarcloud.properties` — как в 3.3.

### 3.5. Версии и обновления

По R04:
- **релиз `.github`** выходит сам после зелёного CI на `main` — следующий патч `vX.Y.Z`, — как R31 spec; какие коммиты его получают — 2.4;
- **вызывающие** закрепляют общий workflow по SHA с комментарием версии на той же строке. Их Dependabot поднимает и SHA, и комментарий, если на коммите есть тег (раздел 4);
- **actions внутри общих workflow** закреплены так же, и их поднимает Dependabot самого `.github`. Слитое обновление выходит релизом, а за ним Dependabot вызывающих поднимает ссылку;
- **инструменты, которых Dependabot не видит**, — версия gitleaks с суммой sha256 архива, actionlint — поднимаются руками, как `ARG` в Dockerfile `spec` (R30 spec);
- **закрепление по SHA** держит правило Exact versions: требование организации закреплять по SHA к ссылке на reusable workflow не относится (раздел 4).

Какие коммиты получают релиз, как считается номер и нужна ли ссылкам на `.github` пауза `cooldown` — открытые пункты 2.4–2.6.

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

**Подпись без ключей из reusable workflow** (раздел 2.3):
- [Fulcio, OIDC usage](https://github.com/sigstore/fulcio/blob/main/docs/oidc.md), раздел Case study: GitHub Actions: «GitHub Actions uses the `job_workflow_ref` as its SAN»;
- [Fulcio, OID information](https://github.com/sigstore/fulcio/blob/main/docs/oid-info.md), раздел Mapping OIDC token claims to Fulcio OIDs: `job_workflow_ref` — это Build Signer URI, «Reference to specific build instructions that are responsible for signing. Can be the same as Build Config URI. For example a reusable workflow in GitHub Actions or a Circle CI Orbs»; `workflow_ref` — Build Config URI, «A reference to the initiating build instructions»; `repository` — Source Repository URI;
- [GitHub Docs, OpenID Connect reference](https://docs.github.com/en/actions/reference/security/oidc), раздел Custom claims provided by GitHub, `job_workflow_ref`: «For jobs using a reusable workflow, the ref path to the reusable workflow».

  Значит, подпись общего релиза называет общий workflow, а вызывающий workflow и его репозиторий — в Build Config URI и Source Repository URI.

**canvas-api** (R03): `.github/workflows/` на коммите [0901af0](https://github.com/MathTrail/canvas-api/tree/0901af0439280334b3da33ffc4cc5c853e4403ff/.github/workflows) — `ci.yml`, `codeql.yml`, `scorecard.yml`, `release.yml` и `deploy.yml`. Единственный reusable workflow — `deploy.yml`, и его вызывает только `release.yml` того же репозитория; workflow других репозиториев canvas-api не вызывает. Проверка лицензий — R48 canvas-api, подпись — R52 canvas-api, CI в образе тулчейна — R49 canvas-api.
