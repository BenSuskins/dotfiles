_:

let
  shared-brews = import ../shared/brews.nix;
in
shared-brews
++ [
  # Development
  "can1357/tap/omp"
]
