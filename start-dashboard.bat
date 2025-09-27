@echo off
echo ========================================
echo    RbxID React Dashboard Startup
echo ========================================
echo.

cd /d "%~dp0\ui-react"

echo [INFO] Installing dependencies...
call npm install

echo.
echo [INFO] Starting React development server...
echo [INFO] Dashboard will open at: http://localhost:5173
echo [INFO] Press Ctrl+C to stop dashboard
echo.

call npm run dev

pause
