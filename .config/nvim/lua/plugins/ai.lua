local AI_PLUGIN = "codecompanion"

return {
  {
    dev = true,
    keys = {
      {
        "g/",
        function()
          require("jean").prompt()
        end,
      },
      {
        "<leader>ctd",
        function()
          require("jean").submit("Implement the TODO or FIXME closest to the current line")
        end,
      },
    },
    "dhleong/jean.nvim",
    opts = {},
  },

  {
    import = "plugins.ai.avante",
    enabled = AI_PLUGIN == "avante",
  },

  {
    import = "plugins.ai.claude",
    enabled = AI_PLUGIN == "claude",
  },

  {
    import = "plugins.ai.codecompanion",
    enabled = AI_PLUGIN == "codecompanion",
  },
}
