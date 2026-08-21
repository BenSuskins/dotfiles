-- LazyVim sends `gr` to a picker that closes on the first pick. That suits
-- "jump to the one usage I want" and fights "read all fourteen", which is the
-- job GoLand's Find Usages panel does. Trouble is already installed and keeps
-- the list open while you step through it.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            {
              "gr",
              "<cmd>Trouble lsp_references toggle focus=true<cr>",
              desc = "References (Trouble)",
              nowait = true,
            },
          },
        },
      },
    },
  },
}
