return {
  {
    "blink.cmp",
    optional = true,
    opts = {
      completion = {
        list = {
          selection = "auto_insert",
        },
      },

      keymap = {
        preset = "default",
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
        ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["("] = { "accept", "fallback" },
        ["."] = {
          function(cmp)
            return cmp.accept({
              callback = function()
                vim.api.nvim_feedkeys(".", "i", false)
              end,
            })
          end,
          "fallback",
        },
      },
    },

    init = function()
      -- Intercept lazyvim's lsp keymaps and replace them with our own.
      require("plugins.lsp.keymaps").init()
    end,
  },
}
