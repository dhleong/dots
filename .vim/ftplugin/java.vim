
function! ConfigureJava()

    if exists("*intellivim#InProject") && intellivim#InProject()
        nnoremap <buffer> <silent> <leader>fi :JavaOptimizeImports<cr>
        nnoremap <buffer> <silent> <leader>jc :FixProblem<cr>
        nnoremap <buffer> <silent> K :GetDocumentation<cr>
        nnoremap <buffer> <silent> gd :GotoDeclaration<cr>
        nnoremap <buffer> <silent> <leader>lf :Locate<cr>
        nnoremap <buffer> <silent> <leader>lc :Locate class<cr>
        nnoremap <buffer> <silent> <leader>ji :Implement<cr>

        nnoremap <buffer> <silent> <leader>pr :RunProject<cr>
        nnoremap <buffer> cpr :RunTest<cr>
    else
        nnoremap <buffer> <silent> <leader>fi :JavaImportOrganize<cr>
        nnoremap <buffer> <silent> <leader>jc :JavaCorrect<cr>
        nnoremap <buffer> <silent> <leader>ji :JavaImpl<cr>
        nnoremap <buffer> <silent> K :JavaDocPreview<cr>
        nnoremap <buffer> <silent> gd :JavaSearch -x implementors -s workspace<cr>
        nnoremap <buffer> <silent> <leader>lf :LocateFile<cr>
        nnoremap <buffer> <silent> <leader>lc :LocationListClear<cr>

        nnoremap <buffer> <silent> <leader>pr :ProjectRun<cr>
        nnoremap <buffer> cpr :JUnit<cr>
        nnoremap <buffer> cpt :JUnit %<cr>
    endif

    nmap <buffer> <silent> <leader>pp :ProjectProblems!<cr>
    nmap <buffer> <silent> <leader>jf :JavaCorrect<cr>
    nmap <buffer> <silent> <leader>jd :JavaDocSearch<cr>
    nmap <buffer> <silent> <leader>js :JavaSearch -x declarations -s project<cr>
    nmap <buffer> <silent> <leader>jr :JavaSearch -x references -s project<cr>
    nmap <buffer> <silent> <leader>ll :lopen<cr>
    nmap <buffer> <silent> <m-1> :JavaCorrect<cr>

    " let c-n do the regular local search
    inoremap <buffer> <c-n> <c-x><c-n>

    " the one above doesn't cooperate here, either...
    inoremap <buffer> <expr><S-Tab> pumvisible()? "\<up>\<C-n>\<C-p>" : "\<c-d>"
endfunction

" some java stuff
autocmd BufEnter *.java call ConfigureJava()
