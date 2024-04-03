return {
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    keys = {
      -- "Git no-verify commit"
      { "<leader>gnc", ":Git commit -a --no-verify<cr>" },
    },
    config = function()
      vim.cmd.source("~/.vim/init/github.vim")
    end,
  },

  {
    dir = "~/git/lilium",
    ft = "gitcommit",
    lazy = true,
    cmd = {
      "LiliumInfo",
      "GBrowse",
    },
    opts = {},
  },
}
