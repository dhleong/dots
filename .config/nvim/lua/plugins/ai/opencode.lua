local function opencode_command(cmd)
  return function()
    require("opencode").command(cmd)
  end
end

return {
  {
    "NickvanDyke/opencode.nvim",
    keys = {
      -- "chat window"
      {
        "<leader>cw",
        function()
          require("opencode").toggle()
        end,
      },
      {
        "<leader>cx",
        function()
          local prompt
          if vim.diagnostic.get(0, { lnum = vim.fn.line(".") }) then
            prompt = "Explain @diagnostics"
          else
            prompt = "Explain @this"
          end
          require("opencode").prompt(prompt, { submit = true })
        end,
      },
      {
        "<leader>cc",
        function()
          require("opencode").ask("@this: ", { submit = true })
        end,
      },
      {
        "<c-b>",
        opencode_command("session.half.page.up"),
        mode = "t",
        ft = "opencode_terminal",
      },
      {
        "<c-f>",
        opencode_command("session.half.page.down"),
        mode = "t",
        ft = "opencode_terminal",
      },
    },
    config = function()
      vim.g.opencode_opts = {
        -- ?
      }

      vim.api.nvim_create_autocmd({ "WinLeave" }, {
        pattern = { "*:opencode" },
        callback = function()
          if vim.bo.filetype == "opencode_terminal" then
            require("opencode").toggle()
          end
        end,
      })
    end,
  },
}
