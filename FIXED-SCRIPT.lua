-- RbxID Telemetry Script (Fixed Version)
-- Copy this entire script and paste in Roblox executor

-- Wait for game to load properly
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Clear any existing settings first
if getgenv().Shop888_Settings then
    getgenv().Shop888_Settings = nil
end

-- Set configuration with proper timing
getgenv().Shop888_Settings = {
    ['key'] = 'fabdd044-a0c4-4ca2-9094-cf9cf94a2200',
    ['PC'] = 'fishis',
}

-- Wait a moment for settings to register
wait(2)

-- Verify settings are set
print("🔍 RbxID: Settings check:")
print("🔍 RbxID: Key:", getgenv().Shop888_Settings.key and (string.sub(getgenv().Shop888_Settings.key, 1, 8) .. "...") or "NOT SET")
print("🔍 RbxID: PC:", getgenv().Shop888_Settings.PC or "NOT SET")

-- Load telemetry script
print("🚀 RbxID: Loading telemetry system...")
loadstring(game:HttpGet('https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_loader.lua'))()

print("✅ RbxID: Script execution completed!")
