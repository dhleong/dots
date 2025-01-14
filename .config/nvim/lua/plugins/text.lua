return {
  {
    "LuaSnip",
    keys = {
      -- These two are configured as part of nvim-cmp in lsp.lua,
      -- to avoid tab not working correctly on a cold start
      { "<tab>", false, mode = { "i", "s" } },
      { "<s-tab>", false, mode = { "i", "s" } },

      -- If we used a cmp completion to fill a snippet
      -- placeholder, we need a more convenient way to jump to
      -- the next placeholder without leaving insert and coming back in
      {
        "<c-j>",
        function()
          if require("luasnip").jumpable(1) then
            return "<Plug>luasnip-jump-next"
          else
            return "<c-j>"
          end
        end,
        expr = true,
        silent = true,
        mode = { "i" },
      },
    },

    opts = {
      update_events = {
        "TextChanged",
        "TextChangedI",
      },
    },

    cmd = "SnipEdit",

    config = function(_, opts)
      -- Is there a better place to set up commands?
      vim.api.nvim_create_user_command("SnipEdit", function(args)
        require("luasnip.loaders").edit_snippet_files()
      end, {})

      require("luasnip").setup(opts)

      require("luasnip.loaders.from_lua").load()
    end,
  },

  -- visual-mode number incrementing
  { "vim-scripts/VisIncr", event = "VeryLazy" },

  { "tommcdo/vim-exchange", event = "VeryLazy" },
  { "tpope/vim-commentary", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "tpope/vim-sleuth", event = "VeryLazy" },
  { "tpope/vim-surround", event = "VeryLazy" },

  -- Replaces my old tpope/vim-endwise plugin, since endwise requires regex syntax enabled
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      -- NOTE: RRethy is canonical, but might be abandoned? It hasn't been updated to
      -- fix an incompatibility despite an open PR...
      -- "RRethy/nvim-treesitter-endwise",
      "metiulekm/nvim-treesitter-endwise",
    },
    opts = {
      endwise = {
        enable = true,
      },
    },
  },

  -- Convert between single-line and wrapped argument lists
  {
    "FooSoft/vim-argwrap",
    keys = {
      { "<leader>aw", ":ArgWrap<cr>" },
    },
  },
}
