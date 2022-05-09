local map = require'helpers.map'

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


-- ======= LSP config =====================================

require('helpers.lsp').config('clojure_lsp', {
  -- NOTE: This gets passed as initializationOptions; clojure_lsp doesn't seem
  -- to otherwise respect our config update if we put it under settings...
  init_options = {
    -- NOTE: If we need to debug the lsp, we can uncomment the next line:
    -- ['log-path'] = '/tmp/clojure-lsp.out',

    -- NOTE: This hard-disables ALL formatting; probably don't need
    -- ['document-formatting'] = false,
    -- ['document-range-formatting'] = false,

    -- May end up clearing these, but for now this causes minimal diffs...
    cljfmt = {
      ['indentation?'] = false,
      ['remove-consecutive-blank-lines?'] = false,
    },

    linters = {
      ['clojure-lsp/unused-public-var'] = {
        level = ':off',
      },
    },
  },
})
