{
  description = "Configuration for MacOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # Pinned to the last rev with a cached darwin starship build; the current
    # unstable starship (1.26.0) has no darwin binary and fails to link on
    # macOS 26 (cctools ld64 crash). Drop this once 1.26.0 lands in the cache.
    nixpkgs-starship.url = "github:nixos/nixpkgs/80d591ed473cfc46329932c2aadac9b435342c7c";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-plist-manager = {
      url = "github:SushyDev/nix-plist-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    homebrew-can1357 = {
      url = "github:can1357/homebrew-tap";
      flake = false;
    };
    herdr = {
      url = "github:ogulcancelik/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
    pstack = {
      url = "github:cursor/plugins";
      flake = false;
    };
    apple-design = {
      url = "github:emilkowalski/skills";
      flake = false;
    };
    ui-ux-pro-max = {
      url = "github:nextlevelbuilder/ui-ux-pro-max-skill";
      flake = false;
    };
    rea = {
      url = "github:morluto/rea/rea-agents-6.7.0";
      flake = false;
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
      homebrew-can1357,
      home-manager,
      nix-plist-manager,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-starship,
      herdr,
      mattpocock-skills,
      pstack,
      apple-design,
      ui-ux-pro-max,
      rea,
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
            agents = import ./programs/agents {
              inherit (nixpkgs) lib;
              inherit mattpocock-skills pstack rea;
              inherit apple-design ui-ux-pro-max;
            };
            userInfo = userInfo.${host};
            hostRole = host;
          };
          modules = [
            home-manager.darwinModules.home-manager
            nix-plist-manager.darwinModules.default
            nix-homebrew.darwinModules.nix-homebrew
            {
              programs.nix-plist-manager.enable = true;
              home-manager.sharedModules = [ nix-plist-manager.homeManagerModules.default ];
            }
            {
              nixpkgs.overlays = [
                herdr.overlays.default
                (final: prev: {
                  starship = nixpkgs-starship.legacyPackages.${system}.starship;
                })
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
                  "can1357/homebrew-tap" = homebrew-can1357;
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
