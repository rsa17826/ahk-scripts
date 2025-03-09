#Requires AutoHotkey v2.0
#SingleInstance Force

; must include
SetWorkingDir(A_ScriptDir)
#Include *i <AutoThemed>
#Include <vars>

#Include <base> ; Array as base, Map as base, String as base, File as F, JSON

#Include <Misc> ; print, range, swap, ToString, RegExMatchAll, Highlight, MouseTip, WindowFromPoint, ConvertWinPos, WinGetInfo, GetCaretPos, IntersectRect
#Include <toast> ; toast - show msgs at Bottom of screen to alert user

#Include <betterui> ; betterui

#Include <desktop switcher>

#Include <textfind> ; FindText, setSpeed, doClick

; #Include <protocol> ; PROTO - listen for web protocols - requires admin

#Include <TTS> ; TTS - text to speech

#Include <CMD> ; CMD - cmd.exe
ui := unset
reshow(*) {
  global ui
  list := cmd.run("ollama list").Split("`n").map(e => e.RegExMatchAll("(.+?)(?: {2,}|$)").map(e => e[1]))
  running := cmd.run("ollama ps").Split("`n").map(e => e.RegExMatchAll("(.+?)(?: {2,}|$)").map(e => e[1])).sub(2, -1)
  print(running)
  for thing in running {
    list[list.map(e => e[1]).indexOf(thing[1])].push("STOPPING - " thing[-1])
  }
  print(list)
  keys := list[1]
  list := list.sub(2, -1)
  ; list := list.sort((a, s) => s.length - a.length)
  ; list := list.map(e => makeSameLength(" ", e*))
  newlist := []

  for temp in list {
    text := ''
    loop temp.length {
      key := ''
      try key := keys[A_Index]
      if ["id"].includes(key.toLower())
        continue
      text .= '`n' (key ? key ' - ' : "") temp[A_Index]
    }
    list[A_Index] := { btns: [], cmd: temp[1], text: ((text.includes("SToPPING") ? "" : "STOPPED") text).trim(" `n"), c: text.includes("SToPPING") ? "00aa00" : "aa0000" }
    if text.includes("SToPPING")
      list[A_Index].btns := [{ text: "open" }]
    else
      list[A_Index].btns := [{ text: "open" }, { text: "start", onclick: (_, obj, *) {
        cmd.runAsync("ollama run " obj.cmd " --keepalive 1h30m")
        SetTimer(reshow, -1000)
      } }]
  }
  ; for temp in list {
  ;   newobj := {}
  ;   loop temp.length
  ;     newobj.%keys[A_Index]% := temp[A_Index]
  ;   newlist.Push(newobj)
  ; }
  print(list*) ;,
  ; .map(e => [e, { name: "stop", cmd: e.cmd, text: "stop" }]).flat()
  for e in list {
    if e.text.includes("SToPPING")
      e.btns.push({ text: "stop", onclick: (btndata, obj, *) {
        cmd.runAsync("ollama stop " obj.cmd)
        SetTimer(reshow, -1000)
      }
      })
  }
  if IsSet(ui)
    WinGetPos(&x, &y, &w, &h, ui)
  try ui.Destroy()
  ui := betterui.newButtonPanel([{ btns: [{ text: "reload", onclick: reshow }], text: "`nreload the window`n`n" }, list*], (o, obj, *) {
    cmd.runAsync("ollama run " obj.cmd " --keepalive 1h30m", '')
    SetTimer(reshow, -1000)
  }, { h: 30, w: 200, rowLength: 3 })
  ui.show("NoActivate")
  if IsSet(x)
    WinMove(x, y, w, h, ui)
  ui.OnEvent("close", (*) => ExitApp())
}
reshow()