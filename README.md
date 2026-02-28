# .claude

Portable, git-backed configuration for Claude Code. Copy into a project's `.claude/` directory or symlink as needed.

## Where files go

| Source | Destination | Notes |
|--------|-------------|-------|
| `settings.json` | `.claude/settings.json` | Or `.claude/settings.local.json` for local overrides |
| `skills/` | `.claude/skills/` | Skills are loaded automatically by Claude Code |
| `ralph/PROMPT.md` | `PROMPT.md` in project root | Customize the `[placeholders]` for your project |
| `ralph/ralph.sh` | `ralph.sh` in project root | The loop script |
| `ralph/ACTIVITY.md` | `ACTIVITY.md` in project root | Session log — lives next to SPEC.md |

The `ralph/` directory in this repo is only for organization. When deploying to a project, all Ralph files (`ralph.sh`, `PROMPT.md`, `ACTIVITY.md`) go into the **project root** alongside `SPEC.md`.

## Ralph

Ralph is an autonomous agent loop built on top of [Claude Code's headless mode](https://docs.anthropic.com/en/docs/claude-code/cli-usage#headless-mode). It executes a task list (`SPEC.md`) one task at a time, where each task runs in a fresh Claude session with no memory of prior sessions.

Useful when you have a well-defined set of tasks that can be solved iteratively and autonomously — refactoring, test writing, feature implementation from a spec, research pipelines, or any work that can be broken into small, independent steps.

Based on the original concept by [Geoffrey Huntley](https://ghuntley.com/ralph/).

See also:
- [ghuntley.com/ralph](https://ghuntley.com/ralph/) — the original Ralph blog post
- [Claude Code CLI usage](https://docs.anthropic.com/en/docs/claude-code/cli-usage) — `claude -p` (print mode) and `--dangerously-skip-permissions`
- [Claude Code settings](https://docs.anthropic.com/en/docs/claude-code/settings) — permissions, model configuration

## Ralph Workflow

```
User input / PLAN.md
        |
        v
    /prd  -->  PRD.md         (planning — what and why)
        |
        v
    /spec -->  SPEC.md        (tasks — what to build, in what order)
        |
        v
    ./ralph.sh N              (execution — one task per session, N iterations)
```

1. **`/prd`** — Ask clarifying questions, generate `PRD.md`
2. **`/spec`** — Convert `PRD.md` into `SPEC.md` (sovereign tasks with JSON task list)
3. **`./ralph.sh <iterations>`** — Run from project root. Each iteration spawns a fresh Claude session that:
   - Reads `SPEC.md` and `ACTIVITY.md`
   - Completes exactly one task
   - Logs progress to `ACTIVITY.md`
   - Commits changes
   - Terminates

## Running Ralph

```bash
# From project root
./ralph.sh 5     # run 5 iterations (one task each)
```

Requires `claude` CLI, `git`, and optionally `jq` for token stats. Uses `--dangerously-skip-permissions` for autonomous operation — configure `.claude/settings.local.json` with appropriate permissions first.

## License

MIT
