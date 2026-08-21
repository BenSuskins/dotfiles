-- The keys are all there; knowing they exist is the hard part. This is the
-- same sheet as `keys` in modules/shared/zsh/functions.sh — sections, a key
-- column, a description column — for Neovim instead of Ghostty.
--
-- Hand-written on purpose. Generating it from the live keymap table would
-- never go stale, but it would list two hundred keys when the point is the
-- twenty that matter. Add a row when you learn one worth keeping.
--
-- <leader>? already belongs to LazyVim's buffer-local keymap popup.
local sections = {
  {
    "Code navigation",
    {
      { "gd", "Go to definition" },
      { "gI", "Go to implementation" },
      { "gr", "Find references (opens Trouble)" },
      { "gy", "Go to type definition" },
      { "K", "Hover documentation" },
      { "<leader>ca", "Code action" },
      { "<leader>cr", "Rename symbol" },
      { "<leader>cs", "Symbols in file" },
      { "]] / [[", "Next / previous use of this word" },
      { "<C-o> / <C-i>", "Jump back / forward" },
    },
  },
  {
    "Files and search",
    {
      { "<leader><space>", "Find file in project" },
      { "<leader>/", "Grep across project" },
      { "<leader>e", "File explorer" },
      { "<leader>,", "Switch buffer" },
      { "<leader>sr", "Search and replace across files" },
      { "s", "Flash jump to any visible spot" },
    },
  },
  {
    "Markdown",
    {
      { "<leader>um", "Toggle in-buffer rendering" },
      { "<leader>uc", "Toggle conceal, to see raw markup" },
      { "<leader>ss", "Jump to a heading" },
      { ":MarkdownPreview", "Open the browser preview" },
    },
  },
  {
    "Git and diagnostics",
    {
      { "]h / [h", "Next / previous change" },
      { "<leader>ghs", "Stage hunk" },
      { "<leader>ghr", "Reset hunk" },
      { "<leader>ghb", "Blame line" },
      { "]d / [d", "Next / previous diagnostic" },
      { "<leader>cd", "Show diagnostic for this line" },
      { "<leader>xx", "All diagnostics in Trouble" },
      { "<leader>st", "Search TODO comments" },
    },
  },
}

local function render()
  local width = 60
  local lines = { "", "  Neovim Keys", "  " .. string.rep("═", width), "" }
  local marks = {}

  local function mark(group, column)
    marks[#marks + 1] = { line = #lines - 1, group = group, column = column }
  end

  mark("Title", { 2, 13 })

  for _, section in ipairs(sections) do
    local title, rows = section[1], section[2]
    lines[#lines + 1] = "  " .. title
    mark("Statement", { 2, 2 + #title })
    lines[#lines + 1] = "  " .. string.rep("─", width)
    mark("Comment", { 0, -1 })

    for _, row in ipairs(rows) do
      local key, description = row[1], row[2]
      lines[#lines + 1] = string.format("  %-22s │ %s", key, description)
      mark("Type", { 2, 24 })
      mark("Comment", { 24, 27 })
    end
    lines[#lines + 1] = ""
  end

  return lines, marks
end

local function open()
  local lines, marks = render()
  local buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)

  local namespace = vim.api.nvim_create_namespace("cheatsheet")
  for _, m in ipairs(marks) do
    vim.api.nvim_buf_set_extmark(buffer, namespace, m.line, m.column[1], {
      end_col = m.column[2] < 0 and #lines[m.line + 1] or m.column[2],
      hl_group = m.group,
    })
  end

  vim.bo[buffer].modifiable = false
  vim.bo[buffer].filetype = "cheatsheet"

  local height = math.min(#lines, math.floor(vim.o.lines * 0.8))
  local window = vim.api.nvim_open_win(buffer, true, {
    relative = "editor",
    width = 66,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - 66) / 2),
    style = "minimal",
    border = "rounded",
    title = " Keys ",
    title_pos = "center",
  })
  vim.wo[window].cursorline = false

  for _, key in ipairs({ "q", "<Esc>" }) do
    vim.keymap.set("n", key, "<cmd>close<cr>", { buffer = buffer, nowait = true })
  end
end

return {
  {
    "folke/which-key.nvim",
    optional = true,
    keys = {
      { "<leader>K", open, desc = "Keys cheatsheet" },
    },
  },
}
