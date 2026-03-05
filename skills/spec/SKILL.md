---
name: spec
description: "Write a specification document - a set of user stories. Either written from scratch (with user input or PLAN.md) or translated from an existing PRD and need to create a task list for autonomous coding. Triggers on: write the spec, convert this plan, create specification from plan, convert this prd, create specification from prd, create spec from prd, turn prd into tasks."
---

# SPECIFICATION DOCUMENT

Either written from scratch or converted from existing PRDs into `SPEC.md` — a structured task list that autonomous agents execute one task at a time, each in an isolated session with no shared memory.

---

## The Job

Write from scratch (use user's input and/or PLAN) or take a PRD (usually `PRD.md` in the project root) and convert it to `SPEC.md` in the project root.

**Key constraint:** Each task in the spec will be executed by a fresh agent session that has ONLY these sources of context:
- `CLAUDE.md` — project-specific conventions, commands, and patterns (if it exists)
- The full `SPEC.md` file
- An `ACTIVITY.md` log from previous sessions
- The `PROMPT.md` instructions
- The git history and current codebase

The agent has **no memory** of how prior tasks were implemented. Tasks must be sovereign — fully self-contained and solvable in isolation.

---

## Step 1: Locate the Source PRD

1. If user specifies a file path, use that
2. Otherwise, look for `PRD.md` in the root directory
3. If multiple PRDs exist, ask which one to convert
4. If no PRD exists, ask user how to proceed with writing the specification
5. Read the entire PRD content or act accordingly with the user's input

---

## Step 2: Validate the PRD

Check that the PRD contains the required sections:

**Required:**
- Introduction/Overview (or Goals)
- User Stories OR Functional Requirements

**Optional but helpful:**
- Non-Goals (helps define boundaries)
- Technical Considerations
- Success Metrics

**If validation fails:**
- Missing User Stories AND Functional Requirements -> Stop and ask user to complete the PRD
- Missing Introduction -> Use the PRD title/filename as description
- Warn about missing optional sections but continue

---

## Step 3: Discover Project Commands

Before writing the SPEC, determine the correct commands for linting, type checking, testing, and running. Use this priority order:

1. **Check `CLAUDE.md`** (project root) — if it exists and lists commands under a "Commands" section, use them. This is the authoritative source maintained by the project owner.
2. **Inspect project files** — look for commands in:
   - `pyproject.toml` — `[tool.ruff]`, `[tool.pytest]`, `[project.scripts]`
   - `package.json` — `scripts` section
   - `Makefile` — targets like `lint`, `test`, `check`, `run`
   - `Cargo.toml`, `go.mod`, or other language-specific config
   - `.github/workflows/*.yml` — CI steps often reveal the canonical commands
   - `README.md` — often documents how to run, test, and lint
3. **Ask the user** — if commands cannot be determined from the above, ask rather than guessing. If the user provides commands verbally but no `CLAUDE.md` exists, suggest they create one for future sessions.

If you cannot determine a command after all sources, use a placeholder: `# TODO: determine [linting/test/...] command`.

---

## Step 4: Extract and Convert Tasks

Transform PRD content into tasks:

### Mapping Rules

| PRD Source | Task Category |
|------------|---------------|
| Infrastructure, schema, config setup | `setup` |
| Research-related tasks | `research` |
| New functionality or experiments | `feature` |
| Code restructuring, cleanup | `refactor` |
| Test writing, coverage improvement | `testing` |
| Documentation, README updates | `docs` |
| Database or system migrations | `migration` |
| Integration with external services | `integration` |

If a task does not fit any category, use the closest match and note it in the task description.

### Conversion Process

For each User Story in the PRD:
1. Extract or generate the ID -> becomes `id` (e.g., `US-1`, `US-2`, or use PRD's ID if present)
2. Extract the title -> becomes `title`
3. Extract the description -> becomes `description`
4. Extract acceptance criteria -> becomes `steps` array
5. Determine category from context and priority
6. Add appropriate verification step as final step (see below)
7. Set `passes: false`

**Field Mapping:**

| PRD User Story Field | Task Field |
|---------------------|------------|
| ID (if present) or generate `US-N` | `id` |
| Title | `title` |
| Description (the "As a... I want..." part) | `description` |
| Priority | Used for ordering and category inference |
| Acceptance Criteria | `steps` |

For Functional Requirements without User Stories:
1. Group related requirements into logical tasks
2. Generate ID (e.g., `FR-1`, `FR-2`)
3. Create title from FR summary
4. Each FR becomes a step within a task
5. Assign appropriate category

### Final Verification Steps by Work Type

| Work Type | Final Step(s) |
|-----------|---------------|
| Any code change | `"Typecheck passes"` |
| Code with tests | `"All tests pass"` |
| ML/Research | `"Results logged and reproducible"` |
| Refactoring | `"Existing tests pass (no regressions)"` |

The executing agent finds the exact commands for these verification steps in the **Notes** section at the bottom of SPEC.md. When writing verification steps, use wording that clearly maps to the commands listed there (e.g., "Typecheck passes" maps to the type checking command in Notes, "All tests pass" maps to the test command).

---

## Step 5: Write SPEC.md

Save the output to `SPEC.md` in the project root.

**JSON validity is critical.** The task list is parsed by automation. Before saving, verify:
- Every string is properly quoted
- No trailing commas after the last element in arrays or objects
- All special characters in strings are escaped (`\"`, `\\`)
- The JSON array is syntactically valid

---

## Output Format

````markdown
# Project Plan

## Overview
[Brief description extracted from PRD Introduction/Overview]

**Reference:** `PRD.md`

---

## Task List

```json
[
  {
    "category": "setup",
    "id": "US-1",
    "title": "User story title from PRD",
    "description": "As a [user], I want [feature] so that [benefit]",
    "steps": [
      "Concrete step 1 from acceptance criteria",
      "Concrete step 2 from acceptance criteria",
      "Verification step"
    ],
    "passes": false
  }
]
```

---

## Notes

**Linting:**
```bash
uv run ruff check .
```

**Type checking:**
```bash
uv run ty src/
```

**Tests:**
```bash
uv run pytest tests/
```

**Run:**
```bash
uv run python main.py
```
````

### Field Definitions

| Field | Type | Description |
|-------|------|-------------|
| `category` | string | One of: `setup`, `research`, `feature`, `refactor`, `testing`, `docs`, `migration`, `integration` |
| `id` | string | From PRD user story ID, or generate as `US-1`, `US-2`, etc. |
| `title` | string | Exact title from PRD user story |
| `description` | string | The "As a... I want... so that..." from PRD user story |
| `steps` | array | Ordered list derived from acceptance criteria + verification |
| `passes` | boolean | Always `false` initially; marked `true` when complete |

---

## Task Sovereignty: The Critical Rule

**Each task must be solvable by a fresh agent that has never seen any prior session.**

The executing agent receives:
- The full SPEC.md (all tasks, including completed ones)
- The ACTIVITY.md log (summaries of what prior sessions did)
- The current codebase (with committed changes from prior tasks)
- The PROMPT.md instructions

It does NOT receive:
- Memory of how prior tasks were implemented
- The reasoning or decisions made during prior sessions
- Any context beyond what is written in the files above

### What this means for task writing

1. **Never write "use the function from US-2"** — instead write "use the `load_dataset()` function from `src/data.py`" (the agent can find it in the codebase)
2. **Never assume knowledge of implementation choices** — if a task depends on a config schema from a prior task, describe what the schema must contain
3. **Each task's steps must be independently checkable** — the agent must be able to verify completion without running other tasks
4. **Include file paths when possible** — "Add `patience` parameter to `src/config.py`" not "Add `patience` parameter to the config"

### Right-sized tasks
- Add a configuration parameter with validation
- Implement a single function or method
- Write tests for one module
- Add logging to a pipeline stage
- Create a data preprocessing step

### Too big — split these
- "Build the entire pipeline" -> Split into: config, data loading, processing stages, evaluation
- "Add experiment tracking" -> Split into: config schema, logging functions, metrics collection, output formatting
- "Refactor the codebase" -> Split into one task per module or pattern

### Complexity signals — when to split further

A task may look small in description but be expensive in context. Watch for:

- **Touches more than 3-4 files** — the agent needs to read and understand each one
- **Requires cross-module understanding** — e.g., "refactor how auth works across the API, middleware, and database layers"
- **Combines implementation and testing** — consider separating the implementation task from its test task
- **Needs broad codebase exploration** — if the agent must search widely to understand where to make changes, the exploration alone may consume most of the context window

**Rule of thumb:** If you cannot describe the change in 2-3 sentences, split it.

---

## Task Ordering: Dependencies First

Tasks are executed sequentially in the order they appear. Earlier tasks must NOT depend on later ones.

**Correct order:**
0. OPTIONAL: Research
1. Configuration and schema changes
2. Core logic and data processing
3. Higher-level functions that use core logic
4. Tests and validation
5. Documentation

**Wrong order:**
1. Evaluation function (needs data loader that doesn't exist yet)
2. Data loader implementation

---

## Steps: Must Be Verifiable

Each step must be something the agent can CHECK, not something vague.

**Good steps (verifiable):**
- "Add `patience` parameter to `src/config.py` with default value 5"
- "Implement `load_dataset()` function in `src/data.py` that returns a DataFrame"
- "Log validation loss after each epoch to `metrics.json`"
- "Raise `ValueError` when input shape doesn't match expected"
- "All tests pass"

**Bad steps (vague):**
- "Works correctly"
- "Handles edge cases"
- "Good performance"
- "Clean implementation"

**Always include appropriate verification:**
```
"Typecheck passes"
"All tests pass"
```

---

## Example Conversion

### Input PRD:

```markdown
# PRD: Early Stopping for Training Pipeline

## 1. Introduction/Overview
The training pipeline currently runs for a fixed number of epochs, wasting compute when the model has converged. This PRD covers adding early stopping based on validation loss.

## 2. Goals
- Reduce training time by stopping when validation loss plateaus
- Save best model checkpoint automatically
- Make patience and threshold configurable

## 4. User Stories

- **Title:** Add early stopping configuration
- **Priority:** P1
- **Description:** As a researcher, I need configurable early stopping parameters
- **Acceptance Criteria:**
    - [ ] Add `patience` parameter (default: 5)
    - [ ] Add `min_delta` parameter (default: 0.001)
    - [ ] Parameters loadable from config file

- **Title:** Implement early stopping logic
- **Priority:** P1
- **Description:** As a researcher, I want training to stop when validation loss plateaus
- **Acceptance Criteria:**
    - [ ] Track validation loss history
    - [ ] Stop training when no improvement for `patience` epochs
    - [ ] Log early stopping event with final metrics

- **Title:** Save best model checkpoint
- **Priority:** P1
- **Description:** As a researcher, I want the best model saved automatically
- **Acceptance Criteria:**
    - [ ] Save checkpoint when validation loss improves
    - [ ] Include epoch number and metrics in checkpoint
    - [ ] Overwrite previous best checkpoint

- **Title:** Add tests for early stopping
- **Priority:** P2
- **Description:** As a developer, I want tests to verify early stopping behavior
- **Acceptance Criteria:**
    - [ ] Test that training stops after patience epochs
    - [ ] Test that best checkpoint is saved correctly
    - [ ] Test edge cases (immediate stop, never stop)

## 6. Non-Goals
- No learning rate scheduling
- No multi-metric support
```

### Output (`SPEC.md`):

````markdown
# Project Plan

## Overview
Add early stopping to the training pipeline based on validation loss to reduce compute waste when the model has converged.

**Reference:** `PRD.md`

---

## Task List

```json
[
  {
    "category": "setup",
    "id": "US-1",
    "title": "Add early stopping configuration",
    "description": "As a researcher, I need configurable early stopping parameters",
    "steps": [
      "Add patience parameter to src/config.py (default: 5)",
      "Add min_delta parameter to src/config.py (default: 0.001)",
      "Ensure parameters are loadable from config file",
      "Typecheck passes"
    ],
    "passes": false
  },
  {
    "category": "feature",
    "id": "US-2",
    "title": "Implement early stopping logic",
    "description": "As a researcher, I want training to stop when validation loss plateaus",
    "steps": [
      "Create EarlyStopping class in src/early_stopping.py with patience and min_delta parameters",
      "Track validation loss history across epochs",
      "Return stop signal when no improvement for patience epochs",
      "Log early stopping event with epoch number and final metrics",
      "Typecheck passes"
    ],
    "passes": false
  },
  {
    "category": "feature",
    "id": "US-3",
    "title": "Save best model checkpoint",
    "description": "As a researcher, I want the best model saved automatically",
    "steps": [
      "Save checkpoint to checkpoints/ directory when validation loss improves",
      "Include epoch number, validation loss, and config in checkpoint metadata",
      "Overwrite previous best checkpoint on improvement",
      "Typecheck passes"
    ],
    "passes": false
  },
  {
    "category": "testing",
    "id": "US-4",
    "title": "Add tests for early stopping",
    "description": "As a developer, I want tests to verify early stopping behavior",
    "steps": [
      "Test training stops after patience epochs without improvement",
      "Test best checkpoint saved when loss improves",
      "Test edge case: stops immediately if first epoch is best",
      "Test edge case: runs full epochs if always improving",
      "All tests pass"
    ],
    "passes": false
  }
]
```

---

## Notes

**Linting:**
```bash
uv run ruff check .
```

**Type checking:**
```bash
uv run ty src/
```

**Tests:**
```bash
uv run pytest tests/
```

**Run:**
```bash
uv run python train.py --config config.yaml
```
````

---

## Final Checklist Before Saving

Before writing SPEC.md, verify:

- [ ] Source PRD (or user input) has been fully read
- [ ] Each task has `id`, `title`, and `description` from PRD user stories
- [ ] Each task is sovereign — solvable by a fresh agent with no memory of prior sessions
- [ ] Each task is completable in one context window (small enough)
- [ ] Tasks are ordered by priority (if same priority, keep the order from the PRD)
- [ ] No task depends on a later task
- [ ] Every task ends with appropriate verification step
- [ ] All steps are verifiable (not vague)
- [ ] Steps include file paths where applicable
- [ ] Overview accurately summarizes the PRD
- [ ] Reference points to correct PRD file
- [ ] Notes section includes project-specific commands discovered from the codebase
- [ ] JSON is syntactically valid (no trailing commas, all strings quoted, special chars escaped)
