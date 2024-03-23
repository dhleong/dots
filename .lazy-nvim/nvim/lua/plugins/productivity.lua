return {
  { dir = "~/work/otsukare" },

  { "tpope/vim-obsession" },

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
