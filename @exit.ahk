#Requires AutoHotkey v2.0
#SingleInstance Force
; #NoTrayIcon
#Include <AutoThemed>
#include <vars>
#include <admin>
#Include <base> ; Array as base, Map as base, String as base, File as F, JSON

#Include <Misc> ; print, range, swap, ToString, RegExMatchAll, Highlight, MouseTip, WindowFromPoint, ConvertWinPos, WinGetInfo, GetCaretPos, IntersectRect

SetWorkingDir(A_ScriptDir)
DetectHiddenWindows(true)
oid := WinGetlist("ahk_class AutoHotkey", , ,)
aid := Array()
id := oid.Length
for v in oid {
  aid.Push(v)
}
loop aid.Length ; retrieves the  ID of the specified windows, one at a time
{
  this_ID := aid[A_Index]
  try {
    title := WinGetTitle("ahk_id " this_ID)
    SkriptPath := RegExReplace(title, " - AutoHotkey v" A_AhkVersion)
  }
  if InStr(SkriptPath, A_ScriptFullPath)
    continue
  if A_Args.has(1) and A_Args[1] == SkriptPath
    continue
  try {
    WinKill(SkriptPath " ahk_class AutoHotkey")
  }
}
ExitApp()