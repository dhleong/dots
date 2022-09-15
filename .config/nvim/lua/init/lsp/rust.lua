require 'helpers.lsp'.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = true,
        disabled = { 'unresolved-macro-call', 'unresolved-proc-macro' },
        enableExperimental = true,
      },
      procMacro = {
        enable = true,
      },
    },
  },
})
