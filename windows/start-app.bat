@echo off
setlocal EnableDelayedExpansion

set "DISPOSITIF=%~1"
set "URL=http://localhost:5173/"

@REM taskkill /im explorer.exe /f

net start "TabletInputService"

timeout /t 5 >nul
start chrome.exe --kiosk --overscroll-history-navigation=0 --disable-pinch --noerrors --disable-session-crashed-bubble --disable-infobars --window-position=0,0 --window-size=1080,1920 --noerrdialogs "%URL%"