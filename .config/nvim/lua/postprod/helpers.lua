local a = require'plenary.async'
local loop = require'null-ls.loop'

local function async(argc, fn)
  return a.wrap(fn, argc)
end

local M = {}

M.command = async(3, function (args, request, callback)
  local command = args.command
  if args.resolver then
    local ok, resolved = pcall(args.resolver, {
        command = command,
        bufnr = request.bufnr,
        bufname = request.path,
    })
    if ok then
      command = resolved
    end
  end

  if not (command and vim.fn.executable(command)) then
    return
  end

  -- TODO: Plenary's Job causes eslint_d to hang for some reason...
  -- so we use null-ls's job spawning for now. Unfortunately, its env support
  -- doesn't seem to work on coder...
  local on_exit = a.void(function (_, stdout)
    a.util.scheduler()

    if stdout then
      request.content = stdout
      callback(true)
    else
      callback(false)
    end
  end)

  loop.spawn(command, args.args, {
    input = request.content,
    handler = on_exit,
  })
end)

return M
