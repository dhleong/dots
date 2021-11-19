let g:coc_global_extensions = [
    \ 'coc-elixir',
    \ 'coc-go',
    \ 'coc-jedi',
    \ 'coc-json',
    \ 'coc-prettier',
    \ 'coc-rust-analyzer',
    \ 'coc-snippets',
    \ 'coc-sourcekit',
    \ 'coc-tsserver',
    \ 'coc-vimlsp',
    \ ]

inoremap <silent><expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr> <s-tab> pumvisible() ? "\<c-p>" : "\<c-d>"

inoremap <silent><expr> <c-space> coc#refresh()

augroup MyCocActionsGroup
  autocmd!

  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')

  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
