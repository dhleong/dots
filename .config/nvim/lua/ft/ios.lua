local M = {}

function M.run_in_xcode()
  vim.fn.system("osascript", [[
    if application "XCode" is running then
      tell application "XCode"
        activate
        tell application "System Events" to keystroke "r" using {command down}
      end tell
    end
  ]])
end

return M
