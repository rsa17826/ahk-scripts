#Requires AutoHotkey v2.0
#SingleInstance Force

#Include *i <AutoThemed>

try TraySetIcon("icon.ico")
SetWorkingDir(A_ScriptDir)
#Include *i <vars>

#Include <Misc>

#Include *i <betterui> ; betterui

#Include *i <textfind> ; FindText, setSpeed, doClick

; #Include *i <CMD> ; CMD - cmd.exe - broken?

; ChangeCursorScheme("some dragons")
remove := [
  'some dragons',
  'rec11',
  'main'
]
changeCursorScheme(listCursorSchemes().filter(e => !remove.includes(e)).random())