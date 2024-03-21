local M = {}

function M.safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    print('ERROR initializing', module)
    print(result)
  end
end

return M
