#Requires AutoHotkey v2.0
#SingleInstance Force

; must include
SetWorkingDir(A_ScriptDir)
#Include *i <AutoThemed>
#Include <vars>

#Include <base> ; Array as base, Map as base, String as base, File as F, JSON

#Include <Misc> ; print, range, swap, ToString, RegExMatchAll, Highlight, MouseTip, WindowFromPoint, ConvertWinPos, WinGetInfo, GetCaretPos, IntersectRect

#Include <betterui> ; betterui

vlcpid := unset
lastobj := {}
try lastobj := JSON.parse(f.read("songplst.json"), , 0)
obj := joinObjs({
  sing: [],
  funny: [],
  ; psongs: [],
  instrumental: [],
  ; eng: [],
  jap: [],
  otherlang: [],
  needsedit: [],
  _worse: [],
  _none: [],
  _slow: [],
  wasfav: [],
  nosing: [],
  couldsing: [],
  changevol: []
}, lastobj)
removett := ToolTip.bind("")
arr := []
lastarr := [obj.OwnProps()*].map(e => obj.%e%).flat().Unique()
print(lastarr)
loop files "C:\Users\User\Desktop\songs\*", "f" {
  filepath := A_LoopFilePath.replace("C:\Users\User\Desktop\songs\", "")
  .replace("#", "%23")
  if filepath.RegExMatch("[’＊サッドガール・セックス�]")
    continue
  if filepath.includes("ルーキー")
    continue
  if filepath.includes("odo - ado english")
    continue
  if filepath.includes("rang ")
    continue
  if !(filepath.endsWith(".mp3") || filepath.endsWith(".opus") || filepath.endsWith(".m4a"))
    continue
  if filepath.endsWith("foldericon.ico") or filepath.endsWith("desktop.ini")
    continue
  if !lastarr.includes(filepath)
    arr.push(filepath)
}
item := unset
RButton::next()
ui := betterui.newButtonPanel([{ btns: [{ text: "Exit", onclick: (*) {
  ProcessClose("vlc.exe")
  ExitApp()
} }, { text: "Reload", onclick: (*) {
  ProcessClose("vlc.exe")
  Reload()
} }, { text: "next", onclick: next }] }, [obj.OwnProps()*].map(e => { btns: [{ text: e }] })].flat(), (btn, *) {
  add(btn.text)
}, { rowLength: 5 })
ui.Show("")
ui.OnEvent("close", (*) {
  ExitApp()
})
add(key) {
  global obj, item
  if obj.%key%.includes(item) {
    obj.%key%.RemoveAt(obj.%key%.indexOf(item))
    ToolTip("removed from `"" key '"')
  } else {
    obj.%key%.push(item)
    ToolTip("added to `"" key '"')
  }
  SetTimer(removett, -1500)
  f.write(, JSON.stringify(obj))
}
next(*) {
  global obj, arr, item, vlcpid
  item := arr.pop()
  lastarr.push(item)
  ProcessClose("vlc.exe")
  vlcpid := unset
  run("C:\Program Files\VLC\vlc.exe" ' "C:\Users\User\Desktop\songs\' item.replace("%23", "#") '"', , , &vlcpid)
  ToolTip(item.replace("%23", "#") . '||||' . Round(lastarr.length / (lastarr.length + arr.length) * 100) '%')
  SetTimer(removett, -1500)
}
print(arr.Length)
next()