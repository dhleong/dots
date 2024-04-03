local godot_exe = '/Applications/Godot-Beta.app/Contents/MacOS/Godot'

local function resolve_project_root()
  -- Maybe we could rely on LSP?
  return vim.fn.trim(vim.fn.system('git rev-parse --show-toplevel'))
end

vim.api.nvim_buf_create_user_command(0, "GodotOpenProject", function()
  vim.loop.spawn(godot_exe, {
    args = {
      '--editor',
      '--path',
      resolve_project_root()
    },
    detached = true,
    hide = true,
  })
end, {})

vim.keymap.set('n', '<leader>pr', function()
  vim.cmd('belowright split')
  vim.cmd.enew()

  local state = {
    win_id = vim.api.nvim_get_current_win()
  }

  local path = resolve_project_root()

  -- TODO: don't hardcode the scene

  vim.fn.termopen(
    {
      godot_exe,
      '--path',
      path,
      'res://Gameplay.tscn',
      '--',
      '--connect-to=localhost'
    },
    {
      on_exit = function()
        vim.api.nvim_win_close(state.win_id, false)
      end
    }
  )
  vim.cmd.normal('G')
end, { buffer = true })
