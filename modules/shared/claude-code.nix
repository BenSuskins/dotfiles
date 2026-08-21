{
  pkgs,
  hostRole,
  agents,
  claude-plugins-official,
}:

let
  inherit (pkgs) lib;

  statusline = pkgs.writeShellApplication {
    name = "claude-statusline";
    runtimeInputs = [
      pkgs.jq
      pkgs.git
    ];
    text = builtins.readFile ../../programs/claude/statusline.sh;
  };
in
{
  enable = hostRole == "personal";

  context = agents.context.claude;

  skills = agents.workboardSkills;

  # Pinned in the flake rather than fetched from the marketplace. Loading a
  # plugin here and in enabledPlugins would install it twice.
  plugins =
    lib.genAttrs [
      "feature-dev"
      "frontend-design"
      "playground"
    ] (name: "${claude-plugins-official}/plugins/${name}")
    // {
      mattpocock-skills = agents.mattpocockPlugin;
    };

  mcpServers = {
    homelab = {
      command = "npx";
      args = [
        "-y"
        "mcp-remote"
        "http://192.168.0.206:8090/mcp"
        "--allow-http"
      ];
    };
  };

  settings = {
    model = "opus";
    theme = "dark-daltonized";
    effortLevel = "high";
    tui = "fullscreen";
    remoteControlAtStartup = true;
    agentPushNotifEnabled = true;
    skipAutoPermissionPrompt = true;

    permissions.allow = [
      "Bash(sips -g *)"
    ];

    statusLine = {
      type = "command";
      command = "${statusline}/bin/claude-statusline";
    };

    # The *-lsp entries carry no content of their own — Claude Code implements
    # the LSP support internally and gates it on the marketplace name, so there
    # is nothing to pin. The content-bearing plugins moved to `plugins` above.
    enabledPlugins = {
      "clangd-lsp@claude-plugins-official" = true;
      "gopls-lsp@claude-plugins-official" = true;
      "jdtls-lsp@claude-plugins-official" = true;
      "kotlin-lsp@claude-plugins-official" = true;
      "swift-lsp@claude-plugins-official" = true;
      "typescript-lsp@claude-plugins-official" = true;
      "eli5@claude-community" = true;
    };
  };
}
