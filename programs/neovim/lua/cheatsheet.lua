-- The keys are all there; knowing they exist is the hard part. This is the
-- same sheet as `keys` in modules/shared/zsh/functions.sh -- sections, a key
-- column, a description column -- for Neovim instead of Ghostty.
--
-- Every row here is bound in lua/config/keymaps.lua, and every key in that
-- file is a row here. Change one, change the other.
--
-- Open it with <leader>K.
local sections = {
  {
    "Code navigation",
    {
      { "gd", "Go to definition" },
      { "gI", "Go to implementation" },
      { "gy", "Go to type definition" },
      { "gr", "Find references (opens Trouble)" },
      { "K", "Hover documentation" },
      { "<leader>ca", "Code action" },
      { "<leader>cr", "Rename symbol" },
      { "<leader>cf", "Format buffer" },
      { "]] / [[", "Next / previous use of this word" },
      { "<C-o> / <C-i>", "Jump back / forward" },
      { "af / if", "Select a function / its body" },
    },
  },
  {
    "Files and search",
    {
      { "<leader><space>", "Find file in project" },
      { "<leader>/", "Grep across project" },
      { "<leader>,", "Switch buffer" },
      { "<leader>e", "File explorer" },
      { "<leader>ss", "Symbols in this file" },
      { "<leader>sr", "Search and replace across files" },
      { "<leader>st", "TODO comments" },
      { "<leader>sh", "Search the help" },
      { "<leader>sk", "Search the keymaps" },
      { "s", "Flash jump to any visible spot" },
    },
  },
  {
    "Markdown",
    {
      { "<leader>um", "Toggle in-buffer rendering" },
      { "<leader>uc", "Toggle conceal, to see raw markup" },
      { "<leader>ss", "Jump to a heading" },
      { "<leader>z", "Zen mode, one centred column" },
    },
  },
  {
    "Git and diagnostics",
    {
      { "]h / [h", "Next / previous change" },
      { "<leader>ghs", "Stage hunk" },
      { "<leader>ghr", "Reset hunk" },
      { "<leader>ghp", "Preview hunk" },
      { "<leader>ghb", "Blame line" },
      { "]d / [d", "Next / previous diagnostic" },
      { "<leader>cd", "Show diagnostic for this line" },
      { "<leader>xx", "All diagnostics in Trouble" },
    },
  },
  {
    "The editor",
    {
      { "<leader>K", "This sheet" },
      { "<leader>.", "Scratch buffer for this project" },
      { "<leader>qs", "Restore the last session here" },
      { "<leader>bd", "Close buffer, keep the window" },
      { "<leader>l", "Plugin manager" },
    },
  },
}
-- `add` returns the 0-based index of the line it just appended, and `mark`
-- takes that index. The two used to be coupled through #lines, which pointed
-- at the wrong line whenever a blank line followed the one being highlighted.
local function render()
  local width = 60
  local lines, marks = {}, {}

  local function add(text)
    lines[#lines + 1] = text
    return #lines - 1
  end

  local function mark(line, group, from, to)
    marks[#marks + 1] = { line = line, group = group, from = from, to = to }
  end

  add("")
  mark(add("  Neovim Keys"), "Title", 2, 13)
  mark(add("  " .. string.rep("═", width)), "Comment", 0, -1)
  add("")

  for _, section in ipairs(sections) do
    local title, rows = section[1], section[2]
    mark(add("  " .. title), "Statement", 2, 2 + #title)
    mark(add("  " .. string.rep("─", width)), "Comment", 0, -1)

    for _, row in ipairs(rows) do
      local key, description = row[1], row[2]
      local line = add(string.format("  %-22s │ %s", key, description))
      mark(line, "Type", 2, 24)
      mark(line, "Comment", 24, 24 + #" │")
    end
    add("")
  end

  return lines, marks
end

local function open()
  local lines, marks = render()
  local buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)

  -- Columns are byte offsets, and the box-drawing characters are three bytes
  -- each. Clamp every mark to the line it sits on rather than trusting the
  -- arithmetic above.
  local namespace = vim.api.nvim_create_namespace("cheatsheet")
  for _, m in ipairs(marks) do
    local length = #lines[m.line + 1]
    local from = math.min(m.from, length)
    local to = m.to < 0 and length or math.min(m.to, length)
    if to > from then
      vim.api.nvim_buf_set_extmark(buffer, namespace, m.line, from, {
        end_col = to,
        hl_group = m.group,
      })
    end
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

return { open = open }
