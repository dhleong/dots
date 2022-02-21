local cmd_resolver = require'null-ls.helpers.command_resolver'
local helpers = require'postprod.helpers'

local M = {
  name = 'eslint',
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
  },
}

function M.handle(request)
  helpers.command({
    command = 'eslint_d',
    args = {
      '--fix-to-stdout',
      '--stdin',
      '--stdin-filename', request.path,
    },
    resolver = cmd_resolver.from_node_modules,
  }, request)
end

return M
