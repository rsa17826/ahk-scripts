#Requires AutoHotkey v2.0
#SingleInstance Force

#Include *i <AutoThemed>

try TraySetIcon("icon.ico")
SetWorkingDir(A_ScriptDir)
#Include *i <vars>

#Include <Misc>

#Include *i <betterui> ; betterui

#Include *i <textfind> ; FindText, setSpeed, doClick

; #Include *i <CMD> ; CMD - cmd.exe - broken?

; WinActivate("ahk_exe flashplayer_32_sa.exe")
; ; up()
; while 1 {
;   if !WinActive("ahk_exe flashplayer_32_sa.exe")
;     continue
;   SendDll("{x up}{z down}{x down}")
;   Sleep(10)
; }
; down() {
;   if WinActive("ahk_exe flashplayer_32_sa.exe")
;     SendDll("{up up}{down down}")
;   SetTimer(up, -1500)
; }
; up() {
;   if WinActive("ahk_exe flashplayer_32_sa.exe")
;     SendDll("{up down}{down up}")
;   SetTimer(down, -1500)
; }

keyType.invert("q", 1)
keyType.toggle("w")
keyType.turbo("e")
keyType.invert("r", 1)
keyType.expire("r", 1000)
keyType.set("r", keyType.expire, keyType.invert)
; add expire to any key type
nullfunc := (*) {

}
; while 1
;   ListHotkeys()
;rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
;
;
;

class hk {
  static hotkeys := {}
  static addHotkey(key, cb?, opts?, data?) {
    Hotkey(key, cb?, opts?)
    simplekey := key.replace("~", "")
    if IsSet(cb) {
      if !hk.hotkeys.HasProp(simplekey)
        hk.hotkeys.%simplekey% := []
      hk.hotkeys.%simplekey%.push([key, cb?, opts?, data?])
    } else {
      hk.hotkeys.DeleteProp(simplekey)
    }
    Print(hk.hotkeys)
  }
  static restore(key) {
    try {
      hk.hotkeys.%key%.pop()
      data := hk.hotkeys.%key%[-1]
    }
    if IsSet(data)
      Hotkey(data[1]?, data[2]?, data[3]?)
    else {
      Hotkey(key)
      Hotkey(key, , "off")
    }
  }
}
keyType.block("f", , Print)
; while 1
;   ListHotkeys()
class keyType {
  static set(key, types*){
    
  }
  ; stops user from pressing key and calls onup when the user releases key onup deactivates when key unblocked
  static block(key, on := 1, onup := nullfunc) {
    static blocker := (*) {
    }
    if on {
      hk.addHotkey("*$" key, blocker, "on p9", "blocker")
      hk.addHotkey("*$" key " up", onup, "on p9", "blocker")
    } else {
      hk.restore("*$" key)
      hk.restore("*$" key " up")
    }
  }
  static unblock(key) {
    keyType.block(key, 0)
  }
  static expire(key, delay) {
    keyStartTime := 0
    hk.addHotkey("~*$" key, (a*) {
      keyStartTime := A_TickCount
      while A_TickCount - keyStartTime < delay and GetKeyState(key, "p") {
        ; print(A_TickCount - keyStartTime)
      }
      SendDll("{" key " up}")
      Send("{" key " up}")
      if GetKeyState(key, "p")
        keyType.block(key, , (*) {
          Print("UP!!")
          keyType.unblock(key)
        })

      ; while GetKeyState(key, "p") {
      ;   SendDll("{" key " up}")
      ; }
    }, , "main")
  }
  static invert(key, startUnpressed := 0) {
    if startUnpressed
      send("{" key " up}")
    else if !GetKeyState(key, "p")
      send("{" key " down}")
    hk.addHotkey("*$" key, (a*) {
      Send("{" key " up}")
    })
    hk.addHotkey("*$" key " up", (a*) {
      Send("{" key " down}")
    })
    OnExit((*) {
      send("{" key " up}")
    })
  }
  static toggle(key) {
    pressed := GetKeyState(key, "p")
    hk.addHotkey("*$" key, (a*) {
      if pressed
        Send("{" key " up}")
      else
        Send("{" key " down}")
      pressed := !pressed
    })
    OnExit((*) {
      send("{" key " up}")
    })
  }
  static turbo(key) {
    pressed := GetKeyState(key, "p")
    hk.addHotkey("*$" key, (a*) {
      while GetKeyState(key, "p") {
        Send("{" key " down}")
        Send("{" key " up}")
        ; Sleep(10)
      }
    })
    OnExit((*) {
      send("{" key " up}")
    })
  }
}
