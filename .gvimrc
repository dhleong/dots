
let _fontName='Inconsolata+for+Powerline.otf'

set gfn=Inconsolata\ for\ Powerline:h17,Inconsolata:h17
if !empty(glob("~/Library/Fonts/" . _fontName)) " could check more places, but....
    " only enable powerline if available
    let g:airline_powerline_fonts = 1
endif

" in a graphical environment, let us y&p directly with system
set clipboard=unnamed

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

