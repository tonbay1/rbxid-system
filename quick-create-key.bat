@echo off
echo ========================================
echo    RbxID Quick Key Creator
echo ========================================
echo.

set /p machine_name="Enter machine name: "

if "%machine_name%"=="" (
    echo [ERROR] Machine name cannot be empty!
    pause
    exit /b 1
)

echo.
echo [INFO] Creating API key for: %machine_name%

REM Create API key
echo [DEBUG] Sending request to server...
curl -s -X POST http://localhost:8888/api/keys -H "Content-Type: application/json" -d "{\"machineName\": \"%machine_name%\", \"description\": \"%machine_name% Gaming PC\"}" > temp_response.json

echo [DEBUG] Server response:
type temp_response.json
echo.

REM Extract key using PowerShell (more reliable)
for /f "usebackq delims=" %%i in (`powershell -Command "(Get-Content temp_response.json | ConvertFrom-Json).key"`) do set api_key=%%i

REM Clean up
del temp_response.json 2>nul

if "%api_key%"=="" (
    echo [ERROR] Failed to create API key. Server might not be running.
    pause
    exit /b 1
)

echo [SUCCESS] API Key created: %api_key%
echo.
echo ========================================
echo    COPY THIS SCRIPT FOR %machine_name%
echo ========================================
echo.
echo getgenv().Shop888_Settings = {
echo     ['key'] = '%api_key%',
echo     ['PC'] = '%machine_name%',
echo     ['apiBase'] = 'http://rbxid.com:8888'
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
echo [INFO] Dashboard: http://localhost:8888
echo.
echo Press any key to close...
pause > nul
