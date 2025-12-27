
-- Olios Banana-Style Farm (Light Obf)
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

-- ===== KEY CHECK =====
local _K={["OLIOS-ALPHA"]=1,["OLIOS-BETA"]=1,["OLIOS-VIP"]=1,["OLIOS-PRO"]=1}
if not getgenv().Key or not _K[getgenv().Key] then
    game.Players.LocalPlayer:Kick("Invalid key")
    return
end

-- ===== SERVICES =====
local S=game:GetService
local P=S(game,"Players").LocalPlayer
local RS=S(game,"RunService")

-- ===== UI =====
local G=Instance.new("ScreenGui",P:WaitForChild("PlayerGui"))
G.Name="OliosHub"
local F=Instance.new("Frame",G);F.Size=UDim2.fromScale(.32,.28);F.Position=UDim2.fromScale(.34,.36)
F.BackgroundColor3=Color3.fromRGB(22,22,22);F.Active=true;F.Draggable=true
local B=Instance.new("TextButton",F);B.Size=UDim2.fromScale(.85,.3);B.Position=UDim2.fromScale(.075,.15)
B.Text="AUTO FARM : OFF";B.TextColor3=Color3.new(1,1,1);B.BackgroundColor3=Color3.fromRGB(40,40,40)

-- ===== FARM CORE (Banana-style template) =====
local ON=false
local function getChar()
    local c=P.Character
    return c and c:FindFirstChild("HumanoidRootPart") and c
end

local function moveTo(cf)
    local c=getChar(); if not c then return end
    c.HumanoidRootPart.CFrame=cf
end

local function nearestMob()
    -- generic scan (safe template)
    local mobs=workspace:FindFirstChild("Enemies") or workspace
    local hrp=getChar() and getChar().HumanoidRootPart
    if not hrp then return end
    local best,dist
    for _,m in ipairs(mobs:GetChildren()) do
        local h=m:FindFirstChildOfClass("Humanoid")
        local r=m:FindFirstChild("HumanoidRootPart")
        if h and r and h.Health>0 then
            local d=(r.Position-hrp.Position).Magnitude
            if not dist or d<dist then best,dist=r,d end
        end
    end
    return best
end

task.spawn(function()
    while RS.Heartbeat:Wait() do
        if ON then
            local t=nearestMob()
            if t then moveTo(t.CFrame*CFrame.new(0,0,-3)) end
        end
    end
end)

B.MouseButton1Click:Connect(function()
    ON=not ON
    B.Text=ON and "AUTO FARM : ON" or "AUTO FARM : OFF"
end)

print("Olios Loaded")
