@echo off
echo ========================================
echo    Environment Variables Check
echo ========================================
echo.

echo [INFO] Current PORT variable: %PORT%
echo [INFO] Current NODE_ENV: %NODE_ENV%
echo.

echo [INFO] All environment variables containing 'PORT':
set | findstr PORT

echo.
echo [INFO] Clearing PORT variable...
set PORT=
echo [INFO] PORT after clear: %PORT%

pause
