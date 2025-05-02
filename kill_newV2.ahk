#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon
#Include *i <AutoThemed>
#Include <base>
DetectHiddenWindows(true)

try TraySetIcon("D:\.ico\x ahk key.ico")
^+#!Escape::{
  RunWait("C:\Users\User\Desktop\non constant ahk scripts\@exit.ahk `"" A_ScriptFullPath "`"")
  while WinGetlist("ahk_class AutoHotkey", , ,).map(e => RegExReplace(WinGetTitle("ahk_id " e), " - AutoHotkey v" A_AhkVersion)).includes("C:\Users\User\Desktop\non constant ahk scripts\@exit.ahk") {
  }
  Sleep(1000)
  print(WinGetlist("ahk_class AutoHotkey", , ,))
  while WinGetlist("ahk_class AutoHotkey", , ,).map(e => RegExReplace(WinGetTitle("ahk_id " e), " - AutoHotkey v" A_AhkVersion)).includes("C:\Users\User\Desktop\non constant ahk scripts\@exit.ahk") {
  }
  run("C:\Users\User\Desktop\non constant ahk scripts\rerun.ahk")
}
#!Escape::RunWait("C:\Users\User\Desktop\non constant ahk scripts\@exit.ahk `"" A_ScriptFullPath "`"")

; killall() {
;   DetectHiddenWindows(true)
;   oid := WinGetlist("ahk_class AutoHotkey", , ,)
;   aid := Array()
;   id := oid.Length
;   for v in oid {
;     aid.Push(v)
;   }
;   loop aid.Length ; retrieves the  ID of the specified windows, one at a time
;   {
;     this_ID := aid[A_Index]
;     try {
;       title := WinGetTitle("ahk_id " this_ID)
;       SkriptPath := RegExReplace(title, " - AutoHotkey v" A_AhkVersion)
;     }
;     if InStr(SkriptPath, A_ScriptFullPath)
;       continue
;     try {
;       WinClose(SkriptPath " ahk_class AutoHotkey")
;     }
;   }

; }
; ; AHKPanic(Kill := 0, Pause := 0, Suspend := 0, SelfToo := 0) {
; ;   DetectHiddenWindows(true)
; ;   wins := WinGetList("ahk_class AutoHotkey")
; ;   aIDList := Array()
; ;   IDList := oIDList.Length
; ;   For v in oIDList
; ;   {
; ;     aIDList.Push(v)
; ;   }
; ;   for id in aIDList
; ;     WinClose("ahk_id " ID)
; ;   Loop aIDList.Length
; ;   {
; ;     ID := aIDList[A_Index]
; ;     try ATitle := WinGetTitle("ahk_id " ID)
; ;     if !ATitle
; ;       continue
; ;     if id
; ;       if !InStr(ATitle, A_ScriptFullPath)
; ;       {
; ;         If Suspend
; ;           PostMessage(0x111, 65305, , , "ahk_id " ID)  ; Suspend.
; ;         If Pause
; ;           PostMessage(0x111, 65306, , , "ahk_id " ID)  ; Pause.
; ;         If Kill
; ;           WinClose("ahk_id " ID) ;kill
; ;       }
; ;   }
; ;   If SelfToo
; ;   {
; ;     If Suspend
; ;       Suspernd(-1)  ; Suspend.
; ;     If Pause
; ;       Pause(-1)  ; Pause.
; ;     If Kill
; ;       ExitApp()
; ;   }
; ; }
