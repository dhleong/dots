" nmap <d-r> :Require!<cr>cqq

function! DoReload()
    silent :Require!
endfunction

augroup ClojureGroup
    autocmd!
    autocmd BufWritePost *.clj call DoReload()
augroup END

nmap <d-r> :%Eval<cr>
