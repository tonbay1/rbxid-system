@echo off
echo ========================================
echo    RbxID Server (Public Access - Port 80)
echo ========================================
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Running on port 80 requires Administrator privileges
    echo [INFO] Right-click and select "Run as administrator"
    echo.
    echo [ALTERNATIVE] Use port forwarding instead:
    echo [INFO] Run: setup-port-forwarding.bat (as admin)
    echo [INFO] Then: start-server-8888.bat (normal user)
    pause
    exit /b 1
)

REM Clear any existing PORT variable and set to 80
set PORT=80

cd /d "%~dp0\server"

echo [INFO] Starting RbxID server on port 80 (public access)...
echo [INFO] Public URLs:
echo [INFO] ✅ http://rbxid.com
echo [INFO] ✅ http://www.rbxid.com  
echo [INFO] ✅ Dashboard: http://rbxid.com
echo [INFO] ✅ API: http://rbxid.com/api
echo.
echo [CTRL+C] to stop server
echo.

node rbxid-server.js

pause
