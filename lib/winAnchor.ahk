#Requires AutoHotkey v2.0
#SingleInstance Force

SetWorkingDir(A_ScriptDir)
#Include *i <AutoThemed>
#Include <vars>

#Include <base> ; Array as base, Map as base, String as base, File as F, JSON

#Include <Misc> ; print, range, swap, ToString, RegExMatchAll, Highlight, MouseTip, WindowFromPoint, ConvertWinPos, WinGetInfo, GetCaretPos, IntersectRect
#HotIf A_LineFile == A_ScriptFullPath
  if A_LineFile == A_ScriptFullPath {
    `::{
      getAnchorPos(A_Clipboard, &x, &y)
      globalMouseMove(x, y)
    }
    ui := betterui({ aot: 1, tool: 1, w: 50, h: 50, gap: 10, transparency: 150, clickthrough: 1 })
    ui.add("text", { o: "w5x center h15", t: "press LControl on a place to select it" }).newLine()
    ui.add("text", { o: "w5x center h15", t: "then use the panel to select the anchor" }).newLine()
    ui.moveRight().add("button", { t: "tl" }, &tl).add("button", { t: "tc" }, &tc).add("button", { t: "tr" }, &tr).newLine()
    ui.moveRight().add("button", { t: "cl" }, &cl).add("button", { t: "cc" }, &cc).add("button", { t: "cr" }, &cr).newLine()
    ui.moveRight().add("button", { t: "bl" }, &bl).add("button", { t: "bc" }, &bc).add("button", { t: "br" }, &br)
    ui.Show("noactivate")
    LControl::{
      ui.setopts({ clickThrough: 0, transparency: 150 })
      Hotkey("LControl", "off")
      MouseGetPos(&msX, &msY, &msWin)
      WinGetClientPos(&winx, &winy, &winw, &winh, msWin)

      Hotkey("numpad7", end.bind("tl"))
      tl.OnEvent("click", end.bind("tl"))
      Hotkey("numpad8", end.bind("tc"))
      tc.OnEvent("click", end.bind("tc"))
      Hotkey("numpad9", end.bind("tr"))
      tr.OnEvent("click", end.bind("tr"))

      Hotkey("numpad4", end.bind("cl"))
      cl.OnEvent("click", end.bind("cl"))
      Hotkey("numpad5", end.bind("cc"))
      cc.OnEvent("click", end.bind("cc"))
      Hotkey("numpad6", end.bind("cr"))
      cr.OnEvent("click", end.bind("cr"))

      Hotkey("numpad1", end.bind("bl"))
      bl.OnEvent("click", end.bind("bl"))
      Hotkey("numpad2", end.bind("bc"))
      bc.OnEvent("click", end.bind("bc"))
      Hotkey("numpad3", end.bind("br"))
      br.OnEvent("click", end.bind("br"))

      end(pos, *) {
        data := ["ahk_exe " WinGetProcessName(msWin), msx, msy, winw, winh, pos].join("|")
        A_Clipboard := '"' data '"'
        getAnchorPos(data, &x, &y)
        globalMouseMove(x, y)
        ExitApp()
      }
    }
  }
#HotIf
getAnchorPos(data, &retx := &_, &rety := &_) {
  data := data.split("|")
  move := data[6]
  data := {
    exe: data[1],
    x: data[2],
    y: data[3],
    w: data[4],
    h: data[5]
  }
  WinGetClientPos(&winx, &winy, &winw, &winh, data.exe)
  pos := {}
  try if move[1] = "t" {
    pos.y := data.y
  }
  try if move[1] = 'b' {
    pos.y := winh - (data.h - data.y)
  }
  try if move[2] = 'l' {
    pos.x := data.x
  }
  try if move[2] = 'r' {
    pos.x := winw - (data.w - data.x)
  }
  try if move[2] = "c" {
    pos.x := rerange(data.x, 0, data.w, 0, winw)
  }
  try if move[1] = 'c' {
    pos.y := rerange(data.y, 0, data.h, 0, winh)
  }
  print(data, pos.x, pos.y, winx, winy)
  return { x: retx := winx + pos.x, y: rety := winy + pos.y }
}
