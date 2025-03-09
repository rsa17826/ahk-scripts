#NoTrayIcon
#SingleInstance Force
#Requires AutoHotkey v2.0
ScriptStartModTime := FileGetTime(A_ScriptFullPath)
SetTimer(CheckScriptUpdate, 100, 0x7FFFFFFF) ; 100 ms, highest priority

CheckScriptUpdate() {
  global ScriptStartModTime
  curModTime := FileGetTime(A_ScriptFullPath)
  if (curModTime == ScriptStartModTime)
    return
  SetTimer(CheckScriptUpdate, 0)
  Reload()
  Sleep(300) ; ms
  ExitApp()
}
