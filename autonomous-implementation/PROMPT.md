# Loop iteration prompt

You are one iteration in an autonomous loop. Each iteration is a fresh session with no memory of prior runs. Complete **exactly one task** from `TASKS.md`, then terminate.

## Context sources

Read these before touching code:

- `CLAUDE.md` — project stack, commands, conventions.
- `TASKS.md` — full task list.
- `ACTIVITY.md` — log entries from prior sessions (blockers, decisions, notes).
- `PATTERNS.md` — human-curated corrections. Treat as binding.
- The codebase and `git log` — all prior work is committed.

## Workflow

1. **Pick the task.** Find the first task in `TASKS.md` where `**Passes:** false`. That is your task. If none exist, output exactly `<all-tasks-done/>` and stop.
2. **Plan.** Re-read the task's `Description` and `Steps`. Identify the files to change. Use subagents (`Agent` tool) for parallel exploration if multiple files are involved.
3. **Execute.** Work through the steps. Stay strictly in scope — do not fix unrelated issues, refactor outside the task, or start the next task.
4. **Verify.** Run the lint / type-check / test commands from `CLAUDE.md` (whichever apply). Fix failures within the task's scope. Never run verification in a subagent - you must see the failures yourself.
5. **Log.** Append an entry to `ACTIVITY.md` using the template in that file. Required even if the task failed.
6. **Mark passing.** If every step verified, change `**Passes:** false` to `**Passes:** true` for this task in `TASKS.md`. Otherwise leave `false`.
7. **Commit.** `git add -A && git commit -m "loop: T-N — short description"`. Commit even on failure — partial progress and the activity log must be preserved.
8. **Stop.** Do not start the next task. Do not output anything after the commit. Terminate completely.

## Rules

- One task per session. No look-ahead, no carry-over.
- Stay in scope. If a fix needs work outside this task, log it as a blocker and leave `Passes: false`.
- Only mark `Passes: true` if every step is genuinely verified.
- Always update `ACTIVITY.md` and always commit, regardless of outcome.
- Trust the codebase, not memory. Verify prior outputs exist before depending on them.

## Failure protocol

If you can't finish the task:

1. Document what went wrong under **Blockers** in `ACTIVITY.md`.
2. Note what you tried and what the next session should try under **Notes for next session**.
3. Leave `**Passes:** false`.
4. Commit (including partial work and the log).
5. Stop.
