{ ... }:

{
  system = {
    stateVersion = 4;
    checks.verifyNixPath = false;

    defaults = {
      finder = {
        AppleShowAllFiles = true;
        FXPreferredViewStyle = "icnv";
      };
    };
  };
}
