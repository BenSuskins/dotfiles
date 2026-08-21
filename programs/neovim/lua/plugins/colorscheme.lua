-- IntelliJ IDEA New UI Dark, sampled pixel by pixel from a GoLand window.
-- The same palette drives the terminal in programs/ghostty/config, so the
-- editor, the shell, and the starship prompt all agree.
--
-- IntelliJ paints variables and types in plain foreground rather than giving
-- each one a colour. base08 and base0A follow that, which is what makes the
-- editor read calmly.
local palette = {
  base00 = "#191a1d", -- background
  base01 = "#212226", -- cursor line, float background
  base02 = "#33353a", -- selection
  base03 = "#7a7e85", -- comments
  base04 = "#9da0a8", -- dim foreground
  base05 = "#bcbec4", -- foreground
  base06 = "#dfe1e5", -- bright foreground
  base07 = "#ffffff",
  base08 = "#bcbec4", -- variables
  base09 = "#2aacb8", -- numbers
  base0A = "#bcbec4", -- types
  base0B = "#6aab73", -- strings
  base0C = "#2aacb8", -- escapes
  base0D = "#56a8f5", -- functions
  base0E = "#cf8e6d", -- keywords
  base0F = "#c77dbb", -- constants
}

local function apply()
  require("mini.base16").setup({ palette = palette })
  vim.g.colors_name = "intellij"

  -- Groups base16 derives differently from how IntelliJ paints them.
  local overrides = {
    LineNr = { fg = "#4b5059" },
    Comment = { fg = "#7a7e85", italic = true },
    DiagnosticError = { fg = "#f75464" },
    DiagnosticWarn = { fg = "#cf8e6d" },
    DiagnosticInfo = { fg = "#56a8f5" },
    DiagnosticHint = { fg = "#7a7e85" },
  }
  for group, opts in pairs(overrides) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

return {
  { "echasnovski/mini.base16" },
  { "LazyVim/LazyVim", opts = { colorscheme = apply } },
}
