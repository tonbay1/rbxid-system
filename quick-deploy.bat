@echo off
echo ========================================
echo    Quick Deploy to VPS
echo ========================================
echo.

REM Compress files to ZIP
echo [INFO] Creating deployment package...
powershell -Command "Compress-Archive -Path '.\*' -DestinationPath 'deploy.zip' -Force"

echo [INFO] Uploading to VPS...
REM Upload via curl (requires curl on Windows)
curl -X POST -F "file=@deploy.zip" -F "token=DEPLOY_TOKEN" http://103.58.149.243:3010/deploy

echo [INFO] Cleaning up...
del deploy.zip

echo.
echo [SUCCESS] Deploy completed!
echo [INFO] Check: http://rbxid.com:3010/health
pause
