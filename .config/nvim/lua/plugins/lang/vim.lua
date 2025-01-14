return {
  { "tpope/vim-scriptease", ft = "vim", cmd = { "Messages" } },
  { "junegunn/vader.vim", ft = "vader" },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
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
