---@diagnostic disable-next-line: deprecated
local spread = unpack or table.unpack

local function transform_rhs(opts, rhs)
  if type(rhs) == 'function' then
    opts.callback = rhs
    return ''
  elseif type(rhs) == 'table' then
    local s = ''

    if rhs.lua_module then
      s = s .. "require'" .. rhs.lua_module .. "'."
    end
    if rhs.lua_call then
      s = s .. rhs.lua_call
    end

    if rhs.lua_call or rhs.lua_module then
      s = '<cmd>lua ' .. s .. '<cr>'
    end

    if rhs.vim_call then
      s = '<cmd>call ' .. rhs.vim_call .. '<cr>'
    end

    return s
  end

  return rhs
end

local function create_mapper(f, lhs, config)
  return function(input_rhs)
    local mode = config.args[#config.args - 1]
    if not config.override and vim.fn.mapcheck(lhs, mode) ~= "" then
      -- Already a mapping; don't override (unless requested)
      return
    end

    local rhs = transform_rhs(config.opts, input_rhs)

    local call = { spread(config.args) }
    table.insert(call, lhs)
    table.insert(call, rhs)
    table.insert(call, config.opts)

    f(spread(call))
  end
end

local function handle(f, args, opts, lhs, rhs)
  local mapper = create_mapper(f, lhs, vim.tbl_extend('force', opts, {
    args = args,
    opts = {
      noremap = opts.noremap,
      silent = true,
    },
  }))

  if rhs then
    return mapper(rhs)
  end

  return mapper
end

local function global(mode, noremap, lhs, rhs)
  return handle(vim.api.nvim_set_keymap, { mode }, noremap, lhs, rhs)
end

local function buffer(mode, noremap, lhs, rhs)
  return handle(vim.api.nvim_buf_set_keymap, { 0, mode }, noremap, lhs, rhs)
end

local function create_interface(opts)
  local iface = {}

  function iface.buf(lhs, rhs)
    return buffer('n', vim.tbl_extend('force', opts, { noremap = false }), lhs, rhs)
  end

  function iface.buf_nno(lhs, rhs)
    return buffer('n', vim.tbl_extend('force', opts, { noremap = true }), lhs, rhs)
  end

  function iface.nno(lhs, rhs)
    return global('n', vim.tbl_extend('force', opts, { noremap = true }), lhs, rhs)
  end

  function iface.tno(lhs, rhs)
    return global('t', vim.tbl_extend('force', opts, { noremap = true }), lhs, rhs)
  end

  return iface
end

local M = create_interface({})

M = setmetatable(M, {
  __index = function(table, index)
    -- NOTE: This just lets us set a single flag... we could perhaps build
    -- something more recursive to get eg map.override.nno.buf, but... this is fine for now
    if index == 'override' then
      return create_interface({ override = true })
    end
    return rawget(table, index)
  end
})

return M
