return {
  { import = "lazyvim.plugins.extras.lang.python" },

  {
    -- I don't use this, and it's whining about... something
    "venv-selector.nvim",
    enabled = false,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- NOTE: LazyVim's auto_brackets conflict with our own handling
      opts.auto_brackets = {}
    end,
  },

  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                -- logLevel = 'Trace',

                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                diagnosticSeverityOverrides = {
                  reportSelfClsParameterName = "off",
                },
              },
            },
          },
        },
      },
    },
  },
}
