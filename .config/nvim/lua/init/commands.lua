if vim.env.BROWSER then
  vim.cmd [[
      command! -nargs=1 OpenBrowser :silent !$BROWSER <q-args>
  ]]
end

vim.api.nvim_create_user_command(
  'Profile',
  function(opts)
    local plenary_profile = require 'plenary.profile'
    if opts.fargs[1] == 'stop' then
      vim.cmd.profile('stop')
      plenary_profile.stop()
      vim.cmd.tabedit(vim.g.dhleong_last_vim_profile_path)
      vim.cmd.vsplit(vim.g.dhleong_last_lua_profile_path)
    else
      local path = '~/nvim.profile.log'
      local lua_path = '~/nvim.lua.profile.log'
      vim.g.dhleong_last_vim_profile_path = path
      vim.g.dhleong_last_lua_profile_path = lua_path
      vim.cmd.profile('start', path)
      vim.cmd.profile('func', '*')
      vim.cmd.profile('file', '*')
      plenary_profile.start(vim.fn.expand(lua_path), {
        flame = opts.fargs[1] == 'flame',
      })
      print('Started profiling to:', path, lua_path)
      print('Use `:Profile stop` when done')
    end
  end,
  {
    nargs = '?',
    complete = function()
      return { 'stop', 'flame' }
    end,
  }
)
