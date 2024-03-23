-- Disable the 's' mapping in netrw (let us keep using flash/sneak)
local function disable_maps()
  vim.keymap.del({ "n" }, "s", { buffer = true })
end

pcall(disable_maps)
