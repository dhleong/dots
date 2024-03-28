return {
  -- NOTE: clangd isn't a "language" but it fits here, maybe? Basically just want
  -- to stop clangd from poking its nose in languages it doesn't actually seem to
  -- work great in.
  {
    "nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          filetypes = { "c", "cpp", "cuda" },
        },
      },
    },
  },
}
