@echo off
echo ========================================
echo    Test Real API Keys with Data
echo ========================================
echo.

echo [INFO] Testing all available API keys for data...
echo.

echo ========================================
echo    AVAILABLE KEYS
echo ========================================
echo [KEY 1] ddee1911-c6c4-4fb9-a65d-db25dc706907 (Demo key)
echo [KEY 2] 9442c0fa-9bc7-4c67-a59f-cb3efc21d487 (fish Gaming PC)
echo [KEY 3] cfd64aab-e56a-49ae-823d-f8df35c167ea (fishis Gaming PC)
echo [KEY 4] fabdd044-a0c4-4ca2-9094-cf9cf94a2200 (fishis Gaming PC)
echo.

echo ========================================
echo    TEST KEY 1: ddee1911...
echo ========================================
curl -s "http://103.58.149.243:8888/api/data?key=ddee1911-c6c4-4fb9-a65d-db25dc706907"
echo.
echo.

echo ========================================
echo    TEST KEY 2: 9442c0fa...
echo ========================================
curl -s "http://103.58.149.243:8888/api/data?key=9442c0fa-9bc7-4c67-a59f-cb3efc21d487"
echo.
echo.

echo ========================================
echo    TEST KEY 3: cfd64aab...
echo ========================================
curl -s "http://103.58.149.243:8888/api/data?key=cfd64aab-e56a-49ae-823d-f8df35c167ea"
echo.
echo.

echo ========================================
echo    TEST KEY 4: fabdd044...
echo ========================================
curl -s "http://103.58.149.243:8888/api/data?key=fabdd044-a0c4-4ca2-9094-cf9cf94a2200"
echo.
echo.

echo ========================================
echo    CHECK TELEMETRY FILES
echo ========================================
echo [INFO] Checking data files on server...
if exist "%~dp0server\rbxid_data" (
    echo [✅] Data directory exists
    dir "%~dp0server\rbxid_data" /b
) else (
    echo [❌] Data directory missing
)

echo.
echo ========================================
echo    SOLUTION
echo ========================================
echo [INFO] The telemetry script is using key: 10bf0ade...
echo [INFO] But this key is NOT in the server's key list
echo [INFO] 
echo [SOLUTION 1] Update telemetry script to use existing key:
echo [COPY THIS] fabdd044-a0c4-4ca2-9094-cf9cf94a2200
echo.
echo [SOLUTION 2] Create the missing key in server
echo [INFO] The server should have this key but it's missing
echo.

pause
