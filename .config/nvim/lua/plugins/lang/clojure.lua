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

  {
    "hrsh7th/nvim-cmp",
    opts = {
      skip_on_methods = {
        -- Clojure is a lisp! We don't need to add anything
        clojure = true,
      },
    },
  },

  { "tpope/vim-fireplace", ft = "clojure" },

  -- Async semantic highlighting
  { "dhleong/vim-mantel", dev = true },

  -- My extra clojure utils
  -- TODO: Make these lazier?
  {
    "dhleong/vim-hearth",
    dev = true,
    keys = {
      { "cpt", ":call hearth#test#RunForBuffer()<cr>", ft = "clojure" },
      { "glc", ":call hearth#repl#Connect()<cr>", ft = "clojure" },
    },
    init = function()
      vim.g.hearth_create_maps = false
    end,
  },

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
