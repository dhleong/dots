require'nvim-treesitter.configs'.setup {
  ensure_installed = 'maintained',

  highlight = {
    enable = true,

    additional_vim_regex_highlighting = {
      -- For endwise compat:
      'elixir', 'lua', 'ruby', 'vim',
    },
  },

  indent = {
    enable = true,
  },

  -- Plugins:

  context_commentstring = {
    enable = true
  },

  textsubjects = {
    enable = true,
    keymaps = {
      ['i;'] = 'textsubjects-smart',
      ['a;'] = 'textsubjects-container-outer',
    }
  },
}
