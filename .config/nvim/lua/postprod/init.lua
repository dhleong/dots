local async = require 'plenary.async'

local builtins = {
  'postprod.handlers.eslint',
}

local function ignore_trailing_newlines(s)
  local only_at_end = 2
  return vim.fn.trim(s, '\n', only_at_end)
end

local function handle_request(request)
  local original_content = request.content

  for _, handler in ipairs(request.handlers) do
    if type(handler) == 'string' then
      handler = require(handler)
    end
    handler.handle(request)

    if vim.b[request.bufnr].changedtick ~= request.changedtick or vim.bo[request.bufnr].modified then
      return
    end
  end

  -- TODO: We could record the changenr to avoid re-running on a no-op save
  if ignore_trailing_newlines(original_content) ~= ignore_trailing_newlines(request.content) then
    local lines = vim.fn.split(request.content, '\n')
    vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, lines)

    if vim.fn.bufnr('%') == request.bufnr then
      vim.cmd [[ write ]]
    end
  end
end

local M = {
  handlers = {},
}

function M.register(handler)
  local module = handler
  if type(module) == 'string' then
    module = require(module)
  end

  for _, ft in ipairs(module.filetypes) do
    if not M.handlers[ft] then
      M.handlers[ft] = {}
    end
    table.insert(M.handlers[ft], handler)
  end
end

function M.on_buf_write_post()
  local ft = vim.bo.filetype
  local handlers = M.handlers[ft]
  if not handlers or vim.tbl_isempty(handlers) then
    return
  end

  local bufnr = vim.fn.bufnr('%')
  local request = {
    bufnr = bufnr,
    changedtick = vim.b.changedtick,
    content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n'),
    cwd = vim.fn.getcwd(),
    handlers = handlers,
    path = vim.fn.expand('#' .. bufnr .. ':p'),
  }

  async.run(function()
    handle_request(request)
  end)
end

function M.setup(opts)
  if opts and not opts.default then
    M.handlers = {}
  end

  vim.cmd [[
    augroup postprod
      autocmd!
      autocmd BufWritePost * lua require'postprod'.on_buf_write_post()
    augroup END
  ]]
end

-- Convenience for hot reload
for _, module_name in ipairs(builtins) do
  M.register(module_name)
end

return M
