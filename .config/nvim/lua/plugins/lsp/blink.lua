return {
  {
    "blink.cmp",
    optional = true,
    opts = {
      completion = {
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },

        menu = {
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind" },
            },
          },
        },
      },

      keymap = {
        preset = "default",
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<C-j>"] = { "snippet_forward", "fallback" },
        ["<C-k>"] = { "snippet_backward", "fallback" },
        ["<C-n>"] = { "fallback" },
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

      -- Overwrite Lazy's version here because it doesn't use "local" checks
      snippets = {
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").locally_jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },
    },

    init = function()
      -- Intercept lazyvim's lsp keymaps and replace them with our own.
      require("plugins.lsp.keymaps").init()
    end,
  },
}