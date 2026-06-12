{ config, pkgs, ... }:

{
  imports = [
    ../../modules/shared/home.nix
    ../../modules/shared
  ];

  nix = {
    package = pkgs.nix;
    enable = false;
  };

  homebrew.taps = builtins.attrNames config.nix-homebrew.taps;

  homebrew.brews = [
    "S-Sigdel/tap/vimhjkl"
  ];

  security.pam.services.sudo_local.touchIdAuth = true;
}
