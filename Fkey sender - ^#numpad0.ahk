#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon
#Include *i <AutoThemed>
#Include <admin>

try TraySetIcon("icon.ico")
SetWorkingDir(A_ScriptDir)
#Include *i <vars>

#Include <Misc>

#MaxThreadsPerHotkey 50
#MaxThreads 50
#SuspendExempt true
Suspend()
^#Numpad0::
#SuspendExempt false
$Numpad0::
$Numpad1::
$Numpad2::
$Numpad3::
$Numpad4::
$Numpad5::
$Numpad6::
$Numpad7::
$Numpad8::
$Numpad9::
{
  static lastKeys := ''
  static t := 0
  if A_ThisHotkey == "^#Numpad0" {
    t := ''
    lastKeys := ''
    ToolTip("F...")
    SetTimer(stop, -5000)
    Suspend(0)
    SendDll("{Ctrl up}{lwin up}{Shift up}{alt up}")
    return
  }
  if A_ThisHotkey[-1] == "p" {
    lastKeys := ''
    return
  }
  lastKeys .= A_ThisHotkey[-1]
  if lastKeys.Length > 1
    ToolTip("F" lastKeys[1] lastKeys[-1])
  else
    ToolTip("F" lastKeys)
  while 1 {
    if lastKeys.Length >= 2
      break
    if !GetKeyState('Numpad' A_ThisHotkey[-1], 'p') {
      if !t
        t := A_TickCount
      if A_TickCount - t >= 100
        break
    }
  }
  if lastKeys
    if lastKeys.Length > 1
      SendDll("{F" lastKeys[1] lastKeys[-1] "}")
    else
      SendDll("{F" lastKeys "}")
  stop()
  SetTimer(stop, 0)
}

stop() {
  Suspend(1)
  ToolTip()
}
f13::a