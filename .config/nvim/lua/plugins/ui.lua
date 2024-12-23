---@diagnostic disable-next-line: duplicate-set-field
vim.ui.input = function(...)
  return require("dhleong.ui").input(...)
end

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(...)
  return require("dhleong.ui").select(...)
end

return {
  { "rhysd/vim-color-spring-night" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        -- NOTE: For some reason if we apply termguicolors in options, that
        -- breaks the colorscheme (at least, in tmux)
        vim.cmd.colorscheme("spring-night")
        vim.o.termguicolors = true
      end,
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = false,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { "filename" },
        lualine_x = { "filetype" },
        lualine_y = {
          "diagnostics",
          -- { lsp_status, cond = lsp_status_exists }
        },
        lualine_z = { "location" },
      },
    },
  },
}
