return {
  { dir = "~/work/otsukare" },

  { "tpope/vim-obsession" },

  {
    "todo-comments.nvim",
    opts = {
      signs = false,
    },
  },

  {
    "nvim-treesitter-context",
    -- NOTE: Before 0.10 nvim has a bug where it complains about
    -- nvim_win_close when you try to open the cmdline window
    -- while context is showing.
    enabled = vim.fn.has("nvim-0.10") == 1,
  },

  {
    "dhleong/trot.nvim",
    keys = {
      {
        "<leader>K",
        function()
          require("trot").search()
        end,
        desc = "Search in Dash",
      },
    },
  },
}
