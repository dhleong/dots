local function readfile(path)
  return table.concat(vim.fn.readfile(path), '\n')
end

local M = {}

---@return string|nil
function M.find_prettier_config()
  local old_ignore = vim.o.wildignore
  vim.o.wildignore = vim.o.wildignore .. '**/node_modules/**'

  local path = vim.fn.trim(vim.fn.system('git rev-parse --show-toplevel'))
  local prettier_file = vim.fn.findfile('.prettierrc', path)

  vim.o.wildignore = old_ignore

  return prettier_file ~= '' and prettier_file
end

function M.extract_prettier_config()
  local file = M.find_prettier_config()
  if not file or not vim.fn.filereadable(file) then
    return
  end

  -- NOTE: Prettier defaults to 2-space tabs
  local config = { ts = 2 }

  -- NOTE: findfile automatically also tries to search various suffixes,
  -- including .js for js files, so we need to make sure to handle the
  -- .prettierrc.js case
  if file:match('.js$') then
    local tab_widget_match = readfile(file):match('tabWidth[ ]*[:=][ ]*(%d+)')
    if tab_widget_match then
      config.ts = tonumber(tab_widget_match)
    end
  else
    local ok, json = pcall(vim.fn.json_decode, readfile(file))
    if ok and json.tabWidth then
      config.ts = json.tabWidth
    end
  end

  return config
end

function M.init()
  require('helpers.lsp').config('tsserver', {
    on_attach = function (client)
      -- Disable tsserver formatting
      client.resolved_capabilities.document_formatting = false
    end
  })

  -- Load from a prettier config, if it exists
  local config = M.extract_prettier_config()
  if config then
    vim.bo.tabstop = config.ts
    vim.bo.shiftwidth = config.ts
  elseif vim.fn.expand('%:e'):match('[jt]sx') then
    -- Default to two-space tabs in tsx files, since we're embedding html
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end
end

return M
