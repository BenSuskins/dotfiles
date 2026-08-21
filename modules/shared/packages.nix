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

  # Neovim
  tree-sitter

  # Go
  go
  gopls
  gofumpt
  gotools
  golangci-lint

  # Java
  jdk
  jetbrains.idea

  # Kotlin
  kotlin-language-server
  ktlint

  # Node
  nodejs_22
  bun
  vtsls
  prettier

  # Python
  uv
  pyright
  ruff

  # Nix
  nixfmt
  nil
  statix

  # Lua
  lua-language-server
  stylua

  # Shell
  shfmt

  # Docker
  dockerfile-language-server-nodejs
  docker-compose-language-service
  hadolint

  # Markup
  vscode-langservers-extracted
  yaml-language-server
  marksman
  markdownlint-cli2

  # Git
  gh
  lazygit

  # Editor. Not programs.neovim: see modules/shared/neovim.nix.
  neovim

  # Utilities
  imagemagick # snacks.image renders pictures inline in Neovim
  maccy
  obsidian

  # Development
  vscode
  ghostty-bin
]
