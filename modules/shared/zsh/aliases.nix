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
  vimhjkl = "uv run --project ~/workspace/vimhjkl vimhjkl";

  # Utility
  copy = "pbcopy";
  paste = "pbpaste";
  ports = "lsof -i -P -n | grep LISTEN";

  # Nix
  nixconfig = "code ~/workspace/dotfiles";
  nixclean = "nix-collect-garbage";
  rebuild = "cd ~/workspace/dotfiles && darwin-rebuild build --flake .#${hostRole}";
  switch = "cd ~/workspace/dotfiles && sudo darwin-rebuild switch --flake .#${hostRole}";
  compare = "cd ~/workspace/dotfiles && nix store diff-closures /run/current-system ./result";
}
# SSH — derived from ./hosts.nix
// sshAliases
