set gfn=Inconsolata:h17

set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Tex_MultipleCompileFormats="pdf,dvi"

let g:Tex_IgnoredWarnings="Underfull\n".
\"Overfull\n".
\"specifier changed to\n".
\"You have requested\n".
\"Missing number, treated as zero.\n".
\"There were undefined references\n".
\"Citation %.%# undefined\n".
\"Unused global option"
let g:Tex_IgnoreLevel=8

let g:Tex_FoldedEnvironments=",algorithm"

