
function! dhleong#text#GetUnicodePairs()
    " copy the output of the ascii command
    redir => raw
        ascii
    redir END

    " strip out the hex part and parse to int
    let match = matchlist(raw, 'Hex \(.*\),')
    let hex = match[1]
    let s = str2nr(hex, 16)

    " source: http://www.russellcottrell.com/greek/utilities/surrogatepaircalculator.htm
    if (s >= 0x10000 && s <= 0x10FFFF)
        let hi = float2nr(floor((s - 0x10000) / 0x400) + 0xD800)
        let lo = float2nr(((s - 0x10000) % 0x400) + 0xDC00)
        let pairs = printf('\u%x\u%x', hi, lo)

        " go ahead and copy it to the clipboard
        let @* = pairs
    else
        let pairs = '(none)'
    endif

    " clear old output and echo new
    redraw!
    echo raw[1:] . ', Pairs ' . pairs
endfunction

function! dhleong#text#TryCleanWhitespace()
    " minus 1 to be zero-indexed;
    " minus another because we're in insert mode
    let col = col('.') - 2
    let line = getline('.')[:col]
    let whitespace = len(matchstr(line, '\s*$'))
    if len(line) == whitespace
        let prefix = ''
    else
        let prefix = repeat("\<BS>", whitespace)
    endif

    return prefix . "\<Enter>"
endfunction

