@echo off
echo ========================================
echo    Test Fixed Dashboard
echo ========================================
echo.

echo [INFO] Testing dashboard with new build...
echo.

echo ========================================
echo    1. CLEAR BROWSER CACHE
echo ========================================
echo [INFO] Dashboard updated - may need to clear browser cache
echo [INFO] Press Ctrl+F5 to force refresh in browser
echo.

echo ========================================
echo    2. TEST API CONNECTION
echo ========================================
echo [TEST] API Keys endpoint
curl -s http://103.58.149.243:8888/api/keys | findstr "success"
if %errorLevel% equ 0 (
    echo [✅] API Keys working
) else (
    echo [❌] API Keys failed
)

echo.
echo [TEST] Telemetry data for key: 10bf0ade-a0c4-4ca2-9094-cf9cf94a2200
curl -s "http://103.58.149.243:8888/api/data?key=10bf0ade-a0c4-4ca2-9094-cf9cf94a2200" | findstr "tonbay2542"
if %errorLevel% equ 0 (
    echo [✅] Telemetry data found for tonbay2542
) else (
    echo [❌] No telemetry data found
)

echo.
echo ========================================
echo    3. OPEN UPDATED DASHBOARD
echo ========================================
echo [INFO] Opening dashboard with updated build...
start http://103.58.149.243:8888

echo.
echo [INFO] Dashboard URLs:
echo [INFO] 🌐 Main: http://103.58.149.243:8888
echo [INFO] 🔧 With API param: http://103.58.149.243:8888?api=http://103.58.149.243:8888
echo.

echo ========================================
echo    4. TESTING INSTRUCTIONS
echo ========================================
echo [INFO] In the dashboard:
echo [INFO] 1. Enter API Key: 10bf0ade-a0c4-4ca2-9094-cf9cf94a2200
echo [INFO] 2. Should see data for: tonbay2542
echo [INFO] 3. Check browser console (F12) for any errors
echo.
echo [INFO] If still not working:
echo [INFO] - Press Ctrl+F5 to force refresh
echo [INFO] - Clear browser cache completely
echo [INFO] - Check browser console for errors
echo.

pause
