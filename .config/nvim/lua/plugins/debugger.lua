return {
  { import = "lazyvim.plugins.extras.dap.core" },
  { import = "lazyvim.plugins.extras.dap.nlua" },

  {
    "nvim-dap",
    dependencies = {
      {
        "dhleong/nvim-dap-mappings",
        dev = true,
        opts = {
          keymaps = {
            { "gk", dap = "run_to_cursor" },
            { "gi", dap = "step_into" },
            { "gn", dap = "step_over" },
            { "go", dap = "step_out" },
            { "gp", dap = "pause" },
            { "gr", dap = "continue" }, -- "resume"
            { "gq", dap = "terminate" }, -- "quit"
          },
        },
      },
    },
  },
}
