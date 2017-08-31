" ======= Global mappings ==================================
"

let $_MYVIMRC = resolve($MYVIMRC)


" ======= Completion-related ===============================

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
    exe 'imap <expr>' . key . ' pumvisible() ? "\<C-y>' . key . '" : "' . key . '"'
endfor


" ======= Insert/Command-mode navigation ===================

" Navigation in insert mode, for use with multicursor
inoremap <C-A> <esc>I
inoremap <C-E> <esc>A

" ctrl+a to get to front of line in commandline mode
cnoremap <C-A> <Home>


" ======= Make =============================================

" Quick make clean
nmap <silent> <leader>mc :make clean<cr>

" Quick make and run
nmap <silent> <leader>mr :make run<cr>


" ======= Open common config files =========================

" Let's make it easy to edit this file (mnemonic for the key sequence is
" 'e'dit 'v'imrc)
nmap <silent> <leader>ev :e $_MYVIMRC<cr>

" And, in a new tab
nmap <silent> <leader>tev :tabe $_MYVIMRC<cr>

" And the bundles dir, as well ('v'im 'b'undles)
nmap <silent> <expr> <leader>vb ":e " . resolve("~/.vim/bundle/") . "<cr>"

" Edit the filetype file of the current file in a new tap
nnoremap <silent> <expr> <leader>eft ":tabe " . resolve(join([$HOME, "/.vim/ftplugin/", &filetype, ".vim"], "")) . "<cr>"

" Open the bash profile
nnoremap <silent> <expr> <leader>eb ":e " . resolve("~/.bash_profile") . "<cr>"
nnoremap <silent> <expr> <leader>teb ":tabe " . resolve("~/.bash_profile") . "<cr>"
nnoremap <silent> <expr> <leader>ep ":e " . resolve("~/.bash_profile") . "<cr>"
nnoremap <silent> <expr> <leader>tep ":tabe " . resolve("~/.bash_profile") . "<cr>"


" ======= Tab/Window manipulation ==========================

" tabclose
nnoremap <silent> <leader>tc :tabclose<cr>

" convenient new tab
nnoremap <C-W><C-W> :tabe<cr>

" Ctrl-S 2x to open a vertical split (I use these a lot)
" It's 2x because <C-S><C-P> does Unite Search to open in vsp,
"  so this is faster if I just want a straight split
nnoremap <C-S><C-S> :vsp<cr>

" Enable faster splits navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" And, faster tab navigation
nnoremap H gT
nnoremap L gt
nnoremap zh H
nnoremap zl L

" ctrl+tab between tabs
nmap <silent> <C-Tab> :tabn<cr>
nmap <silent> <C-S-Tab> :tabp<cr>

" fast window resize
nnoremap <leader>= <C-W>10+
nnoremap <leader>- <C-W>10-

" bring one window in a tab page into 'focus'
function! WindowFocusFunc()
    call feedkeys("\<c-w>=", "n")
    call feedkeys("\<c-w>15+", "n")
    call feedkeys("\<c-w>15>", "n")
endfunction
nnoremap <silent> <leader>wf :call WindowFocusFunc()<cr>


" ======= Misc =============================================

" Make folding/unfolding easier
nnoremap + zA

" find a build.gradle
function! FindGradle()
    try
        find! ./build.gradle
    catch
        find build.gradle
    endtry
endfunction
nnoremap <silent> <leader>og :call FindGradle()<cr>

" get unicode pairs
function! GetUnicodePairs()
    " copy the output of the ascii command
    redir => raw
        ascii
    redir END

    " strip out the hex part and parse to int
    let match = matchlist(raw, 'Hex \(.*\),')
    let hex = match[1]
    let s = str2nr(hex, 16)

    " source: http://www.russellcottrell.com/greek/utilities/surrogatepaircalculator.htm
    if (s >= 0x10000 && s <= 0x10FFFF)
        let hi = float2nr(floor((s - 0x10000) / 0x400) + 0xD800)
        let lo = float2nr(((s - 0x10000) % 0x400) + 0xDC00)
        let pairs = printf('\u%x\u%x', hi, lo)

        " go ahead and copy it to the clipboard
        let @* = pairs
    else
        let pairs = '(none)'
    endif

    " clear old output and echo new
    redraw!
    echo raw[1:] . ', Pairs ' . pairs
endfunction

nnoremap ga :call GetUnicodePairs()<cr>