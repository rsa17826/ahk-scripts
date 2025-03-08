#Requires AutoHotkey v2.0
#SingleInstance Force

; must include
SetWorkingDir(A_ScriptDir)
#Include *i <AutoThemed>
#Include <vars>

#Include <base> ; Array as base, Map as base, String as base, File as F, JSON

#Include <Misc> ; print, range, swap, ToString, RegExMatchAll, Highlight, MouseTip, WindowFromPoint, ConvertWinPos, WinGetInfo, GetCaretPos, IntersectRect
; Computer\HKEY_CURRENT_USER\Software\Classes\*\shell\Detect It Easy\command
; Computer\HKEY_CURRENT_USER\Software\Classes\*\shell\tree\command
; Computer\HKEY_CURRENT_USER\Software\Classes\*\shell\Detect It Easy
; "C:\Users\User\Desktop\customcmd\treemaker\treemaker.exe"
#Include <admin>
switch MsgBox("`"yes`" to add new key or `"no`" to remove key", "", "0x3"), 0 {
  case "cancel":
    ExitApp()
  case "yes":
    name := InputBox("name", , , A_Clipboard)
    if "cancel" = name.Result
      ExitApp()
    name := name.Value.replace("\", '')
    _path := InputBox("path", , , A_Clipboard)
    if "cancel" = _path.Result
      ExitApp()
    _path := _path.Value
    ; RegCreateKey("hkcr\Directory\shell\" name)
    ; settype := InputBox("enter the file extension to add to, * for all files, or Cancel to add to folders")
    ; if "cancel" = settype.Result {
      RegWrite("`"" _path "`" `"%1`"", "REG_SZ", "hkcr\Directory\shell\" name "\command")
    ;   ExitApp()
    ; }
    ; settype := settype.Value
    ; if !settype.startsWith(".")
    ;   settype := '.' settype
    ; RegWrite("`"" path "`" `"%1`"", "REG_SZ", "hkcu\Software\Classes\" settype '\shell\' name "\command")
    ; print(settype)
    ; case "no":
    ;   loop reg "hkcr\Directory\shell", "k" {
    ;     ; settype := InputBox("enter the file extension to remove from, no ., or Cancel to remove from folders", "", "0x4")
    ;     ; if "cancel" = settype.Result {
    ;     ;   RegWrite("`"" path "`" `"%1`"", "REG_SZ", "hkcr\Directory\shell\" name "\command")
    ;     ;   ExitApp()
    ;     ; }
    ;     ; settype := settype.Value
    ;     msg := MsgBox("delete " A_LoopRegName "?", , "0x3")
    ;     if msg = "cancel"
    ;       ExitApp()
    ;     if 'yes' = msg {
    ;       A_Clipboard := "deleting hkcr\Directory\shell\" A_LoopRegName " = " RegRead("hkcr\Directory\shell\" A_LoopRegName "\command")
    ;       RegDeleteKey("hkcr\Directory\shell\" A_LoopRegName)
    ;       ExitApp()
    ;     }
    ;   }

  default:
    MsgBox(MsgBox("failed", "", "0x3"))
}
;   RegDeleteKey()
