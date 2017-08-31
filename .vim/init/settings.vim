" ======= Global settings ==================================
"
syntax enable
filetype plugin on

" ======= Indent-related ===================================

set autoindent
set copyindent      " copy the previous indentation on autoindenting

" 4 space indents
set tabstop=4
set shiftwidth=4
set expandtab


" ======= Search handling ==================================

set incsearch
set ignorecase      " ignore case in search....
set smartcase       " but if we WANT case, use it


" ======= Visual tweaks ====================================

" color scheme
colorscheme zenburn

" adjust splits behaviour
set splitright      " horizontal splits should not open on the left... 
set noea            " 'no equal always'--don't resize my splits!

" show horrid tabs
set list
set listchars=tab:»·,trail:·

" nice autocomplete UI
set completeopt=menu,preview,longest

set guioptions=c    " hide useless gui
set ruler           " we may want to know where we are in the file
set showcmd         " indicate number of selected chars, etc.
set vb              " visual bell

set updatetime=900

" use cursorline, but only for current window
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline


" ======= Misc =============================================

if exists('+autochdir')
    " use the builtin if we have it
    set autochdir
else
    " use the manual method 
    autocmd BufEnter * silent! lcd %:p:h
endif

" space as mapleader is the most comfortable and easiest
" to hit for me.
let mapleader = " "
