-- Ghostty runs the "snazzy" palette, which derives from Dracula.
-- Pin the background to Snazzy's own value so the editor and the shell match.
return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      colors = {
        bg = "#1e1f29",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },
}
