#Requires AutoHotkey v2.0
#SingleInstance Force

; must include
SetWorkingDir(A_ScriptDir)
#Include *i <AutoThemed>
#Include <vars>

#Include <base> ; Array as base, Map as base, String as base, File as F, JSON

#Include <Misc> ; print, range, swap, ToString, RegExMatchAll, Highlight, MouseTip, WindowFromPoint, ConvertWinPos, WinGetInfo, GetCaretPos, IntersectRect
#Include <toast> ; toast - show msgs at Bottom of screen to alert user

modname := A_Args.has(1) ? A_Args[1] : input("mod name", "")

if !modname {
  return
}
settings := json.parse(f.read("settings.json"), , 0)
defaultCreatorName := settings.CreatorName
basepath := path.join(settings.celestePath, "mods", modname)
mapspath := path.join(basepath, "Maps")
if !path.info(basepath).exists {
  MsgBox("the mod `"" modname '" does not exist')
  ExitApp()
}
creatorName := ""
loop files mapspath '/*', "d" {
  creatorName := A_LoopFileName
  break
}

if !creatorName {
  creatorName := defaultCreatorName
  DirCreate(path.join(mapspath, creatorName))
}
foundMapName := 0
folderToMove := ""
loop files path.join(mapspath, creatorName) '/*', "d" {
  folderToMove := A_LoopFileName
  if A_LoopFileName = modname {
    foundMapName := 1
    folderToMove := ''
    break
  }
}
print(path.join(mapspath, creatorName, folderToMove), path.join(mapspath, creatorName, modname))
if foundMapName {

} else if (folderToMove) {
  DirMove(path.join(mapspath, creatorName, folderToMove), path.join(mapspath, creatorName, modname))
} else {
  DirCreate(path.join(mapspath, creatorName, modname))
}

if !path.info(basepath, "Dialog").exists {
  try FileMove(path.join(basepath, "Dialog"), path.join(basepath, "__Dialog"))
  DirCreate(path.join(basepath, "Dialog"))
}
engpath := path.join(basepath, "Dialog", "English.txt")
engtext := f.read(engpath)
starttext := creatorName.replace(" ", "_") '_' modname.replace(" ", "_")
engobj := {}
; add mod name
engobj.%starttext% := modname
loop files path.join(mapspath, creatorName, modname) '/*.bin' {
  newpath := path.join(mapspath, creatorName, modname, A_LoopFileName.RegExReplace(".bin$", ".meta.yaml"))
  if (settings.HasProp("allwaysUpdateMeta") and settings.allwaysUpdateMeta) or !FileExist(A_LoopFileFullPath.RegExReplace(".bin$", ".meta.yaml"))
    FileCopy("./leveldefault.meta.yaml", newpath, 1)
  newmeta := f.read(newpath)
  imgpath := path.join(basepath, "Graphics\Atlases\Endscreens\", creatorName, modname, A_LoopFileName.RegExReplace(".bin$", ".png"))
  relimgpath := imgpath.Replace(path.join(basepath, "Graphics/Atlases"), "").trim("/")
  print(relimgpath, path.info(relimgpath).nameandext)
  newmeta := newmeta
    .replace('"@endimgdir"', FileExist(imgpath) ? '"' path.info(relimgpath).parentdir '"' : "OldSite")
    .RegExReplace(' *#@endimgname *', "    - Type: layer`n"
      . "      Images: [`"" . (FileExist(imgpath) ? path.info(relimgpath).name : "00") . "`"]`n"
      . "      Position: [0.0, 0.0]`n"
      . "      Scroll: [0]"
    )
  f.write(newpath, newmeta)
  if engtext.includes("#ahk") && engtext.includes("#endahk") {
    temp := engtext.RegExMatch("#ahk[\s\S\r\n]+?#endahk")[0]
    temp := temp.RegExMatchAll("m)^(.*?)=(.*)$")
    for thing in temp {
      engobj.%thing[1]% := thing[2]
    }
  }
  levelname := A_LoopFileName.RegExReplace(".bin$", "")
  ; add show level name
  engobj.%starttext '_' levelname.replace(" ", "_")% := levelname.replace("_", " ")
  ; add end poem
  poemkey := "poem_" starttext '_' levelname.replace(" ", "_") '_a'
  if !engobj.HasProp(poemkey)
    engobj.%poemkey% := levelname.replace("_", " ") ' poem'
}
data := ''
for k, v in engobj.OwnProps() {
  data .= k '=' v '`n'
}
if engtext.includes("#ahk") && engtext.includes("#endahk") {
  f.write(engpath,
    "#ahk`n" engtext.RegExReplace("#ahk[\s\S\r\n]+?#endahk\n", data "#endahk`n")
  )
} else {
  f.write(engpath,
    "#ahk`n" data "#endahk`n"
  )
}
