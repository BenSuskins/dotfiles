-- The live twin of lua/cheatsheet.lua: same centred rounded float, same key
-- column and │ separator, same absence of icons. <leader>K is the document you
-- read once; this is the reminder you get while your finger is already down.
--
-- The default `classic` preset draws a full-width strip across the bottom with
-- no border, which spreads twenty entries over six columns and reads as noise.
return {
  {
    "folke/which-key.nvim",
    opts = {
      preset = "modern",
      delay = 400,

      win = {
        -- Capped, not proportional. The width decides the column count, so a
        -- fraction of a wide terminal spreads the panel back over six columns.
        -- 76 is the cheatsheet's 66 plus its border and padding.
        width = { min = 40, max = 76 },
        height = { min = 4, max = 25 },
        col = 0.5,
        border = "rounded",
        title = true,
        title_pos = "center",
        padding = { 1, 2 },
      },
      layout = { width = { min = 22 }, spacing = 2 },

      icons = {
        -- The cheatsheet has no icons and no + before a group. A row is a key,
        -- a separator, and a description; every row the same shape.
        mappings = false,
        separator = "│",
        group = "",
      },

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

      -- Every prefix that owns more than one key needs a name here, or the
      -- panel shows "+1 keymap" instead of telling you what lives under it.
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "file" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunk" },
        { "<leader>q", group = "session" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "toggle" },
        { "<leader>x", group = "diagnostics" },
      },
    },
  },
}
