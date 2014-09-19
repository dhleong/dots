" nmap <d-r> :Require!<cr>cqq

function! DoReload()
    silent :Require
    silent :ClojureHighlightReferences
endfunction

function! RunBufferTests()
    let ns = fireplace#ns()
    if ns !~ '-test$'
        let ns = ns . "-test"
    endif
    silent :Require
    exe "RunTests " . ns
endfunction

augroup ClojureGroup
    autocmd!
    autocmd BufWritePost *.clj call DoReload()
augroup END

nnoremap <buffer> <d-r> :%Eval<cr>
nnoremap <buffer> cpr :call RunBufferTests()<cr>
nnoremap <buffer> cpt :call RunBufferTests()<cr>
nmap <buffer> cql cqp<up><cr>

"
" Auto-start lein repl
"

python << EOF
import os, platform, subprocess, vim

try:
    # only define once, please
    clj_repl_procs
except:
    clj_repl_procs = []

def open_repl():
    win = platform.system() == "Windows"
    env = None
    if platform.system() == "Darwin":
        env = os.environ.copy()
        env["PATH"] += ":/usr/local/bin"

    dir = os.path.dirname(vim.current.buffer.name)
    proc = subprocess.Popen(['lein', 'repl'],
                          env=env, cwd=dir,
                          stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                          stderr=subprocess.STDOUT, shell=win)

    clj_repl_procs.append(proc)

    line = proc.stdout.readline()
    if not line:
        print "Error"
    else:
        # re-open the file to auto-connect
        # do like this to suppress the "return to continue"
        # and make it look fancy
        vim.command('e | redraw | echohl IncSearch | echo "Repl Started" | echohl None')


def close_all_repl():
    for proc in clj_repl_procs:
        proc.stdin.close()
        proc.kill()

def restart_repl():
    vim.command('redraw | echo "Closing Repl..."')
    close_all_repl()
    vim.command('redraw | echo "Restaring Repl..."')
    open_repl()

EOF

command! LeinRepl py open_repl()

function! LeinReplCloseFunc()
    py close_all_repl()
endfunction
command! LeinReplClose call LeinReplCloseFunc()

command! LeinReplRestart py restart_repl()

augroup LeinShutDownGroup
    autocmd VimLeavePre * call LeinReplCloseFunc()
augroup END
