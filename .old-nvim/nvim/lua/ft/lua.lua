local parsers = require "nvim-treesitter.parsers"

local function get_node_text(node, buffer)
  if vim.treesitter.get_node_text then
    return vim.treesitter.get_node_text(node, buffer or 0)
  end
  return vim.treesitter.query.get_node_text(node, buffer or 0)
end

local M = {}

function M.doc_default()
  vim.lsp.buf.hover()
end

function M.doc_vim()
  local ok, err = pcall(vim.cmd.help, vim.fn['scriptease#helptopic']())
  if not ok then
    print(err)
  end
end

function M.doc()
  if not parsers.has_parser() then
    return M.doc_default()
  end

  local node = vim.treesitter.get_node()
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
  local node_string = get_node_text(node:parent(), 0)
  if vim.startswith(node_string, 'vim.fn.') then
    return M.doc_vim()
  elseif vim.startswith(node_string, 'vim.') then
    local query = ':help ' .. node_string
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
