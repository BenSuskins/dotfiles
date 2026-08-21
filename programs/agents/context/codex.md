# Codex

- Prefer the AskUserQuestion tool when the decision has discrete options.
  Plain-text questions are fine when the answer is open-ended.
- Nix manages `~/.codex/AGENTS.md` and `~/.codex/skills`. Do not edit them in
  place; edit `programs/agents/` in the nixos-config repo instead.
- Nix does not manage `~/.codex/config.toml`. Codex owns that file. Edit it
  directly to change plugins, MCP servers, or app settings.
