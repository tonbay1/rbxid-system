@echo off
echo ========================================
echo    Check DNS Propagation Status
echo ========================================
echo.

echo [INFO] Checking DNS propagation for rbxid.com...
echo.

echo ========================================
echo    1. LOCAL DNS RESOLUTION
echo ========================================
nslookup rbxid.com
echo.

echo ========================================
echo    2. GOOGLE DNS (8.8.8.8)
echo ========================================
nslookup rbxid.com 8.8.8.8
echo.

echo ========================================
echo    3. CLOUDFLARE DNS (1.1.1.1)
echo ========================================
nslookup rbxid.com 1.1.1.1
echo.

echo ========================================
echo    4. TEST DIFFERENT URLS
echo ========================================
echo [TEST] Ping domain
ping -n 1 rbxid.com

echo.
echo [TEST] Ping IP directly
ping -n 1 103.58.149.243

echo.
echo ========================================
echo    5. ONLINE DNS PROPAGATION CHECK
echo ========================================
echo [INFO] Check DNS propagation worldwide:
echo [LINK] https://www.whatsmydns.net/#A/rbxid.com
echo.
echo [INFO] This shows if DNS is propagated globally
echo [INFO] Green = Working, Red = Not propagated yet
echo.

echo ========================================
echo    TEMPORARY SOLUTION
echo ========================================
echo [INFO] While waiting for DNS propagation:
echo [INFO] Tell others to use DIRECT IP access:
echo.
echo    ✅ http://103.58.149.243
echo    ✅ http://103.58.149.243:8888
echo.
echo [INFO] DNS propagation can take 24-48 hours worldwide
echo [INFO] But your server is working perfectly!
echo.

start https://www.whatsmydns.net/#A/rbxid.com

pause
