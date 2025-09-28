-- RbxID Telemetry System (Based on working_simple_telemetry.lua)
-- Protected Script - Unauthorized access prohibited

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Read external config from getgenv (executor pattern)
local GEN = (typeof(getgenv) == "function" and getgenv()) or nil
local CFG = (GEN and (GEN.Shop888_Settings or GEN.SHOP888_Settings or GEN.Fishis_Telemetry or GEN.Telemetry_Settings or GEN.SHOP888 or GEN.Hermanos_Settings)) or {}

-- RbxID Configuration
local TELEMETRY_URLS = {
    "http://rbxid.com/api/telemetry",            -- Domain HTTP (Primary)
    "http://103.58.149.243:8888/api/telemetry",  -- IP Fallback
    "http://rbxid.com:8888/api/telemetry",       -- Domain HTTP (Backup)
    "http://127.0.0.1:8888/api/telemetry",       -- Local (Testing)
    "http://localhost:8888/api/telemetry",       -- Local (Testing)
}

-- Add custom API base if provided
do
    local apiBase = CFG.apiBase or CFG.API_BASE or CFG.ApiBase
    if typeof(apiBase) == "string" and apiBase ~= "" then
        local base = apiBase
        if string.sub(base, -1) == "/" then base = string.sub(base, 1, -2) end
        -- Prepend provided apiBase while preserving fallbacks
        local defaults = TELEMETRY_URLS
        TELEMETRY_URLS = { base .. "/api/telemetry" }
        for i = 1, #defaults do TELEMETRY_URLS[#TELEMETRY_URLS + 1] = defaults[i] end
    end
end

local plr = Players.LocalPlayer

-- Get key from settings
local USER_KEY = CFG.key or ""
local PC_NAME = CFG.PC or CFG.pcName or "Unknown-PC"

if USER_KEY == "" then
    warn("❌ RbxID: No key provided in settings")
    return
end

-- Logging toggle (can be overridden by CFG.debug)
local LOG = (typeof(CFG.debug) == "boolean" and CFG.debug) or false
local function log(...) if LOG then print(...) end end
local function warnlog(...) if LOG then warn(...) end end

-- Show notification
if LOG then
    StarterGui:SetCore("SendNotification", {
        Title = "🎣 RbxID Telemetry",
        Text = "Script started! Key: " .. string.sub(USER_KEY, 1, 8) .. "...",
        Duration = 3
    })
end

-- Always show inject confirmation
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "✅ RbxID Injected",
        Text = "ฉีดสคริปต์สำเร็จ",
        Duration = 3
    })
end)

-- Global inventory data (like original script)
local inventory = {
    player = { name = plr.Name, id = plr.UserId, displayName = plr.DisplayName },
    level = 0,
    coin = 0,
    equippedRod = "",
    location = "",
    rods = {},
    baits = {},
    time = os.date("%Y-%m-%d %H:%M:%S"),
    attributes = {}
}

-- Executor-aware HTTP helpers (from original)
local function getHttpRequest()
    return (typeof(syn) == "table" and syn.request)
        or (typeof(http) == "table" and http.request)
        or http_request
        or (typeof(fluxus) == "table" and fluxus.request)
        or request
end

local function sendJson(url, tbl)
    local ok, body = pcall(function() return HttpService:JSONEncode(tbl) end)
    if not ok then return false, "encode_failed" end
    local req = getHttpRequest()
    if req then
        local ok2, res = pcall(req, { Url = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body })
        if ok2 and res then
            local sc = res.StatusCode or res.status or res.Status or res.code
            return (sc == 200 or sc == 201), res
        else
            return false, res
        end
    else
        local ok3, res2 = pcall(function() return HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson) end)
        return ok3, res2
    end
end

-- Data collection functions (enhanced from original)
local function findLevel()
    -- Method 1: Try XP GUI (most reliable)
    local pg = plr:FindFirstChild("PlayerGui")
    if pg then
        local xpGui = pg:FindFirstChild("XP")
        if xpGui then
            local frame = xpGui:FindFirstChild("Frame")
            if frame then
                local levelLabel = frame:FindFirstChild("Level")
                if levelLabel and levelLabel.Text then
                    local lvl = tonumber(string.match(levelLabel.Text, "%d+"))
                    if lvl then
                        inventory.level = lvl
                        return
                    end
                end
            end
        end
    end
    
    -- Method 2: Try Data folder
    local data = plr:FindFirstChild("Data")
    if data then
        local levelValue = data:FindFirstChild("Level")
        if levelValue and levelValue.Value then
            inventory.level = tonumber(levelValue.Value) or 0
            return
        end
    end
    
    -- Method 3: Try leaderstats
    local ls = plr:FindFirstChild("leaderstats")
    if ls then
        local levelStat = ls:FindFirstChild("Level") or ls:FindFirstChild("LVL")
        if levelStat and levelStat.Value then
            inventory.level = tonumber(levelStat.Value) or 0
        end
    end
end

local function findCoin()
    -- Method 1: Try Data folder first
    local data = plr:FindFirstChild("Data")
    if data then
        local coinValue = data:FindFirstChild("Coins") or data:FindFirstChild("C4sh")
        if coinValue and coinValue.Value then
            inventory.coin = tonumber(coinValue.Value) or 0
            return
        end
    end
    
    -- Method 2: Try leaderstats
    local ls = plr:FindFirstChild("leaderstats")
    if ls then
        local coinStat = ls:FindFirstChild("C4sh") or ls:FindFirstChild("Coins") or ls:FindFirstChild("Money")
        if coinStat and coinStat.Value then
            inventory.coin = tonumber(coinStat.Value) or 0
        end
    end
end

local function findLocation()
    -- Method 1: Attribute (most reliable)
    local attr = plr:GetAttribute("LocationName")
    if attr and tostring(attr) ~= "" then
        inventory.location = tostring(attr)
        return
    end
    
    -- Method 2: Try character position
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        local pos = plr.Character.HumanoidRootPart.CFrame.Position
        inventory.location = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
    else
        inventory.location = "Unknown"
    end
end

local function findEquippedRod()
    local playerGui = plr:FindFirstChild("PlayerGui")
    if not playerGui then return end
    
    -- Look in HUD for equipped item
    local hud = playerGui:FindFirstChild("HUD")
    if hud then
        local safezone = hud:FindFirstChild("SafeZone")
        if safezone then
            local hotbar = safezone:FindFirstChild("Hotbar")
            if hotbar then
                for _, slot in pairs(hotbar:GetChildren()) do
                    if slot:IsA("Frame") and slot.Name:match("Slot") then
                        local equipped = slot:FindFirstChild("Equipped")
                        if equipped and equipped.Visible then
                            local itemName = slot:FindFirstChild("ItemName")
                            if itemName and itemName.Text then
                                inventory.equippedRod = itemName.Text
                                return
                            end
                        end
                    end
                end
            end
        end
    end
    
    inventory.equippedRod = "None"
end

-- Send telemetry function (compatible with original)
local function sendTelemetry(data)
    -- Add RbxID specific fields
    data.key = USER_KEY
    data.pcName = PC_NAME
    data.gameId = game.PlaceId
    data.jobId = game.JobId
    data.timestamp = os.time()
    data.online = true
    
    -- Try multiple URLs until one works
    for _, url in ipairs(TELEMETRY_URLS) do
        local ok, res = sendJson(url, data)
        if ok then
            log("✅ RbxID: Data sent to", url)
            return true
        else
            warnlog("❌ RbxID: Failed to send to", url, res)
        end
    end
    warnlog("❌ RbxID: All telemetry URLs failed")
    return false
end

-- Scan and send function (like original)
local function scanAndSend()
    log("🔍 Scanning player data...")
    
    -- Reset data
    inventory.rods = {}
    inventory.baits = {}
    inventory.time = os.date("%Y-%m-%d %H:%M:%S")
    
    -- Collect all data
    findLevel()
    findCoin()
    findLocation()
    findEquippedRod()
    
    -- Prepare telemetry data in Dashboard-compatible format
    local telemetryData = {
        -- Player info (Dashboard format)
        account = inventory.player.name,
        playerName = inventory.player.name,
        displayName = inventory.player.displayName,
        userId = inventory.player.id,
        
        -- Game data (Dashboard expects these exact fields)
        level = inventory.level,
        money = inventory.coin,  -- Dashboard uses 'money'
        coins = inventory.coin,  -- Dashboard also checks 'coins'
        equippedRod = inventory.equippedRod,
        rod = inventory.equippedRod,  -- Dashboard fallback
        location = inventory.location,
        
        -- Collections
        rods = inventory.rods,
        rodsDetailed = inventory.rods,
        baits = inventory.baits,
        baitsDetailed = inventory.baits,
        materials = {},
        materialsDetailed = {},
        
        -- Status
        online = true,
        
        -- Timestamps
        time = inventory.time,
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        lastUpdated = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        
        -- Metadata
        attributes = inventory.attributes
    }
    
    log("📊 Data collected:", "Level:", inventory.level, "Coins:", inventory.coin, "Rod:", inventory.equippedRod)
    
    -- Send data
    local success = sendTelemetry(telemetryData)
    if success then
        log("✅ Telemetry sent successfully")
    else
        warnlog("❌ Failed to send telemetry")
    end
end

-- Initial scan and send
scanAndSend()

-- Set up periodic scanning (every 5 seconds)
local SCAN_INTERVAL = 5
local lastScan = 0

local connection = game:GetService("RunService").Heartbeat:Connect(function()
    local now = tick()
    if now - lastScan >= SCAN_INTERVAL then
        lastScan = now
        scanAndSend()
    end
end)

-- Cleanup on player leaving
Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == plr then
        if connection then
            connection:Disconnect()
        end
        log("🔌 RbxID: Telemetry disconnected")
    end
end)

log("📡 RbxID: Telemetry system active (scanning every", SCAN_INTERVAL, "seconds)")
log("🔑 Using key:", string.sub(USER_KEY, 1, 8) .. "...")
log("💻 PC Name:", PC_NAME)
