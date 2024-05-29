return {
  { "ap/vim-css-color", ft = { "css", "tsx" } },
  { "dhleong/vim-hyperstyle", ft = "css" },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        stylelint_lsp = {
          filetypes = { "css", "less" },
        },
      },
    },
  },

  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        css = { "prettier" },
      },
    },
  },
}
