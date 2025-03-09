#Requires AutoHotkey v2.0
#SingleInstance Force

#Include <base>
#Include <Misc>
#Include <betterui>

#Requires AutoHotkey v2.0
(() {
  global toast
  msgTime := 3000
  messages := []
  msgGuiH := 30
  msgGui := betterui({
    aot: 1,
    h: 30,
    w: A_ScreenWidth,
    clickthrough: 1,
    transparency: 220,
    lastfound: 0,
    disabled: 1,
    tool: 1
  })
  msgGui.opt("+E0x08000000")
  msgGui.SetFont("s15")
  msgGui.add("text", {
    o: "center"
  }, &msgGuiTextBox)
  id := Random()
  msgGoing := 0
  toast := (msg) {
    messages.push([id, msg])
    sendNextMsg()
    obj := {
      inQueue: (*) {
        return !!messages.Find(e => e[1] == id)
      },
      cancelMsg: (*) {
        if obj.inQueue()
          messages.RemoveAt(messages.Find(e => e[1] == id))
        else
          print("the message is not in the queue", "id: " id)
      }
    }
    return obj
  }
  sendNextMsg := () {
    if msgGoing
      return
    if !messages.Length
      return
      ; print("messages", messages)
    msgGuiTextBox.text := messages[1][2]
    msgGui.show("NoActivate xcenter y" A_ScreenHeight - msgGuiH - msgGuiH)
    messages.RemoveAt(1)
    msgGoing := 1
    SetTimer(() {
      msgGoing := 0
      if !messages.Length
        msgGui.hide()
      sendNextMsg()
    }, -msgTime)
  }
})()