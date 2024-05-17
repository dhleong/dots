local function try_trim_markdown_code_blocks(lines)
  local language_id = lines[1]:match("^```(.*)")
  if language_id then
    local has_inner_code_fence = false
    for i = 2, (#lines - 1) do
      local line = lines[i]
      if line:sub(1, 3) == "```" then
        has_inner_code_fence = true
        break
      end
    end
    -- No inner code fences + starting with code fence = hooray.
    if not has_inner_code_fence then
      table.remove(lines, 1)
      table.remove(lines)
      return language_id
    end
  end
  return "markdown"
end

-- NOTE: This is a hack to suppress some deprecation warnings on the latest nightly:
-- Let's remove as soon as we can
if vim.islist then
  vim.tbl_islist = vim.islist

  -- This is a good enough proxy for 0.12 nightly
  vim.lsp.util.try_trim_markdown_code_blocks = try_trim_markdown_code_blocks
end

if vim.lsp.get_clients then
  vim.lsp.buf_get_clients = function(opts)
    opts = opts or {}
    opts.bufnr = 0
    return vim.lsp.get_clients(opts)
  end
end
