@echo off
echo ========================================
echo    Test RbxID Dashboard
echo ========================================
echo.

echo [INFO] Testing dashboard endpoints...
echo.

echo ========================================
echo    1. SERVER STATUS
echo ========================================
curl -s http://localhost:8888/
echo.
echo.

echo ========================================
echo    2. API ENDPOINTS
echo ========================================
echo [TEST] GET /api/keys
curl -s http://localhost:8888/api/keys
echo.
echo.

echo [TEST] GET /health
curl -s http://localhost:8888/health
echo.
echo.

echo ========================================
echo    3. DASHBOARD ACCESS
echo ========================================
echo [INFO] Opening dashboard in browser...
start http://localhost:8888
echo.

echo [INFO] Dashboard URLs:
echo [INFO] Local: http://localhost:8888
echo [INFO] VPS: http://rbxid.com:8888
echo.

pause
