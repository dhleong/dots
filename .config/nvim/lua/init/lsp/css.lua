require('helpers.lsp').config('cssmodules_ls', {
  on_attach = function(client)
    -- Avoid conflicts with tsserver go-to-definition
    client.server_capabilities.definitionProvider = false
  end
})
