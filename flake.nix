{
  description = "Configuration for MacOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-s-sigdel-tap = {
      url = "github:S-Sigdel/homebrew-tap";
      flake = false;
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
      url = "github:ogulcancelik/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      darwin,
      nix-homebrew,
      homebrew-bundle,
      homebrew-core,
      homebrew-cask,
      homebrew-s-sigdel-tap,
      home-manager,
      mac-app-util,
      nixpkgs,
      claude-code,
      herdr,
    }:
    let
      userInfo = {
        personal = {
          name = "Ben Suskins";
          username = "bensuskins";
          email = "suskinsdevelopment@gmail.com";
        };
        work = {
          name = "Ben Suskins";
          username = "tbd";
          email = "tbd";
        };
      };
      system = "aarch64-darwin";
      hosts = [
        "personal"
        "work"
      ];
      mkDarwinConfig =
        host:
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit self;
            userInfo = userInfo.${host};
            hostRole = host;
          };
          modules = [
            home-manager.darwinModules.home-manager
            (
              {
                pkgs,
                config,
                inputs,
                ...
              }:
              {
                home-manager.sharedModules = [
                  mac-app-util.homeManagerModules.default
                ];
              }
            )
            nix-homebrew.darwinModules.nix-homebrew
            mac-app-util.darwinModules.default
            {
              nixpkgs.overlays = [
                claude-code.overlays.default
                herdr.overlays.default
              ];
            }
            {
              nix-homebrew = {
                user = userInfo.${host}.username;
                enable = true;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                  "S-Sigdel/tap" = homebrew-s-sigdel-tap;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
            ./hosts/${host}
          ];
        };
    in
    {
      darwinConfigurations = nixpkgs.lib.genAttrs hosts (host: mkDarwinConfig host);
    };
}
