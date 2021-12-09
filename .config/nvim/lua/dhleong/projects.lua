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

local function configure_buffer ()
  local this_file = vim.fn.expand('%:p')

  for _, proj_dir in ipairs(parent_paths) do
    -- Check if our file matches a project src dir
    local len = string.len(proj_dir)
    if string.sub(this_file, 1, len) == proj_dir then
      local file_in_dir = string.sub(this_file, len) -- path w/o projDir
      local idx = string.find(file_in_dir, '/', 2)

      -- If there's no /, we're not in a project
      if not idx then
        goto continue
      end

      -- Build the path
      local proj_name = string.sub(file_in_dir, 2, idx) -- skip past the /
      local path_dir = proj_dir .. proj_name

      -- Set it!
      vim.o.path = path_dir .. '**'
      -- TODO: call dhleong#projects#MapCtrlP(path_dir)
      return
    end

    ::continue::
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
