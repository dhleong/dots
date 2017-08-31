" ======= Configs ==========================================

let g:ale_emit_conflict_warnings = 0


" Plug auto-install and setup {{{
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/bundle')
" }}}

" ======= Plugin defs and settings =========================
"

" ======= Color schemes ====================================

Plug 'vim-scripts/zenburn'


" ======= Linting ==========================================

"" ALE
""
Plug 'w0rp/ale', {'for': ['javascript', 'typescript']}

let g:ale_linters = {
    \   'javascript': ['eslint'],
    \   'typescript': ['tslint'],
    \}

"" Syntastic
"" TODO: probably, remove in favor of ALE
""
Plug 'scrooloose/syntastic'

" let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
let g:syntastic_cs_checkers = []
let g:syntastic_javascript_checkers = []
let g:syntastic_javascript_eslint_exec = '~/.npm-packages/bin/eslint'
let g:syntastic_javascript_jshint_exec = '~/.npm-packages/bin/jshint'
let g:syntastic_java_checkers = []
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_quiet_messages = {
    \ "regex": [
        \ 'proprietary.*async',
        \ 'proprietary.*onload',
        \ 'proprietary.*onreadystatechange',
    \ ]}


" ======= Syntax plugins ===================================

" use ap's fork here instead of skammer, to add stylus support
" NB: css-color breaks if loaded on-demand
Plug 'ap/vim-css-color'

Plug 'digitaltoad/vim-jade'
Plug 'groenewege/vim-less'
Plug 'kchmck/vim-coffee-script'
Plug 'LokiChaos/vim-tintin'
Plug 'udalov/kotlin-vim'
Plug 'keith/swift.vim'
Plug 'tfnico/vim-gradle'
Plug 'wavded/vim-stylus'
Plug 'leafgarland/typescript-vim'
Plug 'vim-scripts/ShaderHighLight'
Plug '~/git/vim-interspace'
Plug '~/git/vim-jsgf'


" ======= Text completion ==================================


"" YouCompleteMe
""
if !(has('nvim') || exists('g:neojet#version'))
    Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer --omnisharp-completer --tern-completer'}
    " Plug '~/git/YouCompleteMe', {'do': './install.py --omnisharp-completer'}

    " related, for c/c++ stuff
    Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
endif

let g:ycm_filetype_blacklist = {
    \ 'tagbar' : 1,
    \ 'qf' : 1,
    \ 'notes' : 1,
    \ 'unite' : 1,
    \ 'vimwiki' : 1,
    \ 'pandoc' : 1,
    \ 'conque_term' : 1,
    \}

let g:ycm_filter_diagnostics = {
    \   'cs': {
    \     'regex': [
    \       "Convert to 'return' statement",
    \       "Convert to '&=' expresssion",
    \       "Convert to '&=' expression",
    \       "prefix '_'",
    \       "Parameter can be ",
    \       "Redundant argument name specification",
    \       "Use 'var' keyword",
    \       "Xml comment",
    \     ]
    \   },
    \   'cpp': {
    \     'regex': [
    \       "enumeration in a nested name specifier",
    \     ]
    \   }
    \ }

let g:ycm_extra_conf_globlist = ["~/git/juuce/*"]

let g:ycm_key_list_previous_completion = ['<Up>'] " NOT s-tab; we do the right thing below:
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<c-d>"

" most useful for gitcommit
let g:ycm_collect_identifiers_from_comments_and_strings = 1

let g:ycm_always_populate_location_list = 1

" let g:ycm_max_diagnostics_to_display = 50


"" Ultisnips
""
" NOTE: this MUST be AFTER YouCompleteMe for... some reason.
" If before, we get an ABRT signal :|
Plug 'SirVer/ultisnips' | Plug '~/git/vim-cs-snippets' | Plug 'honza/vim-snippets'

let g:UltiSnipsListSnippets="<C-M-Tab>"
let g:UltiSnipsExpandTrigger="<C-Enter>"
let g:UltiSnipsJumpForwardTrigger="<C-J>"
let g:UltiSnipsJumpBackwardTrigger="<C-K>"


" ======= Text objects =====================================

" needed for custom textobjs:
Plug 'kana/vim-textobj-user'

" plugins for the above:
Plug 'haya14busa/vim-textobj-function-syntax' | Plug 'kana/vim-textobj-function'
Plug 'Julian/vim-textobj-variable-segment'

"" Targets
""
Plug 'wellle/targets.vim'

" swap I and i so >iB works as expected
let g:targets_aiAI = 'aIAi'


" ======= Language-specific ================================
"

" ======= Clojure ==========================================

Plug 'tpope/vim-fireplace', {'for': 'clojure'}
" Plug '~/git/vim-fireplace', {'for': 'clojure'}

Plug 'guns/vim-clojure-static', {'for': 'clojure'}
Plug 'guns/vim-clojure-highlight', {'for': 'clojure'}
Plug 'guns/vim-sexp', {'for': 'clojure'}
Plug 'tpope/vim-sexp-mappings-for-regular-people', {'for': 'clojure'}


" ======= Python ===========================================

"" Jedi
""
Plug 'davidhalter/jedi-vim', {'for': 'python', 'do': 'git submodule update --init'}

let g:jedi#completions_enabled = 0
let g:jedi#squelch_py_warning = 1
let g:jedi#popup_select_first = 1
let g:jedi#popup_on_dot = 0
let g:jedi#goto_definitions_command = "gd"
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#use_splits_not_buffers = "right"


" ======= Typescript =======================================

Plug 'jason0x43/vim-js-indent', {'for': 'typescript'}


" ======= UNCATEGORIZED ====================================
" TODO: categorize all these:

Plug 'vim-scripts/matchit.zip'
Plug 'vim-scripts/VisIncr'

Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dhleong/vim-veryhint', {'for': 'java'}
Plug 'fatih/vim-go'
Plug 'junegunn/vader.vim', {'for': 'vader'}
Plug 'justinmk/vim-ipmotion'
Plug 'justinmk/vim-sneak'
Plug 'marijnh/tern_for_vim', {'for': 'javascript', 'do': 'npm install'}
Plug 'moll/vim-node', {'for': 'javascript'}
Plug 'OmniSharp/omnisharp-vim', {'for': 'cs', 'do': 'git submodule update --init --recursive && cd server && xbuild'}
Plug 'oplatek/Conque-Shell', {'on': ['RunCurrentInSplitTerm', 'ConqueTermTab',
            \ 'ConqueTermSplit', 'ConqueTermVSplit']}
Plug 'osyo-manga/vim-over'
Plug 'rizzatti/dash.vim'
Plug 'rstacruz/sparkup', {'rtp': 'vim', 'for': 'html'}
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'suan/vim-instant-markdown', {'for': 'markdown',
            \ 'do': 'sudo gem install redcarpet pygments.rb && sudo npm -g install instant-markdown-d'}
Plug 'terryma/vim-multiple-cursors'
Plug 'tommcdo/vim-exchange'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-markdown', {'for': 'markdown'}
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-scriptease', {'for': 'vim'}
" Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
" Plug 'vimwiki/vimwiki'
Plug 'Valloric/MatchTagAlways', {'for': ['html', 'xml']}
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

Plug '~/git/hubr'
" Plug '~/git/intellivim', {'rtp': 'vim'}
Plug '~/git/lily'
Plug '~/git/vim-latte'


" jsx depends on panglass/vim-javascript:
Plug 'mxw/vim-jsx' | Plug 'pangloss/vim-javascript'


" Footer {{{
call plug#end()
" }}}


