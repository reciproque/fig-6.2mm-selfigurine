@echo off

REM === Paramètres communs  ===
set "SOURCE=%1"
set "OUTPUT=%2"
set "FINAL=%3"

cd /d %~dp0

REM === Activer l'environnement virtuel ===
echo Activating virtual environment...
call roop\path-to-new-venv\Scripts\activate.bat
if %errorlevel% neq 0 (
    echo Failed to activate virtual environment. Aborting.
    exit /b %errorlevel%
)

REM === Ajouter ffmpeg.exe au PATH ===
set "PATH=%CD%\roop\path-to-new-venv\Scripts;%PATH%"

REM === Vérifier que ffmpeg est accessible ===
where ffmpeg
if %errorlevel% neq 0 (
    echo ffmpeg not found in PATH. Aborting.
    exit /b 1
)

REM === Lancer le second script dans le venv ===
echo Running run.py...
python roop/run.py -s "%~dp0%SOURCE%" -t "%~dp0%OUTPUT%" -o "%~dp0%FINAL%"
if %errorlevel% neq 0 (
    echo run.py failed.
    exit /b %errorlevel%
)

REM ---- Deuxième FINAL avec overlay ----
set OUTPUT_LOGO=%FINAL:~0,-4%-overlay.png

python "%~dp0add-overlay.py" "%~dp0%FINAL%" "%~dp0overlay.png" "%~dp0%OUTPUT_LOGO%"

if %errorlevel% neq 0 (
    echo Overlay creation failed.
    exit /b %errorlevel%
)

echo All done.
