@echo off
echo ========================================
echo    Auto Deploy to VPS (103.58.149.243)
echo ========================================
echo.

REM Set VPS connection details
set VPS_IP=103.58.149.243
set VPS_USER=Administrator
set VPS_PATH=C:\rbxid-system

echo [INFO] Pushing to GitHub...
git add .
git commit -m "Auto deploy: %date% %time%"
git push origin main

echo.
echo [INFO] Deploying to VPS via SCP...
REM Using SCP to copy files (requires SSH setup)
scp -r . %VPS_USER%@%VPS_IP%:%VPS_PATH%

echo.
echo [INFO] Restarting server on VPS...
REM SSH command to restart server
ssh %VPS_USER%@%VPS_IP% "cd %VPS_PATH% && taskkill /f /im node.exe && start /b node server/rbxid-server.js"

echo.
echo [SUCCESS] Deploy completed!
echo [INFO] Server URL: http://rbxid.com:3010
pause
