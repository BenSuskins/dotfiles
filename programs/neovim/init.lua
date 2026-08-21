-- Read this file first, then follow it down. Four steps, in order:
-- options set the editor, lazy installs the plugins, keymaps bind the keys,
-- autocmds handle the rest. Every key you have is in lua/config/keymaps.lua.
require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
