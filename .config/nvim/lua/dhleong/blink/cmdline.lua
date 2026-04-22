local fuzzy = require("blink.cmp.fuzzy")

local function is_command_line(types)
  -- NOTE: inlined from https://github.com/saghen/blink.cmp/blob/90d14caca4ae557665ab105080c27d5f289a2e30/lua/blink/cmp/sources/cmdline/utils.lua#L28
  -- to avoid churn if it moves or changes again
  local mode = vim.api.nvim_get_mode().mode
  if mode ~= "c" and vim.fn.getcmdwintype() == "" then
    return false
  end

  if not types or #types == 0 then
    return true
  end

  local cmdtype = mode == "c" and vim.fn.getcmdtype() or vim.fn.getcmdwintype()
  return vim.tbl_contains(types, cmdtype)
end

local source = {}

function source.new()
  local self = setmetatable({}, { __index = source })
  self.opts = { max_lines = 500 } -- TODO: accept an option
  return self
end

function source:enabled()
  return vim.bo.ft ~= "vim" and is_command_line({ "@" })
end

function source:get_completions(_, callback)
  local items = {}
  local limit = vim.fn.histnr("@")
  if limit > 0 then
    local found = {}

    local start = 1
    if limit > self.opts.max_lines then
      start = limit - self.opts.max_lines
    end

    for i = start, limit do
      local history_row = vim.fn.histget("@", i)
      local words = fuzzy.get_words(history_row)

      for _, keyword in ipairs(words) do
        if keyword:len() > 1 and not found[keyword] then
          found[keyword] = true

          --- @type lsp.CompletionItem
          local item = {
            label = keyword,
            kind = require("blink.cmp.types").CompletionItemKind.Keyword,
          }
          table.insert(items, item)
        end
      end
    end
  end

  callback({
    items = items,
    is_incomplete_backwards = false,
    is_incomplete_forward = false,
  })
end

return source
