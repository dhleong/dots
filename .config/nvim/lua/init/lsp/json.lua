require('helpers.lsp').config('jsonls', {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
})
