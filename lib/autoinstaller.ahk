#Requires AutoHotkey v2.0
#SingleInstance Force

; must include
#Include *i <AutoThemed>
#include <vars>
#Include <base> ; Array as base, Map as base, String as base, File as F, JSON

#Include <Misc> ; print, range, swap, ToString, RegExMatchAll, Highlight, MouseTip, WindowFromPoint, ConvertWinPos, WinGetInfo, GetCaretPos, IntersectRect

SetWorkingDir(A_ScriptDir)
class Installer {
  __New(path, win, wd := path.RegExReplace("[/\\][^\\/]+$", '')) {
    this.win := win
    this.path := path
    this.wd := wd
  }
  open() {
    if !winexist(this.win)
      run(this.path, this.wd, , &pid)
    winwait(this.win)
    Sleep(100)
  }
  close() {
    try WinKill(this.win)
    Sleep(100)
  }
  waitfortext(id, text) {
    this.ctrlwait(id)
    while 1 {
      if (this.matchtext(id, text))
        break
      sleep(10)
    }
  }
  matchtext(id, text?) {
    readtext := ControlGetText(id)
    if (!IsSet(text)) || readtext == text {
      return true
    }
    return false
  }
  click(btn) {
    ControlClick(btn, this.win)
  }
  check(box) {
    this.ctrlwait(box)
    if !ControlGetChecked(box, this.win)
      ControlClick(box, this.win)
  }
  uncheck(box) {
    if ControlGetChecked(box, this.win)
      ControlClick(box, this.win)
  }
  ctrlwait(ctrl) {
    while 1 {
      try {
        if ControlGetHwnd(ctrl, this.win)
          break
      }
    }
  }
}
