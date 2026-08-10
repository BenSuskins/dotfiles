---
name: workboard-status
description: Post a status update to the user's Workboard after finishing a coding work session. Use when the user asks to "update the workboard", "log this work", or at the end of a substantial coding session in any repo. Resolves which Workboard project the work belongs to (monorepo-aware), posts what was done, links new PRs, and refreshes the project's AI summary.
---

# Workboard: post a status update

You are finishing a work session in a repository. Record the work on the user's
Workboard via the `workboard` MCP server (tools: `find_project`, `get_project`,
`add_update`, `add_link`, `upsert_summary`, `update_project`, `add_task`).

If no `workboard` MCP tools are available, tell the user to connect it:
`claude mcp add --transport http workboard http://localhost:8787/mcp`

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

Call `add_update` with `agent_name` set to your agent identity. Body: 2–5
sentences of markdown covering **what changed, why, current state (merged / in
review / needs X), and anything blocking**. Write for the user reading their
dashboard on Monday morning, not a commit log.

## Step 4 — Refresh the summary

Call `get_project` for full context (goal, tasks, other recent updates, linked
PR/ticket status), then `upsert_summary`: 2–6 sentences synthesizing the
project's **overall** state — not just this session. Lead with where the
project stands against its goal, then in-flight work, then risks/blockers.

## Step 5 — Housekeeping (only when warranted)

- Work revealed a follow-up? `add_task`.
- Project is now genuinely blocked / unblocked / done? `update_project` with the
  new `status` (and `health` if it changed). Don't churn status speculatively.
- Something needs the **user's** intervention and you can't fix it (failing CI
  you can't repair, a decision needed, a blocked dependency)? `raise_warning`
  with a concrete `suggested_action` — it appears prominently on the dashboard
  until resolved. If a warning you raised earlier no longer applies (check
  `get_project`'s `openWarnings`), `resolve_warning` it.
