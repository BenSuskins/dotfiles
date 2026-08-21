-- Everything that shapes how you move around a file or a project.
--
-- snacks.nvim is one plugin doing six jobs: the picker, the file explorer, the
-- splash screen, the notifications, the input prompt, and the large-file
-- guard. Each is a field below, so what is on and what is off reads at a
-- glance.
-- The dashboard only calls out to GitHub when the directory is actually a
-- GitHub checkout. Elsewhere the sections vanish and nothing hits the network.
local function github_repo()
  local root = vim.fs.root(vim.fn.getcwd(), ".git")
  if not root or vim.fn.executable("gh") ~= 1 then
    return false
  end
  local remote = vim.system({ "git", "-C", root, "remote", "get-url", "origin" }):wait()
  return remote.code == 0 and remote.stdout:match("github%.com") ~= nil
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      picker = { enabled = true },
      explorer = { enabled = true },
      input = { enabled = true },

      -- Underline the other uses of the word under the cursor. ]] and [[ walk
      -- them. This is GoLand's "highlight usages in file".
      words = { enabled = true, notify_jump = false },

      -- Render pictures in the buffer. Ghostty speaks the graphics protocol,
      -- and imagemagick from the flake does the conversion.
      image = { enabled = true, doc = { inline = true, float = true } },

      -- <leader>z centres the buffer and hides the chrome. A mode you enter.
      zen = { toggles = { dim = false } },

      -- Warnings and errors only. Anything quieter belongs in :messages.
      notifier = { enabled = true, level = vim.log.levels.WARN },

      -- Off on purpose: the indentation is already visible, and a second
      -- moving element on the screen buys nothing.
      indent = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },

      dashboard = {
        preset = {
          header = [[
██████╗ ███████╗███╗   ██╗
██╔══██╗██╔════╝████╗  ██║
██████╔╝█████╗  ██╔██╗ ██║
██╔══██╗██╔══╝  ██║╚██╗██║
██████╔╝███████╗██║ ╚████║
╚═════╝ ╚══════╝╚═╝  ╚═══╝
]],
          keys = {
            { icon = " ", key = "f", desc = "Find file", action = ":lua Snacks.picker.smart()" },
            { icon = " ", key = "/", desc = "Grep", action = ":lua Snacks.picker.grep()" },
            { icon = " ", key = "r", desc = "Recent files", action = ":lua Snacks.picker.recent()" },
            { icon = " ", key = "s", desc = "Restore session", action = ":lua require('persistence').load()" },
            { icon = " ", key = "K", desc = "Keys cheatsheet", action = ":lua require('cheatsheet').open()" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        -- Naming `sections` replaces the default layout, so the header and the
        -- keys have to be listed again alongside the new panels.
        sections = {
          { section = "header" },
          {
            icon = " ",
            title = "Open Pull Requests",
            section = "terminal",
            enabled = github_repo,
            cmd = "gh pr list -L 3",
            height = 4,
            ttl = 5 * 60,
            indent = 3,
            padding = 1,
            action = function()
              vim.fn.jobstart("gh pr list --web", { detach = true })
            end,
          },
          {
            icon = " ",
            title = "Open Issues",
            section = "terminal",
            enabled = github_repo,
            cmd = "gh issue list -L 3",
            height = 4,
            ttl = 5 * 60,
            indent = 3,
            padding = 1,
            action = function()
              vim.fn.jobstart("gh issue list --web", { detach = true })
            end,
          },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },

  -- The popup that appears after <leader>. It is a reference for keys you half
  -- remember, not the place to learn them; that is <leader>K.
  {
    "folke/which-key.nvim",
    opts = {
      delay = 400,
      -- Groups first, then the loose keys. The default sorter puts groups
      -- last, which reads as noise before structure.
      sort = {
        "local",
        "order",
        function(item)
          return item.group and 0 or 1
        end,
        "alphanum",
        "mod",
      },
      spec = {
        { "<leader>c", group = "code" },
        { "<leader>g", group = "git" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "toggle" },
        { "<leader>q", group = "session" },
      },
    },
  },

  -- Press s, type two characters, land there. This replaces most f, t, and /
  -- hopping once it is in your fingers.
  { "folke/flash.nvim", opts = {} },

  -- Change marks in the gutter, and the hunk keys under <leader>gh.
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▁" },
        topdelete = { text = "▔" },
        changedelete = { text = "▎" },
      },
    },
  },

  -- The command line as a centred popup instead of a line at the bottom.
  {
    "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      lsp = { progress = { enabled = false } },
      presets = { long_message_to_split = true },
    },
  },

  -- Reopen the buffers you had last time you were in this directory.
  { "folke/persistence.nvim", opts = {} },

  -- A list that stays open while you walk it. gr sends references here.
  { "folke/trouble.nvim", cmd = "Trouble", opts = {} },

  -- Search and replace across the project, in a buffer you can edit.
  { "MagicDuck/grug-far.nvim", cmd = "GrugFar", opts = {} },

  -- TODO and FIXME get a colour and a picker.
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  -- Text objects beyond the built-ins: aa/ia for arguments, a"/i" for quotes,
  -- and the rest of the pairs. af/if for functions live in treesitter.lua.
  { "nvim-mini/mini.ai", version = false, opts = {} },
  { "nvim-mini/mini.pairs", version = false, opts = {} },
  { "nvim-mini/mini.icons", version = false, opts = {} },
}
