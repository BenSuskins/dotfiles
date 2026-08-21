{
  pkgs,
  userInfo,
  hostRole,
  agents,
  claude-plugins-official,
  ...
}:

{
  zoxide = {
    enable = true;
  };

  claude-code = import ../shared/claude-code.nix {
    inherit
      pkgs
      hostRole
      agents
      claude-plugins-official
      ;
  };
  codex = import ../shared/codex.nix { inherit hostRole agents; };
  opencode = import ../shared/opencode.nix { inherit hostRole agents; };
  tmux = import ../shared/tmux.nix { inherit pkgs; };
  direnv = import ../shared/direnv.nix;
  starship = import ../shared/starship.nix;
  zsh = import ../shared/zsh.nix {
    inherit hostRole;
    inherit (pkgs) lib;
  };
  git = import ../shared/git.nix {
    name = userInfo.name;
    email = userInfo.email;
  };
}
