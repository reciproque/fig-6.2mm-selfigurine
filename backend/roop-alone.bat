@echo off

REM === Paramètres communs ===
set "SOURCE=..\photos\WEBCAM\0.png"
set "OUTPUT=..\figurines\fig1.png"
set "FINAL=..\final\final-test-roop-seul-wendy.jpg"

REM === Activer l'environnement virtuel ===
echo Activating virtual environment...
call path-to-new-venv\Scripts\activate.bat
if %errorlevel% neq 0 (
    echo Failed to activate virtual environment. Aborting.
    exit /b %errorlevel%
)

REM === Ajouter ffmpeg.exe au PATH ===
set "PATH=%CD%\path-to-new-venv\Scripts;%PATH%"

REM === Vérifier que ffmpeg est accessible ===
where ffmpeg
if %errorlevel% neq 0 (
    echo ffmpeg not found in PATH. Aborting.
    exit /b 1
)

REM === Lancer le second script dans le venv ===
echo Running run.py...
python run.py -s "%SOURCE%" -t "%OUTPUT%" -o "%FINAL%"
if %errorlevel% neq 0 (
    echo run.py failed.
    exit /b %errorlevel%
)

echo All done.
