# .github — источники

> Внешние факты, на которых стоят документы `docs/`: документация GitHub и других поставщиков, код actions и инструментов на коммите, ответы API GitHub и реестра npm, теги `spec`, файлы других репозиториев. Здесь — их записи: адрес, версия или коммит, дата прочтения и цитата на языке источника, а [architecture.md](architecture.md) и журнал держат утверждение и ссылку на запись по номеру, как на раздел: `sources 2.1` (RULES.md spec, The bar; R143 spec).
>
> Итоги замеров — пробные pull request и их прогоны, шаги, прогнанные отдельно от workflow, набор тестов шагов, длительности и размеры — в [measurements.md](measurements.md).

## 1. Как вести

- **Запись** — подраздел «N.M» темы: один источник — страницы одного издателя об одном предмете, код или файлы одного проекта, тег `spec` — или одно чтение нескольких источников ради одного решения. В ней — адрес, версия, коммит или дата страницы, дата прочтения и цитата на языке источника, дословно. Что прочитано не из первоисточника — копия, цитата из решения `spec`, — запись так и называет.
- **Чтение** — абзац «Прочитано <дата> (<решение или задача>):» и пункты под ним. Чтения одного источника в разные даты — одна запись, по датам.
- **Ссылка.** Утверждение документа ссылается на запись по номеру, как на раздел: `sources 2.1`, а из другого репозитория — `sources 2.1 .github`. Номер записи не меняется: новая запись — в конец своей темы, новая тема — в конец файла.
- **Источник прочитан снова** — новое чтение с датой в той же записи, а прежний текст не правится: на нём стоят решения его дня. Если источник изменился и утверждение с ним разошлось, это поправка к решению или пункт architecture 2, а не правка записи.
- **Чего здесь нет:** итогов замеров — они в measurements.md, а запись, при которой стояла проба, называет её замер; цитат, которые записи журнала дают сами, — они остаются в записи (RULES.md spec, How we work: решение не переписывается).
- **Откуда.** Записи 2.1–14.2 — прежний раздел «Источники», architecture 4, разобранный по источникам 2026-11-12 (T55). Пункты перенесены дословно; пункт, где рядом с цитатой стояла проба, разрезан, и обе части ссылаются друг на друга. Какая группа раздела ушла в какие записи, называет таблица architecture 4. Не из него — запись 13.6 и чтения, которые называют T55.

## 2. GitHub Actions

### 2.1. Reusable workflows

Прочитано 2026-10-19 (R03):
- **вызов и закрепление** — [GitHub Docs, Reuse workflows](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows), раздел Calling a reusable workflow: «`{owner}/{repo}/.github/workflows/{filename}@{ref}` for reusable workflows in public and private repositories» и «Using the commit SHA is the safest option for stability and security»;
- **папка** — там же, раздел Creating a reusable workflow: «Subdirectories of the `workflows` directory are not supported»;
- **лимиты** — [GitHub Docs, Reusing workflow configurations](https://docs.github.com/en/actions/reference/workflows-and-actions/reusing-workflow-configurations), раздел Limitations of reusable workflows: «You can connect up to ten levels of workflows» и «You can call a maximum of 50 unique reusable workflows from a single workflow file»;
- **права** — там же, раздел Supported keywords for jobs that call a reusable workflow: «If `jobs.<job_id>.permissions` is not specified in the calling job, the called workflow will have the default permissions for the `GITHUB_TOKEN`» и «The `GITHUB_TOKEN` permissions passed from the caller workflow can be only downgraded (not elevated) by the called workflow»;
- **контекст** — там же, раздел `github` context: «When a reusable workflow is triggered by a caller workflow, the `github` context is always associated with the caller workflow»;
- **checkout** — [GitHub Docs, Reusing workflow configurations](https://docs.github.com/en/actions/concepts/workflows-and-actions/reusing-workflow-configurations) (Concepts), раздел Reusable workflows: «if the called workflow uses `actions/checkout`, the action checks out the contents of the repository that hosts the caller workflow, not the called workflow»;
- **имя проверки** в ruleset — «`<job name> / <reusable job name>`», цитата GitHub Docs в R30 spec.

Прочитано 2026-11-01 (поправки 2026-11-01 к R16 и R19, T34):
- **права в reusable workflow** — [GitHub Docs, Reusing workflow configurations](https://docs.github.com/en/actions/reference/workflows-and-actions/reusing-workflow-configurations): «The `GITHUB_TOKEN` permissions passed from the caller workflow can be only downgraded (not elevated) by the called workflow». Чем кончается вызов без права, страница не говорит. Чем это кончилось на пробе, — measurements 4.1.

### 2.2. Контексты, переменные и события

Прочитано 2026-10-19 (R03):
- **свои файлы общего workflow** — [GitHub Docs, Contexts reference](https://docs.github.com/en/actions/reference/workflows-and-actions/contexts), раздел `job` context: `job.workflow_sha` — «The commit SHA of the workflow file that defines the current job», `job.workflow_repository` — «The `owner/repo` of the repository containing the workflow file that defines the current job»; пример там же: «This example reusable workflow uses `job.workflow_repository` and `job.workflow_sha` to check out its own source code, rather than the caller's repository».

Прочитано 2026-10-20 (R10):
- **контекст `workflow_run`** — [GitHub Docs, Events that trigger workflows](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows), раздел `workflow_run`: `GITHUB_SHA` — «Last commit on default branch», `GITHUB_REF` — «Default branch».

Прочитано 2026-10-20 (R12; поправка к R10):
- **файл workflow** — [GitHub Docs, Workflows](https://docs.github.com/en/actions/concepts/workflows-and-actions/workflows), раздел Workflow triggers: «Each workflow run will use the version of the workflow that is present in the associated commit SHA or Git ref of the event». У `workflow_run` это `GITHUB_SHA`, последний коммит основной ветки (выше, «контекст `workflow_run`»).

Прочитано 2026-10-21 (R18):
- **`job.workflow_ref`** — [GitHub Docs, Contexts reference](https://docs.github.com/en/actions/reference/workflows-and-actions/contexts), раздел `job` context: «The full ref of the workflow file that defines the current job».

Прочитано 2026-10-21 (R19):
- **`CI`** — GitHub, [Variables reference](https://github.com/github/docs/blob/efd4783/content/actions/reference/workflows-and-actions/variables.md) на коммите efd4783, Default environment variables: «`CI` | Always set to `true`».

Прочитано 2026-11-01 (R28, T35):
- **переменные по умолчанию** — github/docs на 33b1f4a, `data/reusables/actions/environment-variables-are-fixed.md`: «You can't overwrite the value of the default environment variables named `GITHUB_*` and `RUNNER_*`. Currently you can overwrite the value of the `CI` variable. However, it's not guaranteed that this will always be possible».

Прочитано 2026-11-08 (R33, T48):
- **`job.workflow_repository` и `job.workflow_sha`** — [GitHub Docs, Contexts reference](https://docs.github.com/en/actions/reference/workflows-and-actions/contexts) их описывает: «The commit SHA of the workflow file that defines the current job» и «The `owner/repo` of the repository containing the workflow file that defines the current job». Что их не знает actionlint 1.7.12, — measurements 2.5.

### 2.3. Оболочка шага и `set -e`

Прочитано 2026-10-20 (R10):
- **оболочка шага** — без `shell` шаг на Linux идёт как `bash -e {0}`, а с `shell: bash` — как `bash --noprofile --norc -eo pipefail {0}`: [GitHub Docs, Workflow syntax](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax), раздел `defaults.run.shell`.

Прочитано 2026-10-22 (R22, поправки к R16 и R19, T26):
- **оболочка шага** — GitHub Docs, Workflow syntax, `content/actions/reference/workflows-and-actions/workflow-syntax.md` на коммите c67a936 github/docs: «By default, fail-fast behavior is enforced using `set -e` for both `sh` and `bash`. When `shell: bash` is specified, `-o pipefail` is also applied».

Прочитано 2026-11-01 (R28, T35):
- **оболочки шагов** — github/docs на коммите 33b1f4a, `data/reusables/actions/supported-shells.md`. У Linux без `shell` — «`bash -e {0}`», и «Note that this runs a different command to when `bash` is specified explicitly». С `shell: bash` — «`bash --noprofile --norc -eo pipefail {0}`».
- **`set -e` в bash** — [Bash Reference Manual, The Set Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html), редакция 5.3:
  - «The shell does not exit if the command that fails is part of the command list immediately following a while or until reserved word, part of the test in an if statement, part of any command executed in a && or || list except the command following the final && or ||»;
  - «If a compound command or shell function executes in a context where -e is being ignored, none of the commands executed within the compound command or function body will be affected by the -e setting, even if -e is set and a command returns a failure status».

### 2.4. Секреты, форки и пропущенные job

Прочитано 2026-10-19 (R05):
- [GitHub Docs, Using secrets in GitHub Actions](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets), раздел Using secrets in a workflow: «With the exception of `GITHUB_TOKEN`, secrets are not passed to the runner when a workflow is triggered from a forked repository»;
- [GitHub Docs, Securely using pull_request_target](https://docs.github.com/en/actions/reference/security/securely-using-pull_request_target), раздел Risks of `pull_request_target`: «Workflows triggered by `pull_request_target` run with elevated trust: the job receives the base repository's `GITHUB_TOKEN` and access to repository and organization secrets»; там же: «Workflows triggered by this event should not check out, build, or run code from an untrusted pull request with access to repository secrets or a privileged `GITHUB_TOKEN`»;
- [GitHub Docs, Status checks](https://docs.github.com/en/pull-requests/reference/status-checks): «A job that is skipped will report its status as "Success". It will not prevent a pull request from merging, even if it is a required check»;
- [GitHub Docs, Dependabot on GitHub Actions](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-on-actions), раздел Restrictions when Dependabot triggers events: «Secrets are populated from Dependabot secrets. GitHub Actions secrets are not available».

### 2.5. OIDC в GitHub Actions

Прочитано 2026-10-19 (architecture 2.3):
- [GitHub Docs, OpenID Connect reference](https://docs.github.com/en/actions/reference/security/oidc), раздел Custom claims provided by GitHub, `job_workflow_ref`: «For jobs using a reusable workflow, the ref path to the reusable workflow».

Прочитано 2026-10-22 (поправки к R10 и R18, T25):
- **токен OIDC в шагах** — github/docs на коммите 5815d11, `content/actions/reference/security/oidc.md`, раздел Methods for requesting the OIDC token: «The following environment variables on the runner» — `ACTIONS_ID_TOKEN_REQUEST_URL` и `ACTIONS_ID_TOKEN_REQUEST_TOKEN`, «Bearer token for the request to the OIDC provider». Как их читает cosign, — sources 7.1.

Прочитано 2026-10-22 (поправка к R18, T27):
- **GitHub OIDC** — github/docs на коммите 5815d11, `oidc-with-reusable-workflows.md`: «The `workflow`, `ref`, and other attributes describe the caller workflow, while `job_workflow_ref` refers to the called workflow».

### 2.6. Раннеры GitHub

Прочитано 2026-10-21 (R19):
- **Docker на раннере** — На раннере ubuntu-24.04 — Docker 28.0.4 и Buildx 0.38.0 ([`Ubuntu2404-Readme.md`](https://github.com/actions/runner-images/blob/06f4a91/images/ubuntu/Ubuntu2404-Readme.md) на коммите 06f4a91, образ 20261012.334.1).

Прочитано 2026-11-01 (R28, T35):
- **образ раннера** — [`Ubuntu2404-Readme.md`](https://github.com/actions/runner-images/blob/4da2307112a0fad2fd2ecaca8ba7d08683b8c581/images/ubuntu/Ubuntu2404-Readme.md) на коммите 4da2307, образ 20261026.354.1: Bash 5.2.21(1)-release, Git 2.56.0, jq 1.7, OpenSSL 3.0.13-0ubuntu3.16, tar 1.35+dfsg-3ubuntu0.4 и yq 4.54.1. В devcontainer — bash 5.2.21, git 2.56.0, jq 1.7, OpenSSL 3.0.13 и GNU tar 1.35.

Прочитано 2026-11-08 (поправка 2026-11-08 к R16, T47):
- [GitHub Docs, GitHub-hosted runners reference](https://docs.github.com/en/actions/reference/runners/github-hosted-runners), раздел Standard GitHub-hosted runners for public repositories: в таблице у Linux arm64 — `ubuntu-24.04-arm`, `ubuntu-22.04-arm` и `ubuntu-26.04-arm`, 4 CPU и 16 GB, и «Use of the standard GitHub-hosted runners is free and unlimited on public repositories».

### 2.7. `actions/checkout`

Прочитано 2026-10-20 (R08):
- **actions/checkout** v7.0.1 — последний релиз (2026-07-20); тег стоит на коммите `3d3c42e5aac5ba805825da76410c181273ba90b1` (API GitHub, `repos/actions/checkout/git/refs/tags/v7.0.1`).

Прочитано 2026-10-20 (R12; поправка к R10):
- **checkout v7.0.1 без `ref`** — [`src/input-helper.ts`](https://github.com/actions/checkout/blob/3d3c42e5aac5ba805825da76410c181273ba90b1/src/input-helper.ts) на коммите 3d3c42e. Если `ref` не задан, checkout берёт ref и коммит события: `result.ref = github.context.ref` и `result.commit = github.context.sha`.

Прочитано 2026-10-22 (поправки к R10 и R18, T28):
- **post-шаг `actions/checkout`** — v7.0.1 на коммите 3d3c42e, тот, что закреплён в обоих релизах. В его `action.yml` — `post: dist/index.js`, и на post-шаге `src/main.ts` зовёт `gitSourceProvider.cleanup(stateHelper.RepositoryPath)`. Если в checkout есть `.git/config`, `cleanup` в `src/git-source-provider.ts` зовёт `authHelper.removeAuth()`. А та в `src/git-auth-helper.ts` запускает в checkout `git config --local` и `git submodule foreach --recursive` с `sh -c "git config --local …"`. Что этот шаг запустил на пробе, — measurements 5.4.

Прочитано 2026-10-22 (R22, поправки к R16 и R19, T26):
- **вход `submodules`** — actions/checkout v7.0.1, коммит 3d3c42e, `src/input-helper.ts`, строки 146–152: `const submodulesString = (core.getInput('submodules') || '').toUpperCase()`, а затем сравнение с `'RECURSIVE'` и `'TRUE'`.

### 2.8. `actions/cache`

Прочитано 2026-11-09 (R36, T52):
- **`actions/cache`** — v6.1.0, последний релиз, 2026-06-26 (API GitHub, `repos/actions/cache/releases/latest`); тег v6.1.0 — коммит 55cc8345863c7cc4c66a329aec7e433d2d1c52a9. Лицензия — MIT: «The MIT License (MIT)», `LICENSE` на теге. Тот же коммит закрепляет `canvas` в `page.yml` (`main` 66266e1 `canvas`);
- **записи** — README на теге v6.1.0: «The cache is scoped to the key, version, and branch. The default branch cache is available to other branches» («Cache scopes»); «Cache version is a hash generated for a combination of compression tool used (Gzip, Zstd, etc. based on the runner OS) and the `path` of directories being cached», и пример: «`build-linux` will create two different caches as the `paths` are different» («Cache Version»);
- **сохранение** — `src/saveImpl.ts` на теге v6.1.0: ошибку `saveCache` шаг пишет `utils.logWarning`, а `saveOnlyRun` оставляет причину toolkit — «warning for most failures, info for benign concurrency races, error for 5xx»; job дальше идёт. README, «Read-only access»: «When the cache token is read-only, the save step does not fail the job».

### 2.9. `actions/upload-artifact`

Прочитано 2026-10-20 (R09):
- **actions/upload-artifact** v7.0.2 — последний релиз (2026-10-07, `repos/actions/upload-artifact/releases/latest`), тег указывает на коммит `cf430e030ddbb5b0abf93d22962f4752f3646cd9` (`repos/actions/upload-artifact/git/refs/tags/v7.0.2`).

Прочитано 2026-11-01 (поправки 2026-11-01 к R16 и R19, T34):
- **имена артефактов** — README `actions/upload-artifact` на cf430e0, v7.0.2: «Artifact names must be unique since each created artifact is idempotent so multiple jobs cannot modify the same artifact». У `spec` в `ci.yml` уже есть артефакт `coverage`.

## 3. GitHub: rulesets, релизы и организация

### 3.1. Rulesets, обязательные проверки и мерж

Прочитано 2026-10-20 (R09):
- **правило ruleset о находках** — [GitHub Docs, Available rules for rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets), раздел Require code scanning results: мерж не пройдёт, если «A required tool finds a code scanning alert of a severity that is defined in the ruleset», «A required tool's analysis is still in progress» или «A required tool is not configured for the repository».

Прочитано 2026-10-20 (R10):
- **источник обязательной проверки** — [GitHub Docs, Available rules for rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets), раздел Require status checks to pass: «Any person or integration with write permissions to a repository can set the state of any status check in the repository», и потому «you can select an app as the expected source of status updates»;
- **сообщение squash-мержа** — [GitHub Docs, About pull request merges](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/about-pull-request-merges), раздел Merge message for a squash merge: «GitHub generates a default commit message that you can edit. The default message can include the pull request title, pull request description, or commit information, depending on repository settings».

Прочитано 2026-10-20 (R12; поправка к R10):
- **правило `code_scanning`** — [GitHub Docs, Set code scanning merge protection](https://docs.github.com/en/code-security/how-tos/find-and-fix-code-vulnerabilities/manage-your-configuration/set-merge-protection): у инструмента два порога. Alerts — «**None**, **Errors**, **Errors and Warnings** or **All**», Security alerts — «**None**, **Critical**, **High or higher**, **Medium or higher**, or **All**». Каким результатам оно верит — [GitHub Docs, REST API endpoints for rules](https://docs.github.com/en/rest/repos/rules), Update a repository ruleset, правило `code_scanning`: «When configured, code scanning must be enabled and have results for both the commit and the reference being updated»;
- **ruleset `.github` после правки** — API GitHub, `PUT repos/altnovatrail/.github/rulesets/25477399`, 2026-10-20. Тело собрано из `GET`. Сверка до и после показала ровно две правки: правило `code_scanning` и `allowed_merge_methods: ["merge"]`. `GET repos/altnovatrail/.github/rules/branches/main` называет обе;
- **метод мержа** — [GitHub Docs, Available rules for rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets), раздел Require a pull request before merging: «Optionally, you can require a merge type of merge, squash, or rebase. This means the targeted branches may only be merged based on the allowed type. Additionally if the repository has disabled a merge method and the ruleset required a different method, the merge will be blocked». У `.github` `allow_merge_commit` включён (API GitHub, `repos/altnovatrail/.github`).

### 3.2. Релизы и архивы исходников

Прочитано 2026-10-20 (R10):
- **неизменяемые релизы** — API GitHub: `PUT repos/altnovatrail/.github/immutable-releases` ответил 204, а `GET` того же пути — `{"enabled":true,"enforced_by_owner":false}`, как у `spec`. Ruleset `v-tags` — `POST repos/altnovatrail/.github/rulesets` с правилами `update`, `deletion` и `non_fast_forward` на `refs/tags/v*`, без обхода; образец — ruleset `spec` 25426896;
- **отказ Releases API** коммиту, который уже не вершина `main`, — [GitHub Docs, REST API endpoints for releases](https://docs.github.com/en/rest/releases/releases), Create a release: «If the commit identified by target_commitish … adds or modifies any file under .github/workflows/ relative to the repository's default branch, the authenticating token must be authorized to modify workflows. Otherwise, this endpoint returns 404 Not Found; some authentication paths surface 403 Resource not accessible by integration instead», и «The GITHUB_TOKEN available to GitHub Actions cannot be authorized for this». Как этот отказ пропускает релиз `spec`, — sources 12.1.

Прочитано 2026-11-01 (R28, T35):
- **архивы исходников** — github/docs на 33b1f4a, `content/repositories/working-with-files/using-files/downloading-source-code-archives.md`, раздел Stability of source code archives:
  - «The exact compression settings used to generate a zipball or tarball may change over time. The extracted contents won't change if the branch or tag doesn't change, but the outer compressed archive may have a different byte layout»;
  - «If you rely on stability of archives for security (for example: to ensure you don't attempt to unzip a maliciously-crafted file), we recommend using releases instead of using source downloads».

### 3.3. Политика actions организации

Прочитано 2026-10-19 (R04):
- [GitHub Docs, Disabling or limiting GitHub Actions for your organization](https://docs.github.com/en/organizations/managing-organization-settings/disabling-or-limiting-github-actions-for-your-organization), раздел Managing GitHub Actions permissions for your organization: «When you enable **Require actions to be pinned to a full-length commit SHA**, all actions must be pinned to a full-length commit SHA to be used. This includes actions from your organization and actions authored by GitHub. Reusable workflows can still be referenced by tag».

Прочитано 2026-10-20 (R10):
- **политика actions** — API GitHub, `repos/altnovatrail/<репозиторий>/actions/permissions`, у `.github`, `spec`, `module-kit` и `tutor`: `enabled: true`, `allowed_actions: all`, `sha_pinning_required: true` (`tutor` — прочитано 2026-10-20, T12).

### 3.4. Файлы сообщества, формы issue и шаблон pull request

Прочитано 2026-11-01 (R29, T37):
- **где GitHub их берёт** — [GitHub Docs, Creating a default community health file](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file):
  - «Store issue templates and their configuration file in `.github/ISSUE_TEMPLATE`», а для остальных файлов первым из мест идёт «The `.github` folder»;
  - «if a repository defines valid issue templates or issue template configuration in its own `.github/ISSUE_TEMPLATE` folder, none of the contents of the default `.github/ISSUE_TEMPLATE` folder will be used».
- **шаблон pull request** — [GitHub Docs, Creating a pull request template for your repository](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/creating-a-pull-request-template-for-your-repository): «You can create default pull request templates for your organization or personal account» и «To store your file in a hidden directory, name the pull request template `.github/pull_request_template.md`».
- **тип issue** — [GitHub Docs, Syntax for issue forms](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms), ключ `type`: «The issue type that will be automatically added to issues created with this template. Issue types are defined at the organization level». Там же о `labels`: «If a label does not already exist in the repository, it will not be automatically added to the issue». Пример страницы пишет `type: bug`, а различает ли GitHub регистр, не сказано. Формы называют типы так, как их зовёт организация: Task, Bug и Feature, все включены (API GitHub, `orgs/altnovatrail/issue-types`).
- **Markdown в формах** — [GitHub Docs, Syntax for GitHub's form schema](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema):
  - у `markdown` — «Markdown formatting is supported», у подписи галочки — «Markdown is supported for bold or italic text formatting, and hyperlinks». У описаний `textarea` и `input` о Markdown не сказано ничего;
  - `render` — «If a value is provided, submitted text will be formatted into a codeblock. When this key is provided, the text area will not expand for file attachments or Markdown editing»;
  - `required` — «Prevents form submission until element is completed. Only for public repositories».
- **пустой issue** — [GitHub Docs, Configuring issue templates for your repository](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository): при `blank_issues_enabled: false` «users with write access or above (Write, Maintain, or Admin roles) will still see the Blank issue option in the template chooser, labeled Maintainers only», а `contact_links` ведут наружу.

## 4. Dependabot

### 4.1. GitHub Docs о Dependabot

Прочитано 2026-10-19 (R04):
- [GitHub Docs, About Dependabot version updates](https://docs.github.com/en/code-security/concepts/supply-chain-security/dependabot-version-updates), раздел Updates for actions: «Dependabot also checks workflow files for uses of reusable workflows, and updates the Git reference for these called reusable workflows»;
- [GitHub Docs, Supported ecosystems and repositories](https://docs.github.com/en/code-security/reference/supply-chain-security/supported-ecosystems-and-repositories), раздел GitHub Actions: «If the commit you use is not associated with any tag, Dependabot will update the GitHub Actions to the latest commit (which might differ from the latest release)» и «Dependabot will ignore actions or reusable workflows referenced locally (for example, `./.github/actions/foo.yml`)». Комментарий версии он обновляет, если тот на той же строке, — цитата в R30 spec.

Прочитано 2026-10-20 (R12; поправка к R10):
- **справочник Dependabot** — [GitHub Docs, Dependabot options reference](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference), раздел `cooldown`. GitHub Actions — среди менеджеров пакетов, где работает `default-days`, и без настройки «Apply a **default cooldown period of 3 days** to version updates, even when `cooldown` is not configured».

Прочитано 2026-11-08 (поправка 2026-11-08 к R04, T45):
- [GitHub Docs, Dependabot options reference](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference), раздел `groups`: «All updates for dependencies that match a rule are combined in a single pull request», «If a dependency matches more than one rule, it's included in the first group that it matches» и «Any outdated dependencies that do not match a rule are updated in individual pull requests». Имя группы «must start and end with a letter, and can contain letters, pipes `|`, underscores `_`, or hyphens `-`». О `patterns`: «Both options support using `*` as a wild card to define matches with dependency names». Совпадает ли `*` с `/` и действует ли `cooldown` на группу, справочник не говорит. Раздел `open-pull-requests-limit`: «If five pull requests with version updates are open, no further pull requests are raised until some of those open requests are merged or closed».

### 4.2. dependabot-core

Прочитано 2026-10-20 (R12; поправка к R10):
- **пауза у ссылок на reusable workflow** — [dependabot-core](https://github.com/dependabot/dependabot-core/tree/fda701f49c7d6ba5807e98a06549fdb935e3bd2e), коммит fda701f (`main`, 2026-10-20). По README, это «the library at the heart of Dependabot security / version updates». В нём:
  - `github_actions/lib/dependabot/github_actions/file_parser.rb` делает ссылку на reusable workflow зависимостью, как action: «For reusable workflows (.github/workflows/*.yml), use the repository name + workflow path to distinguish between different workflow files in the same repository»;
  - `update_checker.rb` строит для каждой зависимости `LatestVersionFinder` с `cooldown_options: update_cooldown`;
  - в `update_checker/latest_version_finder.rb` `cooldown_enabled?` возвращает `true`. Если ссылка закреплена по SHA, на котором есть тег, кандидаты — теги. Дату каждого берёт `common/lib/dependabot/git_metadata_fetcher.rb` из клона: `git for-each-ref --format="%(refname:short) %(creatordate:short)" refs/tags`. `check_if_version_in_cooldown_period?` читает её через `Time.parse`, так что окно в три раза по 86 400 секунд открывается в полночь этого дня. Дату релиза GitHub — «Priority: GitHub Release published_at > tag creation date > commit date» — тот же файл берёт, только когда предлагает голый SHA;
  - `creatordate` — по [документации git](https://github.com/git/git/blob/master/Documentation/git-for-each-ref.adoc) (`git-for-each-ref`): «For commit and tag objects, the special `creatordate` and `creator` fields will correspond to the appropriate date or name-email-date tuple from the `committer` or `tagger` fields depending on the object type». Тег `v0.1.0` — лёгкий, он указывает прямо на коммит (API GitHub, `repos/altnovatrail/.github/git/refs/tags/v0.1.0`: объект `commit`). Коммит — 2026-10-20T13:17:26Z, релиз — 13:18:27Z;
  - пауза пришла в эту экосистему с #12486 (2025-06-20), её флаг снят в #12577 (2025-07-08), а reusable workflow Dependabot поднимает с коммита dcf1e27 «Allow updating reusable workflows» (2023-02-17) — по истории файлов в API GitHub.

Прочитано 2026-10-21 (поправка к R19):
- **Dependabot и Dockerfile** — [`docker/lib/dependabot/docker/file_parser.rb`](https://github.com/dependabot/dependabot-core/blob/fda701f/docker/lib/dependabot/docker/file_parser.rb) dependabot-core на коммите fda701f, 2026-10-20. `parse` идёт по строкам Dockerfile и пропускает каждую, которая не совпадает с `FROM_LINE`, — «`next unless FROM_LINE.match?(line)`», — а `FROM_LINE` начинается с `^#{FROM}\s+`. Строку `COPY --from` он не читает.

Прочитано 2026-11-08 (поправка 2026-11-08 к R04, T45):
- **dependabot-core** на коммите [fda701f](https://github.com/dependabot/dependabot-core/tree/fda701f49c7d6ba5807e98a06549fdb935e3bd2e), 2026-10-20:
  - `common/lib/wildcard_matcher.rb` — шаблон делится по `*`, части экранируются `Regexp.quote` и сшиваются `.*`, а сравнение — `downcase` с обеих сторон. `.*` совпадает и с `/`;
  - `common/lib/dependabot/dependency_group.rb` — `contains?` сверяет с `patterns` через `WildcardMatcher.match?` имя зависимости, `dependency.name`;
  - `github_actions/lib/dependabot/github_actions/file_parser.rb` — «For reusable workflows (.github/workflows/*.yml), use the repository name + workflow path», `name = "#{repo_name}#{path}"`. Так и называются pull request Dependabot у `spec`, «Bump altnovatrail/.github/.github/workflows/<файл>.yml» (architecture 2.6). Ссылку локальным путём он не разбирает: «TODO: Support Docker references and path references»;
  - `updater/lib/dependabot/updater/group_update_creation.rb` — обновление группы берёт для каждой зависимости `update_checker_for` с `update_cooldown: job.cooldown`, как одиночное обновление в `operations/update_all_versions.rb`.

### 4.3. Pull request Dependabot у `spec`

Прочитано 2026-11-01 (R25, T31):
- **Dependabot у `spec`** — pull request #40–#42, «Bump altnovatrail/.github/.github/workflows/<файл>.yml from 0.1.0 to 0.1.3», открыты и слиты 2026-10-23, а #49–#51, «from 0.1.3 to 0.1.10», открыты 2026-10-26. У коммита #40 автор — `dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>`, коммиттер — `GitHub <noreply@github.com>`, подпись — `Signed-off-by: dependabot[bot] <support@github.com>`, а «DCO / sign-off» — success. Релизы `.github`: v0.1.3 — 2026-10-21T04:50:54Z, коммит его тега — 2026-10-20T23:49:54-05:00; v0.1.4 — 2026-10-21T15:30:24Z; v0.1.10 — 2026-10-22T18:09:38Z (`gh release list`, `git log -1 --format=%cI <тег>`).

## 5. CodeQL

### 5.1. `github/codeql-action`

Прочитано 2026-10-19 (R03):
- [codeql-action, README](https://github.com/github/codeql-action), раздел Workflow Permissions: «All advanced setup code scanning workflows must have the `security-events: write` permission».

Прочитано 2026-10-20 (R09):
- **github/codeql-action** v4.39.0 — новейший тег `v4.*` по `git ls-remote --tags https://github.com/github/codeql-action` (выпущен 2026-10-15, API GitHub, `repos/github/codeql-action/releases/tags/v4.39.0`). Последний «релиз» репозитория — бандл CodeQL, а не версия action. Тег аннотированный, 48870fd, и указывает на коммит `6f2ac81f5cd81fe351a197ba0b00d91d03cd2aee` (`repos/github/codeql-action/git/tags/48870fdd6b42ee6474ec4207209ff87609271a5e`). Входы `init` этой версии — `languages`, `build-mode`, `queries` (`init/action.yml` на теге v4.39.0);
- **бандл CodeQL** — `init/action.yml` на коммите 6f2ac81, вход `tools`: «A special value `linked` which uses the version of the CodeQL tools that the Action has been bundled with», а без входа — «the Action will check in several places until it finds the CodeQL tools». В `src/setup-codeql.ts` того же коммита без входа берётся `defaultCliVersion.enabledVersions[0]` — версия из флагов GitHub, а с `linked` — версия из `src/defaults.json`, `"cliVersion": "2.27.2"`. Пробный прогон это подтвердил — measurements 1.1.

Прочитано 2026-10-20 (поправка к R09, T14):
- **вход `config`** у `init` — `init/action.yml` на коммите 6f2ac81 (v4.39.0): «Configuration passed as a YAML string in the same format as the config-file input. This takes precedence over the config-file input». Пустой вход — то же, что отсутствующий: `getOptionalInput` в `src/actions-util.ts` того же коммита возвращает `undefined` для пустой строки, а `src/init-action.ts` разбирает `config`, только если он задан;
- **свойство репозитория `github-codeql-config-file`** — файл конфигурации, кроме входа `config-file`, `init` может взять из свойства репозитория `github-codeql-config-file`. Его читает `getConfigFileInput` в `src/config/file.ts` на 6f2ac81, за флагом `config_file_repository_property`, а имя свойства задано в `src/feature-flags/properties.ts`. Если рядом окажутся файл и `config`, `init` возьмёт только `config`: «Both a config file and config input were provided. Ignoring config file.» (`src/config-utils.ts`). У организации схема свойств пуста (API GitHub, `orgs/altnovatrail/properties/schema`, 2026-10-20), так что такого свойства нет ни у одного репозитория.

Прочитано 2026-10-21 (поправка к R09, T19):
- **явный режим сборки** — [`src/codeql.ts`](https://github.com/github/codeql-action/blob/6f2ac81f5cd81fe351a197ba0b00d91d03cd2aee/src/codeql.ts) codeql-action на коммите 6f2ac81, v4.39.0: `extractUsingBuildMode` запускает `codeql database trace-command --use-build-mode`, а при `autobuild` и неудаче отвечает «We were unable to automatically build your code». Отдельного шага `autobuild` не нужно: [`src/analyze-action.ts`](https://github.com/github/codeql-action/blob/6f2ac81f5cd81fe351a197ba0b00d91d03cd2aee/src/analyze-action.ts) того же коммита старый автосбор Go пропускает — «Skipping legacy Go autobuild since a build mode has been specified».

### 5.2. GitHub Docs о code scanning

Прочитано 2026-10-19 (R03):
- [GitHub Docs, Workflow configuration options](https://docs.github.com/en/code-security/reference/code-scanning/workflow-configuration-options), раздел Analysis category: «If you don't specify a `category` parameter in your workflow, GitHub will generate a category name for you, based on the name of the workflow file triggering the action, the action name, and any matrix variables». У общего workflow имя файла одно на все репозитории, поэтому `category` задаётся явно;
- default setup и свой workflow вместе не работают — цитата в T15 `spec`, «Выяснилось при планировании».

Прочитано 2026-10-20 (R09):
- **находки и мерж** — [GitHub Docs, Triaging code scanning alerts in pull requests](https://docs.github.com/en/code-security/how-tos/manage-security-alerts/manage-code-scanning-alerts/triage-alerts-in-pull-requests): «the check that contains the results of code scanning is: Code scanning results» и «If the code scanning results check finds any problems with a severity of `error`, `critical`, or `high`, the check fails». Как эта проверка называется на pull request, — measurements 1.1;
- **сборка для CodeQL** — [GitHub Docs, CodeQL build options and steps for compiled languages](https://docs.github.com/en/code-security/reference/code-scanning/codeql/build-options-for-compiled-languages), раздел Building Go: «CodeQL supports build modes `autobuild` or `manual` for Go code» — без сборки, `none`, Go не разбирается.

Прочитано 2026-10-20 (поправка к R09, T14):
- **`paths-ignore`** — [GitHub Docs, Workflow configuration options](https://docs.github.com/en/code-security/reference/code-scanning/workflow-configuration-options):
  - раздел Specifying directories to scan: «You can use this option when you run the CodeQL actions on an interpreted language (Python, Ruby, and JavaScript/TypeScript) or when you analyze a compiled language without building the code (currently supported for C/C++, C#, Java and Rust)». Язык `actions` документация не называет, а экстрактор Actions пути учитывает (sources 5.3);
  - там же о шаблонах: «`**` characters can only be at the start or end of a line, or surrounded by slashes» и «You'll need to quote anything that contains a `*` character»;
  - раздел Configuration details: значение входа `config` «must be a YAML string that follows the configuration file format».

### 5.3. `github/codeql` на теге codeql-cli/v2.27.2

Прочитано 2026-10-20 (поправка к R09, T14):
- **`paths-ignore` у экстрактора Actions** — [`actions/extractor/tools/autobuild.sh`](https://github.com/github/codeql/blob/codeql-cli/v2.27.2/actions/extractor/tools/autobuild.sh) в github/codeql на теге codeql-cli/v2.27.2 говорит: «If the user provided `paths-ignore`, those patterns are excluded». Язык `actions` в разделе Specifying directories to scan документация не называет (sources 5.2); проба — measurements 1.2.

Прочитано 2026-10-21 (поправка к R09, T19):
- **автосборка Go** — [`go/extractor/autobuilder/autobuilder.go`](https://github.com/github/codeql/blob/codeql-cli/v2.27.2/go/extractor/autobuilder/autobuilder.go) в github/codeql на теге codeql-cli/v2.27.2: «If a project is accompanied by a build script (such as a makefile), then we try executing such», и список — `make` для Makefile, makefile и GNUmakefile, `ninja` для build.ninja, `./build` и `./build.sh`.

## 6. Scorecard

### 6.1. `scorecard-action` и `scorecard-webapp`

Прочитано 2026-10-19 (R03; architecture 2.2):
- [scorecard-action v2.5.0, README](https://github.com/ossf/scorecard-action/blob/v2.5.0/README.md), раздел Workflow Restrictions: «The workflow can't contain top level env vars or defaults», «No workflow level write permissions», «Only the job with `ossf/scorecard-action` can use `id-token: write` permissions», а для его job — «The steps running in this job must belong to this approved list of GitHub actions:» `actions/checkout`, `actions/upload-artifact`, `github/codeql-action/upload-sarif`, `ossf/scorecard-action`, `step-security/harden-runner`. Триггеры — `push` и `schedule` на основной ветке, цитата в R30 spec;
- [scorecard-webapp, PR #778](https://github.com/ossf/scorecard-webapp/pull/778) «Fix default branch verification», слит 2025-04-16: «This PR modifies the verification procedure to use the repository of the **calling** workflow instead»;
- что сервер результат отклонил, v2.5.0 не считает ошибкой: [`signing/signing.go`](https://github.com/ossf/scorecard-action/blob/fa7117db83c52d787ae5a89f350999701505d78e/signing/signing.go), функция `ProcessSignature`, на неудачной публикации пишет `::warning::Unable to POST scorecard results to webapp` и возвращает `nil`. Коммит fa7117d — тег v2.5.0; прочитано 2026-10-20;
- входа `fail_on_publish_error` в v2.5.0 нет: ни README, ни `action.yaml` этого тега его не называют. В `main` он есть с 2026-10-14 (коммит 1dfaf3539e, #1721): «Fail the step when the Scorecard API rejects published results». Придёт со следующим релизом.

Прочитано 2026-11-12 (T55; комментарий `scorecard.yml`):
- [scorecard-action v2.5.0, README](https://github.com/ossf/scorecard-action/blob/v2.5.0/README.md), раздел Workflow Restrictions: правила ставит сервер — «our API enforces certain rules on the producing workflow, which may reject the results and cause the Scorecard Action run to fail», — а подраздел Restrictions on the job containing `ossf/scorecard-action` называет для job ещё три: «No job level env vars or defaults», «No containers or services» и «The job should run on one of the Ubuntu hosted runners».

### 6.2. `ossf/scorecard` на коммите 61e8474

Прочитано 2026-10-20 (R10):
- **Dangerous-Workflow у Scorecard** — [`checks/raw/dangerous_workflow.go`](https://github.com/ossf/scorecard/blob/61e84743356275f6ffca23b1b2f2cb945e19eb96/checks/raw/dangerous_workflow.go) на коммите 61e8474, той версии Scorecard, v5.6.0, которой сервер посчитал `.github` (поле `scorecard` в ответе API Scorecard). В workflow с триггером `pull_request_target` или `workflow_run` функция `checkJobForUntrustedCodeCheckout` отмечает checkout, у которого `ref` содержит `github.event.pull_request` или `github.event.workflow_run`; условие `if` job она не читает;
- **риск Dangerous-Workflow** — [`docs/checks.md`](https://github.com/ossf/scorecard/blob/61e84743356275f6ffca23b1b2f2cb945e19eb96/docs/checks.md) Scorecard на том же коммите: «Risk: `Critical` (vulnerable to repository compromise)».

Прочитано 2026-10-20 (R12; поправка к R10):
- **checkout без `ref` у Scorecard** — в [`checks/raw/dangerous_workflow.go`](https://github.com/ossf/scorecard/blob/61e84743356275f6ffca23b1b2f2cb945e19eb96/checks/raw/dangerous_workflow.go) на коммите 61e8474 функция `checkJobForUntrustedCodeCheckout` пропускает шаг без входа `ref`: `if !ok || ref.Value == nil { continue }`. Инъекцию функция `validateScriptInjection` ищет только в `run:`, по списку контекстов, и `head_sha` в нём нет;
- **npm у Scorecard** — в [`checks/raw/shell_download_validate.go`](https://github.com/ossf/scorecard/blob/61e84743356275f6ffca23b1b2f2cb945e19eb96/checks/raw/shell_download_validate.go) на 61e8474 функция `isNpmUnpinnedDownload` не отмечает только `npm ci` — «`npm ci` will verify all hashes are present» — и пакет из git, закреплённый по хешу коммита. Остальные команды установки npm она отмечает. Находка code scanning #2 — строка 113 `.devcontainer/Dockerfile`, Pinned-Dependencies — 8. Архивы, которые Dockerfile скачивает через curl и распаковывает tar, она не отметила: других находок Pinned-Dependencies у `.github` нет (В12 RUN.md, теперь — R34 spec).

### 6.3. API Scorecard

Прочитано 2026-10-20 (R09):
- **API Scorecard** — `https://api.scorecard.dev/projects/github.com/<владелец>/<репозиторий>`: принятый результат приходит с датой, коммитом репозитория и оценкой — поля `date`, `repo.commit`, `score` в ответе для `ossf/scorecard`; у репозитория без опубликованного результата — 404, как у `spec`.

## 7. Sigstore

### 7.1. cosign

Прочитано 2026-10-21 (R18):
- **cosign** v3.1.4 — последний релиз, 2026-10-20 (API GitHub, `repos/sigstore/cosign/releases/latest`); лицензия — Apache-2.0. Сумма `cosign-linux-amd64` из `cosign_checksums.txt` того же релиза — `424e2c97d0b45fd7a6b608a87f090f35633f4c23ece5f092d48bba11aaf4bbfa`, и скачанный файл с ней сошёлся.

Прочитано 2026-10-22 (поправки к R10 и R18, T25):
- **токен OIDC для cosign** — cosign v3.1.4, коммит 8843105, берёт токен из них (sources 2.5): `VariableGitHubRequestToken Variable = "ACTIONS_ID_TOKEN_REQUEST_TOKEN"` в `pkg/cosign/env/env.go`, а запрос с ним шлёт `pkg/providers/github/github.go`. Шаг подписи общего релиза — обычный `run:`, и подпись проходит: значит, эти переменные видят шаги job.

### 7.2. Fulcio: подпись из reusable workflow

Прочитано 2026-10-19 (architecture 2.3):
- [Fulcio, OIDC usage](https://github.com/sigstore/fulcio/blob/main/docs/oidc.md), раздел Case study: GitHub Actions: «GitHub Actions uses the `job_workflow_ref` as its SAN»;
- [Fulcio, OID information](https://github.com/sigstore/fulcio/blob/main/docs/oid-info.md), раздел Mapping OIDC token claims to Fulcio OIDs: `job_workflow_ref` — это Build Signer URI, «Reference to specific build instructions that are responsible for signing. Can be the same as Build Config URI. For example a reusable workflow in GitHub Actions or a Circle CI Orbs»; `workflow_ref` — Build Config URI, «A reference to the initiating build instructions»; `repository` — Source Repository URI.

Значит, вместе с `job_workflow_ref` GitHub (sources 2.5), подпись общего релиза называет общий workflow, а вызывающий workflow и его репозиторий — в Build Config URI и Source Repository URI.

## 8. npm

### 8.1. Документация npm

Прочитано 2026-10-20 (R12; поправка к R10):
- **целостность у npm** — документация npm, [`npm cache`](https://github.com/npm/cli/blob/ae98c62586b6fea44114f72e249e246a2981de70/docs/lib/content/commands/npm-cache.md) на ветке `latest` npm/cli, коммит ae98c62: «All data that passes through the cache is fully verified for integrity on both insertion and extraction». С каким хешем сверяет npm без lockfile, эта страница не говорит, а в репозитории хеша нет.

Прочитано 2026-10-21 (R19):
- **npm** — Node 24.21.0 идёт с npm 11.19.0: [nodejs.org/dist/index.json](https://nodejs.org/dist/index.json), запись `v24.21.0` — `"npm":"11.19.0"`. Сайт документации npm показывает v11 в редакции 11.21.0. Определение `ignore-scripts` ниже то же и в исходниках npm на теге v11.19.0, коммит bfacd33: `workspaces/config/lib/definitions/definitions.js`;
- **`npm ci`** — [npm Docs, npm ci](https://docs.npmjs.com/cli/v11/commands/npm-ci): «The project **must** have an existing `package-lock.json` or `npm-shrinkwrap.json`», «If dependencies in the package lock do not match those in `package.json`, `npm ci` will exit with an error, instead of updating the package lock» и «It will never write to `package.json` or any of the package-locks: installs are essentially frozen»;
- **`ignore-scripts`** — там же, раздел Configuration: «If true, npm does not run scripts specified in package.json files. Note that commands explicitly intended to run a particular script, such as `npm start`, `npm stop`, `npm restart`, `npm test`, and `npm run` will still run their intended script if `ignore-scripts` is set, but they will *not* run any pre- or post-scripts». Переменная окружения задаёт то же самое — [npm Docs, config](https://docs.npmjs.com/cli/v11/using-npm/config): «Any environment variables that start with `npm_config_` will be interpreted as a configuration parameter»;
- **`npm audit`** — [npm Docs, npm audit](https://docs.npmjs.com/cli/v11/commands/npm-audit): «The audit command submits a description of the dependencies configured in your project to your default registry and asks for a report of known vulnerabilities» — ему нужна сеть. О `--audit-level`: «This option does not filter the report output, it simply changes the command's failure threshold».

Прочитано 2026-10-22 (поправка к R18, T27):
- **trusted publishing** — npm/documentation на коммите 7e98ab4, `content/packages-and-modules/securing-your-code/trusted-publishers.mdx`:
  - «Trusted publishing requires npm CLI version 11.5.1 or later and Node version 22.14.0 or higher»;
  - о reusable workflow: «validation checks the calling workflow's name instead of the workflow that actually contains the publish command», и «The `id-token: write` permission must also be given to both parent and child workflows»;
  - «Configurations created after Sep 03, 2026 are automatically set to allow `npm stage publish`, and you can choose whether to also permit direct publishing with `npm publish`», а «A newly created trusted publisher configuration must complete its first successful publish within 2 days»;
  - provenance: «npm automatically generates and publishes provenance attestations … you don't need to add the `--provenance` flag», а «your package's `repository.url` field in `package.json` must exactly match your GitHub repository».

Прочитано 2026-11-01 (R25, T31):
- **trusted publishing и reusable workflow** — страница [npm Docs, Trusted publishing](https://docs.npmjs.com/trusted-publishers) говорит то же, что npm/documentation на 7e98ab4: «validation checks the calling workflow's name instead of the workflow that actually contains the publish command».

Прочитано 2026-11-01 (поправка 2026-11-01 к R18, T33):
- **npm/documentation** — коммит c62df53, 2023-10-23, последний коммит файла `content/policies/unpublish.mdx`:
  - «So if you've ever published a package called "bob" at version 1.1.0, no other package can ever be published with that name at that version. This is true even if that package is unpublished»;
  - «Once `package@version` has been used, you can never use it again. You must publish a new version even if you unpublished the old one»;
  - «If you entirely unpublish all versions of a package, you may not publish any new versions of that package until 24 hours have passed».

Прочитано 2026-11-02 (поправка 2026-11-02 к R18, T42):
- **trusted publishing** — `content/packages-and-modules/securing-your-code/trusted-publishers.mdx` npm/documentation, последний коммит 5152d27 от 2026-10-06: «validation checks the calling workflow's name instead of the workflow that actually contains the publish command», и «The `id-token: write` permission must also be given to both parent and child workflows». Provenance — «when all of these conditions are met»: trusted publishing, публичный репозиторий, публичный пакет. О reusable workflow другого репозитория документ не говорит.

### 8.2. `npm/cli`

Прочитано 2026-10-22 (поправка к R18, T27):
- **`npm trust`** — npm/cli v11.19.0, `docs/lib/content/commands/npm-trust.md`: «Package must exist: The package you're configuring must already exist on the npm registry». `lib/trust-cmd.js` разрешает публикацию флагом `--allow-publish`, а staged — `--allow-stage-publish`;
- **npm CLI 11.19.1**, тот, что идёт с Node 24.22.1. От 11.19.0 у него не отличаются `lib/utils/oidc.js`, `lib/commands/publish.js`, libnpmpublish и npm-registry-fetch (`gh api repos/npm/cli/compare/v11.19.0...v11.19.1`):
  - `oidc.js` без `ACTIONS_ID_TOKEN_REQUEST_URL` и `_TOKEN` обмен пропускает — «Skipped because incorrect permissions for id-token within GitHub workflow», на уровне silly. Отказ обмена и его успех он пишет на уровне verbose: «Failed token exchange request with body message: …», «Successfully retrieved and set token»;
  - `publish.js` зовёт обмен до ветки `--dry-run` (строка 147). Скрипты пакета идут только при публикации папки. С npm 11.0.0 версию ниже старшей без тега он не публикует: «Cannot implicitly apply the "latest" tag because previously published version … is higher than the new version»;
  - лицензия npm — Artistic-2.0 (`package.json` npm), а в `spec/tools/licenses/config.mjs` v0.2.21 её нет.

Прочитано 2026-11-01 (поправка 2026-11-01 к R18, T33):
- **npm** — `lib/commands/view.js` npm 11.19.0 из devcontainer, строки 151–157: на `pckmnt.time?.unpublished` команда бросает ошибку «Unpublished on ${u.time}» со `statusCode: 404` и `code: 'E404'`. Между v11.19.0 и v11.19.1 изменились 33 файла. Из файлов `view` и `publish` среди них только `test/lib/commands/publish.js` (`gh api repos/npm/cli/compare/v11.19.0...v11.19.1`).

### 8.3. Реестр npm

Прочитано 2026-10-22 (поправка к R18, T27):
- **кеш реестра** — 2026-10-22. `https://registry.npmjs.org/semver` отвечает `cf-cache-status: HIT`, `cache-control: public, max-age=300` и `age` больше ста секунд, даже на запрос с `Cache-Control: no-cache`. С `?write=true` ответ — `cf-cache-status: DYNAMIC`. npm-registry-fetch, который идёт с npm 11.19.1, такой GET не кеширует: «do not cache, because this GET is fetching a rev that will be used for a subsequent PUT or DELETE» (`lib/index.js`).

Прочитано 2026-11-01 (R25, T31):
- **публикация `spec` в npm** — `https://registry.npmjs.org/@altnovatrail%2fspec`: `latest` — 0.4.1, вышла 2026-10-29T20:31:01Z, с `dist.attestations`, provenance `https://slsa.dev/provenance/v1`; у 0.4.0, которую автор `spec` опубликовал руками, provenance нет. Шаги npm `release.yml` `spec` — шаги общего `release.yml` v0.1.10 с отличиями, которые называет T51 `spec`.

Прочитано 2026-11-01 (поправка 2026-11-01 к R18, T33):
- **`time` помнит снятые номера** — `https://registry.npmjs.org/<пакет>?write=true`. В `time`, но не в `versions`, лежат:
  - у `ua-parser-js` — 0.7.29, 0.8.0 и 1.0.0;
  - у `coa` — 2.0.3, 2.0.4, 2.1.1, 2.1.3, 3.0.1 и 3.1.3;
  - у `rc` — 1.2.9, 1.3.9 и 2.3.9.

  У `@altnovatrail/spec` в 18:59 UTC ключи `time` — восемь его версий, от `0.0.0-stage` до 0.5.4, и `created` с `modified`;
- **пакет, снятый целиком**, — тот же запрос.
  - `asdasd`, `aaaaaaa` и `test-unpublish` отвечают 200, а в ответе только `_id`, `name`, `_rev` и `time`.
  - У `asdasd` в `time` — `created`, `modified`, `1.0.0` и `unpublished`: `{"time":"2016-09-28T19:51:40.289Z","versions":["1.0.0"]}`.
  - `time` хранит и номера, которых нет в `unpublished.versions`: у `aaaaaaa` — 2.0.0 и 4.0.1.
  - Имя, которого не было, `dfgdfg`, — 404 `{"error":"Not found"}`.
  - У пакета, опубликованного снова, `time.unpublished` нет, а `time` хранит прежние номера: у `pokemon-assets` — 0.6.0 и 0.7.0, которых нет в `versions`.

Прочитано 2026-11-02 (R31, T40):
- **документы пакетов, снятых целиком**, по шагу `spec` (sources 12.7) — `curl https://registry.npmjs.org/<имя>?write=true`, 2026-11-02:
  - у `asdasd`, `aaaaaaa` и `test-unpublish` `versions` пуст, а в `time` — `created`, `modified`, `unpublished` и каждый номер, который пакет держал: `1.0.0`; `2.0.0`, `1.0.0`, `1.0.1`, `3.0.0`, `4.0.0` и `4.0.1`; `0.0.1` и `0.0.0`;
  - в `time.unpublished.versions` — номера, которые пакет держал последними: `["1.0.0"]`, `["1.0.0","1.0.1","3.0.0","4.0.0"]` и `["0.0.0"]`. Номера, снятые раньше, — `2.0.0` и `4.0.1` у `aaaaaaa`, `0.0.1` у `test-unpublish` — есть только в `time`;
  - исправлено 2026-11-02 в T42: первое прочтение брало из `time` только `created`, `modified` и `unpublished` — фильтр jq — и так потеряло ключи номеров. На нём стояли В34 и слова поправки по T40 к R18 о том, что общий шаг такой номер не находит; это неверно (поправка по T42 к R18).

Прочитано 2026-11-02 (поправка 2026-11-02 к R18, T42):
- **документы пакетов, снятых целиком**, — те же, что выше, в чтении по T40, прочитанные целиком: `curl https://registry.npmjs.org/<имя>?write=true | jq '{keys: keys, versions: (.versions // {} | keys), time: .time}'`. Ключи документа — `_id`, `_rev`, `name` и `time`, а в `time` есть каждый номер, который пакет держал. Прежний шаг `(.time // {}) | has($v)` такой номер находил.

### 8.4. Открытые ошибки `npm/cli`

Прочитано 2026-10-22 (поправка к R18, T27):
- **открытые ошибки npm** — npm/cli#9889: `npm publish` выходит с 0, а версия только staged. npm/cli#9969: OIDC у репозиториев с неизменяемым subject GitHub.

Прочитано 2026-11-01 (R25, T31):
- **неизменяемый subject OIDC** — API GitHub, `repos/altnovatrail/<репозиторий>/actions/oidc/customization/sub`: у `spec` и у `canvas` — `"use_immutable_subject":true`, префиксы `repo:altnovatrail@344507087/spec@1424771727` и `repo:altnovatrail@344507087/canvas@1425820257`. npm/cli#9969 — «OIDC trusted publishing fails with "package not found" for GitHub repos that use immutable OIDC subject claims» — открыт, обновлён 2026-10-28; npm/cli#9889 открыт тоже (API GitHub).

Прочитано 2026-11-02 (поправка 2026-11-02 к R18, T42):
- **открытые ошибки npm** (Д7 в RUN.md) — [npm/cli#9969](https://github.com/npm/cli/issues/9969) — open, обновлён 2026-10-28; [npm/cli#9889](https://github.com/npm/cli/issues/9889) — open, обновлён 2026-10-22.

## 9. Node, браузеры и тесты TypeScript

### 9.1. Node

Прочитано 2026-10-22 (поправка к R18, T27):
- **Node** — `https://nodejs.org/dist/index.json`: v24.22.1, 2026-10-20, npm 11.19.1, `security: true`. В `SHASUMS256.txt` v24.22.1 — `6c172a9ab6718f7b801fb5a7bd486af2ee5e32758086a04b84fcce2aa77095e6  node-v24.22.1-linux-x64.tar.xz`, и скачанный архив с ней совпал.

### 9.2. Playwright

Прочитано 2026-10-21 (R19):
- **Playwright в Docker** — [`docs/src/docker.md`](https://github.com/microsoft/playwright/blob/66070a1/docs/src/docker.md) на коммите 66070a1, раздел Recommended Docker Configuration: «Using `--init` Docker flag is recommended to avoid special treatment for processes with PID=1. This is a common reason for zombie processes» и «Using `--ipc=host` is recommended when using Chromium. Without it, Chromium can run out of memory and crash». Playwright — v1.64.1, Apache-2.0 (API GitHub);
  - [`docs/src/browsers.md`](https://github.com/microsoft/playwright/blob/66070a1/docs/src/browsers.md), там же: «Each version of Playwright needs specific versions of browser binaries to operate». Браузеры лежат в «`~/.cache/ms-playwright` on Linux», а другой путь задаёт `PLAYWRIGHT_BROWSERS_PATH`;
  - образ Playwright задаёт `ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright` и ставит браузеры туда ([`utils/docker/Dockerfile.noble`](https://github.com/microsoft/playwright/blob/66070a1/utils/docker/Dockerfile.noble), там же);
  - системные пакеты браузеров ставит `apt-get install`, а не от root — через sudo, «Switching to root user to install dependencies...» ([`dependencies.ts`](https://github.com/microsoft/playwright/blob/66070a1/packages/playwright-core/src/server/registry/dependencies.ts), там же);
  - сумм загрузок браузеров не называет ни документация, ни загрузчик: в `browserFetcher.ts` и `registry/index.ts` сверки суммы не нашлось. Это итог поиска, а не слова документации;
- **образ Playwright** — `mcr.microsoft.com/playwright:v1.64.1-noble`, индекс `sha256:7852dc5a7d72f5fe458a597d690f6c42fbc8e9e26ddfa95f8e6ef552558d9bbf`; amd64 — `sha256:bdfda2a8fdf48707c5e50a49bd3e06d8d0c759153dc8ee057d8a81c3450bb3e9`, 986 271 382 байта сжатыми, в семи слоях (реестр MCR). `utils/docker/Dockerfile.noble` на теге v1.64.1 ставит в `/ms-playwright` chromium с headless shell и ffmpeg, firefox и webkit, а системные библиотеки — `install-deps`, вне этой папки. [`docs/src/docker.md`](https://github.com/microsoft/playwright/blob/v1.64.1/docs/src/docker.md) на теге v1.64.1: «This image includes the Playwright browsers and browser system dependencies. The Playwright package/dependency is not included in the image» и «If the Playwright version in your Docker image does not match the version in your project/tests, Playwright will be unable to locate browser executables»;
- **системные библиотеки Chromium** — [`nativeDeps.ts`](https://github.com/microsoft/playwright/blob/v1.64.1/packages/playwright-core/src/server/registry/nativeDeps.ts) на теге v1.64.1, запись `ubuntu24.04-x64`, `chromium`: 21 пакет, от `libasound2t64` до `libxrandr2`. `install-deps` ставит их через `apt-get install -y --no-install-recommends`, без версий.

Прочитано 2026-10-21 (поправка к R19):
- **Chrome for Testing** — [`docs/src/release-notes-js.md`](https://github.com/microsoft/playwright/blob/v1.64.1/docs/src/release-notes-js.md) Playwright на теге v1.64.1, коммит cfe490d, раздел Version 1.57: «Playwright now runs on Chrome for Testing builds rather than Chromium. Headed mode uses `chrome`; headless mode uses `chrome-headless-shell`». В [`registry/index.ts`](https://github.com/microsoft/playwright/blob/v1.64.1/packages/playwright-core/src/server/registry/index.ts) там же у `chromium` и `chromium-headless-shell` для `ubuntu24.04-x64` — `cftUrl(…)`, путь `builds/cft/${browserVersion}/…` на `https://cdn.playwright.dev`. У Firefox, WebKit и FFmpeg пути свои — `builds/firefox/…`, `builds/webkit/…` и `builds/ffmpeg/…`;
- **папка в образе** — R13 canvas и architecture 4 canvas на 88492c4. В слое образа v1.64.1 с `playwright-core install chromium` лежат `chromium-1248` с `WidevineCdm/LICENSE`, `chromium_headless_shell-1248` и `ffmpeg-1013`. `ABOUT` Chrome Headless Shell: «Google Chrome … Copyright 2026 Google LLC. All rights reserved … See the Terms of Service at chrome://terms». Сам бинарник называет себя «Google Chrome for Testing 156.0.8078.4», а папка занимает 273 МБ.

### 9.3. Vitest и istanbul

Прочитано 2026-10-21 (R19):
- **Vitest в браузере** — [Vitest, Browser Mode](https://vitest.dev/guide/browser): «Vitest always requires a provider to be defined. You can chose either `preview`, `playwright` or `webdriverio`» и «to run tests in CI you need to install either `playwright` or `webdriverio`»;
- **`CI`** — Vitest на коммите c8558f1: [`browser.headless`](https://github.com/vitest-dev/vitest/blob/c8558f1/docs/config/browser/headless.md) — «**Default:** `process.env.CI`» и «If you are running Vitest in CI, it will be enabled by default»; [`allowOnly`](https://github.com/vitest-dev/vitest/blob/c8558f1/docs/config/allowonly.md) — «**Default:** `!process.env.CI`» и «By default, Vitest does not permit tests marked with the `only` flag in Continuous Integration (CI) environments». Что `CI` задан на раннере, — sources 2.2.

Прочитано 2026-11-01 (поправки 2026-11-01 к R16 и R19, T34):
- **Vitest** — vitest-dev/vitest на `main` 2debb4e, последний релиз v5.0.5:
  - `docs/guide/coverage.md`: «By default Vitest will show only files that were imported during test run. To include uncovered files in the report, you'll need to configure `coverage.include` with a pattern that will pick your source files»;
  - `docs/config/coverage.md`: у `coverage.reportsDirectory` «Default: `'./coverage'`», и «Vitest will delete this directory before running tests if `coverage.clean` is enabled (default value)»;
  - имя файла — istanbuljs/istanbuljs на `main` 28ffdbc, `packages/istanbul-reports`: `lcovonly` пишет `opts.file || 'lcov.info'`, а `lcov` — тот же `lcov.info` и HTML в `lcov-report`.

### 9.4. OSV-Scanner

Прочитано 2026-10-21 (R19):
- **OSV-Scanner** — v2.7.0, 2026-10-12 (API GitHub, `repos/google/osv-scanner/releases/latest`), Apache-2.0, в релизе — `osv-scanner_SHA256SUMS`. [Offline Mode](https://google.github.io/osv-scanner/usage/offline-mode/): «Offline scanning checks your project against a local database instead of calling the OSV.dev API» и «When a local database is not present, you will get an error message».

### 9.5. Docker: кеш сборки

Прочитано 2026-10-21 (R19):
- **кеш сборки** — [Docker Docs, GitHub Actions cache](https://github.com/docker/docs/blob/773efbb/content/manuals/build/cache/backends/gha.md) на коммите 773efbb: «This cache storage backend works with the default `docker` driver only when the containerd image store is enabled» и «If you invoke the `docker buildx` command manually from an inline step, then the variables must be manually exposed. Consider using the `crazy-max/ghaction-github-runtime`, GitHub Action as a helper for exposing the variables». Docker и Buildx на раннере — sources 2.6.

### 9.6. Ubuntu Snapshot Service

Прочитано 2026-10-21 (R19):
- **архив Ubuntu на дату** — [Ubuntu Snapshot Service](https://snapshot.ubuntu.com/): «The Ubuntu snapshot service makes it possible to see and use the Ubuntu archive as it was at any specified date and time», «Snapshots of the Ubuntu archive are available for any date and time after 1 March 2023», «We intend to ensure snapshots are available for dates up to at least 2 years in the past» и «The apt included in Ubuntu 24.04 and later automatically detects when snapshots are supported for a repository». Пример оттуда — `apt install hello --update --snapshot 20240301T030400Z`. Образ Playwright заводит своего пользователя, `pwuser` (`adduser pwuser` в `Dockerfile.noble` v1.64.1), а стадия `devcontainer` заготовки идёт от `vscode` (`USER vscode`).

## 10. Go, go-licenses и Codecov

### 10.1. Go

Прочитано 2026-11-01 (поправки 2026-11-01 к R16 и R19, T34):
- **Go** — [Go 1.22 Release Notes](https://go.dev/doc/go1.22): «`go test -cover` now prints coverage summaries for covered packages that do not have their own test files» — «functions in the package are treated as uncovered». И ещё: «if a package contains no executable code at all, we can't report a meaningful coverage percentage; for such packages the `go` tool will continue to report that there are no test files». Проба — measurements 4.1.

### 10.2. go-licenses

Прочитано 2026-10-21 (R16):
- **`--allowed_licenses`** — [README go-licenses v2.0.1](https://github.com/google/go-licenses/blob/v2.0.1/README.md), раздел Usages, Check: «Allow only specific license names» — `go-licenses check <package> [package...] --allowed_licenses=<comma separated license names>`. Проба — measurements 2.1.

### 10.3. Codecov

Прочитано 2026-11-01 (поправки 2026-11-01 к R16 и R19, T34):
- **приложение Codecov** — `gh api orgs/altnovatrail/installations`: `codecov`, `repository_selection: all`. API Codecov, `api.codecov.io/api/v2/github/altnovatrail/repos/`, называет все 13 репозиториев. До T34 активен был только `spec`, а после пробы — и `.github`;
- **CLI Codecov** — релизы codecov/codecov-cli, лицензия Apache-2.0. v11.3.2 — Latest, вышел 2026-10-28: «Clear Dependabot high alert (urllib3)» и «Rebuilt from main so the Linux and Alpine binaries publish».
  - `https://cli.codecov.io/v11.3.2/linux/codecov.SHA256SUM` — `8e1bfb71661378530f6ea21e82b414095899e565cbb4cf555c613064be17b973  codecov`. У v11.3.1 в том же файле — `ca1d6419…`, та же сумма, что в `ci.yml` `spec`.
  - Подпись `codecov.SHA256SUM.sig` gpg 2.4.4 принял: «Good signature from "Codecov Uploader (Codecov Uploader Verification Key) <security@codecov.io>"», «Primary key fingerprint: 2703 4E7F DB85 0E0B BC2C 62FF 806B B28A ED77 9869».
  - Тот же отпечаток называет страница [Codecov Uploader](https://docs.codecov.com/docs/codecov-uploader), обновлённая 2026-06-07: «Key Fingerprint: `2703 4E7F DB85 0E0B BC2C 62FF 806B B28A ED77 9869`». Ключ она велит брать с `https://keybase.io/codecovsecops/pgp_keys.asc`.
  - Бинарник называет себя `codecovcli, version 11.3.2`, а его `sha256sum` сходится с файлом сумм;
- **actions** — `git ls-remote`: `codecov/codecov-action` v7.1.1 — 303a32d, `actions/upload-artifact` v7.0.2 — cf430e0, `actions/download-artifact` v8.0.2 — 9000827. Все три — последние релизы. Лицензия codecov-action — MIT. Его `action.yml` на 303a32d:
  - токен OIDC берёт `core.getIDToken` с аудиторией `https://codecov.io`, если `use_oidc` и это не форк;
  - форк — это `github.event.pull_request.head.repo.full_name` не равный `github.repository`, и тогда отчёт уходит без токена, от ветки `владелец:ветка`, как у `spec` (R48 spec);
- **пути в Codecov** — правило по умолчанию для путей импорта Go, Codecov, Fixing paths (поправка 2026-11-01 к R48 spec). Проба — measurements 4.1;
- **несколько загрузок на коммит** — [Codecov, codecov.yml reference](https://docs.codecov.com/docs/codecovyml-reference), обновлена 2026-07-23. У `codecov.notify.wait_for_ci` — «Should Codecov wait for all CI statuses to complete before sending ours», по умолчанию `true`. У `codecov.notify.after_n_builds` — «How many uploaded reports Codecov should wait to receive before sending statuses», по умолчанию `1`.

## 11. Инструменты проверок

### 11.1. gitleaks

Прочитано 2026-10-19 (R03):
- **релиз и лицензия** — API GitHub — `repos/gitleaks/gitleaks/releases/latest`: v8.30.1, 2026-03-21, файлы — архивы под платформы и `gitleaks_8.30.1_checksums.txt`, подписи и аттестации нет; `repos/gitleaks/gitleaks/license`: MIT.

Прочитано 2026-10-20 (R08):
- **gitleaks** — [README v8.30.1](https://github.com/gitleaks/gitleaks/blob/v8.30.1/README.md), раздел Load Configuration: «The order of precedence is:», и четвёртым — «A `.gitleaks.toml` file within the target path». Сумма архива `gitleaks_8.30.1_linux_x64.tar.gz` — из `gitleaks_8.30.1_checksums.txt` того же релиза: `551f6fc83ea457d62a0d98237cbad105af8d557003051f41f3e7ca7b3f2470eb`.

### 11.2. actionlint и ShellCheck

Прочитано 2026-10-20 (R08):
- **actionlint** 1.7.12 — последний релиз (API GitHub, `repos/rhysd/actionlint/releases/latest`, 2026-03-30); сумма архива `actionlint_1.7.12_linux_amd64.tar.gz` — из `actionlint_1.7.12_checksums.txt`: `8aca8db96f1b94770f1b0d72b6dddcb1ebb8123cb3712530b08cc387b349a3d8`;
- **shellcheck** 0.11.0 — последний релиз (API GitHub, `repos/koalaman/shellcheck/releases/latest`, 2025-08-04), лицензия — GPL-3.0 (`repos/koalaman/shellcheck/license`); файлов сумм в нём нет, поэтому сумма `shellcheck-v0.11.0.linux.x86_64.tar.xz` посчитана по скачанному архиву: `8c3be12b05d5c177a04c29e3c78ce89ac86f1595681cab149b65b97c4e227198`.

### 11.3. yq и bats-core

Прочитано 2026-11-01 (R28, T35):
- **yq** — v4.54.1, последний релиз, 2026-09-29 (API GitHub, `repos/mikefarah/yq/releases/latest`). Лицензия — MIT: «The MIT License (MIT)», `LICENSE` на теге v4.54.1.
  - Среди файлов релиза — `yq_linux_amd64`, `checksums` и `checksums_hashes_order`. SHA-256 — восемнадцатая строка `checksums_hashes_order`, а в строке `yq_linux_amd64` файла `checksums` за именем идут суммы в том же порядке. Сумма SHA-256 — `8e34fc298390875de416e6a4afcb8cabeceb25d9aa8506c1a2f9353cf702ea5f`.
  - Скачанный файл, 14 168 224 байта, с ней сошёлся, а `--version` — «yq (https://github.com/mikefarah/yq/) version v4.54.1».
- **bats-core** — v1.14.0, последний релиз, 2026-07-21, файлов у релиза нет (API GitHub, `repos/bats-core/bats-core/releases/latest`); лицензия — MIT.

### 11.4. just

Прочитано 2026-10-20 (R14):
- **`just --dry-run`** — справка just 1.58.0, `just --help`: «Print what just would do without doing it». Проба — measurements 5.1.

### 11.5. git

Прочитано 2026-10-22 (поправки к R10 и R18, T28):
- **git** v2.55.0, коммит e9019fc. `Documentation/git-clone.adoc`, `--local`: «The files under `.git/objects/` directory are hardlinked to save space when possible», и «If the repository is specified as a local path (e.g., `/path/to/repo`), this is the default». `Documentation/git-worktree.adoc`, `add`: «The new worktree is linked to the current repository, sharing everything except per-worktree files such as `HEAD`, `index`, etc.».

## 12. `spec`: теги, рецепты и скрипты

### 12.1. `spec` v0.2.11

Прочитано 2026-10-20 (R10):
- **отказ Releases API у релиза `spec`** (sources 3.2) — У `release.yml` `spec` на v0.2.6 пропускался только 404. С v0.2.7 пропускаются и 404, и 403, но только когда коммит уже не вершина и в нём добавлены или изменены файлы `.github/workflows/` относительно вершины: `git diff --quiet --diff-filter=AM "$tip" "$TARGET" -- .github/workflows/` (`release.yml` `spec` v0.2.9; поправка к R31 spec). С v0.2.11 это правило — рецепт `release-refusal`, и он требует ещё, чтобы коммит лежал в истории вершины (ниже, в чтении по R14).

Прочитано 2026-10-20 (R14):
- **`release-version`** в `spec/justfile` v0.2.11 принимает коммит и путь к workflow. Комментарий рецепта: вне `spec` «the line is RELEASE_LINE as the workflow named second sets it at that commit, a path from the repository's root, whatever the shell sets: a release workflow's own env, the tip's, must not number an older commit. A commit from before that workflow existed takes the checked-out file's line»;
- **`release-refusal <коммит> <вершина> <файл ошибки>`** там же «Exits 0 when the refusal is that one, and 1 with the reason when it is not or when anything cannot be read». `release.yml` `spec` v0.2.11 зовёт оба рецепта через скрипт запуска `$RUNNER_TEMP/toolchain`: он запускает команду в стадии `toolchain`, смонтировав рабочую папку и `$RUNNER_TEMP`, второй — только для чтения;
- **суммы архивов** — `.devcontainer/Dockerfile` из рецепта v0.2.11 (R34 spec). Все восемь сумм — Node 24.21.0, just 1.58.0, gh 2.101.0 и just-lsp 0.10.0, каждая для amd64 и arm64 — сошлись с архивами, которые 2026-10-20 скачаны с адресов этого Dockerfile и сверены `sha256sum`.

### 12.2. `spec` v0.2.12, v0.2.13 и v0.2.17

Прочитано 2026-10-21 (R16):
- **список `spec`** — `spec/tools/licenses/config.mjs` на v0.2.12: `allowed` — 0BSD, Apache-2.0, BlueOak-1.0.0, BSD-2-Clause, BSD-3-Clause, CC0-1.0, ISC, MIT, MIT-0 и Unlicense, по одному в строке. Проба шага — measurements 2.1.

Прочитано 2026-10-21 (R19):
- **`licenses-check` `spec`** — `spec/tools/licenses/main.mjs` на v0.2.13: «The lock file is always the one beside this script: no path comes from the command line». Он обходит `packages` lock-файла и берёт `license` каждого пакета, а у lock-файла без `packages`, версии 1, проверил бы ноль пакетов и ответил бы «ok».

Прочитано 2026-10-22 (поправки к R10 и R18, T25):
- **`toolchain.sh`** — `spec/tools/toolchain/toolchain.sh` на v0.2.17, режим 100755. Его режимы: `build` — «build the stage as the image novatrail-toolchain», `run <command> [<argument>...]` — «run a command in it» и `spec [--dry-run] <recipe> [<argument>...]` — «run one of spec's recipes, from spec's justfile». О запуске: «The repository is mounted at /work, and RUNNER_TEMP read-only at its own path, where gh leaves the error of a refused release; nothing else of the runner's environment goes in». Тесты скрипта — рецепт `toolchain-test`, с подменой docker.

### 12.3. `spec` v0.2.18–v0.2.21

Прочитано 2026-10-22 (R22, поправки к R16 и R19, T26):
- **теги `spec`** — v0.2.18 04ab0d2, v0.2.19 6462304, v0.2.20 6caf6ff и v0.2.21 14e2a11 (`gh release list -R altnovatrail/spec`), каждый неизменяемый. `tools/licenses/config.mjs`, `.devcontainer/` и `tools/toolchain/` с v0.2.17 не менялись (`git diff`);
- **поправка 2026-10-22 к R39 spec**, v0.2.18 и новее. «Исключение, которое принимает лицензию вне списка, … держит только пакет, который lock-файл помечает `dev`», а «`devOptional` — не `dev`». «То же исключение покрывает пакеты, которые сам инструмент называет в `optionalDependencies`, — так приходят его сборки под платформы, — пока они тоже `dev` и под той же лицензией». Исключение для `null` или `SEE LICENSE IN <файл>` «поправляет то, что говорит lock-файл, а не принимает лицензию вне списка»;
- **рецепты** — `spec/justfile` v0.2.21. `licenses-check-repo lock exceptions=""` идёт из папки, откуда его зовут: `cd {{quote(invocation_directory())}} && node … --lock=… --exceptions=…`. `licenses-allowed` — `node tools/licenses/main.mjs --allowed`, по идентификатору в строке, в порядке `config.mjs`. Ни один не зовёт `_tools`.

### 12.4. `spec` v0.4.1

Прочитано 2026-11-01 (R25, T31):
- **тег** — v0.4.1, коммит 23000f3, вышел 2026-10-29: `gh release view` — неизменяемый, а `gh release verify v0.4.1 -R altnovatrail/spec` — «Release v0.4.1 verified!», с файлами `format-0.1.tar.gz` и `altnovatrail-spec-0.4.1.tgz` и их bundle. Между v0.2.23 и ним — 76 коммитов (`git log --oneline v0.2.23..v0.4.1`). `tools/toolchain/` и `tools/licenses/` не изменились (`git diff --quiet`);
- **Go в стадии `toolchain`** — `.devcontainer/Dockerfile` из `editDevcontainer` v0.4.1 для `.github`: Go 1.27.3. Суммы архивов совпадают со списком go.dev, `https://go.dev/dl/?mode=json&include=all`: `go1.27.3.linux-amd64.tar.gz` — `65efbc80fdc1fa2cd2631cad5b481777a68e8725f34e89f50fc6ac714e379b40`, `go1.27.3.linux-arm64.tar.gz` — `a06e99309dbcbdca1a8ccd2282c3ee146e55930886e26b4f1193269587165f49`. `devcontainer.json` и `host-network.sh` рецепт отдаёт те же, что здесь. docker в devcontainer нет, и образ здесь не собирался: стадию `toolchain` соберёт CI pull request;
- **значки README** — каждый адрес ответил 200 и значением: CI, Release и CodeQL — «passing», номер релиза — «v0.1.10», Scorecard — 6.8, лицензия — «Apache-2.0»; у SonarCloud code smells — 0, reliability, security и maintainability — A, vulnerabilities — 0.

### 12.5. `spec` v0.5.3

Прочитано 2026-11-01 (R27, T36):
- **тег** — v0.5.3, коммит 38ce564, вышел 2026-11-01 в 17:19 UTC: `gh release view` — неизменяемый, а `gh release verify v0.5.3 -R altnovatrail/spec` — «Release v0.5.3 verified!». Между v0.4.1 и ним — v0.5.0, T46 `spec` (R74 spec), и v0.5.1 и v0.5.2, T50 `spec`; сам v0.5.3 — ответ на В28;
- **что не менялось** — `.devcontainer/`, RULES.md, AGENTS.md, `repo-template/`, `tools/toolchain/`, `tools/licenses/`, `tools/new-repo/` и `tools/docs-check/` (`git diff --quiet v0.4.1 v0.5.3`). В `tools/release/` изменился только тест. Рецепты `_tools`, `docs-check-repo`, `licenses-allowed`, `licenses-check-repo`, `release-version` и `release-refusal` в `justfile` те же, слово в слово; новые — `ci-lint`, `ci-test`, `ci-vuln` и `ci-licenses` для `go.yml`;
- **README `spec` v0.5.3**, раздел «Status»: «version 0.1 … comes out as files for code from the release v0.3.0, with its types for Go from v0.3.4 and for TypeScript from v0.4.0 … The first contract between components, the types of the element `<novatrail-canvas>` between `canvas` and `app`, comes out from v0.5.0», со ссылкой на R74 spec, «and the other contracts come after it»;
- **`spec` зовёт `go.yml`** — поправка 2026-11-01 к R30 spec: job «Go» в `ci.yml` `spec` зовёт общий `go.yml` v0.1.10, коммит f3addb7, по SHA с версией рядом, а его `ci-licenses` проверяет по `ALLOWED_LICENSES`, который даёт `go.yml`.

### 12.6. `spec` v0.6.2

Прочитано 2026-11-01 (R30, T38):
- **тег** — v0.6.2, коммит 49d0fb6, вышел 2026-11-01 в 23:54 UTC. `gh release view` — неизменяемый, а `gh release verify v0.6.2 -R altnovatrail/spec` — «Release v0.6.2 verified!». Между v0.5.3 и ним — v0.5.4–v0.5.8, v0.6.0 и v0.6.1 (`gh api repos/altnovatrail/spec/releases`). От v0.6.1 v0.6.2 отличается только RUN.md и concepts 16 `spec`;
- **что не менялось** — `.devcontainer/`, AGENTS.md, `repo-template/`, `tools/toolchain/`, `tools/licenses/`, `tools/new-repo/` и `tools/docs-check/` (`git diff --stat v0.5.3 v0.6.2`).
  - Рецепты, которые зовут общие и `self-` workflow, — `docs-check-repo`, `licenses-allowed`, `licenses-check-repo`, `release-version`, `release-refusal` и `ci-*` — те же слово в слово.
  - Новые рецепты — `release-verify` и `release-verify-npm`, а `release-version-test` теперь зовёт `_tools`.
  - В `tools/package.json` пришли пакеты sigstore-js для `release-verify`, и `_tools` ставит их и для проверки документов;
- **RULES.md**:
  - новое жёсткое правило «Release files are verified»: «A file of a NovaTrail release — a binary, an archive, an index — enters code or CI only once `just -f spec/justfile release-verify` has accepted it …, where it enters NovaTrail»;
  - в правиле о языке — «and so is spec's cross-repository plan, COORDINATION.md (R76 spec)»;
- **README `spec` v0.6.2**, раздел «Status»: «Version 0.1 came out as files for code from the release v0.3.0, with its types for Go from v0.3.4 and for TypeScript from v0.4.0; version 0.2, whose digit on a crop is 24 px high unless the module gives it, comes out from v0.6.0. The format is still to be tried on the modules of the first slice»;
- **В29 и В30** — в `spec` v0.6.2 их нет: ни RUN.md, ни журнал `spec` их не называют.

Прочитано 2026-11-02 (поправка 2026-11-02 к R18, T39):
- **`toolchain.sh` v0.6.2** (комментарий в начале файла): «The repository is mounted at /work, and RUNNER_TEMP read-only at its own path … nothing else of the runner's environment goes in». О `spec --dry-run`: «just's dry run parses the call, prints the recipe and runs nothing».

### 12.7. `spec` v0.6.3

Прочитано 2026-11-02 (R31, T40):
- **тег** — v0.6.3, коммит 8460f11, вышел 2026-11-02 в 02:30 UTC. `gh release view` — неизменяемый, а `gh release verify v0.6.3 -R altnovatrail/spec` — «Release v0.6.3 verified!». Тегов между v0.6.2 и ним нет (`gh release list -R altnovatrail/spec`);
- **что не менялось** — `.devcontainer/`, RULES.md, AGENTS.md, README.md, `justfile`, `tools/toolchain/`, `tools/licenses/` и `tools/docs-check/` (`git diff --quiet v0.6.2 v0.6.3`). В `tools/release/` изменились только `test/`, а `tools/package.json` и `tools/package-lock.json` — нет. Рецепты, которые зовут общие и `self-` workflow, — те же слово в слово. Изменились `repo-template/` и `tools/new-repo/` (R79 spec) и `tools/types/npm/README.md`;
- **поправка 2026-11-02 к R63 spec** — «прошлый индекс получает и проверяет шаг общего `release.yml` `.github` на раннере, а рецепт `release-files` `modules` получает уже проверенный файл. Т-35 закрыт — ответ автора 2026-11-02 по строке „в реестр spec“ `.github` В33, вариантом 1′». Как файл доходит до рецепта, «решает T41 `.github`»;
- **поправка 2026-11-02 к R77 spec** — «В пункте „Где проверяется“ слова „в том шаге, который его получает“ у релиза `modules` значат шаг общего `release.yml` на раннере, а не рецепт `release-files`»;
- **снятый номер у `spec`** — комментарий шага «Check the npm package» `release.yml` `spec` v0.6.3: «A version it held lies in its time then, or under time.unpublished.versions once the whole package is gone». Номер шаг ищет и там: `(.time.unpublished.versions? // []) | index($v) != null`. Документы таких пакетов в реестре — sources 8.3;
- **COORDINATION.md `spec` v0.6.3** — строка 2.2 отмечена сделанной 2026-11-02, с pull request 85 и 86 `.github`, подмодулем `v0.6.2` и релизом `v0.1.13`. Строка 2.3 — «E11: T40, T41», а строка 3.7 — «рецепт `release-files` `modules` получает его проверенным от общего релиза, а не скачивает сам», по поправке 2026-11-02 к R63 spec, и «как именно — T41 `.github`».

Прочитано 2026-11-02 (поправка 2026-11-02 к R18, T41):
- **`previous` шага номера** — `tools/release/version.mjs` `spec` v0.6.3: «previous= the newest release before it, where the release notes start», а `nextVersion` отдаёт в нём `newest`, высший релиз по номеру. У `modules` релизов, `release.yml` и рецепта `release-files` пока нет (API GitHub).

Прочитано 2026-11-02 (поправка 2026-11-02 к R18, T42):
- **проверка `spec`** — шаг «Check the npm package» `release.yml` `spec` v0.6.3: `jq -e --arg v "$version" '((.time // {}) | has($v)) or ((.time.unpublished.versions? // []) | index($v) != null)'`. У общего шага она теперь та же: `diff` строк с `jq -e --arg v "$version"` обоих файлов пуст. Вторая половина ловит номер из `unpublished.versions` без ключа в `time`; в трёх документах такого нет.

### 12.8. `spec` v0.9.8

Прочитано 2026-11-08 (R32, T43):
- **тег** — v0.9.8, коммит b1fbc61, вышел 2026-11-08 в 01:29 UTC и стал новейшим релизом `spec`. `gh release view` — неизменяемый, а `gh release verify v0.9.8 -R altnovatrail/spec` — «Release v0.9.8 verified!». Между v0.6.3 и ним 29 тегов, с v0.6.4 по v0.9.7;
- **что изменилось из того, что берёт `.github`** (`git diff v0.6.3 v0.9.8`):
  - `.devcontainer/Dockerfile`. Базовый образ — `mcr.microsoft.com/devcontainers/base:3.0.12-noble` по digest вместо 3.0.10. Добавлен buf 1.75.0 с суммами для amd64 и arm64 (R83 spec), а комментарии о Go называют любой код репозитория. `devcontainer.json` и `host-network.sh` не менялись;
  - RULES.md. Строки «в реестр spec» сессия `spec` находит сама, на `main` (R81 spec). Новое жёсткое правило — о production-образах (R105 spec);
  - заготовка: правило 2 RUN.md — по R81 spec, а в Environment CLAUDE.md — buf;
  - README `spec`: формат 0.3 выходит с v0.9.0, таблица допуска — с линии 0.8 (R96 spec), код контрактов — с линии 0.7 (R83 spec);
  - карточка 3.11 spec — изменилась только часть `infra` (R105, R106 spec);
- **что не менялось для workflow `.github`.** Рецепты `docs-check-repo`, `licenses-allowed`, `licenses-check-repo`, `release-version`, `release-refusal` и `release-verify` — с теми же параметрами, а `tools/toolchain/` и `tools/docs-check/` не менялись. `tools/release/verify.mjs` сверх прежнего принимает файлы `spec` `admission-<версия>.tar.gz` и `altnovatrail-contracts-<версия>.tgz`. `tools/licenses/main.mjs` только перенёс `inRepository` в `tools/shared.mjs`. Рецепт на настоящем файле — measurements 5.8;
- **что `spec` поручает `.github`** (RUN.md `spec` v0.9.8, таблица 4):
  - Д69 — ответ на В35: комментарий шага «Check the npm package» `release.yml` `spec` говорит, как общий шаг, что номер пакета, снятого целиком, остаётся ключом в `time`;
  - Д80 — перечень `paths` вида modules в шаблоне, а в CONTRIBUTING — что образцы eval-набора вносит только организатор eval-набора (поправка 2026-11-02 к R25 spec; concepts 15 spec). Оба — «своим переходом»;
  - Д88 — группа `groups` для ссылок `altnovatrail/.github/*` в шаблоне `dependabot.yml`, «своим релизом»;
  - Д91 — шаг «Publish to npm» ждёт версию в реестре до 20 минут, с `timeout-minutes` под это (поправка 2026-11-02 к R37 spec), «своей задачей»;
  - Д114 — опции общего `go.yml`: прогоны на целях, разностная проверка `fma-diff`, job на `ubuntu-24.04-arm`, а затем общий тест правил кода (R107 spec), «своей задачей»;
- **COORDINATION.md `spec` v0.9.8.** Пункт 2 закрыт: строка 2.3 — «2026-11-02, pull request 88–91, релизы `v0.1.14` и `v0.1.15`». В «Состоянии» у `.github` — подмодуль v0.6.3, релиз v0.1.15 и «нет: E11 сделан, таблица 2 пуста». О Д5 там сказано, что он «ждёт теперь одного `infra`».

Прочитано 2026-11-08 (поправка 2026-11-08 к R18, T44):
- **поправка 2026-11-02 к R37 spec** — срок 20 минут. Реестр проверяет пакет до выдачи: «introduces a short delay between publishing and availability, typically around five minutes. It may take longer, up to 15 minutes or more, at peak times or depending on a package's content and size» ([GitHub Changelog, npm publish-time malware scanning, 2026-07-28](https://github.blog/changelog/2026-07-28-npm-publish-time-malware-scanning-and-dual-use-metadata/), как его цитирует поправка, прочитавшая его 2026-11-02);
- **вторая поправка 2026-11-03 к R37 spec** — архив. «Версия в реестре доступна, когда документ пакета её показал и реестр отдаёт её архив». У релиза `spec` v0.7.2 документ показал 0.7.2 в 04:17:35 UTC, а архив отвечал 404 до 04:22:50. Общий шаг до T44 качал архив одним `curl -fsSL --retry 3`, который 404 не повторяет, — та же гонка;
- **шаг «Publish to npm» `release.yml` `spec` v0.9.8** — раунды раз в 10 секунд, `deadline=$((SECONDS + 1200))` и не больше 120 раундов. Документ — `curl -sS --proto "=https" --retry 3 --max-time 30`, архив — `curl -sS --proto "=https" --proto-redir "=https" -L --max-time 60`, без повтора. Пакет, на котором npm упал, ищется три раунда, пока документ его не показал. Общий шаг взял это на один пакет, с теми же сообщениями об ошибках.

Прочитано 2026-11-08 (поправка 2026-11-08 к R08):
- **скрипт** — `spec/tools/toolchain/toolchain.sh` v0.9.8: «toolchain.sh build» — «build the stage as the image novatrail-toolchain», «toolchain.sh spec [--dry-run] <recipe>» — «run one of spec's recipes, from spec's justfile». Команда идёт от пользователя раннера, с домом в `/tmp`, корень репозитория — в `/work`, а `RUNNER_TEMP` — только для чтения.

### 12.9. `spec` v0.9.9

Прочитано 2026-11-08 (R34, T51):
- **тег** — v0.9.9, коммит fa5da0b, вышел 2026-11-08 в 16:03 UTC и стал новейшим релизом `spec`. `gh release view` — неизменяемый, а `gh release verify v0.9.9 -R altnovatrail/spec` — «Release v0.9.9 verified!»;
- **что изменилось** (`git diff --stat v0.9.8 v0.9.9`) — 13 файлов: COORDINATION.md, RUN.md, `docs/`, `format/README.md` и пример ловушек, `tools/contracts/report.mjs` и `tools/docs-check/citations.mjs` с их тестами. `.devcontainer/`, RULES.md, `justfile` и `tools/toolchain/` не менялись;
- **карточка 3.11 spec** — пункт «для кода» называет вход `same-bits` обёртки Go: прогоны на целях, `fma-diff`, прогон на arm64 и тест правил кода инструментом `.github` со списками вызывающего в `.github/coderules.json`. Таблица 5 RUN.md `spec` записала ответ на В36 `.github` — карточку 3.11 spec и Д116;
- **COORDINATION.md `spec` v0.9.9** — в «Состоянии» у `.github` подмодуль v0.9.8, релиз v0.1.21 и «нет: E12–E15 сделаны, таблица 2 пуста».

### 12.10. `spec` v0.12.0

Прочитано 2026-11-09 (R35):
- **тег** — v0.12.0, коммит 5b4640a, вышел 2026-11-09 в 19:38 UTC; `gh release list` называет его «Latest». `gh release view` — неизменяемый, а `gh release verify v0.12.0 -R altnovatrail/spec` — «Release v0.12.0 verified!»;
- **что изменилось** (`git diff --stat v0.9.9 v0.12.0`) — 56 коммитов, 756 файлов: формат 0.4 (v0.10.0), часть `deployment/` (v0.11.0), таблица допуска 0.2 (v0.12.0), контракты, типы, `repo-template/` и `tools/new-repo/`, `justfile` и `tools/release/`. `.devcontainer/`, RULES.md, `tools/toolchain/`, `tools/docs-check/` и `tools/licenses/` не менялись;
- **COORDINATION.md `spec` v0.12.0** — в «Состоянии» у `.github` подмодуль v0.9.9, релиз v0.1.21 и «нет: таблица 2 пуста»; строка 2.4 — «задачи ещё нет»: кеш образа стадии `toolchain` в `go.yml`, `typescript.yml` и `documents.yml`, без кеша в общем `release.yml`, и релиз `.github` (поправка 2026-11-09 к R31 spec; Д146 в RUN.md `spec`). T104 `spec`, кеш в `toolchain.sh`, на v0.12.0 ещё не сделана.

### 12.11. `spec` v0.13.0

Прочитано 2026-11-10 (R37):
- **тег** — v0.13.0, коммит 59fd14f, вышел 2026-11-10 в 00:27 UTC; `gh release list` называет его «Latest». `gh release view` — неизменяемый, а `gh release verify v0.13.0 -R altnovatrail/spec` — «Release v0.13.0 verified!»;
- **T104 `spec`** (RUN.md `spec`, «Сделано (2026-11-09)»; коммит 82411a5) — `tools/toolchain/toolchain.sh`: «The image may come from a file of docker save, which the caller keeps in the cache of GitHub Actions by the sha256 of the Dockerfile (R31): TOOLCHAIN_IMAGE_FILE names it, its whole path. Unset or empty, build builds the stage, as ever». Вызовы docker — «load --quiet --input <file>, image inspect novatrail-toolchain, build as above, save --output <file> novatrail-toolchain». Предупреждение — строка `::warning::toolchain.sh: …` в stdout без пути, а путь — строкой в stderr;
- **что ещё изменилось** (`git diff --stat v0.12.0 v0.13.0`) — 102 файла: юридические тексты (`legal/`), DPIA, `ci.yml` и `release.yml` `spec`, `justfile`, `tools/docs-check/config.mjs` — документ `docs/dpia.md`. `.devcontainer/`, RULES.md и `tools/licenses/` не менялись;
- **COORDINATION.md `spec` v0.13.0** — строка 2.4: «E17: T52 сделана, T53 ждёт; ветка `e17`, черновой pull request 109».

Прочитано 2026-11-10 (поправка 2026-11-10 к R36, T53):
- **скрипт** — `spec/tools/toolchain/toolchain.sh` v0.13.0: «TOOLCHAIN_IMAGE_FILE names it, its whole path. Unset or empty, build builds the stage, as ever»; предупреждение о файле, который не дал образа, — «::warning::toolchain.sh: the file of TOOLCHAIN_IMAGE_FILE did not give the image novatrail-toolchain, so it is built. The cache entry that held the file is broken and stays: delete it, or it is hit again»;
- **путь** — `ci.yml` `spec` v0.13.0 держит файл в `${{ runner.temp }}/novatrail-toolchain.tar` под тем же ключом, что `go.yml` (RUN.md `spec`, T104, «Сделано»).

### 12.12. `spec` v0.16.3

Прочитано 2026-11-12 (R38, T54):
- **тег** — v0.16.3, коммит 664398e, мерж pull request 138 `spec`, вышел 2026-11-12 в 20:17 UTC; `gh release list` называет его «Latest». `gh release view` — неизменяемый, а `gh release verify v0.16.3 -R altnovatrail/spec` — «Release v0.16.3 verified!»;
- **что изменилось** (`git diff --stat v0.13.0 v0.16.3`) — 77 коммитов, 302 файла: RULES.md, CLAUDE.md и правила `.claude/rules/` `spec`, `docs/` на английском с `docs/sources.md` и `docs/measurements.md`, `DEBT.md`, части `consent-age/` и `export/`, `legal/` версии 2, контракты, `repo-template/`, `tools/docs-check/`, `tools/session/`, `tools/tokens/`, `tools/translation/`, `tools/release/` и `.devcontainer/Dockerfile` — Go 1.27.4. `tools/toolchain/` не менялся;
- **Go 1.27.4** — суммы архивов по `https://go.dev/dl/?mode=json`: `linux-amd64` — `7226736c2339719cda28fbf3a54d71aa63bcefe376e98cef00034268dab24840`, `linux-arm64` — `3392582988a273a87ab5043ee1b2c9c17a2c3c00580bf9326c47a2e0aaaeac92`, те же, что в Dockerfile `spec` v0.16.3.

## 13. Другие репозитории NovaTrail

### 13.1. Подмодуль `spec` и `documents.yml` у других репозиториев

Прочитано 2026-11-01 (R25, T31):
- **вызывающие `documents.yml`** (Д5 в RUN.md) — `ci.yml` и подмодуль `spec` на `main` каждого, API GitHub: `api`, `app`, `engine`, `infra`, `learner-model`, `modules`, `sim` и `skill-map` — v0.2.9; `module-kit` — v0.2.13; `canvas` — v0.2.42; `tutor` — v0.3.3. `documents.yml` они зовут по SHA v0.1.0, а `tutor` — v0.1.5 и `canvas` — v0.1.10.

Прочитано 2026-11-02 (R30, T38):
- **вызывающие `documents.yml`** (Д5 в RUN.md; 2026-11-02) — подмодуль `spec` на `main` каждого, API GitHub: у `api`, `app`, `engine`, `infra`, `learner-model`, `modules`, `sim` и `skill-map` — v0.2.9, у `module-kit` — v0.2.13, у `canvas` — v0.4.1, у `tutor` — v0.5.4. `documents.yml` они зовут по SHA v0.1.0, `tutor` — v0.1.5, а `canvas` — v0.1.12.

Прочитано 2026-11-02 (поправка 2026-11-02 к R18, T42):
- **вызывающие `documents.yml`** (Д5 в RUN.md) — подмодуль `spec` на `main` каждого, API GitHub: у `engine`, `infra`, `learner-model`, `modules`, `sim` и `skill-map` — v0.2.9, у `module-kit` — v0.2.13, у `api`, `app`, `canvas` и `tutor` — v0.6.2. `documents.yml` они зовут по SHA v0.1.0, `tutor` — v0.1.5, а `canvas` — v0.1.12.

Прочитано 2026-11-08 (R32, T43):
- **вызывающие `documents.yml`** (Д5 в RUN.md) — подмодуль `spec` на `main` каждого, API GitHub: `infra` — v0.2.9, `canvas` — v0.6.5, `app` — v0.6.6, `module-kit` — v0.9.3, `api` — v0.9.4, `learner-model`, `modules` и `tutor` — v0.9.5, а `engine`, `sim` и `skill-map` — v0.9.8. Тег назван по коммиту подмодуля: теги `vX.Y.Z` и `contracts/vX.Y.Z` стоят на одном коммите.

Прочитано 2026-11-08 (поправка 2026-11-08 к R08):
- **вызывающие** — подмодуль `spec` на `main` каждого, API GitHub: `infra` — v0.2.9, а остальные десять — v0.6.6 или новее: `app` — v0.6.6, `api` — v0.9.4, `learner-model` и `tutor` — v0.9.5, `canvas`, `engine`, `module-kit`, `modules`, `sim` и `skill-map` — v0.9.8. `infra` зовёт `documents.yml` по SHA `v0.1.0`, ff2a359, а его последний коммит — от 2026-10-21.

Прочитано 2026-11-12 (R38, T54):
- **`module-kit`** — подмодуль `spec` на `main` — коммит 58d3f46, `v0.15.0` (API GitHub, `repos/altnovatrail/module-kit/contents/spec`): строка 7.1 COORDINATION.md `spec` ещё не сделана.

### 13.2. `canvas` и npm

Прочитано 2026-10-22 (поправка к R18, T27):
- **реестр и `canvas`** — `https://registry.npmjs.org/@altnovatrail%2fcanvas` отвечает 404 «Not found», а `-/org/altnovatrail/package` — 200. У `canvas` нет ни `release.yml`, ни релизов, ни неизменяемых релизов, ни ruleset тегов (API GitHub).

Прочитано 2026-11-01 (R25, T31):
- **`canvas` и npm** (Д7 в RUN.md) — у `canvas` нет ни релизов, ни `release.yml` (API GitHub), а `@altnovatrail/canvas` в реестре — 404 «Not found». Его T24 — в эпике E5, который стоит в таблице 2 RUN.md `canvas`, среди эпиков на потом, а его текущий эпик E7 релиза не несёт: «первый релиз — T24 в E5 или своя задача» (RUN.md `canvas`, `main`).

Прочитано 2026-11-02 (R30, T38):
- **`canvas` и npm** (Д7 в RUN.md; 2026-11-02) — у `canvas` по-прежнему нет ни релизов, ни `release.yml` (API GitHub), а `@altnovatrail/canvas` в реестре — 404. Его текущий эпик — E8 «Первый релиз» (RUN.md `canvas`, `main`):
  - T67 переводит `canvas` на тег линии 0.6;
  - T70 выпускает v0.1.0 и тот же архив кладёт в npm;
  - T71 — следующие версии шагом общего релиза, через trusted publishing.

Прочитано 2026-11-02 (поправка 2026-11-02 к R18, T42):
- **`canvas` и npm** (Д7 в RUN.md):
  - у `canvas` есть `.github/workflows/release.yml` — коммит bc60d93, «Do T66: the release build and its trial run», 2026-11-02. Он зовёт общий `release.yml` v0.1.12 по SHA 4225639, с `publish: false` и `npm-package: "@altnovatrail/canvas"`, а его прогоны 2026-11-02 — `pull_request` и `workflow_run` — прошли (API GitHub);
  - релизов у `canvas` нет, `@altnovatrail/canvas` в реестре — 404, а T70 «Первый релиз: пакет» и T71 «Публикация шагом npm» в RUN.md `canvas` — `[ ]`.

Прочитано 2026-11-08 (R32, T43):
- **`canvas` и npm** (Д7 в RUN.md):
  - у `canvas` релизы v0.1.0, v0.1.1 и v0.1.2, все от 2026-11-02. В реестре `@altnovatrail/canvas` — версии `0.0.0-stage` и 0.1.0 без provenance, а затем 0.1.1, в 05:39 UTC, и 0.1.2, в 16:36 UTC, с provenance `https://slsa.dev/provenance/v1`;
  - provenance 0.1.1 (`registry.npmjs.org/-/npm/v1/attestations/@altnovatrail%2fcanvas@0.1.1`): workflow — `.github/workflows/release.yml` репозитория `altnovatrail/canvas` на `refs/heads/main`, прогон 41395016624. Прогон — `workflow_run`, «success», а его `referenced_workflows` — `altnovatrail/.github/.github/workflows/release.yml@09443e1027ef24197439dfe60a072d14c3626cc3`, v0.1.13. Его job — «Release / release»;
  - значит, npm принял публикацию через trusted publishing из reusable workflow другого репозитория и записал provenance вызывающего. Сейчас `release.yml` `canvas` на `main` зовёт общий v0.1.13 с `npm-package: "@altnovatrail/canvas"`.

### 13.3. Кто зовёт общие workflow для кода

Прочитано 2026-10-22 (поправка к R19, T29):
- **вызывающие** — `.github/workflows/` и `justfile` двенадцати других репозиториев организации — `canvas` и одиннадцати остальных, — через API GitHub. `typescript.yml` зовёт только `canvas`. `ALLOWED_LICENSES` читают `ci-licenses` `module-kit` и `tutor`, но это go-licenses со списком из `go.yml`. Поиск кода GitHub `org:altnovatrail ALLOWED_LICENSES` ответил пусто, поэтому файлы прочитаны по одному.

Прочитано 2026-11-01 (поправки 2026-11-01 к R16 и R19, T34):
- **кто зовёт обёртки** — `ci.yml` на `main` каждого репозитория организации, API GitHub:
  - `canvas` — `typescript.yml` v0.1.10;
  - `spec` — `go.yml` v0.1.10;
  - `tutor` — `go.yml` v0.1.5;
  - `module-kit` — `go.yml` v0.1.2;
  - остальные — ни одну.

  `ci-test` `module-kit` и `tutor` — `go test -race -count=1 ./...`, у `canvas` — `vitest run`, и отчёта не пишет ни один. Модули Go называются `github.com/altnovatrail/module-kit` и `github.com/altnovatrail/tutor`.

### 13.4. `canvas`

Прочитано 2026-10-21 (поправка к R19):
- **`headless`** — `vitest.config.ts` `canvas` на 88492c4: `headless: true`, с комментарием «Headless whatever CI says: there is no display in the container or on the runner. CI still keeps test.only out of CI, as Vitest's allowOnly does by default»;
- **`npm` из скрипта** — `scripts/package.ts` `canvas` на 88492c4 запускает `execFileSync(process.execPath, [npm, "pack", …])`, где `npm` — `../lib/node_modules/npm/bin/npm-cli.js` от папки `process.execPath`: «no program is looked up in PATH». Находку `typescript:S4036` и красный quality gate называет RUN.md `canvas`, T08;
- **ruleset `canvas`** — `repos/altnovatrail/canvas/rulesets/25506234/history` (API GitHub): версия 54216848 — 2026-10-21T23:13:18Z. От прошлой версии, 54024579, её отличают только пять новых проверок в `required_status_checks`, все с `integration_id` 15368. У pull request #19 `canvas` `gh pr checks 19 --required` называет десять проверок, и все — «pass».

Прочитано 2026-10-22 (R22, поправки к R16 и R19, T26):
- **`canvas`** — API GitHub, `main` 7163904. Подмодуль `spec` — 04ab0d2, v0.2.18. `ci.yml` зовёт `typescript.yml@c772cc8… # v0.1.5`, а `ci-licenses` — `node scripts/licenses.ts`, который читает `ALLOWED_LICENSES`. Его T32 переводит `ci-licenses` на рецепт `spec`, когда выйдет обёртка с подмодулем в job `licenses`.

Прочитано 2026-10-22 (поправка к R19, T29):
- **`canvas`** — API GitHub и клон вне репозитория. `main` — 379c774, merge-коммит pull request #25, слит в 16:08 UTC, а `scripts/licenses.ts` ушёл коммитом 1a335a9. `ci-licenses` — `{{ quote(just_executable()) }} -f spec/justfile licenses-check-repo package-lock.json licenses.json` (`justfile`, строка 48). `git grep ALLOWED_LICENSES` на 379c774 находит переменную только в документах и в шапке `justfile`: «Nothing here reads ALLOWED_LICENSES, which .github keeps for older checks until its Д6». Подмодуль `spec` — 04ab0d2, v0.2.18, а `ci.yml` зовёт `typescript.yml@0ab2799… # v0.1.8`. Все четыре «TypeScript / …» зелёные и на голове #25, 1a335a9, и на 379c774.

Прочитано 2026-11-08 (поправка 2026-11-08 к R04, T45):
- **`release.yml` `canvas`** на `main`, bdb9e6d, 2026-11-08 — перечень `paths`, как в шаблоне architecture 3.3, с `npm-package: "@altnovatrail/canvas"`. Его правило — поправка 2026-11-02 к R08 canvas, а `NOTICE` в архиве — R46 canvas (журнал `canvas` на `main`).

Прочитано 2026-11-09 (R36, T52):
- **образец** — R57 canvas (`docs/decisions.md` `canvas`, `main` 66266e1) и его шаги в `page.yml`: `actions/cache/restore` с ключом `toolchain-${{ runner.os }}-${{ runner.arch }}-${{ hashFiles('.devcontainer/Dockerfile') }}`, `emulators/toolchain.sh` — `docker load` файла или сборка с `docker save`, — и `actions/cache/save` при `steps.toolchain.outputs.cache-hit != 'true'` с ключом `cache-primary-key`.

### 13.5. `learner-model` и `engine`

Прочитано 2026-11-08 (поправка 2026-11-08 к R16, T46):
- **рецепты** `test-targets` и `fma-diff` `justfile` `learner-model` (`main` 50f1b51) и `engine` (`main` 33500ea) — одни и те же, кроме комментариев и номера решения в сообщении `fma-diff`. Скрипты job — эти рецепты, с контролем `testdata/fma/control.go` `learner-model` внутри `go.yml`.

Прочитано 2026-11-08 (поправка 2026-11-08 к R16, T47):
- **job «Go arm64»** у `learner-model` и `engine` — `ubuntu-24.04-arm`, стадия `toolchain`, `just ci-test`, к которому рецепт добавлял `test-targets` и `fma-diff`. Job `arm64` `go.yml` делает то же, кроме `fma-diff`: его вывод от хоста не зависит — так говорит комментарий рецепта, — и он уже идёт в «Go / fma-diff».

Прочитано 2026-11-08 (R33, T48):
- **две копии теста** — `rules_test.go` `learner-model` (`main` 50f1b51, 677 строк) и `engine` (`main` 28cbde9, 721 строка, «a port of learner-model's rules_test.go, with the engine's lists»). `diff`: у `engine` разрешённый модуль в `require`, правило `replace`, разбор блоков `go.mod`, импортёр `importer.ForCompiler(fset, "source", nil)` и проверка внешних тестов с тем же набором `*types.Package`; у копий разные `codeImports`, `testImports` и `mathTestFuncs`, а сообщения называют репозиторий. Проверка вложенных модулей у обоих освобождает `.devcontainer/gopls/go.mod`. `testdata/coderules` у копий свой: каждый подогнан под свои списки.

### 13.6. Rulesets и подмодули `spec` других репозиториев

Чтения записи стояли в тексте architecture 2.9 и 3.3, без записи, а T55 перенесла их сюда 2026-11-12, как они были: ответов API запись не держит.

Прочитано 2026-10-20 (поправка к R30 spec; T17 и T16 `spec`):
- **rulesets `spec`, `module-kit` и `tutor`** — API GitHub: правило `code_scanning` и только merge у `spec` и `module-kit` стоят с T17 `spec`, а у `tutor` — с T16 `spec`.

Прочитано 2026-10-21 (поправка к R32 spec; T21 `spec`):
- **подмодуль `engine`** — API GitHub: коммит 5eafb1a, v0.2.9.

## 14. MathTrail и образцы вне NovaTrail

### 14.1. canvas-api

Прочитано 2026-10-19 (R03):
- **workflow canvas-api** — `.github/workflows/` на коммите [0901af0](https://github.com/MathTrail/canvas-api/tree/0901af0439280334b3da33ffc4cc5c853e4403ff/.github/workflows) — `ci.yml`, `codeql.yml`, `scorecard.yml`, `release.yml` и `deploy.yml`. Единственный reusable workflow — `deploy.yml`, и его вызывает только `release.yml` того же репозитория; workflow других репозиториев canvas-api не вызывает. Проверка лицензий — R48 canvas-api, подпись — R52 canvas-api, CI в образе тулчейна — R49 canvas-api.

Прочитано 2026-10-20 (R09):
- **ruleset canvas-api** — У canvas-api правило `code_scanning` (sources 3.1) — с инструментом CodeQL, порогами `errors` и `high_or_higher` (API GitHub, `repos/mathtrail/canvas-api/rulesets/25036747`).

Прочитано 2026-10-21 (R16):
- **имена рецептов** — `justfile` canvas-api на коммите 0901af0: `ci-lint`, `ci-test`, `ci-vuln` и `ci-licenses`; govulncheck и go-licenses там идут через `go run` по точной версии модуля, а CI зовёт те же рецепты в образе тулчейна (R49 canvas-api).

Прочитано 2026-10-21 (R19):
- **canvas-api** на коммите 0901af0, через API GitHub:
  - `web/.npmrc` — `save-exact=true` и `ignore-scripts=true`, с комментарием «No package runs code of its own while it is being installed: nothing in the tree needs to, and what it would run is code nobody here has read»; рецепт `web-install` — `npm ci --no-audit --no-fund`;
  - `ci-vuln` — `npm audit --prefix web --omit=dev --audit-level=high`, без установки пакетов. `ci-licenses` — `node web/scripts/licenses.ts check --allowed … --except lightningcss=MPL-2.0` по `web/package-lock.json` версии 3 (R48 canvas-api);
  - формат и линт — Biome 2.5.15, типы — `tsc --noEmit`, тесты — Vitest 5.0.3 с happy-dom (R47 canvas-api). Тестов в браузере там нет.

### 14.2. `nodenv/.github`

Прочитано 2026-10-19 (R03):
- **репозиторий с именем `.github`** документация как место общих workflow не называет. Так устроен [nodenv/.github](https://github.com/nodenv/.github) (коммит 01e040a): `nodenv/nodenv` вызывает `uses: nodenv/.github/.github/workflows/release.yml@bd27009d5f178c0a88d42f7b07e6a3c7623ed768 # v7.0.8`, а README объясняет: «GitHub doesn't allow them to live in any other directory, so the reusable workflows are all in the same location as the workflows _for this repository. To distinguish them, the workflows for this repository are prefixed with `.github_`». Что Dependabot такую ссылку поднимает, мейнтейнер dependabot-core показал в [issue #12489](https://github.com/dependabot/dependabot-core/issues/12489), 2025-12-29: «issue is not reproducible. Attaching screenshots below for a bump PR to version 7.0.5». Вызов подтвердила T17 `spec` (architecture 2.8); поднимает ли Dependabot ссылку, покажет `v0.1.1` (T14).
