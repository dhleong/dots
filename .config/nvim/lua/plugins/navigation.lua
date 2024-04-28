return {
  -- {
  --   "tpope/vim-vinegar",
  --   keys = {
  --     { "-", "<Plug>VinegarUp" },
  --   },
  -- },

  {
    "stevearc/oil.nvim",
    keys = {
      { "-", "<cmd>Oil<cr>" },
    },
    opts = {
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-r>"] = "actions.refresh",
      },
    },
    init = function()
      -- If any of the files in the arglist were directories, ensure that
      -- oil.nvim is loaded so we can view them properly!
      for _, f in ipairs(vim.fn.argv()) do
        if vim.fn.isdirectory(f) == 1 then
          require("lazy").load({ plugins = { "oil.nvim" } })
          break
        end
      end
    end,
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

        -- By default, flash will try to repeat the motion when you type `f`, but
        -- I often do something like `fhdf.` to jump to an `h` and delete to the period,
        -- for example. With the default behavior, the `df` would delete to the next `h`
        -- which is unexpected. We have `;` and `,` to do that, if we want
        char = {
          char_actions = function(_)
            -- See :help flash.nvim-flash.nvim-configuration for more info
            return {
              [";"] = "next",
              [","] = "prev",
            }
          end,
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
