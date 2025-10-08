@echo off

REM === Paramètres communs  - TODO : enlever harmonized ? ===
set "SOURCE=%1"
set "OUTPUT=%2"
set "MASK=%3"
set "HARMONIZED=%4"
set "FINAL=%5"

cd /d %~dp0

REM === Lancer le premier script avec Python global ou virtualenv déjà activé - TODO : enlever harmonized ? ===
echo Running recol.py...
python recol.py -p "%~dp0%SOURCE%" -f "%~dp0%OUTPUT%" -m "%~dp0%MASK%" -s "%~dp0%HARMONIZED%"
if %errorlevel% neq 0 (
    echo recol.py failed. Aborting.
    exit /b %errorlevel%
)

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

REM === Lancer le second script dans le venv - TODO : enlever harmonized ? ===
echo Running run.py...
python roop/run.py -s "%~dp0%SOURCE%" -t "%~dp0%HARMONIZED%" -o "%~dp0%FINAL%"
if %errorlevel% neq 0 (
    echo run.py failed.
    exit /b %errorlevel%
)

echo All done.
