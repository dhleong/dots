
" don't show tabs because golang just loves them :\
setlocal listchars=tab:\ \ ,trail:·

nnoremap <buffer> <c-w>gd :call dhleong#GotoInNewTab('', ':GoDef')<cr>
nnoremap <buffer> <leader>pb :GoBuild<cr>
