local lsp_installer_servers = require 'nvim-lsp-installer.servers'
local cmp_nvim_lsp = require 'cmp_nvim_lsp'

local lsp_capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local function prepare_mappings()
  local function nmap(lhs, lsp_command)
    local rhs = '<cmd>lua vim.lsp.' .. lsp_command .. '<cr>'
    vim.api.nvim_buf_set_keymap(0, 'n', lhs, rhs, {
      noremap = true
    })
  end

  nmap('K', 'buf.hover()')
  nmap('gd', 'buf.definition()')
  nmap('gid', 'buf.implementation()')
  nmap('<leader>js', 'buf.references()')
  nmap('<leader>jr', 'buf.rename()')
  nmap('<m-cr>', 'buf.code_action()')

  nmap('[c', 'diagnostic.goto_prev()')
  nmap(']c', 'diagnostic.goto_next()')
end

local function prepare_events(filetype, file_extension)
  vim.cmd(string.format([[
    augroup lsp_autocmds_%s
      autocmd!
      autocmd BufWritePre *.%s lua vim.lsp.buf.formatting_seq_sync(nil, 1000)
    augroup END
  ]], filetype, file_extension))
end

local Lsp = {
  config = function (server_name, opts)
    local filetype = vim.bo.filetype
    local file_extension = vim.fn.expand('%:e')
    local server_available, requested_server = lsp_installer_servers.get_server(server_name)
    if server_available then
      requested_server:on_ready(function ()
        opts.capabilities = lsp_capabilities
        requested_server:setup(opts or {})

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
