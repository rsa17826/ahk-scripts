$counter = 0
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$host.UI.RawUI.WindowTitle = "RCTest - Capture"

while ($true) {
  $filename = "temp/temp{0:000}.mkv" -f ($counter)
  ffmpeg.exe -f gdigrab -i desktop -t 5 -vcodec libx264 -pix_fmt yuv420p -s hd720 -preset ultrafast -vsync 1 -framerate 30 -reset_timestamps true -y -packetsize 188 -loglevel info -f mpegts  $filename
  $counter = ($counter + 1) % 60
}
