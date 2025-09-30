-- Test Config Reading
print("=== RbxID Config Test ===")

-- Test getgenv
local GEN = (typeof(getgenv) == "function" and getgenv()) or nil
print("getgenv available:", GEN and "YES" or "NO")

if GEN then
    print("Shop888_Settings:", GEN.Shop888_Settings and "EXISTS" or "MISSING")
    if GEN.Shop888_Settings then
        print("Key:", GEN.Shop888_Settings.key or "NONE")
        print("PC:", GEN.Shop888_Settings.PC or "NONE")
        print("API Base:", GEN.Shop888_Settings.apiBase or "NONE")
    end
end

-- Test config detection
local CFG = (GEN and (GEN.Shop888_Settings or GEN.SHOP888_Settings or GEN.Fishis_Telemetry or GEN.Telemetry_Settings or GEN.SHOP888 or GEN.Hermanos_Settings)) or {}
print("Final CFG:", CFG and "EXISTS" or "MISSING")
if CFG then
    print("CFG Key:", CFG.key or "NONE")
    print("CFG PC:", CFG.PC or "NONE")
end

-- Test simple telemetry send
local HttpService = game:GetService("HttpService")

local function sendTest()
    local testData = {
        key = CFG.key or "TEST-KEY",
        pcName = CFG.PC or "TEST-PC",
        playerName = "TestPlayer",
        test = true
    }
    
    print("Sending test data:", HttpService:JSONEncode(testData))
    
    local success, result = pcall(function()
        return HttpService:PostAsync(
            "https://rbxid.com/api/telemetry",
            HttpService:JSONEncode(testData),
            Enum.HttpContentType.ApplicationJson
        )
    end)
    
    if success then
        print("✅ Test successful:", result)
    else
        print("❌ Test failed:", result)
    end
end

sendTest()
