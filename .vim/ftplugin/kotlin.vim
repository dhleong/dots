" don't let the kotlin-vim plugin override our settings
let b:did_ftplugin = 1

setlocal formatoptions+=croql
setlocal comments=s1:/*,mb:*,ex:*/,://

" Set 'comments' to format dashed lists in comments. Behaves just like C.
" (taken from the VIMRUNTIME java files)
setlocal comments& comments^=sO:*\ -,mO:*\ \ ,exO:*/
