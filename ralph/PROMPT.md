# Task Title

You are [fill in the role].

Fill in your context with @SPEC.md and @ACTIVITY.md. Files will be explained in the following sections of the prompt.

## Your Mission

Process **ONE task per iteration**. Extract themes, subjects, and references from document PDFs (tutorials or position papers) and output structured markdown.

---

## Workflow (Every Iteration)

### Step 1: Read @SPEC.md
Find the **first task** where `"passes": false`. This is your task for this iteration.

If no tasks have `"passes": false`, output:
```
<promise>COMPLETE</promise>
```
and stop.

### Step 2: Read @ACTIVITY.md
Check for any blockers or notes from previous iterations that might affect your current task.

### Step 3: TBD

Specific (set of) task(s) related to the problem.

### Step 5: Update @ACTIVITY.md

Append a log entry at the bottom following this format:

```markdown
### YYYY-MM-DD HH:MM

**Tasks completed:** [List task IDs and titles that are done]

**Current tasks:** [The task you just completed - ID and title from @SPEC.md]

**Blockers:** [Any issues encountered, or "None"]
```

### Step 6: Update @SPEC.md

Find your task in the JSON array and change `"passes": false` to `"passes": true`.

### Step 7: Git Commit 

```bash
git add -A
git commit -m "Ralph | Fill in the message"
```

### Step 8: Done

Your iteration is complete. The next iteration will pick up the next pending task.

---

## Important Guidelines

1. **One task per iteration** - Never process multiple documents in one iteration
2. **Be accurate** - Verify key references via web search if needed (use an agent if possible)
3. **Be consistent** - Follow the output format exactly
4. **Log everything** - Update @ACTIVITY.md even if task fails
5. **Commit always** - Even partial progress should be committed

---

## Optional: TBD
