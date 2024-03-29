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

local function fast_cmp_visible()
  -- NOTE: cmp:visible() is quite slow, and we use it on a fairly
  -- hot path. This hack reaches in to speed up the check
  if not (cmp.core.view and cmp.core.view.custom_entries_view) then
    return false
  end
  return cmp.core.view.custom_entries_view:visible()
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
    if fast_cmp_visible() and cmp.get_active_entry() then
      local entry = cmp.get_active_entry()

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
  }, {
    { name = 'nvim_lsp_signature_help' },
  }),
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      require 'cmp-under-comparator'.under,
      cmp.config.compare.recently_used,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,

      -- Prefer local vars in ties. Might also try .locality here
      -- (which uses distance to cursor)
      cmp.config.compare.scopes,
    },
  },
})

local function find_file(params, files)
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

require 'mason'.setup {
  pip = {
    -- We tend to need to upgrade pip for eg ruff to get installed correctly
    upgrade_pip = true,
  },
}
require 'mason-lspconfig'.setup {
  automatic_installation = true,
}

-- Load all lsp configs automatically
local lsp_config_languages = vim.fn.glob('~/.config/nvim/lua/init/lsp/*', false, true)
for _, language_file in ipairs(lsp_config_languages) do
  local language = vim.fn.fnamemodify(language_file, ':t:r')
  require('init.lsp.' .. language)
end

local function optional_require(ns, opts)
  opts = opts or {}
  local path = opts.path
  return function()
    local ok, mod = pcall(require, ns)
    local result = nil
    if ok and path then
      result = mod[path[1]]
    elseif ok then
      result = mod
    end

    if result and opts.with then
      return result.with(opts.with)
    end

    return result
  end
end

local function can_find_some_file(...)
  local files = vim.tbl_flatten({ ... })
  return function(params)
    -- TODO Possibly, cache this per-buffer
    return find_file(params, files)
  end
end

require 'null-ls.config'.reset()
require 'null-ls.sources'.reset()
require 'null-ls'.setup {
  sources = {
    optional_require('none-ls.code_actions.eslint_d'),
    require('null-ls').builtins.diagnostics.clj_kondo,
    optional_require('none-ls.diagnostics.eslint_d', {
      with = {
        runtime_condition = can_find_some_file('.eslintrc', '.eslintrc.js'),
      },
    }),
    optional_require('none-ls.diagnostics.ruff', {
      with = {
        runtime_condition = can_find_some_file('.ruff.toml'),
      },
    }),
    require('null-ls').builtins.diagnostics.stylelint,
    optional_require('none-ls.formatting.ruff', {
      with = {
        runtime_condition = can_find_some_file('.ruff.toml'),
      },
    }),
    optional_require('none-ls.formatting.ruff_format', {
      with = {
        runtime_condition = can_find_some_file('.ruff.toml'),
      },
    }),
    require('null-ls').builtins.formatting.prettier.with {
      runtime_condition = can_find_some_file('.prettierrc', '.prettierrc.js', '.prettierrc.json'),
    },
    require('null-ls').builtins.formatting.swiftformat,
    optional_require('lilium', { path = 'completer' }),
    require('dhleong.null_ls.filename'),
    optional_require('kodachi.null-ls.completion')
  },
}

require 'postprod'.setup()
