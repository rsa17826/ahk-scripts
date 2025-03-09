#Requires AutoHotkey v2.0
#SingleInstance Force

; must include
SetWorkingDir(A_ScriptDir)
#Include *i <AutoThemed>
#Include <vars>

#Include <base> ; Array as base, Map as base, String as base, File as F, JSON

#Include <Misc> ; print, range, swap, ToString, RegExMatchAll, Highlight, MouseTip, WindowFromPoint, ConvertWinPos, WinGetInfo, GetCaretPos, IntersectRect
#Include <toast> ; toast - show msgs at Bottom of screen to alert user

#Include <betterui> ; betterui

#Include <desktop switcher>

#Include <textfind> ; FindText, setSpeed, doClick

; #Include <protocol> ; PROTO - listen for web protocols - requires admin

#Include <TTS> ; TTS - text to speech

settings := json.parse(f.read("settings.json"), , 0)
CreatorName := settings.CreatorName
basepath := path.join(settings.celestePath, "mods")
modname := A_Args.has(1) ? A_Args[1] : input("enter the mods name", "")
if !modname
  return
DirCreate(path.join(basepath, modname, "Maps", CreatorName, modname))
DirCreate(path.join(basepath, modname, "Graphics\Atlases\Endscreens", CreatorName, modname))
RunWait('"' A_AhkPath '"' " `"" A_ScriptDir "/regen level names.ahk`" `"" modname "`"")
if settings.HasProp("makelinks") and settings.makelinks {
  try {
    RunWait('cmd /c mklink /D "' path.join(basepath, modname, "END LEVEL IMAGES") '" "' path.join(basepath, modname, "Graphics\Atlases\Endscreens", CreatorName, modname) '"', , "hide")
    if !DirExist(path.join(basepath, modname, "END LEVEL IMAGES"))
      throw(Error(""))
    RunWait('cmd /c mklink /D "' path.join(basepath, modname, "LEVEL FILES") '" "' path.join(basepath, modname, "Maps", CreatorName, modname) '"', , "hide")
    if !DirExist(path.join(basepath, modname, "LEVEL FILES"))
      throw(Error(""))
  } catch Error as e {
    Print(e)
    if !A_IsAdmin {
      args := ' "' . StrReplace(modname, '"', '\"') . '"'
      Run('*RunAs "' . A_AhkPath . '" "' . A_ScriptFullPath . '"' . args)
      ExitApp()
    } else {
      throw(e)
    }
  }
}
; f.write(path.join(basepath, "everest.yaml"))
if settings.HasProp("openLevelFolderOnNewMod") and !settings.openLevelFolderOnNewMod
  return
if settings.HasProp("makelinks") and settings.makelinks
  run(path.join(basepath, modname, "LEVEL FILES"))
else
  run(path.join(basepath, modname, "Maps", creatorName, modname))