
function! s:EslintInfo()
    let line = line('.')
    let list = ale#engine#GetLoclist(bufnr('%'))
    for l in list
        if l['lnum'] == line
            echo "Opening..."
            silent exe "!open https://eslint.org/docs/rules/" . l['code']
            return
        endif
    endfor

    echo "No lint info"
endfunction

nnoremap <buffer> gli :call <SID>EslintInfo()<cr>

nnoremap <buffer> <c-w>gd :call dhleong#GotoInNewTab("GoToDefinition")<cr>
nnoremap <buffer> gd :YcmCompleter GoToDefinition<cr>
nnoremap <buffer> K :YcmCompleter GetDoc<cr>
nnoremap <buffer> <leader>jr :call dhleong#refactor#Rename()<cr>

nnoremap <buffer> gpd :!grunt deploy<cr>
nnoremap <buffer> gpi :!grunt lambda_invoke<cr>

nnoremap <buffer> <leader>op :exe 'find package.json'<cr>
nnoremap <buffer> <leader>top :tabe \| exe 'find package.json'<cr>

if expand('%') =~# '-test.js$'
    augroup RunLatte
        autocmd!
        autocmd BufWritePost <buffer> :call latte#Run()
    augroup END
endif

" ======= Plugin config ===================================

" use trailing commas when wrapping argument lines
let b:argwrap_tail_comma = 1
