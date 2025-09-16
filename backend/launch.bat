@echo off

REM === Paramètres communs ===
set "SOURCE=%1"
set "OUTPUT=%2"
set "MASK=%3"
set "HARMONIZED=%4"
set "FINAL=%5"

REM === Lancer le premier script avec Python global ou virtualenv déjà activé ===
echo Running recol.py...
python recol.py -p "%SOURCE%" -f "%OUTPUT%" -m "%MASK%" -s "%HARMONIZED%"
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

REM === Lancer le second script dans le venv ===
echo Running run.py...
python roop/run.py -s "%SOURCE%" -t "%HARMONIZED%" -o "%FINAL%"
if %errorlevel% neq 0 (
    echo run.py failed.
    exit /b %errorlevel%
)

echo All done.
