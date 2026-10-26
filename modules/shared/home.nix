{
  config,
  pkgs,
  lib,
  home-manager,
  userInfo,
  hostRole,
  agents,
  ...
}:

let
  dockEntries = {
    personal = [
      { path = "${pkgs.discord}/Applications/Discord.app"; }
      { path = "/System/Applications/Messages.app/"; }
      { path = "/System/Applications/Mail.app/"; }
      { path = "/System/Applications/Calendar.app/"; }
      { path = "${pkgs.ghostty-bin}/Applications/Ghostty.app"; }
      { path = "/Applications/Safari.app"; }
      { path = "/System/Applications/Notes.app/"; }
      { path = "${pkgs.obsidian}/Applications/Obsidian.app"; }
      { path = "/Applications/Music.app"; }
      { path = "/System/Applications/iPhone Mirroring.app/"; }
    ];
    work = [
      { path = "/System/Applications/Notes.app"; }
      { path = "${pkgs.iterm2}/Applications/iTerm2.app"; }
      { path = "${pkgs.jetbrains.idea}/Applications/IntelliJ IDEA.app"; }
      { path = "${pkgs.vscode}/Applications/Visual Studio Code.app"; }
      { path = "/Applications/Microsoft Edge.app"; }
      { path = "/Applications/Slack.app"; }
      { path = "/Applications/Microsoft Teams.app"; }
      { path = "/System/Applications/Reminders.app/"; }
    ];
  };
in
{
  imports = [
    ./dock
  ];

  system.primaryUser = userInfo.username;

  users.users.${userInfo.username} = {
    name = "${userInfo.username}";
    home = "/Users/${userInfo.username}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ../${hostRole}/casks.nix { };
    onActivation = {
      cleanup = "zap";
      upgrade = true;
      autoUpdate = true;
    };
    brews = pkgs.callPackage ../${hostRole}/brews.nix { };
    masApps = {
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    users.${userInfo.username} =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      {
        targets.darwin.copyApps.enable = true;
        targets.darwin.linkApps.enable = false;

        home = {
          file = import ./files.nix {
            inherit
              config
              lib
              hostRole
              agents
              ;
          };
          sessionPath = [
            "$HOME/.local/bin"
          ];
          enableNixpkgsReleaseCheck = false;
          packages = pkgs.callPackage ../${hostRole}/packages.nix { };
          stateVersion = "23.11";
        };
        programs =
          (import ./programs.nix {
            inherit
              pkgs
              userInfo
              hostRole
              agents
              ;
          })
          // {
            nix-plist-manager = {
              enable = true;
              options.applications = {
                finder = {
                  settings.advanced = {
                    showAllFilenameExtensions = true;
                    showWarningBeforeChangingAnExtension = false;
                  };
                  menuBar.view.showPathBar = true;
                };
                systemSettings = {
                  accessibility.zoom.useScrollGestureWithModifierKeysToZoom = true;
                  desktopAndDock.dock = {
                    size = 58;
                    magnification = {
                      enabled = true;
                      size = 66;
                    };
                    dockPositionOnScreen = "Bottom";
                    automaticallyHideAndShowTheDock.enabled = true;
                    showSuggestedAndRecentAppsInDock = false;
                  };
                  general.dateAndTime."24HourTime" = true;
                  keyboard = {
                    keyRepeatRate = 2;
                    delayUntilRepeat = 15;
                    useF1F2EtcKeysAsStandardFunctionKeys = false;
                  };
                  menuBar = {
                    bluetooth = true;
                    clock.style = "Digital";
                    clock.displayTheTimeWithSeconds = true;
                    sound = "Always Show";
                  };
                  trackpad.pointAndClick.tapToClick = true;
                };
              };
            };
          };
      };
  };

  local.dock.enable = true;
  local.dock.entries = dockEntries.${hostRole};
  local.dock.username = userInfo.username;
}
