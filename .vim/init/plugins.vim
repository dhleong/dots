" ======= Configs ========================================== {{{

let g:ale_emit_conflict_warnings = 0

" }}}


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

" ======= Color-schemes and visual plugins ================= {{{

Plug 'vim-scripts/zenburn'

Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" airline configs {{{
set laststatus=2
let g:airline#extensions#whitespace#enabled = 0
" let g:airline#extensions#eclim#enabled = 0
let g:airline#extensions#default#section_truncate_width = {
  \ 'x': 88,
  \ 'y': 88,
  \ 'z': 45,
  \ }

" only use powerline fonts if we have it. This was moved
"  from .gvimrc because it apparently no longer runs
"  before airline does its config step, so was ignored
let _fontName='Inconsolata+for+Powerline.otf'
if has('gui_running') 
        \ && (!empty(glob("~/Library/Fonts/" . _fontName))
            \ || !empty(glob("~/Library/Fonts/" . substitute(_fontName, '+', ' ', 'g'))))
    " could check more places, but....
    let g:airline_powerline_fonts = 1
endif
" }}}
" }}}


" ======= Git/Github-related =============================== {{{

Plug 'tpope/vim-fugitive'

Plug '~/git/hubr'
Plug '~/git/lily'

" only auto-ref issues assigned to me
let g:hubr#auto_ref_issues_args = 'state=open:assignee=dhleong:milestone?'
" }}}


" ======= Linting ========================================== {{{

"" ALE
""
Plug 'w0rp/ale'

let g:ale_linters = {
    \   'go': ['go build', 'gofmt', 'golint', 'go vet'],
    \   'java': [],
    \   'javascript': ['eslint'],
    \   'typescript': ['tslint'],
    \}

" "" Syntastic
" "" TODO: probably, remove in favor of ALE
" ""
" Plug 'scrooloose/syntastic'

" " Syntastic config {{{
" " let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
" let g:syntastic_cs_checkers = []
" let g:syntastic_javascript_checkers = []
" let g:syntastic_javascript_eslint_exec = '~/.npm-packages/bin/eslint'
" let g:syntastic_javascript_jshint_exec = '~/.npm-packages/bin/jshint'
" let g:syntastic_java_checkers = []
" let g:syntastic_python_checkers = ['flake8']
" let g:syntastic_quiet_messages = {
"     \ "regex": [
"         \ 'proprietary.*async',
"         \ 'proprietary.*onload',
"         \ 'proprietary.*onreadystatechange',
"     \ ]}
" " }}}
" " }}}


" ======= Syntax plugins =================================== {{{

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
" }}}


" ======= Text completion ================================== {{{


"" YouCompleteMe
""
if !(has('nvim') || exists('g:neojet#version'))
    Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer --cs-completer --js-completer --go-completer'}
    " Plug '~/git/YouCompleteMe', {'do': './install.py --omnisharp-completer'}

    " related, for c/c++ stuff
    Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
endif

" YCM Config {{{
let g:ycm_filetype_blacklist = {
    \ 'tagbar' : 1,
    \ 'qf' : 1,
    \ 'notes' : 1,
    \ 'unite' : 1,
    \ 'vimwiki' : 1,
    \ 'pandoc' : 1,
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
" }}}


"" Ultisnips
""
" NOTE: this MUST be AFTER YouCompleteMe for... some reason.
" If before, we get an ABRT signal :|
Plug 'SirVer/ultisnips' | Plug '~/git/vim-cs-snippets' | Plug 'honza/vim-snippets'

let g:UltiSnipsListSnippets="<C-M-Tab>"
let g:UltiSnipsExpandTrigger="<C-Enter>"
let g:UltiSnipsJumpForwardTrigger="<C-J>"
let g:UltiSnipsJumpBackwardTrigger="<C-K>"


" Plug 'dhleong/vim-veryhint', {'for': 'java'}
" }}}


" ======= Text Documentation =============================== {{{

Plug 'rizzatti/dash.vim'

" Generally we can rely on language-specific stuff, but every now and
" then it's nice to be able to quickly pop into Dash
nnoremap <leader>K :Dash<cr>
nnoremap gK :Dash!<cr>
" nnoremap <C-S-k> :Dash " overrides <c-k> for some reason
let g:dash_map = {
    \ 'javascript': 'electron',
    \ 'typescript': ['typescript', 'javascript']
    \ }

" }}}


" ======= Text manipulation ================================ {{{

" visual-mode number incrementing
Plug 'vim-scripts/VisIncr'

Plug 'terryma/vim-multiple-cursors'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

"" tcomment: motion-based commenting
""
Plug 'tomtom/tcomment_vim'

let g:tcomment_types = {
    \ 'java': '// %s',
    \ 'java_inline': '/* %s */',
    \ 'java_block': '// %s'
    \ }
" }}}


" ======= Text navigation ================================== {{{

"" ipmotion
""
Plug 'justinmk/vim-ipmotion'

" Tweaking {} motion behavior
let g:ip_boundary = '[" *]*\s*$'
" don't open folds when jumping over blocks
let g:ip_skipfold = 1

"" Sneak
Plug 'justinmk/vim-sneak'

let g:sneak#streak = 1


Plug 'vim-scripts/matchit.zip'
Plug 'Valloric/MatchTagAlways', {'for': ['html', 'xml']}

" }}}


" ======= Text objects ===================================== {{{

" needed for custom textobjs:
Plug 'kana/vim-textobj-user'

" plugins for the above:
Plug 'haya14busa/vim-textobj-function-syntax' | Plug 'kana/vim-textobj-function'
Plug 'Julian/vim-textobj-variable-segment'

"" Targets
""
Plug 'wellle/targets.vim'

" }}}


" ======= Language-specific ================================
"

Plug '~/git/vim-latte'

" ======= Clojure ==========================================

Plug 'tpope/vim-fireplace', {'for': 'clojure'}
" Plug '~/git/vim-fireplace', {'for': 'clojure'}

Plug 'guns/vim-clojure-static', {'for': 'clojure'}
Plug 'guns/vim-clojure-highlight', {'for': 'clojure'}
Plug 'guns/vim-sexp', {'for': 'clojure'}
Plug 'tpope/vim-sexp-mappings-for-regular-people', {'for': 'clojure'}


" ======= C# ===============================================

Plug 'OmniSharp/omnisharp-vim', {'for': 'cs', 'do': 'git submodule update --init --recursive && cd server && xbuild'}


" ======= Go ===============================================

Plug 'fatih/vim-go'


" ======= Javascript/Node ==================================

Plug 'marijnh/tern_for_vim', {'for': 'javascript', 'do': 'npm install'}
Plug 'moll/vim-node', {'for': 'javascript'}

" tern configs
let g:tern_show_signature_in_pum = 1


" jsx depends on panglass/vim-javascript:
Plug 'mxw/vim-jsx' | Plug 'pangloss/vim-javascript'


" ======= LaTeX ============================================

" Plug 'vim-latex/vim-latex'
" NOTE: Haven't actually used latex in a long time, and this plugin
"  includes some /plugin scripts which I haven't wanted or needed...
"  But this looks like the plugin I was using, so I'll leave the
"  reference in here for future reference.


" ======= Markdown =========================================

Plug 'suan/vim-instant-markdown', {'for': 'markdown',
            \ 'do': 'sudo gem install redcarpet pygments.rb && sudo npm -g install instant-markdown-d'}

let g:instant_markdown_slow = 1


Plug 'tpope/vim-markdown', {'for': 'markdown'}


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


" ======= Vim ==============================================

Plug 'tpope/vim-scriptease', {'for': 'vim'}
Plug 'junegunn/vader.vim', {'for': 'vader'}


" ======= Utility ==========================================
"

" UI/searching plugin. This one is basically abandonware at this point
" Its replacement, denite, is supposed to be better, but it requires python3
" and my MacVim doesn't seem to want to do it...
Plug 'Shougo/unite.vim'

" async stuff required by a lot of plugins
Plug 'Shougo/vimproc.vim', {'do': 'make'}

" simple session handling
Plug 'xolox/vim-session' | Plug 'xolox/vim-misc'

" session configs
let g:session_autosave = 'yes'
let g:session_autoload = 'no'


" simple, lightweight file system navigation
Plug 'tpope/vim-vinegar'


" Footer {{{
call plug#end()
" }}}


