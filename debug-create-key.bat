@echo off
echo ========================================
echo    RbxID Debug Key Creator
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
echo [INFO] Testing server connection...

REM Test server first
echo [DEBUG] Testing http://localhost:3001/health
curl -s http://localhost:3001/health
echo.

if errorlevel 1 (
    echo [ERROR] Cannot connect to server at localhost:3001
    echo [INFO] Make sure server is running with: start-server.bat
    pause
    exit /b 1
)

echo [DEBUG] Server is running. Creating key...

REM Create API key with better error handling
curl -v -X POST http://localhost:3001/api/keys -H "Content-Type: application/json" -d "{\"machineName\": \"%machine_name%\", \"description\": \"%machine_name% Gaming PC\"}" > response.txt 2>&1

echo.
echo [DEBUG] Server response:
type response.txt
echo.

REM Try to extract key
for /f "tokens=*" %%i in ('findstr "key" response.txt') do set key_line=%%i
echo [DEBUG] Key line: %key_line%

REM Simple key extraction
for /f "tokens=2 delims=:" %%a in ('echo %key_line%') do (
    for /f "tokens=1 delims=," %%b in ("%%a") do (
        set api_key=%%b
    )
)

REM Remove quotes and spaces
set api_key=%api_key:"=%
set api_key=%api_key: =%

echo [DEBUG] Extracted key: %api_key%

if "%api_key%"=="" (
    echo [ERROR] Failed to extract API key from response
    echo [INFO] Check response.txt for details
    pause
    exit /b 1
)

echo.
echo [SUCCESS] API Key created: %api_key%
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
echo [INFO] Dashboard: http://localhost:3001
echo.
echo [DEBUG] Response saved to: response.txt
echo [DEBUG] Keys file should be at: server\rbxid_keys.json
echo.
pause
