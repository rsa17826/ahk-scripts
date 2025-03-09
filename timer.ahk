#Requires AutoHotkey v2.0
#SingleInstance Force

; must include
#Include <AutoThemed>

#Include <base> ; Array as base, Map as base, String as base, File as F, JSON

#Include <Misc> ; print, range, swap, ToString, RegExMatchAll, Highlight, MouseTip, WindowFromPoint, ConvertWinPos, WinGetInfo, GetCaretPos, IntersectRect
#Include <toast> ; toast - show msgs at Bottom of screen to alert user

#Include <betterui> ; betterui

; #Include <desktop switcher>

#Include <textfind> ; FindText, setSpeed, doClick

; #Include <protocol> ; PROTO - listen for web protocols - requires admin

#Include <TTS> ; TTS - text to speech

; tomorrow:=today:=A_Now
; tomorrow := DateAdd(tomorrow, 1, 'day')
; today_ddd := FormatTime(today, "ddd")
; tomorrow_ddd := FormatTime(tomorrow, "ddd")
times := []
; Switch A_DDD, 0 {
;   Case "mon":
;     times := [[9, 0, 0, "room 127 - itn 101"], [10, 20, 0, "return home"], [1, 25, 1, "eng 163 - ede 11/eng 111"], [3, 25, 1, "school ends"]]
;   Case "tue":
;     times := [[9, 0, 0, "room 150 - csc 221"], [10, 20, 0, "class ends"], [12, 0, 0, "room 150 - csc 110"], [1, 20, 1, "small break"], [1, 30, 1, "room 150 - sdv 101"], [3, 10, 1, "school ends"]]
;   Case "wed":
;     times := [[9, 0, 0, "room 127 - itn 101"], [10, 20, 0, "return home"], [1, 25, 1, "close 163 - ede 11/eng 111"], [3, 25, 1, "school ends"]]
;   Case "thu":
;     times := [[9, 0, 0, "room 150 - csc 221"], [10, 20, 0, "class ends"], [12, 0, 0, "room 150 - csc 110"], [1, 20, 1, "school ends"]]
;   Case "fri":
;     times := [[1, 25, 1, "eng 163 - ede 11/eng 111"], [3, 25, 1, "school ends"]]
; }
pasttimes := times.filter(e => howlonguntil(e) <= 0)
times := times.filter(e => howlonguntil(e) > 0) ; remove all past times
If !times.length
  ExitApp()
If pasttimes.length {
  temp := [pasttimes[pasttimes.length]]
  For t in times
    temp.push(t)
  times := temp
}

timers := []
ui := betterui({ aot: 1,
  clickthrough: 1,
  w: 50,
  h: 20,
  transparency: 200,
  gap: 5,
  showIcon: 0,
  tool:1
})
Loop times.Length {
  If A_Index == 1 {
    ui.SetFont("s15")
  } Else {
    ui.newLine()
    ui.setSize(, 18)
    ui.SetFont("s10")
  }
  ui.add("text", { o: "center w4x", text: times[A_Index][4] })
  ui.add("text", { o: "center" }, &t_imer)
  timers.push({ elem: t_imer, time: times[A_Index] })
}
ui.show("NoActivate")
WinGetPos(&ignore, &taskbarY, &ignore, &ignore, "ahk_class Shell_TrayWnd")
WinGetPos(&ignore, &ignore, &uiWidth, &uiHeight, ui)
; print(x, y, w, h)
; print(xx, yy, ww, hh)
ui.show("x" A_ScreenWidth - uiWidth ' y' taskbarY - uiHeight " NoActivate")
Loop {
  t_imer := timers[1]
  diff := howlonguntil(t_imer.time)
  If diff <= 0
    t_imer.elem.text := "NOW"
  Else
    t_imer.elem.text := Floor(diff / 60) ':' Mod(diff, 60)
  Loop timers.Length - 1 {
    t_imer := timers[A_Index + 1]
    diff := howlonguntil(t_imer.time)
    If diff <= 0 {
      ; MsgBox()
      Reload()
    }
    t_imer.elem.text := Floor(diff / 60) ':' Mod(diff, 60)
  }
  Sleep(1000)
}
howlonguntil(time) {
  endh := time[1] + (time[3] * 12)
  endm := time[2]
  end := endm + (endh * 60)

  nowh := A_Now[9, 10]
  nowm := A_Now[11, 12]
  now := nowm + (nowh * 60)
  diff := end - now
  Return diff
}
