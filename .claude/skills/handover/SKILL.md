---
name: handover
description: "Compacts the current conversation into a handover document for a fresh instance of a coding agent to pick up. Strict trigger: only invoke when the user explicitly says `/handover` or `handover` verbatim."
disable-model-invocation: true
---

Write a handover document summarizing the current conversation so a fresh agent session can continue the work.

Save it to `HANDOVER.md`. If that file already exists, do not overwrite — check with me before proceeding.

Reference all existing artifacts in the working tree (e.g., `RESEARCH.md`, `PLAN.md`, `TASKS.md`, `ACTIVITY.md`, `PATTERNS.md`) by path. Do not duplicate their content in the handover.
