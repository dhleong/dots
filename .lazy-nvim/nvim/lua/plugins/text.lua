return {
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
