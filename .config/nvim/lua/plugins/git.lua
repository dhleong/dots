local function is_unmapped(keys) -- {{{
  local maparg = vim.fn.maparg(keys, "n", false, true)
  return #maparg == 0
end -- }}}

local function ensure_gq_mapped() -- {{{
  if is_unmapped("gq") then
    vim.keymap.set("n", "gq", function()
      if vim.fn.bufnr("$") == 1 then
        vim.cmd.quit()
      else
        vim.cmd.bdelete()
      end
    end, { buffer = true, silent = true })
  end

  if is_unmapped("q") then
    vim.keymap.set("n", "q", "gq", {
      buffer = true,
      silent = true,
      remap = true,
    })
  end
end -- }}}

return {
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    keys = {
      -- "Git no-verify commit"
      { "<leader>gnc", ":Git commit -a --no-verify<cr>" },
    },
    config = function()
      vim.cmd.source("~/.vim/init/github.vim")

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufReadPost" }, {
        group = vim.api.nvim_create_augroup("FugitiveStatusFixGroup", {
          clear = true,
        }),
        pattern = "fugitive://*",
        callback = ensure_gq_mapped,
      })

      -- Having Gbrowse declared but a no-op can make it kinda annoying
      -- to actually get to GBrowse
      pcall(vim.api.nvim_del_user_command, "Gbrowse")
    end,
  },

  {
    "dhleong/lilium",
    dev = true,
    ft = "gitcommit",
    lazy = true,
    event = "VeryLazy",
    cmd = {
      "LiliumInfo",
      -- "GBrowse",  -- Sadly, doing this doesn't work
    },
    dependencies = {
      "tpope/vim-fugitive",
    },
    opts = {},
  },
}
