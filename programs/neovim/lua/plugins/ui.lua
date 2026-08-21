-- Neovim here is for reading and editing single files, not project work.
-- Strip the chrome that assumes an IDE session.
return {
  -- Ghostty already provides tabs and splits.
  { "akinsho/bufferline.nvim", enabled = false },

  -- Keep the command line popup, drop the LSP progress spinners.
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        progress = { enabled = false },
      },
    },
  },

  -- Surface warnings and errors only, and stop drawing lines down the indents.
  -- The indentation is already visible; the guides are one more thing moving.
  {
    "folke/snacks.nvim",
    opts = {
      notifier = { level = vim.log.levels.WARN },
      indent = { enabled = false },
    },
  },

  -- Mark the problem in the gutter; read the text on demand.
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = { virtual_text = false },
      inlay_hints = { enabled = false },
    },
  },
}
