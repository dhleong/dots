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
