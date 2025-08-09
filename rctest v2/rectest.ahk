#Requires AutoHotkey v2.0
#SingleInstance Force

try TraySetIcon("icon.ico")
SetWorkingDir(A_ScriptDir)
#Include *i <vars>

#Include <Misc>

DirCreate("temp")

IncludeWindowInFileName := false
folder := 'saved captures'
maxVids := 60
windows := [
  'ahk_exe explorer.exe'
]
clearTemp()

DirCreate(folder)
EnvSet('path', A_ScriptDir ';' EnvGet('path'))
; envset("path", 'C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Users\User\Desktop\ALL ahk scripts\rctest v2')
DetectHiddenWindows(1)
stopCapture()
stopCapture()
stopCapture()
startCapture()

stopCapture() {
  while WinExist("RCTest - Capture")
    try WinKill("RCTest - Capture")
}
startCapture() {
  stopCapture()
  clearTemp()
  run('powershell -File capture.ps1', , 'hide')
}
gettitle() {
  global IncludeWindowInFileName
  if !IncludeWindowInFileName
    return FormatTime(A_Now, "HH mm MM dd yyyy")

  exe := StrReplace(WinGetProcessName("a"), ".exe", "")
  title := WinGetTitle("a")
  if instr(title, exe)
    return title . " - " . FormatTime(A_Now, "HH,mm MM,dd,yyyy")
  else
    return title . " - " . exe . " - " . FormatTime(A_Now, "HH,mm MM,dd,yyyy")
}

savevideo() {
  title := gettitle()
  arr := []
  lastTime := 0
  lastFile := ''
  stopCapture()
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
  try FileMove("temp/joined.mkv", folder "/" title . ".mkv")
  catch {
    title .= ' RANDOM ' Random() A_TickCount
    MsgBox(title)
    FileMove("temp/joined.mkv", folder "/" title . ".mkv")
  }
  ; SetTimer(() {
  ;   try FileDelete("temp/file_list.txt")
  ; }, -1000)
  startCapture()
  return folder "/" title . ".mkv"
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
SetTimer(() {
  ; static running := 0
  ; if running {
  ;   return
  ; }
  ; running := 1
  ; a := WinExist('a')
  ; active := 0
  ; for win in windows {
  ;   if WinGetList(win).includes(a) {
  ;     active := 1
  ;     break
  ;   }
  ; }
  ; if active and not (WinGetList("RCTest - Capture").Length == 1) {
  ;   startCapture()
  ;   Sleep(1000)
  ; } else {
  ;   if not active {
  ;     stopCapture()
  ;   }
  ; }
  ; running := 0
  ; ; ToolTip(active)

  static dead := 0
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
}, 100)

; SetTimer(() {
;   static i := 0
;   ToolTip(i)
;   i += 1
;   if i == 80 {
;     videopath := savevideo()
;     filename := path.info(videopath).name
;     Run(A_ScriptDir '/' videopath)
;     ExitApp()
;   }
; }, 100)
clearTemp() {
  try DirDelete("temp", 1)
  DirCreate("temp")
}
