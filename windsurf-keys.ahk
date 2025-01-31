#Requires AutoHotkey v2.0
/*
Windsurf Dvorak Keyboard Layout Fix
==================================

This script fixes an issue in Windsurf where Ctrl+V paste doesn't work correctly
with Dvorak keyboard layouts. The problem occurs because Windsurf interprets the
'v' key based on its QWERTY position rather than its Dvorak position.

Solution:
- Intercepts Ctrl+V only in Windsurf
- Uses Shift+Insert as an alternative paste method that bypasses keyboard layout issues
- Handles multiline text properly by using a single atomic paste operation
- Temporarily blocks input during paste to prevent modifier key interference

Requirements:
- AutoHotkey v2 (https://www.autohotkey.com/)
- Windsurf application installed
*/

; Set up script options
#SingleInstance Force  ; Only allow one instance of this script to run
SetWorkingDir A_ScriptDir  ; Set working directory to script's directory
InstallKeybdHook  ; Install the keyboard hook
#UseHook true     ; Use the hook for all hotkeys

; Debug mode (change to true to enable debug messages)
global debugMode := true  ; Set to true by default for troubleshooting

; Helper function for debug logging
DebugLog(msg) {
    global debugMode  ; Explicitly declare global access
    if debugMode {
        timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        FileAppend timestamp " - " msg "`n", "windsurf-debug.log"
        ToolTip msg
        SetTimer () => ToolTip(), -3000  ; Hide tooltip after 3 seconds
    }
}

; Handle Ctrl+V in Windsurf
#HotIf WinActive("ahk_exe Windsurf.exe")  ; Only match the exact executable
^v:: {
    activeWin := WinGetTitle("A")
    activeExe := WinGetProcessName("A")
    DebugLog "Ctrl+V pressed - Active Window: " activeWin " (Process: " activeExe ")"
    
    if (activeExe != "Windsurf.exe") {
        DebugLog "Not in Windsurf, passing through"
        Send "^v"
        return
    }
    
    try {
        DebugLog "Attempting clipboard paste in Windsurf..."
        
        ; Block input temporarily to prevent modifier key interference
        BlockInput "On"
        
        ; Release all modifiers to ensure clean state
        Send "{Ctrl Up}{Shift Up}{Alt Up}"
        Sleep 10  ; Brief pause to ensure keys are released
        
        ; Use Shift+Insert which bypasses keyboard layout issues
        ; This performs a single atomic paste operation that works with multiline text
        Send "+{Insert}"
        
        BlockInput "Off"
        DebugLog "Paste operation completed via Shift+Insert"
        
    } catch Error as e {
        BlockInput "Off"  ; Ensure input is re-enabled even if an error occurs
        DebugLog "Paste failed: " e.Message
    }
    return  ; Prevent the original Ctrl+V from being passed through
}

; Handle Ctrl+. in Windsurf - just pass it through
^.:: {
    DebugLog "Ctrl+. detected in Windsurf, passing through"
    SendInput "^."
}

#HotIf  ; End Windsurf-specific hotkeys

; Add a tray menu for debugging
tray := A_TrayMenu
tray.Add "Debug Mode", ToggleDebug
tray.Add  ; Add a separator line
tray.Add "View Debug Log", ViewDebugLog
tray.Add "About", ShowAbout

ToggleDebug(*) {
    global debugMode  ; Explicitly declare global access
    debugMode := !debugMode
    DebugLog(debugMode ? "Debug mode enabled" : "Debug mode disabled")
}

ViewDebugLog(*) {
    if FileExist("windsurf-debug.log")
        Run "notepad.exe windsurf-debug.log"
    else
        MsgBox "No debug log found"
}

ShowAbout(*) {
    MsgBox "Windsurf Dvorak Keyboard Handler`n`nThis script fixes paste operations in Windsurf when using a Dvorak keyboard layout.`n`nCreated with AutoHotkey v2", "About"
}

; Show startup message
DebugLog "Windsurf keyboard handler activated"