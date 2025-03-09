#Requires AutoHotkey v1.0

isdark := !RegRead, "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize", "AppsUseLightTheme", 1

uxtheme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
DllCall(DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 135, "ptr"), "int", isdark ? 2:0)
DllCall(DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 136, "ptr"))
