#Requires AutoHotkey v2.0
#SingleInstance Force
#Include *i <AutoThemed>
#Include <base>
#Include <Misc>
#Include <betterui>

winlength := 7

SetWorkingDir(A_ScriptDir)
BepInEx := "\BepInEx\plugins"
mainmodfile := "winhttp.dll"
configfile := A_ScriptFullPath.RegExMatch("\\([^\\]+)\.ahk$")[1] " config.json"
exe := JSON.parse(f.read(configfile))["gamefile"]
exename := exe.Replace(A_ScriptDir "\", "")
_path := A_ScriptDir

mods := []
_path := _path.RegExReplace("\$", "")
loop files, joinpath(_path, BepInEx) "\*.*", "fr" {
  print(A_LoopFileExt)
  if A_LoopFileExt = "dll" || A_LoopFileExt = "dissabled"
    mods.Push({
      path: A_LoopFilePath,
      name: A_LoopFilePath.replace(_path BepInEx '\', "").RegExReplace("\.[^.]+$", ""),
      state: A_LoopFileExt = "dll"
    })
}

modui := betterui({
  aot: 1,
  topbar: 1,
  resize: 1,
  showicon: 1,
  tool: 1,
  minBtn: 1,
  w: 50,
  h: 30,
  autoright: 0
})

startgame() {
  if WinExist("ahk_exe " exename)
    winclose("ahk_exe " exename)
  winwaitclose("ahk_exe " exename)
  print(joinpath(_path, exename))
  Run(exe)
  WinWait("ahk_exe " exename)
  ExitApp()
}
modui.add("button", {
  t: "uninstall",
  o: "w" winlength * 0.5 "x"
}, &btn)
btn.OnEvent("click", (*) {
  print(configfile)
  FileDelete(configfile)
  FileDelete(A_ScriptFullPath)
  ExitApp()
})
modui.moveRight(winlength * 0.5)
modui.add("button", {
  t: "run unmodded",
  o: "w" winlength * 1 "x"
}, &btn)
btn.OnEvent("click", (*) {
  try FileMove(joinpath(_path, mainmodfile), joinpath(_path, mainmodfile).regexreplace("\.dll", ".dissabled"), 1)
  startgame()
})
modui.moveRight(winlength * 1)

modui.add("button", {
  t: "run modded",
  o: "w" winlength * 1.5 "x"
}, &btn)
btn.OnEvent("click", (*) {
  try FileMove(joinpath(_path, mainmodfile).regexreplace("\.dll", ".dissabled"), joinpath(_path, mainmodfile), 1)
  startgame()
})
modui.newline(2)
modui.ignoretextcolor := 1
loop mods.length {
  m := mods[A_Index]
  modui.add("text", {
    text: m.name,
    options: "w3x center"
  }, &text)
    .moveDown()
    .moveright(1)
    .add("button", {
      text: "enable"
    }, &btn)
    .moveUp()
    .moveRight(2)
  text.setfont("c" (m.state ? "00aa00" : "aa0000"))

  btn.OnEvent("click", (m, btn, text, *) {
    oldpath := m.path
    if m.state
      m.path := m.path.regexreplace("\.dll$", ".dissabled")
    else
      m.m.path.regexreplace("\.dissabled$", ".dll")
    FileMove(oldpath, m.path, 1)
    m.state := !m.state
    print(m.state)
    text.setfont("c" (m.state ? "00aa00" : "aa0000"))
    btn.text := m.state ? "dissable" : "enable"
  }.bind(m, btn, text))
  btn.text := m.state ? "dissable" : "enable"
  m.btn := btn
  if mod(A_Index, winlength) == 0 && A_Index != mods.Length
    modui.newline(3)
}
modui.show()
print(mods)

joinpath(paths*) {
  fullpath := ""
  for path in paths {
    fullpath .= path
      .RegExReplace("\\$", "")
      .RegExReplace("^\\", "") . "\"
  }
  return fullpath.RegExReplace("\\$", "")
}
