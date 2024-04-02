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
  { "tpope/vim-rhubarb", event = "VeryLazy" },

  { dir = "~/git/lilium", event = "VeryLazy" },
}
