local otsukare_dir = "~/work/otsukare"
return {
  -- {
  --   dir = otsukare_dir,
  --   import = "otsukare.lazy",
  --   cond = function()
  --     local full_path = vim.fn.expand(otsukare_dir)
  --     return vim.fn.isdirectory(full_path) == 1
  --   end,
  -- },

  { "tpope/vim-obsession" },

  {
    "todo-comments.nvim",
    opts = {
      signs = false,
    },
  },

  { import = "lazyvim.plugins.extras.ui.treesitter-context" },
  {
    "nvim-treesitter-context",
    -- NOTE: Before 0.10 nvim has a bug where it complains about
    -- nvim_win_close when you try to open the cmdline window
    -- while context is showing.
    enabled = vim.fn.has("nvim-0.10") == 1,
  },

  {
    "dhleong/trot.nvim",
    dev = true,
    keys = {
      {
        "<leader>k",
        function()
          require("trot").open_search({
            tool = "sprint",
          })
        end,
        desc = "Search in Sprint",
      },
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
