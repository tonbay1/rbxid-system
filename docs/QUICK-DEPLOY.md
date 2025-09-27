# ⚡ Quick Deploy Guide - rbxid.com

## 🎯 สำหรับ VPS: 103.58.149.243

### 1️⃣ DNS Settings (ในแผงควบคุมโดเมน)
```
Type: A, Name: @, Value: 103.58.149.243
Type: A, Name: www, Value: 103.58.149.243
Type: A, Name: api, Value: 103.58.149.243
```

### 2️⃣ VPS Setup (Windows Commands)

#### ติดตั้ง Node.js
```powershell
# Download from: https://nodejs.org/
# เลือก LTS version
# ติดตั้งแล้วทดสอบ:
node --version
npm --version
```

#### เปิด Firewall Port
```powershell
# Run as Administrator
New-NetFirewallRule -DisplayName "RbxID" -Direction Inbound -Protocol TCP -LocalPort 3010 -Action Allow
```

#### Upload Files
```powershell
# Copy โฟลเดอร์ rbxid-system ไปที่:
C:\rbxid-system\
```

#### Start Server
```powershell
cd C:\rbxid-system
start-server.bat
```

### 3️⃣ Test URLs

- **Local**: http://localhost:3010
- **IP**: http://103.58.149.243:3010  
- **Domain**: http://rbxid.com:3010
- **API Health**: http://rbxid.com:3010/health

### 4️⃣ Lua Script URL
```lua
getgenv().Shop888_Settings = {
    ['key'] = 'GET-FROM-DASHBOARD',
    ['PC'] = 'CHANGE-ME',
}

loadstring(game:HttpGet('http://rbxid.com:3010/script'))()
```

### 5️⃣ Dashboard Access
- **React**: http://rbxid.com:3010 (if served by server)
- **Local Dev**: Run `start-dashboard.bat` → http://localhost:5173

---
**🚀 Ready in 5 minutes!**
