@echo off
echo ========================================
echo    RbxID Auto Deploy to VPS
echo ========================================
echo.

echo [INFO] Deploying to VPS: 103.58.149.243
echo [INFO] Target: http://rbxid.com:3010

REM Send deploy signal to server
echo [INFO] Sending deploy signal...
curl -X POST -H "Content-Type: application/json" -d "{\"token\":\"rbxid-deploy-2024\",\"source\":\"local\"}" http://103.58.149.243:3010/deploy

echo.
echo [INFO] Waiting for server restart...
timeout /t 5 /nobreak > nul

echo [INFO] Testing server health...
curl -s http://103.58.149.243:3010/health

echo.
echo [SUCCESS] Deploy completed!
echo [INFO] Server: http://rbxid.com:3010
echo [INFO] Dashboard: http://rbxid.com:3010
echo [INFO] Script URL: http://rbxid.com:3010/script
echo.
pause
