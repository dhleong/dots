return {
  {
    "LazyVim/LazyVim",
    opts = {
      defaults = {
        keymaps = false,
        options = false,
      },
      -- stylua: ignore
      icons = {
        misc = {
          dots = "",
        },
        dap = {
          Stopped             = { "→", "DiagnosticWarn", "DapStoppedLine" },
          Breakpoint          = "B",
          BreakpointCondition = "C",
          BreakpointRejected  = { "R", "DiagnosticError" },
          LogPoint            = ".>",
        },
        diagnostics = {
          Error = "E",
          Warn  = "W",
          Hint  = "H",
          Info  = "I",
        },
        git = {
          added    = "",
          modified = "",
          removed  = "",
        },
        kinds = {
          Array         = "",
          Boolean       = "",
          Class         = "",
          Codeium       = "",
          Color         = "",
          Control       = "",
          Collapsed     = "",
          Constant      = "",
          Constructor   = "",
          Copilot       = "",
          Enum          = "",
          EnumMember    = "",
          Event         = "",
          Field         = "",
          File          = "",
          Folder        = "",
          Function      = "",
          Interface     = "",
          Key           = "",
          Keyword       = "",
          Method        = "",
          Module        = "",
          Namespace     = "",
          Null          = "",
          Number        = "",
          Object        = "",
          Operator      = "",
          Package       = "",
          Property      = "",
          Reference     = "",
          Snippet       = "",
          String        = "",
          Struct        = "",
          TabNine       = "",
          Text          = "",
          TypeParameter = "",
          Unit          = "",
          Value         = "",
          Variable      = "",
        },
      },
    },
  },

  -- Let's disable a ton of plugins:
  { "bufferline.nvim", enabled = false },
  {
    "snacks.nvim",
    opts = {
      dashboard = { enabled = false },
      input = { enabled = false },
      scroll = { enabled = false },
      toggle = { enabled = false },
    },
    init = function()
      -- snacks.scroll is disabled, but just in case there are any
      -- other lingering animations... disable them:
      vim.g.snacks_animate = false
    end,
  },
  -- This may come back in some form, but I don't want its mappings:
  { "fzf-lua", enabled = false },
  { "gitsigns.nvim", enabled = false },
  { "mini.bufremove", enabled = false },
  { "mini.surround", enabled = false },
  { "neo-tree.nvim", enabled = false },
  { "noice.nvim", enabled = false },
  { "nvim-web-devicons", enabled = false },
  { "persistence.nvim", enabled = false },
  { "telescope.nvim", enabled = false },
  { "which-key.nvim", enabled = false },
}
