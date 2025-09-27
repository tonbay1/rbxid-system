@echo off
echo ========================================
echo    Enable Firewall with Secure Rules
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

echo [INFO] Re-enabling Windows Firewall with secure rules...
echo.

echo ========================================
echo    STEP 1: Enable Windows Firewall
echo ========================================
netsh advfirewall set allprofiles state on
echo [✅] Windows Firewall enabled

echo.
echo ========================================
echo    STEP 2: Add Specific Rules for RbxID
echo ========================================

REM Allow HTTP (port 80)
netsh advfirewall firewall add rule name="RbxID HTTP (Port 80)" dir=in action=allow protocol=TCP localport=80 profile=any
echo [✅] Port 80 (HTTP) allowed

REM Allow RbxID Server (port 8888)
netsh advfirewall firewall add rule name="RbxID Server (Port 8888)" dir=in action=allow protocol=TCP localport=8888 profile=any
echo [✅] Port 8888 (RbxID) allowed

echo.
echo ========================================
echo    STEP 3: Test Access After Firewall
echo ========================================
echo [INFO] Testing access with firewall enabled...

timeout /t 3 /nobreak >nul

curl -s -m 5 http://localhost:8888 | findstr "Fisch Dashboard" >nul
if %errorLevel% equ 0 (
    echo [✅] Local access still works
) else (
    echo [❌] Local access failed
)

curl -s -m 5 http://rbxid.com | findstr "Fisch Dashboard" >nul
if %errorLevel% equ 0 (
    echo [✅] Domain access still works
) else (
    echo [❌] Domain access failed
)

echo.
echo ========================================
echo    RESULT
echo ========================================
echo [SUCCESS] Firewall re-enabled with secure rules!
echo.
echo [INFO] 🌐 Public Dashboard: http://rbxid.com
echo [INFO] 🔒 Security: Firewall enabled with specific rules
echo [INFO] 📊 Share URL with others: http://rbxid.com
echo.
echo [INFO] Current firewall rules for RbxID:
netsh advfirewall firewall show rule name="RbxID HTTP (Port 80)"
netsh advfirewall firewall show rule name="RbxID Server (Port 8888)"

echo.
pause
