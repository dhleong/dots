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

  {
    "dhleong/mini-unpairs",
    dir = ".",
    opts = {
      -- It *is* used for chars, but probably much more commonly
      -- for lifetimes where this is annoying
      rust = {
        ["'"] = { neigh_pattern = "[^&<]." },
        [">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\>]." },
      },
    },
    config = function(_, opts)
      require("dhleong.mini-unpairs").setup(opts)
    end,
  },

  -- Feels like a bit much to me atm; may try again later:
  { "rustaceanvim", enabled = false },

  {
    "Saecki/crates.nvim",
    opts = function(_, opts)
      opts.src = nil
      opts.completion = {
        cmp = {
          enabled = true,
        },
      }
    end,
  },

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

  {
    "hrsh7th/nvim-cmp",
    opts = {
      skip_on_methods = {
        -- Rust doesn't need our on_methods bracket insertion, because
        -- it provides them already via snippets or something. If it
        -- *doesn't* provide them, it's probably an attribute in a
        -- proc_macro or something, so we don't need it
        rust = true,
      },
    },
  },
}
