-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Laziness:
vim.cmd.source("~/.vim/init/mappings.vim")

-- NOTE: We're not using vim-mirror or vim-endwise at the moment, so we're
-- tweaking the imported mapping here to compensate
vim.keymap.set("i", "<Enter>", "<C-R>=dhleong#text#TryCleanWhitespace()<cr>", {
  silent = true,
})

-- vim compat {{{
--

-- nvim makes Y consistent with C/D but I like the old way
vim.keymap.set("n", "Y", "yy")

-- }}}

-- Helpers {{{

local function create_noremap(mode)
  return function(lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, {
      noremap = true,
      silent = true,
    })
  end
end

local inoremap = create_noremap("i")
local nnoremap = create_noremap("n")
local tnoremap = create_noremap("t")

-- }}}

-- nvim config file opening:
--

-- helpers {{{
local paths = {
  nvim = function(path)
    return vim.fn.stdpath("config") .. "/" .. path
  end,
}
paths.config = function(path)
  return paths.nvim("lua/config/" .. path)
end
paths.plugins = function(path)
  return paths.nvim("lua/plugins/" .. path)
end

local function mapOpenFile(leaderMap, path)
  local with_path = '<c-r>=resolve("' .. path .. '")<cr><cr>'
  nnoremap("<Leader>" .. leaderMap, ":e " .. with_path)
  nnoremap("<Leader>t" .. leaderMap, ":tabe " .. with_path)
end

local function edit_ft_snippet_files(opts)
  local o = opts or {}
  local current_ft = vim.o.filetype

  require("luasnip.loaders").edit_snippet_files(vim.tbl_extend("keep", o, {
    ft_filter = function(ft)
      return ft == current_ft
    end,
    format = function(file, source_name)
      if source_name == "vscode" then
        return nil
      end
      return file
    end,
    extend = function(ft, ft_paths)
      if #ft_paths == 0 then
        -- Provide a default if we don't have a file for this type yet
        return {
          {
            "$CONFIG/luasnippets/" .. ft .. ".lua",
            vim.fn.stdpath("config") .. "/luasnippets/" .. ft .. ".lua",
          },
        }
      end

      return {}
    end,
  }))
end
-- }}}

mapOpenFile("ev", paths.config("lazy.lua"))
mapOpenFile("vm", paths.config("keymaps.lua"))
mapOpenFile("vp", paths.plugins(""))
mapOpenFile("vs", paths.config("options.lua"))
mapOpenFile("vb", vim.fn.stdpath("data") .. "/lazy")
mapOpenFile("vl", vim.fn.stdpath("data") .. "/lazy/LazyVim/lua/lazyvim/plugins")

mapOpenFile("eft", paths.plugins('/lang/" . &filetype . ".lua'))

-- "edit file(type) snippets"
nnoremap("<leader>efs", edit_ft_snippet_files)
nnoremap("<leader>tefs", function()
  edit_ft_snippet_files({
    edit = vim.cmd.tabedit,
  })
end)

-- ======= Text manipulation ================================

-- Muscle memory from macOS defaults
inoremap("<m-bs>", "<c-w>")

if vim.g.gui_vimr or vim.g.neovide then
  -- Manually map these to :write because the vimr's default behavior does
  -- not play well with oil.nvim for some reason (and neovide does not
  -- provide any).
  nnoremap("<D-s>", ":w<cr>")
  inoremap("<D-s>", function()
    vim.cmd.write()
  end)

  -- Similarly, the builtin shortcut from vimr doesn't correctly handle
  -- having multiple windows into the same buffer open, so it'll whine
  -- when you try to close a window with unsaved changes unnecesarily.
  -- NOTE: You may need to manually clear the mapping for this; it doesn't
  -- seem to respect this override like it does with d-s
  nnoremap("<D-w>", ":q<cr>")
end

-- W is the same as w, but doesn't perform auto-formatting
vim.api.nvim_create_user_command("W", function()
  vim.b.autoformat = false
  vim.cmd.write()
  vim.b.autoformat = true
end, {})

-- ======= File navigation ==================================

nnoremap("<leader>p", "<cmd>lua require'dhleong.nav'.projects()<cr>")

-- NOTE: netrw's gx is not behaving for some reason. Let's just
-- use our own because netrw is weird
nnoremap("gx", "<cmd>lua require'dhleong.nav'.link()<cr>")

-- ======= Terminal =========================================

-- "Open terminal"
nnoremap("<leader>ot", function()
  require("dhleong.term").split()
end)

-- I'm used to <a-bs> and it sorta works but for whatever reason it leaves a . behind where <c-w>
-- doesn't, so let's just use that:
tnoremap("<a-bs>", "<c-w>")

-- Support leaving terminals with typical mappings
tnoremap("<C-H>", "<C-\\><C-N><C-W><C-H>")
tnoremap("<C-L>", "<C-\\><C-N><C-W><C-L>")
tnoremap("<C-J>", "<C-\\><C-N><C-W><C-J>")
tnoremap("<C-K>", "<C-\\><C-N><C-W><C-K>")

if vim.fn.has("gui_running") == 0 then
  -- Saving files with <cmd-s> in CLI mode (with help from iterm2)
  -- Configure a key map to "Send text with 'vim' Special Chars" as <F-20>
  nnoremap("<F-20>", ":w<cr>")
  inoremap("<F-20>", "<esc>:w<cr>")

  nnoremap("<F-21>", ":tabe<cr>") -- Similarly, <cmd-t> ...
  inoremap("<F-21>", "<esc>:tabe<cr>")
  nnoremap("<F-22>", ":q<cr>") -- ... and <cmd-w>
  inoremap("<F-22>", "<esc>:q<cr>")

  nnoremap("<F-23>", "gt")
  nnoremap("<F-24>", "gT")
  inoremap("<F-23>", "<esc>gt")
  inoremap("<F-24>", "<esc>gT")
  tnoremap("<F-23>", "<C-\\><C-N>gt")
  tnoremap("<F-24>", "<C-\\><C-N>gT")

  -- In term mode, let cmd-k act like c-l to clear the screen. Since we're in
  -- vim, we don't want to clear vim's UI
  inoremap("<F-25>", "<nop>")
  nnoremap("<F-25>", "<nop>")
  tnoremap("<F-25>", "<c-l>")
end

-- ======= Other commands ==================================

if vim.env.BROWSER then
  vim.api.nvim_create_user_command("OpenBrowser", function(opts)
    local cmd = { vim.env.BROWSER, opts.args }
    if vim.fn.has("nvim-0.10") == 1 then
      local result = vim.system(cmd):wait()
      if result.code ~= 0 then
        print(result.stdout)
        print(result.stderr)
      end
    else
      -- vimr is still on 0.9 :'(
      vim.fn.system(cmd)
    end
  end, { nargs = 1 })
end
