local map = require 'helpers.map'

-- ======= Options, etc ====================================

-- Continue comments with 'enter'
vim.bo.formatoptions = vim.bo.formatoptions .. 'r'

-- hearth configs
--

--
-- vim-clojure-static configs
--

vim.g.clojure_align_multiline_strings = 1

vim.g.clojure_fuzzy_indent_patterns = {
  -- Common:
  '^with', '^def', '^let', '^plet', '^go-loop', '^fn-', '^when-',

  -- Spade:
  '^at-media',

  -- Specter:
  '^recursive-path', '^if-path',

  -- match:
  '^match',
}


-- ======= Custom maps ====================================

-- Execute the 'last' quasi-repl command
map.buf 'cql' 'cqp<up><cr>'

-- Paste AFTER the current form, on the same level of indentation
map.buf_nno('gpp', function()
  -- NOTE: We use the blackhole register to cleanup whitespace (added to maintain
  -- indentation) without trashing the paste register
  local macro = '%a<cr><space><esc>p%"_X'

  local col = vim.fn.col('.')
  local ch = string.sub(vim.fn.getline('.'), col, col)
  if ch ~= '(' then
    -- NOTE: When not already at the beginning, % will take you there.
    -- We want to be at the end!
    macro = '%' .. macro
  end

  local keys = vim.api.nvim_replace_termcodes(macro, true, false, true)
  vim.api.nvim_feedkeys(keys, 'n', false)
end)

map.buf_nno('cnpr', function()
  local ns = 'clojure'
  if 'cljs' == vim.fn.expand('%:e') then
    ns = 'cljs'
  end

  -- NOTE: if we just eval directly, shadow may simply echo it in the console
  -- instead of returning it (this could also just be due to an old version
  -- of shadow...)
  -- call fireplace#eval('(' . ns . '.pprint/pp)')

  -- NOTE: this is a bit hacky, since fireplace#platform().Eval is nil for some reason.
  -- So, we use a vimscript bridge to get the result map, and work with that
  local resp = vim.fn['dhleong#clojure#PlatformEval']('(symbol (with-out-str (' .. ns .. '.pprint/pp)))')
  print(table.concat(resp.value, '\n'))
end)

local augroup = vim.api.nvim_create_augroup('dhleongClojure', {})
vim.api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'FireplaceActivate',
  callback = function()
    map.override.buf('cpr', function()
      vim.fn['hearth#test#RunForBuffer']()
    end)
  end
})
