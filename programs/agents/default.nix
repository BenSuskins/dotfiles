{
  lib,
  mattpocock-skills,
  pstack,
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

  pstackSkills = {
    statechart = "${pstack}/pstack/skills/statechart";
  };
in
{
  context = {
    codex = fragments [
      ./context/shared.md
      ./context/codex.md
    ];
    opencode = fragments [
      ./context/shared.md
      ./context/opencode.md
    ];
  };

  skills = mattpocockSkills // workboardSkills // designSkills // pstackSkills;

  reaSkills.reverse-engineer-anything = "${rea}/.agents/skills/reverse-engineer-anything";
}
