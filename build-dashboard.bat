@echo off
echo ========================================
echo    Build RbxID Dashboard for Production
echo ========================================
echo.

cd /d "%~dp0\ui-react"

echo [INFO] Installing dependencies...
call npm install

echo.
echo [INFO] Building React app for production...
call npm run build

echo.
echo [INFO] Build completed!
echo [INFO] Files are in: ui-react\dist\
echo.

echo ========================================
echo    Deploy to VPS
echo ========================================
echo.
echo [INFO] Copy the 'dist' folder contents to your VPS web directory
echo [INFO] Or serve via Node.js server at http://rbxid.com:8888
echo.

pause
