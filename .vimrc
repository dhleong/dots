" This must be first, because it changes other options as side effect
set nocompatible

" load pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

set autoindent
set copyindent    " copy the previous indentation on autoindenting
set showcmd
set incsearch
syntax enable
filetype plugin on
set tabstop=4
set shiftwidth=4
set expandtab
set ruler       " we may want to know where we are in the file

set ignorecase  " ignore case in search....
set smartcase   " but if we WANT case, use it

if exists('+autochdir')
    " use the builtin if we have it
    set autochdir
else
    " use the manual method 
    autocmd BufEnter * silent! lcd %:p:h
endif

"colorscheme desert
colorscheme zenburn

set wildignore=*.bak,*~,*.o,*.h,*.info,*.swp,*.class

" array of paths pointing to parent directories
"   of project directories; IE: each path here
"   contains subdirectories which themselves are
"   project directories.
" NOTE that we're lazy, so these MUST contain
"   the trailing backslash
let g:ProjectParentPaths = [
    \'/Users/dhleong/git/',
    \'/Users/dhleong/Documents/workspace/',
    \'/Users/dhleong/code/appengine/',
    \'/Users/dhleong/code/'
\]

" visual bell
set vb

" hide useless gui
set guioptions=ac

" Let's make it easy to edit this file (mnemonic for the key sequence is
" 'e'dit 'v'imrc)
nmap <silent> <leader>ev :e $MYVIMRC<cr>

" And, in a new tab
nmap <silent> <leader>tev :tabe $MYVIMRC<cr>

" And to source this file as well (mnemonic for the key sequence is
" 's'ource 'v'imrc)
nmap <silent> <leader>sv :so $MYVIMRC<cr>

" Quick make 
nmap <silent> <leader>mm :make<cr>

" Quick make clean
nmap <silent> <leader>mc :make clean<cr>

" Quick make and run
nmap <silent> <leader>mr :make run<cr>

" ctrl+tab between tabs
nmap <silent> <C-Tab> :tabn<cr>
nmap <silent> <C-S-Tab> :tabp<cr>

" ctrl+a to get to front of line in commandline mode
cnoremap <C-A> <Home>

" eregex config
let g:eregex_default_enable = 0  " doesn't do incremental search, so no
nnoremap <leader>/ :call eregex#toggle()<CR>

" add :gitco alias
nnoremap <leader>gc :Gcommit -a<CR>

" Tweaking {} motion behavior
let g:ip_boundary = '"\?\s*$' 

" super tab and other completion settings
let g:SuperTabNoCompleteAfter = ['//', '\s', ',', '#']
let g:SuperTabNoCompleteBefore = ['\w']
let g:SuperTabLongestEnhanced = 1
let g:SuperTabLongestHighlight = 1
let g:SuperTabMappingBackward = '<s-c-space>' " don't override our custom guy!

" use shift-tab in normal mode, or insert mode with no popup, to unindent
" crazy redundancy required because just <C-p> goes forward, for some
" reason (although the c-n c-p thing works as expected. weird)
inoremap <expr><S-Tab> pumvisible()? "\<down>\<C-n>\<C-p>" : "\<c-d>"
nnoremap <S-Tab> <<_
nnoremap <Tab> >>_

set completeopt=menu,preview,longest

"
" some abbreviations/typo fixes
"

" I do this ALL the time
abbr ~? ~/

"
" My project path script
"

let g:ProjectGrepPath = "*"

" function to automatically set the appropriate path :)
function! SetPathToProject()
    let this_file = expand("%:p:h") . '/' . expand("%:t")
    for projDir in g:ProjectParentPaths
        " check if our file matches a project src dir
        let len = strlen(projDir)
        if strpart(this_file, 0, len) == projDir
            let noDir = strpart(this_file, len) " path w/o projDir
            let idx = stridx(noDir, '/')

            " if there's no /, we're not in a project
            if idx == -1
                continue
            endif

            " build the path
            let projName = strpart(noDir, 0, idx+1)
            let pathDir = projDir . projName . '**'

            " set it
            exe 'set path='.pathDir
            let g:ProjectGrepPath = projDir . projName . '*'
            return
        endif
    endfor

    " if we get here, we found no path
    if exists('g:DefaultPath')
        exe 'set path='.g:DefaultPath
    else
        " vim default path
        exe 'set path=.,/usr/include,,'
    endif
endfunction

function! ConfigureJava()

    "let <buffer>g:SuperTabDefaultCompletionType = "<c-x><c-u>"
    call SuperTabSetDefaultCompletionType("<c-x><c-u>")

    nmap <silent> <leader>fi :JavaImportOrganize<cr>
    nmap <silent> <leader>ji :JavaImpl<cr>
    nmap <silent> <leader>pp :ProjectProblems!<cr>
    nmap <silent> <leader>jc :JavaCorrect<cr> 
    nmap <silent> <leader>jf :JavaCorrect<cr> 
    nmap <silent> <leader>jd :JavaDocPreview<cr> 

    " let c-n do the regular local search
    inoremap <buffer> <c-n> <c-x><c-n> 
endfunction

function! ConfigurePython()
    nmap <silent> <F19> :!python %<cr>
    "let <buffer> g:SuperTabDefaultCompletionType = "<c-x><c-o>"
    call SuperTabSetDefaultCompletionType("<c-x><c-o>")

    " let c-n do the regular local search
    inoremap <buffer> <c-n> <c-x><c-n> 

    " the one above doesn't cooperate with vim-jedi for some reason
    inoremap <buffer> <expr><S-Tab> pumvisible()? "\<up>\<C-n>\<C-p>" : "\<c-d>"

endfunction

if has('autocmd') && !exists('autocmds_loaded')

    let autocmds_loaded = 1

    " some java stuff
    autocmd BufEnter *.java call ConfigureJava()
    "autocmd BufWrite *.java silent! JavaImportOrganize " import missing on save
    
    autocmd BufEnter *.py call ConfigurePython()

    autocmd BufEnter * if &ft == '' | let b:SuperTabDisabled = 1 | else | let b:SuperTabDisabled = 0 | endif

    " let K call vim 'help' when in a vim file
    autocmd FileType vim nnoremap <buffer> K :exe 'help ' .expand('<cword>')<cr>

    " have some nice auto paths
    autocmd BufEnter * call SetPathToProject()
endif

function! FixLineEndingsFunc()
    update	 " Save any changes.
    e ++ff=dos	 " Edit file again, using dos file format 
    setlocal ff=unix	" This buffer will use LF-only line endings 
    w
endfunction

command! FixLineEndings call FixLineEndingsFunc()

" For converting XML stuff into style;
" Select some lines, then run :'<,'>norm @x
function! XmlToStyleFunc()
    let @x = 'I<item name="f=xa>f"c$</item>j'
endfunction

command! XmlToStyle call XmlToStyleFunc()

" automatically fill the x macro reg
:XmlToStyle

" 
" Quick todo list using grep and quickfix
"
function! SetTitleAndClearAutoCmd()
    setl statusline="Quick Todo List" 
    au! BufWinEnter quickfix
endfunction

function! OpenTodoListFunc()
    " we just use the tasklist var for tokens
    if !exists('g:tlTokenList')
        let g:tlTokenList = ["FIXME", "TODO", "XXX"]
    endif

    autocmd BufWinEnter quickfix call SetTitleAndClearAutoCmd()
    cgetexpr system("grep -IERn '" . join(g:tlTokenList, '\|') . "' " . g:ProjectGrepPath)
    copen
endfunction

command! OpenTodoList call OpenTodoListFunc()

nmap <leader>T :OpenTodoList<cr>

"let g:EclimDisabled=0

:source /Users/dhleong/code/vim-javadocer/javadocer.vim

" jedi configs
let g:jedi#squelch_py_warning = 1
let g:jedi#popup_select_first = 1
let g:jedi#get_definition_command = "gd"
