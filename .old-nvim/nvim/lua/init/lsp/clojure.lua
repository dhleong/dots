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

