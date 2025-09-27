-- RbxID Telemetry Loader
-- Usage: loadstring(game:HttpGet('https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_loader.lua'))()

-- Configuration check
local GEN = (typeof(getgenv) == "function" and getgenv()) or {}
local CFG = GEN.Shop888_Settings or GEN.SHOP888_Settings or GEN.RbxID_Settings or {}

-- Debug configuration
print("🔍 RbxID: Checking configuration...")
print("🔍 RbxID: getgenv exists:", typeof(getgenv) == "function")
print("🔍 RbxID: Shop888_Settings:", CFG)
print("🔍 RbxID: API Key:", CFG.key and (string.sub(CFG.key, 1, 8) .. "...") or "NOT SET")
print("🔍 RbxID: PC Name:", CFG.PC or "NOT SET")

-- Validate configuration
if not CFG.key or CFG.key == "" or CFG.key == "YOUR-API-KEY-HERE" then
    warn("❌ RbxID: No key provided in settings")
    warn("❌ RbxID: Please set your API key in Shop888_Settings.key")
    return
end

if not CFG.PC or CFG.PC == "" or CFG.PC == "CHANGE-ME" then
    warn("❌ RbxID: Please set your PC name in Shop888_Settings.PC")
    return
end

-- Load main telemetry script
print("🚀 RbxID: Loading telemetry system...")
print("📡 RbxID: API Key:", string.sub(CFG.key, 1, 8) .. "...")
print("💻 RbxID: PC Name:", CFG.PC)

-- GitHub raw URL for main script
local SCRIPT_URL = "https://raw.githubusercontent.com/tonbay1/rbxid-system/main/client/rbxid_telemetry.lua"

-- Load and execute main script
local success, result = pcall(function()
    return loadstring(game:HttpGet(SCRIPT_URL))()
end)

if success then
    print("✅ RbxID: Telemetry system loaded successfully!")
else
    warn("❌ RbxID: Failed to load telemetry system:", result)
end
