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
