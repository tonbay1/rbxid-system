@echo off
echo ========================================
echo    Diagnose Connection Issues
echo ========================================
echo.

echo [INFO] Checking server and network status...
echo.

echo ========================================
echo    1. CHECK SERVER PROCESS
echo ========================================
tasklist | findstr node.exe
if %errorLevel% equ 0 (
    echo [✅] Node.js process running
) else (
    echo [❌] Node.js process NOT running
    echo [SOLUTION] Server crashed - need to restart
    goto :restart_server
)

echo.
echo ========================================
echo    2. CHECK LISTENING PORTS
echo ========================================
netstat -an | findstr ":8888.*LISTENING"
if %errorLevel% equ 0 (
    echo [✅] Server listening on port 8888
) else (
    echo [❌] Server NOT listening on port 8888
    goto :restart_server
)

echo.
echo ========================================
echo    3. TEST LOCAL CONNECTION
echo ========================================
curl -s -m 3 http://localhost:8888 >nul 2>&1
if %errorLevel% equ 0 (
    echo [✅] Local connection works
) else (
    echo [❌] Local connection failed
    goto :restart_server
)

echo.
echo ========================================
echo    4. TEST EXTERNAL IP (Direct)
echo ========================================
curl -s -m 10 http://103.58.149.243:8888 >nul 2>&1
if %errorLevel% equ 0 (
    echo [✅] External IP:8888 works
) else (
    echo [❌] External IP:8888 failed - VPS/ISP blocking?
)

echo.
echo ========================================
echo    5. TEST PORT 80 (Via Port Forwarding)
echo ========================================
curl -s -m 10 http://103.58.149.243 >nul 2>&1
if %errorLevel% equ 0 (
    echo [✅] Port 80 works
) else (
    echo [❌] Port 80 failed - Port forwarding issue?
)

echo.
echo ========================================
echo    DIAGNOSIS COMPLETE
echo ========================================
echo [INFO] If external access failed, possible causes:
echo [INFO] 1. VPS Provider blocks incoming connections
echo [INFO] 2. ISP blocks certain ports
echo [INFO] 3. Server crashed and needs restart
echo.
goto :end

:restart_server
echo.
echo ========================================
echo    RESTARTING SERVER
echo ========================================
echo [INFO] Server not running properly - restarting...

REM Kill existing processes
taskkill /f /im node.exe 2>nul
timeout /t 2 /nobreak >nul

REM Start server
cd /d "%~dp0\server"
set PORT=8888
echo [INFO] Starting server on 0.0.0.0:8888...

start "RbxID Server" cmd /k "echo RbxID Server Restarted && node rbxid-server.js"

timeout /t 5 /nobreak >nul

echo [INFO] Server restarted - testing again...
curl -s -m 3 http://localhost:8888 >nul 2>&1
if %errorLevel% equ 0 (
    echo [✅] Server restart successful
    echo [INFO] Try accessing: http://rbxid.com
) else (
    echo [❌] Server restart failed
    echo [INFO] Check server logs in the new window
)

:end
echo.
pause
