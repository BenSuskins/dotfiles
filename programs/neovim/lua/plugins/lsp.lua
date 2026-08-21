-- Language servers, completion, and formatting.
--
-- Every binary here comes from the Nix flake and resolves from PATH. There is
-- no mason: the flake owns tool versions, so the editor must not install its
-- own copies behind its back.
--
-- Neovim 0.12 enables servers itself. nvim-lspconfig is on the runtime path
-- only to supply each server's default command and root markers.
return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            -- Colour by meaning needs the server to say what each symbol is.
            semanticTokens = true,
            analyses = { unusedparams = true, shadow = true },
          },
        },
      })

      -- nvim-lspconfig derives storagePath from a Gradle root. Outside a Gradle
      -- project that root is nil, init_options serialises as an empty JSON
      -- array, and the server rejects the handshake with an internal error.
      -- A real path keeps it an object, so a loose .kt file still gets an LSP.
      vim.lsp.config("kotlin_language_server", {
        init_options = {
          storagePath = vim.fn.stdpath("cache") .. "/kotlin-language-server",
        },
      })

      vim.lsp.config("lua_ls", {
        settings = { Lua = { workspace = { checkThirdParty = false } } },
      })

      vim.lsp.enable({
        "gopls",
        "kotlin_language_server",
        "marksman", -- markdown
        "nil_ls", -- nix
        "lua_ls",
      })
    end,
  },

  -- lua_ls learns the Neovim API, so editing this config gets completion.
  { "folke/lazydev.nvim", ft = "lua", opts = {} },

  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = { preset = "default" }, -- <C-n>/<C-p> to move, <C-y> to accept
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 250 },
        ghost_text = { enabled = false },
      },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      signature = { enabled = true },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = { timeout_ms = 2000, lsp_format = "fallback" },
      formatters_by_ft = {
        go = { "gofumpt", "goimports" },
        lua = { "stylua" },
        nix = { "nixfmt" },
        sh = { "shfmt" },
        json = { "prettier" },
        yaml = { "prettier" },
      },
    },
  },

  -- gopls does not run golangci-lint. This does, on save.
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = { go = { "golangcilint" } }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
