@echo off
echo ========================================
echo    RbxID Server (Port 8888)
echo ========================================
echo.

REM Clear any PORT environment variable
set PORT=

cd /d "%~dp0\server"

echo [INFO] Starting RbxID server on port 8888...
echo [INFO] Dashboard: http://localhost:8888
echo [INFO] API: http://localhost:8888/api
echo [INFO] Environment PORT cleared
echo.
echo [CTRL+C] to stop server
echo.

node rbxid-server.js
