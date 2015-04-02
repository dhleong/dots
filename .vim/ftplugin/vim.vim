
function! GotoPluginHomepage()
    redraw!
    let line = getline('.')
    let matches = matchlist(line, 'Plug ''\(.*\)''')
    if len(matches) > 1
        let plugin = matches[1]
        if -1 != stridx(plugin, '/')
            " probably git
            if 0 != stridx(plugin, "file:")
                call system("open https://github.com/" . plugin)
            endif
        endif
    endif
endfunction

" goto plugin home/open
nnoremap gph :call GotoPluginHomepage()<cr>
nnoremap gpo :call GotoPluginHomepage()<cr>
