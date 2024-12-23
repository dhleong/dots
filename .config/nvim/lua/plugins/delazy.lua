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
  -- { "dashboard-nvim", enabled = false },
  -- { "dressing.nvim", enabled = false },
  { "snacks.input", enabled = false },
  { "snacks.dashboard", enabled = false },
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
