local M = {}

function M.unmap_mini_keys(keys)
  local ok, MiniPairs = pcall(require, "mini.pairs")
  if not ok then
    return
  end

  for key_or_index, config_or_key in pairs(keys) do
    if type(key_or_index) == "number" then
      local key = config_or_key
      vim.keymap.set("i", key, key, { buffer = 0, remap = false })
    elseif type(key_or_index) == "string" then
      local key = key_or_index
      local config = config_or_key
      local existing = MiniPairs.config.mappings[key]
      local merged_config = vim.tbl_extend("force", {}, existing or {}, config)
      MiniPairs.map_buf(0, "i", key, merged_config, {})
    end
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
