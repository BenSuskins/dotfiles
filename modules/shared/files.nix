{
  lib,
  hostRole,
  agents,
}:

{
  ".config/nvim" = {
    source = ../../programs/neovim;
    recursive = true;
  };

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
