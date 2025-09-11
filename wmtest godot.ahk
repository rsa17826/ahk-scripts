#Requires AutoHotkey v2.0
#SingleInstance Force
#Include *i <AutoThemed>
#Include <betterui>
#Include <SingleInstance>
#Include <admin>
try TraySetIcon("D:\godotgames\foldericon.ico")
global godotpid := 0
send("{MButton up}")
DetectHiddenWindows(1)

kombarh := 30
winwasactive := 0
taskBarSize := 35
ff := 'C:\Users\User\.glzr\glazewm\config.yaml'
disableManage() {
  ; data := F.read(ff)
  ; newdata := data.replace('# - window_class: { equals: "Engine" }`r`n     #   window_title: { equals: "" }', ' - window_class: { equals: "Engine" }`r`n        window_title: { equals: "" }')
  ; if data != newdata {
  ;   F.write(ff, newdata)
  ;   send("+!q")
  ; }
}
enableManage() {
  ; data := F.read(ff)
  ; newdata := data.replace(' - window_class: { equals: "Engine" }`r`n        window_title: { equals: "" }', '# - window_class: { equals: "Engine" }`r`n     #   window_title: { equals: "" }')
  ; if data != newdata {
  ;   F.write(ff, newdata)
  ;   send("+!q")
  ; }
}
enableManage()
while true {
  try {
    ; global godotpid
    if WinExist(" - Godot Engine ahk_class Engine") {
      if !godotpid {
        godotpid := WinExist(" - Godot Engine ahk_class Engine")
        WinMinimize(godotpid)
        WinRestore(godotpid)
      }
      disableManage()
    } else {
      godotpid := 0
      enableManage()
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
        ((A_ScreenHeight - taskBarSize) - kombarh) + 10, godotpid)
      WinMove(0, kombarh, (size / 100 * A_ScreenWidth), ((A_ScreenHeight - taskBarSize) - kombarh), "ahk_exe VSCodium.exe")
    }
  } catch Error as e {
    tooltip(e.Message)
    Sleep(4000)
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
        try WinMinimize(win)
    }
    sleep(10)
  } catch {
    Reload()
  }
  sleep(1000)
}
; joy8::{
;   Print(godotpid , WinExist(godotpid) , WinGetMinMax(godotpid) != -1 , WinGetMinMax("ahk_exe VSCodium.exe") == 0)
; }
#HotIf godotpid and WinExist(godotpid) and WinGetMinMax(godotpid) != -1 and (
  (
    WinActive("ahk_class Engine") || (
      WinExist("ahk_exe VSCodium.exe") and WinActive("ahk_exe VSCodium.exe")
    )
  )
  and (
    WinGetMinMax("ahk_exe VSCodium.exe") == 0 || !WinExist("ahk_exe VSCodium.exe")
  )
)
$F12::{
  try ControlSend("{F12}", , godotpid)
  catch
    reload()
  winwasactive := 0
}
joy8::
$F5::
^$F5::{
  ; if WinActive("ahk_exe VSCodium.exe") {
  ;   send("^s")
  ;   Sleep(100)
  ; }
  try ControlSend("{F5}", , godotpid)
  catch
    reload()
  winwasactive := 0
}
$F6::{
  ; if WinActive("ahk_exe VSCodium.exe") {
  ;   send("^s")
  ;   Sleep(100)
  ; }
  try ControlSend("{F5}", , godotpid)
  catch
    reload()
  winwasactive := 0
}
^$F6::{
  ; if WinActive("ahk_exe VSCodium.exe") {
  ;   send("^s")
  ;   Sleep(100)
  ; }
  try ControlSend("{F6}", , godotpid)
  catch
    reload()
  winwasactive := 0
}
F8::
joy7::
^F8::{
  try ControlSend("{F8}", , godotpid)
  catch
    reload()
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
