---
name: to-tasks
description: "Converts a plan (and optionally research findings) into a TASKS.md - task list ready for autonomous implementation via a coding-agent loop. Strict trigger: only invoke when the user explicitly says `/to-tasks` or `to-tasks` verbatim."
disable-model-invocation: true
---

# TO-TASKS

Turn `PLAN.md` (and optional `RESEARCH.md`) into a `TASKS.md` the autonomous loop can execute one task at a time.

Do not implement anything in this phase. Do not write PRD-style narrative — this is a task list. Stay agent-agnostic: refer to "the coding agent" or "the autonomous loop", never a specific assistant.

## High-level overview

1. Locate inputs: `PLAN.md` (required), `RESEARCH.md` (optional).
2. Study them end to end.
3. Ask only the critical clarifying questions if real ambiguity remains.
4. Discover project commands and conventions. Ask only if undiscoverable.
5. Write `TASKS.md` to the project root unless I specify otherwise. Include only sections with real content.

## Step 1 — Locate inputs

Look for `PLAN.md` and `RESEARCH.md` in the project root or the location I specified.

If `PLAN.md` is missing, stop and ask me to create it. If `TASKS.md` already exists, see *Existing TASKS.md* below — never overwrite silently.

## Step 2 — Minimal clarification

Read both inputs end to end. Ask questions only if one of these is genuinely unclear:

- Objective — what problem this solves
- Work type — feature, refactor, research, migration, etc.
- Constraints — time, compute, scope
- Verification — how "done" is checked

One round of questions, max. If everything is clear, skip questions and proceed.

## Step 3 — Discover commands and conventions

Determine lint, type-check, test, and run commands plus the tech stack. Use this priority order:

1. `CLAUDE.md` or `AGENTS.md` in the project root — authoritative if present.
2. Project config files:
   - `pyproject.toml` — `[tool.ruff]`, `[tool.pytest]`, `[project.scripts]`
   - `package.json` — the `scripts` section
   - `Makefile` — targets like `lint`, `test`, `check`, `run`
   - `Cargo.toml`, `go.mod`, or other language-specific configs
   - `.github/workflows/*.yml` — CI steps often reveal canonical commands
   - `README.md` — frequently documents run/test/lint
3. Ask me if commands cannot be determined from the above. If I answer verbally and no `AGENTS.md` exists, suggest I add one for future sessions.

If a command genuinely cannot be determined, leave a placeholder: `# TODO: determine <kind> command`.

## Step 4 — Build the task list

### Categories

Pick one per task:

- `setup` — infrastructure, schema, config bootstrapping
- `research` — research-related work
- `feature` — new functionality or experiments
- `refactor` — restructuring, cleanup
- `testing` — test writing, coverage
- `docs` — documentation, README updates
- `migration` — DB or system migrations
- `integration` — external services

If a task doesn't fit cleanly, pick the closest and note the nuance in the description.

### Verification step

Each task's final step depends on its work type:

- Any code change → `Typecheck passes`
- Code with tests → `All tests pass`
- ML / research → `Results logged and reproducible`
- Refactoring → `Existing tests pass (no regressions)`

The wording must map directly to a command in the *Tech Guidelines* section.

### Sovereignty

Each task runs in a fresh agent session that has only:

- `CLAUDE.md` or `AGENTS.md`
- The full `TASKS.md`
- `ACTIVITY.md`, `PATTERNS.md`, `PROMPT.md`
- Git history and the current codebase

The agent has no memory of how prior tasks were implemented. Therefore:

1. Never write "use the function from T-2". Write "use `load_dataset()` from `src/data.py`". The agent finds it in the codebase.
2. Never assume implementation choices. If a task depends on a config schema from a prior task, describe what the schema must contain.
3. Each task's steps must be independently checkable — no need to run other tasks first.
4. Include file paths whenever possible. Write "Add `patience` to `src/config.py`", not "to the config".

### Right-sized tasks

Good size examples:

- A configuration parameter with validation
- A single function or method
- Tests for one module
- Logging in a pipeline stage
- A data preprocessing step

Too big — split. Examples:

- "Build the entire pipeline" → config, data loading, processing, evaluation
- "Add experiment tracking" → schema, logging, metrics, output formatting
- "Refactor the codebase" → one task per module or pattern

Split further if the task touches more than 3-4 files, requires cross-module understanding, combines implementation with its own tests, or needs broad codebase exploration before any change is possible.

Rule of thumb: if you can't describe the change in 2-3 sentences, split it.

### Verifiable steps

Good steps:

- `Add patience parameter to src/config.py with default 5`
- `Implement load_dataset() in src/data.py returning a DataFrame`
- `Log validation loss after each epoch to metrics.json`
- `Raise ValueError when input shape mismatches expected`

Bad steps:

- `Works correctly`
- `Handles edge cases`
- `Good performance`
- `Clean implementation`

### Ordering

Earlier tasks must never require later tasks. Order roughly:

0. Additional research (optional)
1. Configuration and schema changes
2. Core logic and data processing
3. Higher-level functions built on core logic
4. Tests and validation

Documentation and integration are interspersed where useful.

## Step 5 — Write TASKS.md

Save to `TASKS.md` in the project root, or to the path I specified. Include a section only if there's real content — do not invent goals, non-goals, or metrics to fill space.

````markdown
# TASKS

## Overview
[1-3 sentence summary distilled from PLAN.md / RESEARCH.md.]

## Goals
[Bulleted, concrete, testable. Omit if not in PLAN/RESEARCH.]

## Non-Goals
[Bulleted scope guardrails. Omit if not in PLAN/RESEARCH.]

## Success Metrics
[Bulleted, measurable. Omit if not in PLAN/RESEARCH.]

## Tasks

### T-1: <short title>
- **Category:** <one of the 8 categories>
- **Passes:** false
- **Description:** <plain factual sentence>
- **Steps:**
  - <verifiable step with file paths where relevant>
  - <verifiable step>
  - <verification step from the table above>

<...more tasks...>

## Tech Guidelines

**Tech stack:** <language + version, frameworks, package manager>
**Conventions:** <project-specific rules from AGENTS.md / README / inferred>
**File layout:** <source dir, test dir, config location>

**Linting:** `<command>`
**Type checking:** `<command>`
**Tests:** `<command>`
**Run:** `<command>`
````

Task heading is `### T-N: Title` with sequential `T-N` starting at `T-1`. `Passes` is always `false` when written; the loop flips it to `true` on completion.

## Existing TASKS.md

If `TASKS.md` already exists at the target location, read it first and ask me whether to:

- Update — preserve `Passes: true` tasks, apply surgical edits to others, note changes at top via `<!-- Updated: YYYY-MM-DD — ... -->`.
- Extend — append new tasks with fresh sequential IDs, leave existing tasks untouched.
- Replace — overwrite, but confirm explicitly first.

Never silently overwrite. Always preserve completed-task state unless I say to replace.

## Writing style

The reader is the autonomous coding agent and a human reviewer. Therefore:

- Be explicit and concrete.
- Number tasks.
- Reference files and functions by path.
- Avoid unexplained jargon.
- Assume zero prior context.
