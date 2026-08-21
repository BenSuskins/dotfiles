-- Markdown renders in the buffer, not in a browser. <leader>um toggles it.
--
-- Headings are coloured text, not filled bars: the bar reads as a rendered
-- document, which is wrong for a file you are editing. The colours themselves
-- live in colorscheme.lua with every other highlight.
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = {
      -- Show the markup on the line the cursor sits on, hide it everywhere
      -- else. Nothing disappears from under the cursor.
      anti_conceal = { enabled = true },
      heading = {
        sign = false,
        icons = {},
        width = "block",
        backgrounds = {},
      },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
        border = "thin",
      },
      -- Checkboxes are half of what a notes file is for.
      checkbox = { enabled = true },
      bullet = { icons = { "•", "◦", "▪", "▫" } },
      quote = { icon = "▎" },
    },
  },
}
