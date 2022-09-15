require('helpers.lsp').config('pyright', {
  update_capabilities = function(capabilities)
    -- Hacks to prevent pyright from reporting "unused" variables; flake8 can handle that
    capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = {
      vim.lsp.protocol.DiagnosticTag.Deprecated
    }
  end,

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

      venvPath = vim.env.HOME .. '/.virtualenvs',
    },
  },
})
