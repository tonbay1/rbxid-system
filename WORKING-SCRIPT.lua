-- RbxID Telemetry Script (Production Ready)
-- This script will work with your VPS deployment

-- Wait for game to load properly
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Clear any existing settings first
if getgenv().Shop888_Settings then
    getgenv().Shop888_Settings = nil
end

-- Set configuration
getgenv().Shop888_Settings = {
    ['key'] = 'fabdd044-a0c4-4ca2-9094-cf9cf94a2200',
    ['PC'] = 'fishis',
    ['apiBase'] = 'http://rbxid.com:8888'  -- Your VPS domain
}

-- Wait a moment for settings to register
wait(2)

-- Debug info
print("🔍 RbxID: Configuration loaded")
print("🔍 RbxID: Key:", string.sub(getgenv().Shop888_Settings.key, 1, 8) .. "...")
print("🔍 RbxID: PC:", getgenv().Shop888_Settings.PC)
print("🔍 RbxID: API Base:", getgenv().Shop888_Settings.apiBase)

-- Load telemetry script from GitHub
print("🚀 RbxID: Loading telemetry system...")
loadstring(game:HttpGet('https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_loader.lua'))()

print("✅ RbxID: Script execution completed!")
