@echo off
echo ========================================
echo    Fix External Access to rbxid.com
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

echo [INFO] Fixing external access issues...
echo.

echo ========================================
echo    STEP 1: Configure Windows Firewall
echo ========================================

REM Allow inbound connections on port 80
netsh advfirewall firewall delete rule name="RbxID HTTP Port 80" 2>nul
netsh advfirewall firewall add rule name="RbxID HTTP Port 80" dir=in action=allow protocol=TCP localport=80 profile=any

REM Allow inbound connections on port 8888
netsh advfirewall firewall delete rule name="RbxID Server Port 8888" 2>nul
netsh advfirewall firewall add rule name="RbxID Server Port 8888" dir=in action=allow protocol=TCP localport=8888 profile=any

echo [✅] Firewall rules updated

echo.
echo ========================================
echo    STEP 2: Check Port Forwarding
echo ========================================
echo [INFO] Current port forwarding rules:
netsh interface portproxy show all

echo.
echo ========================================
echo    STEP 3: Reset Port Forwarding
echo ========================================
REM Remove and re-add port forwarding
netsh interface portproxy delete v4tov4 listenport=80 listenaddress=0.0.0.0 2>nul
netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=8888 connectaddress=127.0.0.1

echo [✅] Port forwarding reset: 80 → 8888

echo.
echo ========================================
echo    STEP 4: Test Network Binding
echo ========================================
echo [INFO] Testing if server binds to all interfaces...

REM Check if server is listening on all interfaces
netstat -an | findstr ":8888"
if %errorLevel% equ 0 (
    echo [✅] Server is listening on port 8888
) else (
    echo [❌] Server not listening on port 8888
    echo [INFO] Make sure server is running: start-server-8888.bat
)

echo.
echo ========================================
echo    STEP 5: Test External Access
echo ========================================
echo [INFO] Testing external access...

REM Test local access first
curl -s http://localhost:8888 | findstr "Fisch Dashboard" >nul
if %errorLevel% equ 0 (
    echo [✅] Local access works
) else (
    echo [❌] Local access failed
)

REM Test via IP
curl -s http://103.58.149.243:8888 | findstr "Fisch Dashboard" >nul
if %errorLevel% equ 0 (
    echo [✅] IP access works
) else (
    echo [❌] IP access failed
)

echo.
echo ========================================
echo    STEP 6: Advanced Network Settings
echo ========================================

REM Disable Windows Defender Firewall temporarily for testing
echo [INFO] Temporarily disabling Windows Firewall for testing...
netsh advfirewall set allprofiles state off

echo [WARNING] Windows Firewall is now DISABLED for testing
echo [WARNING] Remember to re-enable it later!

echo.
echo ========================================
echo    RESULT
echo ========================================
echo [INFO] External access should now work
echo [INFO] Test from another computer: http://rbxid.com
echo [INFO] Or test with IP: http://103.58.149.243
echo.
echo [WARNING] To re-enable firewall later, run:
echo [COMMAND] netsh advfirewall set allprofiles state on
echo.

pause
