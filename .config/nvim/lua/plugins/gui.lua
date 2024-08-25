return {
  {
    dir = ".",
    event = "VeryLazy",
    name = "neovide",
    cond = vim.g.neovide == true,
    keys = {
      {
        "<D-n>",
        function()
          vim.fn.system("open --new -b com.neovide.neovide")
        end,
      },
      { "<D-t>", ":tabe<cr>" },

      -- NOTE: :suspend works like minimize in neovide
      { "<D-m>", ":suspend<cr>" },

      { "<D-v>", '"+P"', mode = "n" },
      { "<D-v>", '"+P"', mode = "v" },
      { "<D-v>", "<C-R>+", mode = "c" },

      -- NOTE: The cursor movement is a cheeky way to remove the highlighting.
      -- It may be a bad idea
      { "<D-v>", '<C-\\><C-N>"+pa<left><right>', mode = "t" },

      -- NOTE: Neovide's docs suggest:
      --   '<ESC>l"+Pli'
      -- but that fails on blank lines....
      { "<D-v>", '<esc>"+gpa', mode = "i" },
    },
    config = function()
      vim.o.guifont = table.concat({
        -- NOTE: We can only specify options at the end, it seems. This feels like a neovide bug
        "Maple Mono",
        "Victor Mono Medium:h15",
      }, ",")

      vim.g.neovide_cursor_animation_length = 0.07
      vim.g.neovide_cursor_animate_command_line = false
      vim.g.neovide_cursor_trail_size = 0.02
      vim.g.neovide_cursor_vfx_mode = "pixiedust"
      vim.g.neovide_scroll_animation_length = 0.1
      vim.g.neovide_hide_mouse_when_typing = true

      -- NOTE: This might be nice if it worked more consistently, but it
      -- doesn't seem to handle changes in pixel density correctly
      -- vim.g.neovide_remember_window_size = true

      -- It might be possible to make this look nice, but right now it's
      -- just distracting:
      vim.g.neovide_floating_shadow = false
    end,
  },
}
