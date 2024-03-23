return {
  { "tpope/vim-vinegar", event = "VeryLazy" },
  {
    "junegunn/fzf",
    build = "./install --bin",
    event = "VeryLazy",
  },
  { "junegunn/fzf.vim", lazy = true },
  {
    dir = ".",
    event = "VeryLazy",
    name = "My projects",
    config = function()
      require("dhleong.projects").init()
    end,
  },

  {
    "flash.nvim",
    opts = {
      modes = {
        search = {
          enabled = false,
        },
      },
    },
    keys = {
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").jump()
        end,
        desc = "Flash reverse",
      },
    },
  },
}
