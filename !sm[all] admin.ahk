#Requires AutoHotkey v2.0
#SingleInstance Force
; #NoTrayIcon
#Include *i <AutoThemed>
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
  WinKill("A")
}

; audacity dont save
#hotif WinActive("ahk_exe audacity.exe")
  !F4::{
    try ProcessClose("audacity.exe")
  }
  tasks.push(() {
    if !winactive("Save changes to")
      return
    ControlClick('Button2', "Save changes to")
    sleep(10)
  })
#hotif

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
  if !WinExist("Automatic Crash Recovery")
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

; ControlGetClassNN("Button4", "Cheat Engine 7.5") ; enable
#HotIf WinExist("Cheat Engine 7.5")
  ^numpad1::cheatengine_setspeed('1')
  ^numpad2::cheatengine_setspeed('1.7')
  ^numpad3::cheatengine_setspeed('3')
  ^numpad4::cheatengine_setspeed('50')
  ^numpad0::cheatengine_setspeed('0')
  cheatengine_setspeed(speed) {
    lastwin := WinGetPID('A')
    ControlSetText(speed, "Edit1", "Cheat Engine 7.5")
    ControlClick("Button3", "Cheat Engine 7.5")
    WinActivate('ahk_pid ' . lastwin)
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
    text := (
      ; "process name: " WinGetProcessName("ahk_id " lParam)
      ; "`nprocess path: " WinGetProcessPath("ahk_id " lParam)
      ; "`nwindow title: " WinGetTitle("ahk_id " lParam)
      ; "`n"
      WinGetInfo("ahk_id " lParam)
      .RegExReplace("TransColor:[\s\S]*$", '`n`n')
      .split("`n")
      .filter(e =>
        !(e.startsWith("ahk_id") or e.startsWith("ahk_pid") or e.startsWith("Screen position")))).join("`n")
    try IniWrite(text, "c:\users\user\openedwindows.ini", "opened windows: " A_Now)
    todark("ahk_id " lParam)
  } catch {
    try IniWrite("failed to get window", "c:\users\user\openedwindows.ini", "opened windows: " A_Now)
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

; allow resize
#q::WinSetStyle('+0x40000', 'a')
; ^+q:: WinSetStyle('-0x40000', 'a')
; ^+f:: WinMove(100, 100, 500, 500, "a")

tasks.Push()

#HotIf WinActive('ahk_exe explorer.exe')
  !del::{
    ecount := WinGetCount("ahk_exe explorer.exe")
    send("!{enter}")
    sleep(400)
    if ecount == WinGetCount("ahk_exe explorer.exe")
      return
    temp := A_Clipboard
    send("{tab}")
    sleep(100)
    send("^c")
    i := 0
    while i < 30 && A_Clipboard == temp {
      Sleep(100)
      i++
    }
    if i >= 30
      return
    FileRecycle(A_Clipboard
      .RegExReplace("`"$", "")
      .RegExReplace("^`"", "")
      .RegExReplace("\\$", ""))
    A_Clipboard := temp
    send("{esc}")
    sleep(200)
    send("{del}")
    ; ecount := WinGetCount("ahk_exe explorer.exe")
    ; win1 := WinGetList("ahk_exe explorer.exe")[1]
    ; send("{tab}{tab}{tab}{tab}{tab}f!{up}")
    ; while ecount == WinGetCount("ahk_exe explorer.exe") {
    ; }
    ; sleep(700)
    ; send("!{tab}{Esc}{Esc}{Esc}{Esc}{Esc}{Esc}{Esc}")
    ; win2 := WinGetList("ahk_exe explorer.exe")[1]
    ; send("!{up}")
    ; sleep(500)
    ; WinActivate(win2)
    ; WinClose(win2)
    ; send("!{F4}")
    ; WinClose("ahk_id " win2)
    ; send("{del}")
  }

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
  if WinExist("KeePassOTP ahk_exe KeePass.exe") {
    WinClose("KeePassOTP ahk_exe KeePass.exe")
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
GODOT_eventopened := "|<>*125$183.zzzzzzzzzzzzzzzzzzzzUbzzzzzzzz0zDzzs1zzzzzzzzUTzzzs8zzzzzzzzs3tzzz0Dzzzzznzs1zzzz7bzzzzzzzz0DDzzszzzzzzyTy6Tzzzszzzzzzzzzs1twDz7swQ7YD0TlzkT8S17V6DC8sTV17C0Tsz770Q0M3wTw1s0U8s0ltk41s08tlXz0MsllVXXzXz37377766DC1X761XASDs3XCCAQQTwTsssssslsltkswlsANXlz7wFk1XXXzXz777776D6DCD06D1lASDszmC0AQQTwTsssssslsltls0lsD1Xlz7y3lzXXXzVz777776D6CCD7yD1sCATszkSDwQQTy7MMssssskkllwSskDVk3z0D3s3XXUTs3UD7777070CDU701wDVzs1szUQQS3zUS3ssssw8w9lz1w8zzzzzzzzzzzzzzzzzzzzzzzDzzzzzzzzzzzzzzzzzzzzzzzzzzzzvlzzzzzzzzzzzzzzzzzzzzzzzzzzzzz0Dzzzzzzzzzzzzzzzzzzzzzzzzzzzzs7zzzzzzzU"
GODOT_okbtn := "|<ok btn>*56$32.Tzzzzjzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw3nXzy0Qlzzbn8zztwkTzwTADzz7n1zztwmDzyTAnzzU7CTzw3nXzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzxzzzzyU"
tasks.Push(() {
  ; if !WinActive("ahk_class Engine")
  ;   continue
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
      doclick(btnx, btny)
    } catch {
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