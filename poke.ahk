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

$*z::c
$*shift::{
  Send("{z down}")
  Sleep(30)
  Send("{z up}")
}
$*shift up::{
  Send("{z up}")
}
$*c::z