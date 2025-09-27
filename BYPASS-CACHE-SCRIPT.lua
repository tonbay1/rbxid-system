-- RbxID Bypass Cache Script
-- This script bypasses GitHub cache by adding timestamp

-- Wait for game to load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Clear existing settings
if getgenv().Shop888_Settings then
    getgenv().Shop888_Settings = nil
end

-- Set configuration
getgenv().Shop888_Settings = {
    ['key'] = '10bf0ade-a0c4-4ca2-9094-cf9cf94a2200',
    ['PC'] = 'fisaa',
    ['apiBase'] = 'http://rbxid.com:8888'
}

-- Wait for settings to register
wait(3)

-- Debug settings
print("🔍 RbxID: Final settings check:")
print("🔍 RbxID: getgenv exists:", typeof(getgenv) == "function")
print("🔍 RbxID: Shop888_Settings:", getgenv().Shop888_Settings)
if getgenv().Shop888_Settings then
    print("🔍 RbxID: Key:", string.sub(getgenv().Shop888_Settings.key, 1, 8) .. "...")
    print("🔍 RbxID: PC:", getgenv().Shop888_Settings.PC)
    print("🔍 RbxID: API Base:", getgenv().Shop888_Settings.apiBase)
end

-- Load with cache bypass (add timestamp)
local timestamp = tostring(os.time())
local url = 'https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_loader.lua?t=' .. timestamp

print("🚀 RbxID: Loading from:", url)
loadstring(game:HttpGet(url))()

print("✅ RbxID: Script execution completed!")
