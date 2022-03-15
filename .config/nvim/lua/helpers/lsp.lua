local lsp_installer_servers = require 'nvim-lsp-installer.servers'
local cmp_nvim_lsp = require 'cmp_nvim_lsp'
local map = require'helpers.map'

local lsp_capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- NOTE: Uncomment this line to get more logging output from LSP servers for debug purposes:
-- vim.lsp.set_log_level("trace")

vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
  print('[' .. client.name .. '][' .. lvl .. '] ' .. result.message)
end

local function prepare_mappings()
  local function nmap(lhs, lua)
    map.buf_nno(lhs, { lua_call = lua })
  end
  local function vim_map(lhs, vim_command)
    local rhs = 'vim.' .. vim_command
    nmap(lhs, rhs)
  end
  local function lsp_map(lhs, lsp_command)
    local rhs = 'lsp.' .. lsp_command
    vim_map(lhs, rhs)
  end

  lsp_map('K', 'buf.hover()')
  lsp_map('gd', 'buf.definition()')
  lsp_map('gid', 'buf.implementation()')
  nmap('<c-w>gd', "require'dhleong.nav'.lsp_in_new_tab('definition')")
  nmap('<c-w>gid', "require'dhleong.nav'.lsp_in_new_tab('implementation')")
  lsp_map('<leader>js', 'buf.references()')
  lsp_map('<leader>jr', 'buf.rename()')
  lsp_map('<m-cr>', 'buf.code_action()')

  vim_map('[c', 'diagnostic.goto_prev()')
  vim_map(']c', 'diagnostic.goto_next()')

  vim.ui.input = function (opts, on_confirm)
    require'dhleong.ui'.input(opts, on_confirm)
  end

  vim.ui.select = function (items, opts, on_choice)
    require'dhleong.ui'.select(items, opts, on_choice)
  end
end

local function prepare_events(filetype, file_extension)
  vim.cmd(string.format([[
    augroup lsp_autocmds_%s
      autocmd!
      autocmd BufWritePre *.%s lua vim.lsp.buf.formatting_seq_sync(nil, 2000)
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

local configured = {}

local Lsp = {}

function Lsp.config(server_name, opts)
  local filetype = vim.bo.filetype
  if configured[filetype] then
    prepare_mappings()
    return
  end

  local file_extension = vim.fn.expand('%:e')
  local server_available, requested_server = lsp_installer_servers.get_server(server_name)
  if server_available then
    requested_server:on_ready(function ()
      local setup_opts = opts or {}
      setup_opts.capabilities = lsp_capabilities

      if setup_opts.update_capabilities then
        local duplicate = vim.deepcopy(setup_opts.capabilities)
        setup_opts.update_capabilities(duplicate)
        setup_opts.capabilities = duplicate
      end

      -- Wrap any provided on_attach callback
      local provided_on_attach = setup_opts.on_attach

      -- Integrate with otsukare
      local otsukare_on_attach = nil
      local ok, otsukare_module = pcall(require, 'otsukare.' .. filetype)
      if ok and otsukare_module then
        otsukare_on_attach = otsukare_module.lsp_on_attach
      end

      if provided_on_attach or otsukare_on_attach then
        setup_opts.on_attach = function (client, bufnr)
          local any = nil
          if provided_on_attach then
            local result = provided_on_attach(client, bufnr)
            if result then
              any = result
            end
          end
          if otsukare_on_attach then
            local result = otsukare_on_attach(client, bufnr)
            if result then
              any = result
            end
          end
          return on_attach(client, bufnr) or any
        end
      else
        setup_opts.on_attach = on_attach
      end

      -- Integrate with otsukare
      if ok and otsukare_module and otsukare_module.lsp_update_config then
        local duplicate = vim.deepcopy(setup_opts)
        otsukare_module.lsp_update_config(duplicate)
        setup_opts = duplicate
      end

      requested_server:setup(setup_opts)

      -- Config init
      configured[filetype] = true
      prepare_mappings()
      prepare_events(filetype, file_extension)
    end)
    if not requested_server:is_installed() then
      -- Queue the server to be installed
      requested_server:install()
    end
  end
end

return Lsp
