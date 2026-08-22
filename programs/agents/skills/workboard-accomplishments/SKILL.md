---
name: workboard-accomplishments
description: Write an accomplishments report ("what shipped") to the user's Workboard — the user's own completed work plus what agents delivered, across all projects. Use when the user asks "what did I ship?", wants a month-end or week-end recap for standups/reviews, or asks for their accomplishment log.
---

# Workboard: write an accomplishments report

Produce the record of shipped work the user can paste into a standup, review, or
status meeting: outcomes, not effort. Cover **both** the user's own work and
what agents delivered on their behalf.

Requires the `workboard` MCP server (tools: `get_activity`, `list_projects`,
`save_report`, `list_reports`). If unavailable, tell the user to connect it:
`claude mcp add --transport http workboard http://localhost:8787/mcp`

## Step 1 — Gather

1. Ask the window if unclear (default: the last 30 days). Note it in the report.
2. `get_activity` with `since` set to the window start. Every non-archived
   project returns its updates (each carries an `author`: the user posts as
   `user`, agents as `agent:<name>`), open tasks, and cached PR state.
3. From PR snapshots count what actually landed: PRs with `merged: true` whose
   `updatedAt` falls inside the window. A merged PR is shipped; a draft is not.
4. Claimed tasks (`claimedBy` set) that reached done are agent deliveries;
   attribute them to the agent name.

## Step 2 — Write

Markdown, grouped by outcome:

- Title: `## Accomplishments — <window>`.
- **Shipped**: one bullet per completed outcome — merged PRs (with repo#number),
  closed milestones, resolved warnings. Lead each bullet with the outcome, then
  the one-line why-it-matters. Attribute agent work inline ("via agent:claude").
- **Delivered by agents**: bullets for claimed-and-completed queue tasks and
  agent-authored updates describing finished work.
- **In flight at window close**: one line per project still carrying open PRs or
  in-progress tasks — no detail, just what remains.

Ground every claim in updates and snapshots. No praise, no filler, no
restating project descriptions. If the window has nothing shipped, say so
plainly and list what got close.

## Step 3 — Save

`save_report` with `kind: "accomplishments"`, your `agent_name`, and the body.
Confirm with a one-line recap and mention it's on the Reports page under
Accomplishments.
