#Include <AutoThemed>
#Include <Misc>
#SingleInstance Force
#Requires AutoHotkey v2.0
loop files, "C:\Users\User\Documents\real startup\*.*", "fr" {
  if A_LoopFileFullPath.endsWith("close apps that just need bg processes.ahk")
    continue
  if A_LoopFileFullPath.RegExMatch("\.ahk( - Shortcut)?(\.lnk)?$")
    Run("`"" A_LoopFileFullPath "`"")
}
