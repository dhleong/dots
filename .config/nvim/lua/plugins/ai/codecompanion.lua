local preferred_adapter = "anthropic"

local function get_visual_selection() -- {{{
  local mode = vim.fn.mode()
  if mode == "n" then
    return nil
  end

  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")
  local lines = vim.fn.getregion(start_pos, end_pos, { type = mode })
  return lines
end -- }}}

return {
  {
    "blink.cmp",
    optional = true,
    dependencies = {
      "codecompanion.nvim",
    },
    opts = {
      sources = {
        default = {
          "codecompanion",
        },
      },
    },
  },

  {
    "github/copilot.vim",
    lazy = true,
    cmd = {
      "Copilot",
    },
    init = function()
      -- We only want this function for Copilot setup
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_filetypes = { ["*"] = false }
    end,
  },

  {
    "olimorris/codecompanion.nvim",
    keys = {
      -- "chat window"
      { "<leader>cw", ":CodeCompanionChat Toggle<cr>" },

      {
        "<leader>cx",
        function()
          local prompt = "/explain"
          if vim.diagnostic.get(0, { lnum = vim.fn.line(".") }) then
            prompt = "/lsp"
          end
          vim.cmd.CodeCompanion(prompt)
        end,
        mode = { "n", "v" },
      },

      {
        "<leader>cc",
        function()
          local cc = require("codecompanion")

          -- If called in visual mode, we probably want to do something
          -- with it
          local selection = get_visual_selection()
          if selection then
            vim.fn.inputsave()
            local prompt = vim.fn.input({
              prompt = "Ask AI> ",
            })
            vim.fn.inputrestore()
            vim.cmd.CodeCompanion(prompt)
            return
          end

          local chat = cc:last_chat()
          if chat and chat.ui:is_active() then
            -- If we're already in there, hide it I guess
            vim.cmd.CodeCompanionChat("Toggle")
            return
          elseif chat and chat.ui:is_visible() then
            -- If it's visible but we're not in it,
            -- jump over there
            chat.ui:open()
          end

          -- Otherwise, start a chat if there isn't one, and
          -- add the #buffer as context
          if not chat then
            chat = cc.chat()
            if not chat then
              return
            end
          end

          local config = require("codecompanion.config")
          chat:add_buf_message({
            role = config.constants.USER_ROLE,
            content = "#buffer\n\n",
          })
          chat.ui:open()
        end,
        mode = { "n", "v" },
      },
    },
    opts = {
      display = {
        chat = {
          show_token_count = false,
          start_in_insert_mode = true,
        },
      },
      strategies = {
        chat = {
          adapter = preferred_adapter,
          keymaps = {
            send = {
              -- Just send on enter
              modes = {
                n = { "<c-s>", "<cr>" },
                i = { "<c-s>", "<cr>" },
              },
            },

            next_chat = {
              modes = { n = "]c" },
            },
            previous_chat = {
              modes = { n = "[c" },
            },

            hide = {
              callback = function()
                vim.cmd.CodeCompanionChat("Toggle")
              end,
              modes = { n = "q" },
            },
          },
        },

        inline = {
          adapter = preferred_adapter,
        },
      },
    },
  },
}
