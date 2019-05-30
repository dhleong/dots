" ======= Global mappings ==================================
"

let $_MYVIMRC = resolve($MYVIMRC)


" ======= Completion-related ===============================

" use shift-tab in normal mode, or insert mode with no popup, to unindent
inoremap <expr><S-Tab> pumvisible()? "\<C-p>" : "\<c-d>"
nnoremap <S-Tab> <<_
nnoremap <Tab> >>_

" This is cool but we don't auto-select the first suggestion right now:
" " If we have suggestions open, we want some keys
" " to accept the suggestion *and* add their key, 
" " for more fluid typing
" let acceptSuggestionKeys = ['<Space>', '.', ',', ':', ';', '(', ')', '[', ']']
" for key in acceptSuggestionKeys
"     exe 'imap <expr>' . key . ' pumvisible() ? "\<C-y>' . key . '" : "' . key . '"'
" endfor


" ======= Text manipulation ===============================

" vim-surround extensions:
" You can use `r` as the surround type, but not the target?
" Let's fix that
nmap ysar ysa]


" ======= Insert/Command-mode navigation ===================

" Navigation in insert mode, for use with multicursor
inoremap <C-A> <esc>I
inoremap <C-E> <esc>A

" ctrl+a to get to front of line in commandline mode
cnoremap <C-A> <Home>

" ctrl+f to edit the current command/prompt in the command-line window
" this is the default mapping, but I'm putting it here as a reminder
" because it's awesome—makes renaming things in netrw way better!
set cedit=\<C-F>


" ======= Terminal mode maps ===============================

" map alt+backspace to send <c-w> (see :help ctrl-w_.)
" this lets us use the reglar key chord for 'delete back word'
" in insert mode in any fzf-based search UI (it theoretically
" has this mapping already but it doesn't seem to work in OSX)
tnoremap <m-bs> <c-w>.


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
nmap <silent> <expr> <leader>vp ":e " . resolve("~/.vim/init/plugins.vim") . "<cr>"

" Edit the filetype file of the current file in a new tab
nnoremap <silent> <expr> <leader>eft ":tabe " . resolve(join([$HOME, "/.vim/ftplugin/", &filetype, ".vim"], "")) . "<cr>"

" Open the bash profile
nnoremap <silent> <expr> <leader>eb ":e " . resolve("~/.bash_profile") . "<cr>"
nnoremap <silent> <expr> <leader>teb ":tabe " . resolve("~/.bash_profile") . "<cr>"
nnoremap <silent> <expr> <leader>ep ":e " . resolve("~/.bash_profile") . "<cr>"
nnoremap <silent> <expr> <leader>tez ":tabe " . resolve("~/.zshrc") . "<cr>"
nnoremap <silent> <expr> <leader>ez ":e " . resolve("~/.zshrc") . "<cr>"


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
function! s:windowFocusFunc()
    call feedkeys("\<c-w>=", "n")
    call feedkeys("\<c-w>15+", "n")
    call feedkeys("\<c-w>15>", "n")
endfunction
nnoremap <silent> <leader>wf :call <SID>windowFocusFunc()<cr>


" ======= File navigation ==================================

nnoremap <silent> <leader>p :call dhleong#nav#Projects()<cr>

" Note: I don't really use this anymore, but could be nice to restore...
" execute 'nnoremap <silent> <leader>y :Unite ' . g:UniteProjects .
"     \ ' -start-insert -sync -unique -hide-source-names ' .
"     \ ' -default-action=lily<cr>'

" " fancier way to search through file than /
" call unite#custom#source('line', 'matchers', 'matcher_fuzzy')
" nnoremap <silent> \  :<C-u>Unite -buffer-name=search
"     \ line -start-insert<CR>


" ======= Misc =============================================

" Make folding/unfolding easier
nnoremap + zA

" find a build.gradle
nnoremap <silent> <leader>og :call dhleong#nav#FindGradle()<cr>

" print unicode pairs
nnoremap ga :call dhleong#text#GetUnicodePairs()<cr>

" open an url in a browser
nnoremap gbo :silent exe '!open "' . expand('<cWORD>') . '"'<cr>


" ======= Prevent trailing whitespace ======================

" Clean up trailing whitespace
" NOTE: we manually add the vim-endwise <Plug> mapping here so
" remaps from eg vim-hyperstyle don't break things; by default,
" vim-endwise uses <script>-local maps, which we obviously can't
" reproduce when re-mapping
imap <Enter> <C-R>=dhleong#text#TryCleanWhitespace()<cr><Plug>DiscretionaryEnd


" ======= Smart text manipulation ==========================

nnoremap <a-cr> :call dhleong#fix#Fix()<cr>

