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

Debug Mode:
To enable debug logging, run in the Hammerspoon console:
> hs.logger.setGlobalLogLevel('debug')
]]--

-- Create a logger
local log = hs.logger.new('windsurf-paste', 'info')

-- Constants
local WINDSURF_BUNDLE_ID = "com.exafunction.windsurf"
local PASTE_MENU_ITEMS = {"Edit", "Paste"}

-- Create an event tap that only watches for keyboard events with Command modifier
cmdV = hs.eventtap.new(
    {hs.eventtap.event.types.flagsChanged, hs.eventtap.event.types.keyDown},
    function(event)
        -- Only process keyDown events when Command is held
        if event:getType() == hs.eventtap.event.types.keyDown and
           event:getFlags():containExactly({'cmd'}) and
           event:getCharacters() == "v" then
            
            -- Get information about the active application
            local frontApp = hs.application.frontmostApplication()
            local appName = frontApp:name()
            local bundleID = frontApp:bundleID()
            
            log.df("Paste detected in %s (Bundle ID: %s)", appName, bundleID or "nil")
            
            -- Special handling for Windsurf
            if bundleID == WINDSURF_BUNDLE_ID then
                -- Use the menu item instead of the keystroke
                local success = frontApp:selectMenuItem(PASTE_MENU_ITEMS)
                if not success then
                    hs.alert.show("Hammerspoon cmdV (see ~/.hammerspoon/init.lua): Could not find Edit > Paste in Windsurf")
                    log.w("Failed to find Edit > Paste menu item in Windsurf")
                else
                    log.d("Successfully triggered paste via menu in Windsurf")
                end
                return true  -- Prevent the original Cmd+v from being processed
            end
        end
        
        return false  -- Pass through all other keystrokes normally
    end
)

-- Start watching for keystrokes
cmdV:start()
log.i("Windsurf paste handler activated")
