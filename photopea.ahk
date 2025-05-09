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

DetectHiddenWindows(1)
while ProcessExist("nginx.exe")
  ProcessClose("nginx.exe")

while WinExist("photopea python server")
  WinClose("photopea python server")

run("cmd /c `"title photopea python server & py -3.14 -m http.server 15643 -d `"D:\programs\photopea\www.photopea.com`"`"", , "hide")
run('cmd /c "d: & cd "D:\programs\nginx-1.28.0" & "D:\programs\nginx-1.28.0\nginx.exe"', "D:\programs\nginx-1.28.0", "hide")
; Run('http://www.photopea.com')