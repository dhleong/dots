local function toggle_local_diagnostics()
  local bufnr = vim.fn.bufnr("%")
  vim.cmd.Trouble("diagnostics", "toggle", "filter.buf=" .. bufnr)
end

return {
  {
    "trouble.nvim",
    keys = {
      { "<leader>dd", toggle_local_diagnostics, desc = "Toggle diagnostics" },
      { "<leader>xx", toggle_local_diagnostics, desc = "Toggle diagnostics" },
    },
  },

  {
    -- LSP status overlay
    "j-hui/fidget.nvim",
    opts = {},
  },

  -- Lazy defaults to native snippets, but I like luasnip
  { import = "lazyvim.plugins.extras.coding.luasnip" },

  {
    "nvim-lspconfig",
    opts = {
      diagnostics = {
        signs = {
          text = {
            -- pyright in particular uses hints for things that are "okay"
            -- like not accessing a parameter in an abstract method.
            [vim.diagnostic.severity.HINT] = "",
          },
        },
      },
    },
  },

  {
    import = "plugins.lsp.blink",
    enabled = function()
      return not LazyVim.has_extra("coding.blink.cmp")
    end,
  },
  {
    import = "plugins.lsp.cmp",
    enabled = function()
      return LazyVim.has_extra("coding.nvim-cmp")
    end,
  },
}
