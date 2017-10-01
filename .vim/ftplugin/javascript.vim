function! RunLastTermCommand()

    let currentWinnr = winnr()

    for [idx, term] in items(g:ConqueTerm_Terminals)
        if !has_key(term, 'bufname')
            continue
        endif

        let winnr = bufwinnr(term.bufname)
        if winnr != -1 && term.active != 0
            " found a Conque shell window!

            exe term.winnr . 'wincmd w'
            :startinsert
            exe 'resize ' . term.winSize

            call term.writeln("cd " . b:fullPath)
            call term.writeln("clear")
            call term.writeln("./" . b:fileName)

            exe 'inoremap <buffer> <Tab> <esc>:' . currentWinnr . 'wincmd w<cr>'
        endif
    endfor

    echo "No shell found"
endfunction

nnoremap <buffer> gd :TernDef<CR>

nnoremap <buffer> cpr :call RunLastTermCommand()<cr>
nnoremap <buffer> K :TernDoc<CR>

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

