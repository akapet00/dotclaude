---
name: scholar
description: "Search and analyze academic papers via Semantic Scholar API. Triggers on: /scholar command or when user explicitly requests academic paper search."
disable-model-invocation: true
---

Search, analyze, and export academic papers using the Semantic Scholar API.

Before acting, read the relevant doc for the task:
- Paper search/details/citations/references/recommendations: `docs/papers.md`
- Author search/details/top papers/duplicates: `docs/authors.md`
- BibTeX export and paper tracking: `docs/export.md`

Run scripts from this skill's directory: `cd ~/.claude/skills/semantic-scholar && DISABLE_SSL_VERIFY=1 uv run scripts/<name>.py <subcommand> [args]`
