return {
  { import = "lazyvim.plugins.extras.lang.python" },

  {
    -- I don't use this, and it's whining about... something
    "venv-selector.nvim",
    enabled = false,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- NOTE: LazyVim's auto_brackets conflict with our own handling
      opts.auto_brackets = {}
    end,
  },

  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyrefly = {
          -- Use pyrefly as a diagnostics engine only; let pyright own all the
          -- interactive features (definition, hover, references, ...). Every
          -- interactive feature is a `*Provider` capability, so drop them all
          -- (except pull-diagnostics) and leave the document-sync machinery
          -- intact. Diagnostics are server-pushed, so they keep flowing.
          on_init = function(client)
            local caps = client.server_capabilities
            for name in pairs(caps) do
              if name:match("Provider$") and name ~= "diagnosticProvider" then
                caps[name] = nil
              end
            end
          end,
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                -- logLevel = 'Trace',

                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                diagnosticSeverityOverrides = {
                  reportSelfClsParameterName = "off",
                },
              },
            },
          },
        },
      },
    },
  },
}
