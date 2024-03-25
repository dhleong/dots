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
