-- Treesitter parses the file into a syntax tree. Two things depend on it:
-- the colour scheme, which paints by what a symbol *is* rather than by
-- pattern match, and the af/if text objects below.
--
-- This is the `main` branch of nvim-treesitter, which dropped the old module
-- system. Parsers install once into stdpath("data")/site/parser; highlighting
-- starts per buffer in the autocmd.
local languages = {
  "bash",
  "diff",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "json",
  "kotlin",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "nix",
  "query",
  "toml",
  "vim",
  "vimdoc",
  "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({})

      local installed = require("nvim-treesitter.config").get_installed()
      local missing = vim.tbl_filter(function(language)
        return not vim.tbl_contains(installed, language)
      end, languages)
      if #missing > 0 then
        require("nvim-treesitter").install(missing)
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(event)
          local language = vim.treesitter.language.get_lang(event.match)
          if language and vim.treesitter.language.add(language) then
            vim.treesitter.start(event.buf, language)
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- af / if select a whole function or its body. ac / ic do the same for a
  -- class or struct. These are the two that pay for themselves in Go.
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    opts = { select = { lookahead = true } },
  },

  -- Pin the enclosing function to the top of the window when it scrolls off.
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = { max_lines = 3, multiline_threshold = 1 },
  },
}
