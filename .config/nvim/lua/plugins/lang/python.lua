return {
  { import = "lazyvim.plugins.extras.lang.python" },

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
