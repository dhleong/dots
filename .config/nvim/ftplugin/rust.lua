require('helpers.lsp').config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      procMacro = {
        enable = true,
      },
    },
  },
})

