-- lazy.nvim installs and updates the plugins. Nothing else. The plugin list
-- itself is six files in lua/plugins, each one a topic.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },
  -- Plugins load at startup unless a spec says otherwise. There are twenty of
  -- them; the milliseconds saved by lazy-loading cost more in confusion than
  -- they return in speed.
  defaults = { lazy = false, version = false },
  install = { colorscheme = { "invariant", "habamax" } },
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin", "netrwPlugin" },
    },
  },
})

-- The colour scheme is a vim file in colors/, not a plugin. Set it after the
-- plugins load, so their own highlight defaults cannot land on top of the
-- overrides in lua/plugins/colorscheme.lua.
vim.cmd.colorscheme("invariant")
