@echo off
echo ========================================
echo    Push to Existing GitHub Repository
echo ========================================
echo.

echo [INFO] Repository should be created at: https://github.com/tonbay1/rbxid-system
echo [INFO] Pushing existing commits...

git push -u origin main

echo.
echo [SUCCESS] Pushed to GitHub!
echo.
echo [INFO] Repository: https://github.com/tonbay1/rbxid-system
echo [INFO] Raw URLs available:
echo [INFO] Loader: https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_loader.lua
echo [INFO] Main Script: https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_telemetry.lua
echo [INFO] Server: https://raw.githubusercontent.com/tonbay1/rbxid-system/main/server/rbxid-server.js
echo.
pause
