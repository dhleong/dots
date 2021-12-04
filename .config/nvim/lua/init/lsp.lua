local cmp = require'cmp'

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
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
  }, {
    { name = 'buffer' },
  })
})

require("null-ls").config({
  sources = {
    require("null-ls").builtins.code_actions.eslint,
    require("null-ls").builtins.diagnostics.eslint,
    require("null-ls").builtins.formatting.black,
    require("null-ls").builtins.formatting.eslint,
    require("null-ls").builtins.formatting.prettier,
  },
})
require("lspconfig")["null-ls"].setup{}
