@echo off
echo ========================================
echo    Force Dashboard to Use Correct API
echo ========================================
echo.

echo [INFO] Dashboard is calling wrong API URL
echo [WRONG] https://rbxid.com/api/data
echo [RIGHT] http://103.58.149.243:8888/api/data
echo.

echo ========================================
echo    SOLUTION: Use API Parameter
echo ========================================
echo [INFO] Opening dashboard with forced API URL...

start "Dashboard with Correct API" "http://103.58.149.243:8888/?api=http://103.58.149.243:8888"

echo.
echo [INFO] Dashboard opened with API parameter
echo [INFO] This forces the dashboard to use the correct server
echo.

echo ========================================
echo    TEST INSTRUCTIONS
echo ========================================
echo [STEP 1] In the new browser window:
echo [STEP 2] Enter API Key: fabdd044-a0c4-4ca2-9094-cf9cf94a2200
echo [STEP 3] Click "Load Data" or press Enter
echo [STEP 4] Should see tonbay2542 data now!
echo.

echo ========================================
echo    ALTERNATIVE: Manual Test
echo ========================================
echo [INFO] If still not working, test API directly:
echo.
curl -s "http://103.58.149.243:8888/api/data?key=fabdd044-a0c4-4ca2-9094-cf9cf94a2200"
echo.
echo.

echo [INFO] If you see data above, the API works
echo [INFO] The problem is dashboard configuration
echo.

pause
