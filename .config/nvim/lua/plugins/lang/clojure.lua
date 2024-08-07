return {
  -- TODO: Add to hearth?
  {
    dir = ".",
    init = function()
      vim.filetype.add({
        pattern = {
          [".*"] = {
            priority = -math.huge,
            function(_, bufnr)
              local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
              if vim.startswith(content, "#!/usr/bin/env bb") then
                return "clojure"
              end
            end,
          },
        },
      })
    end,
  },

  { "tpope/vim-fireplace", ft = "clojure" },

  -- Async semantic highlighting
  { "dhleong/vim-mantel", dev = true },

  -- My extra clojure utils
  -- TODO: Make these lazier?
  { "dhleong/vim-hearth", dev = true },

  { "guns/vim-clojure-static", ft = "clojure" },
  { "guns/vim-sexp", ft = "clojure" },
  { "tpope/vim-sexp-mappings-for-regular-people", ft = "clojure" },

  {
    "dhleong/mini-unpairs",
    dir = ".",
    opts = {
      clojure = { "`", "'" },
    },
    config = function(_, opts)
      require("dhleong.mini-unpairs").setup(opts)
    end,
  },
}
