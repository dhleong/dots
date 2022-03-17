require('helpers.lsp').config('sumneko_lua', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      telemetry = {
        -- Disable sending (anonymized) telemetry
        enable = false,
      },
    },
  },
})

-- ======= Settings =======================================

vim.bo.shiftwidth = 2
vim.bo.tabstop = 2


-- ======= Mappings =======================================

vim.cmd [[
  nnoremap <buffer> K <cmd>lua require'ft.lua'.doc()<cr>
]]
