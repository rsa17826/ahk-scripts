#Requires AutoHotkey v2.0
#Include <AutoThemed>

if !A_IsAdmin {
  args := ""
  for arg in A_Args {
    args .= ' "' . StrReplace(arg, '"', '\"') . '"'
  }
  Run('*RunAs "' . A_AhkPath . '" "' . A_ScriptFullPath . '"' . args, A_WorkingDir)
  ExitApp()
}
