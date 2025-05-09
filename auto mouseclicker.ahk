#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon
#Include *i <AutoThemed>

try TraySetIcon("D:\.ico\mouse.ico")

terraria() {
  return WinActive('ahk_exe Terraria.exe') or WinActive("ahk_exe dotnet.exe")
}
#HotIf terraria()
  $RButton::{
    MouseClick("right")
    while GetKeyState("RButton", "P") && terraria() {
      ; Sleep(10)
      MouseClick("right")
    }
    return
  }
#hotif (GetKeyState("ScrollLock", "T"))
{
  $*RButton::{
    while GetKeyState("RButton", "P") && GetKeyState("ScrollLock", "T") {
      if GetKeyState("lButton", "p") {
        MouseClick("Left")
        MouseClick("right")
        ; OutputDebug("r,l")
      } else {
        ; OutputDebug("r")
        MouseClick("right")
      }
      ; Sleep(10)
    }
  }
  $*LButton::{
    while GetKeyState("LButton", "P") && GetKeyState("ScrollLock", "T") {
      if GetKeyState("RButton", "p") {
        MouseClick("Left")
        MouseClick("Right")
        ; OutputDebug("r,l")
      } else {
        ; OutputDebug("l")
        MouseClick("Left")
      }
      ; Sleep(10)
    }
  }
}
#hotif WinActive("ahk_exe PlantsVsZombies.exe") && GetKeyState("z", "p")
  $LButton::{
    MouseClick("left")
    while GetKeyState("LButton", "P") && (GetKeyState("z", "p")) {
      ; Sleep(10)
      MouseClick("left")
    }
    return
  }
#hotif
^Escape::ExitApp()