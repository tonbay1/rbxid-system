@echo off
echo ========================================
echo    Start RbxID Server (External Access)
echo ========================================
echo.

REM Kill any existing Node.js processes
echo [INFO] Stopping existing servers...
taskkill /f /im node.exe 2>nul

timeout /t 2 /nobreak >nul

REM Set environment variables
set PORT=8888
set NODE_ENV=production

cd /d "%~dp0\server"

echo [INFO] Starting RbxID server with external access...
echo [INFO] Server will bind to: 0.0.0.0:8888
echo [INFO] External URLs:
echo [INFO] ✅ http://rbxid.com
echo [INFO] ✅ http://103.58.149.243
echo [INFO] ✅ http://103.58.149.243:8888
echo.
echo [CTRL+C] to stop server
echo.

REM Start server
node rbxid-server.js

pause
