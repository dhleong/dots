func! s:xcodeConfig()
    let existing = get(b:, 'swift_xcode_config', '')
    if existing !=# ''
        return existing
    endif

    let project = fnamemodify(findfile('project.pbxproj'), ':p:h')
    if project !=# '' && project =~# '.xcodeproj$'
        let b:swift_xcode_config = '-project ' . project
        return b:swift_xcode_config
    endif

    return ''
endfunc

func! s:xcodebuild(args)
    let config = s:xcodeConfig()
    if config ==# ''
        return ''
    endif
    return 'xcodebuild ' . config . ' ' . a:args
endfunc

func! s:xcodejson(args)
    let cmd = s:xcodebuild(a:args)
    if cmd ==# ''
        return v:null
    endif

    let output = system(cmd . ' -json')
    return json_decode(output)
endfunc

func! s:ensureScheme()
    if get(b:, 'swift_xcode_scheme', '') ==# ''
        echo "Locating project..."

        " TODO: we probably ought to refactor this to be done async
        let info = s:xcodejson('-list')
        if type(info) != v:t_dict
            echom "Couldn't locate xcode config"
            return
        endif

        if has_key(info.project, 'schemes') && len(info.project.schemes)
            let b:swift_xcode_scheme = info.project.schemes[0]
            return b:swift_xcode_scheme
        endif
    endif

    let scheme = get(b:, 'swift_xcode_scheme', '')
    if scheme ==# ''
        echom "No scheme found"
        return
    endif

    return scheme
endfunc

func! s:Run()
    let scheme = s:ensureScheme()
    if scheme ==# ''
        return
    endif

    " TODO ensure any previous job is stopped

    let win = winnr()

    " TODO: open in float?
    let winSize = 7
    exe 'botright split | resize ' . winSize
    let job = term_start(s:xcodebuild('-scheme ' . scheme), {
        \ 'term_name': 'Xcode Build',
        \ 'curwin': 1,
        \ 'term_finish': 'close',
        \ })

    if win != 0
        " go back to the previous window
        exe win . 'wincmd w'
    endif
endfunc


" ======= mappings ========================================

" my standard mappings
nnoremap <buffer> <c-w>gd :call dhleong#GotoInNewTab("GoToDefinition")<cr>
nnoremap <buffer> gd :YcmCompleter GoToDefinition<cr>
nnoremap <buffer> K :YcmCompleter GetHover<cr>
nnoremap <buffer> <leader>js :YcmCompleter GoToReferences<cr>

" swift/xcode-specific
nnoremap <silent> <leader>pr :call <SID>Run()<cr>
