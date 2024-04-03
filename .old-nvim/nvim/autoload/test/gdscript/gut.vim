if !exists('g:test#gdscript#gut#file_pattern')
  let g:test#gdscript#gut#file_pattern = '\v(_test|^test_.+)\.gd$'
end

let s:patterns = {
  \ 'test':      ['\v^\s*func (test_\w+)'],
  \ 'namespace': ['\v^\s*class (\w+)'],
\}

function! test#gdscript#gut#test_file(file) abort
  if fnamemodify(a:file, ':t') =~# g:test#gdscript#gut#file_pattern
    if exists('g:test#gdscript#runner')
      return g:test#gdscript#runner ==# 'gut'
    else
      let exe = test#gdscript#gut#executable()
      return executable(exe)
    endif
  endif
endfunction

function! test#gdscript#gut#build_position(type, position) abort
  if a:type ==# 'nearest'
    let args = s:nearest_test_args(a:position)
    return [a:position['file']] + args
  elseif a:type ==# 'class'
    let args = s:nearest_class_args(a:position)
    return [a:position['file']] + args
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#gdscript#gut#build_args(args) abort
  let file_res = 'res://' .. a:args[0]
  let selected_file = fnamemodify(a:args[0], ':t')

  " NOTE: The config file specified here doesn't exist; that
  " is done to ensure the configs we provide are the only ones used
  let args = [
        \ '-s',
        \ '--headless',
        \ 'addons/gut/gut_cmdln.gd',
        \ '-gtest=' .. file_res,
        \ '-gselect=' .. selected_file,
        \ '-gexit',
        \ ]

  if len(a:args) > 1
    let args = args + a:args[1:]
  endif

  return args
endfunction

function! test#gdscript#gut#executable() abort
  " TODO
  return '/Applications/Godot.app/Contents/MacOS/Godot'
endfunction

function! s:format_inner_class(name)
  return '-ginner_class=' .. a:name['namespace'][0]
endfunction

function! s:nearest_test_args(position) abort
  let name = test#base#nearest_test(a:position, s:patterns)
  let args = []

  if len(name['test']) > 0
    let args = add(args, '-gunit_test_name=' .. name['test'][0])
  endif

  if len(name['namespace']) > 0
    let args = add(args, s:format_inner_class(name))
  endif

  return args
endfunction

function! s:nearest_class_args(position) abort
  let name = test#base#nearest_test(a:position, s:patterns)
  if len(name['namespace']) > 0
    return [s:format_inner_class(name)]
  endif
  return []
endfunction

