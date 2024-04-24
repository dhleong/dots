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

      -- Having Gbrowse declared but a no-op can make it kinda annoying
      -- to actually get to GBrowse
      pcall(vim.api.nvim_del_user_command, "Gbrowse")
    end,
  },

  {
    "dhleong/lilium",
    dev = true,
    ft = "gitcommit",
    lazy = true,
    event = "VeryLazy",
    cmd = {
      "LiliumInfo",
      -- "GBrowse",  -- Sadly, doing this doesn't work
    },
    dependencies = {
      "tpope/vim-fugitive",
    },
    opts = {},
  },
}
