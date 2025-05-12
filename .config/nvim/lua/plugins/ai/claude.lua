return {
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {},
    keys = {
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
    },
  },
}
