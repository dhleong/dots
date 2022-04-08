local M = {}

function M.reset_cache(path)
  path = vim.fn.fnamemodify(path, ':p:r')

  local package_name = ''
  while path:len() > 1 do
    local package_part = vim.fn.fnamemodify(path, ':t')
    if package_part == 'init' then
      -- EG: lua/dhleong/dev/init => dhleong.dev
      package_part = ''
    end

    if package_name:len() > 0 then
      package_name = '.' .. package_name
    end
    package_name = package_part .. package_name

    if package.loaded[package_name] then
      package.loaded[package_name] = nil
      return
    end

    local new_path = vim.fn.fnamemodify(path, ':h')
    if new_path == path then
      break
    end

    path = new_path
  end
end

function M.unload_prefix(package_prefix)
  local prefix_partial = package_prefix .. '.'
  for k, _ in pairs(package.loaded) do
    if k == package_prefix or vim.startswith(k, prefix_partial) then
      package.loaded[k] = nil
    end
  end
end

return M
