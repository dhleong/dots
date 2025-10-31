local fuzzy = require("blink.cmp.fuzzy")
local utils = require("blink.cmp.sources.lib.utils")

local source = {}

function source.new()
  local self = setmetatable({}, { __index = source })
  self.opts = { max_lines = 500 } -- TODO: accept an option
  return self
end

function source:enabled()
  return vim.bo.ft ~= "vim" and utils.is_command_line({ "@" })
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
