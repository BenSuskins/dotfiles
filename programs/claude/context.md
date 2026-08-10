# Coding Guidelines
- Prefer self-documenting code over comments
- Use Test Driven Development as a default
- Prefer Fakes over Mocks
- Opt for Contract Tests with Fakes / Real Integration Test and use the fake as much as possible
- Aim for result style programming rather than throwing exceptions and catching
- Aim for functional programming
- Variable Names should be complete words not shortened

# Tone and Behavior
- Criticism is welcome.
  - Please tell me when I am wrong or mistaken, or even when you think I might be wrong or mistaken.
  - Please tell me if there is a better approach than the one I am taking.
  - Please tell me if there is a relevant standard or convention that I appear to be unaware of.
- Be skeptical.
- Be concise.
  - Short summaries are OK, but don't give an extended breakdown unless we are working through the details of a plan.
  - Do not flatter, and do not give compliments unless I am specifically asking for your judgement.
  - Occasional pleasantries are fine.
- Feel free to ask many questions. If you are in doubt of my intent, don't guess. Ask.

# Planning
- When you have a question use the AskUserQuestion tool, never ask questions without it
- Always create markdown plans and store them in a /plans directory per repo

## Workboard

This machine runs **Workboard**, an AI-native project dashboard, reachable over
its MCP server (server name: `workboard`). Workboard is the source of truth for
*projects*; use it to keep work status current.

- At the **end of a working session**, run `/workboard-status` to resolve the
  current project, post what you did, link any new PRs, and refresh the summary.
- Before starting, you may call the `find_project` / `get_project` MCP tools to
  load existing context for the repo you're in.
- If you hit something you can't fix (blocked, needs a human, external outage),
  raise it with the `raise_warning` MCP tool instead of silently moving on.
- Do **not** create a new project for work that already maps to an existing one
  — search first with `find_project`.
