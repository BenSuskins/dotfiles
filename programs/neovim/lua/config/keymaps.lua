-- Every key this config adds is in this file. If a key is not here and not in
-- `:help index`, it does not exist. That is the whole point of the file.
--
-- The sections match lua/cheatsheet.lua, which is the printed version of the
-- same list. Add a key here, add the row there.
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end

-- Code navigation ------------------------------------------------------------
-- Neovim already binds gd, gO, and K. These fill the gaps and rename the ones
-- whose defaults are hard to remember.
map("n", "gd", vim.lsp.buf.definition, "Go to definition")
map("n", "gI", vim.lsp.buf.implementation, "Go to implementation")
map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
map("n", "gr", "<cmd>Trouble lsp_references toggle focus=true<cr>", "References (Trouble)")
map("n", "K", vim.lsp.buf.hover, "Hover documentation")
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
map("n", "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, "Format buffer")

-- Files and search -----------------------------------------------------------
map("n", "<leader><space>", function()
  Snacks.picker.smart()
end, "Find file in project")
map("n", "<leader>/", function()
  Snacks.picker.grep()
end, "Grep across project")
map("n", "<leader>,", function()
  Snacks.picker.buffers()
end, "Switch buffer")
map("n", "<leader>e", function()
  Snacks.explorer()
end, "File explorer")
map("n", "<leader>sr", "<cmd>GrugFar<cr>", "Search and replace across files")
map("n", "<leader>ss", function()
  Snacks.picker.lsp_symbols()
end, "Jump to a symbol or heading")
map("n", "<leader>st", "<cmd>TodoTrouble<cr>", "TODO comments in Trouble")
map("n", "<leader>sh", function()
  Snacks.picker.help()
end, "Search help")
map("n", "<leader>sk", function()
  Snacks.picker.keymaps()
end, "Search keymaps")

-- Flash: press s, type two characters, land there.
map({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, "Flash jump")
map({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, "Flash treesitter select")

-- Text objects: af selects a whole function, if selects its body.
for key, query in pairs({
  af = "@function.outer",
  ["if"] = "@function.inner",
  ac = "@class.outer",
  ic = "@class.inner",
}) do
  map({ "x", "o" }, key, function()
    require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
  end, "Select " .. query)
end

-- Jump between the other uses of the word under the cursor.
map("n", "]]", function()
  Snacks.words.jump(1, true)
end, "Next use of this word")
map("n", "[[", function()
  Snacks.words.jump(-1, true)
end, "Previous use of this word")

-- Git ------------------------------------------------------------------------
map("n", "]h", function()
  require("gitsigns").nav_hunk("next")
end, "Next change")
map("n", "[h", function()
  require("gitsigns").nav_hunk("prev")
end, "Previous change")
map("n", "<leader>ghs", function()
  require("gitsigns").stage_hunk()
end, "Stage hunk")
map("n", "<leader>ghr", function()
  require("gitsigns").reset_hunk()
end, "Reset hunk")
map("n", "<leader>ghp", function()
  require("gitsigns").preview_hunk()
end, "Preview hunk")
map("n", "<leader>ghb", function()
  require("gitsigns").blame_line({ full = true })
end, "Blame line")

-- Diagnostics ----------------------------------------------------------------
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1 })
end, "Next diagnostic")
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1 })
end, "Previous diagnostic")
map("n", "<leader>cd", vim.diagnostic.open_float, "Show diagnostic for this line")
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", "All diagnostics in Trouble")

-- Toggles --------------------------------------------------------------------
map("n", "<leader>um", "<cmd>RenderMarkdown toggle<cr>", "Toggle markdown rendering")
map("n", "<leader>uc", function()
  vim.opt_local.conceallevel = vim.opt_local.conceallevel:get() == 0 and 2 or 0
end, "Toggle conceal")
map("n", "<leader>uw", function()
  vim.opt_local.wrap = not vim.opt_local.wrap:get()
end, "Toggle wrap")
map("n", "<leader>ur", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, "Toggle relative numbers")

-- Session and buffers --------------------------------------------------------
map("n", "<leader>qs", function()
  require("persistence").load()
end, "Restore session for this directory")
map("n", "<leader>bd", function()
  Snacks.bufdelete()
end, "Close buffer, keep the window")

-- A scratch buffer per project, kept between sessions.
map("n", "<leader>.", function()
  Snacks.scratch()
end, "Scratch buffer")
map("n", "<leader>z", function()
  Snacks.zen()
end, "Zen mode")

-- The editor itself ----------------------------------------------------------
map("n", "<leader>K", function()
  require("cheatsheet").open()
end, "Keys cheatsheet")
map("n", "<leader>l", "<cmd>Lazy<cr>", "Plugin manager")
map("n", "<leader>fn", "<cmd>enew<cr>", "New file")

-- Small comforts -------------------------------------------------------------
map("n", "<Esc>", "<cmd>nohlsearch<cr>", "Clear search highlight")
-- A wrapped line counts as one line for j and k, unless you give a count.
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("v", "<", "<gv", "Outdent and keep the selection")
map("v", ">", ">gv", "Indent and keep the selection")
