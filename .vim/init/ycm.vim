" YCM LSP {{{

let g:ycm_language_server = [
    \ {
    \   'name': 'sourcekit-lsp',
    \   'cmdline': ['xcrun', 'sourcekit-lsp', '--log-level=debug'],
    \   'filetypes': ['swift'],
    \   'project_root_files': [ 'Package.swift' ],
    \ },
    \ {
    \   'name': 'elixir-ls',
    \   'cmdline': [$HOME . '/work/elixir-ls/language_server.sh'],
    \   'filetypes': ['elixir'],
    \   'project_root_files': [ 'mix.exs' ],
    \ }
    \ ]
" }}}

let g:ycm_filetype_blacklist = {
    \ 'tagbar' : 1,
    \ 'qf' : 1,
    \ 'notes' : 1,
    \ 'unite' : 1,
    \ 'vimwiki' : 1,
    \ 'pandoc' : 1,
    \}

let g:ycm_filter_diagnostics = {
    \   'cs': {
    \     'regex': [
    \       "Convert to 'return' statement",
    \       "Convert to '&=' expresssion",
    \       "Convert to '&=' expression",
    \       "prefix '_'",
    \       "Parameter can be ",
    \       "Redundant argument name specification",
    \       "Use 'var' keyword",
    \       "Xml comment",
    \     ]
    \   },
    \   'cpp': {
    \     'regex': [
    \       "enumeration in a nested name specifier",
    \     ]
    \   }
    \ }

let g:ycm_key_list_previous_completion = ['<Up>'] " NOT s-tab; we do the right thing below:
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<c-d>"

" most useful for gitcommit
let g:ycm_collect_identifiers_from_comments_and_strings = 1

let g:ycm_always_populate_location_list = 1

let g:ycm_auto_hover = ''

let g:ycm_tsserver_binary_path = "/Users/dhleong/.npm-packages/bin/tsserver"

" NOTE: use the version installed via homebrew:
if filereadable('/usr/local/bin/rust-analyzer')
    let g:ycm_rust_toolchain_root = '/usr/local'
endif

let g:ycm_extra_conf_globlist = [
    \ '~/.dotfiles/dots/.vim/bundle/YouCompleteMe/*',
    \ '~/git/juuce/*',
    \ '~/git/iaido/*',
    \ '~/work/*',
    \ ]

" let g:ycm_max_diagnostics_to_display = 50

