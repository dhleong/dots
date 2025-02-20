return {
  {
    "trouble.nvim",
    opts = {
      icons = false,
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
