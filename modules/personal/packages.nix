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

  # ESP
  platformio

  # AI
  codexbar
  codex

  # Misc
  shottr
]
