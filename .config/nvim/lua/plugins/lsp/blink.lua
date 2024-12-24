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
      },
    },
  },
}
