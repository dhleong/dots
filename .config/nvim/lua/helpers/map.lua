---@diagnostic disable-next-line: deprecated
local spread = unpack or table.unpack

local mappings = {}

local function transform_rhs(rhs)
  if type(rhs) == 'function' then
    local id = '' .. #mappings
    mappings[id] = rhs
    return '<cmd>lua require("helpers.map")._invoke("' .. id .. '")<cr>'
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
  return function (input_rhs)
    local rhs = transform_rhs(input_rhs)

    local call = {spread(config.args)}
    table.insert(call, lhs)
    table.insert(call, rhs)
    table.insert(call, config.opts)

    f(spread(call))
  end
end

local function handle(f, args, noremap, lhs, rhs)
  local mapper = create_mapper(f, lhs, {
    args = args,
    opts = {
      noremap = noremap,
      silent = true,
    },
  })

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

local M = {}

function M.buf(lhs, rhs)
  return buffer('n', false, lhs, rhs)
end

function M.buf_nno(lhs, rhs)
  return buffer('n', true, lhs, rhs)
end

function M.nno(lhs, rhs)
  return global('n', true, lhs, rhs)
end

function M.tno(lhs, rhs)
  return global('t', true, lhs, rhs)
end

function M._invoke(id)
  local fn = mappings[id]
  if not fn then
    print(id, vim.inspect(mappings))
  end
  return fn()
end

return M
