#Requires AutoHotkey v2.0
#Include <Misc>
#Include <base>
#Include <betterui>
SetWorkingDir(A_ScriptDir)

#SingleInstance Off
urls := A_Clipboard.RegExMatchAll("https?://[^\s`"]+")
urls := urls.map(e => e[0].split("\n"))
urls := urls.flat()
urls := urls.map((e) => e.RegExReplace("&t=\d+", '').RegExReplace("&startTime=\d+", ''))
urls := urls.filter(e => e.startsWith("http"))
if !urls.length
  return
progress := 0
texts := {}
fails := []
ui := betterui({
  aot: 0,
  h: 20,
  w: 350,
  clickthrough: 1,
  transparency: 180
})
ui.ignoretextcolor := 1
ui.SetFont("caaaaaa")
ui.add("progress", {}, &progbar)
.newLine(1.4)
.add("text", {
  o: "center",
  t: "DOWNLOADING AS VIDEO"
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
ui.show("x0 y0 NoActivate")
for url in urls {
  texts.%url%.setfont("cbbbb00")
  cmd := "cmd /c `"cd `"" A_ScriptDir "`" & yt-dlp --no-check-certificate -f `"bestvideo[height<=720]+bestaudio/best[height<=720]`" --merge-output-format mp4 `"" url "`" --no-mtime --add-metadata --output `".\%(title)s.%(ext)s`" --ffmpeg-location `"./ffmpeg.exe`" --paths `"D:\Downloads\Videos`" --audio-format mp3 --audio-quality 128k --cookies ./cookies.txt --sponsorblock-remove `"sponsor, intro, outro, selfpromo, preview, filler, interaction, music_offtopic`"`""
  ; A_Clipboard := cmd
  test := RunWait(cmd, , "min", &pid)
  progress += 1
  updateprogress()
  texts.%url%.setfont(test ? "cbd0000" : "c00bd00")
  if test
    fails.push(cmd.RegExReplace("^cmd /c `"", "").RegExReplace("`"$", ""))
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
