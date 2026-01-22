---
name: prd
description: "Generate a Product Requirements Document (PRD) for a new feature, task, or experiment. Use during the planning, starting a new project, refactoring, code testing, or simply when asked to create a PRD. Triggers on: create a prd, write prd for, plan this feature, plan the experiment, plan the refactoring, write requirements for, spec out, etc."
---

# PRD Generator

Create detailed PRD that is clear, actionable, and suitable for implementation.

---

## The Job

1. Receive a task description from the user
2. Ask 3 to 5 essential clarifying questions (with lettered options)
3. Generate a structured PRD based on answers
4. Save to `tasks/prd-[feature-name].md`

**Important:**
- Do NOT implement code
- Keep your focus on planning, structure, and evaluation

---

## Step 1: Clarifying Questions

Ask only critical questions where the initial prompt is ambiguous. Focus on:

- **Objective:** What question are we answering?
- **Methodology:** What type of approach is expected?
- **Artifacts:** What outputs are required?
- **Evaluation:** How will results be assessed?
- **Constraints:** Time, compute, data, or tooling limits

**Example Questions Format (Adjust a Set of Questions for a Specific Problem):**

```
1. What is the primary objective of this task?
  A. Explore feasibility / proof-of-concept
  B. Improve an existing model or method
  C. Benchmark against baselines
  D. Refactor / stabilize code
  E. Write / update and run tests
  F. Other: [please specify]

2. What is the expected maturity level?
  A. Exploratory / experimental
  B. Reproducible research prototype
  C. Pre-production / handoff-ready
  D. Production-grade quality

3. What type of work is involved?
  A. Model development or experimentation
  B. Data processing / feature engineering
  C. Evaluation, metrics, or benchmarking
  D. Refactoring, testing, or infrastructure
  E. Combination of the above

4. How should success be evaluated?
  A. Quantitative metrics (e.g., accuracy, RMSE, F1)
  B. Qualitative analysis or visualization
  C. Comparison to baselines
  D. Code quality, tests, and reproducibility
  E. Other: [please specify]
```

This lets users respond with "1A, 2C, 3B" for quick iteration.

---

## Step 2: PRD Structure

Generate the PRD with these sections:

### 1. Introduction/Overview

Brief description of the feature and the problem it solves. Provide context. Why this is done / why it matters. What gap / limitation / hypothesis it addresses. Avoid marketing language. Be factual and concise.

### 2. Goals

Concrete, testable objectives. Use bullet points. Avoid vague goals like "improve performance" without criteria.

**Example:**
- Reduce validation RMSE by around 10 percent compared to baseline
- Establish whether method A statistically outperforms method B
- Refactor pipeline to enable deterministic reruns
- Test the code so that the coverage is at least 80 percent

### 3. Research Questions / Hypotheses (Optional)
For purely research-focused tasks. List explicit research questions or hypotheses.

**Example:**
- **RQ-1** Does adding temporal smoothing improve robustness under noise?
- **H-1:** Adding feature group A improves predictive performance under metric M.

### 4. User Stories

Atomic work unit written in markdown format that should be **small enough to complete in one focused session**:
```markdown
- **Title:** Short descriptive name
- **Priority:** P0 (Critical) | P1 (High) | P2 (Medium) | P3 (Low)
- **Description:** "As a [user/researcher/tester], I want [feature/experiment/refactor/test/analysis] so that [benefit]"
- **Acceptance Criteria:** (choose template based on work type)
```

**Acceptance Criteria Templates:**

Template A: ML/AI Research
```markdown
- [ ] Inputs, outputs, and assumptions documented
- [ ] Results reproducible under fixed random seed(s)
- [ ] Evaluation metric(s) computed and logged
- [ ] Artifacts saved (models, metrics, plots, reports)
- [ ] Experiment tracked (config, hyperparams, results)
```

Template B: Software Development
```markdown
- [ ] Feature works as specified in description
- [ ] Unit tests written and passing
- [ ] Edge cases handled appropriately
- [ ] Code follows project style/linting rules
- [ ] Documentation updated if needed
```

Template C: Refactoring / Testing
```markdown
- [ ] Existing behavior preserved (no regressions)
- [ ] Test coverage meets target (specify %)
- [ ] All tests pass
- [ ] Code complexity reduced or maintained
- [ ] Type hints added/updated where applicable
```

**Important:** Acceptance criteria must be **verifiable**, not subjective.

### 5. Functional Requirements
Explicit, numbered requirements describing **what the code must solve**.

Examples:
- FR-1: Load dataset version `vX.Y` with deterministic preprocessing
- FR-2: Support running experiments via configuration files
- FR-3: Log metrics per epoch to structured output (CSV/JSON)
- FR-4: Enable ablation of feature groups via config flags

### 6. Non-Goals (Out of Scope)
What this feature will NOT include. Critical for managing scope.

Examples:
- No hyperparameter auto-tuning
- No deployment or serving considerations
- No UI or visualization dashboard
- No guarantees of state-of-the-art performance

This is **CRITICAL** for avoiding scope creep.

### 7. Dependencies & Risks

**Dependencies:**
- External systems, APIs, or services required
- Data availability or access requirements
- Other teams or components this work depends on
- Libraries, frameworks, or tool versions

**Risks & Mitigations:**
- Technical risks and how to address them
- Assumptions that might prove incorrect
- Potential blockers and contingency plans

### 8. Technical Considerations (Optional)
- Known constraints or dependencies
- Integration points with existing systems
- Performance requirements

### 9. Success Metrics
How will success be measured?

May include:
- Quantitative metrics (accuracy, AUC, RMSE, latency, memory)
- Statistical tests or confidence intervals
- Qualitative inspection (plots, embeddings, examples)
- Engineering metrics (runtime, code coverage, linting)

### 10. Open Questions
Remaining questions or areas needing clarification.

---

## Example PRDs

### Example 1: ML/AI Research (Single User Story)

```markdown
# PRD: Early Stopping for Training Pipeline

## 1. Introduction/Overview
The training pipeline currently runs for a fixed number of epochs, wasting compute when the model has converged or is overfitting. This PRD covers adding early stopping based on validation loss to reduce training time and prevent overfitting.

## 2. Goals
- Reduce average training time by 20-40% on standard benchmarks
- Prevent overfitting by stopping when validation loss stops improving
- Maintain or improve final model performance vs. fixed-epoch training

## 3. Research Questions / Hypotheses (Optional)
- **H-1:** Early stopping with patience=5 produces models within 1% accuracy of full training

## 4. User Stories
- **Title:** Implement early stopping callback
- **Priority:** P1 (High)
- **Description:** "As a researcher, I want training to stop automatically when validation loss plateaus so that I save compute and avoid overfitting"
- **Acceptance Criteria:**
    - [ ] Inputs, outputs, and assumptions documented
    - [ ] Results reproducible under fixed random seed(s)
    - [ ] Validation loss tracked and logged each epoch
    - [ ] Training stops when patience threshold exceeded
    - [ ] Best model checkpoint saved before stopping

## 5. Functional Requirements
- FR-1: Monitor validation loss after each epoch
- FR-2: Support configurable patience parameter (default=5)
- FR-3: Support configurable min_delta for improvement threshold
- FR-4: Save best model checkpoint based on validation loss
- FR-5: Log early stopping event with epoch number and final metrics

## 6. Non-Goals (Out of Scope)
- No learning rate scheduling (separate feature)
- No support for multiple metrics (validation loss only)
- No distributed training considerations

## 7. Dependencies & Risks
**Dependencies:**
- Existing checkpoint saving mechanism
- Validation dataset must be defined in config

**Risks & Mitigations:**
- Risk: Stopping too early on noisy validation loss
- Mitigation: Use smoothed/averaged loss or higher patience

## 8. Technical Considerations (Optional)
- Must integrate with existing training loop without major refactor
- Checkpoint format must remain backward-compatible

## 9. Success Metrics
- Training time reduced by 20%+ on 3 benchmark datasets
- Final accuracy within 1% of fixed-epoch baseline
- No increase in validation loss variance across runs

## 10. Open Questions
- Should we support other metrics besides validation loss?
- What default patience value works best across our datasets?
```

### Example 2: Refactoring (Multiple User Stories)

```markdown
# PRD: Refactor Database Access Layer

## 1. Introduction/Overview
The current database access code is scattered across multiple modules with duplicated queries, no type hints, and minimal test coverage. This refactor consolidates database operations into a repository pattern, improves type safety, and increases test coverage to support future feature development.

## 2. Goals
- Consolidate all database queries into repository classes
- Achieve 80% test coverage on database layer
- Add type hints to all public interfaces
- Reduce code duplication by 50%+

## 3. Research Questions / Hypotheses (Optional)
N/A - this is a refactoring task.

## 4. User Stories

- **Title:** Extract queries into repository pattern
- **Priority:** P1 (High)
- **Description:** "As a developer, I want database queries centralized in repository classes so that I can modify data access logic in one place"
- **Acceptance Criteria:**
    - [ ] Existing behavior preserved (no regressions)
    - [ ] All tests pass
    - [ ] UserRepository, ProjectRepository, TaskRepository created
    - [ ] No raw SQL queries outside repository classes
    - [ ] Type hints added/updated where applicable

- **Title:** Add type hints to public interfaces
- **Priority:** P1 (High)
- **Description:** "As a developer, I want type hints on all repository methods so that I catch type errors at development time"
- **Acceptance Criteria:**
    - [ ] Existing behavior preserved (no regressions)
    - [ ] All tests pass
    - [ ] All public methods have input/output type hints
    - [ ] mypy passes with no errors
    - [ ] Type hints added/updated where applicable

- **Title:** Increase test coverage to 80%
- **Priority:** P2 (Medium)
- **Description:** "As a developer, I want comprehensive tests for the database layer so that I can refactor with confidence"
- **Acceptance Criteria:**
    - [ ] Existing behavior preserved (no regressions)
    - [ ] Test coverage meets target (80%)
    - [ ] All tests pass
    - [ ] Edge cases covered (empty results, connection errors, invalid input)
    - [ ] Tests use fixtures, not production database

- **Title:** Add connection pooling configuration
- **Priority:** P3 (Low)
- **Description:** "As a developer, I want configurable connection pooling so that I can tune database performance per environment"
- **Acceptance Criteria:**
    - [ ] Existing behavior preserved (no regressions)
    - [ ] All tests pass
    - [ ] Pool size configurable via environment variable
    - [ ] Default values work without configuration
    - [ ] Documentation updated if needed

## 5. Functional Requirements
- FR-1: Create base Repository class with common CRUD operations
- FR-2: Implement UserRepository, ProjectRepository, TaskRepository
- FR-3: Add type hints using typing module (no third-party dependencies)
- FR-4: Write unit tests using pytest with fixtures
- FR-5: Support connection pooling with configurable pool size (default=5)

## 6. Non-Goals (Out of Scope)
- No ORM migration (staying with raw SQL + repositories)
- No async/await support
- No caching layer
- No query optimization (separate task)

## 7. Dependencies & Risks
**Dependencies:**
- pytest and pytest-cov for testing
- mypy for type checking
- Existing database schema (no migrations)

**Risks & Mitigations:**
- Risk: Breaking existing functionality during refactor
- Mitigation: Write characterization tests before refactoring
- Risk: Type hints may reveal existing bugs
- Mitigation: Track and address separately, don't block refactor

## 8. Technical Considerations (Optional)
- Must maintain backward compatibility with existing callers
- Repository methods should mirror existing function signatures initially

## 9. Success Metrics
- All existing tests pass after refactor
- Test coverage >= 80% on src/repositories/
- mypy reports 0 errors
- No raw SQL queries outside repository classes

## 10. Open Questions
- Should repositories return domain objects or dicts?
- Do we need a separate integration test suite?
```

---

## Writing Style Guidelines

The reader may be:
- A future version of yourself
- A collaborator
- An AI coding agent


Therefore:
- Be explicit and concrete
- Prefer clarity over brevity
- Avoid unexplained jargon
- Number everything that may be referenced later
- Assume **ZERO** prior context

---

## Output

- **Format:** Markdown (`.md`)
- **Location:** `tasks/`
- **Filename:** `prd-[feature-or-project-or-task-name].md` (kebab-case)

---

## Checklist

Before saving the PRD:

- [ ] Asked clarifying questions with lettered options
- [ ] Incorporated user's answers
- [ ] Stories are small and specific
- [ ] Functional requirements are numbered and unambiguous
- [ ] Non-goals section defines clear boundaries
- [ ] Saved to `prd-[feature-or-project-or-task-name].md`
