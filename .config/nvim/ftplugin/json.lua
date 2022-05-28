require('helpers.lsp').config('jsonls', {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
})

-- Load prettier config to determine indents
require('ft.js').init_prettier_config()
