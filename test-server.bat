@echo off
echo ========================================
echo    RbxID Server Test
echo ========================================
echo.

echo [INFO] Testing server endpoints...
echo.

echo ========================================
echo    1. HEALTH CHECK
echo ========================================
echo [TEST] GET /health
curl -s http://localhost:8888/health
echo.
echo.

echo ========================================
echo    2. API KEYS
echo ========================================
echo [TEST] GET /api/keys
curl -s http://localhost:8888/api/keys
echo.
echo.

echo ========================================
echo    3. TELEMETRY ENDPOINT TEST
echo ========================================
echo [TEST] POST /api/telemetry (with valid key)
curl -X POST http://localhost:8888/api/telemetry ^
  -H "Content-Type: application/json" ^
  -d "{\"key\":\"fabdd044-a0c4-4ca2-9094-cf9cf94a2200\",\"PC\":\"fishis\",\"playerName\":\"TestPlayer\",\"level\":50,\"money\":1000}"
echo.
echo.

echo ========================================
echo    4. DATA RETRIEVAL
echo ========================================
echo [TEST] GET /api/data/fabdd044-a0c4-4ca2-9094-cf9cf94a2200
curl -s "http://localhost:8888/api/data/fabdd044-a0c4-4ca2-9094-cf9cf94a2200"
echo.
echo.

echo ========================================
echo    5. SERVER STATUS
echo ========================================
echo [INFO] If all tests pass, server is working correctly
echo [INFO] If any test fails, check server logs
echo.

pause
