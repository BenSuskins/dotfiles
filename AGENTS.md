# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Nix flake-based macOS configuration using nix-darwin and home-manager. It manages two separate configurations: `personal` and `work`.

## Commands

```shell
# Update flake inputs
nix flake update

# Build configuration (check for errors without applying)
sudo darwin-rebuild build --flake .#personal
sudo darwin-rebuild build --flake .#work

# Apply configuration
sudo darwin-rebuild switch --flake .#personal
sudo darwin-rebuild switch --flake .#work

# Rollback to previous generation
sudo darwin-rebuild rollback

# First-time setup (when darwin-rebuild isn't available yet)
nix run nix-darwin -- switch --flake .#personal
nix run nix-darwin -- switch --flake .#work

# Format Nix files
nixfmt-rfc-style <file.nix>
```

## Architecture

### Flake Structure

- `flake.nix` - Entry point defining two Darwin configurations (`personal`, `work`) with user info and shared modules
- `hosts/personal/` and `hosts/work/` - Host-specific entry points that import relevant modules

### Module Organization

- `modules/shared/` - Common configuration used by both hosts
  - `programs.nix` - Program configurations (neovim, zsh, git, starship, direnv)
  - `packages.nix` - Shared nix packages
  - `casks.nix` - Shared Homebrew casks
  - `system.nix` - macOS system preferences
  - `dock/` - Custom dock configuration module
- `modules/personal/` and `modules/work/` - Host-specific overrides
  - `home.nix` - Home-manager config, Homebrew casks, dock entries
  - `packages.nix` - Additional host-specific packages
  - `casks.nix` - Additional host-specific Homebrew casks

### Dotfiles

- `programs/neovim/` - Neovim configuration (symlinked to `~/.config/nvim`)
- `programs/ghostty/` - Ghostty terminal configuration

### Key Patterns

- User info (`name`, `username`, `email`) is defined in `flake.nix` and passed as `userInfo` to modules
- `hostRole` ("personal" or "work") enables conditional configuration
- Homebrew casks are managed declaratively with `cleanup = "zap"` (removes unmanaged apps)
- Packages use `pkgs.callPackage ./packages.nix { }` pattern for modularity
