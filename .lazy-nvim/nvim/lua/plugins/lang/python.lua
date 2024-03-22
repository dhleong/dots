return {
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
                  reportSelfClsParameterName = 'off',
                },
              },
            },
          },
        },
      },
    },
  }
}
