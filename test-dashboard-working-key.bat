@echo off
echo ========================================
echo    Test Dashboard with Working Key
echo ========================================
echo.

echo [INFO] Testing dashboard with key that has data...
echo.

echo ========================================
echo    WORKING KEY WITH DATA
echo ========================================
echo [KEY] fabdd044-a0c4-4ca2-9094-cf9cf94a2200
echo [DATA] TestPlayer, Level 50, Money 1000
echo [STATUS] ✅ Has data in server
echo.

echo ========================================
echo    TEST API CALL
echo ========================================
echo [TEST] Getting data for working key...
curl -s "http://103.58.149.243:8888/api/data?key=fabdd044-a0c4-4ca2-9094-cf9cf94a2200"
echo.
echo.

echo ========================================
echo    OPEN DASHBOARD
echo ========================================
echo [INFO] Opening dashboard...
start http://103.58.149.243:8888

echo.
echo ========================================
echo    DASHBOARD TEST INSTRUCTIONS
echo ========================================
echo [STEP 1] In the dashboard, enter this API key:
echo.
echo    fabdd044-a0c4-4ca2-9094-cf9cf94a2200
echo.
echo [STEP 2] Click "Load Data" or press Enter
echo.
echo [STEP 3] You should see:
echo    - Player: TestPlayer
echo    - Level: 50  
echo    - Money: 1000
echo    - Status: Offline
echo.
echo [STEP 4] If you see "Network error":
echo    - Press F12 to open Developer Tools
echo    - Check Console tab for errors
echo    - Try Ctrl+F5 to force refresh
echo.

echo ========================================
echo    FIX TELEMETRY SCRIPT
echo ========================================
echo [INFO] To fix the telemetry script sending to wrong key:
echo [INFO] Update your Lua script to use this key:
echo.
echo    getgenv().Shop888_Settings = {
echo        ['key'] = 'fabdd044-a0c4-4ca2-9094-cf9cf94a2200',
echo        ['PC'] = 'YourPCName',
echo        ['apiBase'] = 'http://103.58.149.243:8888'
echo    }
echo.

pause
