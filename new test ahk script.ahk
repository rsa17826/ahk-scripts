#Requires AutoHotkey v2.0
#Include <base>
#SingleInstance Force

dir := A_ScriptDir "\ahk test scripts"
if !DirExist(dir)
  DirCreate(dir)
SetWorkingDir(dir)
; filename:="test " A_Now ".ahk"
filename := "testing.ahk"
text := "
(
#Requires AutoHotkey v2.0
#SingleInstance Force

#Include *i <AutoThemed>

try TraySetIcon("icon.ico")
SetWorkingDir(A_ScriptDir)
#Include *i <vars>

#Include <Misc>

#Include *i <betterui> ; betterui

#Include *i <textfind> ; FindText, setSpeed, doClick

; #Include *i <CMD> ; CMD - cmd.exe - broken?



)"
if f.read(filename) != text
  FileRecycle(filename)

f.write(filename, text)
run("`"VSCodium.exe`" `"" dir "`" --goto `"" filename "`":" text.split("`n").length ":1")