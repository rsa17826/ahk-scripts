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
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
cp()
py := 0
SetTimer(() {
  global py
  if ProcessExist("python.exe") {
    if py
      return
    py := 1
    SetTimer(cp, -10000, 999)
  } else {
    SetTimer(cp, 0)
    py := 0
  }
}, 100)
cp() {
  while ProcessExist("python.exe")
    try ProcessClose("python.exe")
}
while 1 {
  WinWaitNotActive("ahk_exe vscodium.exe")
  while ProcessExist("python.exe")
    try ProcessClose("python.exe")
  WinWaitActive("ahk_exe vscodium.exe")
}
