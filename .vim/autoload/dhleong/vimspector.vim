let s:debuggerMappings = {
    \ 'gk': '<Plug>VimspectorRunToCursor',
    \ 'gi': '<Plug>VimspectorStepInto',
    \ 'gn': '<Plug>VimspectorStepOver',
    \ 'go': '<Plug>VimspectorStepOut',
    \ }

func! s:ConfigureWatches()
    nmap <buffer> dd <del>
endfunc

" ======= debugger keymap management ======================

func! s:Map(kvs)
    for [keys, mapping] in items(a:kvs)
        exe 'nmap <buffer> ' . keys . ' ' . mapping
    endfor
endfunc

func! s:RestoreOriginalMappings()
    for keys in keys(s:debuggerMappings)
        try
            exe 'nunmap <buffer> ' . keys
        catch /.*/
            " ignore if already unmapped
        endtry
    endfor
    call s:Map(get(b:, 'dhleong_vimspectorOriginalMaps', {}))
endfunc

func! s:StashOriginalMappings()
    if type(get(b:, 'dhleong_vimspectorOriginalMaps', 0)) != type(0)
        " already done
        return
    endif

    let toStash = {}
    for keys in keys(s:debuggerMappings)
        let mapped = maparg(keys, 'n', 0, 1)
        if get(mapped, 'buffer', 0)
            let toStash[keys] = mapped.rhs
        endif
    endfor

    let b:dhleong_vimspectorOriginalMaps = toStash
endfunc

func! s:SetDebuggerMappings()
    call s:Map(s:debuggerMappings)
endfunc

func! s:SetOrClearDebuggerMappings()
    let windows = get(g:, 'vimspector_session_windows', {})
    if empty(windows) || windows.tabpage != tabpagenr()
        call s:RestoreOriginalMappings()
        return
    else
        call s:StashOriginalMappings()
        call s:SetDebuggerMappings()
    endif
endfunc


" ======= public interface ================================

func! dhleong#vimspector#Config()
    augroup MyVimspectorConfigs
        autocmd!
        autocmd BufEnter vimspector.Watches call <SID>ConfigureWatches()
        autocmd WinEnter * call <SID>SetOrClearDebuggerMappings()
    augroup END

    nmap <buffer> <leader>dc <Plug>VimspectorRunToCursor
    nmap <buffer> <leader>di <Plug>VimspectorStepInto
    nmap <buffer> <leader>dn <Plug>VimspectorStepOver
    nmap <buffer> <leader>do <Plug>VimspectorStepOut
endfunc
