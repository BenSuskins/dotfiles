---
name: workboard-status
description: Post a status update to the user's Workboard after finishing a coding work session. Use when the user asks to "update the workboard", "log this work", or at the end of a substantial coding session in any repo. Resolves which Workboard project the work belongs to (monorepo-aware), posts what was done, links new PRs, and refreshes the project's AI summary.
---

# Workboard: post a status update

You are finishing a work session in a repository. Record the work on the user's
Workboard via the `workboard` MCP server (tools: `find_project`, `get_project`,
`add_post`, `add_link`, `upsert_summary`, `update_project`, `add_task`,
`add_task_comment`, `list_answers`, `ask_question`, `add_comment`).

If no `workboard` MCP tools are available, tell the user to connect it:
`claude mcp add --transport http workboard http://localhost:8787/mcp`

## Step 0 — Read your replies first

Call `list_answers` with your `agent_name`. It returns comments the user left on
your posts and answers to your questions. Address anything waiting before you
start new work — a reply may change what you were about to do. Reply in the
thread with `add_comment` when you act on one.

## Step 1 — Resolve the project (monorepo-aware)

This user works in platform monorepos: **one repo hosts many projects, so never
assume repo = project.** Gather what you know and call `find_project`:

- `repo`: from `git remote get-url origin` (owner/name)
- `branch`: from `git branch --show-current`
- `pr_number`: if you created or worked on a PR this session
- `paths`: representative changed paths from `git diff --name-only main...HEAD` (or the session's edits)
- `labels`: PR labels if known

Interpret the result:
- **One match** → use it.
- **Multiple matches** → ask the user which project this work belongs to.
- **No match** → ask whether to register it with `create_project` (offer a name
  and description inferred from the work), or attach to an existing project via
  `list_projects`.

## Step 2 — Link new artifacts

If this session created a PR that isn't in the project's links (check
`get_project`), attach it with `add_link` (the PR URL is enough — kind is
inferred).

## Step 3 — Post the update

Call `add_post` with `agent_name` set to your agent identity.

Give it a `title` that carries the takeaway on its own — the board shows the
title and an excerpt, and the full post has its own page.

Write the `body` as a document, not a commit log: what changed, why, where it
stands (merged / in review / needs X), and anything blocking. Use markdown
properly — headings when there is more than one topic, a table when you are
reporting state across several things, and a ```mermaid diagram when the shape
of the work is clearer drawn than described. Write for the user reading their
dashboard on Monday morning.

## Step 4 — Refresh the summary

Call `get_project` for full context (goal, tasks, other recent updates, linked
PR/ticket status), then `upsert_summary`: 2–6 sentences synthesizing the
project's **overall** state — not just this session. Lead with where the
project stands against its goal, then in-flight work, then risks/blockers.

## Step 5 — Housekeeping (only when warranted)

- Work revealed a follow-up? `add_task`.
- Worked a task this session? `add_task_comment` on it and move it with
  `update_task` — `done` when it shipped, `blocked` when you got stuck (that
  keeps your name on it, takes it out of the queue, and puts it in the board's
  **Blocked** column). Say in the comment what you need to get moving; the
  user's reply comes back through `list_answers` under `taskReplies`.
- Project is now genuinely blocked / unblocked / done? `update_project` with the
  new `status` (and `health` if it changed). Don't churn status speculatively.
- Need a **decision** from the user — which approach, which name, whether to
  proceed? `ask_question` with the options and your recommendation, so a
  one-word reply unblocks you. Their answer reaches you through `list_answers`.
- Something is **broken** and needs the user, and you can't fix it (failing CI
  you can't repair, a blocked dependency)? `raise_warning`
  with a concrete `suggested_action` — it appears prominently on the dashboard
  until resolved. If a warning you raised earlier no longer applies (check
  `get_project`'s `openWarnings`), `resolve_warning` it.
