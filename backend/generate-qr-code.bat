@echo off

REM === Paramètres communs  ===
set "SOURCE=%1"

@echo off
cd /d "%~dp0"


REM === Activer l'environnement virtuel ===
echo Activating virtual environment...
call roop\path-to-new-venv\Scripts\activate.bat
if %errorlevel% neq 0 (
    echo Failed to activate virtual environment. Aborting.
    exit /b %errorlevel%
)

echo Running generate-qr-code.py...
python generate-qr-code.py "%SOURCE%"
if %errorlevel% neq 0 (
    echo generate-qr-code.py failed.
    exit /b %errorlevel%
)

echo All done.
