# 🖥️ VPS Setup Guide for rbxid.com

## 📋 Prerequisites
- Windows VPS: 103.58.149.243
- Domain: rbxid.com
- Admin access to VPS

## 🔧 Step 1: Install Node.js on VPS

### Download & Install Node.js
1. เข้า VPS ผ่าน RDP
2. เปิด browser ไปที่: https://nodejs.org/
3. Download "LTS" version (แนะนำ v18 หรือใหม่กว่า)
4. ติดตั้งตามขั้นตอน (เลือก "Add to PATH")
5. เปิด PowerShell แล้วทดสอบ:
```powershell
node --version
npm --version
```

## 🌐 Step 2: Configure Windows Firewall

### เปิด Port 3010 สำหรับ HTTP
```powershell
# เปิด PowerShell as Administrator
New-NetFirewallRule -DisplayName "RbxID HTTP" -Direction Inbound -Protocol TCP -LocalPort 3010 -Action Allow
New-NetFirewallRule -DisplayName "RbxID HTTP Out" -Direction Outbound -Protocol TCP -LocalPort 3010 -Action Allow
```

### หรือใช้ GUI:
1. เปิด "Windows Defender Firewall with Advanced Security"
2. คลิก "Inbound Rules" → "New Rule"
3. เลือก "Port" → "TCP" → "Specific Local Ports: 3010"
4. เลือก "Allow the connection"
5. ตั้งชื่อ "RbxID Server"

## 📁 Step 3: Upload Files to VPS

### วิธีที่ 1: Remote Desktop Copy-Paste
1. เชื่อมต่อ VPS ผ่าน RDP
2. Copy โฟลเดอร์ `rbxid-system` จากเครื่องของคุณ
3. Paste ไปที่ `C:\rbxid-system\`

### วิธีที่ 2: GitHub (แนะนำ)
```powershell
# ใน VPS PowerShell
cd C:\
git clone https://github.com/YOUR-USERNAME/rbxid-system.git
cd rbxid-system
```

## 🚀 Step 4: Start Server on VPS

```powershell
# เข้าไปในโฟลเดอร์
cd C:\rbxid-system\server

# ติดตั้ง dependencies (ถ้ามี)
npm install

# เริ่ม server
node rbxid-server.js
```

### หรือใช้ Batch File:
```powershell
# Double-click
C:\rbxid-system\start-server.bat
```

## 🔒 Step 5: Install IIS (Optional - สำหรับ Reverse Proxy)

### ติดตั้ง IIS
1. เปิด "Turn Windows features on or off"
2. เลือก "Internet Information Services (IIS)"
3. เลือก "Web Management Tools" และ "World Wide Web Services"
4. คลิก OK

### ตั้งค่า IIS Reverse Proxy
1. ติดตั้ง "URL Rewrite" และ "Application Request Routing" modules
2. สร้าง website ใหม่ชื่อ "rbxid.com"
3. ตั้งค่า binding: Port 80, Host name: rbxid.com
4. เพิ่ม web.config:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <system.webServer>
        <rewrite>
            <rules>
                <rule name="ReverseProxyInboundRule1" stopProcessing="true">
                    <match url="(.*)" />
                    <action type="Rewrite" url="http://localhost:3010/{R:1}" />
                </rule>
            </rules>
        </rewrite>
    </system.webServer>
</configuration>
```

## 🔐 Step 6: SSL Certificate (HTTPS)

### วิธีที่ 1: Let's Encrypt (ฟรี)
1. ติดตั้ง Certbot for Windows
2. รัน: `certbot --iis -d rbxid.com -d www.rbxid.com`

### วิธีที่ 2: Cloudflare (แนะนำ)
1. เพิ่มโดเมนใน Cloudflare
2. เปลี่ยน Nameservers ตามที่ Cloudflare บอก
3. เปิด "SSL/TLS" → "Full (strict)"
4. เปิด "Always Use HTTPS"

## ⚡ Step 7: Auto-Start Service (Optional)

### สร้าง Windows Service
1. ติดตั้ง `node-windows`:
```powershell
npm install -g node-windows
```

2. สร้างไฟล์ `install-service.js`:
```javascript
var Service = require('node-windows').Service;

var svc = new Service({
  name:'RbxID Server',
  description: 'RbxID Telemetry Server',
  script: 'C:\\rbxid-system\\server\\rbxid-server.js'
});

svc.on('install',function(){
  svc.start();
});

svc.install();
```

3. รัน: `node install-service.js`

## 🧪 Step 8: Test Everything

### ทดสอบ Local
```powershell
# ใน VPS browser
http://localhost:3010
http://localhost:3010/health
```

### ทดสอบ External
```bash
# จากเครื่องอื่น
http://103.58.149.243:3010
http://rbxid.com (ถ้าตั้งค่า DNS แล้ว)
https://rbxid.com (ถ้าตั้งค่า SSL แล้ว)
```

## 🔍 Troubleshooting

### Server ไม่เริ่ม
```powershell
# ตรวจสอบ port ว่าถูกใช้หรือไม่
netstat -ano | findstr :3010

# ดู process ที่ใช้ port
tasklist /fi "pid eq PROCESS_ID"
```

### โดเมนไม่ทำงาน
1. ตรวจสอบ DNS propagation: https://dnschecker.org/
2. ตรวจสอบ Firewall rules
3. ตรวจสอบ IIS configuration

### SSL ไม่ทำงาน
1. ตรวจสอบ certificate installation
2. ตรวจสอบ port 443 เปิดหรือไม่
3. ใช้ SSL checker: https://www.ssllabs.com/ssltest/

## 📞 Support Commands

```powershell
# ดู server logs
Get-Content C:\rbxid-system\server\logs\server.log -Tail 50

# Restart server service
Restart-Service "RbxID Server"

# ตรวจสอบ network connections
netstat -an | findstr :3010
```

---
**🎮 rbxid.com - Ready for Production!**
