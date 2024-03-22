local current_root = vim.fn.stdpath('config')
if current_root:find('.lazy') then
  vim.opt.rtp:prepend(vim.env.HOME .. '/.config/nvim')
end

return {}
