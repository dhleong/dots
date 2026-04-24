local extra_max_memory = {
  maxTsServerMemory = 16184,
}

local tsserver_settings = {
  javascript = {
    showUnused = false,
    suggestionActions = {
      enabled = false,
    },
    tsserver = extra_max_memory,
  },
  typescript = {
    showUnused = false,
    tsserver = extra_max_memory,
  },

  -- So for now we ignore specific annoying ones
  diagnostics = {
    ignoredCodes = {
      -- These can be found here:
      -- https://github.com/microsoft/TypeScript/blob/master/src/compiler/diagnosticMessages.json

      6133, -- "X Is declared but its value is never read"
      80001, -- "This is a CommonJS file"
      80005, -- "This require may be converted to an import"
      80006, -- "This may be converted to an async function"
    },
  },
}

return {
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.linting.eslint" },

  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsgo = {
          enabled = true,
          settings = tsserver_settings,

          -- Don't use tsserver or eslint's formatting
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
          end,
        },
        vtsls = {
          enabled = false,
          settings = tsserver_settings,

          -- Don't use tsserver or eslint's formatting
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
          end,
        },
        ts_ls = {
          settings = tsserver_settings,

          -- Don't use tsserver or eslint's formatting
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
          end,
        },
      },
    },
  },
}
