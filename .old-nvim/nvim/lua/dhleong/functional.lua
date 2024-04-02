local M = {}

function M.add_hook_before(f, new_func)
  if not new_func then
    return f
  elseif not f then
    return new_func
  else
    return function (...)
      -- Always execute the hook `new_func` *first*; return its result if `f`
      -- doesn't return one
      local hook_result = new_func(...)
      return f(...) or hook_result
    end
  end
end

return M
