@echo off
echo ========================================
echo    Quick Fix - External Access Problem
echo ========================================
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] This script requires Administrator privileges
    echo [INFO] Right-click and select "Run as administrator"
    pause
    exit /b 1
)

echo [INFO] Applying quick fixes for external access...
echo.

echo ========================================
echo    FIX 1: Disable Windows Firewall (Temporary)
echo ========================================
netsh advfirewall set allprofiles state off
echo [✅] Windows Firewall disabled temporarily

echo.
echo ========================================
echo    FIX 2: Reset Port Forwarding
echo ========================================
netsh interface portproxy delete v4tov4 listenport=80 2>nul
netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=8888 connectaddress=127.0.0.1
echo [✅] Port forwarding: 80 → 8888

echo.
echo ========================================
echo    FIX 3: Restart Server with New Settings
echo ========================================
echo [INFO] Stopping any existing server...
taskkill /f /im node.exe 2>nul

echo [INFO] Starting server on all interfaces (0.0.0.0:8888)...
cd /d "%~dp0\server"
set PORT=8888

start "RbxID Server" cmd /k "echo Server running on all interfaces && node rbxid-server.js"

timeout /t 5 /nobreak >nul

echo.
echo ========================================
echo    TEST EXTERNAL ACCESS
echo ========================================
echo [INFO] Testing access from external IP...

REM Test via domain
curl -s http://rbxid.com | findstr "Fisch Dashboard" >nul
if %errorLevel% equ 0 (
    echo [✅] Domain access: http://rbxid.com WORKS!
) else (
    echo [❌] Domain access failed
)

REM Test via IP
curl -s http://103.58.149.243 | findstr "Fisch Dashboard" >nul
if %errorLevel% equ 0 (
    echo [✅] IP access: http://103.58.149.243 WORKS!
) else (
    echo [❌] IP access failed
)

echo.
echo ========================================
echo    RESULT
echo ========================================
echo [INFO] Quick fixes applied!
echo [INFO] 🌐 Test from other computers: http://rbxid.com
echo [INFO] 🔧 Direct IP: http://103.58.149.243
echo.
echo [WARNING] Windows Firewall is DISABLED for testing
echo [INFO] To re-enable: netsh advfirewall set allprofiles state on
echo.

start http://rbxid.com

pause
