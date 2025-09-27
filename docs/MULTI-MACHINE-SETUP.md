# 🖥️ Multi-Machine Setup Guide

## 📋 Overview
RbxID รองรับการใช้งานหลายเครื่องด้วยการแยก API Key แต่ละเครื่อง

## 🔑 การสร้าง API Keys

### วิธีที่ 1: ผ่าน Dashboard
1. เปิด Dashboard: `http://rbxid.com`
2. คลิก "Create New Key"
3. ตั้งชื่อ Key (เช่น "PC-Home", "PC-Office", "Laptop-Gaming")
4. Copy Key ที่ได้

### วิธีที่ 2: ผ่าน API
```bash
curl -X POST http://rbxid.com/api/keys \
  -H "Content-Type: application/json" \
  -d '{"description": "PC-Home"}'
```

## 🖥️ ตัวอย่างการแจกจ่าย Keys

### เครื่องที่ 1: PC หลัก
```lua
getgenv().Shop888_Settings = {
    ['key'] = 'rbxid_abc123def456',  -- Key สำหรับ PC หลัก
    ['PC'] = 'PC-Main',
}

loadstring(game:HttpGet('https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_loader.lua'))()
```

### เครื่องที่ 2: Laptop
```lua
getgenv().Shop888_Settings = {
    ['key'] = 'rbxid_xyz789ghi012',  -- Key สำหรับ Laptop
    ['PC'] = 'Laptop-Gaming',
}

loadstring(game:HttpGet('https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_loader.lua'))()
```

### เครื่องที่ 3: PC สำรอง
```lua
getgenv().Shop888_Settings = {
    ['key'] = 'rbxid_mno345pqr678',  -- Key สำหรับ PC สำรอง
    ['PC'] = 'PC-Backup',
}

loadstring(game:HttpGet('https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_loader.lua'))()
```

## 📊 การดูข้อมูลแยกตาม Key

### ใน Dashboard:
1. เลือก API Key จาก dropdown
2. ข้อมูลจะแสดงเฉพาะ Key ที่เลือก
3. สามารถสลับดู Key อื่นได้

### ผ่าน API:
```bash
# ดูข้อมูล PC หลัก
curl "http://rbxid.com/api/data?key=rbxid_abc123def456"

# ดูข้อมูล Laptop
curl "http://rbxid.com/api/data?key=rbxid_xyz789ghi012"

# ดูข้อมูล PC สำรอง
curl "http://rbxid.com/api/data?key=rbxid_mno345pqr678"
```

## 🗂️ โครงสร้างไฟล์ข้อมูล

```
server/rbxid_data/
├── rbxid_abc123def456.json    # ข้อมูล PC หลัก
├── rbxid_xyz789ghi012.json    # ข้อมูล Laptop
├── rbxid_mno345pqr678.json    # ข้อมูล PC สำรอง
└── ...
```

## 🔒 ความปลอดภัย

### ข้อดี:
✅ **แยกข้อมูลสมบูรณ์** - ไม่มีการปะปนข้อมูล  
✅ **ควบคุมการเข้าถึง** - แต่ละ Key เห็นเฉพาะข้อมูลตัวเอง  
✅ **ลบข้อมูลแยก** - สามารถลบข้อมูลเฉพาะ Key  
✅ **สถิติแยก** - ดูสถิติแต่ละเครื่องแยกกัน  

### การจัดการ:
- **เพิ่ม Key**: สร้างใหม่ผ่าน Dashboard
- **ลบ Key**: ลบผ่าน API หรือ Dashboard
- **เปลี่ยน Key**: สร้างใหม่แล้วอัปเดต script

## 📈 ตัวอย่างการใช้งาน

### สำหรับ Internet Cafe:
```lua
-- เครื่องที่ 1
['key'] = 'cafe_pc01_key'
['PC'] = 'Cafe-PC-01'

-- เครื่องที่ 2  
['key'] = 'cafe_pc02_key'
['PC'] = 'Cafe-PC-02'
```

### สำหรับทีมงาน:
```lua
-- สมาชิกคนที่ 1
['key'] = 'team_member1_key'
['PC'] = 'Member1-Gaming'

-- สมาชิกคนที่ 2
['key'] = 'team_member2_key'  
['PC'] = 'Member2-Main'
```

## 🛠️ การแก้ไขปัญหา

### Key ไม่ทำงาน:
1. ตรวจสอบ Key ถูกต้อง
2. ตรวจสอบ Key ยังไม่ถูกลบ
3. ดู server logs

### ข้อมูลไม่แสดง:
1. ตรวจสอบเลือก Key ถูกต้องใน Dashboard
2. ตรวจสอบ telemetry script ทำงาน
3. ตรวจสอบ network connection

---
**🔑 แต่ละเครื่อง = แต่ละ Key = ข้อมูลแยกสมบูรณ์**
