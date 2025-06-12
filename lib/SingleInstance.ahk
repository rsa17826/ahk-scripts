DetectHiddenWindows(1)
if WinGetList(A_ScriptFullPath).Length > 1 {
  Sleep(1000)
  if WinGetList(A_ScriptFullPath).Length > 1 {
    ToolTip(JSON.stringify(WinGetList(A_ScriptFullPath)))
    Sleep(1000)
    if WinGetList(A_ScriptFullPath).Length > 1 {
      ExitApp()
    }
  }
}
