#Include <AutoThemed>
#Include <Misc>
#Include <CMD>
#NoTrayIcon
#SingleInstance Force
#Requires AutoHotkey v2.0
DetectHiddenWindows(1)
DetectHiddenText(1)
total := 0
active := 0
sympathCache := cache()
oneshots := [
  "photopea.ahk",
  "random cursor scheme.ahk - Shortcut",
  "disable screenreader warning.ahk",
  "yasb.ahk",
]
; run("C:\Users\User\Desktop\glazewm\target\release\glazewm.exe")
ignores := [
  "close apps that just need bg processes.ahk",
]
runRequired := []
loop files, "C:\Users\" A_UserName "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\*.*", "f" {
  if A_LoopFileFullPath.RegExMatch("\.ahk( - Shortcut)?(\.lnk)?$") {
    b := 0
    for a in ignores
      if A_LoopFileFullPath.endsWith(a) or A_LoopFileFullPath.endsWith(a '.lnk') {
        b := 1
        break
      }
    for a in oneshots
      if A_LoopFileFullPath.endsWith(a) or A_LoopFileFullPath.endsWith(a '.lnk') {
        Run("`"" A_LoopFileFullPath "`"")
        b := 1
        break
      }
    if b
      continue
    total += 1
    if isActive(A_LoopFileFullPath)
      active += 1
    else {
      runRequired.push(A_LoopFileFullPath)
      ; MsgBox(A_LoopFileFullPath)
    }
  }
}
ToolTip(round((total - runRequired.Length) / total * 100) "% active`ntotal: " total ", active: " active)
if !runRequired.Length {
  Sleep(1000)
  ExitApp()
}
for filepath in runRequired {
  ; ahksList := WinGetlist("ahk_class AutoHotkey", , ,)
  if filepath.RegExMatch("\.ahk( - Shortcut)?(\.lnk)?$") {
    if !isActive(filepath) {
      Run("`"" filepath "`"")
      for a in oneshots
        if filepath.endsWith(a)
          continue 2

      while 1 {
        ToolTip("Waiting for " filepath)
        if isActive(filepath)
          break
        sleep(10)
      }
    }
  }
}
Sleep(1000)
reload()
isActive(path) {
  lnkPath := path
  try FileGetShortcut(path, &lnkPath)
  catch
    lnkPath := path
  print(A_LoopFileFullPath, lnkPath, getSymPath(path), WinExist(path) || WinExist(lnkPath) || WinExist(getSymPath(path)))
  return WinExist(path) || WinExist(lnkPath) || WinExist(getSymPath(path))
}
getSymPath(p) {
  if sympathCache.has(p)
    return sympathCache.get()

  startDir := path.info(p).parentdir
  filePath := cmd.run('dir /s "' p '"').RegExMatch("<SYMLINK>.*?\[(.*)\]")[1]
  return sympathCache.set(filePath ? path.info(path.join(startDir, cmd.run('dir /s "' p '"').RegExMatch("<SYMLINK>.*?\[(.*)\]")[1])).abspath.replace("/", "\") : p)
}
