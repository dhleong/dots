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

Plug 'AndrewRadev/splitjoin.vim'

" less/css convenience
" Plug 'rstacruz/vim-hyperstyle'
Plug '~/git/vim-hyperstyle'

"Plug 'vim-denops/denops.vim'
Plug '~/git/vim-feather'

let g:denops#debug = 1

" }}}


" ======= Color-schemes and visual plugins ================= {{{

Plug 'vim-scripts/zenburn'
Plug 'rhysd/vim-color-spring-night'

let g:fzf_colors = {
    \ 'bg+': ['bg', 'Visual'],
    \ 'pointer': ['fg', 'SpecialComment', 'StatusLine'],
    \ }

Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" airline configs {{{
set laststatus=2
let g:airline#extensions#whitespace#enabled = 0
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

let g:ale_linters_ignore = {
    \   'typescriptreact': ['deno', 'tsserver']
    \}

let g:ale_fixers = {
    \   'clojure': ['hearth'],
    \   'go': ['gofmt'],
    \   'javascript': ['eslint'],
    \   'typescript': ['eslint', 'tslint'],
    \   'typescriptreact': ['eslint'],
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
Plug 'cespare/vim-toml'
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

"" Completer selection

let g:dhleong_completer = 'coc'

let s:completer_config_path = resolve(expand('~/.vim/init/' . g:dhleong_completer . '.vim'))

if g:dhleong_completer ==# 'coc'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
elseif !(has('nvim') || exists('g:neojet#version')) && g:dhleong_completer ==# 'ycm'
    let s:ycmCompleters = ['clang', 'cs', 'go', 'rust', 'ts']
    let flags = join(map(s:ycmCompleters, '"--" . v:val . "-completer"'), ' ')
    Plug 'ycm-core/YouCompleteMe', {'do': './install.py ' . flags}

    " related, for c/c++ stuff
    Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
endif

exe 'source ' . s:completer_config_path

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

let g:OmniSharp_server_use_mono = 1
let g:OmniSharp_highlighting = 2

let s:osTypeColor = 'SpecialComment'
let g:OmniSharp_highlight_groups = {
    \ 'ClassName': s:osTypeColor,
    \ 'EnumName': s:osTypeColor,
    \ 'StructName': s:osTypeColor,
    \ 'FieldName': 'SpecialChar',
    \ 'PropertyName': 'SpecialChar',
    \ 'LocalName': 'Normal',
    \ 'ParameterName': 'Normal',
    \ }


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

let g:closetag_regions = {
    \ 'typescript.jsx': 'jsxRegion,tsxRegion',
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }

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


