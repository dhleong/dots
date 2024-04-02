-- Disable LazyVim's default options
package.loaded["lazyvim.config.options"] = true

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
