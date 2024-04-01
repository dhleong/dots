return {
  { import = "lazyvim.plugins.extras.linting.eslint" },

  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
      },
    },
  },
}
