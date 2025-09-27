@echo off
echo ========================================
echo    RbxID Manual Script Creator
echo ========================================
echo.

set /p machine_name="Enter machine name: "
set /p api_key="Enter API key: "

if "%machine_name%"=="" (
    echo [ERROR] Machine name cannot be empty!
    pause
    exit /b 1
)

if "%api_key%"=="" (
    echo [ERROR] API key cannot be empty!
    pause
    exit /b 1
)

echo.
echo ========================================
echo    COPY THIS SCRIPT FOR %machine_name%
echo ========================================
echo.
echo getgenv().Shop888_Settings = {
echo     ['key'] = '%api_key%',
echo     ['PC'] = '%machine_name%',
echo }
echo.
echo.
echo loadstring(game:HttpGet('https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_loader.lua'))() 
echo.
echo ========================================
echo.
echo [INSTRUCTIONS]
echo 1. SELECT ALL the script above (Ctrl+A)
echo 2. COPY it (Ctrl+C) 
echo 3. PASTE in Roblox executor
echo 4. EXECUTE the script
echo.
echo [INFO] API Key: %api_key%
echo [INFO] Machine: %machine_name%
echo [INFO] Dashboard: http://localhost:3010
echo.
echo Press any key to close...
pause > nul
