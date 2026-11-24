# EPICS.md — epics for later of `.github`

Table 2 of [RUN.md](../RUN.md) (R153 spec, R154 spec).

- A row has a result and a basis, no tasks yet. Row order is the order epics are taken, until the author decides otherwise.
- Read by the choice and planning of the next epic, not by each task. Once an epic is split into tasks, they go to table 1 and the body of RUN.md, and its row leaves (RUN.md, Epics).
- Epics come from spec's COORDINATION.md, a row of `.github` there, or from what a tag of spec gives `.github`.

## Table 2. Epics for later

| ID | Epic | Result | Basis |
|---|---|---|---|
| E32 | Analysis of the budgets raised in E31 | The analysis R145 spec sets for a threshold met: the entries `R16`, `R18`, `R19`, `R41` and `R42` of the log and the section `architecture 3.3` grew when links at a tag or commit replaced the numbers of records; each one either goes back under its former limit, by a rewrite of its text in force, or keeps the raise with the reason, as the analysis of measurements 1.14 spec did | The threshold of three raises of a budget since the last analysis (R145 spec): four commits of `docs-budgets.json` in E31, measurements 11.2 |
