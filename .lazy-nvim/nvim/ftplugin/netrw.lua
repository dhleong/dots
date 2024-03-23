-- Disable the 's' mapping in netrw (let us keep using flash/sneak)
vim.keymap.del({ "n" }, "s", { buffer = 0 })
