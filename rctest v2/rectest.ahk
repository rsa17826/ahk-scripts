#SingleInstance Force
#Requires Autohotkey v2.0
#Include <AutoThemed>
try TraySetIcon("icon.ico")
SetWorkingDir(A_ScriptDir)
#Include <Misc>
#Include <darkgui>
DirCreate("temp")
SetWorkingDir(A_ScriptDir)

includeWindowInFileName := false
separateFolderesPerWindowTitle := true
separateFolderesPerWindowExe := false
folder := 'saved captures'
maxVids := 60
; 'ahk_exe explorer.exe',
; 'ahk_exe VSCodium.exe'
windows := []

clearTemp()

saving := 0
DirCreate(folder)
EnvSet('path', EnvGet('path') ';' A_ScriptDir)
; envset("path", 'C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Users\User\Desktop\ALL ahk scripts\rctest v2')
DetectHiddenWindows(1)
g := darkgui('AlwaysOnTop +ToolWindow -Caption')
grecordState := g.AddText('x5 w70')
gwinCount := g.AddText('x75 y5 w100')
gfileCount := g.AddText('x75 y20 w100')
gticker := g.AddText('x5 w100 y20')
; g.Show("x0 y30 NoActivate w180 h40")
; stopCapture()
startCapture()

stopCapture() {
  grecordState.text := 'stopping...'
  while WinExist("RCTest - Capture")
    try WinKill("RCTest - Capture")
  grecordState.text := 'STOPPED'
  ; stopping.text := 'Capturing...'
}
startCapture() {
  stopCapture()
  clearTemp()
  run('powershell -File capture.ps1', , 'hide')
  grecordState.text := 'recording'
}
gettitle() {
  exe := StrReplace(WinGetProcessName("a"), ".exe", "")
  wt := WinGetTitle("a")
  if instr(wt, exe)
    return wt
  else
    return wt . " - " . exe
}

savevideo() {
  global saving
  saving := 1
  title := FormatTime(A_Now, "HH mm MM dd yyyy")
  if includeWindowInFileName
    title := gettitle() ' - ' title
  if separateFolderesPerWindowTitle
    title := gettitle() '\' title
  if separateFolderesPerWindowExe
    title := exe := StrReplace(WinGetProcessName("a"), ".exe", "") '\' title
  videoOutPath := path.join(folder, title.Trim("\/ "))
  try DirCreate(path.parentdir(videoOutPath))
  arr := []
  lastTime := 0
  lastFile := ''
  stopCapture()
  grecordState.text := 'SAVING VIDEO'
  Sleep(1000)
  loop files 'temp/*.mkv', 'F' {
    if FileGetTime(A_LoopFileFullPath) > lastTime {
      lastTime := FileGetTime(A_LoopFileFullPath)
      lastFile := A_LoopFileName.replace("temp", '').replace(".mkv", '')
    }
  }
  i := mod(lastFile + 1, maxVids)
  text := ''
  for ii in Range(0, maxVids) {
    ; print(ii, i, pad(mod(i + ii, maxVids + 1), 3))
    if FileExist("temp/temp" pad(mod(i + ii, maxVids + 1), 3) ".mkv")
      text .= "file 'temp" pad(mod(i + ii, maxVids + 1), 3) ".mkv`n"
  }
  ; print(lastFile, lastTime, i, text)
  ; arr := arr.sort((a, s) {
  ;   return FileGetTime('temp/' s) > FileGetTime('temp/' a)
  ; })
  ; print(arr)

  ; arr.pop()
  f.writeLine(path.join(A_ScriptDir, './logs/') '/' A_ScriptName '.ans', fg(25) "---------------------------------------------------`n" fg() RTrim(text, "`n"))
  ; Print()
  F.write('temp/file_list.txt', RTrim(text, "`n"))
  ; F.write('temp/file_list.txt', arr.map(e => "file '" e "'").join("`n"))
  try FileDelete("temp/joined.mkv")
  RunWait('cmd /c "ffmpeg.exe -f concat -safe 0 -i "temp/file_list.txt" -c copy "temp/joined.mkv" -y"', , 'hide')
  while !FileExist("temp/joined.mkv") {
    Sleep(100)
  }
  while !FileExist("temp/joined.mkv") {
    Sleep(100)
  }
  try FileMove("temp/joined.mkv", videoOutPath . ".mkv")
  catch {
    title .= ' RANDOM ' Random() A_TickCount
    MsgBox(title)
    FileMove("temp/joined.mkv", videoOutPath . ".mkv")
  }
  ; SetTimer(() {
  ;   try FileDelete("temp/file_list.txt")
  ; }, -1000)
  try FileDelete('./counter')
  startCapture()
  saving := 0
  return videoOutPath . ".mkv"
}

pad(num, count) {
  while StrLen(num) < count {
    num := "0" num
  }
  return num

}

^+F9::{
  videopath := savevideo()
  filename := path.info(videopath).name
  RunWait(A_ScriptDir '/' videopath)
  ; FileRecycle(videopath)
  if "yes" = MsgBox("DELETE " filename "?", "", 0x4)
    FileRecycle(videopath)
  else {
    newname := input("file name", filename, , , filename)
    if !newname or newname == filename
      return
    FileMove(videopath, path.join(path.info(videopath).parentdir, newname '.mkv'))
  }
}
^F9::
{
  videopath := savevideo()
  filename := path.info(videopath).name
  newname := input("file name", filename, , , filename)
  if !newname or newname == filename
    return
  FileMove(videopath, path.join(path.info(videopath).parentdir, newname '.mkv'))
}

OnExit((*) {
  stopCapture()
})

; SetTimer(() {
;   static i := 0
;   i += 1
;   gticker.text := 'ticker: ' i
;   ii := 0
;   loop files 'temp/*.mkv', 'F' {
;     ii += 1
;   }
;   gfileCount.text := "fileCount: " ii
; }, 100)

SetTimer(() {
  gwinCount.text := 'windowCount: ' WinGetList("RCTest - Capture").Length
  if saving
    return
  static running := 0
  static dead := 0
  if running
    return

  running := 1
  if windows.Length {
    a := WinExist('a')
    active := 0
    for win in windows {
      if WinGetList(win).includes(a) {
        active := 1
        break
      }
    }
    print(active)
    if active and not (WinGetList("RCTest - Capture").Length == 1) {
      startCapture()
      Sleep(1000)
    } else {
      if not active {
        stopCapture()
      }
    }
  } else {
    if WinGetList("RCTest - Capture").Length == 1 {
      dead := 0
    } else {
      dead += 1
    }
    if dead == 30 {
      startCapture()
    }
    if dead == 50 {
      MsgBox("Error: video capture failed!!", "ERROR", 0x1000)
      reload()
    }
  }
  running := 0
}, 100)

clearTemp() {
  try DirDelete("temp", 1)
  DirCreate("temp")
  try FileDelete('counter')
}
