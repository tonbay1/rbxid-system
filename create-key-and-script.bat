@echo off
echo ========================================
echo    RbxID: Create Key + Generate Script
echo ========================================
echo.

set /p machine_name="Enter machine name (e.g., PC-Main, ddc, abc): "

if "%machine_name%"=="" (
    echo [ERROR] Machine name cannot be empty!
    pause
    exit /b 1
)

echo.
echo [INFO] Creating API key for: %machine_name%
echo [INFO] Connecting to server...

REM Create API key via curl
for /f "tokens=*" %%i in ('curl -s -X POST http://localhost:3010/api/keys -H "Content-Type: application/json" -d "{\"machineName\": \"%machine_name%\", \"description\": \"%machine_name% Gaming PC\"}"') do set response=%%i

echo [INFO] Server response: %response%

REM Extract key from JSON response (simple method)
for /f "tokens=2 delims=:" %%a in ('echo %response% ^| findstr /C:"key"') do (
    for /f "tokens=1 delims=," %%b in ("%%a") do (
        set api_key=%%b
    )
)

REM Remove quotes from key
set api_key=%api_key:"=%

if "%api_key%"=="" (
    echo [ERROR] Failed to create API key. Make sure server is running at localhost:3010
    pause
    exit /b 1
)

echo.
echo [SUCCESS] API Key created: %api_key%
echo.

REM Create scripts directory if not exists
if not exist "scripts" mkdir scripts

REM Generate clean Lua script
(
echo getgenv^(^).Shop888_Settings = {
echo     ['key'] = '%api_key%',
echo     ['PC'] = '%machine_name%',
echo }
echo.
echo.
echo loadstring^(game:HttpGet^('https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_loader.lua'^)^)^(^) 
) > "scripts\%machine_name%.lua"

echo [SUCCESS] Script generated: scripts\%machine_name%.lua
echo.
echo ========================================
echo    COPY THIS SCRIPT FOR %machine_name%
echo ========================================
echo.
echo getgenv^(^).Shop888_Settings = {
echo     ['key'] = '%api_key%',
echo     ['PC'] = '%machine_name%',
echo }
echo.
echo.
echo loadstring^(game:HttpGet^('https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_loader.lua'^)^)^(^) 
echo.
echo ========================================
echo.
echo [INFO] Instructions:
echo 1. SELECT ALL the script above ^(Ctrl+A^)
echo 2. COPY it ^(Ctrl+C^)
echo 3. PASTE in Roblox executor on %machine_name%
echo 4. EXECUTE the script
echo 5. Data will appear in dashboard
echo.
echo [INFO] API Key: %api_key%
echo [INFO] Dashboard: http://localhost:3010
echo [INFO] Machine: %machine_name%
echo.
echo Press any key to close...
pause > nul
