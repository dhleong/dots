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
  local eslint_d = cmd_resolver.from_node_modules {
    command = 'eslint_d',
    bufnr = request.bufnr,
  }
  if not eslint_d then
    return
  end

  helpers.command({
    command = eslint_d,
    args = {
      '--fix-to-stdout',
      '--stdin',
      '--stdin-filename', request.path,
    },
  }, request)
end

return M
