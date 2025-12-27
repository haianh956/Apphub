
-- OLIOS HUB | FULL MENU + ONLINE KEY + HWID
if getgenv().__OLIOS_FULL then return end
getgenv().__OLIOS_FULL = true

-- SERVICES
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalPlayer = Players.LocalPlayer

-- CONFIG
local KEY_DATABASE_URL = "https://raw.githubusercontent.com/haianh956/oliosBkit/main/keys.json"
local AVATAR_USER_ID = 128402659894166

-- ===== KEY + HWID CHECK =====
if not getgenv().Key then
	LocalPlayer:Kick("Please Enter Key")
	return
end

local HWID = RbxAnalyticsService:GetClientId()

local ok, res = pcall(function()
	return game:HttpGet(KEY_DATABASE_URL)
end)

if not ok then
	LocalPlayer:Kick("Cannot connect to key server")
	return
end

local data = HttpService:JSONDecode(res)

if data[getgenv().Key] == nil then
	LocalPlayer:Kick("Invalid Key")
	return
end

if data[getgenv().Key] ~= "" and data[getgenv().Key] ~= HWID then
	LocalPlayer:Kick("Key already bound to another HWID")
	return
end

print("KEY + HWID VERIFIED")

-- ===== FLAGS =====
getgenv().AutoFarm = false
getgenv().AvatarToggle = false

-- ===== GUI =====
local Gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
Gui.Name = "OliosHub_Full"
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0,400,0,300)
Main.Position = UDim2.new(0.5,-200,0.5,-150)
Main.BackgroundColor3 = Color3.fromRGB(18,18,22)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,20)

local Grad = Instance.new("UIGradient", Main)
Grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0,Color3.fromRGB(40,40,55)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(15,15,20))
}

-- LOGO
local Logo = Instance.new("TextLabel", Main)
Logo.Size = UDim2.new(1,0,0,60)
Logo.Text = "◉ OLIOS HUB"
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 30
Logo.TextColor3 = Color3.fromRGB(255,215,120)
Logo.BackgroundTransparency = 1

-- BUTTON CREATOR
local function createBtn(text,y)
	local b = Instance.new("TextButton", Main)
	b.Size = UDim2.new(1,-40,0,44)
	b.Position = UDim2.new(0,20,0,y)
	b.Text = text.." : OFF"
	b.Font = Enum.Font.GothamBold
	b.TextSize = 15
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(35,35,48)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)

	b.MouseEnter:Connect(function()
		TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(60,60,80)}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(35,35,48)}):Play()
	end)
	return b
end

local FarmBtn = createBtn("AUTO FARM",80)
local AvatarBtn = createBtn("AVATAR",135)

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(1,-40,0,36)
Close.Position = UDim2.new(0,20,1,-50)
Close.Text = "CLOSE"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14
Close.TextColor3 = Color3.new(1,1,1)
Close.BackgroundColor3 = Color3.fromRGB(180,60,60)
Instance.new("UICorner", Close).CornerRadius = UDim.new(0,12)

-- ===== BUTTON LOGIC =====
FarmBtn.MouseButton1Click:Connect(function()
	getgenv().AutoFarm = not getgenv().AutoFarm
	FarmBtn.Text = "AUTO FARM : "..(getgenv().AutoFarm and "ON" or "OFF")
end)

local original
AvatarBtn.MouseButton1Click:Connect(function()
	getgenv().AvatarToggle = not getgenv().AvatarToggle
	AvatarBtn.Text = "AVATAR : "..(getgenv().AvatarToggle and "ON" or "OFF")

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")

	if getgenv().AvatarToggle then
		original = hum:GetAppliedDescription()
		hum:ApplyDescription(Players:GetHumanoidDescriptionFromUserId(AVATAR_USER_ID))
	else
		if original then hum:ApplyDescription(original) end
	end
end)

Close.MouseButton1Click:Connect(function()
	Gui:Destroy()
	getgenv().__OLIOS_FULL = false
end)

-- ===== AUTO FARM LOOP =====
task.spawn(function()
	while task.wait(0.4) do
		if getgenv().AutoFarm then
			pcall(function()
				local char = LocalPlayer.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				if not hrp then return end
				local enemies = workspace:FindFirstChild("Enemies")
				if not enemies then return end

				for _,mob in pairs(enemies:GetChildren()) do
					if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
						hrp.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
						VirtualUser:Button1Down(Vector2.new(), workspace.CurrentCamera.CFrame)
						task.wait(0.1)
					end
				end
			end)
		end
	end
end)

print("OLIOS HUB FULL LOADED")
