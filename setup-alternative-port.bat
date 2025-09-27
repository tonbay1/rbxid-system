@echo off
echo ========================================
echo    Setup Alternative Port (3000)
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

echo [INFO] Some ISPs block port 8888, trying port 3000...
echo.

echo ========================================
echo    STEP 1: Setup Port Forwarding (80→3000)
echo ========================================
netsh interface portproxy delete v4tov4 listenport=80 2>nul
netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=3000 connectaddress=127.0.0.1
echo [✅] Port forwarding: 80 → 3000

echo.
echo ========================================
echo    STEP 2: Configure Firewall
echo ========================================
netsh advfirewall firewall delete rule name="RbxID Port 3000" 2>nul
netsh advfirewall firewall add rule name="RbxID Port 3000" dir=in action=allow protocol=TCP localport=3000 profile=any
echo [✅] Firewall rule for port 3000

echo.
echo ========================================
echo    STEP 3: Start Server on Port 3000
echo ========================================
taskkill /f /im node.exe 2>nul
timeout /t 2 /nobreak >nul

cd /d "%~dp0\server"
set PORT=3000

echo [INFO] Starting server on port 3000...
start "RbxID Server (Port 3000)" cmd /k "echo Server on Port 3000 && node rbxid-server.js"

timeout /t 5 /nobreak >nul

echo.
echo ========================================
echo    STEP 4: Test Alternative Setup
echo ========================================
curl -s -m 5 http://localhost:3000 | findstr "Fisch Dashboard" >nul
if %errorLevel% equ 0 (
    echo [✅] Port 3000 local test passed
) else (
    echo [❌] Port 3000 local test failed
)

curl -s -m 10 http://rbxid.com | findstr "Fisch Dashboard" >nul
if %errorLevel% equ 0 (
    echo [✅] Domain access works with port 3000!
    echo [SUCCESS] 🌐 Dashboard: http://rbxid.com
) else (
    echo [❌] Domain access still failed
)

echo.
echo ========================================
echo    RESULT
echo ========================================
echo [INFO] Alternative port setup complete
echo [INFO] 🌐 Try: http://rbxid.com
echo [INFO] 🔧 Direct: http://103.58.149.243:3000
echo.

pause
