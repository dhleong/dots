local ui = require'dhleong.ui'

local POPUP_TERM_PATCH = 'patch-8.2.0286'

local function not_nil(value)
  return value ~= nil
end

local function fzf(config)
  if not config.window and vim.fn.has(POPUP_TERM_PATCH) then
    config.window = {
      width = 0.4,
      height = 0.8,
      yoffset = 0.2,
      xoffset = 0.9,
    }
  end
  if not vim.fn.has(POPUP_TERM_PATCH) or not config.window then
    config.window = 'aboveleft 15new'
  end

  if not config.dir then
    config.dir = vim.g.otsukare_default_project_root
    if not config.dir then
      print('Not in a project directory')
      return
    end
  end

  if not config.options then
    config.options = {}
  end

  ui.fzf(config)
end

local M = {}

function M.link()
  local url = vim.fn.expand('<cfile>')
  vim.api.nvim_exec([[!open ]] .. url, true)
end

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
  fzf{
    dir = project_dir,
    options = {},
    source = 'list-repo-files',
    sink = sink,
  }
end

function M.by_text(project_dir, sink)
  local rg = table.concat({
    'rg', '--column', '--line-number', '--no-heading', '--smart-case',
    "--glob '!*.lock'",
    "--glob '!tsconfig.json'",
    '--',
  }, ' ')

  local options = {
    -- NOTE: use 4.. as the query and presentation target to handle Swift
    -- (and other code that uses colons).
    '--with-nth=1,4..',
    '--nth=2..',
    '--delimiter=:',

    -- Automatically create a new search with the query text on change; this is much
    -- faster than waiting for rg to load all text in the project
    '--bind', 'change:reload:' .. rg .. ' {q} || true',
  }

  fzf{
    dir = project_dir,
    options = options,
    source = rg .. ' .',
    window = { width = 1.0, height = 0.8, yoffset = 0 },
    sink = function (output)
      local _, _, file, line = string.find(output, '^([^:]+):(%d+):')
      if not file and not line then
        print('Unexpected input: ' .. output)
        return
      end

      vim.cmd(sink .. ' ' .. file)
      vim.cmd('normal! ' .. line .. 'G')
      vim.cmd[[normal! zz]]
    end,
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
  ui.fzf{
    source = cmd,
    sink = M.open_project,
  }
end

return M
