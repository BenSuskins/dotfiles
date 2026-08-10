{ hostRole, lib }:

{
  enable = true;
  autocd = false;
  syntaxHighlighting.enable = true;
  autosuggestion.enable = true;
  shellAliases = import ./zsh/aliases.nix { inherit hostRole lib; };
  sessionVariables = import ./zsh/variables.nix { inherit lib; };
  initContent = ''
    ${builtins.readFile ./zsh/functions.sh}
  '';
}
