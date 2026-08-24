{ hostRole, agents }:

{
  enable = hostRole == "personal";

  context = agents.context.opencode;

  skills = agents.skills;

  settings = {
    "$schema" = "https://opencode.ai/config.json";

    # The same MCPJungle gateway the other clients use, by LAN IP. See the note
    # in claude-code.nix for why the public hostname is not usable.
    mcp.suskins = {
      type = "remote";
      url = "http://192.168.0.206:8090/mcp";
      enabled = true;
    };

    provider.openrouter.models = {
      # OpenRouter's current stealth model. Declared by hand because models.dev
      # (which opencode reads its catalogue from) does not carry stealth slugs,
      # so `-m openrouter/stealth/ox-alpha` fails without this entry. Not set as
      # the default model: the free preview is time-boxed and the slug retires
      # with it. Select it per run with `-m`, or `/models` in the TUI.
      "stealth/ox-alpha" = {
        name = "Ox Alpha (stealth)";
        reasoning = true;
        limit = {
          context = 1048576;
          output = 131072;
        };
        cost = {
          input = 0;
          output = 0;
        };
      };
    };
  };
}
