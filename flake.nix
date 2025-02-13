{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle, }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      # Packages
      environment.systemPackages = [ 
          # Ansible
          pkgs.ansible
          pkgs.ansible-lint
          # CLI Tools
          pkgs.neovim
          pkgs.gh
          pkgs.wget
          pkgs.go
          # Shell config
          pkgs.pure-prompt
          # Misc
          pkgs.mkalias
        ];

      # Fonts
      fonts.packages =  [
          pkgs.nerd-fonts.fira-code
          pkgs.nerd-fonts.jetbrains-mono
      ];

      # Homebrew
      homebrew =  {
          enable = true;
          brews = [
              "zsh-syntax-highlighting"
              "z"
              "zsh-autosuggestions"
          ];
          casks = [
            "visual-studio-code"
            "iterm2"
            "intellij-idea-ce"
            "maccy"
            "postman"
          ];
          masApps = {};
          onActivation.cleanup = "zap";
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;
      };

      # Mac OS System
      system.defaults = {
          dock = {
            autohide = true;
            orientation = "bottom";
            largesize = 66;
            tilesize = 58;
            magnification = true;
            show-recents = false;
            persistent-apps = [
              "/System/Applications/Launchpad.app"
              "/System/Applications/Messages.app"
              "/System/Applications/Calendar.app"
              "/Applications/Iterm.app"
              "/Applications/Safari.app"
              "/System/Applications/Notes.app"
              "/Applications/Spotify.app"
              "/System/Applications/iPhone Mirroring.app"
            ];
          };
          finder = {
            AppleShowAllExtensions = true;
            ShowPathbar = true;
            AppleShowAllFiles = true;
            FXPreferredViewStyle = "icnv";
            FXEnableExtensionChangeWarning = false;
          };
          NSGlobalDomain = {
            "com.apple.keyboard.fnState" = false;
          };
      };

      # Enable Touch ID Sudo
      security.pam.enableSudoTouchIdAuth = true;

      # Create alias' for GUI apps in Applications
      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
          # Set up applications.
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
        '';

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Bens-MacBook-Pro
    darwinConfigurations."Bens-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        # home-manager.darwinModules.home-manager
        #   {
        #     home-manager.useGlobalPkgs = true;
        #     home-manager.useUserPackages = true;
        #     home-manager.users.bensuskins = import ./home.nix;            
        #   }
         nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "bensuskins";

              autoMigrate = true;

              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle" = homebrew-bundle;
              };
            };
          }
       ];
    };
  };
}
