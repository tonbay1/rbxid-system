@echo off
echo ========================================
echo    Setup Port Forwarding for rbxid.com
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

echo [INFO] Setting up port forwarding...
echo [INFO] This will redirect port 80 → 8888
echo.

echo ========================================
echo    STEP 1: Remove existing rules (if any)
echo ========================================
netsh interface portproxy delete v4tov4 listenport=80 listenaddress=0.0.0.0 2>nul
echo [INFO] Cleared existing port 80 forwarding

echo.
echo ========================================
echo    STEP 2: Add new forwarding rule
echo ========================================
netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=8888 connectaddress=127.0.0.1

if %errorLevel% equ 0 (
    echo [SUCCESS] Port forwarding added: 80 → 8888
) else (
    echo [ERROR] Failed to add port forwarding
    pause
    exit /b 1
)

echo.
echo ========================================
echo    STEP 3: Configure Windows Firewall
echo ========================================
netsh advfirewall firewall add rule name="RbxID HTTP Port 80" dir=in action=allow protocol=TCP localport=80 2>nul
echo [INFO] Firewall rule added for port 80

echo.
echo ========================================
echo    STEP 4: Verify configuration
echo ========================================
echo [INFO] Current port forwarding rules:
netsh interface portproxy show all

echo.
echo ========================================
echo    RESULT
echo ========================================
echo [SUCCESS] Setup completed!
echo.
echo [INFO] Now users can access:
echo [INFO] ✅ http://rbxid.com (no port needed)
echo [INFO] ✅ http://www.rbxid.com
echo [INFO] ✅ http://rbxid.com:8888 (direct)
echo.
echo [WARNING] Make sure your RbxID server is running on port 8888
echo [COMMAND] Use: start-server-8888.bat
echo.

pause
