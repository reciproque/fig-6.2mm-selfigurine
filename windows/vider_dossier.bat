@echo off
setlocal enabledelayedexpansion
 
:: Vérifier si un chemin est fourni
if "%~1"=="" (
    echo Erreur : Aucun chemin de dossier spécifié.
    echo Usage : %~nx0 "C:/Chemin/vers/le/dossier"
    pause
    exit /b 1
)
 
:: Vérifier si le dossier existe
if not exist "%~1" (
    echo Erreur : Le dossier "%~1" n'existe pas.
    pause
    exit /b 1
)
 
:: Supprimer uniquement les fichiers JPG et PNG
echo Suppression des fichiers JPG et PNG dans "%~1"...
del /q "%~1\*.jpg" 2>nul
del /q "%~1\*.png" 2>nul
 
:: Vérifier si photo-count.txt existe
if exist "%~1\photo-count.txt" (
    :: Éditer le fichier photo-count.txt pour mettre "0"
    echo 0 > "%~1\photo-count.txt"
    echo Fichier photo-count.txt mis à jour avec "0".
) else (
    echo Avertissement : Le fichier photo-count.txt n'existe pas dans "%~1".
)
 
echo Suppression des fichiers JPG et PNG terminée.
pause