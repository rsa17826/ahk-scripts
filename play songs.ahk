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

try WinClose("ahk_exe vlc.exe")

Run("C:\Program Files\VLC\vlc.exe", , , &vlc)
WinWait(vlc)
run("C:\Users\User\Desktop\songs", , , &folder)
Hotkey("rbutton", (*) {
  Send("^a")
  Sleep(100)
  Send("{lbutton down}")
  WinGetPos(&x, &y, &w, &h, "ahk_exe vlc.exe")
  MouseMoveDll(x + w / 2, y + h / 2)
  Send("{lbutton up}")
  s := timer(1000)
  SetTitleMatchMode("regex")
  while vlc := WinExist("^VLC media player$") {
    if s.expired() {
      SetTitleMatchMode(1)
      WinClose("C:\Users\User\Desktop\songs")
      Reload()
    }
  }
  s.restart()
  Sleep(600)
  lasttit := WinGetTitle("ahk_exe vlc.exe")
  send("^!{Right}")
  Sleep(300)
  while 1 {
    a := WinGetTitle("ahk_exe vlc.exe")
    if lasttit != a && a != "VLC media player" {
      break
    }
    if s.expired() {
      SetTitleMatchMode(1)
      WinClose("C:\Users\User\Desktop\songs")
      Reload()
    }
  }
  MsgBox(lasttit)
  MsgBox(a)
  send("^!{Left}")
  SetTitleMatchMode(1)
  WinMinimize("ahk_exe vlc.exe")
  WinClose("C:\Users\User\Desktop\songs")
  ExitApp()
})