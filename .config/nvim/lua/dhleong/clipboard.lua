local function encode_osc52_tmux(lines)
  -- With help from: https://github.com/ojroques/vim-oscyank
  local base64 = table.concat(vim.fn.systemlist({ 'base64' }, lines))
  local trimmed, _ = string.gsub(base64, '%s*$', '')
  return '\x1BPtmux;\x1B\x1B]52;c;' .. trimmed .. '\x07\x1B\\'
end

local function determine_usable_register(for_register)
  -- There seems to be a regression or something in 0.10 where
  -- writing to */+ no longer work. I never use the z register,
  -- so I guess this is...fine?
  if for_register == '*' or for_register == '+' then
    if vim.version().prerelease then
      return 'z'
    end
  end

  return for_register
end

local function create_copy(for_register)
  local register = determine_usable_register(for_register)
  return function(lines)
    vim.b.lines = lines
    vim.fn.setreg(register, lines)

    -- I only use tmux on remote systems; in such cases, attempt to use
    -- OSC52 to send copies back to the host system's clipboard:
    if vim.env.TMUX and vim.fn.filewritable('/dev/fd/2') then
      local osc = encode_osc52_tmux(lines)
      vim.fn.writefile({ osc }, '/dev/fd/2', 'b')
    end
  end
end

local function create_paste(for_register)
  local register = determine_usable_register(for_register)
  return function()
    -- I can't yet figure out how to read from the host clipboard, but
    -- at least I can use <apple-v> to paste from it, so not as big of a
    -- deal as writing to it (where I might want to copy an url to open
    -- in a browser, for example)
    local info = vim.fn.getreginfo(register)
    return { info.regcontents, info.regtype }
  end
end

local M = {}

function M.create()
  return {
    name = 'tmux-system-clipboard-integration',
    copy = {
      ["*"] = create_copy('*'),
      ["+"] = create_copy('+'),
    },
    paste = {
      ["*"] = create_paste('*'),
      ["+"] = create_paste('+'),
    },
  }
end

return M
