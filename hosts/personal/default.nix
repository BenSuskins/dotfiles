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

  security.pam.services.sudo_local.touchIdAuth = true;
}
