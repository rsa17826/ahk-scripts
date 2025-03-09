#Requires AutoHotkey v2.0
#include <base>
#Include <misc>

errs := []
sucesses := []
configfile := "install locations.json"
paths := json.parse(f.read(configfile, "install locations"))
if FileExist(configfile) {
  if MsgBox("reinstall to`n" paths.join("`n"), , 1) = "ok" {
    for loc in paths
      try {
        filecopy(A_ScriptDir "\__mod loader.ahk", loc, 1)
        sucesses.Push(loc)
      }
      catch {
        errs.push(loc)
      }
    print(sucesses)
    print(errs)
    if sucesses.Length
      MsgBox("sucessfully reinstalled " sucesses.length " files to`n`n" paths.join("`n"))
    if errs.Length
      MsgBox("failed to reinstall " errs.Length " files to`n`n" errs.join("`n"))
  }
}
else
  MsgBox("file not found at \" configfile)