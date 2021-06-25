" ======= config ==========================================

let b:ale_linters = {
    \ 'elixir': ['credo', 'dialyxer', 'mix'],
    \ }

let b:ale_fixers = {
    \ 'elixir': ['mix_format'],
    \ }
let b:ale_fix_on_save = 1


" ======= mappings ========================================

call dhleong#completer().MapNavigation()
