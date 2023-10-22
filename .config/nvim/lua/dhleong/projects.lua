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
parent_paths = vim.tbl_map(function(path)
  return vim.env.HOME .. path
end, parent_paths)

local function create_project_navigation_maps(paths)
  local function nmap(lhs, nav_call)
    local lua_call = "require'dhleong.nav'." .. nav_call
    vim.api.nvim_buf_set_keymap(0, 'n', lhs, '<cmd>lua ' .. lua_call .. '<cr>', {
      noremap = true,
      silent = true,
    })
  end

  local project_dir = paths.project_dir
  local project_path = 'nil'
  if project_dir then
    project_path = '"' .. project_dir .. '"'

    -- NOTE: vim-test *must* be run from the project root, frustratingly. It supplies
    -- this "feature" to workaround that assumption, but it's global and doesn't support
    -- a buffer-local for... reasons :\
    vim.g['test#project_root'] = project_dir
  end

  nmap('<c-p>', "in_project(" .. project_path .. ", 'e')")
  nmap('<c-w><c-p>', "in_project(" .. project_path .. ", 'tabe')")
  nmap('<c-s><c-p>', "in_project(" .. project_path .. ", 'vsplit')")
  nmap('\\', "by_text(" .. project_path .. ", 'e')")
  nmap('|', "resume_by_text(" .. project_path .. ", 'e')")
  nmap('<c-w>\\', "by_text(" .. project_path .. ", 'tabe')")
  nmap('<c-s>\\', "by_text(" .. project_path .. ", 'tabe')")
  nmap('g\\', "by_text(" .. project_path .. ", 'e', { query = vim.fn.expand('<cword>') })")

  if paths.monorepo_root then
    nmap('<leader>m\\', "by_text('" .. paths.monorepo_root .. "', 'e')")
    nmap('<leader>m|', "resume_by_text('" .. paths.monorepo_root .. "', 'e')")
    nmap('<leader>mg\\', "by_text(" .. paths.monorepo_root .. ", 'e', { query = vim.fn.expand('<cword>') })")
    nmap('<leader>m<c-p>', "in_project('" .. paths.monorepo_root .. "', 'e')")
  end
end

local function extract_project_paths(proj_dir, file_in_dir, idx)
  -- Build the path
  local proj_name = file_in_dir:sub(2, idx) -- skip past the /
  local path_dir = proj_dir .. proj_name

  -- Is this a simple monorepo? These look like eg:
  -- project/project_subproject
  -- NOTE: It might be nice to have some sort of heuristic for "project size"
  -- at which this is useful...
  local subproj_idx = file_in_dir:find('/', idx + 1)
  if subproj_idx then
    local subproj_name = file_in_dir:sub(idx + 1, subproj_idx)

    -- Trim the trailing slashes
    local clean_subproj_name = vim.fn.trim(subproj_name, '/', 2)
    local clean_proj_name = vim.fn.trim(proj_name, '/', 2)

    for _, separator in ipairs { '_', '-' } do
      if vim.startswith(clean_subproj_name, clean_proj_name .. separator) then
        return {
          monorepo_root = path_dir,
          project_dir = path_dir .. subproj_name
        }
      end
    end
  end

  return {
    project_dir = path_dir,
  }
end

local function configure_buffer()
  -- NOTE: This is NOT exactly the same as `expand('%:p')` this lets us
  -- treat empty buffers (like from :tabe) as being part of the same
  -- "project"
  local this_file = vim.fn.expand('%:p:h') .. '/' .. vim.fn.expand('%:t')

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
      local paths = extract_project_paths(proj_dir, file_in_dir, idx)

      -- Set it!
      vim.bo.path = paths.project_dir .. '**'
      create_project_navigation_maps(paths)
      return
    end

    ::continue::
  end

  -- If we got here, we found no path
  create_project_navigation_maps {
    project_dir = nil
  }
end

local Projects = {
  configure_buffer = configure_buffer,
  parent_paths = parent_paths,
  init = function()
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
