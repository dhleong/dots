local tsserver_settings = {
  -- NOTE: For whatever reason, these don't seem to be respected...
  javascript = {
    showUnused = false,
    suggestionActions = {
      enabled = false,
    },
  },
  typescript = {
    showUnused = false,
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
  { import = "lazyvim.plugins.extras.linting.eslint" },

  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = {
          settings = tsserver_settings,
        },
      },

      -- Don't use tsserver or eslint's formatting
      setup = {
        tsserver = function()
          local lspFormattingDisabled = {
            tsserver = true,
            eslint = true,
          }
          require("lazyvim.util").lsp.on_attach(function(client)
            if lspFormattingDisabled[client.name] then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
    },
  },
}
