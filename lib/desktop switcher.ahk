#Requires Autohotkey v2.0
#SingleInstance Force
#Include <misc>
#Include <vars>
KeyHistory(0)
SendMode("Input")
DesktopCount := 2
CurrentDesktop := 1
LastOpenedDesktop := 1
hVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", a_lineDir "\desktop switcher\VirtualDesktopAccessor.dll", "Ptr")
global IsWindowOnDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "IsWindowOnDesktopNumber", "Ptr")
global MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "MoveWindowToDesktopNumber", "Ptr")
global GoToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GoToDesktopNumber", "Ptr")
SetKeyDelay(75)
mapDesktopsFromRegistry()
mapDesktopsFromRegistry() {
  global CurrentDesktop, DesktopCount
  IdLength := 32
  SessionId := getSessionId()
  if (SessionId) {
    try {
      CurrentDesktopId := RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops", "CurrentVirtualDesktop")
    } catch {
      CurrentDesktopId := RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\" SessionId "\VirtualDesktops", "CurrentVirtualDesktop")
    }

    if (CurrentDesktopId) {
      IdLength := StrLen(CurrentDesktopId)
    }
  }
  DesktopList := RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops", "VirtualDesktopIDs")
  if (DesktopList) {
    DesktopListLength := StrLen(DesktopList)
    DesktopCount := floor(DesktopListLength / IdLength)
  } else {
    DesktopCount := 1
  }
  i := 0
  while (CurrentDesktopId and i < DesktopCount) {
    StartPos := (i * IdLength) + 1
    DesktopIter := SubStr(DesktopList, (StartPos) < 1 ? (StartPos) - 1 : (StartPos), IdLength)
    if (DesktopIter = CurrentDesktopId) {
      CurrentDesktop := i + 1
      break
    }
    i++
  }
}
getSessionId() {
  try {
    ProcessId := DllCall("GetCurrentProcessId", "UInt")
  } catch Error as err {
    print("Error getting current process id: " err)
    return
  }
  try {

    SessionId := DllCall("ProcessIdToSessionId", "UInt", ProcessId, "UInt*", 0)
  } catch Error as err {
    print(err)
    return
  }
  return SessionId
}

_switchDesktopToTarget(targetDesktop) {
  global CurrentDesktop, DesktopCount, LastOpenedDesktop
  if (targetDesktop > DesktopCount || targetDesktop < 1 || targetDesktop == CurrentDesktop) {
    print("[invalid] target: " targetDesktop " current: " CurrentDesktop)
    return
  }

  LastOpenedDesktop := CurrentDesktop
  WinActivate("ahk_class Shell_TrayWnd")

  DllCall(GoToDesktopNumberProc, "Int", targetDesktop - 1)
  Sleep(50)
  focusTheForemostWindow(targetDesktop)
}

updateGlobalVariables() {
  mapDesktopsFromRegistry()
}

switchDesktopByNumber(targetDesktop) {
  global CurrentDesktop, DesktopCount
  updateGlobalVariables()
  _switchDesktopToTarget(targetDesktop)
}

switchDesktopToLastOpened() {
  global CurrentDesktop, DesktopCount, LastOpenedDesktop
  updateGlobalVariables()
  _switchDesktopToTarget(LastOpenedDesktop)
}

switchDesktopToRight() {
  global CurrentDesktop, DesktopCount
  updateGlobalVariables()
  _switchDesktopToTarget(CurrentDesktop == DesktopCount ? 1 : CurrentDesktop + 1)
}

switchDesktopToLeft() {
  global CurrentDesktop, DesktopCount
  updateGlobalVariables()
  _switchDesktopToTarget(CurrentDesktop == 1 ? DesktopCount : CurrentDesktop - 1)
}

focusTheForemostWindow(targetDesktop) {
  foremostWindowId := getForemostWindowIdOnDesktop(targetDesktop)
  if isWindowNonMinimized(foremostWindowId) {
    WinActivate("ahk_id " foremostWindowId)
  }
}

isWindowNonMinimized(windowId) {
  MMX := WinGetMinMax("ahk_id " windowId)
  return MMX != -1
}

getForemostWindowIdOnDesktop(n) {
  n := n - 1
  owinIDList := WinGetlist(, , ,)
  awinIDList := Array()
  winIDList := owinIDList.Length
  for v in owinIDList {
    awinIDList.Push(v)
  }
  loop awinIDList.Length {
    windowID := awinIDList[A_Index]
    windowIsOnDesktop := DllCall(IsWindowOnDesktopNumberProc, "UInt", windowID, "UInt", n)
    if (windowIsOnDesktop == 1) {
      return windowID
    }
  }
}

MoveCurrentWindowToDesktop(desktopNumber) {
  activeHwnd := WinGetID("A")
  DllCall(MoveWindowToDesktopNumberProc, "UInt", activeHwnd, "UInt", desktopNumber - 1)
  switchDesktopByNumber(desktopNumber)
}

MoveCurrentWindowToRightDesktop() {
  global CurrentDesktop, DesktopCount
  updateGlobalVariables()
  activeHwnd := WinGetID("A")
  DllCall(MoveWindowToDesktopNumberProc, "UInt", activeHwnd, "UInt", (CurrentDesktop == DesktopCount ? 1 : CurrentDesktop + 1) - 1)
  _switchDesktopToTarget(CurrentDesktop == DesktopCount ? 1 : CurrentDesktop + 1)
}

MoveCurrentWindowToLeftDesktop() {
  global CurrentDesktop, DesktopCount
  updateGlobalVariables()
  activeHwnd := WinGetID("A")
  DllCall(MoveWindowToDesktopNumberProc, "UInt", activeHwnd, "UInt", (CurrentDesktop == 1 ? DesktopCount : CurrentDesktop - 1) - 1)
  _switchDesktopToTarget(CurrentDesktop == 1 ? DesktopCount : CurrentDesktop - 1)
}
createVirtualDesktop() {
  global CurrentDesktop, DesktopCount
  Send("#^d")
  DesktopCount++
  CurrentDesktop := DesktopCount
}
deleteVirtualDesktop() {
  global CurrentDesktop, DesktopCount, LastOpenedDesktop
  Send("#^{F4}")
  if (LastOpenedDesktop >= CurrentDesktop) {
    LastOpenedDesktop--
  }
  DesktopCount--
  CurrentDesktop--
}
