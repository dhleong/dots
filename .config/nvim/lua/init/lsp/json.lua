require('helpers.lsp').config('jsonls', {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      format = {
        enable = false,
      },
      validate = {
        enable = true,
      },
    },
  },
})
