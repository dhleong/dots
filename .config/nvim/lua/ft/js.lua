return {
  init = function ()
    require('helpers.lsp').config('tsserver', {
      on_attach = function (client)
        -- Disable tsserver formatting
        client.resolved_capabilities.document_formatting = false
      end
    })
  end
}

