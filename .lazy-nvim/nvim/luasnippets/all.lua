local banner = {
  length = 60,
  before = 7,
  char = "=",
}

-- Based on honza/vim-snippets
local function parse_comments(s) -- {{{
  return vim.tbl_map(function(flags_text_pair)
    local split = vim.split(flags_text_pair, ":")
    local flags = split[1]
    if flags == "" then
      return {
        type = "other",
        middle_lines = table.concat(split, ":", 2),
      }
    end

    if flags:find("b") then
      return {
        type = "single",
        middle_lines = table.concat(split, ":", 2),
      }
    end

    if flags:find("s") and not flags:find("O") then
      return {
        type = "triple",
        middle_lines = "", -- TODO
      }
    end

    return {}
  end, vim.split(s, ","))
end -- }}}

local function pick_banner_prefix() -- {{{
  local s = vim.o.commentstring
  if vim.endswith(s, "%s") then
    return vim.fn.trim(s:sub(0, #s - 2))
  end

  local comments = parse_comments(vim.o.comments)
  for _, comment in ipairs(comments) do
    if comment.type == "single" then
      return comment.middle_lines
    end
  end

  return comments[1].middle_lines
end -- }}}

return {
  s(
    "banner",
    fmt("\n{comment} {before} {label} {after}\n", {
      comment = sn(2, { f(pick_banner_prefix) }),
      before = f(function()
        return string.rep(banner.char, banner.before, "")
      end, {}),
      label = i(1, "Heading"),
      after = f(function(args)
        local separators_count = 3
        local label = args[1][1]
        local comment = args[2][1]
        local after_len = banner.length - banner.before - #label - separators_count - #comment
        return string.rep(banner.char, after_len, "")
      end, { 1, 2 }, {}),
    })
  ),
}
