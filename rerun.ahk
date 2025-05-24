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

loop files, "C:\Users\" A_UserName "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\*.*", "f" {
  if A_LoopFileFullPath.endsWith("close apps that just need bg processes.ahk")
    continue
  if A_LoopFileFullPath.endsWith("photopea.ahk") {
    Run("`"" A_LoopFileFullPath "`"")
    continue
  }
  if A_LoopFileFullPath.RegExMatch("\.ahk( - Shortcut)?(\.lnk)?$") {
    total += 1
    if isActive(A_LoopFileFullPath)
      active += 1
  }
}
ToolTip(round(active / total * 100) "% active`ntotal: " total ", active: " active)

if total = active {
  Sleep(1000)
  ExitApp()
}
loop files, "C:\Users\" A_UserName "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\*.*", "f" {
  if A_LoopFileFullPath.endsWith("close apps that just need bg processes.ahk")
    continue
  ahksList := WinGetlist("ahk_class AutoHotkey", , ,)
  if A_LoopFileFullPath.RegExMatch("\.ahk( - Shortcut)?(\.lnk)?$") {
    ; print(WinExist(A_LoopFileFullPath), getSymPath(A_LoopFileFullPath), WinExist(getSymPath(A_LoopFileFullPath)))

    if !isActive(A_LoopFileFullPath) {
      Run("`"" A_LoopFileFullPath "`"")
      ; print(getSymPath(A_LoopFileFullPath), A_LoopFileFullPath)
      ; print(ahksList.map((e) {
      ;   return WinGetInfo(e)
      ; }), ahksList.map((e) {
      ;   return StatusBarGetText(e)
      ; }).join("`n").includes(A_LoopFileFullPath), A_LoopFileFullPath)
      if A_LoopFileFullPath.endsWith("photopea.ahk")
        continue

      while 1 {
        if isActive(A_LoopFileFullPath)
          break
        sleep(10)
      }
    }
  }
}
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
