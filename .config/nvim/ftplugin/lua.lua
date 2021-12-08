vim.o.shiftwidth = 2
vim.o.tabstop = 2

require('helpers.lsp').config('sumneko_lua', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
})
