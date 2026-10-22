{
  lib,
  mattpocock-skills,
  apple-design,
  ui-ux-pro-max,
  rea,
}:

let
  fragments = files: lib.concatMapStringsSep "\n" builtins.readFile files;

  # Driven by upstream's own manifest so `nix flake update` picks up new skills
  # and drops deprecated ones without an edit here.
  mattpocockManifest = builtins.fromJSON (
    builtins.readFile "${mattpocock-skills}/.claude-plugin/plugin.json"
  );

  mattpocockSkills = lib.listToAttrs (
    map (relativePath: {
      name = baseNameOf relativePath;
      value = "${mattpocock-skills}/${lib.removePrefix "./" relativePath}";
    }) mattpocockManifest.skills
  );

  reaVersion = (builtins.fromJSON (builtins.readFile "${rea}/package.json")).version;

  workboardSkills = {
    workboard-accomplishments = ./skills/workboard-accomplishments;
    workboard-digest = ./skills/workboard-digest;
    workboard-queue = ./skills/workboard-queue;
    workboard-status = ./skills/workboard-status;
    workboard-triage = ./skills/workboard-triage;
  };

  designSkills = {
    apple-design = "${apple-design}/skills/apple-design";
    ui-ux-pro-max = "${ui-ux-pro-max}/.claude/skills/ui-ux-pro-max";
  };
in
{
  context = {
    shared = fragments [
      ./context/shared.md
    ];
    codex = fragments [
      ./context/shared.md
      ./context/codex.md
    ];
    opencode = fragments [
      ./context/shared.md
      ./context/opencode.md
    ];
  };

  # Harnesses without plugin support get the skills flat.
  skills = mattpocockSkills // workboardSkills // designSkills;

  # Plugin-capable clients can load the upstream skill bundle as a plugin.
  inherit workboardSkills designSkills;
  mattpocockPlugin = mattpocock-skills;

  reaSkills.reverse-engineer-anything = "${rea}/.agents/skills/reverse-engineer-anything";
  reaMcpArguments = [
    "-y"
    "rea-agents@${reaVersion}"
    "mcp"
  ];
}
