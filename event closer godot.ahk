; #NoTrayIcon
#SingleInstance Force
#Requires AutoHotkey v2.0
#Include <textfind>
; TraySetIcon("D:\.ico\opened files view.ico")

; tryfind(text, x, y) {
;   return FindText(x, y, 513 - 150000, 425 - 150000, 513 + 150000, 425 + 150000, 0, 0, text)
; }
; doclick(x, y, back := 1, time := 100) {
;   FindText().Click(x, y, "L", "D", back)
;   sleep(time)
;   FindText().Click(x, y, "L", "U", back)
; }