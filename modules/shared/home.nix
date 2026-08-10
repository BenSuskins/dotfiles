{
  config,
  pkgs,
  lib,
  home-manager,
  userInfo,
  hostRole,
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
        home = {
          file = import ./files.nix { inherit hostRole; };
          sessionPath = [
            "$HOME/.local/bin"
          ];
          enableNixpkgsReleaseCheck = false;
          packages = pkgs.callPackage ../${hostRole}/packages.nix { };
          stateVersion = "23.11";
        };
        programs = import ./programs.nix { inherit pkgs userInfo hostRole; };
      };
  };

  local.dock.enable = true;
  local.dock.entries = dockEntries.${hostRole};
  local.dock.username = userInfo.username;
}
