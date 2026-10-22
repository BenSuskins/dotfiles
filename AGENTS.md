# Repository Guide

This repository defines macOS developer environments with Nix flakes, nix-darwin, and Home Manager. It builds the `personal` and `work` configurations for `aarch64-darwin`.

## Structure

- `flake.nix` defines inputs, shared user data, and both Darwin configurations.
- `hosts/personal/` and `hosts/work/` are host entry points. Both import the shared Home Manager and system modules.
- `modules/shared/` holds common system, Home Manager, application, and shell settings.
- `modules/personal/` and `modules/work/` hold host-specific packages, Homebrew formulae, and casks.
- `programs/` contains source configuration and the agent setup assembled by Nix.

Read the relevant module and its imports before changing configuration. Follow the existing module structure and attribute style. Keep shared behavior in `modules/shared/`; use a host module when behavior differs by `hostRole`.

## Nix Configuration

- `flake.nix` passes `userInfo`, `hostRole`, and the assembled `agents` value through module arguments. Use these values instead of duplicating host-specific data.
- Shared program configuration is composed in `modules/shared/programs.nix` and host selections are made through `hostRole`.
- Package lists use the existing `pkgs.callPackage` pattern. Keep package definitions in the matching shared or host module.
- `programs/agents/default.nix` assembles context and skill sources for Codex, Claude Code, and OpenCode. Put shared agent guidance in `programs/agents/context/shared.md`; put client-specific guidance in that client's context file.
- Nix manages `~/.codex/AGENTS.md` and `~/.codex/skills` from `programs/agents/`. Codex owns `~/.codex/config.toml`; follow the user's request and the established local workflow when editing runtime settings.
- Home Manager copies Darwin applications and disables app linking. Preserve both settings when editing Home Manager configuration.
- Homebrew activation uses `cleanup = "zap"`. Account for its removal of unmanaged applications when changing cask management.

## Build and Apply

Format changed Nix files with:

```sh
nixfmt-rfc-style path/to/file.nix
```

Build a configuration to check evaluation without applying it:

```sh
sudo darwin-rebuild build --flake .#personal
sudo darwin-rebuild build --flake .#work
```

Apply a configuration only when the user asks to apply it:

```sh
sudo darwin-rebuild switch --flake .#personal
sudo darwin-rebuild switch --flake .#work
```

Use the build for each affected host as the configuration check. A successful build confirms evaluation and build completion; it does not confirm that a configuration was applied or that macOS behavior changed.

## Agent Guidance Changes

Keep this file focused on repository-specific conventions. Keep shared agent context and client-specific context in `programs/agents/context/`, where Nix assembles them for each client. Do not copy client context into this file.
