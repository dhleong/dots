require 'nvim-treesitter.configs'.setup {
  ensure_installed = 'all',

  highlight = {
    enable = true,

    -- Highlighting hangs the entire editor in very large python files
    disable = { 'python' },

    additional_vim_regex_highlighting = {
      -- For endwise compat:
      'elixir', 'lua', 'ruby', 'vim',

      -- To colorize css files
      'css',

      -- These just don't look good by default:
      'clojure',
    },
  },

  indent = {
    enable = true,
    disable = { 'css', 'gdscript', 'lua', 'rust', 'python' },
  },

  -- Plugins:

  autotag = {
    enable = true,
  },

  -- context_commentstring = {
  --   enable = true,
  -- },

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

require('ts_context_commentstring').setup {}

vim.g.skip_ts_context_commentstring_module = true
