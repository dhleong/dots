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
compiler nodeunit

let g:makegreen_stay_on_file = 1

nnoremap <buffer> cpr :call RunLastTermCommand()<cr>
nnoremap K :TernDoc<CR>
