@echo off
echo ========================================
echo    Test Public Access to rbxid.com
echo ========================================
echo.

echo [INFO] Testing public access to dashboard...
echo.

echo ========================================
echo    1. TEST LOCAL SERVER (Port 8888)
echo ========================================
echo [TEST] http://localhost:8888
curl -s http://localhost:8888 | findstr "Fisch Dashboard" >nul
if %errorLevel% equ 0 (
    echo [✅] Local server running on port 8888
) else (
    echo [❌] Local server NOT running
    echo [INFO] Run: start-server-8888.bat
    goto :end
)

echo.
echo ========================================
echo    2. TEST PUBLIC DOMAIN (Port 80)
echo ========================================
echo [TEST] http://rbxid.com
curl -s http://rbxid.com | findstr "Fisch Dashboard" >nul
if %errorLevel% equ 0 (
    echo [✅] Public domain accessible!
    echo [INFO] Dashboard: http://rbxid.com
) else (
    echo [❌] Public domain not accessible
    echo [INFO] Check port forwarding setup
)

echo.
echo ========================================
echo    3. TEST API ENDPOINTS
echo ========================================
echo [TEST] API Keys
curl -s http://rbxid.com/api/keys | findstr "success" >nul
if %errorLevel% equ 0 (
    echo [✅] API working
) else (
    echo [❌] API not working
)

echo.
echo ========================================
echo    4. OPEN DASHBOARD IN BROWSER
echo ========================================
echo [INFO] Opening dashboard...
start http://rbxid.com

echo.
echo [INFO] Dashboard URLs:
echo [INFO] 🌐 Public: http://rbxid.com
echo [INFO] 🔧 Direct: http://rbxid.com:8888
echo [INFO] 💻 Local: http://localhost:8888
echo.

:end
pause
