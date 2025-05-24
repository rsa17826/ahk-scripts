DetectHiddenWindows(1)
if WinGetList(A_ScriptFullPath).Length > 1 {
  ExitApp()
}
