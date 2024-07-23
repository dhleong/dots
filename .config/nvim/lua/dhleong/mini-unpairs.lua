local M = {}

function M.unmap_mini_keys(keys)
  for _, key in ipairs(keys) do
    vim.keymap.set("i", key, key, { buffer = 0, remap = false })
  end
end

function M.setup(opts)
  local augroup = vim.api.nvim_create_augroup("MiniUnpairs", { clear = true })
  for ft, keys in pairs(opts) do
    vim.api.nvim_create_autocmd("FileType", {
      group = augroup,
      pattern = { ft },
      callback = function()
        M.unmap_mini_keys(keys)
      end,
    })
  end
end

return M
