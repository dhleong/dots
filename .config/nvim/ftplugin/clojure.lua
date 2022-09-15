local map = require 'helpers.map'

-- ======= Options, etc ====================================

-- Continue comments with 'enter'
vim.bo.formatoptions = vim.bo.formatoptions .. 'r'

-- hearth configs
--

vim.g.hearth_ignored_build_ids = { ':ci' }
vim.g.hearth_ignored_build_regex = ':ci.*'

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
