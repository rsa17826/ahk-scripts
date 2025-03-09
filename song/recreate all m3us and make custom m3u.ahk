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

plstdata := JSON.parse(f.read("songplst.json"), , 0)
displaydata := []
try DirDelete("plsts")
newdata := [{
  btns: [{ text: "run", onclick: (*) {
    name := makefile()
    FileMove(name, "C:\Users\User\Desktop\songs")
    run("C:\Users\User\Desktop\songs\" name, , "min")
    Sleep(1000)
    FileDelete("C:\Users\User\Desktop\songs\" name)
  } }, { t: "save", onclick: makefile }],
  text: " "
}]
newdata.push({ btns: [{ text: "load", onclick: (*) {
  inp := input("regen text", '')
  if !inp
    return
  global displaydata
  displaydata := inp.trim().split(" ")
} }], text: "load" })
for key, val in plstdata.OwnProps() {
  realkey := key
  key := key.RegExReplace("^_", '')
  newdata.push({ btns: [{ text: key }], text: key, state: 0, realkey: realkey })
  F.write("plsts\" key ".m3u", val.join("`n"))
}
ui := betterui.newButtonPanel(newdata, onclick(null, data, obj, *) {
  colors := {
    0: "aaaaaa",
    1: "00aa00"
  }
  colors.%-1% := "aa0000"
  data.state += 1
  if data.state >= 2
    data.state := -1
  obj.text.setfont("c" colors.%data.state%)
  if data.state == 1
    try displaydata.push(data.realkey)
  if data.state == 0
    try displaydata.RemoveAt(displaydata.IndexOf("-" data.realkey))
  if data.state == -1 {
    try displaydata.RemoveAt(displaydata.IndexOf(data.realkey))
    try displaydata.push("-" data.realkey)
  }
  print(displaydata)
})
ui.show()
makefile(*) {
  newlist := []
  _add := displaydata.filter(e => !e.startsWith("-"))
  remove := displaydata.filter(e => e.startsWith("-")).map(e => e.RegExReplace("^-"))
  print(displaydata)
  for addlist in _add {
    try newlist.RemoveAt(newlist.IndexOf((plstdata.HasProp(addlist) ? plstdata.%addlist% : plstdata._%addlist%)))
    try newlist.push((plstdata.HasProp(addlist) ? plstdata.%addlist% : plstdata._%addlist%))
  }
  newlist := newlist.flat().unique()
  for removelist in remove
    try for removethis in (plstdata.HasProp(removelist) ? plstdata.%removelist% : plstdata._%removelist%)
      try newlist.RemoveAt(newlist.IndexOf(removethis))
  name := './plsts/' displaydata.map(e => e.RegExReplace("^_", "").RegExReplace("^-_", "-")).join(" ") '.m3u'
  f.write(name, newlist.join("`n"))
  return name
}
