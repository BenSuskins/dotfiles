{
  lib,
  mattpocock-skills,
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
    workboard-digest = ./skills/workboard-digest;
    workboard-status = ./skills/workboard-status;
    workboard-triage = ./skills/workboard-triage;
  };
in
{
  context = {
    claude = fragments [
      ./context/shared.md
      ./context/claude-code.md
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
  skills = mattpocockSkills // workboardSkills;

  # Claude loads Matt's skills as a plugin instead, to keep them namespaced
  # away from the built-in code-review, research, and prototype skills.
  inherit workboardSkills;
  mattpocockPlugin = mattpocock-skills;
}
