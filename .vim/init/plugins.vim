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

Plug '~/work/otsukare'


" ======= Trial-basis ===================================== {{{

Plug 'jalvesaq/Nvim-R'

" less/css convenience
" Plug 'rstacruz/vim-hyperstyle'
Plug '~/git/vim-hyperstyle'

" }}}


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

Plug '~/git/lilium'

let g:lilium_matcher = 'fuzzy'

" only auto-ref issues assigned to me
let g:hubr#auto_ref_issues_args = 'state=open:assignee=dhleong:milestone?'
" }}}


" ======= Linting ========================================== {{{

"" ALE
""
Plug 'dense-analysis/ale'

let g:ale_linters = {
    \   'clojure': ['clj-kondo'],
    \   'cs': ['OmniSharp'],
    \   'go': ['go build', 'gofmt', 'golint', 'go vet', 'golangci-lint'],
    \   'html': ['htmlhint'],
    \   'java': [],
    \   'javascript': ['eslint'],
    \   'python': ['pylint'],
    \   'tex': ['chktex'],
    \   'typescript': ['tslint', 'tsserver', 'eslint'],
    \}

let g:ale_fixers = {
    \   'clojure': ['hearth'],
    \   'go': ['gofmt'],
    \   'javascript': ['eslint'],
    \   'typescript': ['eslint', 'tslint'],
    \   'typescriptreact': ['eslint', 'prettier'],
    \}

let g:ale_pattern_options = {
    \   '-test\.js$': {
    \       'ale_set_loclist': 0,
    \       'ale_enabled': 0,
    \   },
    \}

let g:ale_javascript_eslint_options = '--cache'

" }}}


" ======= Syntax plugins =================================== {{{

" NB: css-color breaks if loaded on-demand
Plug 'ap/vim-css-color'

Plug 'digitaltoad/vim-jade'
Plug 'elubow/cql-vim'
Plug 'groenewege/vim-less'
Plug 'kchmck/vim-coffee-script'
Plug 'LokiChaos/vim-tintin'
Plug 'milch/vim-fastlane'
Plug 'udalov/kotlin-vim'
Plug 'keith/swift.vim'
Plug 'tfnico/vim-gradle'
Plug 'wavded/vim-stylus'
Plug 'leafgarland/typescript-vim'
Plug '~/git/vim-jsx-typescript'
Plug 'vim-scripts/ShaderHighLight'
Plug 'zchee/vim-flatbuffers'
Plug '~/git/vim-interspace'
Plug '~/git/vim-jsgf'
Plug 'elixir-editors/vim-elixir'
" }}}


" ======= Debugging ======================================= {{{

Plug 'puremourning/vimspector'

" }}}


" ======= Text completion ================================== {{{

" auto-close brackets, parens, etc. on <cr>
Plug '~/git/vim-mirror'

" auto-close other structures
Plug 'tpope/vim-endwise'

" we manually map in mappings.vim to avoid breaking other <cr> map
" augmentations, like hyperstyle
let g:endwise_no_mappings = 1

"" YouCompleteMe
""

" YCM LSP {{{

let g:ycm_language_server = [
    \ {
    \   'name': 'sourcekit-lsp',
    \   'cmdline': ['xcrun', 'sourcekit-lsp', '--log-level=debug'],
    \   'filetypes': ['swift'],
    \   'project_root_files': [ 'Package.swift' ],
    \ },
    \ {
    \   'name': 'elixir-ls',
    \   'cmdline': [$HOME . '/work/elixir-ls/language_server.sh'],
    \   'filetypes': ['elixir'],
    \   'project_root_files': [ 'mix.exs' ],
    \ }
    \ ]
" }}}

let s:ycmCompleters = ['clang', 'cs', 'go', 'rust', 'ts']

if !(has('nvim') || exists('g:neojet#version'))
    let flags = join(map(s:ycmCompleters, '"--" . v:val . "-completer"'), ' ')
    Plug 'ycm-core/YouCompleteMe', {'do': './install.py ' . flags}

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

let g:ycm_key_list_previous_completion = ['<Up>'] " NOT s-tab; we do the right thing below:
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<c-d>"

" most useful for gitcommit
let g:ycm_collect_identifiers_from_comments_and_strings = 1

let g:ycm_always_populate_location_list = 1

let g:ycm_auto_hover = ''

let g:ycm_tsserver_binary_path = "/Users/dhleong/.npm-packages/bin/tsserver"

" NOTE: use the version installed via homebrew:
if filereadable('/usr/local/bin/rust-analyzer')
    let g:ycm_rust_toolchain_root = '/usr/local'
endif

let g:ycm_extra_conf_globlist = [
    \ '~/.dotfiles/dots/.vim/bundle/YouCompleteMe/*',
    \ '~/git/juuce/*',
    \ '~/git/iaido/*',
    \ '~/work/*',
    \ ]

" let g:ycm_max_diagnostics_to_display = 50
" }}}


"" Ultisnips
""
" NOTE: this MUST be AFTER YouCompleteMe for... some reason.
" If before, we get an ABRT signal :|
let s:hasPython3 = exists("+pythonthreehome") && !empty(&pythonthreehome)
if s:hasPython3
    " NOTE: if python3 isn't setup, ultisnips barfs HARD on *every* keypress.
    " Let's just disable it so we can still do things
    Plug 'SirVer/ultisnips' | Plug '~/git/vim-cs-snippets' | Plug 'honza/vim-snippets'
endif

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
    \ 'typescript': ['typescript', 'javascript', 'nodejs']
    \ }

" }}}


" ======= Text manipulation ================================ {{{

" visual-mode number incrementing
Plug 'vim-scripts/VisIncr'

Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

"" tcomment: motion-based commenting
""
Plug 'tomtom/tcomment_vim', {'commit': 'e365bfab66ab481aebcefd57b795c8ef1d42681f'}

let g:tcomment_types = {
    \ 'java': '// %s',
    \ 'java_inline': '/* %s */',
    \ 'java_block': '// %s'
    \ }

" convert between single-line and wrapped argument lists
Plug 'FooSoft/vim-argwrap'

nnoremap <leader>aw :ArgWrap<cr>

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

let g:sneak#label = 1


Plug 'chrisbra/matchit'
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

" async semantic highlighting (dhleong/vim-mantel)
Plug '~/git/vim-mantel'

" my extra clojure utils (dhleong/vim-hearth)
Plug '~/git/vim-hearth'

Plug 'guns/vim-clojure-static', {'for': 'clojure'}
Plug 'guns/vim-sexp', {'for': 'clojure'}
Plug 'tpope/vim-sexp-mappings-for-regular-people', {'for': 'clojure'}


" ======= C# ===============================================

Plug 'OmniSharp/omnisharp-vim', {'for': 'cs'}

let g:OmniSharp_server_stdio = 0
let g:OmniSharp_highlight_types = 2


" ======= Go ===============================================

Plug 'fatih/vim-go'

let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_arguments = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1

" use ycm
let g:go_def_mapping_enabled = 0
" echo_go_info enabled just causes annoying 'press enter to continue' prompt
" since we use ycm for completion (reproducible by pressing esc after tabbing
" to insert a completion)
let g:go_echo_go_info = 0


" ======= HTML/XML ========================================

Plug 'alvan/vim-closetag'

let g:closetag_filenames = '*.xml,*.html,*.tsx'
let g:closetag_xhtml_filenames = '*.xhtml,*.tsx'

" ======= HTTP/Rest/Websockets =============================

" dhleong/vim-pie
Plug '~/git/vim-pie'

" dhleong/vim-wildwildws
Plug '~/git/vim-wildwildws'


" ======= Javascript/Node ==================================

Plug 'moll/vim-node', {'for': 'javascript'}

" tern configs
let g:tern_show_signature_in_pum = 1

" Plug 'jason0x43/vim-js-indent', {'for': 'typescript'}


" ======= LaTeX ============================================

Plug 'lervag/vimtex'

" ignore 'command terminated with space'
let g:ale_tex_chktex_options = '-nowarn 1'


" ======= Markdown =========================================

Plug 'tpope/vim-markdown', {'for': 'markdown'}

let g:markdown_fenced_languages = ['clojure', 'javascript', 'typescript']

" ======= Python ===========================================

"" Jedi
""
" Plug 'davidhalter/jedi-vim', {'for': 'python', 'do': 'git submodule update --init'}

let g:jedi#completions_enabled = 0
let g:jedi#squelch_py_warning = 1
let g:jedi#popup_select_first = 1
let g:jedi#popup_on_dot = 0
let g:jedi#goto_definitions_command = "gd"
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#use_splits_not_buffers = "right"

"" Indenting

Plug 'Vimjas/vim-python-pep8-indent'


" ======= Typescript =======================================

" NOTE: this is included above (see the note there)
" Plug 'jason0x43/vim-js-indent', {'for': 'typescript'}

let g:js_indent_flat_switch = 1

" " disable typescript-vim indent and use the above:
" let g:typescript_indent_disable = 1


" ======= Vim ==============================================

Plug 'tpope/vim-scriptease', {'for': 'vim'}
Plug 'junegunn/vader.vim', {'for': 'vader'}


" ======= Utility ==========================================
"

" fzf all the things
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" simple, lightweight file system navigation
Plug 'tpope/vim-vinegar'

" like it says on the tin:
Plug 'ciaranm/securemodelines'

" Footer {{{
call plug#end()
" }}}


