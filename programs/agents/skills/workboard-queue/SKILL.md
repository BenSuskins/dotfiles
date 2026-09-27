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

Each pipeline stage runs as an installed agent profile — `workboard-planner`,
`workboard-implementer`, `workboard-reviewer`, `workboard-verifier`
(`npm run claude:install` in the Workboard repo installs them). The profile
carries that role's constraints and output shape; your prompt supplies the
specifics. If a profile is missing, fall back to a general-purpose subagent with
those constraints stated inline, and say once, in one line, that you are running
without it.

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

**1. Plan (`workboard-planner`, main checkout, read-only).** Dispatch the
planner (Task tool, `subagent_type: workboard-planner`; without the profile, a
general-purpose subagent told explicitly that it must not edit any file) with:
the task title, **description**, and thread (the description is
the spec — if it is empty or too thin to act on, leave the question with
`add_task_comment` and move the task to `blocked` with `update_task`, then skip
it; the user's answer comes back through `list_answers` under `taskReplies` on a
later run), plus the project goal/summary. The profile
already carries the read-only constraint and the plan's shape — approach, files
to touch, test strategy, risks. Return the plan as text.

**2. Worktree.** Isolate the work so parallel pipelines can't collide:

```bash
git worktree add "../$(basename $PWD)-worktrees/task-<id>-<short-slug>" \
  -b workboard/task-<id>-<short-slug>
```

If the branch name exists, the task was partially run before — pick a fresh
suffix and note it. Record the worktree path; the implementer works ONLY there.

**3. Implement (`workboard-implementer`, inside the worktree).** Dispatch the
implementer (`subagent_type: workboard-implementer`) with the worktree path, the
plan from step 1, and the task title and id. The profile already binds it to the
worktree, to the repo's own checks, and to a commit-and-push finish.

Without the profile, dispatch a general-purpose subagent and state the
constraints inline: `cd` into the worktree path, implement the plan, follow the
repo's conventions, keep changes scoped to the task, run **the checks the repo
actually defines** — typecheck and tests, plus lint only if a lint script exists
— and make them pass, then commit (conventional message referencing the task)
and push the branch. It must not touch the main checkout and must not push to
the default branch.

Either way it returns a 3–6 sentence summary of what changed plus test results.

**3.5 Review and verify (subagents, on the worktree).** Nothing else stands
between the implementer and a PR, so run both, in parallel:

- `workboard-reviewer` — give it the worktree path, the task title and
  description, and the implementer's summary. It reads the diff against the
  spec and returns `approve` or `changes requested` with an ordered list.
- `workboard-verifier` — give it the worktree path. It runs the repo's own
  checks itself and returns a pass/fail table. Its result, not the
  implementer's claim, is what "tests pass" means from here on.

Blocking findings or a failed check → one more implementer pass carrying both
reports, then **re-run the verifier** (and the reviewer too, if its findings
were the blocker). That second result is what decides pass or pipeline failure,
and it is the table that goes in the PR body — never the failing first one. If
it still doesn't clear, take the failure path below. Non-blocking review notes
ride into the PR body either way.

**4. Draft PR (you, from the worktree path).**

```bash
git -C <worktree-path> gh pr create --draft ...
```

Title: the task title. Body: task id, what changed (from the implementer), the
verifier's check table from its **last** run, any non-blocking reviewer notes
under **Reviewer notes**, and `Part of <project> queue`. Base: the repo's
default branch.

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

- Implementer fails, review findings stay unaddressed, or checks stay red after
  the second pass: do not mark done. Remove the worktree,
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
