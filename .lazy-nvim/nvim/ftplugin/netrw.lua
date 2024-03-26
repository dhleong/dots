-- Disable the 's' and 'S' mappings in netrw (let us keep using flash/sneak)
local function disable_maps()
  vim.keymap.del({ "n" }, "s", { buffer = true })
  vim.keymap.del({ "n" }, "S", { buffer = true })
end

pcall(disable_maps)
