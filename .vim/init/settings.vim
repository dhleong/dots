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
colorscheme spring-night
let g:airline_theme = "spring_night"

" adjust splits behaviour
set splitright      " horizontal splits should not open on the left...
set noea            " 'no equal always'--don't resize my splits!

" show horrid tabs
set list
set listchars=tab:»·,trail:·

" nice autocomplete UI
if !get(g:, 'dhleong_set_completeopt', 0)
    " NOTE: only attempt to set this once. YCM will change these
    " at some point, and for some wacky reason if we change them
    " back (for example, when sourcing ~/.vimrc to change things)
    " it causes input to go CRAZY--typing anything not in a comment
    " causes it to disappear after the second character. Wild.
    let g:dhleong_set_completeopt = 1

    set completeopt=menu,preview,longest

    if has('patch-8.1.1880')
        set completeopt+=popup
        set completepopup=border:off,width:40
    endif
endif

set guioptions=c    " hide useless gui
set mouse=a         " mouse scrolling in iterm
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


" ======= .swp management ==================================

" keep swp files, but don't pollute the file system
let s:swapdir = $HOME . '/.vim-tmp/swp'
if !isdirectory(s:swapdir)
    " make the directory
    call mkdir(s:swapdir, 'p')
endif
exe 'set directory^=' . s:swapdir


" ======= undo management ==================================

" persist undo, but don't pollute the file system
let s:undodir = $HOME . '/.vim-tmp/undo'
if !isdirectory(s:undodir)
    " make the directory
    call mkdir(s:undodir, 'p')
endif
exe 'set undodir=' . s:undodir
set undofile


" ======= Wildignore and other filtering ===================

set wildignore=.svn,.git,*.o,*.a,*.class,*.pyc
set wildignore+=*.mo,*.la,*.so,*.obj,*.swp,*.swo
set wildignore+=*.jpg,*.png,*.xpm,*.gif,*.pdf,*.bak
set wildignore+=*.beam,*~,*.info
set wildignore+=*.asset,*.meta


" ======= Improve syntax performance on huge files =========

augroup DisableSyntaxSyncOnLargeFiles
    autocmd!
    autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syn sync clear | endif
augroup END


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
