---
name: workboard-queue
description: Run the Workboard agent task queue for one project as a parallel dispatcher — poll for queued tasks, claim each, plan it, implement it in its own git worktree, and raise a draft PR. Use when the user says "run the queue", "drain the backlog", "work the queued tasks", or names this skill with a project name.
---

# Workboard: run the agent task queue

You are a **dispatcher**, not an implementer. You own the loop: pull tasks from
the project's queue, and for each one run the pipeline — plan → worktree →
implement → draft PR → bookkeeping. Tasks are independent; run several pipelines
at once. Your own context stays small: never implement anything yourself.

Requires the `workboard` MCP server (`find_project`, `get_project`,
`list_queued_tasks`, `claim_task`, `add_link`, `add_post`, `update_task`,
`add_task_comment`, `list_task_comments`, `list_answers`, `ask_question`,
`raise_warning`) plus the Task tool for subagents. If unavailable, tell the
user to connect it: `claude mcp add --transport http workboard http://localhost:8787/mcp`

## Parameters

- `project` (required): project name/slug on the Workboard.
- `max_tasks`: stop after this many completed pipelines. Default: run until interrupted.
- `max_concurrent`: pipelines running at once. Default 3.
- `poll_seconds`: queue re-check interval. Default 300.

## Setup (once)

1. Resolve the project: `get_project`. Note its goal/summary (plan subagents need it).
2. Verify you're in the right checkout: the project's repo link (`external_id`)
   must match `git remote get-url origin`. If not, stop and tell the user —
   never guess a repo for someone else's task.
3. Confirm `gh auth status` works; PR creation depends on it.

## The loop

```
while running:
  queued = list_queued_tasks(project)
  for task in queued while slots free:
    claim_task(task.id, your_agent_name)     # atomic — losers get an error, skip those
    start pipeline(task)                     # subagents, see below
  sleep(poll_seconds)
```

Announce state changes in one line each ("claimed #12 · 2 running, 1 done").
Never let the loop die on a single pipeline's failure — catch, record, continue.

## Pipeline (per task)

**0. Read the thread.** `list_task_comments(task_id)` before planning. The
description is the spec as filed; the thread is everything said since, including
answers to a question a previous run left on the task.

**1. Plan (subagent, main checkout, read-only).** Dispatch a research/explore
subagent with: the task title, **description**, and thread (the description is
the spec — if it is empty or too thin to act on, leave the question with
`add_task_comment` and move the task to `blocked` with `update_task`, then skip
it; the user's answer comes back through `list_answers` under `taskReplies` on a
later run), plus the project goal/summary, and instruction
to produce an implementation plan — approach, files to touch, test strategy,
risks. It must not edit files. Return the plan as text.

**2. Worktree.** Isolate the work so parallel pipelines can't collide:

```bash
git worktree add "../$(basename $PWD)-worktrees/task-<id>-<short-slug>" \
  -b workboard/task-<id>-<short-slug>
```

If the branch name exists, the task was partially run before — pick a fresh
suffix and note it. Record the worktree path; the implementer works ONLY there.

**3. Implement (subagent, inside the worktree).** Dispatch a general-purpose
subagent told to: `cd` into the worktree path, implement the plan, follow the
repo's conventions, keep changes scoped to the task, run lint/typecheck/tests
and make them pass, then commit (conventional message referencing the task)
and push the branch. It must not touch the main checkout, must not push to
main, and returns a 3–6 sentence summary of what changed plus test results.

**4. Draft PR (you, from the worktree path).**

```bash
git -C <worktree-path> gh pr create --draft ...
```

Title: the task title. Body: task id, what changed (from the implementer),
test status, `Part of <project> queue`. Base: the repo's default branch.

**5. Bookkeeping (workboard).**
- `add_link` with the PR URL (kind inferred).
- `add_post` — the check-in. Title carries the outcome ("Task 42: dual-write
  shipped, in review"); body covers what changed, the PR, and test status.
  Author = your agent name.
- `add_task_comment` — the same outcome on the task itself, so it reads in
  place when someone opens the card.
- `update_task` → `done`.
- Leave the worktree in place for review; it merges like any PR branch.

## Failure handling

- Implementer fails or tests stay red: do not mark done. Remove the worktree,
  delete the pushed branch if any, `add_task_comment` saying exactly what failed
  and what you would need, and `update_task` → `blocked`. That keeps your name on
  the task, drops it out of the queue so nobody re-picks a known-broken job, and
  lands it in the board's **Blocked** column where the user will see it. Move on.
  Use `todo` instead only when the failure is transient and the task is genuinely
  fine to hand to the next agent — that releases your claim and re-queues it. If
  the same task fails twice, `raise_warning` with the error instead of retrying.
- Claim collision (`already claimed`): another dispatcher took it — skip silently.
- Subagent hangs beyond ~15 minutes: abandon it, treat as failure above.

## Stopping

Stop when `max_tasks` completed pipelines finish, or the user interrupts.
On exit, report: completed task ids + PR links, still-running pipelines,
and current queue depth. Do not remove worktrees with open PRs.
