-- TODO: Add to hearth?
vim.filetype.add({
  pattern = {
    -- NOTE: This is a HACK to avoid collision with snacks.nvim's bigfile detection
    ["..*"] = {
      function(_, bufnr)
        local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
        if vim.startswith(content, "#!/usr/bin/env bb") then
          return "clojure"
        end
      end,
      { priority = -math.huge },
    },
  },
})

local filetypes = { "clojure", "fennel" }

return {
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = {
      skip_on_methods = {
        -- Clojure is a lisp! We don't need to add anything
        clojure = true,
      },
    },
  },

  { "tpope/vim-fireplace", ft = filetypes },

  -- Async semantic highlighting
  { "dhleong/vim-mantel", dev = true },

  -- My extra clojure utils
  -- TODO: Make these lazier?
  {
    "dhleong/vim-hearth",
    dev = true,
    keys = {
      { "cpt", ":call hearth#test#RunForBuffer()<cr>", ft = filetypes },
      {
        "glc",
        function()
          vim.fn["fireplace#activate"]()
          vim.fn["hearth#repl#Connect"]()
        end,
        ft = filetypes,
      },
      { "<leader>st", ":call hearth#nav#find#Test()<cr>", ft = filetypes },
      { "<leader>nt", ":call hearth#nav#create#Test()<cr>", ft = filetypes },
    },
    init = function()
      vim.g.hearth_create_maps = false
      vim.g.hearth_enable_fennel = true

      vim.g.hearth_ignored_build_ids = { ":ci" }
      vim.g.hearth_ignored_build_regex = ":ci.*"
    end,
  },

  { "guns/vim-clojure-static", ft = filetypes },
  { "guns/vim-sexp", ft = filetypes },
  { "tpope/vim-sexp-mappings-for-regular-people", ft = filetypes },

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
