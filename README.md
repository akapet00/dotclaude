# dotclaude

## `.claude/`

Goes to `~/.claude/`. Applies to every Claude Code session on the machine.

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Global instructions applied to every project |
| `TROPES.md` | AI writing patterns to avoid ([source](https://tropes.fyi/tropes-md) by [ossama.is](https://ossama.is)) |
| `settings.json` | Claude Code settings |
| `statusline-command.sh` | Custom status line showing model and context usage |
| `skills/` | Skills available across all projects |

### Skills

Each skill uses `disable-model-invocation: true`, so it only fires when you type the slash command or the skill name verbatim. The one exception is `scholar`, which also auto-invokes when no Semantic Scholar MCP server is available in the session.

| Skill | Purpose |
|-------|---------|
| `/brainstorm` | Interview-driven design or planning conversation |
| `/research` | Literature + codebase + interview research, outputs `RESEARCH.md` |
| `/to-tasks` | Convert `PLAN.md` (and optional `RESEARCH.md`) into `TASKS.md` for the autonomous loop |
| `/handover` | Compact the current conversation into `HANDOVER.md` for a fresh session |
| `/scholar` | Semantic Scholar API wrapper (paper search, author analysis, BibTeX export) |

## `autonomous-implementation/`

A coding-agent loop that completes one task per Claude session, with a fresh context each iteration. Drop the contents into a project root.

Based on the original idea of the Ralph Wiggum loop by [Geoffrey Huntley](https://ghuntley.com/ralph/).

### Contents

| File | Purpose |
|------|---------|
| `loop.sh` | The loop driver which runs N iterations of `claude -p` |
| `PROMPT.md` | Per-iteration instructions for the agent |
| `CLAUDE.md` | Project-specific stack, commands, and conventions (you fill this in) |
| `PATTERNS.md` | Human-curated corrections accumulated over time |
| `TASKS.md` | Task list (placeholder until `/to-tasks` generates it) |
| `ACTIVITY.md` | Session log appended by the agent each iteration |
| `.claude/settings.local.json` | Minimal sandbox config (writes confined to the working directory) |

### Workflow

```
PLAN.md
    │
    ▼
/to-tasks  →  TASKS.md
    │
    ▼
./loop.sh N   (each iteration: read task, execute, verify, log, commit)
```

1. Write a `PLAN.md` in the project root.
2. Run `/to-tasks` to convert it to `TASKS.md`.
3. Run `./loop.sh <iterations>` from the project root.

Each iteration spawns a fresh Claude session that:

- Reads `CLAUDE.md`, `TASKS.md`, `ACTIVITY.md`, `PATTERNS.md`.
- Finds the first task in `TASKS.md` where `**Passes:** false`.
- Executes it, runs verification, appends to `ACTIVITY.md`, commits.
- Terminates.

The loop stops when all tasks pass or the iteration count is exhausted.

### Running the loop

```bash
# from project root
./loop.sh 5     # five iterations, one task each
```

Requires the `claude` CLI, `git`, and `jq` (optional, for token usage stats). Runs with `--dangerously-skip-permissions` for autonomous operation.

### Sandboxing

The included `.claude/settings.local.json` enables Claude Code's native sandbox:

```json
{
  "sandbox": {
    "enabled": true
  }
}
```

This confines all bash writes to the current working directory. Reads remain system-wide; new network domains trigger first-access prompts. See [Claude Code sandboxing docs](https://code.claude.com/docs/en/sandboxing) for the full schema.

For stronger isolation, run the loop inside a Docker container, dev container, or cloud sandbox ([E2B](https://e2b.dev), [Fly Machines](https://fly.io/docs/machines/)). At minimum, run on a dedicated branch and review diffs before merging.

## License

MIT
