local function select_current_entry() -- {{{
  local oil = require("oil")
  local entry = oil.get_cursor_entry()

  if vim.fn.mode() == "i" then
    -- Leave insert mode so we can immediately press `y` or `n` in the
    -- modal that pops up
    vim.cmd.stopinsert()
  end

  if not entry or entry.id then
    -- Normal behavior
    oil.select()
  else
    -- Save first and open the file that was (probably) "pending"
    -- This lets us created a file in a nested path and open it
    -- directly
    local oil_bufnr = vim.api.nvim_get_current_buf()
    oil.save({ confirm = true }, function()
      -- Hackily borrowed from oil. Would be nice if we could
      -- just pass an entry to select()
      local util = require("oil.util")
      local config = require("oil.config")
      util.get_edit_path(oil_bufnr, entry, function(normalized_url)
        local filebufnr = vim.fn.bufadd(normalized_url)
        local entry_is_file = not vim.endswith(normalized_url, "/")

        if entry_is_file or config.buf_options.buflisted then
          vim.bo[filebufnr].buflisted = true
        end

        vim.cmd.buffer({ filebufnr, mods = {
          keepalt = true,
        } })
      end)
    end)
  end
end -- }}}

return {
  {
    "stevearc/oil.nvim",
    keys = {
      { "-", "<cmd>Oil<cr>" },
    },
    lazy = false,
    opts = {
      -- Disable the icon column:
      columns = {},
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-r>"] = "actions.refresh",
        ["<CR>"] = {
          callback = select_current_entry,
          mode = { "i", "n" },
        },
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
    init = function()
      vim.g.fzf_colors = {
        ["bg+"] = { "bg", "Visual" },
        ["pointer"] = { "fg", "SpecialComment", "StatusLine" },
      }
    end,
  },

  {
    "fzf-lua",
    enabled = vim.g.lazyvim_picker == "fzf",
    -- LazyVim adds a bunch of mappings I don't want by default.
    -- Let's pick and choose
    keys = function(_, old)
      local function old_mapping_for(keys)
        for _, map in ipairs(old) do
          if map[1] == keys then
            return map[2]
          end
        end
      end

      return {
        -- "LSP symbols"
        {
          "<leader>ls",
          old_mapping_for("<leader>sS"),
          desc = "LSP Symbols",
        },
      }
    end,
    opts = {
      keymap = {
        -- Disable bulitin keybinds
        builtin = { false },
        fzf = { false },
      },
      winopts = {
        preview = {
          -- Defaults to 100; I prefer the vertical layout unless I have a *lot* of room!
          flip_columns = 200,
          vertical = "up:35%",
        },
      },
      fzf_opts = {
        ["--cycle"] = true,
      },
    },
  },

  {
    dir = "~/.old-nvim/nvim/lua/dhleong",
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
          -- This behavior is kinda broken. Example:
          --    write_killswitch = write_killswitch
          -- If you try to change `write` to `delete` with `cfe delete fw .`
          -- the dot-repeat will instead do a `cfw` instead of `cfe`...
          enabled = false,

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
