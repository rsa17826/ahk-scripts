@echo off
setlocal enabledelayedexpansion

cd temp
echo Current Directory: %CD%

:: Check if the first file exists, if not, exit
@REM if not exist "1.mkv" (
@REM     echo File "1.mkv" not found. Exiting.
@REM     exit /b
@REM )


(for /l %%i in (60,-1,1) do (
    if exist "%%i.mkv" (
        echo file '%%i.mkv'
    )
)) > file_list.txt



"%CD%\..\ffmpeg.exe" -f concat -safe 0 -i file_list.txt -c copy "tempjoined.mkv"
if exist "%CD%\..\%~1.mkv" del "%CD%\..\%~1.mkv"
move "tempjoined.mkv" "%CD%\..\%~1.mkv"


endlocal

