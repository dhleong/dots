local lspconfig = require 'lspconfig'
local cmp_nvim_lsp = require 'cmp_nvim_lsp'

local map = require 'helpers.map'
local fn = require 'dhleong.functional'

local lsp_capabilities = cmp_nvim_lsp.default_capabilities()

-- NOTE: Uncomment this line to get more logging output from LSP servers for debug purposes:
-- vim.lsp.set_log_level("trace")

vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
  print('[' .. client.name .. '][' .. lvl .. '] ' .. result.message)
end

local function prepare_commands()
  vim.api.nvim_buf_create_user_command(0, 'W', function()
    vim.b.lsp_no_auto_format = 1
    vim.cmd.write()
    vim.b.lsp_no_auto_format = nil
  end, {})
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

  vim.ui.input = function(opts, on_confirm)
    require 'dhleong.ui'.input(opts, on_confirm)
  end

  vim.ui.select = function(items, opts, on_choice)
    require 'dhleong.ui'.select(items, opts, on_choice)
  end
end

local function prepare_events(filetype)
  vim.cmd(string.format([[
    augroup lsp_autocmds_%s
      autocmd!
      autocmd FileType %s lua require'helpers.lsp'.on_attach()
    augroup END
  ]], filetype, filetype, filetype))
end

local function on_attach(_, bufnr)
  require 'lsp_signature'.on_attach({
    bind = true,
    handler_opts = {
      border = 'rounded',
    },
    hint_prefix = '',
  }, bufnr)
end

local configured = {}

local Lsp = {}

function Lsp.on_attach()
  -- We could perhaps use a global autocmd for this and run conditionally, but
  -- native lsp uses buffer-specific groups like this and I kinda like it.

  local bufnr = vim.fn.bufnr()
  local augroup_name = "dhleong_lsp_b_" .. bufnr
  local augroup = vim.api.nvim_create_augroup(augroup_name, {})
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    buffer = bufnr,
    desc = 'Auto format using lsp',
    callback = function()
      if vim.b.lsp_no_auto_format == 1 then
        return
      end

      -- NOTE: We temporarily swap to "manual" fold method to avoid collapsing folds on save
      local old_method = vim.wo.foldmethod
      vim.wo.foldmethod = 'manual'

      Lsp.format()

      vim.wo.foldmethod = old_method
    end
  })

  prepare_commands()
  prepare_mappings()
end

function Lsp.format()
  if vim.lsp.buf.format then
    vim.lsp.buf.format {
      timeout_ms = 2000,
      filter = function(client)
        return client.name ~= 'tsserver'
      end
    }
  else
    -- NOTE: This is deprecated:
    vim.lsp.buf.formatting_seq_sync(nil, 2000)
  end
end

function Lsp.config(server_name, provided_opts)
  local opts = provided_opts or {}

  local existing = configured[server_name]
  if existing and vim.deep_equal(existing and existing.settings, opts.settings) then
    -- No change in config
    return
  elseif existing then
    -- Configuration has changed, but the server *is* running! Merge the new settings
    -- with the default config settings and notify the change
    local server = lspconfig[server_name]
    local settings = opts.settings

    local default_settings = server.document_config.default_config.settings
    if default_settings then
      settings = vim.tbl_deep_extend('keep', settings, default_settings)
    end

    -- Notify clients for this buffer that the config has changed
    for _, client in pairs(vim.lsp.buf_get_clients()) do
      if client.name == server_name then
        client.workspace_did_change_configuration(settings)
      end
    end
    return
  end

  -- New, unconfigured server!
  local input_opts = vim.deepcopy(opts)
  local server = lspconfig[server_name]
  local server_filetypes = server.filetypes or server.document_config.default_config.filetypes

  local setup_opts = opts or {}
  setup_opts.capabilities = lsp_capabilities

  -- Allow clients to tweak the capabilities we report to the server
  if setup_opts.update_capabilities then
    -- NOTE: As of cmp-nvim-lsp@389f06d3101fb412db64cb49ca4f22a67882e469, we no longer
    -- have the full capabilities object by default; to keep things simple we only
    -- inflate a full map if the client provides an update_capabilities fn:
    local duplicate = vim.lsp.protocol.make_client_capabilities()
    local new_config = vim.tbl_deep_extend('keep', duplicate, setup_opts.capabilities)

    setup_opts.update_capabilities(new_config)
    setup_opts.capabilities = new_config
  end

  -- Wrap any provided on_attach callback. Note that we call ours *last*
  setup_opts.on_attach = fn.add_hook_before(on_attach, setup_opts.on_attach)
  setup_opts.on_new_config = function(config, root_dir)
    -- Integrate with otsukare
    for _, filetype in ipairs(server_filetypes) do
      local ok, otsukare_module = pcall(require, 'otsukare.' .. filetype)
      if ok and otsukare_module then
        config.on_attach = fn.add_hook_before(config.on_attach, otsukare_module.lsp_on_attach)

        if otsukare_module.lsp_update_config then
          otsukare_module.lsp_update_config(config, root_dir)
        end
      end
    end
  end

  -- Setup the server!
  server.setup(setup_opts)

  -- Config init
  configured[server_name] = input_opts

  for _, filetype in ipairs(server_filetypes) do
    prepare_events(filetype)
  end
end

return Lsp
