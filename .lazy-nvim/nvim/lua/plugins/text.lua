return {
  {
    "LuaSnip",
    keys = {
      {
        "<s-tab>",
        function()
          if require("luasnip").jumpable(-1) then
            return "<Plug>luasnip-jump-prev"
          elseif vim.fn.pumvisible() == 1 then
            return "<c-p>"
          else
            return "<c-d>"
          end
        end,
        expr = true,
        silent = true,
        mode = { "i" },
      },
    },
  },

  -- visual-mode number incrementing
  { "vim-scripts/VisIncr", event = "VeryLazy" },

  { "tommcdo/vim-exchange", event = "VeryLazy" },
  { "tpope/vim-commentary", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "tpope/vim-sleuth", event = "VeryLazy" },
  { "tpope/vim-surround", event = "VeryLazy" },

  {
    "tpope/vim-endwise",
    event = "VeryLazy",
    init = function()
      -- we manually map in mappings.vim to avoid breaking other <cr> map
      -- augmentations, like hyperstyle
      vim.g.endwise_no_mappings = 1
    end,
  },

  -- Convert between single-line and wrapped argument lists
  {
    "FooSoft/vim-argwrap",
    keys = {
      { "<leader>aw", ":ArgWrap<cr>" },
    },
  },
}
