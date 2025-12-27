
-- OLIOS HUB | STABLE VERSION (NO KICK WHEN SERVER DOWN)
-- Key + HWID Online (Safe fallback)

if getgenv().__OLIOS_STABLE then return end
getgenv().__OLIOS_STABLE = true

-- SERVICES
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalPlayer = Players.LocalPlayer

-- CONFIG
local KEY_DATABASE_URL = "https://raw.githubusercontent.com/haianh956/oliosBkit/main/keys.json"
local AVATAR_USER_ID = 128402659894166

-- CHECK KEY INPUT
if not getgenv().Key then
	warn("[OLIOS] No key provided")
	return
end

local HWID = RbxAnalyticsService:GetClientId()

-- TRY CONNECT KEY SERVER
local ok, res = pcall(function()
	return game:HttpGet(KEY_DATABASE_URL)
end)

local keyVerified = false

if ok then
	local success, data = pcall(function()
		return HttpService:JSONDecode(res)
	end)

	if success and data[getgenv().Key] ~= nil then
		if data[getgenv().Key] == "" or data[getgenv().Key] == HWID then
			keyVerified = true
		else
			warn("[OLIOS] Key bound to another HWID")
		end
	else
		warn("[OLIOS] Invalid key")
	end
else
	warn("[OLIOS] Key server offline, running in fallback mode")
	-- FALLBACK MODE: allow run without kick
	keyVerified = true
end

if not keyVerified then
	warn("[OLIOS] Verification failed")
	return
end

-- ===== GUI =====
local Gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
Gui.Name = "OliosHub_Stable"
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0,420,0,280)
Main.Position = UDim2.new(0.5,-210,0.5,-140)
Main.BackgroundColor3 = Color3.fromRGB(20,20,28)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,55)
Title.Text = "OLIOS HUB"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 28
Title.TextColor3 = Color3.fromRGB(255,220,140)
Title.BackgroundTransparency = 1

local function button(text,y)
	local b = Instance.new("TextButton", Main)
	b.Size = UDim2.new(1,-40,0,42)
	b.Position = UDim2.new(0,20,0,y)
	b.Text = text.." : OFF"
	b.Font = Enum.Font.GothamBold
	b.TextSize = 15
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(45,45,60)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	return b
end

getgenv().AutoFarm = false
getgenv().AvatarToggle = false

local FarmBtn = button("AUTO FARM",80)
local AvatarBtn = button("AVATAR",135)

FarmBtn.MouseButton1Click:Connect(function()
	getgenv().AutoFarm = not getgenv().AutoFarm
	FarmBtn.Text = "AUTO FARM : "..(getgenv().AutoFarm and "ON" or "OFF")
end)

local originalDesc
AvatarBtn.MouseButton1Click:Connect(function()
	getgenv().AvatarToggle = not getgenv().AvatarToggle
	AvatarBtn.Text = "AVATAR : "..(getgenv().AvatarToggle and "ON" or "OFF")

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")

	if getgenv().AvatarToggle then
		originalDesc = hum:GetAppliedDescription()
		hum:ApplyDescription(Players:GetHumanoidDescriptionFromUserId(AVATAR_USER_ID))
	else
		if originalDesc then hum:ApplyDescription(originalDesc) end
	end
end)

print("[OLIOS] Stable version loaded successfully")
