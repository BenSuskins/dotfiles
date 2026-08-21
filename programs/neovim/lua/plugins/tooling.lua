-- Language servers, formatters, and linters come from the Nix flake.
-- Without mason-lspconfig, LazyVim enables every configured server directly,
-- so each binary resolves from PATH instead of ~/.local/share/nvim/mason.
return {
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
}
