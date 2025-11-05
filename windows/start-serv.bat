@echo off
set "APP_DIR=%~1"

cd /d "%APP_DIR%"
cmd /c "npm run app"