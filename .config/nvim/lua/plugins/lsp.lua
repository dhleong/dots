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
    "blink.cmp",
    optional = true,
    opts = {
      keymap = {
        preset = "default",
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
        ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
    },
  },

  {
    import = "plugins.lsp.cmp",
    enabled = function()
      return LazyVim.cmp_engine() == "nvim-cmp"
    end,
  },
}
