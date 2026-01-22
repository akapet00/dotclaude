---
name: spec
description: "Convert Product Requirement Document (PRD) into a specification document - a set of user stories. Use when you have an existing PRD and need to create a task list for autonomous coding. Triggers on: convert this prd, create plan from prd, create spec from prd, turn prd into tasks."
---

# User-Story Converter

Converts existing PRDs into `SPEC.md` - a structured user-story list that autonomous agents can execute.

---

## The Job

Take a PRD (markdown file from `tasks/` or `/docs` directory) and convert it to `spec.md` in the project root.

---

## Step 1: Locate the Source PRD

Find the PRD to convert:

1. If user specifies a file path, use that
2. Otherwise, look in `tasks/` or `/docs` for files matching `prd-*.md`
3. If multiple PRDs exist, ask which one to convert
4. Read the entire PRD content

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
- Missing User Stories AND Functional Requirements → Stop and ask user to complete the PRD
- Missing Introduction → Use the PRD title/filename as description
- Warn about missing optional sections but continue

---

## Step 3: Extract and Convert Tasks

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

### Conversion Process

For each User Story in the PRD:
1. Extract or generate the ID → becomes `id` (e.g., `US-1`, `US-2`, or use PRD's ID if present)
2. Extract the title → becomes `title`
3. Extract the description → becomes `description`
4. Extract acceptance criteria → becomes `steps` array
5. Determine category from context and priority
6. Add appropriate verification step as final step (see below)
7. Set `passes: false`

**Field Mapping from PRD User Stories:**

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

---

## Step 4: Write SPEC.md

Save the output to `SPEC.md` in the project root.

---

## Output Format

```markdown
# Project Plan

## Overview
[Brief description extracted from PRD Introduction/Overview]

**Reference:** `tasks/prd-[feature-name].md` or `docs/prd-[feature-name].md`

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
# Command to run linting (e.g., uv run ruff check ., npm run lint)
```

**Type checking:**
```bash
# Command to run type checking (e.g., uv run mypy src/, npx tsc --noEmit)
```

**Tests:**
```bash
# Command to run tests (e.g., uv run pytest tests/, npm test)
```

**Run:**
```bash
# Command to run the project (e.g., uv run python main.py, npm start)
```

### Field Definitions

| Field | Type | Description |
|-------|------|-------------|
| `category` | string | One of: `setup`, `feature`, `refactor`, `testing`, `docs` |
| `id` | string | From PRD user story ID, or generate as `US-1`, `US-2`, etc. |
| `title` | string | Exact title from PRD user story |
| `description` | string | The "As a... I want... so that..." from PRD user story |
| `steps` | array | Ordered list derived from acceptance criteria + verification |
| `passes` | boolean | Always `false` initially; Ralph marks `true` when complete |

---

## Task Sizing: The Critical Rule

**Each task must be completable within ONE context window.**

For example, if a fresh Claude instance is spawned per iteration with no memory of previous work, it should be able to do a single task. If a task is too big, the agent runs out of context before finishing and produces broken code.

### Right-sized tasks:
- Add a configuration parameter with validation
- Implement a single function or method
- Write tests for one module
- Add logging to a pipeline stage
- Create a data preprocessing step

### Too big (split these):
- "Build the entire pipeline" → Split into: config, data loading, processing stages, evaluation
- "Add experiment tracking" → Split into: config schema, logging functions, metrics collection, output formatting
- "Refactor the codebase" → Split into one task per module or pattern

**Rule of thumb:** If you cannot describe the change in 2-3 sentences, split it.

---

## Task Ordering: Dependencies First

Tasks execute per priority order. Earlier tasks must NOT depend on later ones.

**Correct order:**
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

### Good steps (verifiable):
- "Add `patience` parameter to config with default value 5"
- "Implement `load_dataset()` function that returns DataFrame"
- "Log validation loss after each epoch to `metrics.json`"
- "Raise ValueError when input shape doesn't match expected"
- "All tests pass"

### Bad steps (vague):
- "Works correctly"
- "Handles edge cases"
- "Good performance"
- "Clean implementation"

### Always include appropriate verification:
```
"Typecheck passes"
"All tests pass"
```

---

## Example Conversion

### Input PRD (`tasks/prd-early-stopping.md`):

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

```markdown
# Project Plan

## Overview
Add early stopping to the training pipeline based on validation loss to reduce compute waste when the model has converged.

**Reference:** `tasks/prd-early-stopping.md`

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
      "Add patience parameter to config (default: 5)",
      "Add min_delta parameter to config (default: 0.001)",
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
      "Create EarlyStopping class with patience and min_delta",
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
      "Save checkpoint when validation loss improves",
      "Include epoch number, validation loss, and config in checkpoint",
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
uv run mypy src/
```

**Tests:**
```bash
uv run pytest tests/
```

**Run:**
```bash
uv run python train.py --config config.yaml
```
```

---

## Checklist Before Saving

Before writing SPEC.md, verify:

- [ ] Source PRD has been fully read
- [ ] Each task has `id`, `title`, and `description` from PRD user stories
- [ ] Each task is completable in one iteration (small enough)
- [ ] Tasks are ordered by priority (if same priority, select in the order written)
- [ ] Every task ends with appropriate verification step
- [ ] All steps are verifiable (not vague)
- [ ] No task depends on a later task
- [ ] Overview accurately summarizes the PRD
- [ ] Reference points to correct PRD file
- [ ] Notes section includes project-specific commands for linting, type checking, tests, and running
