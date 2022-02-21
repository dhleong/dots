local async = require'plenary.async'

local function handle_request(request)
  local original_content = request.content

  for _, handler in ipairs(request.handlers) do
    handler.handle(request)

    if vim.b.changetick ~= request.changetick or vim.bo[request.bufnr].modified then
      return
    end
  end

  -- TODO: We could record the changenr to avoid re-running on a no-op save
  if original_content ~= request.content then
    local lines = vim.fn.split(request.content, '\n')
    vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, lines)
  end
end

local M = {
  handlers = {},
}

function M.register(handler)
  for _, ft in ipairs(handler.filetypes) do
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
    changetick = vim.b.changetick,
    content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n'),
    cwd = vim.fn.getcwd(),
    handlers = handlers,
    path = vim.fn.expand('#' .. bufnr .. ':p'),
  }

  async.run(function ()
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

-- Register default handlers
-- TODO: Probably move this inside setup(); it's convenient here for hot reloads
M.register(require'postprod.handlers.eslint')

return M
