-- Names for the snacks explorer actions the generic rule below renders badly:
-- `explorer_del` becomes "Del", and `tcd` stays "Tcd". Anything not listed
-- here falls through to the rule, which is right for most of them.
local action_names = {
  confirm = "Open",
  explorer_add = "New file or folder",
  explorer_close = "Collapse folder",
  explorer_close_all = "Collapse everything",
  explorer_del = "Delete",
  explorer_focus = "Treat this folder as the root",
  explorer_open = "Open in the system application",
  explorer_up = "Parent folder",
  explorer_update = "Refresh",
  picker_grep = "Grep inside this folder",
  tcd = "Set the working directory here",
  toggle_hidden = "Toggle hidden files",
  toggle_ignored = "Toggle ignored files",
}

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

      replace = {
        desc = {
          -- snacks binds every explorer key to a raw action name, so the panel
          -- reads `explorer_del` and `picker_grep` while the tree has focus.
          -- Turn those into words. Only all-lowercase names are touched, and
          -- the group names above are written capitalised for that reason:
          -- what is written in this file is what the panel shows.
          function(desc)
            if action_names[desc] then
              return action_names[desc]
            end
            if not desc:match("^[%l%d_]+$") then
              return desc
            end
            local text = desc:gsub("^explorer_", ""):gsub("^picker_", ""):gsub("_", " ")
            return text:sub(1, 1):upper() .. text:sub(2)
          end,
          -- which-key's own rules. They are listed again because a table in
          -- `opts` replaces the default outright rather than adding to it.
          { "<Plug>%(?(.*)%)?", "%1" },
          { "^%+", "" },
          { "<[cC]md>", "" },
          { "<[cC][rR]>", "" },
          { "<[sS]ilent>", "" },
          { "^lua%s+", "" },
          { "^call%s+", "" },
          { "^:%s*", "" },
        },
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
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "File" },
        { "<leader>g", group = "Git" },
        { "<leader>gh", group = "Hunk" },
        { "<leader>q", group = "Session" },
        { "<leader>s", group = "Search" },
        { "<leader>u", group = "Toggle" },
        { "<leader>x", group = "Diagnostics" },
      },
    },
  },
}
