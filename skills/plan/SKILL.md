---
name: plan
description: Create deterministic execution plans (`plan.json`) for autonomous implementation agents. Use when the user asks for a plan, execution plan, task breakdown, or a step-by-step implementation sequence from requirements or a PRD.
---

# Plan

## Overview

Create an ordered, deterministic, end-to-end execution plan another autonomous agent can run without assumptions.
Stay in planning mode at all times. Do not write, suggest, or include code.

## Activation

Activate only when the user explicitly asks for a plan or execution plan.

## Chain Contract (`prd -> plan -> exec`)

- Prefer upstream input from a PRD included in the prompt or stored as `prd.md` in the repository root.
- If the PRD contains requirement IDs (`FR-*`, `NFR-*`, `AC-*`), preserve traceability:
  - reference covered IDs in each task `goal` and `DoD` (example: `Covers: FR-003, AC-007`).
- Do not invent product behavior outside PRD scope unless required to keep the repository runnable or backward-compatible.
  - If unavoidable, record the assumption explicitly in `summary`.

## Operating Principles

- Do not output the final plan until it is executable end-to-end without guesses.
- Ask clarification questions only when required data cannot be obtained from repository code, tests, docs, configs, or tooling.
- Keep every task atomic, minimal, and runnable.
- Do not include opportunistic refactors, renames, formatting sweeps, or unrelated improvements.

## Planning Workflow (strict order)

### 1) Clarify requirements

Drive requirement clarification until desired behavior is unambiguous.
Capture:

- user-visible behavior
- invariants, constraints, and success criteria
- edge cases and backward compatibility needs
- performance and security constraints

Decide safety mode from requirements:

- **Runnable invariant (mandatory):** after every task, the repository builds and task-relevant tests pass.
- **Rolling-safe invariant (optional):** enforce only when requested. Old and new versions must run concurrently during rollout, including backward/forward compatibility windows for DB or contract changes.

### 2) Map repository context

Identify:

- architecture boundaries (modules/services/layers)
- existing patterns for similar changes
- sources of truth (DB tables, configs, external systems)
- exact ownership of each change

### 3) Review tools and dependencies

- Prefer tools and dependencies already present in the repository.
- Add a new dependency only when strictly necessary.
- Explicitly rule out simpler built-in or already-available alternatives before introducing anything new.

### 4) Synthesize and minimize tasks

Draft tasks, then run the required minimization pass until every task satisfies all validation gates and keeps the repository runnable.

### 5) Emit the plan artifact

Produce a valid `plan.json` document with exact top-level shape:

- `tasks`: ordered list of task objects
- `summary`: short summary of scope, non-goals, risks, and assumptions

Output JSON only:

- no markdown fences
- no prose before or after JSON
- no extra top-level keys

## Task Minimality System (mandatory)

### Core rules

Each task must be:

- **Atomic:** one coherent change reviewable in isolation.
- **Minimal:** no unrelated refactors, renames, formatting sweeps, or opportunistic work.
- **Runnable:** after the task, the repository still builds and task-relevant tests pass.

Each task must also have:

- one primary intent
- at most one decision point

Umbrella tasks are forbidden (for example: `migrate all...`, `update everything...`, `refactor module...`).

### Semantic Delta Units (0/1 each per task)

- **BDU (Behavior Delta Unit):** introduces or changes exactly one user-observable behavior or rule.
- **CDU (Contract Delta Unit):** introduces or changes exactly one external contract (API shape, schema, CLI/public type, event format).
- **SDU (State Delta Unit):** introduces or changes exactly one persisted state format (DB, stored JSON, cache key, file format).
- **ODU (Ops Delta Unit):** introduces or changes exactly one operational/runtime requirement (config, env var, worker/cron, permissions, secrets).
- **FSU (Failure Surface Unit):** changes failure policy or semantics (retry, timeout, error mapping/classification, alerting semantics, client-visible error contract).

Minimality rule:

- For every task: `(BDU + CDU + SDU + ODU + FSU) <= 1`
- **Bridge exception (rare):** allow total `2` only when the second unit is a strict compatibility bridge required to keep runnable and it adds no new observable behavior.

### What does not count as a delta unit

Treat these as mechanical keep-runnable edits:

- import/plumbing/signature updates forced by additive scaffolding
- compatibility parsing that accepts old and new formats without enabling new behavior
- fixture updates that preserve prior test meaning
- build-only adjustments required to compile, without new runtime requirements

### Single-Dimension Rule

Each task must declare exactly one primary dimension from:
`{Behavior, Contract, State, Ops, Failure}`.

Do not combine independent semantic changes across dimensions.
Cross-dimension edits are allowed only as backward-compatible, no-op scaffolding needed to keep runnable.

### Compatibility constraints

**SDU tasks must be additive:**

- no destructive drops/renames without a compatibility window
- new fields nullable or with safe defaults
- new tables/indexes must not break existing paths

**CDU tasks must be backward-compatible:**

- new fields optional by default
- no removals or semantic/type breaks in the same task
- removals require staged compatibility tasks

**ODU tasks must be optional by default:**

- new env/config must have safe defaults or gating
- new runtime components start disabled/no-op, then enable later in separate tasks

### Required minimization pass

For each drafted task:

1. Compute `BDU/CDU/SDU/ODU/FSU`.
2. If minimality or Single-Dimension fails, split in this fixed order:
   - split state preparation (`SDU`) from behavior that uses it (`BDU`)
   - split contract introduction (`CDU`) from behavior that depends on it (`BDU`)
   - split behavior implementation (behind defaults/flags/no-op) from behavior enablement wiring
   - split failure or ops policy changes (`FSU/ODU`) from core behavior (`BDU`) unless purely mechanical scaffolding
3. Repeat until all tasks pass and the repository remains runnable after each task.

### Forbidden compositions (must split)

A task is forbidden if it simultaneously:

- introduces a contract change (`CDU`) and enables dependent behavior (`BDU`)
- introduces a state change (`SDU`) and enables dependent behavior (`BDU`)
- introduces a new runtime requirement (`ODU`) and makes it mandatory immediately
- changes happy-path behavior (`BDU`) and failure policy semantics (`FSU`)

### Validation gate before output

Do not emit the final plan unless every task passes:

- one primary intent
- at most one decision point
- repository runnable after the task
- delta rule satisfied (or explicit bridge-exception rationale)
- Single-Dimension Rule satisfied
- compatibility constraints satisfied
- `DoD` validates only this task
- rollback scoped to this task

## Output Contract

### `plan.json` shape

Return exactly one JSON object:
`{"tasks":[...], "summary":"..."}`

Rules:

1. `tasks` must use the exact task schema below.
2. `T01` must create and switch to a new git branch inside task `steps`:
   - branch name must be short and kebab-case
   - include exact git commands
   - `T01` must not be branch-only no-op; include at least one concrete repository change so commit is possible
3. `summary` must briefly include:
   - what will change
   - what will not change
   - key risks
   - assumptions

### Task schema (no extra fields)

- `id`: stable unique identifier (`T01`, `T02`, ...)
- `title`: short imperative title
- `goal`: exact change introduced by this task
- `context`: explicit relative-path allowlist of files/directories to inspect or edit
- `steps`: exact ordered mechanical steps (no code)
- `bounds`: explicit files/components/behaviors that must remain unchanged
- `DoD`: objective checks validating only this task; include requirement traceability when PRD IDs exist
- `commit`: imperative, concise commit message
- `push`: exact command(s) to push
- `rollback`: one concrete rollback action limited to this task

### Minimality proof (mandatory inside `goal`)

Append this exact line at the end of `goal`:
`Minimality: primary=<Behavior|Contract|State|Ops|Failure>; BDU=<0|1> CDU=<0|1> SDU=<0|1> ODU=<0|1> FSU=<0|1>; rationale=<why it cannot be split further without breaking runnable/back-compat>.`

If you cannot write this honestly, split the task.

### DoD rules

- Validate only this task.
- Do not include unrelated checks.
- Do not defer core verification to a final aggregate task.
