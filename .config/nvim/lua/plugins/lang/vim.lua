return {
  { "tpope/vim-scriptease", ft = "vim", cmd = { "Messages" } },
  { "junegunn/vader.vim", ft = "vader" },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          keys = {
            { "gK", vim.lsp.buf.hover, desc = "LSP hover" },
          },
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      },
    },
  },
}
