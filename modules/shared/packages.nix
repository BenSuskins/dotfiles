{ pkgs }:

with pkgs;
[
  # General
  wget
  ripgrep
  fzf
  jq
  dockutil
  eza
  bat

  # Go
  go

  # Java
  jdk
  jetbrains.idea

  # Node
  nodejs_22
  bun

  # Python
  uv

  # Containers
  podman
  podman-compose
  podman-desktop

  # Nix
  nixfmt

  # Git
  gh
  lazygit

  # Utilities
  maccy
  obsidian

  # Development
  vscode
  ghostty-bin
]
