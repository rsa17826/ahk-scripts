#Requires AutoHotkey v2.0
#SingleInstance Force

#Include *i <AutoThemed>

try TraySetIcon("icon.ico")
SetWorkingDir(A_ScriptDir)
#Include *i <vars>

#Include <Misc>

#Include *i <betterui> ; betterui

#Include *i <textfind> ; FindText, setSpeed, doClick

; #Include *i <CMD> ; CMD - cmd.exe - broken?

loop files "./js globals/*.js" {
  name := path.info(A_LoopFileFullPath).nameandext
  dir := path.info(A_LoopFileFullPath).parentdir
  newname := name.RegExReplace("lib_", "").RegExReplace(" ?\(\d+\)", "").Trim().RegExReplace(" +", " ") ;.RegExReplace("(?:\.user)?\.js$", ".user.js")
  if newname != name {
    FileMove(A_LoopFileFullPath, path.join(dir, newname), 1)
  }
}
