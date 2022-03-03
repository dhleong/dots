local a = require'plenary.async'

---@alias CommandArgs {command: string|string[], cwd: string}

local M = {}

---@param args CommandArgs
M.run = a.wrap(function (args, done)
  vim.fn.jobstart(args.command, {
    stdin = "null",
    stdout_buffered = true,
    on_exit = function (_, code, _)
      if code ~= 0 then
        done(nil)
      end
    end,
    on_stdout = function (_, stdout, _)
      if stdout[#stdout] == '' then
        stdout = vim.list_slice(stdout, 1, #stdout-1)
      end
      done(stdout)
    end
  })
end, 2)

return M
