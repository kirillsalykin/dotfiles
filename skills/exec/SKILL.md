---
name: exec
description: Execute exactly one task from `plan.json` in strict order, without reinterpretation. Use when the user asks to run the next planned implementation task from `plan.json`/`progress.txt` with deterministic boundaries.
---

# Exec

## Overview

Run one implementation task at a time from `plan.json`, exactly as written.
Do not design, reinterpret, refactor, or optimize. Execute the plan literally.

## Input Contract

Read tasks from `plan.json` using this top-level shape:

- `tasks`: ordered array of task objects
- `summary`: planning summary (informational only)

Each task object must include exactly:

- `id`
- `title`
- `goal`
- `context`
- `steps`
- `bounds`
- `DoD`
- `commit`
- `push`
- `rollback`

If any field is missing or ambiguous, treat the task as unclear and stop.

## Control Files

- `plan.json`: read-only plan definition, never modify
- `progress.txt`: append-only log of completed task ids

Other repository files may be edited only if:

- explicitly required by the selected task `steps`
- within that task `context`

## Non-Negotiable Rules

1. No guessing, no assumptions, no best effort.
2. Execute only the selected task.
3. No opportunistic work (cleanup, rename, reformat, refactor, "while here" edits).
4. Execute exactly one task per run.
5. Never reorder, skip, add, or rewrite tasks.
6. Never modify `plan.json`.
7. If the task is unclear or requires work outside `context`, stop immediately.

## One-Run Procedure (strict order)

1. Read `plan.json`.
2. Validate `plan.json` structure:
   - top-level JSON object
   - `tasks` exists and is an ordered array
   - every task includes all required fields
   - if validation fails, stop
3. Read `progress.txt` (create an empty file if missing).
4. Select the first task in `plan.json.tasks` whose `id` is not yet in `progress.txt`.
5. Validate task clarity:
   - `context` is specific enough to bound work
   - `steps` are mechanically executable without reinterpretation
   - `bounds` clearly define what must not change
   - `DoD` is objective and runnable
   - `commit`, `push`, `rollback` are concrete executable instructions
   - if any check fails, stop with no code changes, no commit, and no push
6. Execute task steps exactly as written:
   - inspect only locations listed in `context`
   - perform only actions listed in `steps`
   - preserve everything listed in `bounds`
   - if required work extends beyond `context`, stop
7. Run `DoD` checks exactly as specified.
8. If `DoD` passes:
   - commit with task `commit` message verbatim
   - push using task `push` instructions verbatim
   - append task `id` to `progress.txt`
   - stop
9. If `DoD` fails:
   - execute task `rollback` once
   - fix only what is necessary for this same task to pass, staying inside `steps`, `bounds`, and `context`
   - rerun `DoD`
   - repeat until pass or task becomes unclear/blocked; then stop

## Blocked or Unclear State

If completion requires assumptions, unknown behavior, undefined commands, unclear push target, or out-of-context edits:

- stop immediately
- do not commit
- do not push
- do not append to `progress.txt`
- do not proceed to the next task
- write `INTERRUPTED` as the first non-empty line in `signal.txt`

## Commit and Completion Rules

- Use `commit` message exactly as provided by the task.
- Do not create extra commits unless the task explicitly requires them.
- When every task id in `plan.json.tasks` exists in `progress.txt`, write `COMPLETE` as the first non-empty line in `signal.txt`.

The runner reads only the first non-empty signal line. Additional explanation may follow.
