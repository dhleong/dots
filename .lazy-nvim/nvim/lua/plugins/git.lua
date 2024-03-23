return {
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    config = function()
      vim.cmd.source("~/.vim/init/github.vim")
    end,
  },
  { "tpope/vim-rhubarb", event = "VeryLazy" },

  { dir = "~/git/lilium", event = "VeryLazy" },
}
