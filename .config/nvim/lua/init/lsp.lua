local cmp = require 'cmp'

local function entry_has_key(entry, key)
  if not entry.completion_item then
    return
  end

  if entry.completion_item.textEdit then
    return entry.completion_item.textEdit.newText:find(key, 1, true)
  end

  if entry.completion_item.insertText then
    return entry.completion_item.insertText:find(key, 1, true)
  end
end

---@param key_or_config string|{ key:string, cmdwin: string }
local function try_accept_completion(key_or_config)
  local key = key_or_config
  local cmdwin = nil
  if type(key_or_config) == 'table' then
    key = key_or_config.key
    cmdwin = key_or_config.cmdwin
  end

  return cmp.mapping(function(fallback)
    local entry = cmp.get_active_entry()
    if cmp.visible() and entry then
      cmp.confirm()

      if key and not entry_has_key(entry, key) then
        vim.api.nvim_feedkeys(key, 'nt', false)
      end
    elseif cmdwin and vim.fn.getcmdwintype() ~= '' then
      local to_feed = vim.api.nvim_replace_termcodes(cmdwin, true, false, true)
      vim.api.nvim_feedkeys(to_feed, 'nt', true)
    else
      fallback()
    end
  end, { 'i', 'c' })
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },

  mapping = {
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<Space>'] = try_accept_completion(' '),
    ['('] = try_accept_completion('('),
    ['.'] = try_accept_completion('.'),

    -- NOTE: The enter key is a bit special here; if we use the normal fallback
    -- from the cmdline window, we will end up performing a bunch of edits due to
    -- the fallback mappings from endwise (which would run *after* the cmdline
    -- window gets closed)
    ['<CR>'] = try_accept_completion { cmdwin = '<CR>' },
  },

  preselect = cmp.PreselectMode.None,

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
  }, {
    { name = 'buffer' },
  })
})

local function find_file(params, ...)
  local files = vim.tbl_flatten({ ... })

  local dir = params.bufname
  for _ = 1, 100 do
    local last_dir = dir
    dir = vim.fn.fnamemodify(dir, ':h')
    if not dir or dir == last_dir then
      break
    end

    for _, file in ipairs(files) do
      local candidate = dir .. '/' .. file
      if vim.fn.filereadable(candidate) == 1 then
        return candidate
      end
    end
  end
end

vim.diagnostic.config {
  float = {
    format = function(diagnostic)
      local formatted = ''

      if diagnostic.code then
        formatted = formatted .. '[' .. diagnostic.code .. '] '
      end

      formatted = formatted .. diagnostic.message

      if diagnostic.source then
        formatted = formatted .. '\n\nSource: ' .. diagnostic.source .. ''
      end

      return formatted
    end
  },
}

require 'mason'.setup()
require 'mason-lspconfig'.setup {
  automatic_installation = true,
}

-- Load all lsp configs automatically
local lsp_config_languages = vim.fn.glob('~/.config/nvim/lua/init/lsp/*', false, true)
for _, language_file in ipairs(lsp_config_languages) do
  local language = vim.fn.fnamemodify(language_file, ':t:r')
  require('init.lsp.' .. language)
end

local function optional_require(ns, path)
  return function()
    local ok, mod = pcall(require, ns)
    if ok and path then
      return mod[path[1]]
    elseif ok then
      return mod
    end
  end
end

require 'null-ls.config'.reset()
require 'null-ls.sources'.reset()
require 'null-ls'.setup {
  sources = {
    require('null-ls').builtins.code_actions.eslint_d,
    require('null-ls').builtins.diagnostics.clj_kondo,
    require('null-ls').builtins.diagnostics.eslint_d.with {
      runtime_condition = function(params)
        return find_file(params, '.eslintrc', '.eslintrc.js')
      end
    },
    require('null-ls').builtins.diagnostics.flake8.with {
      cwd = function(params)
        return vim.fn.fnamemodify(params.bufname, ':h')
      end,
    },
    require('null-ls').builtins.formatting.black,
    require('null-ls').builtins.formatting.prettier.with {
      runtime_condition = function(params)
        -- Only run prettier if there's actually a config for it
        -- TODO cache this...
        return find_file(params, '.prettierrc', '.prettierrc.js', '.prettierrc.json')
      end,
    },
    optional_require('lilium', { 'completer' }),
    require('dhleong.null_ls.filename'),
    optional_require('kodachi.null-ls.completion')
  },
}

require 'postprod'.setup()
