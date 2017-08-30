
let g:ale_emit_conflict_warnings = 0


" ======= vim-plug plugins =================================
    if empty(glob('~/.vim/autoload/plug.vim'))
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall
    endif

    call plug#begin('~/.vim/bundle')


    " FIXME: find proper homes for these:
    Plug 'vim-scripts/eregex.vim'
    Plug 'vim-scripts/matchit.zip'
    Plug 'vim-scripts/VisIncr'
    Plug 'vim-scripts/zenburn'
    Plug 'vim-scripts/ShaderHighLight'

    " use ap's fork here instead of skammer, to add stylus support
    " NB: css-color breaks if loaded on-demand
    Plug 'ap/vim-css-color'
    Plug 'bling/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'davidhalter/jedi-vim', {'for': 'python', 'do': 'git submodule update --init'}
    Plug 'dhleong/vim-veryhint', {'for': 'java'}
    Plug 'fatih/vim-go'
    Plug 'guns/vim-clojure-static', {'for': 'clojure'}
    Plug 'guns/vim-clojure-highlight', {'for': 'clojure'}
    Plug 'guns/vim-sexp', {'for': 'clojure'}
    Plug 'haya14busa/vim-textobj-function-syntax' | Plug 'kana/vim-textobj-function'
    Plug 'Julian/vim-textobj-variable-segment'
    " Plug 'junegunn/vim-peekaboo'
    Plug 'junegunn/vim-pseudocl'
    Plug 'junegunn/vader.vim', {'for': 'vader'}
    Plug 'justinmk/vim-ipmotion'
    Plug 'justinmk/vim-sneak'
    Plug 'kana/vim-textobj-user'
    Plug 'marijnh/tern_for_vim', {'for': 'javascript', 'do': 'npm install'}
    Plug 'moll/vim-node', {'for': 'javascript'}
    Plug 'OmniSharp/omnisharp-vim', {'for': 'cs', 'do': 'git submodule update --init --recursive && cd server && xbuild'}
    Plug 'oplatek/Conque-Shell', {'on': ['RunCurrentInSplitTerm', 'ConqueTermTab',
                \ 'ConqueTermSplit', 'ConqueTermVSplit']}
    Plug 'osyo-manga/vim-over'
    Plug 'rizzatti/dash.vim'
    Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
    Plug 'rstacruz/sparkup', {'rtp': 'vim', 'for': 'html'}
    Plug 'scrooloose/syntastic'
    Plug 'Shougo/unite.vim'
    Plug 'Shougo/vimproc.vim', {'do': 'make'}
    " Plug 'shime/vim-livedown'
    Plug 'suan/vim-instant-markdown', {'for': 'markdown',
                \ 'do': 'sudo gem install redcarpet pygments.rb && sudo npm -g install instant-markdown-d'}
    Plug 'terryma/vim-multiple-cursors'
    Plug 'tommcdo/vim-exchange'
    Plug 'tomtom/tcomment_vim'
    Plug 'tpope/vim-fireplace', {'for': 'clojure'}
    " Plug '~/git/vim-fireplace', {'for': 'clojure'}
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-markdown', {'for': 'markdown'}
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-scriptease', {'for': 'vim'}
    Plug 'tpope/vim-sexp-mappings-for-regular-people', {'for': 'clojure'}
    " Plug 'tpope/vim-sleuth'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-vinegar'
    " Plug 'vimwiki/vimwiki'
    Plug 'Valloric/MatchTagAlways', {'for': ['html', 'xml']}
    if !(has('nvim') || exists('g:neojet#version'))
        Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer --omnisharp-completer --tern-completer'}
        " Plug '~/git/YouCompleteMe', {'do': './install.py --omnisharp-completer'}
    endif
    Plug 'wellle/targets.vim'
    Plug 'w0rp/ale', {'for': ['javascript', 'typescript']}
    Plug 'xolox/vim-misc'
    Plug 'xolox/vim-session'

    " Plug 'file:///Users/dhleong/code/hubr'
    Plug '~/git/hubr'
    " Plug '~/git/intellivim', {'rtp': 'vim'}
    " Plug 'file:///Users/dhleong/code/njast'
    " Plug 'file:///Users/dhleong/git/Conque-Shell'
    Plug '~/git/lily'
    Plug '~/git/vim-latte'

    " I would prefer to user MarcWeber's,
    "  but it seems to be broken with YCM
    " Plug 'MarcWeber/ultisnips'
    Plug 'SirVer/ultisnips' | Plug '~/git/vim-cs-snippets' | Plug 'honza/vim-snippets'

    " Syntax plugins
    Plug 'digitaltoad/vim-jade'
    Plug 'groenewege/vim-less'
    Plug 'kchmck/vim-coffee-script'
    Plug 'LokiChaos/vim-tintin'
    Plug 'udalov/kotlin-vim'
    Plug 'keith/swift.vim'
    Plug 'tfnico/vim-gradle'
    Plug 'wavded/vim-stylus'
    Plug '~/git/vim-interspace'
    Plug '~/git/vim-jsgf'

    " typescript
    Plug 'leafgarland/typescript-vim'
    Plug 'jason0x43/vim-js-indent', {'for': 'typescript'}

    " jsx depends on panglass/vim-javascript:
    Plug 'mxw/vim-jsx' | Plug 'pangloss/vim-javascript'

    call plug#end()
" ======= end vim-plug stuff ===============================


