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
      return LazyVim.cmp_engine() == "blink.cmp"
    end,
  },
  {
    import = "plugins.lsp.cmp",
    enabled = function()
      return LazyVim.cmp_engine() == "nvim-cmp"
    end,
  },
}
