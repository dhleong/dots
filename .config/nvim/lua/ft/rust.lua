local M = {}

function M.get_nearest_module()
  local position = require'neo-latte.test'.create_position()
  local info = vim.fn['test#rust#cargotest#build_position']('nearest', position)
  local module = info[#info-2]
  if module:sub(0, 1) == "'" then
    return module:sub(2, #module-1)
  end
  return module
end

function M.compile_module_for_executable(module)
  local lines = vim.fn.systemlist('cargo test --no-run --message-format=json ' .. module)
  for i = #lines, 1, -1 do
    local line = lines[i]
    if line:sub(0, 1) == '{' then
      local data = vim.fn.json_decode(line)
      if data.reason == 'compiler-artifact' then
        return data['executable']
      end
    end
  end
end

function M.debug_nearest()
  local module = M.get_nearest_module()

  print('Compiling ' .. module .. '...')

  local path = M.compile_module_for_executable(module)
  if not path then
    print('No executable produced')
    return
  end

  vim.fn['vimspector#LaunchWithSettings']({
    configuration = 'Run Test',
    Exe = path,
    Module = module,
  })
end

return M
