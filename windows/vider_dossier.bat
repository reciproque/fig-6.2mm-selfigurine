@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Erreur : Aucun chemin de dossier spécifié.
    echo Usage : %~nx0 "C:/Chemin/vers/le/dossier"
    pause
    exit /b 1
)

if not exist "%~1" (
    echo Erreur : Le dossier "%~1" n'existe pas.
    pause
    exit /b 1
)

echo Suppression des fichiers et sous-dossiers dans "%~1"...
rmdir /s /q "%~1" 2>nul
mkdir "%~1" 2>nul

echo Dossier "%~1" vidé avec succès.
pause