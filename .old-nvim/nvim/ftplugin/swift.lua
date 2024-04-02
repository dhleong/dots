vim.bo.commentstring = '//%s'

vim.keymap.set('n', '<leader>pr', function()
  require 'ft.ios'.run_in_xcode()
end, { buffer = true })
