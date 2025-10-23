#Requires AutoHotkey v2.0
#SingleInstance Force
; #NoTrayIcon
#Include *i <AutoThemed>
#Include <admin>
#Include <textfind>
#Include <base>
#Include <Misc>
; try TraySetIcon("D:\.ico\clear.ico")

tasks := []
SetTimer(RunTasks(*) {
  for index, task in tasks
    try task.Call()
}, 50)
; close ahk errs on blur

;||ahk_exe AutoHotkeyUX.exe ahk_class #32770 => Could not close the previous instance of
; tasks.push(() {
;   if !WinActive("ahk_exe AutoHotkey64.exe ahk_class #32770")
;     return
;   while WinActive("ahk_exe AutoHotkey64.exe ahk_class #32770") {
;   }
;   sleep(300)
;   if WinExist("ahk_exe AutoHotkey64.exe ahk_class #32770") and not WinActive("ahk_exe AutoHotkey64.exe ahk_class #32770")
;     try WinClose("ahk_exe AutoHotkey64.exe ahk_class #32770")
; })

; kill active window
^!F4::{
  if winactive("ahk_class Shell_TrayWnd") || winactive("ahk_class Progman")
    return
  try
    WinKill("A")
}

; audacity dont save
#hotif WinActive("ahk_exe audacity.exe")
!F4::{
  try ProcessClose("audacity.exe")
}
#hotif

tasks.push(() {
  if !winactive("Save changes to ahk_exe audacity.exe")
    return
  ControlClick('Button2', "Save changes to ahk_exe audacity.exe")
  sleep(10)
})

; close pixiEditor window
tasks.push(() {
  if WinExist("Hello there!")
    WinClose("Hello there!")
})

; auto close Logged In Elsewhere
DetectHiddenWindows(true)
tasks.push(() {
  if !winactive("Logged In Elsewhere ahk_exe SoulseekQt.exe")
    return
  ToolTip("!!!Logged In Elsewhere!!!")
  SetTimer(ToolTip.bind(""), 5000)
  try WinClose()
})

; auto kill crash recovery audacity
tasks.Push(() {
  if !WinExist("Automatic Crash Recovery ahk_exe audacity.exe")
    return
  try WinClose()
})
tasks.Push(() {
  if !WinExist("Microsoft Store ahk_exe ApplicationFrameHost.exe")
    return
  try WinClose()
})

; autoattack sog
#hotif winactive("ahk_exe Secrets Of Grindea.exe")
*$z::{
  while getkeystate('z', 'p')
    sendevent('{numpad0}')
}
#HotIf

; dissable capslock
SetCapsLockState("AlwaysOff")
SetNumLockState("AlwaysOn")

; set active window aot
#InputLevel 100
; windown := 0
; dontsendwin := 1
; LWin::{
;   global windown := 1
;   global dontsendwin := 1
; }
nott := ToolTip.bind("") ; nott -> NOToolTip
$!/::{
  ; global windown
  ; if !windown
  ;   return send("{space}")
  a := WinExist("a")
  SetTimer(nott, 0)
  ToolTip(((aot := WinGetAlwaysOnTop(a)) ? "dissabled" : "enabled") " aot for " WinGetProcessName(a).RegExReplace(".exe$", ''))
  WinSetAlwaysontop(!aot, a)
  SetTimer(nott, -1000)
}
; ~lwin up::{
;   global windown := 0
;   global dontsendwin
;   if !dontsendwin
;     send("{LWin}")
; }
#InputLevel
; kill explorer
tasks.push(() {
  if WinExist('ahk_exe msedge.exe') {
    try winkill("ahk_exe msedge.exe")
    try winclose("ahk_exe msedge.exe")
    if WinExist('ahk_exe msedge.exe') {
      try WinActivate("ahk_exe msedge.exe")
      try winkill("ahk_exe msedge.exe")
      try winclose("ahk_exe msedge.exe")
    }
  }
})

; kill wog
tasks.push(() {
  if winexist('Fatal Error!')
    try WinClose('Fatal Error!')
})

; olympus close is a dependancy window
; tasks.push(() {
;   static cancel := "|<>*150$77.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzjzzzzkTzzzzzzTzzzzCTzzzzzyzzzzwySBcT7sxzzzzvzvXCRnivzzzzrzjayrqyrzzzzjzThxjw1jzzzzTyzPvTvzTzzzyTBwrqyrqzzzzyQxljitrRzzzzy3wPTSDlvzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzy"
;   static cmark := "|<>*108$82.k00Dzzzzzzzzzy000Tzzzzzzzzzk000zzzzzzzzzz0003zzzzzzzzzw000DzzzzvzTzzU000y3zzzjxzzy0083vzzzyzrzzs01UDjoD1O7Q7UU060yz4MlWBaAM00E3sBtbaQqynk030DjrqzPvM3TU0A0yzTPxjhjxy0MU3vxxbaQqwnk0q0DjrqAMXMX601s0y3TQ5cRkS20303zzzzzzzzzw000Dzzzzzzzzzk000zzzzzzzzzz0003zzzzzzzzzw000Dzzzzzzzzzk000zzzzzzzzzzU007zzzzzzzzzz000zzzzzzzzzzs"
;   FindText().setStatic([cancel])
;   if !WinActive("Olympus ahk_exe main.exe")
;     return
;   if GetKeyState("z", "p")
;     if tryfind(cancel)
;       doclick()
; })

; sharex autorenamer
~!PrintScreen::{
  Sleep(300)
  loop files "D:\Downloads\images\screenshots\*.*", 'fr' {
    if (A_LoopFilePath.includes("_")) {
      newname := A_LoopFilePath.replace("_", ' ')
      DirCreate(newname.RegExReplace("[\\/][^\\/]+$", ''))
      FileMove(A_LoopFileFullPath, newname, 1)
    }
  }
  loop files "D:\Downloads\images\screenshots\*.*", 'dr' {
    if isEmpty(A_LoopFilePath)
      DirDelete(A_LoopFileFullPath, 1)
  }
}

; speedhack hotkeys

; ControlGetClassNN("Button4", "Cheat Engine") ; enable
#HotIf WinExist("Cheat Engine")
^numpad1::cheatengine_setspeed('1')
^numpad2::cheatengine_setspeed('1.7')
^numpad3::cheatengine_setspeed('3')
^numpad4::cheatengine_setspeed('50')
^numpad0::cheatengine_setspeed('0')
cheatengine_setspeed(speed) {
  DetectHiddenWindows(0)
  lastwin := WinGetPID('A')
  loop 5 {
    if ControlGetText("Button" A_Index, "Cheat Engine") == "Enable Speedhack" {
      enable := "Button" A_Index
      break
    }
  }

  if !ControlGetChecked(enable, "Cheat Engine")
    ControlSetChecked(1, enable, "Cheat Engine")

  loop 5 {
    if ControlGetText("Button" A_Index, "Cheat Engine") == "Apply" {
      Apply := "Button" A_Index
      break
    }
  }
  ControlSetText(speed, "Edit1", "Cheat Engine")
  ControlClick(Apply, "Cheat Engine")
  WinActivate('ahk_pid ' . lastwin)
  DetectHiddenWindows(1)
}
#HotIf

; steam block Special Offers
tasks.push(() {
  if WinExist("Special Offers ahk_exe steamwebhelper.exe")
    try WinClose()
  if WinExist("Support Message ahk_exe steamwebhelper.exe")
    try WinClose()
})
tasks.push(() {
  if WinExist("Windows Media Player Legacy ahk_exe setup_wm.exe")
    try WinClose()
})

; tunic ladder fly
#HotIf WinActive("ahk_exe Tunic.exe")
a::{
  send("{z down}")
  send("{x down}")
  while GetKeyState("a", "P") {
    sleep(10)
    send("{x up}")
    send("{z up}")
    sleep(10)
    send("{z down}")
  }
  sleep(10)
  send("{z up}")
}
#HotIf

; vlc global hotkeys
^#Left::^!left
^#Right::^!right
^#Space::^!Space

; #HotIf WinActive('ahk_exe vlc.exe')
;   ; space::^!space
;   settime() {
;     send("{control down}t{control up}")
;     send("000030{enter}")
;   }
;   ; NumpadAdd:: {
;   ;   save("", "good")
;   ; }
;   ; NumpadSub:: {
;   ;   save("", "bad")
;   ; }
;   ; save(val, val2) {
;   ;   ac := WinActive("a")
;   ;   win := WinExist("ahk_exe vlc.exe")
;   ;   WinActivate(win)
;   ;   text := WinGetTitle(win)
;   ;   IniWrite(val, "test.ini", val2, '"' . text . '"')
;   ;   ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, "D:/downloads/images/screenshots/vlc/＂Weird_Al＂_Yankovic_-_Trapped_In_The_Drive-Thru_(O {1721225354} 28X24.png")
;   ;   MouseGetPos(&lx, &ly)
;   ;   MouseMove(x + 10, y + 10, 0)
;   ;   Sleep(20)
;   ;   click()
;   ;   Sleep(20)
;   ;   MouseMove(lx, ly, 0)
;   ;   ; send("{ctrl down}{alt down}{right}{alt up}{ctrl up}")
;   ;   sleep(100)
;   ;   settime()
;   ;   loop 4 {
;   ;     Sleep(100)
;   ;     WinActivate(ac)
;   ;     WinActivate("ahk_id " . ac)
;   ;   }
;   ; }
; #HotIf

; gd item remover?
; idx := 290
; q:: {
;   global idx
;   idx += 1
;   sendtext(idx '`n')
;   if String(idx)[-1] == 9 {
;     ToolTip(idx)
;     SetTimer(ToolTip.Bind(""), -1000)
;   }
; }
; z:: {
;   global idx
;   idx += 1
;   sendtext("# " idx '`n')
;   if String(idx)[-1] == 9 {
;     ToolTip(idx)
;     SetTimer(ToolTip.Bind(""), -1000)
;   }
; }

; auto set darkmode on titlebar
OnNewWindow((lParam) {
  try {
    ; try IniWrite(WinGetTitle(lParam), "c:\users\user\openedwindows.ini", "opened windows: " A_Now)
    text := ''
    ; text.='`n' ProcessGetParent("ahk_id " lParam)
    try {
      text .= 'process id: ' lParam
      ; text .= '`nprocess name: ' WinGetProcessName("ahk_id " lParam)
      text .= '`nprocess path: ' WinGetProcessPath("ahk_id " lParam)
      try {
        pp := ProcessGetParent(WinGetProcessName("ahk_id " lParam))
        text .= '`nparent process id: ' pp
        ; text .= '`nparent process name: ' ProcessGetName(pp)
        text .= '`nparent process path: ' ProcessGetPath(pp)
      }catch Error as e{
        text.="`nfailed to get parent process info because `"" e.message '"'
      }
    }catch Error as e{
      text.="`nfailed to get process info because `"" e.message '"'
    }
    text .= (
      ; "`nwindow title: " WinGetTitle("ahk_id " lParam)
      "`n"
      (WinGetInfo("ahk_id " lParam)
      .RegExReplace("TransColor:[\s\S]*$", '`n`n')
      .split("`n")
      .filter(e =>
        !(e.startsWith("ahk_id") or e.startsWith("ahk_pid") or e.startsWith("Screen position")))).join("`n"))
    try IniWrite(text, "c:\users\user\openedwindows.ini", "opened windows: " A_Now)
    todark("ahk_id " lParam)
  } catch Error as e {
    try IniWrite("failed to get window because `"" e.message '"', "c:\users\user\openedwindows.ini", "opened windows: " A_Now)
  }

  ; auto aot for xdm download window
  try {
    if (WinGetProcessPath(lParam) == "C:\Program Files (x86)\XDM\java-runtime\bin\javaw.exe") {
      WinSetAlwaysOnTop(1, lParam)
    }
  }
})

todark(win) {
  if !WinExist(win)
    return
  ; num := VerCompare(A_OSVersion, "10.0.17763") >= 0 ? 19
  ;   : VerCompare(A_OSVersion, "10.0.18985") >= 0 ? 20 : 0
  ; DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", winexist(win), "Int", num, "Int*", 1, "Int", 4)

  DarkColors := Map("Background", "0x202020", "Controls", "0x404040", "Font", "0xE0E0E0")
  TextBackgroundBrush := DllCall("gdi32\CreateSolidBrush", "UInt", DarkColors["Background"], "Ptr")

  if (VerCompare(A_OSVersion, "10.0.17763") >= 0) {
    DWMWA_USE_IMMERSIVE_DARK_MODE := 19
    if (VerCompare(A_OSVersion, "10.0.18985") >= 0) {
      DWMWA_USE_IMMERSIVE_DARK_MODE := 20
    }
    DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", WinExist(win), "Int", DWMWA_USE_IMMERSIVE_DARK_MODE, "Int*", True, "Int", 4)
    uxtheme := DllCall("kernel32\GetModuleHandle", "Str", "uxtheme", "Ptr")
    DllCall(DllCall("kernel32\GetProcAddress", "Ptr", uxtheme, "Ptr", 135, "Ptr"), "Int", 2) ; SetPreferredAppMode + ForceDark
    DllCall(DllCall("kernel32\GetProcAddress", "Ptr", uxtheme, "Ptr", 136, "Ptr")) ; FlushMenuThemes
  }
  uxtheme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
  SetPreferredAppMode := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 135, "ptr")
  FlushMenuThemes := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 136, "ptr")
  DllCall(SetPreferredAppMode, "int", 2) ; Dark
  DllCall(FlushMenuThemes)
  ; DllCall("uxtheme\SetWindowTheme", "ptr", ctrl_hwnd, "str", "DarkMode_Explorer", "ptr", 0)

  ;   For Hwnd, GuiCtrlObj in MyGui{
  ;     DllCall("uxtheme\SetWindowTheme", "ptr", GuiCtrlObj.hwnd, "str", "DarkMode_Explorer", "ptr", 0)
  ; }
}

; #HotIf WinActive('ahk_exe explorer.exe')
;   !del::{
;     ecount := WinGetCount("ahk_exe explorer.exe")
;     send("!{enter}")
;     sleep(400)
;     if ecount == WinGetCount("ahk_exe explorer.exe")
;       return
;     temp := A_Clipboard
;     send("{tab}")
;     sleep(100)
;     send("^c")
;     i := 0
;     while i < 30 && A_Clipboard == temp {
;       Sleep(100)
;       i++
;     }
;     if i >= 30
;       return
;     FileRecycle(A_Clipboard
;       .RegExReplace("`"$", "")
;       .RegExReplace("^`"", "")
;       .RegExReplace("\\$", ""))
;     A_Clipboard := temp
;     send("{esc}")
;     sleep(200)
;     send("{del}")
;     ; ecount := WinGetCount("ahk_exe explorer.exe")
;     ; win1 := WinGetList("ahk_exe explorer.exe")[1]
;     ; send("{tab}{tab}{tab}{tab}{tab}f!{up}")
;     ; while ecount == WinGetCount("ahk_exe explorer.exe") {
;     ; }
;     ; sleep(700)
;     ; send("!{tab}{Esc}{Esc}{Esc}{Esc}{Esc}{Esc}{Esc}")
;     ; win2 := WinGetList("ahk_exe explorer.exe")[1]
;     ; send("!{up}")
;     ; sleep(500)
;     ; WinActivate(win2)
;     ; WinClose(win2)
;     ; send("!{F4}")
;     ; WinClose("ahk_id " win2)
;     ; send("{del}")
;   }

#HotIf WinActive("ahk_exe VSCodium.exe")
^8::{
  send("/**")
  sleep(100)
  send("{tab}")
}

; add () to ahk function call
^+F8::{
  send("{end}{home}^{right}+{end}({f8}")
}

#HotIf

; close KeePassOTP cant fetch error popup
tasks.push(() {
  if WinExist("KeePassOTP ahk_exe KeePass.exe ahk_class #32770") {
    WinClose("KeePassOTP ahk_exe KeePass.exe ahk_class #32770")
    ; WinActivate("KeePassOTP ahk_exe KeePass.exe")
    ; WinWaitActive("KeePassOTP ahk_exe KeePass.exe")
    ; send("{Enter}")
  }
})
tasks.push(() {
  if WinExist("ahk_class SunAwtDialog ahk_exe Minecraft.exe") {
    WinActivate("ahk_class SunAwtDialog ahk_exe Minecraft.exe")
    WinWaitActive("ahk_class SunAwtDialog ahk_exe Minecraft.exe")
    send("{Enter}")
  }
})
::stopprop::e.stopImmediatePropagation()`ne.stopPropagation()`ne.preventDefault()

; aot explorer progress windows
tasks.push(() {
  if winexist("ahk_class OperationStatusWindow")
    WinSetAlwaysOnTop(1, "ahk_class OperationStatusWindow")
  if winexist("Delete Folder ahk_class #32770 ahk_exe explorer.exe")
    WinSetAlwaysOnTop(1, "Delete Folder ahk_class #32770 ahk_exe explorer.exe")
  ; if winexist("ahk_class #32770")
  ;   WinSetAlwaysOnTop(1, "ahk_class #32770")
})

; godot close sucess
tasks.push(() {
  if WinExist("Success! ahk_class Engine")
    WinClose("Success! ahk_class Engine")
})

; event closer godot
GODOT_eventopened := "|<>*93$183.zzzzzzzzzzzzzzzzzzzzUbzzzzzzzz0zDzzs1zzzzzzzzUTzzzs8zzzzzzzzs3tzzz0Dzzzzznzs1zzzz7bzzzzzzzz0DDzzszzzzzzyTy6Tzzzszzzzzzzzzs1twDz7swQ7YD0TlzkT8S17V6DC8sTV17C0Tsz770Q0M3wTw1s0U8s0ltk41s08tlXz0MsllVXXzXz37377766DC1X761XASDs3XCCAQQTwTsssssslsltkswlsANXlz7wFk1XXXzXz777776D6DCD06D1lASDszmC0AQQTwTsssssslsltls0lsD1Xlz7y3lzXXXzVz777776D6CCD7yD1sCATszkSDwQQTy7MMssssskkllwSskDVk3z0D3s3XXUTs3UD7777070CDU701wDVzs1szUQQS3zUS3ssssw8w9lz1w8zzzzzzzzzzzzzzzzzzzzzzzDzzzzzzzzzzzzzzzzzzzzzzzzzzzzvlzzzzzzzzzzzzzzzzzzzzzzzzzzzzz0Dzzzzzzzzzzzzzzzzzzzzzzzzzzzzs7zzzzzzzU"
GODOT_okbtn := "|<ok btn>*75$41.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzwDCTzzznaNzzzzDgbzzzyzMTzzzxykzzzzvxYzzzznvAzzzznaRzzzzkwtzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"
tasks.Push(() {
  if !WinActive("ahk_class Engine")
    return
  if tryfind(GODOT_eventopened, &x, &y) {
    try {
      tryfind(GODOT_okbtn, &btnx, &btny)
      while tryfind(GODOT_eventopened, &x, &y) {
      }
      while GetKeyState("ctrl", "P") or
      GetKeyState("alt", "P") or
      GetKeyState("lwin", "P") or
      GetKeyState("rwin", "P") or
      GetKeyState("shift", "P") {
      }
      if tryfind(GODOT_okbtn, &btnx, &btny)
        doclick(btnx, btny)
    }
  }
})

; #+s::^PrintScreen

; close testing.ahk
$^CtrlBreak::{
  a := A_DetectHiddenWindows
  DetectHiddenWindows(1)
  if WinExist("\" "testing.ahk" " - AutoHotkey v" A_AhkVersion) {
    DetectHiddenWindows(1)
    try WinClose(WinExist("\" "testing.ahk" " - AutoHotkey v" A_AhkVersion))
  } else {
    Send("^{CtrlBreak}")
  }
  DetectHiddenWindows(a)
}

; LWin::^!+NumpadSub

; type clip text
SetKeyDelay(0, 0)
^!v::{
  SendDll("{ctrl up}{alt up}{v up}")
  text := A_Clipboard.replace("`r`n", "`n").split("")
  for i in text {
    SendInput("{raw}" i)
    ; Sleep(1)
  }
}

; type clip text but slower
^+!v::{
  SendDll("{ctrl up}{alt up}{v up}")
  text := A_Clipboard.replace("`r`n", "`n").split("")
  for i in text {
    SendInput("{raw}" i)
    Sleep(100)
  }
}

; change volume step
#InputLevel 100
$*Volume_Down::SoundSetVolume(SoundGetVolume() - 1)
$*Volume_Up::SoundSetVolume(SoundGetVolume() + 1)
#InputLevel

; hider
HIDER_ui := Gui()
HIDER_ui.BackColor := "000000"
HIDER_ui.Opt("-Caption +AlwaysOnTop")
HIDER_ui.Title := "BlackScreen"
HIDER_on := false

tasks.Push(() {
  global HIDER_on
  if (HIDER_on) {
    HIDER_ui.Show("W" . A_ScreenWidth . " H" . A_ScreenHeight + 100)
    ; WinSetTransparent(200, HIDER_ui)
  } else {
    HIDER_ui.hide()
  }
})

^numpad9::{
  global HIDER_on
  HIDER_on := true
  HIDER_ui.Show("W" . A_ScreenWidth . " H" . A_ScreenHeight + 100)
}

^Numpad8::{
  global HIDER_on
  HIDER_on := false
  HIDER_ui.hide()
}

#HotIf WinActive('ahk_exe Cookie Clicker.exe')
F11::WinMove(1340, 774, 500, 300)
#HotIf

#down::{
  try WinMinimize("a")
}

#!$LButton up::send("{LButton down}")
#!$RButton up::send("{RButton down}")
#HotIf WinActive('ahk_exe brave.exe')
F1::f24
#HotIf
; allow resize
*#q::try WinSetStyle('+0x40000', 'a')
; ^+q:: WinSetStyle('-0x40000', 'a')
; ^+f:: WinMove(100, 100, 500, 500, "a")

if WinExist("ahk_exe ShaderGlass.exe ahk_class SHADERGLASS")
  ProcessClose("ShaderGlass.exe")
DllCall("ShowCursor", "UInt", 1)
^esc::argReload()
^+!/::{
  win := "ahk_exe ShaderGlass.exe ahk_class SHADERGLASS"
  DllCall("ShowCursor", "UInt", 1)

  DetectHiddenWindows(0)
  if WinExist(win)
    WinHide(win)
  else {
    DetectHiddenWindows(1)
    if WinExist(win) {
      WinShow(win)
    } else {
      a := WinExist("a")
      Run("`"D:\programs\shaderglass\ShaderGlass.exe`" inwhi.sgp", "D:\programs\shaderglass", "NoActivate")
      WinWait(win)
      WinMove(0, 0, A_ScreenWidth, A_ScreenHeight, win)
      ControlSend("{shift up}{ctrl up}{alt up}{/ up}m", , win)
      ControlSend("{win down}", , win)
      WinSetStyle("-0xC40000 +E0x20", win) ; -0xC40000 - no title bar
      WinSetExStyle("+0x80", win) ; +0x80 not in taskbar
      WinSetAlwaysOnTop(1, win)
      ; MsgBox(JSON.stringify(WinGetList("ahk_exe ShaderGlass.exe")))
      SetTimer(() {
        try {
          WinSetAlwaysOnTop(1, win)
          WinSetStyle("-0xC40000 +E0x20", win) ; -0xC40000 - no title bar
          WinSetExStyle("+0x80", win) ; +0x80 not in taskbar
        }
        catch
          settimer(, 0)
      }, 50)
      if WinExist(a)
        WinActivate(a)
      DetectHiddenWindows(1)
    }
  }
  DetectHiddenWindows(1)

  ; if WinExist(win)
  ;   ProcessClose("ShaderGlass.exe")
  ; else {
  ;   a := WinExist("a")
  ;   Run("`"D:\programs\shaderglass\ShaderGlass.exe`" inwhi.sgp", "D:\programs\shaderglass", "NoActivate")
  ;   WinWait(win)
  ;   WinMove(0, 0, A_ScreenWidth, A_ScreenHeight, win)
  ;   ControlSend("{shift up}{ctrl up}{alt up}{/ up}m", , win)
  ;   ControlSend("{win down}", , win)
  ;   WinSetStyle("-0xC40000 +E0x20", win) ; -0xC40000 - no title bar
  ;   WinSetExStyle("+0x80", win) ; +0x80 not in taskbar
  ;   WinSetAlwaysOnTop(1, win)
  ;   ; MsgBox(JSON.stringify(WinGetList("ahk_exe ShaderGlass.exe")))
  ;   SetTimer(() {
  ;     try {
  ;       WinSetAlwaysOnTop(1, win)
  ;       WinSetStyle("-0xC40000 +E0x20", win) ; -0xC40000 - no title bar
  ;       WinSetExStyle("+0x80", win) ; +0x80 not in taskbar
  ;     }
  ;     catch
  ;       settimer(, 0)
  ;   }, 50)
  ;   if WinExist(a)
  ;     WinActivate(a)
  ;   DetectHiddenWindows(1)
  ; }
}
tasks.Push(() {
  try WinClose("Authorization required ahk_exe javaw.exe ahk_class SunAwtDialog")
})

ctrlXAfterZCooldown_NOW := 0
$~^z::{
  global ctrlXAfterZCooldown_NOW
  ctrlXAfterZCooldown_NOW := A_TickCount
}

#HotIf A_TickCount - ctrlXAfterZCooldown_NOW < 700
^x::{
}
#HotIf
ctrlZAfterXCooldown_NOW := 0
$~^x::{
  global ctrlZAfterXCooldown_NOW
  ctrlZAfterXCooldown_NOW := A_TickCount
}

#HotIf A_TickCount - ctrlZAfterXCooldown_NOW < 700
^z::{
}
#HotIf
tasks.Push(() {
  ; ClassNN:	DirectUIHWND1
  w := "VSCodium ahk_class #32770"
  if WinExist(w) and !ControlGetHwnd("Button3", w) {
    WinActivate(w)
    WinKill(w)
    send("+!g")
  }
})

; godot auto export
tasks.Push(() {
  win := WinExist("Export ahk_class Engine")
  if !win
    return
  WinActivate(win)
  ; MouseMove(148, 574, 0)
  ; Click()
  if not WinExist("Export ahk_class Engine")
    return
  win := WinWait("Export All ahk_class Engine")
  WinActivate(win)
  MouseMove(171, 70, 0)
  Click()
  if not WinExist("Export ahk_class Engine")
    return
  WinWaitClose("Export All ahk_class Engine")
  while win := WinExist("Export ahk_class Engine") {
    WinActivate(win)
    if WinExist("Export ahk_class Engine")
      MouseMove(759, 572, 0)
    if WinExist("Export ahk_class Engine")
      Click()
    Sleep(100)
  }
})

#HotIf

; _1p := 0
; ; SetTimer(() {
; ;   global _1p
; ;   _1p := GetKeyState("1", "p")
; ; }, 9000)

; #hotif _1p
; *$~Ctrl::
; *$~Shift::
; *$~LWin::
; *$~Alt::{
;   if _1p
;     SendDll("{1 up}")
; }

; MsgBox(1)

; $^#Numpad1 up::
; $^#Numpad2 up::
; $^#Numpad3 up::
; $^#Numpad4 up::
; $^#Numpad5 up::
; $^#Numpad6 up::
; $^#Numpad7 up::
; $^#Numpad8 up::
; $^#Numpad9 up::

run('D:\programs\nirsoft\SoundVolumeView\SoundVolumeView.exe /setvolume "discord" 25')
if RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", "Discord", 0) {
  RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", "Discord")
  run('"D:\programs\betterdiscord cli installer\cli.exe" install stable')
  ; run("C:\Users\User\Downloads\Applications\Windows\BetterDiscord-Windows.exe")
}

#HotIf WinActive('ahk_exe explorer.exe')
^+b::{
  send("^lcmd{enter}")
  if WinWaitActive("ahk_exe WindowsTerminal.exe", , 1) {
    pass := envget("sshpass")
    send("git add .{enter}git commit -m `"no message set`"{enter}" pass "{enter}git push{enter}" pass "{Enter}")
  }
}
#HotIf

$^+v::{
  start := A_Clipboard
  A_Clipboard := A_Clipboard.replace("\", "/")
  SendDll("{shift up}{ctrl up}^v")
  if GetKeyState("ctrl", 'p') {
    SendDll("{ctrl down}")
  }
  if GetKeyState("shift", 'p') {
    SendDll("{shift down}")
  }
  Sleep(100)
  if !GetKeyState("ctrl", 'p') {
    SendDll("{ctrl up}")
  }
  if !GetKeyState("shift", 'p') {
    SendDll("{shift up}")
  }
}
if WinExist("YasbBar ahk_class Qt691QWindowToolSaveBits")
  WinSetAlwaysOnTop(1,)

^+q::{
  WinClose("a")
}

^!+t::{
  if WinActive("ahk_exe explorer.exe ahk_class CabinetWClass")
    SendDll("{alt up}{shift up}^lcmd /k sudo{enter}")
  else
    Run("cmd")
}
