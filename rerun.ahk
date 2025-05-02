#Include <AutoThemed>
#Include <Misc>
#Include <CMD>
#NoTrayIcon
#SingleInstance Force
#Requires AutoHotkey v2.0
DetectHiddenWindows(1)
DetectHiddenText(1)

loop files, "C:\Users\" A_UserName "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\*.*", "f" {
  if A_LoopFileFullPath.endsWith("close apps that just need bg processes.ahk")
    continue
  ahksList := WinGetlist("ahk_class AutoHotkey", , ,)
  if A_LoopFileFullPath.RegExMatch("\.ahk( - Shortcut)?(\.lnk)?$") {
    ; print(WinExist(A_LoopFileFullPath), getSymPath(A_LoopFileFullPath), WinExist(getSymPath(A_LoopFileFullPath)))
    lnkPath := A_LoopFileFullPath
    try FileGetShortcut(A_LoopFileFullPath, &lnkPath)
    catch
      lnkPath := A_LoopFileFullPath
    if !WinExist(A_LoopFileFullPath) && !WinExist(getSymPath(A_LoopFileFullPath)) && !WinExist(lnkPath) {
      Run("`"" A_LoopFileFullPath "`"")
      ; print(getSymPath(A_LoopFileFullPath), A_LoopFileFullPath)
      ; print(ahksList.map((e) {
      ;   return WinGetInfo(e)
      ; }), ahksList.map((e) {
      ;   return StatusBarGetText(e)
      ; }).join("`n").includes(A_LoopFileFullPath), A_LoopFileFullPath)
      while 1 {
        if winexist(A_LoopFileFullPath) or WinExist(getSymPath(A_LoopFileFullPath)) or WinExist(lnkPath)
          break
        sleep(10)
      }
    }
  }
}

getSymPath(p) {
  startDir := path.info(p).parentdir
  ; print(cmd.run('dir /s "' p '"'))
  filePath := cmd.run('dir /s "' p '"').RegExMatch("<SYMLINK>.*?\[(.*)\]")[1]
  print("SYM", p, filePath, path.info(path.join(startDir, filePath)).abspath.replace("/", "\"))
  return filePath ? path.info(path.join(startDir, cmd.run('dir /s "' p '"').RegExMatch("<SYMLINK>.*?\[(.*)\]")[1])).abspath.replace("/", "\") : p
}
