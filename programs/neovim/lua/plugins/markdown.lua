-- Markdown renders in the buffer, not in a browser. <leader>um toggles it.
--
-- The document is rendered; the line you are on is not. anti_conceal keeps the
-- raw markup visible under the cursor, so editing a heading or a link shows you
-- the real text while every other line stays a finished page.
--
-- Headings are an icon and coloured text, with no filled bar behind them. The
-- colours live in colorscheme.lua with every other highlight: H1 pink, H2
-- green, H3 cyan, then blue, orange, and pale blue.
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = {
      anti_conceal = { enabled = true },

      heading = {
        -- `foregrounds` colours the text; `backgrounds` is empty so nothing is
        -- filled in behind it. Both lists must be given: render-markdown draws
        -- no heading at all when it has neither an icon nor a background, which
        -- is why the `#` markers used to survive with conceallevel already 3.
        sign = false,
        position = "overlay",
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        width = "block",
        backgrounds = {},
        foregrounds = {
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
      },

      code = {
        sign = false,
        width = "block",
        right_pad = 1,
        border = "thin",
        language_name = true,
      },

      -- Checkboxes are half of what a notes file is for.
      checkbox = { enabled = true },
      bullet = { icons = { "•", "◦", "▪", "▫" } },
      quote = { icon = "▎" },

      -- A table drawn with box characters is the whole point of rendering it.
      pipe_table = { preset = "round", style = "full" },

      -- callout and link are left alone. Both are on by default, and both take
      -- a table of definitions rather than an enabled flag, so `enabled = true`
      -- is read as a malformed definition and the whole config fails to load.
    },
  },
}
