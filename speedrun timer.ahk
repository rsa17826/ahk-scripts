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

startTime := A_TickCount
testTime := 45.33 * 1000
bufferTime := 2500
respawnTime := 2250
gameId := "ahk_exe Aurascope.exe"

restart() {
  global startTime, testTime
  BlockInput("on")
  send("``")
  Sleep(260)
  send("{down}z")
  Sleep(20)
  BlockInput("off")
  startTime := A_TickCount + respawnTime
}
p::{
  Pause(-1)
}
$*`::{
  restart()
}
t := betterui({ aot: 1, clickthrough: 1, tool: 1, showicon: 0, resize: 0, topbar: 0, gap: 4, 1: 100, h: 20, transparency: 255 })
t.add("text", { t: "asdasd", o: "center" }, &text)
.newLine()
t.add("progress", {}, &prog)
t.show("NoActivate x" A_ScreenWidth - 500 " y" A_ScreenHeight - 150)
curtime := startTime
while 1 {
  ; if !WinActive(gameId) {
  ;   WinWaitActive(gameId)
  ;   restart()
  ; }
  curtime := A_TickCount - startTime
  if (curtime '/' testTime) !== text.Text {
    text.text := curtime '/' testTime
    if curtime > testTime
      prog.value := rerange(curtime - testTime, bufferTime, 0, 0, 100)
    else
      prog.value := rerange(curtime, 0, testTime, 0, 100)
  }
  if (curtime - bufferTime) > testTime {
    restart()
  }
}
