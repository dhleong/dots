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
    "tpope/vim-rhubarb",
    event = "VeryLazy",
    dependencies = {
      {
        "tpope/vim-fugitive",
        keys = {
          -- "Git no-verify commit"
          { "<leader>gnc", ":Git commit -a --no-verify<cr>" },
        },
        config = function()
          vim.cmd.source("~/.vim/init/github.vim")

          -- Having Gbrowse declared but a no-op can make it kinda annoying
          -- to actually get to GBrowse
          pcall(vim.api.nvim_del_user_command, "Gbrowse")
        end,
      },
    },
  },

  {
    "dhleong/lilium",
    dev = true,
    event = "VeryLazy",
    build = "cargo build",
    opts = {
      -- NOTE: It'd be nice if we could use the normal lazy lsp init
      -- but for some reason that doesn't work...?
      setup_lsp = {},
    },
  },
}
