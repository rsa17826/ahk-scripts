; @name format includes
; @regex ^(#\w+ .*\n)\n+(#)
; @flags gim
; @untilfail
; @replace $1$2
; @endregex
; @regex ^#include .*(?=\n\w)
; @flags gim
; @replace $&
;
; @endregex

; @name remove ai comments
; @regex \n *(;) [A-Z].*
; @replace
; @endregex
; @regex  (;) [A-Z].*
; @replace
; @endregex

; @name max newlines
; @regex ^\n{3,}
; @flags gim
; @full
; @replace
;
;
; @endregex

; @name seperate different regexes
; @regex ( *)(;.*)\n(\1; @name)
; @full
; @replace $1$2
;
; $3
; @endregex

#Requires AutoHotkey v2.0
#SingleInstance Force

; must include
#Include <AutoThemed>
; #include <vars>
; #Include <base>
; #Include <Misc> ; print, range, swap, ToString, RegExMatchAll, Highlight, MouseTip, WindowFromPoint, ConvertWinPos, WinGetInfo, GetCaretPos, IntersectRect

SetWorkingDir(A_ScriptDir)
DetectHiddenWindows(1)

try WinClose("python http server")
if !a_args.has(1) {
  return
}

try DirDelete(a_args[1] "\js globals")
DirCopy("js globals", a_args[1] '\js globals', 1)

Run("cmd /c `"title python http server & python -m http.server --cgi`"", a_args[1], "hide")
run("http://127.0.0.1:8000")