vim.keymap.set('n', '<leader>pr', function()
  vim.cmd('belowright split')
  vim.cmd.enew()

  local state = {
    win_id = vim.api.nvim_get_current_win()
  }

  -- TODO: don't hardcode the scene

  vim.fn.termopen(
    {
      '/Applications/Godot.app/Contents/MacOS/Godot',
      '--path',
      vim.fn.getcwd(),
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

end, { buffer = true })
