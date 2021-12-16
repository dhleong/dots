local POPUP_TERM_PATCH = 'patch-8.2.0286'

local function not_nil(value)
  return value ~= nil
end

local function fzf(config)
  local wrapped = vim.fn['fzf#wrap'](config)
  wrapped.options = '--no-clear ' .. wrapped.options
  wrapped.sink = config.sink -- Lua fns don't come back from wrap

  -- Ensure we have some basic colors, if not otherwise specified
  -- (see g:fzf_colors)
  if not wrapped.options:find('--color') then
    wrapped.options = wrapped.options .. ' --color=dark'
  end

  return vim.fn['fzf#run'](wrapped)
end

local M = {}

function M.open_project(project_dir)
  if vim.fn.isdirectory(project_dir) == 1 then
    vim.bo.path = project_dir .. '**'
    vim.cmd('lcd ' .. project_dir)

    require'dhleong.projects'.configure_buffer()
    M.in_project(project_dir, 'e')
  else
    vim.cmd('edit ' .. project_dir)
  end
end

function M.in_project(project_dir, sink)
  local window = 'aboveleft 15new'
  if vim.fn.has(POPUP_TERM_PATCH) then
    window = {
      width = 0.4,
      height = 0.8,
      yoffset = 0.2,
      xoffset = 0.9,
    }
  end

  local dir = project_dir or vim.g.otsukare_default_project_root
  if not dir then
    print('Not in a project directory')
    return
  end

  fzf{
    dir = dir,
    options = {},
    source = 'list-repo-files',
    sink = sink,
    window = window,
  }
end

function M.lsp_in_new_tab(buffer_method)
  local cursor = vim.fn.getpos('.')
  vim.cmd('tabe %')
  vim.fn.cursor(cursor[2], cursor[3])
  vim.lsp.buf[buffer_method]()
end

function M.projects()
  local parent_paths = require'dhleong.projects'.parent_paths
  local dirs = vim.tbl_map(function (path)
    if vim.fn.isdirectory(path) == 1 then
      return path .. '*'
    end
  end, parent_paths)
  dirs = vim.tbl_filter(not_nil, dirs)

    if #dirs == 0 then
      print('No project dirs exist? Checked:')
      print(parent_paths)
      return
    end

    local cmd = 'ls -d ' .. table.concat(dirs, ' ')
    fzf{
      source = cmd,
      sink = M.open_project,
    }
  end

return M
