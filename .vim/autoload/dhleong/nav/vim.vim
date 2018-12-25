function! s:tryFind(path, fn)
    try
        " jump to the definition of the function if the path exists
        exe 'find +/fun.*\ ' . a:fn . ' ' . a:path
        return
    catch /^Vim\%((\a\+)\)\=:E345
        " 'cannot find on path'; fall through to normal gd
    endtry
endfunction

function! dhleong#nav#vim#GoToDefinition()
    " if the cursor is on an autocmd, we may be able to figure out where it is
    let word = expand("<cword>")
    let autocmdParts = split(word, "#")
    if len(autocmdParts) > 1
        let expectedPath = 'autoload/' . join(autocmdParts[0:-2], '/') . '.vim'

        " first, try to find it on the path (eg: vim projects)
        if s:tryFind('.vim/' . expectedPath, word)
            return
        endif

        " this is sorta hax for the path we set up in the .vim root
        if s:tryFind(expectedPath, word)
            " got it!
            return
        endif

        " TODO try to prefix with each item in rtp?
    endif

    " fall back to default gd
    normal! gd
endfunction
