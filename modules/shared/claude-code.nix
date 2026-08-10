{ pkgs, hostRole }:

let
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

  context = ../../programs/claude/context.md;

  skills = {
    workboard-digest = ../../programs/claude/skills/workboard-digest;
    workboard-status = ../../programs/claude/skills/workboard-status;
    workboard-triage = ../../programs/claude/skills/workboard-triage;
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

    enabledPlugins = {
      "clangd-lsp@claude-plugins-official" = true;
      "feature-dev@claude-plugins-official" = true;
      "frontend-design@claude-plugins-official" = true;
      "gopls-lsp@claude-plugins-official" = true;
      "jdtls-lsp@claude-plugins-official" = true;
      "kotlin-lsp@claude-plugins-official" = true;
      "mattpocock-skills@claude-plugins-official" = true;
      "playground@claude-plugins-official" = true;
      "swift-lsp@claude-plugins-official" = true;
      "typescript-lsp@claude-plugins-official" = true;
    };
  };
}
