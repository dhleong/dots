vim.filetype.add({
  extension = {
    fnl = "fennel",
    -- fnl = "clojure",
  },
})

-- NOTE: Some other configs live in ./clojure.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "fennel" } },
  },
}
