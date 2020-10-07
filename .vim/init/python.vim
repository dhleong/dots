if exists("+pythonthreehome")
    let dirs = glob("/usr/local/Cellar/python@3.*/3.*/Frameworks/Python.framework/Versions/Current", 1, 1)
    if len(dirs) == 0
        echom "Could not find python3 installation"
    else
        let py3 = dirs[0]
        exe 'set pythonthreehome=' . py3
        exe 'set pythonthreedll=' . py3 . '/Python'
    endif
endif
