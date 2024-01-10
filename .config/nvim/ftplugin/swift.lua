vim.bo.commentstring = '//%s'

vim.keymap.set('n', '<leader>pr', function()
  vim.fn.system("osascript", [[
    if application "XCode" is running then
      tell application "XCode"
        activate
        tell application "System Events" to keystroke "r" using {command down}
      end tell
    end
  ]])
end, { buffer = true })
