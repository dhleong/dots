
function! s:TslintInfo()
    let line = line('.')
    let list = ale#engine#GetLoclist(bufnr('%'))
    for l in list
        if l['lnum'] == line
            echo "Opening..."
            silent exe "!open https://palantir.github.io/tslint/rules/" . l['code']
            return
        endif
    endfor

    echo "No lint info"
endfunction

nnoremap <buffer> gli :call <SID>TslintInfo()<cr>

if expand('%:e') ==# 'tsx'
    " two-space tabs in tsx files, since we're embedding html
    setlocal tabstop=2 shiftwidth=2
endif

" format comments like javascript does
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://

" shared config with javascript
call dhleong#ft#javascript#Config()
