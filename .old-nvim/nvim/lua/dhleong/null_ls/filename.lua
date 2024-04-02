local h = require'null-ls.helpers'
local methods = require'null-ls.methods'

local COMPLETION = methods.internal.COMPLETION

local function get_candidates(entries)
  local items = {}
  for k, v in ipairs(entries) do
    items[k] = { label = v, kind = vim.lsp.protocol.CompletionItemKind["Text"] }
  end

  return items
end

return h.make_builtin{
  name = 'filename',
  method = COMPLETION,
  filetypes = { 'typescript', 'typescriptreact' },
  generator = {
    fn = function(params, done)
      local name = vim.fn.fnamemodify(params.bufname, ':t:r')
      local items = get_candidates{ name }
      done{ { items = items, isIncomplete = false } }
    end,
    async = true,
  },
}
