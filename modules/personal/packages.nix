{ pkgs }:

with pkgs;
let
  shared-packages = import ../shared/packages.nix { inherit pkgs; };
in
shared-packages
++ [
  # Ansible
  ansible
  ansible-lint

  # Terraform
  terraform

  # AI
  claude-code
  codexbar
  codex

  # Misc
  shottr
]
