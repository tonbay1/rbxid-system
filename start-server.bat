@echo off
echo ========================================
echo    RbxID Telemetry Server Startup
echo ========================================
echo.

cd /d "%~dp0\server"

echo [INFO] Starting RbxID Server...
echo [INFO] Domain: rbxid.com
echo [INFO] Port: 3010
echo [INFO] Press Ctrl+C to stop server
echo.

node rbxid-server.js

pause
