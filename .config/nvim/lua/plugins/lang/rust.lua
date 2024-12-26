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

local diagnostics = vim.g.lazyvim_rust_diagnostics or "rust-analyzer"

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

  --- This obviously is unnecessary in rust. Not sure why it runs in
  --- rust by default... but it breaks our mini-unpairs config for
  --- closing the `>` bracket, so... disable here. This helps when
  --- rust's completion includes brackets for a type, eg:
  ---
  ---   impl<T> Deref for YourType<_>
  ---                     ^^^^^^^^^|^
  ---
  --- In this case the cursor will be at the _ and, with this fix, you
  --- can type the generic param and then `>` to go smoothly *over* the
  --- closing bracket. Without the fix, we just insert a duplicate >
  {
    "nvim-ts-autotag",
    opts = {
      per_filetype = {
        ["rust"] = {
          enable_close = false,
        },
      },
    },
  },

  -- Feels like a bit much to me atm; may try again later:
  { "rustaceanvim", enabled = false },

  {
    "Saecki/crates.nvim",
    opts = function(_, opts)
      opts.src = nil
      opts.completion = {
        cmp = {
          enabled = LazyVim.cmp_engine() == "nvim-cmp",
        },
      }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          enabled = diagnostics == "rust-analyzer",
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
    optional = true,
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
