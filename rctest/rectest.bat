@echo off
setlocal enabledelayedexpansion
:: Delete temp.mkv if it exists to start fresh
if exist "%CD%\temp\temp.mkv" del "%CD%\temp\temp.mkv"
title RCTEST
:loop
:: Record a segment
echo y | "%CD%\ffmpeg.exe" -packetsize 188 -loglevel info -t 5 -f gdigrab -i desktop -vcodec libx264 -pix_fmt yuv420p -s hd720 -preset ultrafast -vsync vfr -acodec libmp3lame -f mpegts "%CD%\temp\temp.mkv"

:: Shift existing files to make room for the new recording
for /l %%i in (59,-1,1) do (
    set /a "newIndex=%%i+1"
    if exist "%CD%\temp\%%i.mkv" move /y "%CD%\temp\%%i.mkv" "%CD%\temp\!newIndex!.mkv"
)

:: Move the new recording to 1.mkv
move /y "%CD%\temp\temp.mkv" "%CD%\temp\1.mkv" 

goto loop

