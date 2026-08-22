---
name: workboard-digest
description: Write a cross-project digest ("where everything stands") to the user's Workboard. Use when the user asks for a daily/weekly digest, a status briefing across their projects, or on a schedule. Pulls all project activity from the workboard MCP server, synthesizes a briefing, and saves it to the Reports page.
---

# Workboard: write a digest

Produce the briefing the user would want first thing in the morning: where every
piece of their work stands, what moved, and what deserves attention today.

Requires the `workboard` MCP server (tools: `get_activity`, `list_projects`,
`refresh_project`, `save_report`, `list_reports`). If unavailable, tell the user
to connect it: `claude mcp add --transport http workboard http://localhost:8787/mcp`

## Step 1 — Gather

1. `list_reports` with `kind: "digest"`, limit 1 — note when the last digest ran
   so you cover the gap since then (default to 7 days if none).
2. `get_activity` with `since` set to the last digest's timestamp. This returns
   every project with its latest summary, updates in the window, open tasks, and
   cached PR/Jira/doc status.
3. If a project's snapshot data looks stale and matters to the story, call
   `refresh_project` for it and re-check.

## Step 2 — Write

Markdown, scannable in under a minute. Structure:

- Title: `## Digest — <date>` (daily) or `## Weekly digest — w/c <date>`.
- **What moved**: 1–2 sentences per project that had activity — lead with
  outcome (shipped/merged/decided), not effort. Use PR/ticket state from the
  snapshots (e.g. "cutover PR approved, unmerged for 3 days"). Updates carry an
  `author` (`user` vs `agent:<name>`): say who did it when it matters — the
  user tracking their own week is part of the point.
- **Quiet**: one line listing projects with no activity, if any. Flag anything
  active-but-silent for over a week.
- **Suggested focus**: 2–4 numbered, concrete next actions ranked by impact.
  "Land #4821" beats "keep making progress on payments". Queued-but-unclaimed
  tasks (visible in updates/summaries) are fair game here.

Ground every claim in the activity data. No filler, no praise, no restating
project descriptions the user already knows.

## Step 3 — Save

`save_report` with `kind: "digest"`, your `agent_name`, and the markdown body.
Confirm to the user with a one-line recap and mention it's on the Reports page.
