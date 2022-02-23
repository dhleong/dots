require'nvim-treesitter.configs'.setup {
  ensure_installed = 'maintained',

  highlight = {
    enable = true,

    additional_vim_regex_highlighting = {
      -- For endwise compat:
      'elixir', 'lua', 'ruby', 'vim',

      -- To colorize css files
      'css',
    },
  },

  indent = {
    enable = true,
    disable = { 'css', 'lua', 'rust', 'python' },
  },

  -- Plugins:

  autotag = {
    enable = true,
  },

  context_commentstring = {
    enable = true,
  },

  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
      },
    },
  },

  textsubjects = {
    enable = true,
    keymaps = {
      ['i;'] = 'textsubjects-smart',
      ['a;'] = 'textsubjects-container-outer',
    }
  },
}
