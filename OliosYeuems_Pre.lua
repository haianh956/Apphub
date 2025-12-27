-- OLIOS PREMIUM | DELTA SAFE (DEVICE HWID)
-- 1 DEVICE = 1 KEY | Menu first, then key check

if game.CoreGui:FindFirstChild("OliosUI") then
    game.CoreGui.OliosUI:Destroy()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

-- ===== DEVICE HWID =====
local function getHWID()
    return RbxAnalyticsService:GetClientId()
end

-- ===== VALID KEYS =====
local VALID_KEYS = {
    ["OLIOS-ALPHA"] = true,
    ["OLIOS-BETA"]  = true,
    ["OLIOS-PRO"]   = true,
    ["OLIOS-VIP"]   = true
}

-- ===== KEY BINDS (RUNTIME) =====
local BINDS = {}

-- ===== UI =====
local gui = Instance.new("ScreenGui")
gui.Name = "OliosUI"
gui.Parent = game.CoreGui

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 320, 0, 200)
main.Position = UDim2.new(0.5, -160, 0.5, -100)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "OLIOS PREMIUM"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local box = Instance.new("Input key buy", main)
box.Size = UDim2.new(0.8,0,0,35)
box.Position = UDim2.new(0.1,0,0.35,0)
box.PlaceholderText = "ENTER KEY"
box.Text = ""
box.BackgroundColor3 = Color3.fromRGB(40,40,40)
box.TextColor3 = Color3.new(1,1,1)
box.Font = Enum.Font.Gotham
box.TextScaled = true
Instance.new("UICorner", box).CornerRadius = UDim.new(0,8)

local btn = Instance.new("TextButton", main)
btn.Size = UDim2.new(0.6,0,0,35)
btn.Position = UDim2.new(0.2,0,0.6,0)
btn.Text = "UNLOCK"
btn.BackgroundColor3 = Color3.fromRGB(80,160,255)
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true
Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

local function kick(msg)
    LocalPlayer:Kick(msg or "HWID INVALID")
end

btn.MouseButton1Click:Connect(function()
    local key = string.upper(box.Text)
    if not VALID_KEYS[key] then
        kick("INVALID KEY")
        return
    end

    local hwid = getHWID()
    if BINDS[key] and BINDS[key] ~= hwid then
        kick("HWID INVALID")
        return
    end

    BINDS[key] = hwid
    gui:Destroy()

    -- ===== MAIN SCRIPT START =====
    print("OLIOS UNLOCKED | DEVICE VERIFIED")
end)
