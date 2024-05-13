if not vim.g.lazy_did_setup then
  local map = require("helpers.map")

  require("dhleong.debugger").configure({
    adapter = "CodeLLDB",
  })

  map.nno("<leader>rd")({
    lua_module = "ft.rust",
    lua_call = "debug_nearest()",
  })

  vim.cmd([[command! Debug lua require'ft.rust'.debug_app()]])
end
