local parsers = require "nvim-treesitter.parsers"
local ts_utils = require "nvim-treesitter.ts_utils"

local M = {}

function M.doc_default()
  vim.lsp.buf.hover()
end

function M.doc_vim()
  vim.cmd('help ' .. vim.fn['scriptease#helptopic']())
end

function M.doc()
  if not parsers.has_parser() then
    return M.doc_default()
  end

  local node = ts_utils.get_node_at_cursor()
  if not node then
    return M.doc_default()
  end

  -- Figure out the language under the cursor
  local sr, sc, er, ec = node:range()
  local root = parsers.get_parser()
  local language_tree = root:language_for_range { sr, sc, er, ec }
  local language = language_tree:lang()

  if language == 'vim' then
    -- Obvious case; we're in a vim code block
    return M.doc_vim()
  end

  -- Vim fns in the expression
  local node_string = ts_utils.get_node_text(node:parent())
  if vim.startswith(node_string[1], 'vim.fn.') then
    return M.doc_vim()
  elseif vim.startswith(node_string[1], 'vim.') then
    local query = ':help ' .. node_string[1]
    local ok = pcall(vim.cmd, query)
    if not ok then
      M.doc_vim()
    end
    return
  end

  -- Else... assume lua
  return M.doc_default()
end

return M
