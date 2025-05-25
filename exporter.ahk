#Requires AutoHotkey v2.0
#SingleInstance OFF
#Include <admin>
#Include *i <AutoThemed>

try TraySetIcon("icon.ico")
; MsgBox(JSON.stringify(A_Args))
#Include <compiledArgFixer>
#Include *i <vars>

#Include <Misc>

; try WinClose("C:\Windows\system32\cmd.exe")
; MsgBox(JSON.stringify([A_Args, A_WorkingDir]))
if A_Args.Length >= 1 {
  SetWorkingDir(A_Args[1])
}
uploadPaths := []
if A_Args.Length >= 1 and
  path.join(A_Args[1]).includes("D:/godotgames/") {
  loop files path.join(A_Args[1]).RegExReplace("/([^/]+)$", "/exports/$1/*"), 'D' {
    uploadPaths.Push(A_LoopFileFullPath)
  }
} else {
  loop files (path.join(A_Args.Length >= 2 ? A_Args[2] : input("enter folder parent path", "", , , A_Clipboard)) '/*').replace("//", '/'), 'D' {
    uploadPaths.Push(A_LoopFileFullPath)
  }
}
; MsgBox(uploadPath)
if !uploadPaths.Length
  ExitApp()

DetectHiddenWindows(1)
; win := getConsole(A_WorkingDir, "hide")
RunWait("cmd /c gh release list --json tagName > test.txt")
versions := JSON.parse(f.read("test.txt"), 0, 0)
; FileDelete("test.txt")
uploadPaths := uploadPaths.map(e => e.trim('"'))
version := 1
for v in versions {
  if v.tagName >= version {
    version := v.tagName + 1
  }
}
win := getConsole(A_WorkingDir, "", "C:\Program Files\PowerShell\7\pwsh.exe")
; sshpass := EnvGet("SSHPASS")
while GetKeyState("shift", "p") || GetKeyState("ctrl", "p") || GetKeyState("alt", "p") || GetKeyState("enter", "p") {
}
; cd "__PATH__"
WinActivate(win)
text := ''
for p in uploadPaths {
  text .= '`nCompress-Archive -Path "__PATH__\*" -DestinationPath "__PATH__.zip"'.replace("__PATH__", p)
}
text .= '`ngh release create "__VERSION__" "__PATHS__" --notes ""'.replace("__VERSION__", version).replace("__PATHS__", uploadPaths.map(e => e '.zip').join('" "'))
for p in uploadPaths {
  text .= '`nRemove-Item "__PATH__.zip" -Force'.replace("__PATH__", p)
}
A_Clipboard := text
print(text)
SendText(text "`nexit`n")
; Send("git add . {enter}git commit -m `"" msg.replace("\", "\\").replace('"', '\"').replace("'", "\'") "`"{enter}" sshpass "{enter}git push{enter}" sshpass "{enter}")
; ControlSend("git add . {enter}git commit -m `"" msg.replace("\", "\\").replace('"', '\"').replace("'", "\'") "`"{enter}" sshpass "{enter}git push{enter}" sshpass "{enter}", , win)
Sleep(1000)
; WinClose(win)
; MsgBox("done")
; D:\godotgames\exports