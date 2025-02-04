--[[
Windsurf Paste Handler
=====================

This script provides a custom paste behavior for the Windsurf application while maintaining
normal paste functionality in all other applications. This is necessary because Windsurf
requires using the Edit → Paste menu item instead of the standard Cmd+v keystroke.

How it works:
1. Watches for Cmd+v keystrokes system-wide
2. If pressed in Windsurf: Triggers the Edit → Paste menu item
3. If pressed in any other app: Passes through normally (acts like a normal Cmd+v)

Requirements:
- Hammerspoon (https://www.hammerspoon.org/)
- Windsurf application installed
]]--

-- Replace this with the actual bundle ID for Windsurf:
local WINDSURF_BUNDLE_ID = "com.exafunction.windsurf"

-- Bind Command+V globally
hs.hotkey.bind({"cmd"}, "v", function()
    local frontApp = hs.application.frontmostApplication()
    local bundleID = frontApp:bundleID()

    if bundleID == WINDSURF_BUNDLE_ID then
        -- Use the menu-based paste (Edit > Paste)
        local success = frontApp:selectMenuItem({"Edit", "Paste"})
        if not success then
            hs.alert.show("Could not find Edit > Paste in Windsurf")
        end
    else
        -- Pass through a normal Cmd+V
        hs.eventtap.keyStroke({"cmd"}, "v", 0)
    end
end)

-- Optional log message or alert to confirm it's loaded
hs.alert.show("Windsurf hotkey-based paste override loaded")