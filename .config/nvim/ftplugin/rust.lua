require('helpers.lsp').config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        disabled = { 'unresolved-macro-call' },
      },
      procMacro = {
        enable = true,
      },
    },
  },
})

