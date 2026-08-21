-- A statusline in the same spirit as the starship prompt: no separators, and
-- colour only where it carries meaning. Invariant ships a lifted StatusLine;
-- this keeps the bar the same colour as the buffer so the eye only sees text.
--
-- The mode is the one place colour earns its keep. LazyVim sets
-- showmode = false on the assumption the statusline reports it, so without
-- this block nothing on screen names the mode at all.
--
-- The mode reads as coloured text rather than a filled block: the colour
-- carries the meaning, and a solid slab at the left edge would be the only
-- heavy thing on an otherwise flat bar.
return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local flat = { fg = "#7b7468", bg = "#191a1c" }
      local modes = {
        normal = "#cfbfad",
        insert = "#a7ec21",
        visual = "#fd971f",
        replace = "#ff6b68",
        command = "#ece47e",
        inactive = "#7b7468",
      }

      local theme = {}
      for mode, colour in pairs(modes) do
        theme[mode] = {
          a = { fg = colour, bg = flat.bg, gui = "bold" },
          b = flat,
          c = flat,
        }
      end

      return {
        options = {
          theme = theme,
          globalstatus = true,
          component_separators = "",
          section_separators = "",
          disabled_filetypes = { statusline = { "dashboard", "snacks_dashboard" } },
        },
        sections = {
          lualine_a = { { "mode", padding = { left = 1, right = 2 } } },
          lualine_b = {},
          lualine_c = {
            { "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "" } },
          },
          lualine_x = {
            "diagnostics",
            { "branch", icon = "" },
          },
          lualine_y = {},
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { "filename", path = 1 } },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "lazy" },
      }
    end,
  },
}
