/*

OnMouseEvent emitter.

Based on MouseDelta by evilC
https://github.com/evilC/AHK-Random-Musings/blob/master/MouseDelta/MouseDelta.ahk

Only one window per raw input device class may be registered to receive raw input within a process (the window passed in the last call to RegisterRawInputDevices). Because of this, RegisterRawInputDevices should not be used from a library, as it may interfere with any raw input processing logic already present in applications that load it.
https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-registerrawinputdevices

https://docs.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-rawmouse

Flags
	The mouse state. This member can be any reasonable combination of the following:
	MOUSE_MOVE_RELATIVE 0x00
		Mouse movement data is relative to the last mouse position.
		If MOUSE_MOVE_RELATIVE value is specified, lLastX and lLastY specify movement relative to the previous mouse event (the last reported position). Positive values mean the mouse moved right (or down); negative values mean the mouse moved left (or up).
	MOUSE_MOVE_ABSOLUTE 0x01
		Mouse movement data is based on absolute position.
		If MOUSE_MOVE_ABSOLUTE value is specified, lLastX and lLastY contain normalized absolute coordinates between 0 and 65,535. Coordinate (0,0) maps onto the upper-left corner of the display surface; coordinate (65535,65535) maps onto the lower-right corner. In a multimonitor system, the coordinates map to the primary monitor.
	MOUSE_VIRTUAL_DESKTOP 0x02
		Mouse coordinates are mapped to the virtual desktop (for a multiple monitor system).
		If MOUSE_VIRTUAL_DESKTOP is specified in addition to MOUSE_MOVE_ABSOLUTE, the coordinates map to the entire virtual desktop.
	MOUSE_ATTRIBUTES_CHANGED 0x04
		Mouse attributes changed; application needs to query the mouse attributes.
	MOUSE_MOVE_NOCOALESCE 0x08
		This mouse movement event was not coalesced. Mouse movement events can be coalesced by default.
		Windows XP/2000: This value is not supported.

Padding
	Always 0. Aligns ULONG ulButtons, which is "reserved", to 4 bytes.

ButtonFlags
	The transition state of the mouse buttons. This member can be one or more of the following values:
	RI_MOUSE_BUTTON_1_DOWN 0x0001
	RI_MOUSE_BUTTON_1_UP 0x0002
	RI_MOUSE_BUTTON_2_DOWN 0x0004
	RI_MOUSE_BUTTON_2_UP 0x0008
	RI_MOUSE_BUTTON_3_DOWN 0x0010
	RI_MOUSE_BUTTON_3_UP 0x0020
	RI_MOUSE_BUTTON_4_DOWN 0x0040
	RI_MOUSE_BUTTON_4_UP 0x0080
	RI_MOUSE_BUTTON_5_DOWN 0x0100
	RI_MOUSE_BUTTON_5_UP 0x0200
		Button state changed.
	RI_MOUSE_WHEEL 0x0400
		Raw input comes from a mouse wheel. The wheel delta is stored in usButtonData.
		A positive value indicates that the wheel was rotated forward, away from the user; a negative value indicates that the wheel was rotated backward, toward the user.
	RI_MOUSE_HWHEEL 0x0800
		Raw input comes from a horizontal mouse wheel. The wheel delta is stored in usButtonData.
		A positive value indicates that the wheel was rotated to the right; a negative value indicates that the wheel was rotated to the left.
		Windows XP/2000: This value is not supported.

ButtonData
	If mouse wheel is moved, indicated by RI_MOUSE_WHEEL or RI_MOUSE_HWHEEL in usButtonFlags, then usButtonData contains a signed short value that specifies the distance the wheel is rotated.
	The wheel rotation will be a multiple of WHEEL_DELTA, which is set at 120. This is the threshold for action to be taken, and one such action (for example, scrolling one increment) should occur for each delta.
	For more information, read the article.

RawButtons
	The raw state of the mouse buttons. The Win32 subsystem does not use this member.
	i.e, always 0.

LastX
LastY
	The motion in the X and Y directions. This is signed relative motion or absolute motion, depending on the value of usFlags.

ExtraInformation
	The device-specific additional information for the event.

ThisMouse
	A handle to the device generating the raw input data (hDevice). This comes from the RAWINPUTHEADER.
	To get more information on the device, use hDevice in a call to GetRawInputDeviceInfo.
	Synthetic mouse events will come from device 0?
	Returns -1 if the DllCall fails for any reason (cargo cult code)

TODO:
	https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getrawinputdata
	https://docs.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-rawinputheader
	https://docs.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-rawinput
	This can be a LOT less scary and confusing

	pcbSize needs a VarRef, yes? Can a single VarRef be recycled all the time for that?
	Is that even necessary?

	MouseMovedReal() passes a property instead of a VarRef to a UInt* DllCall, is this fine?

	MouseMovedReal() fires the event whilst Critical, is this fine?
	Should a new object be created to hold the data or the event be called with actual arguments?
	(Reuse the object/buffer if the event finished firing before a new mouse event arrives, to avoid allocations)

; Released on the AHK forum in 2022-05-28

*/

; #include <Event>
class Event {
  Listeners := []

  ; Add a listener.
  ; addremove = 1 will add the function to the end of the list
  ; addremove = 0 will remove the listener if it is in the list
  ; addremove = -1 will add the function to the beginning of the list
  ; Return 1 if the first listener was added, -1 if the last listener was removed, 0 otherwise.
  ; The return value is intended to inform whether to start or stop whichever system will fire this event.
  OnFire(fn, addremove := 1) {
    if addremove == 1
      return (this.Listeners.Push(fn), this.Listeners.Length == 1)
    else if addremove == 0 {
      for i, v in this.Listeners
        if v == fn
          return (this.Listeners.RemoveAt(i), -(this.Listeners.Length == 0))
      return 0
    } else if addremove == -1
      return (this.Listeners.InsertAt(1, fn), this.Listeners.Length == 1)
    else
      throw(ValueError("Parameter #2 invalid", -1, addremove))
  }

  ; Call all listeners with args.
  ; Return nothing.
  Fire(args*) {
    ; warning: it's possible to modify the array during traversal
    for fn in this.Listeners
      fn(args*)
  }
}

; Big ol' singleton class
class OnMouseEvent {
  ; Register or unregister an event listener.
  ; This is the only intended public method.
  ; OnMouseEvent(Callback [, AddRemove := 1])
  ; Callback(EventData)
  ; The Callback will be fired while Critical! :(
  static Call(fn, addremove := 1) {
    status := this.Event.OnFire(fn, addremove)
    if status == 1
      this.Start()
    else if status == -1
      this.Stop()
  }

  ; Get input data.
  ; Intended to be accessed in an event listener.
  static Flags => NumGet(this.Data, A_PtrSize * 2 + 8, "UShort")
  ; static Padding          => NumGet(this.Data, A_PtrSize * 2 + 10, "UShort")
  static ButtonFlags => NumGet(this.Data, A_PtrSize * 2 + 12, "UShort")
  static ButtonData => NumGet(this.Data, A_PtrSize * 2 + 14, "Short")
  ; static RawButtons       => NumGet(this.Data, A_PtrSize * 2 + 16, "UInt")
  static LastX => NumGet(this.Data, A_PtrSize * 2 + 20, "Int")
  static LastY => NumGet(this.Data, A_PtrSize * 2 + 24, "Int")
  static ExtraInformation => NumGet(this.Data, A_PtrSize * 2 + 28, "UInt")
  ; Get hDevice from RAWINPUTHEADER to identify which mouse this data came from
  ; Should probably be cached/invalidated!
  static ThisMouse => DllCall("GetRawInputData", "Ptr", this.lParam, "UInt", 0x10000005, "Ptr", this.Header, "UInt*", A_PtrSize * 2 + 8, "UInt", A_PtrSize * 2 + 8) ? NumGet(this.Header, 8, "Ptr") : -1

  ; Examples of conclusions that can be drawn from the data.
  ; These will be zero or nonzero, not zero or one.
  static IsRelativeMovement => (this.LastX || this.LastY) && !(this.Flags & 0x01)
  static IsAbsoluteMovement => this.Flags & 0x01
  static IsMovement => this.LastX || this.LastY || this.Flags & 0x01
  static IsButtons => this.ButtonFlags & 0x03ff
  static IsWheel => this.ButtonFlags & 0x0400
  static IsHWheel => this.ButtonFlags & 0x0800
  ; WARNING: does not account for virtual desktop!
  static GetAbsolutePosition(&x, &y) => (x := Floor(this.LastX / 65535 * A_ScreenWidth), y := Floor(this.LastY / 65535 * A_ScreenHeight))

  ; ================================================================
  ; Internals
  ; ================================================================

  static Event := Event()
  static Device := Buffer(A_PtrSize + 8) ; RAWINPUTDEVICE
  static Header := Buffer(A_PtrSize * 2 + 8) ; RAWINPUTHEADER
  static Data := Buffer() ; Size is determined upon the first event's arrival.
  static SinkGui := Gui() ; WM_INPUT needs a hwnd to route to.
  static lParam := ( ; Gotta put these somewhere...
    this.DefineProp("MouseMoved", { Call: this.MouseMoved.Bind(this) }),
    this.DefineProp("MouseMovedReal", { Call: this.MouseMovedReal.Bind(this) }),
    this.DefineProp("Exit", { Call: this.Exit.Bind(this) }),
    OnExit(this.Exit))

  static Start() {
    ; Register mouse for WM_INPUT messages.
    NumPut("UShort", 1
      , "UShort", 2
      , "UInt", 0x00000100 ; RIDEV_INPUTSINK := 0x00000100
      , "UInt", this.SinkGui.Hwnd
      , this.Device, 0)

    DllCall("RegisterRawInputDevices"
      , "Ptr", this.Device
      , "UInt", 1
      , "UInt", A_PtrSize + 8)

    OnMessage(0x00FF, this.MouseMoved) ; WM_INPUT
  }

  static Stop() {
    OnMessage(0x00FF, this.MouseMoved, 0) ; WM_INPUT

    NumPut("UInt", 0x00000001, this.Device, 4) ; RIDEV_REMOVE := 0x00000001

    DllCall("RegisterRawInputDevices"
      , "Ptr", this.Device
      , "UInt", 1
      , "UInt", A_PtrSize + 8)
  }

  ; ================================================================
  ; Callbacks
  ; ================================================================
  ; Note that each of these still have the implied `this` argument.
  ; There's a part up above that fills it in (with Func.Bind)

  ; This method runs only once, replacing itself with MouseMovedReal in the process
  static MouseMoved(wParam, lParam, msg, hwnd) {
    Critical()

    ; Find size of rawinput data - only needs to be run the first time.
    iSize := 0
    DllCall("GetRawInputData"
      , "UInt", lParam
      , "UInt", 0x10000003
      , "Ptr", 0
      , "UInt*", &iSize
      , "UInt", A_PtrSize * 2 + 8)

    this.Data.Size := iSize

    ; Re-route WM_INPUT to the correct function
    OnMessage(0x00FF, this.MouseMoved, 0)
    this.DefineProp("MouseMoved", { Call: this.MouseMovedReal })
    OnMessage(0x00FF, this.MouseMoved)
    this.MouseMoved.Call(wParam, lParam, msg, hwnd)
  }

  static MouseMovedReal(wParam, lParam, msg, hwnd) {
    Critical()
    , this.lParam := lParam
    ; Get RawInput data
    , DllCall("GetRawInputData"
      , "UInt", lParam
      , "UInt", 0x10000003
      , "Ptr", this.Data
      , "UInt*", this.Data.Size
      , "UInt", A_PtrSize * 2 + 8)
    ; Event is fired while Critical because the data may otherwise be overwritten :(
    , this.Event.Fire(this)
  }

  static Exit(ExitReason, ExitCode) => this.Event.Listeners.Length && this.Stop()
}

; #include <Flags>
; Pretty-print an integer as a |-separated string of flag names
; warning: assumes each flag is only a single bit
class Flags {
  ; construct from pairs of (string, integer)
  __New(args*) {
    this.flags := args
    ; Loop args.Length
    ; this.%args[A_Index]% := ++A_Index ; use A_Index, increment, use A_Index
  }

  Call(value) {
    out := ""
    loop this.flags.Length
      if (value & this.flags[++A_Index])
        value ^= this.flags[A_Index], out && out .= " | ", out .= this.flags[A_Index - 1]
    if value
      (out && out .= " | ", out .= value)
    return out ? out : "0"
  }
}
