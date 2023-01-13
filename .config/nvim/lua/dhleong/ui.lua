local function get_filter_predicate()
  local ft = vim.bo.filetype

  if string.match(ft, '^typescript') then
    return function(item)
      return not string.match(item, '^Disable ESLint')
    end
  end

  return function()
    return true
  end
end

local function item_str_to_index(item)
  local index_str = string.match(item, '^(%d+)[.]')
  if index_str then
    return tonumber(index_str)
  end
  return nil
end

local M = {}

---@alias FzfConfig {prompt: string, source: string|string[], sink: fun(string), sinklist: fun(lines: string[])}

---@param config FzfConfig
function M.fzf(config)
  local wrapped = vim.fn['fzf#wrap'](config)
  wrapped.options = '--no-clear ' .. wrapped.options

  -- Lua fns don't come back from wrap
  wrapped.sink = config.sink
  wrapped.sinklist = config.sinklist

  -- Ensure we have some basic colors, if not otherwise specified
  -- (see g:fzf_colors)
  if not wrapped.options:find('--color') then
    wrapped.options = wrapped.options .. ' --color=dark'
  end

  return vim.fn['fzf#run'](wrapped)
end

function M.select(items, opts, on_choice)
  local filter = get_filter_predicate()
  local to_present = {}
  for i, item in ipairs(items) do
    if opts.format_item then
      item = opts.format_item(item)
    end

    if filter(item) then
      local with_index = i .. '. ' .. item
      table.insert(to_present, with_index)
    end
  end

  -- NOTE: We don't *necessarily* want to always do the only thing;
  -- for example, there are some rust actions we don't necessarily want
  -- to just do. Experimentally I'm using the fact that we've filtered out
  -- irrelevant actions as a proxy for being okay with auto-accepting
  if #to_present < #items then
    if #to_present == 0 then
      return on_choice(nil, nil)
    elseif #to_present == 1 then
      local index = item_str_to_index(to_present[1])
      return on_choice(items[index], index)
    end
  end

  local config = {
    prompt = opts.prompt,
    source = to_present,
    sink = function(value)
      local index = item_str_to_index(value)
      if index then
        on_choice(items[index], index)
      else
        on_choice(nil, nil)
      end
    end
  }

  if opts.prompt then
    config.options = '--prompt "' .. opts.prompt .. '"'
  end

  if #items < 10 then
    -- NOTE: +4 gives room for the fzf and popup window UI
    config.window = { height = #items + 4, width = 0.5 }
  end

  M.fzf(config)
end

function M.input(opts, on_confirm)
  vim.fn.inputsave()

  -- Prepare the typeahead buffer so input() gets opened into cmdline mode
  local keys = vim.api.nvim_replace_termcodes('<C-f>b', true, false, true)
  vim.api.nvim_feedkeys(keys, 'n', true)

  -- Start the default input()
  local result = vim.fn.input(opts)

  vim.fn.inputrestore()
  on_confirm(result)
end

return M
