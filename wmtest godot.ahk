#Requires AutoHotkey v2.0
#SingleInstance Force
#Include *i <AutoThemed>
#Include <betterui>
#Include <SingleInstance>
#Include <admin>
; try TraySetIcon("D:\.ico\sharex.ico")
global godotpid := 0
send("{MButton up}")
DetectHiddenWindows(1)
kombarh := 30
winwasactive := 0

while true {
  try {
    global godotpid
    if WinExist(" - Godot Engine ahk_class Engine") {
      if !godotpid {
        godotpid := WinExist(" - Godot Engine ahk_class Engine")
      }
    } else {
      godotpid := 0
    }
    if godotpid and WinGetMinMax(godotpid) == -1
      continue
    if (WinExist("ahk_exe VSCodium.exe") and WinExist(" - Godot Engine ahk_class Engine")) {
      if WinGetMinMax("ahk_exe VSCodium.exe") != 0
        continue
      if WinGetMinMax(godotpid) == -1
        continue

      if WinGetMinMax(godotpid) == 1
        WinRestore(godotpid)
      size := 35
      WinMove(
        (size / 100 * A_ScreenWidth) - 10,
        kombarh,
        A_ScreenWidth - (size / 100 * A_ScreenWidth) + 18,
        ((A_ScreenHeight - 50) - kombarh) + 10, godotpid)
      WinMove(0, kombarh, (size / 100 * A_ScreenWidth), ((A_ScreenHeight - 50) - kombarh), "ahk_exe VSCodium.exe")
    }
  } catch Error as e {
    ; MsgBox(e.Message)
    Reload()
  }
  try {
    for win in WinGetList("(DEBUG) ahk_class Engine") {
      if !WinExist(win)
        Reload()
      if !WinGetAlwaysOnTop(win)
        WinSetAlwaysOnTop(0, win)
    }
    if WinActive("(DEBUG) ahk_class Engine") {
      winwasactive := WinActive("(DEBUG) ahk_class Engine")
    }
    if ((WinActive("a") && WinExist("(DEBUG) ahk_class Engine") && !WinActive("(DEBUG) ahk_class Engine") && winwasactive == WinExist("(DEBUG) ahk_class Engine") && WinGetTitle(WinActive("a"))) && WinActive("ahk_exe VSCodium.exe")) {
      for win in WinGetList("(DEBUG) ahk_class Engine")
        try WinKill(win)
    }
    sleep(10)
  } catch {
    Reload()
  }
}
; joy8::{
;   Print(godotpid , WinExist(godotpid) , WinGetMinMax(godotpid) != -1 , WinGetMinMax("ahk_exe VSCodium.exe") == 0)
; }
#HotIf godotpid and WinExist(godotpid) and WinGetMinMax(godotpid) != -1 and (WinActive("ahk_class Engine") || WinActive("ahk_exe VSCodium.exe")) ;and WinGetMinMax("ahk_exe VSCodium.exe") == 0
joy8::
$F5::
^$F5::{
  if WinActive("ahk_exe VSCodium.exe") {
    send("^s")
    Sleep(100)
  }
  ControlSend("{F5}", , godotpid)
  winwasactive := 0
}
$F6::{
  if WinActive("ahk_exe VSCodium.exe") {
    send("^s")
    Sleep(100)
  }
  ControlSend("{F5}", , godotpid)
  winwasactive := 0
}
^$F6::{
  if WinActive("ahk_exe VSCodium.exe") {
    send("^s")
    Sleep(100)
  }
  ControlSend("{F6}", , godotpid)
  winwasactive := 0
}
F8::
joy7::
^F8::{
  ControlSend("{F8}", , godotpid)
  winwasactive := 0
}
#HotIf

; m(*) {
;   send("{MButton down}")
; }
; mu(*) {
;   send("{MButton up}")
; }
MsgBox("fail exit wmtest godot")
; #HotIf WinActive(' - Godot Engine ahk_class Engine')
; LWin::MButton
; ~lwin & LButton::MButton
; ~lwin & RButton::MButton
; LWin::Esc
; {
;   Hotkey("LButton", m, "On")
;   Hotkey("LButton up", mu, "On")
;   print(1)
; }
; $^Shift up::{
;   send("{MButton up}")
;   Hotkey("LButton", m, "off")
;   Hotkey("LButton up", mu, "On")
;   print(0)
; }
