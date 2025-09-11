#Requires AutoHotkey v2.0
#Include <AutoThemed>

if !A_IsAdmin {
  args := ""
  for arg in A_Args {
    args .= ' "' . StrReplace(arg, '"', '\"') . '"'
  }
  if A_IsCompiled
    Run('*RunAs "' A_ScriptFullPath . '"' . args, A_WorkingDir)
  else
    Run('*RunAs "' . A_AhkPath . '" "' . A_ScriptFullPath . '"' . args, A_WorkingDir)
  ExitApp()
}
