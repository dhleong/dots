require 'helpers.lsp'.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      check = {
        -- experimental, for monorepos
        workspace = false,
      },
      diagnostics = {
        enable = true,
        disabled = { 'unresolved-macro-call', 'unresolved-proc-macro' },
        -- enableExperimental = true,
      },
      procMacro = {
        enable = false,
      },
    },
  },
})
