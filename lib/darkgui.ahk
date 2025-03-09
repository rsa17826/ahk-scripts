#Requires AutoHotkey v2.0
#Include <Misc>
#SingleInstance Force

guishow := gui.Prototype.show
gui.Prototype := darkgui.Prototype

class darkgui extends gui {
  show(opts := "") {
    if RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize", "AppsUseLightTheme", 1)
      return
    DarkColors := Map("Background", "0x202020", "Controls", "0x404040", "Font", "0xE0E0E0")
    TextBackgroundBrush := DllCall("gdi32\CreateSolidBrush", "UInt", DarkColors["Background"], "Ptr")
    PreferredAppMode := Map("Default", 0, "AllowDark", 1, "ForceDark", 2, "ForceLight", 3, "Max", 4)
    if (VerCompare(A_OSVersion, "10.0.17763") >= 0) {
      DWMWA_USE_IMMERSIVE_DARK_MODE := 19
      if (VerCompare(A_OSVersion, "10.0.18985") >= 0) {
        DWMWA_USE_IMMERSIVE_DARK_MODE := 20
      }
      uxtheme := DllCall("kernel32\GetModuleHandle", "Str", "uxtheme", "Ptr")
      SetPreferredAppMode := DllCall("kernel32\GetProcAddress", "Ptr", uxtheme, "Ptr", 135, "Ptr")
      FlushMenuThemes := DllCall("kernel32\GetProcAddress", "Ptr", uxtheme, "Ptr", 136, "Ptr")
      DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", this.hWnd, "Int", DWMWA_USE_IMMERSIVE_DARK_MODE, "Int*", True, "Int", 4)
      DllCall(SetPreferredAppMode, "Int", PreferredAppMode["ForceDark"])
      DllCall(FlushMenuThemes)
      this.BackColor := DarkColors["Background"]
    }
    GWL_WNDPROC := -4
    GWL_STYLE := -16
    ES_MULTILINE := 0x0004
    LVM_GETTEXTCOLOR := 0x1023
    LVM_SETTEXTCOLOR := 0x1024
    LVM_GETTEXTBKCOLOR := 0x1025
    LVM_SETTEXTBKCOLOR := 0x1026
    LVM_GETBKCOLOR := 0x1000
    LVM_SETBKCOLOR := 0x1001
    LVM_GETHEADER := 0x101F
    GetWindowLong := A_PtrSize == 8 ? "GetWindowLongPtr" : "GetWindowLong"
    SetWindowLong := A_PtrSize == 8 ? "SetWindowLongPtr" : "SetWindowLong"
    Init := False
    LV_Init := False
    for hWnd, GuiCtrlObj in this {
      switch GuiCtrlObj.Type {
        case "Button", "CheckBox", "ListBox", "UpDown":
        {
          DllCall("uxtheme\SetWindowTheme", "Ptr", GuiCtrlObj.hWnd, "Str", "DarkMode_Explorer", "Ptr", 0)
        }
        case "ComboBox", "DDL":
        {
          DllCall("uxtheme\SetWindowTheme", "Ptr", GuiCtrlObj.hWnd, "Str", "DarkMode_CFD", "Ptr", 0)
        }
        case "Edit":
        {
          if (DllCall("user32\" GetWindowLong, "Ptr", GuiCtrlObj.hWnd, "Int", GWL_STYLE) & ES_MULTILINE) {
            DllCall("uxtheme\SetWindowTheme", "Ptr", GuiCtrlObj.hWnd, "Str", "DarkMode_Explorer", "Ptr", 0)
          } else {
            DllCall("uxtheme\SetWindowTheme", "Ptr", GuiCtrlObj.hWnd, "Str", "DarkMode_CFD", "Ptr", 0)
          }
        }
        case "ListView":
        {
          if !(LV_Init) {
            LV_TEXTCOLOR := SendMessage(LVM_GETTEXTCOLOR, 0, 0, GuiCtrlObj.hWnd)
            LV_TEXTBKCOLOR := SendMessage(LVM_GETTEXTBKCOLOR, 0, 0, GuiCtrlObj.hWnd)
            LV_BKCOLOR := SendMessage(LVM_GETBKCOLOR, 0, 0, GuiCtrlObj.hWnd)
            LV_Init := True
          }
          GuiCtrlObj.Opt("-Redraw")
          SendMessage(LVM_SETTEXTCOLOR, 0, DarkColors["Font"], GuiCtrlObj.hWnd)
          SendMessage(LVM_SETTEXTBKCOLOR, 0, DarkColors["Background"], GuiCtrlObj.hWnd)
          SendMessage(LVM_SETBKCOLOR, 0, DarkColors["Background"], GuiCtrlObj.hWnd)
          DllCall("uxtheme\SetWindowTheme", "Ptr", GuiCtrlObj.hWnd, "Str", "DarkMode_Explorer", "Ptr", 0)
          ; To color the selection - scrollbar turns back to normal
          ;DllCall("uxtheme\SetWindowTheme", "Ptr", GuiCtrlObj.hWnd, "Str", Mode_ItemsView, "Ptr", 0)
          ; Header Text needs some NM_CUSTOMDRAW coloring
          LV_Header := SendMessage(LVM_GETHEADER, 0, 0, GuiCtrlObj.hWnd)
          DllCall("uxtheme\SetWindowTheme", "Ptr", LV_Header, "Str", "DarkMode_ItemsView", "Ptr", 0)
          GuiCtrlObj.Opt("+Redraw")
        }
      }
    }
    ; if !(Init) {
      ; https://www.autohotkey.com/docs/v2/lib/CallbackCreate.htm#ExSubclassGUI
      WindowProcNew := CallbackCreate(___WindowProc(hwnd, uMsg, wParam, lParam) {
        critical()
        WM_CTLCOLOREDIT := 0x0133
        WM_CTLCOLORLISTBOX := 0x0134
        WM_CTLCOLORBTN := 0x0135
        WM_CTLCOLORSTATIC := 0x0138
        DC_BRUSH := 18
        switch uMsg {
          case WM_CTLCOLOREDIT, WM_CTLCOLORLISTBOX:
            DllCall("gdi32\SetTextColor", "Ptr", wParam, "UInt", DarkColors["Font"])
            DllCall("gdi32\SetBkColor", "Ptr", wParam, "UInt", DarkColors["Controls"])
            DllCall("gdi32\SetDCBrushColor", "Ptr", wParam, "UInt", DarkColors["Controls"], "UInt")
            return DllCall("gdi32\GetStockObject", "Int", DC_BRUSH, "Ptr")
          case WM_CTLCOLORBTN:
            DllCall("gdi32\SetDCBrushColor", "Ptr", wParam, "UInt", DarkColors["Background"], "UInt")
            return DllCall("gdi32\GetStockObject", "Int", DC_BRUSH, "Ptr")
          case WM_CTLCOLORSTATIC:
            DllCall("gdi32\SetTextColor", "Ptr", wParam, "UInt", DarkColors["Font"])
            DllCall("gdi32\SetBkColor", "Ptr", wParam, "UInt", DarkColors["Background"])
            return TextBackgroundBrush
        }
        return DllCall("user32\CallWindowProc", "Ptr", WindowProcOld, "Ptr", hwnd, "UInt", uMsg, "Ptr", wParam, "Ptr", lParam)
      }) ; Avoid fast-mode for subclassing.
      WindowProcOld := DllCall("user32\" SetWindowLong, "Ptr", this.Hwnd, "Int", GWL_WNDPROC, "Ptr", WindowProcNew, "Ptr")
      Init := True
    ; }
    guishow.call(this, opts)
  }
}
