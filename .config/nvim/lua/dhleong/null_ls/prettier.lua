local original = require('null-ls').builtins.formatting.prettier
local s = require('null-ls.state')
local u = require('null-ls.utils')

return original.with({
  name = 'dhleong/prettier',
  dynamic_command = function(params)
    local lsputil = require("lspconfig.util")

    local resolved = s.get_resolved_command(params.bufnr, params.command)
    -- a string means command was resolved on last run
    -- false means the command already failed to resolve, so don't bother checking again
    if resolved and (type(resolved.command) == "string" or resolved.command == false) then
      return resolved.command
    end

    local found, resolved_cwd
    lsputil.path.traverse_parents(params.bufname, function(dir)
      found = lsputil.path.join(dir, 'node_modules', '.bin', 'prettier')
      if u.is_executable(found) then
        resolved_cwd = dir
        return true
      end

      found = nil
      resolved_cwd = nil
    end)

    if found then
      local is_executable, err_msg = u.is_executable(found)
      assert(is_executable, err_msg)
    end

    s.set_resolved_command(
      params.bufnr,
      params.command,
      { command = found or false, cwd = resolved_cwd }
    )
    return found
  end,
})
