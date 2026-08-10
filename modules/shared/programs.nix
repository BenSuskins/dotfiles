{
  pkgs,
  userInfo,
  hostRole,
  ...
}:

{
  zoxide = {
    enable = true;
  };

  neovim = import ../shared/neovim.nix { inherit pkgs; };
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
