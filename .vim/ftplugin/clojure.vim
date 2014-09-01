" nmap <d-r> :Require!<cr>cqq

function! DoReload()
    silent :Require
endfunction

augroup ClojureGroup
    autocmd!
    autocmd BufWritePost *.clj call DoReload()
augroup END

nmap <buffer> <d-r> :%Eval<cr>

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
EOF

command! LeinRepl py open_repl()

function! LeinReplClose()
    py close_all_repl()
endfunction

augroup LeinShutDownGroup
    autocmd VimLeavePre * call LeinReplClose()
augroup END
