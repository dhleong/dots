local function debug_nearest()
  local helper = require("ft.rust")
  local module = helper.get_nearest_module()

  print("Compiling " .. module .. "...")

  local path = helper.compile_module_for_executable(module)
  if not path then
    print("No executable produced")
    return
  end

  -- NOTE: Some projects need the DYLD_LIBRARY_PATH to be set explicitly
  -- or else they crash when run, complaining about "no LC_RPATH's found"
  -- for @rpath/libstd-*. Let's go ahead and handle that:
  local sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

  require("dap").run({
    type = "codelldb",
    request = "launch",
    name = "Run nearest",
    program = path,
    args = { module },
    env = {
      DYLD_LIBRARY_PATH = sysroot .. "/lib",
    },
  })
end

return {
  { import = "lazyvim.plugins.extras.lang.rust" },

  -- Feels like a bit much to me atm; may try again later:
  { "rustaceanvim", enable = false },

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

  {
    "mason-nvim-dap.nvim",
    keys = {
      {
        "<leader>rd",
        debug_nearest,
        desc = "Debug Nearest",
      },
    },
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "codelldb" })
    end,
  },
}
