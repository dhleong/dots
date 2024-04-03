local map = require 'helpers.map'

local debugger_mappings = {
  ['gk'] = '<Plug>VimspectorRunToCursor',
  ['gi'] = '<Plug>VimspectorStepInto',
  ['gn'] = '<Plug>VimspectorStepOver',
  ['go'] = '<Plug>VimspectorStepOut',
  ['gp'] = '<Plug>VimspectorPause',
  ['gr'] = '<Plug>VimspectorContinue',
  ['gq'] = ':call vimspector#Reset()<cr>',
}

---@alias DebuggerOpts { adapter: string }

local function set_mappings(mappings_map)
  for keys, mapping in pairs(mappings_map) do
    vim.cmd('nmap <buffer> ' .. keys .. ' ' .. mapping)
  end
end

local function restore_original_mappings()
  for keys, _ in pairs(debugger_mappings) do
    -- NOTE: Ignore if already unmapped
    pcall(vim.cmd, 'nunmap <buffer> ' .. keys)
  end
  set_mappings(vim.b.dhleong_vimspector_original_maps or {})
end

local function stash_original_mappings()
  if vim.b.dhleong_vimspector_original_maps then
    -- Already done
    return
  end

  local to_stash = {}
  vim.b.dhleong_vimspector_original_maps = to_stash

  for keys, _ in pairs(debugger_mappings) do
    local mapped = vim.fn.maparg(keys, 'n', 0, 1)
    if mapped.buffer then
      to_stash[keys] = mapped.rhs
    end
  end
end

local function set_debugger_mappings()
  set_mappings(debugger_mappings)
end

local M = {
  ---@type table<string, DebuggerOpts>
  ft_configs = {},
}

function M.handle_mappings()
  local windows = vim.g.vimspector_session_windows
  if not windows or windows.tabpage ~= vim.fn.tabpagenr() then
    restore_original_mappings()
  else
    stash_original_mappings()
    set_debugger_mappings()
  end
end

function M.configure_watches()
  set_mappings {
    ['dd'] = '<del>',
  }
end

---@param opts DebuggerOpts
function M.configure(opts)
  if not opts.adapter then
    print('Incomplete debugger config')
    return
  end

  M.ft_configs[vim.bo.filetype] = opts

  -- Mappings:
  map.nno '<leader>rq' { vim_call = 'vimspector#Reset()' }
  map.buf_nno '<leader>bc' { vim_call = 'vimspector#ClearBreakpoints()' }
  map.buf_nno '<leader>bt' { vim_call = 'vimspector#ToggleBreakpoint()' }

  -- Autocmd:
  vim.cmd([[
    augroup MyVimspectorConfigs
      autocmd!
      autocmd BufEnter vimspector.Watches* lua require'dhleong.debugger'.configure_watches()
      autocmd BufWinEnter * lua require'dhleong.debugger'.handle_mappings()
      autocmd WinEnter * lua require'dhleong.debugger'.handle_mappings()
      autocmd User VimspectorUICreated lua require'dhleong.debugger'.handle_mappings()
    augroup END
  ]])
end

return M
