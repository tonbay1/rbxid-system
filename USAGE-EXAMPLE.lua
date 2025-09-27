-- RbxID Telemetry System - Usage Examples
-- Copy and paste these scripts for different machines

-- Example 1: PC Main
getgenv().Shop888_Settings = {
    ['key'] = 'ce0b1015-36b0-4849-a173-fc816644101c',
    ['PC'] = 'PC-Main',
}


loadstring(game:HttpGet('https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_loader.lua'))()

-- Example 2: Laptop Gaming
getgenv().Shop888_Settings = {
    ['key'] = 'a1b2c3d4-5678-9012-3456-789012345678',
    ['PC'] = 'Laptop-Gaming',
}


loadstring(game:HttpGet('https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_loader.lua'))()

-- Example 3: PC Backup
getgenv().Shop888_Settings = {
    ['key'] = 'x9y8z7w6-5432-1098-7654-321098765432',
    ['PC'] = 'PC-Backup',
}


loadstring(game:HttpGet('https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_loader.lua'))()

--[[
INSTRUCTIONS FOR USERS:

1. Replace 'YOUR-API-KEY-HERE' with your actual API key from the dashboard
2. Replace 'CHANGE-ME' with your username/PC name
3. Execute this script in your Roblox executor
4. The telemetry will start automatically

DASHBOARD URLS:
- Main: https://rbxid.com
- Health: https://rbxid.com/health
- API: https://rbxid.com/api/data?key=YOUR-KEY

GITHUB REPOSITORY:
- https://github.com/tonbay1/rbxid-system

SUPPORT:
- Check server logs if not working
- Verify your API key is correct
- Make sure rbxid.com is accessible
]]
