#SingleInstance Force
#Requires Autohotkey v2.0
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