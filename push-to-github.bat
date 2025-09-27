@echo off
echo ========================================
echo    Push RbxID to GitHub
echo ========================================
echo.

REM Initialize git if not exists
if not exist ".git" (
    echo [INFO] Initializing Git repository...
    git init
    git branch -M main
    git remote add origin https://github.com/tonbay1/rbxid-system.git
)

echo [INFO] Adding files to Git...
git add .

echo [INFO] Committing changes...
git commit -m "RbxID System Update - %date% %time%"

echo [INFO] Pushing to GitHub...
git push -u origin main

echo.
echo [SUCCESS] Pushed to GitHub!
echo.
echo [INFO] Raw URLs available:
echo [INFO] Lua Script: https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_telemetry.lua
echo [INFO] Server: https://raw.githubusercontent.com/tonbay1/rbxid-system/main/server/rbxid-server.js
echo.
pause
