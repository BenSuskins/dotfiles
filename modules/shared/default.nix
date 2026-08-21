{ config, pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./nix-gc.nix
    ./system.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };
  };
}
