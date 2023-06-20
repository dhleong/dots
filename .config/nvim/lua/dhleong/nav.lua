local a = require 'plenary.async'

local ui = require 'dhleong.ui'

local POPUP_TERM_PATCH = 'patch-8.2.0286'

local function not_nil(value)
  return value ~= nil
end

local function fzf(config)
  if not config.window and vim.fn.has(POPUP_TERM_PATCH) then
    config.window = {
      width = 0.6,
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

local function unpack_text_result(result)
  local _, _, file, line, col, text = string.find(result, '^([^:]+):(%d+):(%d+):(.*)')
  return file, line, col, text
end

local M = {
  _last_search = {}
}

---@param args {command:string, arguments:string[], query:string, dir:string, selected:string}
M._preserve_search_results = a.void(function(args)
  local results = require 'dhleong.command'.run {
    command = args.command,
    cwd = args.dir,
  }

  M._last_search[args.dir] = {
    command = args.command,
    query = args.query,
    results = results,
    selected = args.selected,
  }
end)

function M.link()
  local url = vim.fn.expand('<cfile>')
  local browser = vim.env.BROWSER or 'open'

  if vim.startswith(url, '#') then
    -- Github issue/PR reference, probably
    local remote = vim.fn.FugitiveRemoteUrl()
    local homepage = vim.fn['rhubarb#HomepageForUrl'](remote)
    url = homepage .. '/issues/' .. string.sub(url, 2)
  end

  local lines = vim.fn.system({ browser, url })
  if #lines > 1 then
    print(vim.fn.trim(table.concat(vim.list_slice(lines, 2), '\n')))
  end
end

function M.open_project(project_dir)
  if vim.fn.isdirectory(project_dir) == 1 then
    vim.bo.path = project_dir .. '**'
    vim.cmd.lcd(project_dir)

    require 'dhleong.projects'.configure_buffer()
    M.in_project(project_dir, 'e')
  else
    vim.cmd.edit(project_dir)
  end
end

function M.in_project(project_dir, sink)
  fzf {
    dir = project_dir,
    options = {},
    source = vim.env.HOME .. '/bin/list-repo-files',
    sink = sink,
  }
end

local function make_rg(opts)
  local fuzzy = opts.fuzzy and '' or '--fixed-strings'
  return table.concat({
    'rg', '--column', '--line-number', '--no-heading', '--smart-case',
    fuzzy,
    '--glob', "'!*.lock'",
    '--glob', "'!package*.json'",
    '--glob', "'!tsconfig.json'",
    '--',
  }, ' ')
end

local function bindings(entries)
  return table.concat(entries, '+')
end

function M.by_text(project_dir, sink, opts)
  -- NOTE: I almost never want regex, by default
  local rg = make_rg { fuzzy = false }

  local options = {
    -- NOTE: use 4.. as the query and presentation target to handle Swift
    -- (and other code that uses colons).
    '--with-nth=1,4..',
    '--delimiter=:',

    -- NOTE: By disabling FZF search by default, it defaults to an interactive
    -- interface for RG. Then, by removing nth we can use ctrl-f to search
    -- within *those* results, letting us narrow by filename in addition to text.
    -- '--nth=2..',
    '--disabled',

    -- Enable us to do something with the most recent query
    '--print-query',

    '--prompt', '> ',

    -- Automatically create a new search with the query text on change; this is much
    -- faster than waiting for rg to load all text in the project
    '--bind', 'change:reload:' .. rg .. ' {q} || true',

    -- Support using ctrl-f to narrow the search results with fuzzy matching
    -- Using ctrl-r will pop back out to the rg search
    '--bind',
    'ctrl-f:' .. bindings {
      'unbind(change,ctrl-f)',
      'change-prompt(narrow> )',
      'enable-search',
      'clear-query',
      'rebind(ctrl-r)'
    },

    '--bind',
    'ctrl-r:' .. bindings {
      'unbind(ctrl-r)',
      'change-prompt(> )',
      'disable-search',
      'reload(' .. rg .. ' {q} || true)',
      'rebind(change,ctrl-f)'
    },
  }

  local initial_query = rg .. ' .'

  if opts and opts.query then
    table.insert(options, '--query')
    table.insert(options, opts.query)
    initial_query = rg .. ' ' .. opts.query
  end

  fzf {
    dir = project_dir,
    options = options,
    source = initial_query,
    window = { width = 1.0, height = 0.8, yoffset = 0 },
    sinklist = function(output)
      local query = output[1]
      local file, line, col = unpack_text_result(output[2])
      if not file and not line then
        print('Unexpected input: ' .. output[2])
        return
      end

      vim.cmd(sink .. ' ' .. file)
      vim.api.nvim_win_set_cursor(0, {
        tonumber(line, 10),
        tonumber(col, 10) - 1,
      })
      vim.cmd [[normal! zz]]

      if query ~= '' then
        M._preserve_search_results {
          command = rg .. ' ' .. query,
          dir = project_dir,
          query = query,
          selected = output[2],
        }
      end
    end,
  }
end

function M.resume_by_text(project_dir)
  local search = M._last_search[project_dir]
  if not search then
    print('[WARN] No search to resume for ' .. project_dir)
    return
  end

  local selected_file, selected_line = unpack_text_result(search.selected)

  local selected_index = nil
  local items = {}
  for i, result in ipairs(search.results) do
    local file, line, col, text = unpack_text_result(result)
    items[i] = {
      text = text,
      filename = project_dir .. file,
      lnum = line,
      col = col,
      pattern = search.query,
    }

    if vim.endswith(selected_file, file) and selected_line == line then
      selected_index = i
    end
  end

  if #items == 0 then
    print('No results')
    return
  end

  vim.fn.setqflist({}, 'r', {
    items = items,
    title = 'Text search: ' .. search.query,
  })
  vim.cmd.copen()

  if selected_index and selected_index ~= -1 then
    vim.api.nvim_win_set_cursor(0, { selected_index, 0 })
  end
end

function M.lsp_in_new_tab(buffer_method)
  local cursor = vim.fn.getpos('.')
  vim.cmd.tabe('%')
  vim.api.nvim_win_set_cursor(0, { cursor[2], cursor[3] - 1 })
  vim.lsp.buf[buffer_method]()
end

function M.projects()
  local parent_paths = require 'dhleong.projects'.parent_paths
  local dirs = vim.tbl_map(function(path)
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
  ui.fzf {
    source = cmd,
    sink = M.open_project,
  }
end

return M
