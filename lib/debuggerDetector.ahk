; #Requires AutoHotkey v2.0
; #SingleInstance Force
; A_DebuggerActive := unset
; #Include <Misc>
; test := RunRet("powershell wget 127.0.0.1:9002", "", "hide", , 2000)
; if (test.includes("Unable to connect to the remote server")) {
;   A_DebuggerActive := 0
; } else {
;   A_DebuggerActive := 1
; }
; MsgBox(A_DebuggerActive)
; ; MsgBox(test)
; ; if (WinExist("ahk_pid " . pid)) {
; ;   winkill("ahk_pid " pid)
; ;   A_DebuggerActive := 1
; ; } else {
; ;   A_DebuggerActive := 0
; ; }
