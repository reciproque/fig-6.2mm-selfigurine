@echo off
setlocal EnableDelayedExpansion

set "URL=http://localhost:5173/"
set "MAX_WAIT_SECONDS=120"

taskkill /im explorer.exe /f

net start "TabletInputService"

REM --- Attente active que le serveur Vite reponde (au lieu d'un timeout fixe) ---
set /a "elapsed=0"
:waitloop
curl -s -o nul -w "%%{http_code}" "%URL%" > "%TEMP%\selfigurine_httpcode.txt" 2>nul
set /p HTTP_CODE=<"%TEMP%\selfigurine_httpcode.txt"

if "%HTTP_CODE%"=="200" goto serverready

if !elapsed! GEQ %MAX_WAIT_SECONDS% (
    echo [WARN] Le serveur ne repond pas apres %MAX_WAIT_SECONDS%s, lancement de Chrome quand meme.
    goto serverready
)

timeout /t 1 >nul
set /a "elapsed+=1"
goto waitloop

:serverready
del "%TEMP%\selfigurine_httpcode.txt" >nul 2>nul

REM --- Cache HTTP dedie, vide a chaque demarrage ---
REM Contrairement a --incognito, ceci ne touche PAS au profil Chrome habituel :
REM les extensions (Vue Devtools) et les permissions (webcam) restent celles
REM du profil par defaut et ne sont donc jamais reinitialisees.
set "CACHE_DIR=%LOCALAPPDATA%\SelfigurineChromeCache"
if exist "%CACHE_DIR%" rd /s /q "%CACHE_DIR%"
mkdir "%CACHE_DIR%"

REM --- Lancement de Chrome en kiosque ---
start chrome.exe --kiosk --disk-cache-dir="%CACHE_DIR%" --disk-cache-size=52428800 --overscroll-history-navigation=0 --disable-pinch --noerrors --disable-session-crashed-bubble --disable-infobars --window-position=0,0 --window-size=720,120 --noerrdialogs "%URL%"