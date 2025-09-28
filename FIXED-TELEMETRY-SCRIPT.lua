-- ✅ FIXED TELEMETRY SCRIPT - Use this in Roblox
-- Copy and paste this entire script into your executor

getgenv().Shop888_Settings = {
    ['key'] = 'fabdd044-a0c4-4ca2-9094-cf9cf94a2200',  -- ✅ Working key with data
    ['PC'] = 'fisaa',  -- Your PC name
    ['apiBase'] = 'http://103.58.149.243:8888'  -- ✅ Correct server URL
}

-- Load the telemetry script
task.spawn(function()
    local success, result = pcall(function()
        return loadstring(game:HttpGet('https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_telemetry.lua'))()
    end)
    
    if success then
        print("✅ RbxID Telemetry loaded successfully!")
        print("📊 Dashboard: http://103.58.149.243:8888")
        print("🔑 API Key: fabdd044-a0c4-4ca2-9094-cf9cf94a2200")
    else
        warn("❌ Failed to load telemetry:", result)
    end
end)
