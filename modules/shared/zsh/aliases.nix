{ hostRole, lib }:

let
  hosts = import ./hosts.nix;

  sshAliases = lib.mapAttrs' (name: host: {
    name = "ssh${name}";
    value = "ssh -i ~/.ssh/homelab ${host.user}@${host.ip}";
  }) (lib.filterAttrs (_: host: host.user != null) hosts);
in
{
  # General
  l = "eza -lah";
  ls = "eza";
  tree = "eza --tree --git-ignore";
  cat = "bat";

  # Navigation
  ".." = "cd ..";
  "..." = "cd ../..";
  "...." = "cd ../../..";

  # Shortcuts
  g = "lazygit";

  # Utility
  copy = "pbcopy";
  paste = "pbpaste";
  ports = "lsof -i -P -n | grep LISTEN";

  # Nix
  nixconfig = "code ~/workspace/nixos-config";
  nixclean = "nix-collect-garbage";
  rebuild = "cd ~/workspace/nixos-config && darwin-rebuild build --flake .#${hostRole}";
  switch = "cd ~/workspace/nixos-config && sudo darwin-rebuild switch --flake .#${hostRole}";
  compare = "cd ~/workspace/nixos-config && nix store diff-closures /run/current-system ./result";
}
# SSH — derived from ./hosts.nix
// sshAliases
