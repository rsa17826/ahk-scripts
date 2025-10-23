#Requires AutoHotkey v2.0
#SingleInstance Force
; #NoTrayIcon
#Include *i <AutoThemed>
#Include <textfind>
#Include <base>
#Include <Misc>
; try TraySetIcon("D:\.ico\clear.ico")

tasks := []
SetTimer(RunTasks(*) {
  for index, task in tasks
    try task.Call()
}, 50)
; close ahk errs on blur

;||ahk_exe AutoHotkeyUX.exe ahk_class #32770 => Could not close the previous instance of
; tasks.push(() {
;   if !WinActive("ahk_exe AutoHotkey64.exe ahk_class #32770")
;     return
;   while WinActive("ahk_exe AutoHotkey64.exe ahk_class #32770") {
;   }
;   sleep(300)
;   if WinExist("ahk_exe AutoHotkey64.exe ahk_class #32770") and not WinActive("ahk_exe AutoHotkey64.exe ahk_class #32770")
;     try WinClose("ahk_exe AutoHotkey64.exe ahk_class #32770")
; })

; close celeste error log
tasks.push(() {
  ; if WinActive("D:\Games\Celeste\errorLog.txt - Notepad++") {
  ;   send("{ctrl down}")
  ;   send("w")
  ;   send("{ctrl up}")
  ;   sleep(200)
  ;   while WinExist("ahk_exe notepad++.exe")
  ;     try WinClose("ahk_exe notepad++.exe")
  ;   run("`"C:\Users\User\Downloads\SmartSteamEmu\SSELauncher.exe`" -appid 504230", "C:\Users\User\Downloads\SmartSteamEmu")
  ; }
  if WinActive("errorLog.txt - VSCodium") {
    send("{ctrl down}")
    send("w")
    send("{ctrl up}")
    sleep(200)
    try WinKill()
    run("`"D:\Games\Celeste\steamclient_loader_x64.exe`"")
  }
})

; f11::WinMaximize("a")

; reload active window
^+NumpadAdd::{
  SendDll("{shift up}{ctrl up}{NumpadAdd up}")
  pp := WinGetProcessPath("A")
  WinClose("a")
  Run("`"" pp "`"", pp.RegExReplace("\\[^\\]+$", ""))
  ; active := WinActive("a")
  ; exe := WinGetProcessPath(active)
  ; try WinClose(active)
  ; try WinKill(active)
  ; WinWaitClose(active)
  ; Run(exe, exe.RegExReplace("\\[^\\]+$", ""), "low")
  ; MsgBox(exe)
  ; while !WinExist("ahk_exe " exe, , 3)
  ;   Run(exe, exe.RegExReplace("\\[^\\]+$", ""), "low")
}
; tasks.push(() {
;   if WinActive("ahk_exe dotnet.exe")
;     if GetKeyState("d", "p") || GetKeyState("a", "p") {
;       ; if GetKeyState("w", "p") {
;       ;   send("{w up}")
;       ;   Sleep(100)
;       ; }
;       send("{w down}")
;       Sleep(100)
;       send("{w up}")
;       if !WinActive("ahk_exe dotnet.exe")
;         send("{w up}")
;     } else {
;       if GetKeyState("w", "p") {
;         send("{w up}")
;       }
;     }
; })
#HotIf WinActive("ahk_exe dotnet.exe")
; ~a::SendDll("w")

; ~d::SendDll("w")
^g::{
  while GetKeyState("g", "p") {
  }
  while !GetKeyState("g", "p") {
    SendDll("8")
    Sleep(100)
    send("{lbutton}")
    Sleep(100)
    SendDll("3")
    Sleep(100)
    Send("{lbutton down}")
    Sleep(1000)
    SendDll("{space down}")
    Sleep(400)
    SendDll("{space up}")
    Send("{lbutton up}``")
    Sleep(100)
  }
  while GetKeyState("g", "p") {
  }
}

; +RButton::u

; #HotIf WinActive("ahk_exe javaw.exe")
;   ; `::f24

;   #Include <AutoHotInterception\AutoHotInterception>
;   isFirstSpaceDown := 1
;   active := 0
;   AHI := AutoHotInterception()
;   kb() {
;     return AHI.GetDeviceIdFromHandle(0, EnvGet("INTERCEPTON_MAIN_KEYBOARD_HANDLE"))
;   }
;   AHI.SubscribeKey(kb(), GetKeySC("space"), 1, (down, a*) {
;     if WinActive("ahk_exe javaw.exe") {
;       TIME := 60
;       global isFirstSpaceDown, active
;       if down {
;         if !isFirstSpaceDown
;           return
;         if active
;           return
;         isFirstSpaceDown := 0
;         AHI.SendKeyEvent(kb(), GetKeySC("space"), 1)
;         Sleep(TIME)
;         AHI.SendKeyEvent(kb(), GetKeySC("space"), 0)
;         Sleep(TIME)
;         AHI.SendKeyEvent(kb(), GetKeySC("space"), 1)
;         Sleep(TIME)
;         active := 0
;       } else {
;         isFirstSpaceDown := 1
;         AHI.SendKeyEvent(kb(), GetKeySC("space"), 0)
;         Sleep(TIME)
;         AHI.SendKeyEvent(kb(), GetKeySC("space"), 1)
;         Sleep(TIME)
;         AHI.SendKeyEvent(kb(), GetKeySC("space"), 0)
;         Sleep(TIME)
;         AHI.SendKeyEvent(kb(), GetKeySC("space"), 1)
;         Sleep(TIME)
;         AHI.SendKeyEvent(kb(), GetKeySC("space"), 0)
;         Sleep(TIME)
;         active := 0
;       }
;     } else {
;       AHI.SendKeyEvent(kb(), GetKeySC("space"), down)
;     }
;   })
;   ~*$w::{
;     if (!GetKeyState("ctrl", "p")) {
;       send("{Ctrl}")
;     }
;   }
;   ; $*Space::{
;   ;   SendDll("{Space}", 0, 70)
;   ;   Sleep(70)
;   ;   SendDll("{Space down}", 0, 70)
;   ;   while GetKeyState("space", "p") {

;   ;   }
;   ;   SendDll("{Space up}", 0, 70)
;   ; }

#hotif
; #hotif ProcessExist("Godot_v4.5-stable_win64.exe") ; and WinActive('ahk_class Engine')
^+!F5::
{
  ; MsgBox(WinGetInfo('a'))
  ; MsgBox(ProcessExist("Godot_v4.5-stable_win64.exe"))
  while ProcessExist("Godot_v4.5-stable_win64.exe") {
    ProcessClose("Godot_v4.5-stable_win64.exe")
  }
  run("D:\programs\godot\Godot_v4.5-stable_win64.exe --path D:/godotgames/vex --editor")
  ; run("D:\programs\godot\Godot_v4.5-stable_win64.exe")
  ; run("D:\programs\godot\gvm.exe")
}
^!t::{
  if WinActive("ahk_exe explorer.exe ahk_class CabinetWClass")
    SendDll("{alt up}^lcmd{enter}")
  else
    Run("cmd")
}
