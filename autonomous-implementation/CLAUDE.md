# CLAUDE.md

<!-- Project-specific instructions for the AI agent.
     
     How it works?
     Claude Code reads this file automatically at the start of every session. In
     the autonomous loop, each iteration gets a fresh context window with no
     memory of prior sessions. This file is the primary way you (the human)
     communicate project-specific knowledge to the agent.

     Who writes the file?
     You do. Not the agent. ACTIVITY.md and commit history are where the agent
     logs what it did. CLAUDE.md is where you tell the agent how to behave.

     How to populate it?
     Seed it before the first run with what you already know (stack, commands,
     conventions). This prevents the agent from wasting its first iteration
     guessing how to build and test your project.

     For corrections observed over time (recurring mistakes, antipatterns), use
     accompanying PATTERNS.md file.

     Keep it concise. Every token here is loaded into every session's context. -->

## Project

<!-- One or two sentences: what this project is and what it does. -->

[Describe the project briefly]

## Stack

<!-- Languages, frameworks, key libraries. Helps the agent make correct import
     and dependency decisions without exploring the codebase. -->

- Language: [e.g., Python 3.12]
- Framework: [e.g., FastAPI, PyTorch]
- Key libraries: [e.g., Pydantic, SQLAlchemy, pytest]
- Package manager: [e.g., uv, pip, poetry]

## Commands

<!-- Exact commands the agent should use for build, test, lint, and run. These
     are the backpressure gates — the agent runs these after making changes and
     must fix failures before committing. If the agent doesn't know the right
     commands, it will guess (often wrong) or skip validation entirely. Spell
     them out. -->

- Install: `[e.g., uv sync]`
- Build: `[e.g., uv run python -m build]`
- Test: `[e.g., uv run pytest]`
- Test (single): `[e.g., uv run pytest tests/test_foo.py::test_bar -x]`
- Lint: `[e.g., uv run ruff check .]`
- Format: `[e.g., uv run ruff format .]`
- Type check: `[e.g., uv run mypy src/]`

## Structure

<!-- Key directories and where things go. Prevents the agent from creating
     files in the wrong location or missing existing code. Only include paths
     that are non-obvious or critical. -->

```
src/      # Source code
tests/    # Tests mirror src/ structure
docs/     # Documentation
```

## Conventions

<!-- Project-specific rules the agent should follow. Be specific and actionable:
       - "Use Zod for all runtime validation, not manual checks"
       - "Import directly from source files, never from index.ts barrels"
       - "All API responses use the ApiResponse wrapper from src/types"
     Avoid vague entries like "write clean code" or "follow best practices". -->

- [Convention 1]
- [Convention 2]
