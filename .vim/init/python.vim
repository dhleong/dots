" TODO: can we quickly figure this out instead of hard-coding?
if exists("+pythonthreehome")
    let py3 = "/usr/local/Cellar/python/3.7.6/Frameworks/Python.framework/Versions/3.7"
    exe 'set pythonthreehome=' . py3
    exe 'set pythonthreedll=' . py3 . '/lib/libpython3.7m.dylib'
endif
