---@alias LspMessage {loading: boolean, message: string|nil, name: string, title: string, percentage: number|nil}

local function lsp_status_exists()
  local messages = vim.lsp.util.get_progress_messages()
  return #messages > 0
end

---@param msg LspMessage
local function format_message(msg)
  if msg.message then
    return msg.title .. ': ' .. msg.message
  end
  return msg.title
end

---@param messages LspMessage[]
local function percentage_message(messages)
  for _, msg in ipairs(messages) do
    if msg.percentage then
      return msg
    end
  end
end

---@param messages LspMessage[]
local function preferred_message(messages)
  -- Prefer something with a percentage
  local perc = percentage_message(messages)
  if perc then
    return perc
  end

  -- Otherwise, just use the last
  return messages[#messages]
end

local function lsp_status()
  local messages = vim.lsp.util.get_progress_messages()
  if #messages == 0 then
    return
  end

  local selected_name = messages[1].name

  local by_name = vim.tbl_filter(function (item)
    return item.name == selected_name
  end, messages)

  local msg = preferred_message(by_name)
  return string.format('[%s] %s', selected_name, format_message(msg))
end

require'lualine'.setup {
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {'filetype'},
    lualine_y = {
      'diagnostics',
      {lsp_status, cond = lsp_status_exists}
    },
    lualine_z = {'location'}
  },
}

vim.cmd([[
  augroup LspStatusLine
    autocmd!
    autocmd User LspProgressUpdate redrawstatus!
  augroup END
]])
