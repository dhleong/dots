local map = require'helpers.map'

require'helpers.lsp'.config('rust_analyzer', {
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

require'dhleong.debugger'.configure{
  adapter = 'CodeLLDB',
}

map.nno'<leader>rd'{
  lua_module = 'ft.rust',
  lua_call = 'debug_nearest()',
}
