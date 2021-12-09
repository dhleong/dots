-- Array of paths pointing to parent directories of project directories; IE:
-- each path here contains subdirectories which themselves are project directories.
-- NOTE: We're lazy, so these MUST contain the trailing backslash
local parent_paths = {
  '/git/',
  '/code/appengine/',
  '/code/go/src/github.com/dhleong/',
  '/code/',
  '/judo/',
  '/work/',
  '/.dotfiles/',
}

-- Automatically expand the project parents into absolute paths:
parent_paths = vim.tbl_map(function (path)
  return vim.env.HOME .. path
end, parent_paths)

local function create_project_navigation_maps (project_dir)
  local function nmap (lhs, nav_call)
    local lua_call = "require'dhleong.nav'." .. nav_call
    vim.api.nvim_buf_set_keymap(0, 'n', lhs, '<cmd>lua ' .. lua_call .. '<cr>', {
      noremap = true,
      silent = true,
    })
  end

  nmap('<c-p>', "in_project('" .. project_dir .. "', 'e')")
  nmap('<c-w><c-p>', "in_project('" .. project_dir .. "', 'tabe')")
  nmap('<c-s><c-p>', "in_project('" .. project_dir .. "', 'vsplit')")
  -- TODO in_project_subpath
  -- TODO by_text
end

local function configure_buffer()
  local this_file = vim.fn.expand('%:p')

  for _, proj_dir in ipairs(parent_paths) do
    -- Check if our file matches a project src dir
    local len = proj_dir:len()
    if this_file:sub(1, len) == proj_dir then
      local file_in_dir = this_file:sub(len) -- path w/o projDir
      local idx = file_in_dir:find('/', 2)

      -- If there's no /, we're not in a project
      if not idx then
        goto continue
      end

      -- Build the path
      local proj_name = file_in_dir:sub(2, idx) -- skip past the /
      local path_dir = proj_dir .. proj_name

      -- Set it!
      vim.bo.path = path_dir .. '**'
      create_project_navigation_maps(path_dir)
      return
    end

    ::continue::
  end

  -- If we got here, we found no path
  if vim.g.DefaultPath then
    vim.bo.path = vim.g.DefaultPath .. '**'
    create_project_navigation_maps(vim.g.DefaultPath)
  end
end

local Projects = {
  configure_buffer = configure_buffer,
  parent_paths = parent_paths,

  init = function ()
    vim.cmd([[
      augroup dhleong_project_config
        autocmd!
        autocmd BufEnter * lua require'dhleong.projects'.configure_buffer()
      augroup END
    ]])
    configure_buffer()
  end,
}

return Projects
