local M = {}

function M.split()
  -- NOTE: By default, :term does not respect the "current" dir
  local cwd = vim.b.netrw_curdir or vim.fn.getcwd()
  vim.cmd('lcd ' .. cwd)
  vim.cmd [[ split | terminal ]]
  vim.cmd [[ startinsert ]]
end

return M
