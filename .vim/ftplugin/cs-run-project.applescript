
if application "Visual Studio" is running then
    activate application "Visual Studio"
    tell application "System Events" to keystroke "b" using command down
    tell application "System Events" to keystroke "r" using command down

    activate application "MacVim"
else
    activate application "Unity"
    tell application "System Events" to keystroke "p" using command down
end if
