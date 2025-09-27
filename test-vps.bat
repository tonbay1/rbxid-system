@echo off
echo ========================================
echo    RbxID VPS Server Test
echo ========================================
echo.

set /p VPS_IP="Enter VPS IP address: "
if "%VPS_IP%"=="" set VPS_IP=YOUR_VPS_IP

echo [INFO] Testing VPS server at %VPS_IP%:8888
echo.

echo ========================================
echo    1. HEALTH CHECK
echo ========================================
echo [TEST] GET /health
curl -s http://%VPS_IP%:8888/health
echo.
echo.

echo ========================================
echo    2. API KEYS
echo ========================================
echo [TEST] GET /api/keys
curl -s http://%VPS_IP%:8888/api/keys
echo.
echo.

echo ========================================
echo    3. TELEMETRY ENDPOINT TEST
echo ========================================
echo [TEST] POST /api/telemetry (with valid key)
curl -X POST http://%VPS_IP%:8888/api/telemetry ^
  -H "Content-Type: application/json" ^
  -d "{\"key\":\"fabdd044-a0c4-4ca2-9094-cf9cf94a2200\",\"PC\":\"fishis\",\"playerName\":\"TestPlayer\",\"level\":50,\"money\":1000}"
echo.
echo.

echo ========================================
echo    4. DATA RETRIEVAL
echo ========================================
echo [TEST] GET /api/data/fabdd044-a0c4-4ca2-9094-cf9cf94a2200
curl -s "http://%VPS_IP%:8888/api/data/fabdd044-a0c4-4ca2-9094-cf9cf94a2200"
echo.
echo.

echo ========================================
echo    5. VPS STATUS
echo ========================================
echo [INFO] VPS IP: %VPS_IP%
echo [INFO] Dashboard: http://%VPS_IP%:8888
echo [INFO] API: http://%VPS_IP%:8888/api
echo.

pause
