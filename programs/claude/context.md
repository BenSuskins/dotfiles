# Coding Guidelines

The existing codebase wins. Match its style, idioms, and structure even where
they conflict with the preferences below — raise the conflict, don't unilaterally
introduce a second convention.

- Prefer self-documenting code over comments. Comment the *why*, never the *what*.
- Variable names are complete words, not abbreviations.
- Prefer functional style: pure functions, immutable data, composition over
  inheritance.
- Prefer result-style error handling over throw/catch, in languages where that
  is idiomatic.
- Prefer fakes over mocks. Favour contract tests against a fake plus a real
  integration test proving the fake is faithful.
- Use TDD in repos with a test harness. In config, infra, and scripting repos,
  verify by running the thing instead.

# Tone and Behavior

- Criticism is welcome. Tell me when I'm wrong or might be wrong, when there's a
  better approach, and when there's a standard or convention I appear to be
  unaware of.
- Be skeptical of my premises, and of your own prior conclusions.
- Be concise. Short summaries are fine; save the extended breakdown for when
  we're working through a plan.
- Don't flatter or compliment unless I've asked for your judgement.
- Ask rather than guess. If my intent is ambiguous, say so.

# Planning

- Prefer the AskUserQuestion tool when the decision has discrete options.
  Plain-text questions are fine when the answer is open-ended.
- For work spanning multiple steps or sessions, write the plan as markdown in
  `plans/` at the repo root. Skip the file for small, single-step changes.
- `plans/` is scratch space — add it to `.gitignore` if it isn't already.
  Plans don't belong in repo history or PRs.

# Workboard

This machine runs **Workboard**, an AI-native project dashboard, reachable over
its MCP server (server name: `workboard`). Workboard is the source of truth for
*projects*; use it to keep work status current.

- Before starting, call `find_project` / `get_project` to load existing context
  for the repo you're in.
- Do **not** create a new project for work that already maps to an existing one
  — search first with `find_project`.
- After finishing a substantial piece of work, or when I say we're done, run
  `/workboard-status` to post what you did, link any new PRs, and refresh the
  summary.
- If you hit something you can't fix (blocked, needs a human, external outage),
  raise it with `raise_warning` instead of silently moving on.
