#Requires AutoHotkey v2.0
#Include <Misc>
#Include <base>
#Include <betterui>
; https://www.twitch.tv/videos/2442602093?filter=archives&sort=time
; https://www.twitch.tv/videos/2440867343?filter=archives&sort=time
; https://www.twitch.tv/videos/2439669348?filter=archives&sort=time
; https://www.twitch.tv/videos/2434741651?filter=archives&sort=time
; https://www.twitch.tv/videos/2433005202?filter=archives&sort=time
; https://www.twitch.tv/videos/2423263953?filter=archives&sort=time
; https://www.twitch.tv/videos/2421455443?filter=archives&sort=time
; https://www.twitch.tv/videos/2417935604?filter=archives&sort=time
; https://www.twitch.tv/videos/2413676282?filter=archives&sort=time
; https://www.twitch.tv/videos/2411513087?filter=archives&sort=time
; https://www.twitch.tv/videos/2407666331?filter=archives&sort=time
; https://www.twitch.tv/videos/2405817724?filter=archives&sort=time
; https://www.twitch.tv/videos/2404118354?filter=archives&sort=time
; https://www.twitch.tv/videos/2401658254?filter=archives&sort=time
; https://www.twitch.tv/videos/2398991912?filter=archives&sort=time
; https://www.twitch.tv/videos/2397419713?filter=archives&sort=time
; https://www.twitch.tv/videos/2397354646?filter=archives&sort=time
; https://www.twitch.tv/videos/2395728869?filter=archives&sort=time
; https://www.twitch.tv/videos/2394826562?filter=archives&sort=time

; https://www.twitch.tv/videos/2489772230?filter=archives&sort=time
; https://www.twitch.tv/videos/2497768418?filter=archives&sort=time
; cmd /c "cd "C:\Users\User\Downloads\programs\ytdlp ahk" & yt-dlp --no-check-certificate -f bestvideo+bestaudio/best --merge-output-format mp4 "https://www.twitch.tv/videos/2411513087?filter=archives&sort=time" --no-mtime --add-metadata --output ".\%(title)s.%(ext)s" --ffmpeg-location "./ffmpeg.exe" --paths "D:\Downloads\Videos" --audio-format mp3 --audio-quality 128k --cookies ./cookies.txt --sponsorblock-remove "sponsor, intro, outro, selfpromo, preview, filler, interaction, music_offtopic""
; cmd /c "cd "C:\Users\User\Downloads\programs\ytdlp ahk" & yt-dlp --no-check-certificate -f bestvideo+bestaudio/best --merge-output-format mp4 "https://www.twitch.tv/videos/2407666331?filter=archives&sort=time" --no-mtime --add-metadata --output ".\%(title)s.%(ext)s" --ffmpeg-location "./ffmpeg.exe" --paths "D:\Downloads\Videos" --audio-format mp3 --audio-quality 128k --cookies ./cookies.txt --sponsorblock-remove "sponsor, intro, outro, selfpromo, preview, filler, interaction, music_offtopic""
; cmd /c "cd "C:\Users\User\Downloads\programs\ytdlp ahk" & yt-dlp --no-check-certificate -f bestvideo+bestaudio/best --merge-output-format mp4 "https://www.twitch.tv/videos/2405817724?filter=archives&sort=time" --no-mtime --add-metadata --output ".\%(title)s.%(ext)s" --ffmpeg-location "./ffmpeg.exe" --paths "D:\Downloads\Videos" --audio-format mp3 --audio-quality 128k --cookies ./cookies.txt --sponsorblock-remove "sponsor, intro, outro, selfpromo, preview, filler, interaction, music_offtopic""
; cmd /c "cd "C:\Users\User\Downloads\programs\ytdlp ahk" & yt-dlp --no-check-certificate -f bestvideo+bestaudio/best --merge-output-format mp4 "https://www.twitch.tv/videos/2404118354?filter=archives&sort=time" --no-mtime --add-metadata --output ".\%(title)s.%(ext)s" --ffmpeg-location "./ffmpeg.exe" --paths "D:\Downloads\Videos" --audio-format mp3 --audio-quality 128k --cookies ./cookies.txt --sponsorblock-remove "sponsor, intro, outro, selfpromo, preview, filler, interaction, music_offtopic""
; cmd /c "cd "C:\Users\User\Downloads\programs\ytdlp ahk" & yt-dlp --no-check-certificate -f bestvideo+bestaudio/best --merge-output-format mp4 "https://www.twitch.tv/videos/2401658254?filter=archives&sort=time" --no-mtime --add-metadata --output ".\%(title)s.%(ext)s" --ffmpeg-location "./ffmpeg.exe" --paths "D:\Downloads\Videos" --audio-format mp3 --audio-quality 128k --cookies ./cookies.txt --sponsorblock-remove "sponsor, intro, outro, selfpromo, preview, filler, interaction, music_offtopic""
; cmd /c "cd "C:\Users\User\Downloads\programs\ytdlp ahk" & yt-dlp --no-check-certificate -f bestvideo+bestaudio/best --merge-output-format mp4 "https://www.twitch.tv/videos/2398991912?filter=archives&sort=time" --no-mtime --add-metadata --output ".\%(title)s.%(ext)s" --ffmpeg-location "./ffmpeg.exe" --paths "D:\Downloads\Videos" --audio-format mp3 --audio-quality 128k --cookies ./cookies.txt --sponsorblock-remove "sponsor, intro, outro, selfpromo, preview, filler, interaction, music_offtopic""
; cmd /c "cd "C:\Users\User\Downloads\programs\ytdlp ahk" & yt-dlp --no-check-certificate -f bestvideo+bestaudio/best --merge-output-format mp4 "https://www.twitch.tv/videos/2397419713?filter=archives&sort=time" --no-mtime --add-metadata --output ".\%(title)s.%(ext)s" --ffmpeg-location "./ffmpeg.exe" --paths "D:\Downloads\Videos" --audio-format mp3 --audio-quality 128k --cookies ./cookies.txt --sponsorblock-remove "sponsor, intro, outro, selfpromo, preview, filler, interaction, music_offtopic""
; cmd /c "cd "C:\Users\User\Downloads\programs\ytdlp ahk" & yt-dlp --no-check-certificate -f bestvideo+bestaudio/best --merge-output-format mp4 "https://www.twitch.tv/videos/2397354646?filter=archives&sort=time" --no-mtime --add-metadata --output ".\%(title)s.%(ext)s" --ffmpeg-location "./ffmpeg.exe" --paths "D:\Downloads\Videos" --audio-format mp3 --audio-quality 128k --cookies ./cookies.txt --sponsorblock-remove "sponsor, intro, outro, selfpromo, preview, filler, interaction, music_offtopic""
; cmd /c "cd "C:\Users\User\Downloads\programs\ytdlp ahk" & yt-dlp --no-check-certificate -f bestvideo+bestaudio/best --merge-output-format mp4 "https://www.twitch.tv/videos/2395728869?filter=archives&sort=time" --no-mtime --add-metadata --output ".\%(title)s.%(ext)s" --ffmpeg-location "./ffmpeg.exe" --paths "D:\Downloads\Videos" --audio-format mp3 --audio-quality 128k --cookies ./cookies.txt --sponsorblock-remove "sponsor, intro, outro, selfpromo, preview, filler, interaction, music_offtopic""
; cmd /c "cd "C:\Users\User\Downloads\programs\ytdlp ahk" & yt-dlp --no-check-certificate -f bestvideo+bestaudio/best --merge-output-format mp4 "https://www.twitch.tv/videos/2394826562?filter=archives&sort=time" --no-mtime --add-metadata --output ".\%(title)s.%(ext)s" --ffmpeg-location "./ffmpeg.exe" --paths "D:\Downloads\Videos" --audio-format mp3 --audio-quality 128k --cookies ./cookies.txt --sponsorblock-remove "sponsor, intro, outro, selfpromo, preview, filler, interaction, music_offtopic""
SetWorkingDir(A_ScriptDir)

#SingleInstance Off
urls := A_Clipboard.RegExMatchAll("https?://[^\s`"]+").map((e) => e[0].RegExReplace("&t=\d+", '').RegExReplace("&startTime=\d+", ''))
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
