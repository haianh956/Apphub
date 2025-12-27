
-- OLIOS HUB | ONLINE KEY + HWID CHECK
-- GitHub RAW (READ)
-- By GPT

if getgenv().__OLIOS_ONLINE then return end
getgenv().__OLIOS_ONLINE = true

-- SERVICES
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalPlayer = Players.LocalPlayer

-- CONFIG
local KEY_DATABASE_URL = "https://raw.githubusercontent.com/haianh956/oliosBkit/main/keys.json"
-- keys.json format:
-- { "BANANA-OLIOS": "", "OLIOS-ALPHA": "", "OLIOS-BETA": "" }

-- REQUIRE KEY
if not getgenv().Key then
	LocalPlayer:Kick("Please Enter Key")
	return
end

-- GET HWID
local HWID = RbxAnalyticsService:GetClientId()

-- LOAD ONLINE DB
local success, result = pcall(function()
	return game:HttpGet(KEY_DATABASE_URL)
end)

if not success then
	LocalPlayer:Kick("Cannot connect to key server")
	return
end

local data
pcall(function()
	data = HttpService:JSONDecode(result)
end)

if type(data) ~= "table" then
	LocalPlayer:Kick("Key database error")
	return
end

-- CHECK KEY EXIST
if data[getgenv().Key] == nil then
	LocalPlayer:Kick("Invalid Key")
	return
end

-- FIRST USE (UNBOUND)
if data[getgenv().Key] == "" then
	warn("FIRST USE KEY")
	warn("KEY:", getgenv().Key)
	warn("BOUND HWID:", HWID)
	-- ⚠ GitHub RAW cannot save, bind is logical only
end

-- HWID MISMATCH
if data[getgenv().Key] ~= "" and data[getgenv().Key] ~= HWID then
	LocalPlayer:Kick("Key already bound to another HWID")
	return
end

print("KEY VERIFIED | HWID OK")

-- ====== MENU TEST ======
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.Name = "Olios_Verified"

local lb = Instance.new("TextLabel", gui)
lb.Size = UDim2.new(0,400,0,120)
lb.Position = UDim2.new(0.5,-200,0.5,-60)
lb.Text = "OLIOS HUB VERIFIED\nKEY + HWID OK"
lb.TextColor3 = Color3.new(1,1,1)
lb.BackgroundColor3 = Color3.fromRGB(20,20,20)
lb.Font = Enum.Font.GothamBold
lb.TextSize = 20
Instance.new("UICorner", lb)

