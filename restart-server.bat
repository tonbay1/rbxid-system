@echo off
echo ========================================
echo    RbxID Server Restart (Port 8888)
echo ========================================
echo.

echo [INFO] Stopping any existing server processes...
taskkill /f /im node.exe 2>nul
timeout /t 2 /nobreak >nul

echo [INFO] Starting fresh server on port 8888...
cd /d "%~dp0\server"

echo.
echo ========================================
echo    SERVER STARTING
echo ========================================
echo [INFO] Dashboard: http://localhost:8888
echo [INFO] API: http://localhost:8888/api
echo [INFO] Press CTRL+C to stop
echo ========================================
echo.

node rbxid-server.js
