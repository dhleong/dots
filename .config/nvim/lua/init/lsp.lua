local cmp = require'cmp'

local function entry_has_key(entry, key)
  if not entry.completion_item then
    return
  end

  if entry.completion_item.textEdit then
    return entry.completion_item.textEdit.newText:find(key, 1, true)
  end

  if entry.completion_item.insertText then
    return entry.completion_item.insertText:find(key, 1, true)
  end
end

local function try_accept_completion(key)
  return cmp.mapping(function (fallback)
    local entry = cmp.get_active_entry()
    if cmp.visible() and entry then
      cmp.confirm()

      if key and not entry_has_key(entry, key) then
        vim.api.nvim_feedkeys(key, 'nt', false)
      end
    else
      fallback()
    end
  end, { 'i', 'c' })
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },

  mapping = {
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<Space>'] = try_accept_completion(),
    ['<CR>'] = try_accept_completion(),
    ['('] = try_accept_completion('('),
    ['.'] = try_accept_completion('.'),
  },

  preselect = cmp.PreselectMode.None,

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
  }, {
    { name = 'buffer' },
  })
})

require'null-ls.config'.reset()
require'null-ls.sources'.reset()
require'null-ls'.setup{
  sources = {
    require('null-ls').builtins.code_actions.eslint_d,
    require('null-ls').builtins.diagnostics.eslint_d,
    require('null-ls').builtins.diagnostics.flake8,
    require('null-ls').builtins.formatting.black,
    require('lilium').completer,
    require('dhleong.null_ls.filename'),
    require('dhleong.null_ls.prettier'),
  },
}

require'postprod'.setup()
