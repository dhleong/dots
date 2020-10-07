" TODO: can we quickly figure this out instead of hard-coding?
if exists("+pythonthreehome")
    let py3 = "/usr/local/Cellar/python@3.8/3.8.5/Frameworks/Python.framework/Versions/3.8"
    exe 'set pythonthreehome=' . py3
    exe 'set pythonthreedll=' . py3 . '/Python'
endif
