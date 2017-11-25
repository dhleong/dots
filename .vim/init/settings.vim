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

augroup CurrentWindowCursorLine
    " use cursorline, but only for current window
    autocmd!
    autocmd WinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
augroup END


" ======= Wildignore and other filtering ===================

set wildignore=.svn,.git,*.o,*.a,*.class,*.pyc
set wildignore+=*.mo,*.la,*.so,*.obj,*.swp,*.swo
set wildignore+=*.jpg,*.png,*.xpm,*.gif,*.pdf,*.bak
set wildignore+=*.beam,*~,*.info
set wildignore+=*.asset,*.meta


" ======= Misc =============================================

" if exists('+autochdir')
"     " use the builtin if we have it
"     set autochdir
" else
"     " use the manual method
"     autocmd BufEnter * silent! lcd %:p:h
" endif

" for some reason, the autochdir option causes wacky behavior
"  with netrw, with this repro:
"   - open a file
"   - :vsp
"   - go up a dir via - and vinegar until you can open another dir
"   - when you open another subdir, netrw will fill the whole tabpage,
"       and the original buffer's contents will be overwritten
augroup AutoChdir
    autocmd!
    autocmd BufEnter * silent! lcd %:p:h
augroup END
