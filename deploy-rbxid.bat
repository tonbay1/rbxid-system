@echo off
echo ========================================
echo    Deploy RbxID System - Complete Setup
echo ========================================
echo.

echo [INFO] This script will:
echo [INFO] 1. Start RbxID server on port 8888
echo [INFO] 2. Make dashboard accessible at http://rbxid.com
echo [INFO] 3. Test public access
echo.

set /p confirm="Continue? (Y/N): "
if /i not "%confirm%"=="Y" goto :end

echo.
echo ========================================
echo    STEP 1: Start RbxID Server
echo ========================================
echo.

cd /d "%~dp0\server"

echo [INFO] Starting server on port 8888...
echo [INFO] Dashboard will be available at: http://rbxid.com
echo [INFO] Press Ctrl+C to stop server
echo.

REM Clear PORT variable to ensure port 8888
set PORT=8888

start "RbxID Server" cmd /k "echo RbxID Server Running... && node rbxid-server.js"

echo [INFO] Server started in new window
timeout /t 3 /nobreak >nul

echo.
echo ========================================
echo    STEP 2: Test Public Access
echo ========================================
echo.

cd /d "%~dp0"
call test-public-access.bat

:end
echo.
echo ========================================
echo    DEPLOYMENT COMPLETE
echo ========================================
echo.
echo [INFO] Your RbxID system is now running!
echo [INFO] 🌐 Dashboard: http://rbxid.com
echo [INFO] 📊 Share this URL with others to view telemetry data
echo.
pause
