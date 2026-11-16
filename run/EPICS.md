# EPICS.md — epics for later of `.github`

Table 2 of [RUN.md](../RUN.md) (R153 spec, R154 spec).

- A row has a result and a basis, no tasks yet. Row order is the order epics are taken, until the author decides otherwise.
- Read by the choice and planning of the next epic, not by each task. Once an epic is split into tasks, they go to table 1 and the body of RUN.md, and its row leaves (RUN.md, Epics).
- Epics come from spec's COORDINATION.md, a row of `.github` there, or from what a tag of spec gives `.github`.

## Table 2. Epics for later

| ID | Epic | Result | Basis |
|---|---|---|---|
| E21 | CI speed of the shared workflows | A release of the shared workflows by row 7.13 of COORDINATION.md spec: the Go cache in `go.yml` — `GOMODCACHE`, `GOCACHE`, `GOLANGCI_LINT_CACHE` as a volume, keyed by the Dockerfile, the check and `go.sum`, read-only on a pull request, saved on a push to `main`, then `go mod verify`, none in `release.yml`; one path and one tag of the `toolchain` image file in every workflow, not saved from a pull request, one job builds it on a miss; «Go / targets» as a matrix by target, «Go / fma-diff» targets in parallel; `release.yml` verifies its files in one call or in parallel, signs in parallel; CodeQL (go) takes Go from the Dockerfile's archive by its sha256, no image; `typescript.yml` — WebKit and Firefox as a check of their own, which names the contract's browsers too (Д217 spec; R19); with the tag of spec of row 7.14 — the release and the checks with no browser and no Go tests in the stage `toolchain-core`. Its cases (R28), trial pull requests, decisions; callers take the release by Dependabot | Row 7.13 of COORDINATION.md spec; measurements 3.1 spec; Д217 spec; R40. Its part `toolchain-core` waits for row 7.14, T166 spec |
