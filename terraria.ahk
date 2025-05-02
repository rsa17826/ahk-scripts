#Requires AutoHotkey v2.0
#SingleInstance Force

#Include *i <AutoThemed>

try TraySetIcon("icon.ico")
SetWorkingDir(A_ScriptDir)
#Include *i <vars>

#Include <Misc>

#Include *i <betterui> ; betterui

#Include *i <textfind> ; FindText, setSpeed, doClick
#Include <AutoHotInterception\AutoHotInterception>

; #Include *i <CMD> ; CMD - cmd.exe - broken?

CoordMode("mouse", "screen")
MouseGetPos(&x, &y)
print(x, y)
AHI := AutoHotInterception()
kb := AHI.GetKeyboardIdFromHandle(EnvGet("INTERCEPTON_MAIN_KEYBOARD_HANDLE"))

#HotIf WinActive('ahk_exe dotnet.exe')
  slot := 1
  ^m::{
    MouseMoveDll(512, 585)
    send("u")
  }
  ; InstallKeybdHook(1)

  d := GetKeyState("shift", "p")
  $+e::{
    global d
    AHI.SubscribeKey(kb, GetKeySC("shift"), 1, (down) {
      global d
      d := down
    })
    d := GetKeyState("shift", "p")
    AHI.SendKeyEvent(kb, GetKeySC("shift"), 0)
    SendDll("{shift up}{e}{shift down}{lbutton}{shift up}{lbutton}", 40, 40)
    AHI.UnsubscribeKey(kb, GetKeySC("shift"))
    AHI.SendKeyEvent(kb, GetKeySC("shift"), d)
  }

  $*RButton::{
    ; static lastpress := A_TickCount - 900
    ; global s
    for key in ['shift', "ctrl", "lbutton"]
      if GetKeyState(key, "p")
        return
    ; if (A_TickCount - lastpress) < 30
    ;   return
    ; lastpress := A_TickCount

    MouseClick("r", , , 1, 0, 'd')
    Sleep(30)
    MouseClick("r", , , 1, 0, 'u')
    Sleep(180)
    SendDll(slot)
    ; SendDll(s)
  }
  slot := 0
  $*~1::
  $*~2::
  $*~3::
  $*~4::
  $*~5::
  $*~6::
  $*~7::
  $*~8::
  $*~9::
  $*~0::{
    global slot
    slot := A_ThisHotkey.Replace("$*~", '')
  }
  
  ; s := 1
  ; while 1 {
  ;   temp := getSelected()
  ;   if temp != 100 {
  ;     ToolTip(temp)
  ;     s := temp
  ;   }
  ;   Sleep(1000)
  ;   ToolTip()
  ; }
  ; getSelected() {
  ;   obj := { %PixelGetColor(29, 98)%: 1, %PixelGetColor(90, 103)%: 2, %PixelGetColor(136, 100)%: 3, %PixelGetColor(183, 100)%: 4, %PixelGetColor(227, 100)%: 5, %PixelGetColor(274, 98)%: 6, %PixelGetColor(320, 98)%: 7, %PixelGetColor(367, 100)%: 8, %PixelGetColor(413, 100)%: 9, %PixelGetColor(459, 98)%: 0 }
  ;   print(obj)
  ;   return (OptObj(obj, 100).%0x4249BD%)
  ; }
  ; $*RButton::{
  ;   static lastpress := A_TickCount - 900
  ;   for key in ['shift', "ctrl", "lbutton"]
  ;     if GetKeyState(key, "p")
  ;       return
  ;   if (A_TickCount - lastpress) < 30
  ;     return
  ;   lastpress := A_TickCount
  ;   s := { %PixelGetColor(29, 98)%: 1, %PixelGetColor(90, 103)%: 2, %PixelGetColor(136, 100)%: 3, %PixelGetColor(183, 100)%: 4, %PixelGetColor(227, 100)%: 5, %PixelGetColor(274, 98)%: 6, %PixelGetColor(320, 98)%: 7, %PixelGetColor(367, 100)%: 8, %PixelGetColor(413, 100)%: 9, %PixelGetColor(459, 98)%: 0,
  ;   }.%0x4249BD%
  ;   MouseClick("r", , , 1, 0, 'd')
  ;   Sleep(30)
  ;   MouseClick("r", , , 1, 0, 'u')
  ;   Sleep(1300)
  ; }

  ; t::{
  ;   MouseGetPos(&x, &y)
  ;   print(x ', ' y)
  ; }
