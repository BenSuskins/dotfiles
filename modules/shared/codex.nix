{ hostRole, agents }:

{
  enable = hostRole == "personal";

  context = agents.context.codex;

  # Flat rather than a plugin: setting `plugins` here would also pull
  # config.toml under Nix management, and the Codex app writes that file at
  # runtime (marketplace state, project trust levels, desktop prefs).
  skills = agents.skills;
}
