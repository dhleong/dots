local POPUP_TERM_PATCH = 'patch-8.2.0286'

local function fzf(config)
  local wrapped = vim.fn['fzf#wrap'](config)

  -- Ensure we have some basic colors, if not otherwise specified
  -- (see g:fzf_colors)
  if wrapped.options ~='--color' then
    wrapped.options = wrapped.options .. ' --color=dark'
  end

  return vim.fn['fzf#run'](wrapped)
end

local Nav = {
  in_project = function (project_dir, sink)
    local window = 'aboveleft 15new'
    if vim.fn.has(POPUP_TERM_PATCH) then
      window = {
        width = 0.4,
        height = 0.8,
        yoffset = 0.2,
        xoffset = 0.9,
      }
    end

    fzf{
      dir = project_dir,
      options = {},
      source = 'list-repo-files',
      sink = sink,
      window = window,
    }
  end
}

return Nav
