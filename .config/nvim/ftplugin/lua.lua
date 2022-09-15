-- ======= Settings =======================================

vim.bo.shiftwidth = 2
vim.bo.tabstop = 2


-- ======= Mappings =======================================

vim.cmd [[
  nnoremap <buffer> K <cmd>lua require'ft.lua'.doc()<cr>
]]
