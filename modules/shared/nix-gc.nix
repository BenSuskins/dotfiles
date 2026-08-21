{ pkgs, userInfo, ... }:

let
  retention = "30d";

  # The Determinate installer owns /etc/nix, so `nix.enable` is false — and both
  # `nix.gc.automatic` and `nix.optimise.automatic` assert it. Declare the same
  # launchd daemon directly.
  #
  # Call the installed Nix rather than `pkgs.nix`: the GC client talks to the
  # running daemon, and the two versions differ.
  nixBin = "/nix/var/nix/profiles/default/bin";

  collectGarbage = pkgs.writeShellScript "nix-gc" ''
    # nix-collect-garbage only walks /nix/var/nix/profiles, so the user profile
    # under the XDG state directory needs naming. A failure here must not stop
    # the store collection below.
    ${nixBin}/nix-env \
      --profile /Users/${userInfo.username}/.local/state/nix/profiles/profile \
      --delete-generations ${retention} || true

    exec ${nixBin}/nix-collect-garbage --delete-older-than ${retention}
  '';
in
{
  launchd.daemons.nix-gc = {
    command = "${collectGarbage}";
    serviceConfig = {
      RunAtLoad = false;
      StartCalendarInterval = [
        {
          Weekday = 7;
          Hour = 3;
          Minute = 15;
        }
      ];
      StandardOutPath = "/var/log/nix-gc.log";
      StandardErrorPath = "/var/log/nix-gc.log";
    };
  };
}
