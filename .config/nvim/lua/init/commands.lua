if vim.env.BROWSER then
  vim.cmd [[
      command! -nargs=1 OpenBrowser :silent !$BROWSER <q-args>
  ]]
end

vim.api.nvim_create_user_command(
  'Profile',
  function(opts)
    if opts.fargs[1] == 'stop' then
      vim.cmd.profile('stop')
      vim.cmd.tabedit(vim.g.dhleong_last_profile_path)
    else
      local path = '~/nvim.profile.log'
      vim.g.dhleong_last_profile_path = path
      vim.cmd.profile('start', path)
      vim.cmd.profile('func', '*')
      vim.cmd.profile('file', '*')
      print('Started profiling to:', path)
      print('Use :Profile stop when done')
    end
  end,
  {
    nargs = '?',
    complete = function()
      return { "stop" }
    end,
  }
)
