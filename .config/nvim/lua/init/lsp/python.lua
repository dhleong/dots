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

-- Just can't seem to get pyslp to be a good experience :/

-- local settings = {
--   pylsp = {
--     configurationSources = {},
--     plugins = {
--       mccabe = { enabled = false },
--       pyflakes = { enabled = false },
--       pycodestyle = { enabled = false },
--     },
--   },
-- }

-- require('helpers.lsp').config('pylsp', {
--   settings = settings,
--
--   -- NOTE: For whatever reason, pylsp needs us to manually set the
--   -- settings *again* at a later time, or else it gets ignored...
--   on_attach = function(client)
--     client.workspace_did_change_configuration(settings)
--   end,
-- })
