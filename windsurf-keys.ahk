#Requires AutoHotkey v2.0
/*
Windsurf Paste Handler for Windows
=================================

This script provides a custom paste behavior for the Windsurf application while maintaining
normal paste functionality in all other applications. This is necessary because Windsurf
may have issues with standard Ctrl+V paste in certain keyboard layouts.

How it works:
1. Watches for Ctrl+V keystrokes system-wide
2. If pressed in Windsurf: Triggers the Edit → Paste menu item
3. If pressed in any other app: Passes through normally (acts like a normal Ctrl+V)

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
debugMode := true  ; Set to true by default for troubleshooting

; Helper function for debug logging
DebugLog(msg) {
    if debugMode {
        timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        FileAppend timestamp " - " msg "`n", "windsurf-debug.log"
        ToolTip msg
        SetTimer () => ToolTip(), -3000  ; Hide tooltip after 3 seconds
    }
}

; Handle Ctrl+V in Windsurf
#HotIf WinActive("ahk_exe Windsurf.exe") or WinActive("Windsurf")
^v:: {
    activeWin := WinGetTitle("A")
    DebugLog "Ctrl+V pressed - Active Window: " activeWin
    
    ; Try to paste using clipboard
    try {
        DebugLog "Attempting clipboard paste..."
        savedClip := ClipboardAll()  ; Save current clipboard
        clipText := A_Clipboard      ; Get text content
        DebugLog "Clipboard content length: " StrLen(clipText)
        
        ; Send the paste command
        SendInput "^v"
        Sleep 100
        
        ; Restore original clipboard
        A_Clipboard := savedClip
        savedClip := ""
        DebugLog "Paste operation completed"
    } catch Error as e {
        DebugLog "Paste failed: " e.Message
    }
}

; Handle Ctrl+. in Windsurf - just pass it through
^.:: {
    DebugLog "Ctrl+. detected in Windsurf, passing through"
    SendInput "^."
}

#HotIf  ; End context-sensitive hotkeys

; Add a tray menu
tray := A_TrayMenu
tray.Add "Debug Mode", ToggleDebug
tray.Add  ; Add a separator line
tray.Add "View Debug Log", ViewDebugLog
tray.Add "About", ShowAbout

ToggleDebug(*) {
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
    MsgBox "Windsurf Keyboard Handler`n`nThis script provides custom keyboard handling for the Windsurf application.`n`nCreated with AutoHotkey v2", "About"
}

; Show startup message
DebugLog "Windsurf keyboard handler activated"