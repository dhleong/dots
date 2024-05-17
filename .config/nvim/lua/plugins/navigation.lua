return {
  {
    "stevearc/oil.nvim",
    opts = {
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-r>"] = "actions.refresh",
        ["%"] = function()
          local filename = vim.fn.input("Enter filename: ")
          if filename ~= "" then
            require("oil.actions").cd.callback()
            local dir = require("oil").get_current_dir()
            vim.cmd.edit(dir .. "/" .. filename)
          end
        end,
      },
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
