require('helpers.lsp').config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      workspace = {
        -- Disable third party library checks (super annoying)
        checkThirdParty = false,

        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
})
