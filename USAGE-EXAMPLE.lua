-- RbxID Telemetry System - Usage Example
-- Copy this code and give to your users

-- Step 1: Configure your settings
getgenv().Shop888_Settings = {
    ['key'] = 'YOUR-API-KEY-HERE',  -- Get from dashboard
    ['PC'] = 'CHANGE-ME',           -- Your PC/User name
}

-- Step 2: Load the telemetry system
task.spawn(function() 
    loadstring(game:HttpGet('https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_loader.lua'))() 
end)

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
