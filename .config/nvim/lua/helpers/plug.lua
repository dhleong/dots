local Plug = {
  begin = function (path)
    vim.cmd([[
      if empty(glob('~/.config/nvim/autoload/plug.vim'))
          silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
              \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
          autocmd VimEnter * PlugInstall
      endif
    ]])
    vim.fn['plug#begin'](path)
  end,

  -- "end" is a keyword, need something else
  ends = vim.fn['plug#end'],
}

-- "Meta-functions"
local meta = {

  -- Function call "operation"
  ---@diagnostic disable-next-line:unused-local
  __call = function(self, repo, opts)
    opts = opts or vim.empty_dict()

    -- We declare some aliases for `do` and `for`
    opts['do'] = opts.run
    opts.run = nil

    opts['for'] = opts.ft
    opts.ft = nil

    local declare = vim.fn['plug#']

    declare(repo, opts)

    -- Support a slightly cleaner, command-like syntax:
    return function (command_like_opts)
      declare(repo, command_like_opts)
    end
  end
}

-- Meta-tables are awesome
return setmetatable(Plug, meta)
