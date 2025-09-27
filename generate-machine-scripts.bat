@echo off
echo ========================================
echo    RbxID Machine Script Generator
echo ========================================
echo.

set /p machine_name="Enter machine name (e.g., PC-Main, Laptop-Gaming): "
set /p api_key="Enter API key for this machine: "

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
echo [INFO] Generating script for: %machine_name%
echo [INFO] API Key: %api_key:~0,8%...

REM Create scripts directory if not exists
if not exist "scripts" mkdir scripts

REM Generate Lua script
(
echo getgenv^(^).Shop888_Settings = {
echo     ['key'] = '%api_key%',
echo     ['PC'] = '%machine_name%',
echo }
echo.
echo.
echo loadstring^(game:HttpGet^('https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_loader.lua'^)^)^(^) 
) > "scripts\%machine_name%.lua"

echo.
echo [SUCCESS] Script generated: scripts\%machine_name%.lua
echo.
echo [INFO] Usage instructions:
echo 1. Copy the content of scripts\%machine_name%.lua
echo 2. Paste and execute in Roblox executor on %machine_name%
echo 3. Data will be separated by API key: %api_key:~0,8%...
echo.
echo [INFO] Dashboard URL: http://rbxid.com
echo [INFO] Select your API key in dashboard to view %machine_name% data
echo.
pause
