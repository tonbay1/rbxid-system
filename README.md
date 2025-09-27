# 🎮 RbxID - Roblox Fisch Telemetry System

## 📖 Overview
RbxID เป็นระบบติดตามข้อมูลเกม Roblox Fisch แบบ Real-time ที่ใช้โดเมนของคุณเอง (rbxid.com)

## 🚀 Quick Start

### 1. เริ่ม Server
```bash
# Double-click หรือ run
start-server.bat
```

### 2. เริ่ม Dashboard
```bash
# Double-click หรือ run  
start-dashboard.bat
```

### 3. เข้าใช้งาน
- **Server API**: http://localhost:3010
- **Dashboard**: http://localhost:5173
- **Production**: https://rbxid.com

## 📁 โครงสร้างไฟล์

```
rbxid-system/
├── server/                    # Backend API Server
│   ├── rbxid-server.js       # Main server file
│   ├── package.json          # Server dependencies
│   ├── rbxid_keys.json       # API keys storage
│   └── rbxid_data/           # User data files (auto-created)
├── client/                   # Lua Scripts
│   └── rbxid_telemetry.lua   # Roblox telemetry script
├── ui-react/                 # React Dashboard
│   ├── src/
│   │   └── FischMinimalDashboard.tsx
│   └── package.json          # React dependencies
├── web/                      # Static Web (backup)
│   └── index.html           # Simple HTML dashboard
├── start-server.bat         # Windows server startup
├── start-dashboard.bat      # Windows dashboard startup
└── README.md               # This file
```

## 🔑 การใช้งาน

### สร้าง API Key
1. เปิด Dashboard
2. กดปุ่ม "Create New Key"
3. Copy key ที่ได้

### แจกจ่าย Script ให้ผู้ใช้
```lua
getgenv().Shop888_Settings = {
    ['key'] = 'YOUR-API-KEY-HERE',
    ['PC'] = 'CHANGE-ME',
}

task.spawn(function() 
    loadstring(game:HttpGet('https://rbxid.com/script'))() 
end)
```

## 🌐 การ Deploy บน VPS

### 1. อัปโหลดไฟล์
- Copy โฟลเดอร์ `rbxid-system` ไปยัง VPS
- ติดตั้ง Node.js บน VPS

### 2. ตั้งค่า DNS
```
Type: A
Name: @
Value: YOUR_VPS_IP

Type: A  
Name: www
Value: YOUR_VPS_IP
```

### 3. ตั้งค่า Reverse Proxy (Nginx)
```nginx
server {
    listen 80;
    server_name rbxid.com www.rbxid.com;
    
    location / {
        proxy_pass http://localhost:3010;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 4. SSL Certificate
```bash
sudo certbot --nginx -d rbxid.com -d www.rbxid.com
```

## 📡 API Endpoints

- `GET /` - Dashboard หรือ Server info
- `GET /script` - Obfuscated Lua script
- `POST /api/telemetry` - รับข้อมูล telemetry
- `GET /api/data?key=` - ดูข้อมูลตาม key
- `POST /api/keys` - สร้าง API key ใหม่
- `GET /api/keys` - ดูรายการ keys

## 🔒 ความปลอดภัย

- ✅ API key validation
- ✅ Data separation ตาม key
- ✅ Script obfuscation
- ✅ CORS protection
- ✅ Input sanitization

## ⚡ ฟีเจอร์หลัก

- ✅ Real-time player tracking
- ✅ Online/Offline detection (5 นาที)
- ✅ Multi-user support
- ✅ Beautiful React dashboard
- ✅ API key management
- ✅ Data export (Google Sheets)
- ✅ Dark/Light theme
- ✅ Auto-refresh

## 🛠️ การแก้ไขปัญหา

### Server ไม่เริ่ม
```bash
# ตรวจสอบ port
netstat -ano | findstr :3010

# ตรวจสอบ Node.js
node --version
```

### Dashboard ไม่โหลด
```bash
# ติดตั้ง dependencies
cd ui-react
npm install

# เริ่มใหม่
npm run dev
```

### Script ไม่ทำงาน
1. ตรวจสอบ key ถูกต้อง
2. ตรวจสอบ URL endpoint
3. ดู console logs

## 📞 Support

- ตรวจสอบ server logs
- Test API endpoints ด้วย browser
- ตรวจสอบ firewall settings

---

**🎮 RbxID - Professional Roblox Telemetry Solution**
