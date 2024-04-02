local tsserver_settings = {
  -- NOTE: For whatever reason, these don't seem to be respected...
  javascript = {
    showUnused = false,
    suggestionActions = {
      enabled = false,
    },
  },
  typescript = {
    showUnused = false,
  },

  -- So for now we ignore specific annoying ones
  diagnostics = {
    ignoredCodes = {
      -- These can be found here:
      -- https://github.com/microsoft/TypeScript/blob/master/src/compiler/diagnosticMessages.json

      6133, -- "X Is declared but its value is enver read"
      80001, -- "This is a CommonJS file"
      80005, -- "This require may be converted to an import"
      80006, -- "This may be converted to an async function"
    },
  },
}

require('helpers.lsp').config('tsserver', {
  settings = tsserver_settings,

  on_attach = function(client)
    -- Disable tsserver formatting
    client.server_capabilities.documentFormattingProvider = false
  end
})
