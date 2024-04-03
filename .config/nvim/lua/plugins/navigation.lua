return {
  {
    "tpope/vim-vinegar",
    keys = {
      { "-", "<Plug>VinegarUp" },
    },
  },

  {
    "junegunn/fzf",
    build = "./install --bin",
    event = "VeryLazy",
  },
  {
    "junegunn/fzf.vim",
    lazy = true,
    init = function()
      vim.g.fzf_colors = {
        ["bg+"] = { "bg", "Visual" },
        ["pointer"] = { "fg", "SpecialComment", "StatusLine" },
      }
    end,
  },

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
      search = {
        -- Multi-window makes it harder for autojump to trigger...
        multi_window = false,
      },
      jump = {
        autojump = true,
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
