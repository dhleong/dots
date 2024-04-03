return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          capabilities = {
            -- See: https://github.com/neovim/neovim/issues/23291
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = false,
              },
            },
          },
          settings = {
            ["rust-analyzer"] = {
              check = {
                -- experimental, for monorepos
                workspace = false,
              },
              diagnostics = {
                enable = true,
                disabled = { "unresolved-macro-call", "unresolved-proc-macro" },
                enableExperimental = true,
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
      },
    },
  },
}
