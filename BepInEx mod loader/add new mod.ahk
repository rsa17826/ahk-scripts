#Requires AutoHotkey v2.0
#SingleInstance Force
#Include *i <AutoThemed>
#Include <Misc>
#Include <base>


SetWorkingDir(A_ScriptDir)
configfile := "install locations.json"
paths := JSON.parse(f.read(configfile, "[]"))
; exe := FileSelect(0, A_ScriptDir, , "*.exe")
gameFile := FileSelect(0, "D:\Games\Bopl.Battle.Build.14513341", , "*.exe")
if !gameFile
  return
gameDir := gameFile.RegExMatch("^.*\\")[0]
gameName := gameFile.RegExMatch("\\([^\\]+)\.exe$")[1]
f.write(joinpath(gamedir, gamename " mod loader config.json"), JSON.stringify({ gamefile: gameFile }))
newfile := gameDir gameName " mod loader.ahk"

paths.push(newfile)
paths := paths.Unique()

f.write(configfile, JSON.stringify(paths))
FileCopy(A_ScriptDir "\__mod loader.ahk", newfile, 1)
if FileExist(newfile) {
  if MsgBox("installed sucessfully`nopen it now?", "BepInEx mod loader installer", 4) = "yes"
    run("`"" newfile "`"", gameDir)
}
else {
  if MsgBox("failed`ntry again?", "BepInEx mod loader installer", 4) = "yes"
    Reload()
}

joinpath(paths*) {
  fullpath := ""
  for path in paths {
    fullpath .= path
      .RegExReplace("\\$", "")
      .RegExReplace("^\\", "") . "\"
  }
  return fullpath.RegExReplace("\\$", "")
}