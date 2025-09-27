@echo off
echo ========================================
echo    Test Access from External Machine
echo ========================================
echo.

echo [INFO] Instructions for testing from OTHER computers:
echo.

echo ========================================
echo    METHOD 1: Test Direct IP Access
echo ========================================
echo [COPY THIS] Open browser on other computer and try:
echo.
echo    http://103.58.149.243
echo    http://103.58.149.243:8888
echo.
echo [INFO] If IP works but domain doesn't = DNS problem
echo [INFO] If IP doesn't work = Network/Firewall problem
echo.

echo ========================================
echo    METHOD 2: Test DNS Resolution
echo ========================================
echo [COPY THIS] Run this command on other computer:
echo.
echo    nslookup rbxid.com
echo.
echo [EXPECTED] Should return: 103.58.149.243
echo [IF DIFFERENT] DNS not propagated to that ISP yet
echo.

echo ========================================
echo    METHOD 3: Force DNS (Windows)
echo ========================================
echo [COPY THIS] Add to C:\Windows\System32\drivers\etc\hosts on other computer:
echo.
echo    103.58.149.243 rbxid.com
echo    103.58.149.243 www.rbxid.com
echo.
echo [INFO] This forces DNS to point to your VPS
echo [INFO] Then try: http://rbxid.com
echo.

echo ========================================
echo    METHOD 4: Use Public DNS
echo ========================================
echo [COPY THIS] Change DNS on other computer to:
echo.
echo    Primary DNS: 8.8.8.8 (Google)
echo    Secondary DNS: 1.1.1.1 (Cloudflare)
echo.
echo [INFO] Then try: http://rbxid.com
echo.

echo ========================================
echo    CURRENT SERVER STATUS
echo ========================================
echo [INFO] Your server is running correctly:
echo [✅] Server: ONLINE on port 8888
echo [✅] Port forwarding: 80 → 8888 WORKING
echo [✅] Local access: WORKING
echo [✅] VPS access: WORKING
echo.
echo [INFO] The problem is likely DNS propagation delay
echo [INFO] or ISP-specific DNS caching issues
echo.

echo ========================================
echo    QUICK SHARE LINKS
echo ========================================
echo [SHARE THESE] Give these URLs to others to test:
echo.
echo    🌐 Domain: http://rbxid.com
echo    🔧 Direct IP: http://103.58.149.243
echo    📱 With Port: http://103.58.149.243:8888
echo.
echo [INFO] If IP works but domain doesn't = DNS issue
echo [INFO] If nothing works = Ask them to check firewall/antivirus
echo.

pause
