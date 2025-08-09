#Requires AutoHotkey v2.0
#Include <Misc>
#Include <base>
#Include <betterui>

#SingleInstance Ignore
urls := A_Clipboard.RegExMatchAll("https?://[^\s`"]+").map((e) => e[0].RegExReplace("&t=\d+", '').RegExReplace("&startTime=\d+", ''))
if !urls.length
  return
progress := 0
texts := {}
fails := []
ui := betterui({
  aot: 1,
  h: 20,
  w: 350,
  clickthrough: 1,
  transparency: 200
})
ui.ignoretextcolor := 1
ui.SetFont("caaaaaa")
ui.add("progress", {}, &progbar)
.newLine(1.4)
.add("text", {
  o: "center",
  t: "DOWNLOADING AS AUDIO"
}, &progtext)
.newLine(1)
.add("text", {
  o: "center"
}, &progtext)
.newline()
loop urls.length {
  if A_Index != 1
    ui.newline()
  url := urls[A_Index]
  print(url, urls)
  ui.add("text", {
    t: url,
    o: "center"
  }, &text)
  texts.%url% := text
}
updateprogress()
ui.show("x0 y0")

for url in urls {
  texts.%url%.setfont("cbbbb00")
  cmd := "cmd /c `"cd `"" A_ScriptDir "`" & yt-dlp --no-check-certificate --extract-audio `"" url "`" --output `".\%(title)s.%(ext)s`" --ffmpeg-location `"./ffmpeg.exe`" --paths `"C:\Users\User\Downloads\``ney`" --audio-format mp3 --audio-quality 128k --cookies ./cookies.txt --sponsorblock-remove `"sponsor, intro, outro, selfpromo, preview, filler, interaction, music_offtopic`" --write-thumbnail -o `"%(fulltitle)s - by %(channel)s.%(ext)s`"`""
  ; cmd := "C:\Users\User\Downloads\programs\yt-dlp.exe --no-check-certificate --extract-audio `"" url "`" --ffmpeg-location `"C:\Users\User\Downloads\programs\ffmpeg\ffmpeg.exe`" --paths `"C:\Users\User\Downloads\``ney`" --audio-format mp3 --audio-quality 128k --sponsorblock-remove `"sponsor, intro, outro, selfpromo, preview, filler, interaction, music_offtopic`" --write-thumbnail -o `"%(fulltitle)s - by %(channel)s.%(ext)s`""
  test := RunWait(cmd, "", "hide")
  progress += 1
  updateprogress()
  texts.%url%.setfont(test ? "cbd0000" : "c00bd00")
  if test
    fails.push(cmd)
}
if fails.length {
  msgbox("failed to download`n" A_Clipboard := fails.join("`n"))
}
ExitApp()

updateprogress() {
  global progbar
  global progtext
  global progress
  progbar.value := (progress / urls.length) * 100
  progtext.text := (progress / urls.length) * 100 "%"
}
