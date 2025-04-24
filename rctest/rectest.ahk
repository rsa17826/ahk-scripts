#Include *i <AutoThemed>
#SingleInstance Force
#Requires Autohotkey v2.0
#Include <Misc>
SetWorkingDir(A_ScriptDir)
#Include "end.ahk"

IncludeWindowInFileName := false
DetectHiddenWindows(1)
while WinExist("RCTEST") {
  try WinClose("RCTEST")
}
while ProcessExist("ffmpeg.exe") {
  ProcessClose("ffmpeg.exe")
}
DirCreate("temp")
try FileDelete("./temp/temp.mkv")
sleep(1000)
try FileDelete("./temp/temp.mkv")
ToolTip("started recording")
SetTimer(ToolTip.Bind(""), -1000)
RunWait(A_ScriptDir . "\rectest.bat", A_ScriptDir, "hide")
ToolTip("recorder died, reloading...")
sleep(600)
reload()
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
  ; A_Clipboard := title
  ; A_Clipboard := A_ScriptDir . "\joiner.bat `"" . title . '"'
  if Runwait(A_ScriptDir . "\joiner.bat `"" . title . '"', A_ScriptDir, "hide", &pid) {
    Runwait(A_ScriptDir . "\joiner.bat `"" . title . '" & pause', A_ScriptDir, "", &pid)
    SetWorkingDir(A_ScriptDir . '\temp')

    while ProcessExist("cmd.exe") {
      ProcessClose("cmd.exe")
    }
    while ProcessExist("ffmpeg.exe") {
      ProcessClose("ffmpeg.exe")
    }
    loop 300 {
      if FileExist(A_Index . ".mkv")
        FileDelete(A_Index . ".mkv")
    }
    try FileDelete("temp.mkv")
    ToolTip("removed temp files")
    Sleep(1000)
    ToolTip()
    reload()
  }
  return A_ScriptDir . '\' . title . '.mkv'
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
^+F9::{
  videopath := savevideo()
  filename := path.info(videopath).name
  RunWait(videopath)
  if "yes" = MsgBox("DELETE " filename "?", "", 0x4)
    FileRecycle(videopath)
  else {
    newname := input("file name", filename, , , filename)
    if !newname or newname == filename
      return
    FileMove(videopath, path.join(path.info(videopath).parentdir, newname '.mkv'))
  }
}
