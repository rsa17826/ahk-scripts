#Requires AutoHotkey v2.0
#SingleInstance Force

; must include
#Include *i <AutoThemed>
#include <vars>

#Include <base> ; Array as base, Map as base, String as base, File as F, JSON

#Include <Misc> ; print, range, swap, ToString, RegExMatchAll, Highlight, MouseTip, WindowFromPoint, ConvertWinPos, WinGetInfo, GetCaretPos, IntersectRect

SetWorkingDir(A_ScriptDir)
try {
  dict := json.parse(f.read(A_Args[1]), , 0)
} catch {
  MsgBox("ERROR: cant read the file as json")
}
basepath := dict.basepath
switch dict.mode, 0 {
  case "make":
    loop files basepath '\*.*', "df" {
      try FileDelete(A_LoopFileFullPath)
      try DirDelete(A_LoopFileFullPath, 1)
    }
    makethings(basepath, dict.folders)
  case "check":
    MsgBox(json.stringify(checkthings(basepath, dict.folders)))
  default:
    print("Invalid mode")
}

checkthings(path, dict) {
  for key, val in dict.OwnProps() {
    if type(val) = "object" {
      checkthings(path '\' key, val)
    }
  }
  for key, val in dict.OwnProps() {
    if type(val) = "string" {
      if FileExist(path '\' key) and f.read(path '\' key) == val {
        dict.%key% := 1
      } else {
        dict.%key% := 0
      }
    }
  }
  loop files path '\*.*', 'df' {
    if !dict.HasOwnProp(A_LoopFileName) {
      dict.%A_LoopFileName% := -1
    }
  }
  return dict
}
makethings(path, dict) {
  DirCreate(path)
  for key, val in dict.OwnProps() {
    if type(val) = "string" {
      f.write(path '\' key, val)
    } else if type(val) = "object" {
      makethings(path '\' key, val)
    }
  }
}
