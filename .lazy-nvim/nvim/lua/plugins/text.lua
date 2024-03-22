return {
  -- visual-mode number incrementing
  { 'vim-scripts/VisIncr' },

  { 'tommcdo/vim-exchange' },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-sleuth' },
  { 'tpope/vim-surround' },

  -- Convert between single-line and wrapped argument lists
  {
    'FooSoft/vim-argwrap',
    keys = {
      { '<leader>aw', ':ArgWrap<cr>' },
    }
  },
}
