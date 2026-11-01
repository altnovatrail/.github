# NovaTrail

NovaTrail is a universal open platform for adaptive learning, interactive lessons and AI tutoring, for any subject and any age. A subject comes as a module: data, not code and not instructions to a model. A program decides whether an answer is right, against the task's key; the AI only reads the learner's work and words the tutor's replies. A learner model brings together the skills of every module, and an engine picks what comes next.

**Status:** early design. spec holds the platform's documents and the [module format](https://github.com/altnovatrail/spec/blob/v0.4.1/format/README.md): version 0.1, its text, schemas, examples and test vectors, which comes out as files for code from the release v0.3.0, with its types for Go from v0.3.4 and for TypeScript from v0.4.0, and is still to be tried on the modules of the first slice. The contracts between the platform's parts come after it. NovaTrail succeeds [MathTrail](https://github.com/mathtrail), olympiad maths for grades 1–6, which is now frozen.

## Repositories

| Repository | What it is | Stage |
|---|---|---|
| [spec](https://github.com/altnovatrail/spec) | the vocabulary, formats, contracts and platform documents | 0. Foundation |
| [.github](https://github.com/altnovatrail/.github) | the organization's profile, community files and shared CI workflows | 0. Foundation |
| [modules](https://github.com/altnovatrail/modules) | the official modules: olympiad maths for grades 1–6, school maths for grade 3 and short essays in English | 1. Format and core |
| [module-kit](https://github.com/altnovatrail/module-kit) | the module format in code — validation, packages, open views, check kinds — and the authors' CLI | 1. Format and core |
| [learner-model](https://github.com/altnovatrail/learner-model) | the learner model: how well each skill is mastered, from the evidence of attempts | 1. Format and core |
| [engine](https://github.com/altnovatrail/engine) | the engine: picks the next lesson or task, with a reason code | 1. Format and core |
| [sim](https://github.com/altnovatrail/sim) | virtual learners that test the learner model and the engine | 1. Format and core |
| [tutor](https://github.com/altnovatrail/tutor) | the AI side of the tutor: reading the work, the tutor's words, routes to AI and eval; a library inside api | 2. First slice with learners |
| [api](https://github.com/altnovatrail/api) | the platform service: accounts, attempts, checks, the learner model and the engine | 2. First slice with learners |
| [canvas](https://github.com/altnovatrail/canvas) | the canvases: the kinds, the layers, the learner's strokes, and the samples page for eval | 2. First slice with learners |
| [skill-map](https://github.com/altnovatrail/skill-map) | the skill map | 2. First slice with learners |
| [app](https://github.com/altnovatrail/app) | the web app for learners and the adults beside them | 2. First slice with learners |
| [infra](https://github.com/altnovatrail/infra) | shared infrastructure: Terraform, domains, logs, deployment and self-hosting | 2. First slice with learners |

Later come site, at stage 3, Beta and public launch, and module-registry, module-pipeline and widget-template, at stage 4, Authors. The stages are the roadmap's, in the [product document](https://github.com/altnovatrail/spec/blob/v0.4.1/docs/product.md).

## Documents

The platform's documents live in spec, in Russian:

- [product](https://github.com/altnovatrail/spec/blob/v0.4.1/docs/product.md) — what we build and why: the principles, the first slice, the roadmap;
- [concepts](https://github.com/altnovatrail/spec/blob/v0.4.1/docs/concepts.md) — the shared vocabulary;
- [privacy](https://github.com/altnovatrail/spec/blob/v0.4.1/docs/privacy.md) — privacy and age;
- [architecture](https://github.com/altnovatrail/spec/blob/v0.4.1/docs/architecture.md) — the components and how they connect;
- [repositories](https://github.com/altnovatrail/spec/blob/v0.4.1/docs/repositories.md) — the repositories, the order they appear in, and how one is set up;
- [decisions](https://github.com/altnovatrail/spec/blob/v0.4.1/docs/decisions.md) — the decision log: what was decided, why, and what was rejected.

## Contributing

- [How to contribute](https://github.com/altnovatrail/.github/blob/main/CONTRIBUTING.md), and the rules every repository shares.
- [How to report a vulnerability](https://github.com/altnovatrail/.github/blob/main/SECURITY.md), privately.
- [The code of conduct](https://github.com/altnovatrail/.github/blob/main/CODE_OF_CONDUCT.md).

## License

Everything is [Apache-2.0](https://github.com/altnovatrail/spec/blob/v0.4.1/LICENSE): the code, the documents and the official modules' content. The one exception is the code of conduct, the Contributor Covenant 2.1, which keeps its own license, [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
