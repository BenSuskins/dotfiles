-- A statusline in the same spirit as the starship prompt: no separators,
-- no mode block, and colour only where it carries meaning. Invariant ships a
-- lifted StatusLine; this keeps the bar the same colour as the buffer so the
-- eye only sees the text.
return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local flat = { fg = "#7b7468", bg = "#191a1c" }
      local theme = {}
      for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "inactive" }) do
        theme[mode] = { a = flat, b = flat, c = flat }
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
          lualine_a = {},
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
