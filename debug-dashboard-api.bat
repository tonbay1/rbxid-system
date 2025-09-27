@echo off
echo ========================================
echo    Debug Dashboard API Connection
========================================
echo.

echo [INFO] Testing API endpoints that dashboard uses...
echo.

echo ========================================
echo    1. TEST API KEYS ENDPOINT
========================================
echo [TEST] GET /api/keys
curl -s http://localhost:8888/api/keys
echo.
echo.

echo ========================================
echo    2. TEST SPECIFIC KEY DATA
========================================
set /p test_key="Enter API key to test (or press Enter for demo): "
if "%test_key%"=="" set test_key=10bf0ade-a0c4-4ca2-9094-cf9cf94a2200

echo [TEST] GET /api/data?key=%test_key%
curl -s "http://localhost:8888/api/data?key=%test_key%"
echo.
echo.

echo ========================================
echo    3. TEST CORS HEADERS
========================================
echo [TEST] OPTIONS request (CORS preflight)
curl -s -X OPTIONS -H "Origin: http://localhost:5173" -H "Access-Control-Request-Method: GET" http://localhost:8888/api/keys -v
echo.

echo ========================================
echo    4. CHECK REACT BUILD FILES
========================================
echo [INFO] Checking if React files exist...
if exist "%~dp0ui-react\dist\index.html" (
    echo [✅] React build exists
) else (
    echo [❌] React build missing - need to run build-dashboard.bat
)

if exist "%~dp0ui-react\dist\assets" (
    echo [✅] React assets exist
    dir "%~dp0ui-react\dist\assets" /b
) else (
    echo [❌] React assets missing
)

echo.
echo ========================================
echo    5. TEST DASHBOARD STATIC FILES
========================================
echo [TEST] Dashboard index.html
curl -s http://localhost:8888/ | findstr "Fisch Dashboard"
if %errorLevel% equ 0 (
    echo [✅] Dashboard HTML loads
) else (
    echo [❌] Dashboard HTML failed
)

echo.
echo ========================================
echo    6. CHECK SERVER LOGS
========================================
echo [INFO] Recent server activity should show API calls
echo [INFO] Check the server console window for errors
echo.

echo ========================================
echo    DIAGNOSIS
========================================
echo [INFO] Common issues:
echo [INFO] 1. CORS not configured properly
echo [INFO] 2. React app not connecting to correct API URL
echo [INFO] 3. API endpoints returning wrong format
echo [INFO] 4. JavaScript errors in browser console
echo.
echo [SOLUTION] Check browser Developer Tools (F12) for errors
echo.

pause
