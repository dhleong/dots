local AI_PLUGIN = "codecompanion"

return {
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
