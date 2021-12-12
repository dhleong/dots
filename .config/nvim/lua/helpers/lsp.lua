local lsp_installer_servers = require 'nvim-lsp-installer.servers'
local cmp_nvim_lsp = require 'cmp_nvim_lsp'

local lsp_capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local function prepare_mappings()
  local function nmap(lhs, lua)
    local rhs = '<cmd>lua ' .. lua .. '<cr>'
    vim.api.nvim_buf_set_keymap(0, 'n', lhs, rhs, {
      noremap = true,
      silent = true,
    })
  end
  local function lsp_map(lhs, lsp_command)
    local rhs = 'vim.lsp.' .. lsp_command
    nmap(lhs, rhs)
  end

  lsp_map('K', 'buf.hover()')
  lsp_map('gd', 'buf.definition()')
  lsp_map('gid', 'buf.implementation()')
  nmap('<c-w>gd', "require'dhleong.nav'.lsp_in_new_tab('definition')")
  nmap('<c-w>gid', "require'dhleong.nav'.lsp_in_new_tab('implementation')")
  lsp_map('<leader>js', 'buf.references()')
  lsp_map('<leader>jr', 'buf.rename()')
  lsp_map('<m-cr>', 'buf.code_action()')

  lsp_map('[c', 'diagnostic.goto_prev()')
  lsp_map(']c', 'diagnostic.goto_next()')
end

local function prepare_events(filetype, file_extension)
  vim.cmd(string.format([[
    augroup lsp_autocmds_%s
      autocmd!
      autocmd BufWritePre *.%s lua vim.lsp.buf.formatting_seq_sync(nil, 1000)
    augroup END
  ]], filetype, file_extension))
end

local function on_attach(_, bufnr)
  require'lsp_signature'.on_attach({
    bind = true,
    handler_opts = {
      border = 'rounded',
    },
    hint_prefix = '',
  }, bufnr)
end

local Lsp = {
  config = function (server_name, opts)
    local filetype = vim.bo.filetype
    local file_extension = vim.fn.expand('%:e')
    local server_available, requested_server = lsp_installer_servers.get_server(server_name)
    if server_available then
      requested_server:on_ready(function ()
        local setup_opts = opts or {}
        setup_opts.capabilities = lsp_capabilities
        setup_opts.on_attach = on_attach
        requested_server:setup(setup_opts)

        -- Config init
        prepare_mappings()
        prepare_events(filetype, file_extension)
      end)
      if not requested_server:is_installed() then
        -- Queue the server to be installed
        requested_server:install()
      end
    end
  end
}

return Lsp
