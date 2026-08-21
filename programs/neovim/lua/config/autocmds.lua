-- Behaviour that hangs off an event rather than a key.
local function augroup(name)
  return vim.api.nvim_create_augroup("ben_" .. name, { clear = true })
end

-- Flash the text you just yanked, so you can see what went to the register.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("yank_highlight"),
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

-- Reopen a file on the line you left it.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_position"),
  callback = function(event)
    local line = vim.api.nvim_buf_get_mark(event.buf, '"')[1]
    if line > 1 and line <= vim.api.nvim_buf_line_count(event.buf) then
      vim.cmd('normal! g`"zz')
    end
  end,
})

-- Prose wants wrapping and a spell check; code does not.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("prose"),
  pattern = { "markdown", "gitcommit", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.linebreak = true
  end,
})

-- Close scratch and help windows with q, the way every other panel closes.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("quick_close"),
  pattern = { "help", "qf", "checkhealth", "lspinfo", "trouble" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Light the cursor line in the window you are actually in, and nowhere else.
-- Without this the line stays lit in every window at once, so opening a float
-- leaves a bright row glowing behind it and the cursor looks lost.
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  group = augroup("cursorline_follows_focus"),
  callback = function()
    if vim.bo.buftype == "" then
      vim.wo.cursorline = true
    end
  end,
})

-- Only ordinary file windows. Plugin windows use the cursor line to mean
-- something else -- the snacks picker draws its selection with it -- so
-- leaving one must not switch it off.
vim.api.nvim_create_autocmd("WinLeave", {
  group = augroup("cursorline_leaves"),
  callback = function()
    if vim.bo.buftype == "" then
      vim.wo.cursorline = false
    end
  end,
})
