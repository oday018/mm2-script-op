-- ✨ تحميل Wand UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()
local Window = Library:MakeWindow({
	Title = "M1's Murder & Fling",
	SubTitle = "For MM2 — Clean & Complete",
	ScriptFolder = "m1-murder-fling"
})

-- 🔪 تاب القاتل
local MurdererTab = Window:MakeTab({ Title = "Murderer", Icon = "axe" })

-- 🌀 تاب الفلينق
local FlingTab = Window:MakeTab({ Title = "Fling", Icon = "rotate-cw" })

-- === 🔁 المتغيرات والمصادر من السكربت الأصلي === --
local vu18 = game.Players
local vu26 = vu18.LocalPlayer
local vu16 = game:GetService("ReplicatedStorage")
local vu13 = game.Workspace
local vu27, vu28, vu29

vu26.CharacterAdded:Connect(function(Char)
	vu27 = Char
	vu28 = Char:WaitForChild("Humanoid")
	vu29 = Char:WaitForChild("HumanoidRootPart")
end)

if vu26.Character then
	vu27 = vu26.Character
	vu28 = vu27:FindFirstChild("Humanoid")
	vu29 = vu27:FindFirstChild("HumanoidRootPart")
end

-- === 📋 إدارة اللاعبين === --
local PlayersList = {}
local function RefreshPlayersList()
	PlayersList = {}
	for _, Player in ipairs(vu18:GetPlayers()) do
		if Player ~= vu26 then
			table.insert(PlayersList, Player.Name)
		end
	end
end

RefreshPlayersList()
vu18.PlayerAdded:Connect(RefreshPlayersList)
vu18.PlayerRemoving:Connect(RefreshPlayersList)

-- === 🎭 تحديد الأدوار === --
local Gameplay = {}
local function GetRoles()
	local Data = vu16.Remotes.Extras.GetPlayerData:InvokeServer()
	for Name, Info in pairs(Data) do
		if Info.Role ~= "Innocent" then
			local Player = vu18:FindFirstChild(Name)
			if Player then
				Gameplay[Info.Role] = Player
			end
		end
	end
end

-- === 🧠 الدوال الأساسية من الملف === --
local function IsAlive(p107)
	local Name = p107 or vu26.Name
	local Data = vu16.Remotes.Extras.GetPlayerData:InvokeServer()[Name]
	if not Data then return false end
	return not Data.Dead and not Data.Killed
end

local function KillPlayer(pu195, pu196)
	task.spawn(function()
		local Target = vu18:FindFirstChild(pu195)
		if tostring(Gameplay.Murderer) == vu26.Name and Target then
			if not vu27:FindFirstChild("Knife") and pu196 then
				vu16.Remotes.Extras.ReplicateToy:InvokeServer("Knife")
				task.wait(0.1)
			end
			local HRP = Target.Character and Target.Character:FindFirstChild("HumanoidRootPart")
			local Knife = vu27:FindFirstChild("Knife")
			if HRP and Knife then
				if pu196 then
					Knife.Stab:FireServer()
				end
				firetouchinterest(HRP, Knife.Handle, 1)
				firetouchinterest(HRP, Knife.Handle, 0)
			end
		end
	end)
end

local function KillAll()
	task.spawn(function()
		if tostring(Gameplay.Murderer) == vu26.Name then
			for _, Player in ipairs(vu18:GetPlayers()) do
				if Player ~= vu26 and IsAlive(Player.Name) then
					KillPlayer(Player.Name, true)
					task.wait(0.05)
				end
			end
		end
	end)
end

local function KillSelectedPlayers(p206)
	if p206 then
		for _, Name in ipairs(p206) do
			KillPlayer(Name, true)
		end
	end
end

local function GetNearestPlayer(p143)
	if not (p143 and vu29) then return nil end
	local MinDist = math.huge
	local Nearest = nil
	for _, Player in ipairs(vu18:GetPlayers()) do
		if Player ~= vu26 and IsAlive(Player.Name) then
			local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
			if HRP then
				local Dist = (HRP.Position - vu29.Position).Magnitude
				if Dist <= tonumber(p143) and Dist < MinDist then
					Nearest = Player
					MinDist = Dist
				end
			end
		end
	end
	return Nearest
end

-- === 💥 Fling من السكربت الأصلي (نسخ حرفي للمنطق الأساسي) === --
local vu236 = false
local function Fling(pu244)
	pcall(function()
		if not pu244.Character or not vu29 then return end
		getgenv().FPDH = game.Workspace.FallenPartsDestroyHeight
		game.Workspace.FallenPartsDestroyHeight = math.huge
		game.Workspace.CurrentCamera.CameraSubject = pu244.Character:FindFirstChild("Humanoid") or pu244.Character:FindFirstChild("Head")
		
		local BodyVelocity = Instance.new("BodyVelocity")
		BodyVelocity.Velocity = Vector3.new(9e8, 9e8, 9e8)
		BodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
		BodyVelocity.Parent = pu244.Character:FindFirstChild("HumanoidRootPart") or pu244.Character:FindFirstChild("Head")
		
		task.wait(0.5)
		BodyVelocity:Destroy()
		game.Workspace.CurrentCamera.CameraSubject = vu28
		game.Workspace.FallenPartsDestroyHeight = getgenv().FPDH
	end)
end

local function FlingKill(pu262)
	pcall(function()
		if pu262 ~= "All" then
			local Target = vu18:FindFirstChild(pu262)
			if Target and Target ~= vu26 then
				Fling(Target)
			end
		else
			vu236 = true
			for _, Player in ipairs(vu18:GetPlayers()) do
				if Player ~= vu26 and IsAlive(Player.Name) then
					Fling(Player)
				end
			end
			vu236 = false
		end
	end)
end

-- === 🔄 تحديث القوائم داينمك (مثل الأصل) === --
local function UpdateDropdowns()
	RefreshPlayersList()
	if PlayersToKillDropdown then PlayersToKillDropdown:NewOptions(PlayersList) end
	if FlingPlayerDropdown then FlingPlayerDropdown:NewOptions(PlayersList) end
end

vu18.PlayerAdded:Connect(function() task.delay(0.3, UpdateDropdowns) end)
vu18.PlayerRemoving:Connect(UpdateDropdowns)

-- === 🔪 Murderer Tab === --
local PlayersToKillDropdown = MurdererTab:AddDropdown({
	Name = "Players To Kill",
	Options = PlayersList,
	MultiSelect = true,
	Default = {}
})

MurdererTab:AddButton({
	Name = "Kill Selected Players",
	Callback = function()
		KillSelectedPlayers(PlayersToKillDropdown:GetValue())
	end
})

MurdererTab:AddButton({
	Name = "Kill Sheriff",
	Callback = function()
		if Gameplay.Sheriff then
			KillPlayer(Gameplay.Sheriff.Name, true)
		else
			Window:Notify({ Title = "M1", Content = "Sheriff not found!", Duration = 3 })
		end
	end
})

MurdererTab:AddButton({
	Name = "Kill Everyone",
	Callback = function()
		KillAll()
	end
})

local KillAuraRange = 15
local KillAuraEnabled = false

MurdererTab:AddSlider({
	Name = "Kill Aura Range",
	Min = 1,
	Max = 60,
	Increment = 1,
	Default = KillAuraRange,
	Callback = function(v) KillAuraRange = v end
})

MurdererTab:AddToggle({
	Name = "Kill Aura",
	Default = false,
	Callback = function(v)
		KillAuraEnabled = v
		if v then
			spawn(function()
				while KillAuraEnabled do
					local Nearest = GetNearestPlayer(KillAuraRange)
					if Nearest then
						KillPlayer(Nearest.Name, true)
					end
					task.wait(0.15)
				end
			end)
		end
	end
})

-- Knife Silent Aim (باستخدام hook لاحقًا — لكن بدون أي تعليق)
local KnifeSilentAimEnabled = false
local vu396 = nil
MurdererTab:AddToggle({
	Name = "Knife Silent Aim",
	Default = false,
	Callback = function(v)
		KnifeSilentAimEnabled = v
		if v then
			spawn(function()
				while KnifeSilentAimEnabled do
					if tostring(Gameplay.Murderer) == vu26.Name then
						vu396 = GetNearestPlayer(60)
					else
						vu396 = nil
					end
					task.wait(0.2)
				end
			end)
		end
	end
})

-- Hook for Knife Silent Aim (بدون أي تعليق — جاهز للدمج)
local oldNamecall = nil
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
	if not checkcaller() and getnamecallmethod() == "FireServer" and self.Name == "Throw" and self.Parent == vu26 and KnifeSilentAimEnabled and vu396 then
		local HRP = vu396.Character and vu396.Character:FindFirstChild("HumanoidRootPart")
		if HRP then
			return oldNamecall(self, HRP.CFrame, select(2, ...))
		end
	end
	return oldNamecall(self, ...)
end)

-- === 🌀 Fling Tab === --
local FlingPlayerDropdown = FlingTab:AddDropdown({
	Name = "Fling Player",
	Options = PlayersList,
	MultiSelect = false,
	Default = PlayersList[1] or "None"
})

FlingTab:AddButton({
	Name = "Fling Selected",
	Callback = function()
		local Sel = FlingPlayerDropdown:GetValue()
		if type(Sel) == "string" and Sel ~= "None" then
			FlingKill(Sel)
		end
	end
})

FlingTab:AddButton({
	Name = "Fling Murderer",
	Callback = function()
		if Gameplay.Murderer then
			FlingKill(Gameplay.Murderer.Name)
		else
			Window:Notify({ Title = "M1", Content = "Murderer not found!", Duration = 3 })
		end
	end
})

FlingTab:AddButton({
	Name = "Fling Sheriff",
	Callback = function()
		if Gameplay.Sheriff then
			FlingKill(Gameplay.Sheriff.Name)
		else
			Window:Notify({ Title = "M1", Content = "Sheriff not found!", Duration = 3 })
		end
	end
})

FlingTab:AddButton({
	Name = "Fling All",
	Callback = function()
		FlingKill("All")
	end
})

-- === 🔄 بدء جمع الأدوار === --
GetRoles()

-- ربط أدوات السكربت عند دخولها
vu13.DescendantAdded:Connect(function(Obj)
	if Obj:IsA("Tool") and (Obj.Name == "Knife" or Obj.Name == "Gun") then
		local Owner = Obj:FindFirstAncestorOfClass("Model")
		if Owner and Owner.Parent == vu18 then
			local Player = vu18:GetPlayerFromCharacter(Owner)
			if Player then
				if Obj.Name == "Knife" then
					Gameplay.Murderer = Player
				elseif Obj.Name == "Gun" then
					Gameplay.Sheriff = Player
				end
			end
		end
	end
end)

Window:Notify({ Title = "M1", Content = "Murderer + Fling Loaded ✅", Duration = 4 })
