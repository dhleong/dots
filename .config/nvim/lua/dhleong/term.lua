local M = {}

function M.split()
  -- NOTE: By default, :term does not respect the "current" dir
  local cwd = require("oil").get_current_dir() or vim.fn.expand("%:p:h")
  vim.cmd.split()
  vim.cmd.lcd(cwd)
  vim.cmd.terminal()
  vim.cmd.startinsert()
end

return M
