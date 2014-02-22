" This must be first, because it changes other options as side effect
set nocompatible

let g:useYcmCompletion = 1 " else, acp and supertab

" From http://www.erikzaadi.com/2012/03/19/auto-installing-vundle-from-your-vimrc/
" Setting up Vundle - the vim plugin bundler
    let iCanHazVundle=1
    let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
    if !filereadable(vundle_readme)
        echo "Installing Vundle.."
        echo ""
        silent !mkdir -p ~/.vim/bundle
        silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
        let iCanHazVundle=0
    endif

    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()

    Bundle 'gmarik/vundle'
    "Add your bundles here
    Bundle 'eregex.vim'
    Bundle 'matchit.zip'
    Bundle 'VisIncr'

    Bundle 'bling/vim-airline'
    Bundle 'davidhalter/jedi-vim'
    Bundle 'dhleong/tcomment_vim'
    Bundle 'marijnh/tern_for_vim'
    Bundle 'oplatek/Conque-Shell'
    Bundle 'reinh/vim-makegreen'
    Bundle 'scrooloose/syntastic'
    Bundle 'Shougo/unite.vim'
    Bundle 'Shougo/vimproc.vim'
    Bundle 'skammer/vim-css-color'
    Bundle 'suan/vim-instant-markdown'
    Bundle 'tpope/vim-fugitive' 
    Bundle 'tpope/vim-repeat' 
    Bundle 'tpope/vim-surround' 
    Bundle 'Valloric/MatchTagAlways'
    Bundle 'xolox/vim-misc'
    Bundle 'xolox/vim-session'

    " completion
    if g:useYcmCompletion == 1
        Bundle 'Valloric/YouCompleteMe'
    else
        Bundle 'dhleong/vim-autocomplpop'
        Bundle 'ervandew/supertab'
    endif

    " I would prefer to user MarcWeber's,
    "  but it seems to be broken with YCM
    " Bundle 'MarcWeber/ultisnips'
    Bundle 'SirVer/ultisnips'
    "Bundle 'honza/vim-snippets' " unneeded with SirVer

    " Syntax plugins
    Bundle 'groenewege/vim-less'

    "...All your other bundles...
    if iCanHazVundle == 0
        echo "Installing Bundles, please ignore key map error messages"
        echo ""
        :BundleInstall

        echo "Building vimproc"
        silent !cd ~/.vim/bundle/vimproc.vim && make

        echo "Installing Tern"
        silent !cd ~/.vim/bundle/tern_for_vim && npm install

        echo "Installing jedi"
        silent !cd ~/.vim/bundle/jedi-vim && git submodule update --init

        echo "Installing vim-instant-markdown"
        silent sudo gem install redcarpet pygments.rb && sudo npm -g install instant-markdown-d

        if g:useYcmCompletion == 1
            echo "Installing YCM"
            silent !cd ~/.vim/bundle/YouCompleteMe && ./install.sh --clang-completer
        endif

        echo "Done!"
        echo "Note that you may need to restart vim for airline fonts to work!"
    endif
" Setting up Vundle - the vim plugin bundler end


set autoindent
set copyindent    " copy the previous indentation on autoindenting
set showcmd
set incsearch
syntax enable
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
set ruler       " we may want to know where we are in the file

set ignorecase  " ignore case in search....
set smartcase   " but if we WANT case, use it

set splitright  " horizontal splits should not open on the left... 

if exists('+autochdir')
    " use the builtin if we have it
    set autochdir
else
    " use the manual method 
    autocmd BufEnter * silent! lcd %:p:h
endif

"colorscheme desert
colorscheme zenburn

set wildignore=.svn,.git,*.o,*.a,*.class,*.pyc
set wildignore+=*.mo,*.la,*.so,*.obj,*.swp,*.swo
set wildignore+=*.jpg,*.png,*.xpm,*.gif,*.pdf,*.bak
set wildignore+=*.beam,*~,*.info

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

" Also, just source it automatically on write
augroup VimAutoSource
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

" While we're here, how about a vim shell? :)
let g:ConqueTerm_CloseOnEnd = 1 " close the tab/split when the shell exits
let g:ConqueTerm_StartMessages = 0 " shhh. it's fine
nmap <silent> <leader>vs :ConqueTermVSplit bash -l<cr>
nmap <silent> <leader>tvs :ConqueTermTab bash -l<cr>

" Enable faster splits navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Ctrl-S 2x to open a vertical split (I use these a lot)
" It's 2x because <C-S><C-P> does Unite Search to open in vsp,
"  so this is faster if I just want a straight split
nnoremap <C-S><C-S> :vsp<cr>

" Quick make 
function! CompileLess()
    silent !lessc % %:t:r.css > /dev/null

    " quickly open, write, and close the file.
    " this helps trick Tincr into reloading
    " the updated css file more reliably
    silent new %:t:r.css
    silent w
    silent q
endfunction
function! MapMake()
    if &ft == 'less'
        " the make shortcut should just compile lesscss
        nnoremap <silent> <leader>mm :w<cr> <BAR> call CompileLess()
    elseif expand('%:p') == $MYVIMRC
        " make green
        nmap <silent> <leader>mm :BundleInstall<cr>
    elseif &ft == 'javascript'
        " make green
        nmap <silent> <leader>mm :MakeGreen<cr>
    else
        " otherwise, just make
        nmap <silent> <leader>mm :make<cr>
    endif 
endfunction
augroup MakeMapper
    autocmd!
    autocmd BufEnter * call MapMake()
augroup END

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

" some git configs
nnoremap <leader>gc :Gcommit -a<CR>

function! WriteAndPush()
    if expand('%') == "COMMIT_EDITMSG" 
        :Gwrite
        :Git push
    else
        :Git push
    endif
endfunction
nnoremap <leader>gp :call WriteAndPush()<CR>


" Tweaking {} motion behavior
let g:ip_boundary = '"\?\s*$' 
" don't open folds when jumping over blocks
let g:ip_skipfold = 1


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

" If we have suggestions open, we want some keys
" to accept the suggestion *and* add their key, 
" for more fluid typing
let acceptSuggestionKeys = ['<Space>', '.', ',', ':', ';', '(', ')', '[', ']']
for key in acceptSuggestionKeys
    exe 'inoremap <expr>' . key . ' pumvisible() ? "\<C-y>' . key . '" : "' . key . '"'
endfor

set completeopt=menu,preview,longest

"
" some abbreviations/typo fixes
"

" I do this ALL the time
abbr ~? ~/
iabbr mfa Miners/minus-for-Android


"
" unite configs
"

" borrow ignore extensions from wildignore setting
let _wilds = substitute(&wildignore, "[~.*]", "", "g") " remove unneeded
let _wilds = substitute(_wilds, ",", "\\\\|", "g") " replace , with \|
let _wilds = '\%(^\|/\)\.\.\?$\|\.git/\|node_modules/\|\~$\|\.\%(' . _wilds . '\)$' " borrowed from default
call unite#custom#source("file_rec/async", "ignore_pattern", _wilds)

" keymaps
function! MapCtrlP(path)
    execute 'nnoremap <C-p> :Unite tab:no-current file_rec/async:' . a:path .  ' -start-insert<cr>'
    execute 'nnoremap <C-w><C-p> :Unite tab:no-current file_rec/async:' . a:path .  ' -start-insert -default-action=tabopen<cr>'
    execute 'nnoremap <C-s><C-p> :Unite tab:no-current file_rec/async:' . a:path .  ' -start-insert -default-action=vsplit<cr>'
endfunction

" default map for C-p (we'll remap with project directory soon)
call MapCtrlP("")
nnoremap <leader>/ :Unite grep:. -auto-preview<cr>
let g:unite_enable_ignore_case = 1

" use \p to open a list of project dirs, from which we can rec/async a file
" It's disappointingly slow to open, but... oh well
let g:UniteProjects = ''
for path in g:ProjectParentPaths
    let g:UniteProjects = g:UniteProjects . ' directory:' . path
endfor
call unite#custom#source('directory', 'matchers', 'matcher_fuzzy')
execute 'nnoremap <silent> <leader>p :Unite ' . g:UniteProjects .
    \ ' -start-insert -default-action=rec/async<cr>'


"
" My project path script
"
let g:ProjectPath = "./"
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
            let g:ProjectPath = projDir . projName 
            let g:ProjectGrepPath = g:ProjectPath . '*'
            call MapCtrlP(g:ProjectPath)
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

    " reset ctrl-p to default
    call MapCtrlP("")
endfunction

function! ConfigureJava()

    if g:useYcmCompletion == 0
        " this is good for eclim, but not for now
        "call SuperTabSetDefaultCompletionType("<c-x><c-u>")

        " ...but the default is super slow
        call SuperTabSetDefaultCompletionType("<c-x><c-n>") 
    endif 

    nmap <silent> <leader>fi :JavaImportOrganize<cr>
    nmap <silent> <leader>ji :JavaImpl<cr>
    nmap <silent> <leader>pp :ProjectProblems!<cr>
    nmap <silent> <leader>jc :JavaCorrect<cr> 
    nmap <silent> <leader>jf :JavaCorrect<cr> 
    nmap <silent> <leader>jd :JavaDocPreview<cr> 

    " let c-n do the regular local search
    inoremap <buffer> <c-n> <c-x><c-n>

    " the one above doesn't cooperate here, either...
    inoremap <buffer> <expr><S-Tab> pumvisible()? "\<up>\<C-n>\<C-p>" : "\<c-d>"
endfunction

function! ConfigurePython()
    nmap <silent> <F19> :!python %<cr>
    "let <buffer> g:SuperTabDefaultCompletionType = "<c-x><c-o>"
    "call SuperTabSetDefaultCompletionType("<c-x><c-o>")

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

    autocmd BufWritePost *.less call CompileLess()

    " have some nice auto paths
    autocmd BufEnter * call SetPathToProject()

    " Use omnifunc when available, and chain back to normal
    if g:useYcmCompletion == 0
        autocmd FileType * 
            \ if &omnifunc != '' |
            \   call SuperTabChain(&omnifunc, "<c-x><c-n>") |
            \   call SuperTabSetDefaultCompletionType("<c-x><c-u>") |
            \ endif
    endif

endif

function! FixLineEndingsFunc()
    update	 " Save any changes.
    e ++ff=dos	 " Edit file again, using dos file format 
    setlocal ff=unix	" This buffer will use LF-only line endings 
    w
endfunction

command! FixLineEndings call FixLineEndingsFunc()

function! DocToJson()
    :%!python -mjson.tool
    set ft=javascript
endfunction
command! JSON call DocToJson()

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
        let g:tlTokenList = ["FIXME", "TODO", "XXX", "STOPSHIP"]
    endif

    autocmd BufWinEnter quickfix call SetTitleAndClearAutoCmd()
    cgetexpr system("grep -IERn '" . join(g:tlTokenList, '\|') . "' " . g:ProjectGrepPath)
    copen
endfunction

command! OpenTodoList call OpenTodoListFunc()

nmap <leader>T :OpenTodoList<cr>
nmap <leader>tq :sign unplace *<cr> :LocationListClear<cr>

"let g:EclimDisabled=0
let g:EclimJavascriptValidate = 0 

":source /Users/dhleong/code/vim-javadocer/javadocer.vim
silent! source /Users/dhleong/code/njast/njast.vim

" jedi configs
let g:jedi#squelch_py_warning = 1
let g:jedi#popup_select_first = 1
let g:jedi#goto_definitions_command = "gd"

" session configs
let g:session_autosave = 'yes'
let g:session_autoload = 'no'

" airline configs
set laststatus=2
let g:airline_detect_whitespace = 0
let g:airline#extensions#eclim#enabled = 0
let g:airline#extensions#default#section_truncate_width = {
  \ 'x': 88,
  \ 'y': 88,
  \ 'z': 45,
  \ }

" autocomplpop configs
let g:acp_completeoptPreview = 1
" fix unshift when popup isn't open
let g:acp_previousItemMapping = ['<S-Tab>', '\<lt>c-d>']

" syntastic configs
let g:syntastic_java_checkers = ['checkstyle']

if g:useYcmCompletion == 1

  let g:ycm_filetype_blacklist = {
        \ 'tagbar' : 1,
        \ 'qf' : 1,
        \ 'notes' : 1,
        \ 'unite' : 1,
        \ 'vimwiki' : 1,
        \ 'pandoc' : 1,
        \ 'conque_term' : 1
        \}
    
    let g:ycm_key_list_previous_completion = ['<Up>'] " NOT s-tab; we do the right thing below:
    inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<c-d>"

    " most useful for gitcommit
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    
endif

let g:UltiSnipsListSnippets="<C-M-Tab>"
let g:UltiSnipsExpandTrigger="<C-Enter>"
let g:UltiSnipsJumpForwardTrigger="<C-J>"
let g:UltiSnipsJumpBackwardTrigger="<C-K>"

"
" Commenting configs
"
let g:tcomment_types = {
    \ 'java': '// %s',
    \ 'java_inline': '// %s',
    \ 'java_block': '// %s'
    \ }


"
" Github fun
"
let g:gh_cmd = "/Users/dhleong/code/hubr/gh-cmd"
function! GithubAcceptFunc()
    let ticket=expand("<cword>")
    echo "Accepting Github ticket #" . ticket . "..."
    let cmd=":!" . g:gh_cmd . ' accept ' . ticket
    exe cmd
endfunction
command! GithubAccept call GithubAcceptFunc()

function! GithubTakeFunc()
    let ticket=expand("<cword>")
    echo "Taking Github ticket #" . ticket . "..."
    let cmd=":!" . g:gh_cmd . ' take ' . ticket
    exe cmd
endfunction

command! GithubTake call GithubTakeFunc()
" mark the issue number under the cursor as accept
nnoremap gha :GithubAccept<cr>

" 'take' the issue under the cursor (assign to 'me')
nnoremap ght :GithubTake<cr>
