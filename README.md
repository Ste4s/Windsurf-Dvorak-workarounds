# Windsurf-Dvorak-workarounds

Scripts to work around non-US keyboard layout issue in Windsurf IDE.

As referenced by the the [Codeium forums](https://codeium.canny.io/feature-requests/p/changing-the-ctrl-hotkey-that-switches-to-write-mode), here are scripts to work around the issue with non-US keyboard layouts and the Windsurf IDE Cascade panel:

- [init.lua](init.lua): configuration for HammerSpoon (macOS).
- [windsurf-keys.ahk](windsurf-keys.ahk): configuration for AutoHotkey (Windows).

On 14th December, 2024 Michael wrote:

> i use a dvorak keyboard layout, so ctrl + . is the same as paste lol. its the only keybind that it doesnt pick up with being in an alternate keyboard layout. so the effect is that when i go to paste in the chat, it instantly switches between write and chat mode and i lose what i pasted. i cant see anywhere to change this keybind.

My response:

> I've encountered the same keyboard layout issue in Windsurf myself, and have created work-around solutions for both macOS (using Hammerspoon) and Windows (using AutoHotkey). I'm sharing both below - skip to the one that matches your operating system.
>
> This is a common  issue with Electron apps and alternative keyboard layouts. The same issue has been in Evernote for several years. While we continue to advocate for better accessibility support in Electron apps, the solutions below provide immediate workarounds that:
>
> - Make paste work correctly in Windsurf (you may need to modify the hotkey if you're using a non-US keyboard layout other than Dvorak).
> - Don't interfere with paste in other applications
> - Include debugging options to help troubleshoot any issues
> - Can be easily enabled/disabled
>
> While these are workarounds rather than proper fixes, they demonstrate how the community can help each other with creative solutions. I encourage everyone to:
> - Continue reporting accessibility issues to raise awareness
> - Share workarounds like this to help others in the meantime
> - Consider contributing to open-source projects that improve accessibility

# Detailed Installation Instructions

## For macOS Users
Install Hammerspoon:
- Download from https://www.hammerspoon.org/
- Move Hammerspoon.app to your Applications folder
- Launch Hammerspoon and allow accessibility permissions when prompted

Create or edit ~/.hammerspoon/init.lua with the code from [init.lua](init.lua).

Reload Hammerspoon (click the Hammerspoon menubar icon → "Reload Config").

## For Windows Users

Install AutoHotkey v2:
- Download from https://www.autohotkey.com/
- Run the installer
- Choose to install AutoHotkey v2 (not v1.1)

Create a new file named windsurf-keys.ahk with the code from [windsurf-keys.ahk](windsurf-keys.ahk).

Double-click the file to run it (you'll see the AutoHotkey icon in your system tray). Put the AHK script in C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup to have it start when you log in (alternative method: press Win+R to open the Run dialogue and type `shell:startup` to open the Startup folder). 

## Linux

Linux users can almost certainly do the same using an equivalent tool, perhaps something like AutoKey, xbindkeys, KHotkeys, etc (if you build it, please post the code here).

