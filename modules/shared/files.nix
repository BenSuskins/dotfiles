{
  config,
  lib,
  hostRole,
  agents,
}:

{
  # A symlink into the working copy, not a copy in the Nix store. Editing a Lua
  # file takes effect the next time Neovim starts, with no rebuild and no
  # `git add`. The cost is that this path is hard-coded: a fresh machine must
  # clone the repo here before the link resolves.
  ".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/workspace/dotfiles/programs/neovim";

  "Library/Application Support/com.mitchellh.ghostty" = {
    source = ../../programs/ghostty;
    recursive = true;
  };
}
# The cross-harness Agent Skills convention, for harnesses without a
# home-manager module of their own.
// lib.mapAttrs' (
  name: source: lib.nameValuePair ".agents/skills/${name}" { inherit source; }
) agents.skills
