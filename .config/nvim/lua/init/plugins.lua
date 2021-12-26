local map = require'helpers.map'

-- Plug auto-install and setup {{{
Plug = require 'helpers.plug'
-- }}}

Plug.begin('~/.config/nvim/bundle')

-- ======= Plugin defs and settings =========================
--

Plug '~/work/otsukare'

-- ======= Color-schemes and visual plugins ================= {{{

Plug 'vim-scripts/zenburn'
Plug 'rhysd/vim-color-spring-night'

vim.g.fzf_colors = {
    ['bg+'] = {'bg', 'Visual'},
    ['pointer'] = {'fg', 'SpecialComment', 'StatusLine'},
}

-- }}}

-- ======= Git/Github-related =============================== {{{

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb' -- Exclusively for :GBrowse

-- TODO: make compat with nvim jobs:
-- Plug '~/git/lilium'

vim.g.lilium_matcher = 'fuzzy'

-- only auto-ref issues assigned to me
vim.g['hubr#auto_ref_issues_args'] = 'state=open:assignee=dhleong:milestone?'
-- }}}

-- ======= Testing / Debugging ============================== {{{

Plug 'vim-test/vim-test'
Plug '~/git/neo-latte'

map.nno'<leader>tt'{
  lua_module = 'neo-latte',
  lua_call = 'toggle_auto_test()',
}

map.nno'<leader>tn'{
  lua_module = 'neo-latte',
  lua_call = "toggle_auto_test('nearest')",
}

map.nno'<leader>trn'{
  lua_module = 'neo-latte',
  lua_call = "run('nearest')",
}

map.nno'<leader>trf'{
  lua_module = 'neo-latte',
  lua_call = "run('file')",
}


-- }}}

-- ======= Text completion ================================== {{{

-- auto-close brackets, parens, etc. on <cr>
Plug '~/git/vim-mirror'

-- auto-close other structures
Plug 'tpope/vim-endwise'

-- we manually map in mappings.vim to avoid breaking other <cr> map
-- augmentations, like hyperstyle
vim.g.endwise_no_mappings = 1

-- Plug 'SirVer/ultisnips'
Plug '~/git/ultisnips'
Plug '~/git/vim-cs-snippets'
Plug 'honza/vim-snippets'

vim.g.UltiSnipsListSnippets = '<C-M-Tab>'
vim.g.UltiSnipsExpandTrigger = '<C-Enter>'
vim.g.UltiSnipsJumpForwardTrigger = '<C-J>'
vim.g.UltiSnipsJumpBackwardTrigger = '<C-K>'

-- LSP Config

Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'nvim-lua/plenary.nvim' -- dependency of null-ls

-- Plug 'jose-elias-alvarez/null-ls.nvim'
Plug '~/git/null-ls.nvim'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'hrsh7th/nvim-cmp'

Plug 'ray-x/lsp_signature.nvim'

-- }}}

-- ======= Text manipulation ================================ {{{

-- visual-mode number incrementing
Plug 'vim-scripts/VisIncr'

Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

-- }}}

-- ======= Text navigation ================================== {{{

-- ipmotion
--
Plug 'justinmk/vim-ipmotion'

-- Tweaking {} motion behavior
vim.g.ip_boundary = '[" *]*\\s*$'
-- don't open folds when jumping over blocks
vim.g.ip_skipfold = 1

-- Sneak
Plug 'justinmk/vim-sneak'

vim.g['sneak#label'] = 1

Plug 'chrisbra/matchit'
Plug('Valloric/MatchTagAlways', { ft = {'html', 'xml'} })
--
-- }}}

-- ======= Tree sitter ====================================== {{{
-- See treesitter.lua for config

Plug('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

-- Provides contextual commenting (for eg tsx)
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

-- Provides "smart" text objects
Plug 'RRethy/nvim-treesitter-textsubjects'

-- }}}

-- ======= Vim ==============================================

Plug('tpope/vim-scriptease', { ft = 'vim' })
Plug('junegunn/vader.vim', { ft = 'vader' })


-- ======= Utility ========================================== {{{
--

-- fzf all the things
Plug('junegunn/fzf', { run = './install --bin' })
Plug 'junegunn/fzf.vim'

-- simple, lightweight file system navigation
Plug 'tpope/vim-vinegar'

-- like it says on the tin:
Plug 'ciaranm/securemodelines'


-- }}}

Plug.ends()
