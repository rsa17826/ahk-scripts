#SingleInstance Force
#Requires Autohotkey v2.0
SetWorkingDir(A_ScriptDir)
try FileDelete("*.mkv")
try FileDelete(A_ScriptDir . "\temp\*.mkv")
ToolTip("removed all mkv files")
Sleep(1000)
ToolTip()