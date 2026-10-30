_:

let
  shared-casks = import ../shared/casks.nix;
in
shared-casks
++ [
  # Entertainment Tools
  "steam"
  "vlc"
  "plex"

  # Productivity Tools
  "chatgpt"
  "discord"
  "tailscale-app"
]
