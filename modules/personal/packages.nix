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
  terraform-ls
  tflint

  # ESP
  platformio

  # AI
  codexbar

  # Misc
  shottr
]
