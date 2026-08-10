---
name: workboard-triage
description: Triage the user's Workboard — find stale projects, blockers, risks, and overdue work, and save a prioritized action list to the Reports page. Use when the user asks "what needs attention?", "what's blocked?", "triage my projects", or on a schedule.
---

# Workboard: triage

Find what's rotting. The output is a short, prioritized list of things that need
the user's intervention — not a status report (that's `workboard-digest`).

Requires the `workboard` MCP server (tools: `get_activity`, `get_project`,
`save_report`, `raise_warning`, `resolve_warning`). If unavailable, tell the
user to connect it:
`claude mcp add --transport http workboard http://localhost:8787/mcp`

## Step 1 — Scan

Call `get_activity` (default window is fine). For each project check, in order
of severity:

1. **Open warnings**: `openWarnings` on each project — these are already-flagged
   problems. Weigh how long they've been open; verify each still holds (if it
   clearly no longer does, `resolve_warning` with a note).
2. **Blocked**: `status: blocked` — how long? Is the unblock path named anywhere
   in the updates?
3. **Off track / at risk**: `health: red` or `amber`.
4. **Stale**: status `active` but no updates in the window and `lastActivityAt`
   over a week old.
5. **Rotting or red PRs**: snapshot shows an *open* PR with `ciStatus: failing`,
   approved-but-unmerged for days, in review with no movement, or a long-lived
   draft. Ignore closed/merged PRs — they carry no CI status by design.
6. **Overdue / stuck tasks**: `dueDate` in the past, or `in_progress` tasks on
   otherwise-silent projects.
7. **Contradictions**: e.g. health green but the latest update describes a
   blocker; summary far older than recent activity.

For 🔴 findings the user must see even without opening the triage report, also
`raise_warning` on the affected project (skip if an equivalent warning is
already open — never duplicate).

Use `get_project` on anything that needs a closer look before judging it.

## Step 2 — Write

Markdown. Title `## Triage — <date>`. One bullet per finding, most severe first,
each with severity emoji (🔴 needs intervention now / 🟡 needs attention this
week / 🟢 fine), the **project name in bold**, a one-line diagnosis with concrete
evidence (dates, PR numbers), and *a suggested action in italics* that the user
could do in under 30 minutes.

Close with one 🟢 line naming the projects that are healthy, so the user knows
they were checked — silence is not a verdict. If nothing needs attention at all,
say exactly that in one line; never invent findings.

## Step 3 — Save

`save_report` with `kind: "triage"`, your `agent_name`, and the body. Give the
user the 🔴 items inline in your reply.
