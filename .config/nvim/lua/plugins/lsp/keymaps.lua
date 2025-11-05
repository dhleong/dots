local M = {}

local function diagnostic_jump(count)
  return function()
    if vim.wo.diff then
      local flags = ""
      if count < 0 then
        flags = flags .. "b"
      end
      local line = vim.fn.search("^<<<<<<<", flags)
      if line ~= 0 then
        -- Found something!
        return
      end

      print("No more conflicts found!")
      -- NOTE: fall through to diagnostic jump
    end

    if vim.diagnostic.jump then
      vim.diagnostic.jump({ count = count, float = true })
    elseif count < 0 then
      ---@diagnostic disable-next-line: deprecated
      vim.diagnostic.goto_prev()
    else
      ---@diagnostic disable-next-line: deprecated
      vim.diagnostic.goto_next()
    end
  end
end

local function show_doc()
  -- This is a little yuck...
  if vim.o.filetype == "lua" then
    require("ft.lua").doc()
  else
    vim.lsp.buf.hover()
  end
end

function M.build()
  -- stylua: ignore
  return {
    { 'K',   show_doc },
    { 'gd',  vim.lsp.buf.definition, has = "definition" },
    { 'gid', vim.lsp.buf.implementation },
    { 'gyd', vim.lsp.buf.type_definition, desc = "Goto T[ype] Definition" },
    { 'gD',  vim.lsp.buf.declaration, desc = "Goto Declaration" },

    { '<c-w>gd',    function() require 'dhleong.nav'.lsp_in_new_tab('definition') end },
    { '<c-w>gid',   function() require 'dhleong.nav'.lsp_in_new_tab('implementation') end },
    { '<leader>js', vim.lsp.buf.references },
    { '<leader>jr', vim.lsp.buf.rename },

    { '<m-cr>',     vim.lsp.buf.code_action },
    { '[c',         diagnostic_jump(-1) },
    { ']c',         diagnostic_jump(1) },
  }
end

return M
