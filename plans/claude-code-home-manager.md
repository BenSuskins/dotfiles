# Migrate Claude Code config to home-manager

## Goal

Replace the mutable `~/.claude` configuration with declarative
`programs.claude-code` from home-manager, add the `homelab` MCP server, drop the
third-party claude-code overlay, and replace the broken statusline.

## Findings

- The pinned `home-manager` input (`7834e82`) ships
  `modules/programs/claude-code`, exposing `settings`, `context`, `commands`,
  `skills`, `agents`, `hooks`, `mcpServers`, `lspServers`, `plugins`,
  `marketplaces`.
- `mcpServers` is **not** written to `~/.claude.json`. The module builds a
  synthetic personal plugin (`claude-code-home-manager`) containing `.mcp.json`.
  This path requires claude-code >= 2.1.157; nixpkgs ships 2.1.222.
- `settings.json` is installed `-Dm444` — a read-only store symlink. Runtime
  mutation of settings stops working.
- `programs.claude-code` adds `finalPackage` to `home.packages`, so
  `claude-code` was dropped from `modules/personal/packages.nix`.
- Both `sadjow/claude-code-nix` and nixpkgs wrap with `DISABLE_AUTOUPDATER 1`;
  **neither auto-updates**. nixpkgs now has a maintained `update.sh` +
  `manifest.json` driven by the update bot, so it tracks upstream closely and
  the overlay earns nothing. nixpkgs additionally sets
  `FORCE_AUTOUPDATE_PLUGINS 1`.
- The previous statusline pointed at a `claude-hud` plugin cache directory that
  no longer exists, so it was already silently failing.

## Consequences accepted

- `/config`, theme switching, `/plugin` enable/disable no longer persist —
  every settings change goes through the flake.
- Plugin *marketplaces* stay mutable (`plugins/known_marketplaces.json` is not
  nix-managed). Only `enabledPlugins` is declared, so `/plugin update` works.
- `programs/claude/context.md` is not named `CLAUDE.md` because
  `~/.gitignore_global` ignores that filename; it is written to
  `~/.claude/CLAUDE.md` by the `context` option regardless.

## What shipped

1. `programs/claude/` holds `context.md`, `statusline.sh`, and
   `skills/workboard-{digest,status,triage}/SKILL.md`.
2. `modules/shared/claude-code.nix` returns the `programs.claude-code` attrset
   and builds the statusline via `pkgs.writeShellApplication` (shellcheck runs
   at build time) with `jq` and `git` as runtime inputs.
3. Wired into `modules/shared/programs.nix`, gated with
   `enable = hostRole == "personal"` to preserve per-host behaviour.
4. `claude-code` input and overlay removed from `flake.nix`.
5. `homelab` MCP server added:
   `npx -y mcp-remote http://192.168.0.206:8090/mcp --allow-http`.
6. Statusline renders `model · repo/branch* · N% ctx · $cost`, colour-coded
   green/yellow/red at 50%/80% context. Reads `context_window.used_percentage`
   and `cost.total_cost_usd`, tolerating the nulls the docs warn about early in
   a session.
7. Dropped the `interview` command (superseded by mattpocock `grill`) and the
   `ui-ux-pro-max` marketplace/plugin.

## Manual pre-activation step

macOS is case-insensitive: `~/.claude/CLAUDE.MD` collides with the `CLAUDE.md`
symlink home-manager creates, and home-manager refuses to clobber a regular
file. The same applies to `~/.claude/settings.json` and
`~/.claude/skills/workboard-*`. Remove them before `darwin-rebuild switch`:

```sh
rm -rf ~/.claude/CLAUDE.MD ~/.claude/settings.json \
       ~/.claude/skills/workboard-digest \
       ~/.claude/skills/workboard-status \
       ~/.claude/skills/workboard-triage \
       ~/.claude/commands/interview.md
```

## Verification

- `nix build .#darwinConfigurations.personal.system` — green
- Statusline exercised against sample payloads incl. null context and `{}`
- After switch: confirm `~/.claude/settings.json` is a store symlink and
  `claude mcp list` shows `homelab`
