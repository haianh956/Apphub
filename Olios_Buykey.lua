
-- OLIOS HUB | Custom Logo Edition
if getgenv().__OLIOS_LOGO then return end
getgenv().__OLIOS_LOGO = true

-- CONFIG
local VALID_KEYS = {["BANANA-OLIOS"]=true,["OLIOS-ALPHA"]=true,["OLIOS-BETA"]=true}
local VALID_HWID = {["REPLACE_WITH_HWID"]=true}
local AVATAR_USER_ID = 128402659894166

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalPlayer = Players.LocalPlayer

-- KEY & HWID
if not getgenv().Key or not VALID_KEYS[getgenv().Key] then LocalPlayer:Kick("Invalid Key") return end
local HWID = RbxAnalyticsService:GetClientId()
if not VALID_HWID[HWID] then LocalPlayer:Kick("HWID Not Authorized") return end

-- FLAGS
getgenv().AutoFarm=false
getgenv().AvatarToggle=false

-- GUI
local Gui=Instance.new("ScreenGui",LocalPlayer:WaitForChild("PlayerGui"))
Gui.Name="OliosHub_Logo"
Gui.ResetOnSpawn=false

local Main=Instance.new("Frame",Gui)
Main.Size=UDim2.new(0,380,0,280)
Main.Position=UDim2.new(0.5,-190,0.5,-140)
Main.BackgroundColor3=Color3.fromRGB(18,18,22)
Main.Active=true
Main.Draggable=true
Instance.new("UICorner",Main).CornerRadius=UDim.new(0,20)

local Grad=Instance.new("UIGradient",Main)
Grad.Color=ColorSequence.new{
	ColorSequenceKeypoint.new(0,Color3.fromRGB(40,40,55)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(15,15,20))
}

-- LOGO CONTAINER
local LogoWrap=Instance.new("Frame",Main)
LogoWrap.Size=UDim2.new(1,0,0,70)
LogoWrap.BackgroundTransparency=1

-- TEXT LOGO (CUSTOM)
local Logo=Instance.new("TextLabel",LogoWrap)
Logo.Size=UDim2.new(1,0,1,0)
Logo.Text="◉ OLIOS"
Logo.Font=Enum.Font.GothamBlack
Logo.TextSize=34
Logo.TextColor3=Color3.fromRGB(255,215,120)
Logo.BackgroundTransparency=1

local Glow=Instance.new("UIStroke",Logo)
Glow.Thickness=2
Glow.Color=Color3.fromRGB(255,200,90)
Glow.Transparency=0.4

-- SUBTITLE
local Sub=Instance.new("TextLabel",Main)
Sub.Position=UDim2.new(0,0,0,70)
Sub.Size=UDim2.new(1,0,0,22)
Sub.Text="PRIVATE HUB • BLOX FRUITS"
Sub.Font=Enum.Font.Gotham
Sub.TextSize=13
Sub.TextColor3=Color3.fromRGB(170,170,170)
Sub.BackgroundTransparency=1

-- BUTTON MAKER
local function mk(text,y)
	local b=Instance.new("TextButton",Main)
	b.Size=UDim2.new(1,-44,0,44)
	b.Position=UDim2.new(0,22,0,y)
	b.Text=text.." : OFF"
	b.Font=Enum.Font.GothamBold
	b.TextSize=15
	b.TextColor3=Color3.fromRGB(235,235,235)
	b.BackgroundColor3=Color3.fromRGB(35,35,48)
	Instance.new("UICorner",b).CornerRadius=UDim.new(0,14)
	b.MouseEnter:Connect(function()
		TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(60,60,80)}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(35,35,48)}):Play()
	end)
	return b
end

local Farm=mk("AUTO FARM",110)
local Avatar=mk("AVATAR",165)

local Close=Instance.new("TextButton",Main)
Close.Size=UDim2.new(1,-44,0,38)
Close.Position=UDim2.new(0,22,1,-52)
Close.Text="CLOSE"
Close.Font=Enum.Font.GothamBold
Close.TextSize=14
Close.TextColor3=Color3.new(1,1,1)
Close.BackgroundColor3=Color3.fromRGB(185,70,70)
Instance.new("UICorner",Close).CornerRadius=UDim.new(0,12)

-- LOGIC
Farm.MouseButton1Click:Connect(function()
	getgenv().AutoFarm=not getgenv().AutoFarm
	Farm.Text="AUTO FARM : "..(getgenv().AutoFarm and "ON" or "OFF")
end)

local original
Avatar.MouseButton1Click:Connect(function()
	getgenv().AvatarToggle=not getgenv().AvatarToggle
	Avatar.Text="AVATAR : "..(getgenv().AvatarToggle and "ON" or "OFF")
	local char=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hum=char:WaitForChild("Humanoid")
	if getgenv().AvatarToggle then
		original=hum:GetAppliedDescription()
		hum:ApplyDescription(Players:GetHumanoidDescriptionFromUserId(AVATAR_USER_ID))
	else
		if original then hum:ApplyDescription(original) end
	end
end)

Close.MouseButton1Click:Connect(function()
	Gui:Destroy()
	getgenv().__OLIOS_LOGO=false
end)

-- AUTOFARM LOOP
task.spawn(function()
	while task.wait(0.4) do
		if getgenv().AutoFarm then
			pcall(function()
				local c=LocalPlayer.Character
				local hrp=c and c:FindFirstChild("HumanoidRootPart")
				if not hrp then return end
				local e=workspace:FindFirstChild("Enemies")
				if not e then return end
				for _,m in pairs(e:GetChildren()) do
					if m:FindFirstChild("Humanoid") and m.Humanoid.Health>0 and m:FindFirstChild("HumanoidRootPart") then
						hrp.CFrame=m.HumanoidRootPart.CFrame*CFrame.new(0,0,3)
						VirtualUser:Button1Down(Vector2.new(),workspace.CurrentCamera.CFrame)
						task.wait(0.1)
					end
				end
			end)
		end
	end
end)

print("Olios Hub Loaded | Logo Edition")
