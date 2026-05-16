---
name: scholar
description: "Searches and analyzes academic papers via Semantic Scholar API. Use when the user asks about papers, authors, citations, or related literature AND no semantic-scholar MCP server tools are available in the current session. Also invoked on `/scholar` or `scholar`."
---

Search, analyze, and export academic papers using the Semantic Scholar API.

Before acting, read the relevant doc for the task:
- Paper search/details/citations/references/recommendations: `docs/PAPERS.md`
- Author search/details/top papers/duplicates: `docs/AUTHORS.md`
- BibTeX export and paper tracking: `docs/EXPORT.md`

Run scripts from this skill's directory: `DISABLE_SSL_VERIFY=1 uv run scripts/<name>.py <subcommand> [args]`
