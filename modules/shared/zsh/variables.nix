{ lib }:

let
  hosts = import ./hosts.nix;

  serverAddresses = lib.mapAttrs' (name: host: {
    name = "${lib.toUpper name}_SERVER_IP";
    value = host.ip;
  }) hosts;
in
serverAddresses
// {
  EDITOR = "nvim";
  VISUAL = "$EDITOR";
}
