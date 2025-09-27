@echo off
echo ========================================
echo    VPS Setup for RbxID (Port 8888)
echo ========================================
echo.

echo [INFO] Opening Windows Firewall for port 8888...
echo.

REM Allow inbound traffic on port 8888
netsh advfirewall firewall add rule name="RbxID Server Port 8888" dir=in action=allow protocol=TCP localport=8888

REM Allow outbound traffic on port 8888
netsh advfirewall firewall add rule name="RbxID Server Port 8888 Out" dir=out action=allow protocol=TCP localport=8888

echo.
echo [SUCCESS] Firewall rules added for port 8888
echo.

echo ========================================
echo    Network Test
echo ========================================
echo.

echo [INFO] Testing if port 8888 is accessible...
netstat -an | findstr :8888

echo.
echo [INFO] Your VPS IP addresses:
ipconfig | findstr "IPv4"

echo.
echo ========================================
echo    DNS Configuration Needed
echo ========================================
echo.
echo [IMPORTANT] You need to configure DNS:
echo.
echo 1. Go to your domain registrar (where you bought rbxid.com)
echo 2. Add/Update A record:
echo    - Name: @ (or rbxid.com)
echo    - Type: A
echo    - Value: [YOUR_VPS_IP]
echo    - TTL: 300 (5 minutes)
echo.
echo 3. Test with: nslookup rbxid.com
echo.

pause
