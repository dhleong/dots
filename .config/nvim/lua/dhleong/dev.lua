local Dev = {
  reset_cache = function (path)
    path = vim.fn.fnamemodify(path, ':p:r')
    local package_name = ''
    while path:len() > 1 do
      local package_part = vim.fn.fnamemodify(path, ':t')

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
  end,
}

return Dev
