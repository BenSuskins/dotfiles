# dotfiles

> Declarative macOS configuration via Nix flakes, nix-darwin, and home-manager.

## Overview

A Nix flake managing my macOS setup across two profiles — `personal` and
`work` — with shared modules for common programs (neovim, zsh, git, starship,
direnv) and host-specific overrides for packages, Homebrew casks, and dock
entries. Homebrew casks are managed declaratively with `cleanup = "zap"`, so
unmanaged apps are removed.

## Tech Stack

- [Nix](https://nixos.org/) flakes
- [nix-darwin](https://github.com/LnL7/nix-darwin) — macOS system config
- [home-manager](https://github.com/nix-community/home-manager) — per-user config
- Nixpkgs + Homebrew (for GUI apps via casks)

## Project Structure

```
dotfiles/
├── flake.nix             # Entry point — defines `personal` and `work` Darwin configs
├── hosts/
│   ├── personal/         # Host entry point importing relevant modules
│   └── work/
├── modules/
│   ├── shared/           # Common config used by both hosts (programs, packages, casks, system)
│   ├── personal/         # Personal-only overrides
│   └── work/             # Work-only overrides
├── programs/             # Dotfiles symlinked into ~/.config (neovim, ghostty, starship)
└── docs/
```

## Getting Started

### Prerequisites

- macOS (Apple Silicon or Intel)
- [Nix](https://nixos.org/download) installed (Determinate Systems installer recommended)

### Setup

```bash
git clone git@github.com:bensuskins/dotfiles.git
cd dotfiles

# First-time apply (before darwin-rebuild is available)
nix run nix-darwin -- switch --flake .#personal   # or .#work
```

Verify: re-open the terminal. `darwin-rebuild --version` should return a version and `zsh`/`starship`/`neovim` should reflect the configured setup.

## Commands

| Command | Purpose |
|---------|---------|
| `sudo darwin-rebuild switch --flake .#personal` | Apply the personal config |
| `sudo darwin-rebuild switch --flake .#work` | Apply the work config |
| `sudo darwin-rebuild build --flake .#<host>` | Build only (validate without applying) |
| `sudo darwin-rebuild rollback` | Revert to the previous generation |
| `nix flake update` | Update flake inputs |
| `nixfmt-rfc-style <file.nix>` | Format a Nix file |

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues and fixes.

## Resources

- [Nix Manual](https://nixos.org/manual/nix/stable/)
- [Nix Packages Search](https://search.nixos.org/packages)
- [home-manager Options](https://home-manager-options.extranix.com)
- [nix-darwin Options](https://nix-darwin.github.io/nix-darwin/manual/)

## Acknowledgments

Based on [dustinlyons/nixos-config](https://github.com/dustinlyons/nixos-config).

## Security

See [SECURITY.md](SECURITY.md) for vulnerability reporting.

## License

[MIT](../LICENSE)
