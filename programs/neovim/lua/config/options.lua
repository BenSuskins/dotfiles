-- The leader must be set before lazy.nvim reads any plugin spec, so this file
-- loads first. Everything else here is an editor default worth naming.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- Screen
opt.number = true
opt.relativenumber = false
opt.signcolumn = "number" -- git and diagnostic marks share the number column
opt.cursorline = true
opt.scrolloff = 6 -- keep context above and below the cursor
opt.wrap = false
opt.termguicolors = true
opt.laststatus = 3 -- one statusline for all windows
opt.showmode = false -- lualine reports the mode
opt.splitbelow = true
opt.splitright = true
opt.winborder = "rounded"

-- Editing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.undofile = true
opt.confirm = true -- ask to save rather than refusing to quit
opt.updatetime = 200
opt.timeoutlen = 400 -- how long which-key waits before it appears

-- Search
opt.ignorecase = true
opt.smartcase = true -- a capital letter in the pattern makes the search exact
opt.inccommand = "nosplit" -- preview :substitute as you type

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Diagnostics: colour in the gutter, text on demand. Nothing floats in.
vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.INFO] = "I",
      [vim.diagnostic.severity.HINT] = "H",
    },
  },
})
