-- ✨ تحميل Wand UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()
local Window = Library:MakeWindow({
	Title = "M1's Murder & Fling",
	SubTitle = "For MM2 — Pure Power",
	ScriptFolder = "m1-murder-fling"
})

-- 🔪 تاب القاتل
local MurdererTab = Window:MakeTab({ Title = "Murderer", Icon = "axe" })

-- 🌀 تاب الفلينق
local FlingTab = Window:MakeTab({ Title = "Fling", Icon = "rotate-cw" })

-- === 🧬 المتغيرات الأساسية من السكربت الأصلي === --
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

-- === 📋 Players List === --
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
vu18.PlayerAdded:Connect(function() task.delay(0.3, RefreshPlayersList) end)
vu18.PlayerRemoving:Connect(RefreshPlayersList)

-- === 🎭 Roles Detection === --
local Gameplay = {}
local function DetectRoles()
	Gameplay = {}
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
DetectRoles()

-- === 🧠 IsAlive === --
local function IsAlive(p107)
	local Name = p107 or vu26.Name
	local Data = vu16.Remotes.Extras.GetPlayerData:InvokeServer()[Name]
	if not Data then return false end
	return not Data.Dead and not Data.Killed
end

-- === 💀 Kill Functions === --
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

-- === 🌪️ Fling Functions (مأخوذة حرفيًا من ملفك، محدثة) === --
local vu236 = false
local OldPos, FPDH

function Fling(pu244)
	pcall(function()
		if not pu244 or not pu244.Character then return end
		local Character = pu244.Character
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		local HRP = Humanoid and Humanoid.RootPart or Character:FindFirstChild("HumanoidRootPart")
		local Head = Character:FindFirstChild("Head")

		if not (HRP or Head) then return end

		if vu29 and vu29.Velocity.Magnitude < 50 then
			OldPos = vu29.CFrame
		end

		if vu236 and (Humanoid and Humanoid.Sit) then return end

		if Head then
			vu13.CurrentCamera.CameraSubject = Head
		elseif HRP then
			vu13.CurrentCamera.CameraSubject = Humanoid
		end

		if not Character:FindFirstChildWhichIsA("BasePart") then return end

		FPDH = vu13.FallenPartsDestroyHeight
		vu13.FallenPartsDestroyHeight = math.huge

		if Humanoid then
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
		end

		local Vel = Instance.new("BodyVelocity")
		Vel.Velocity = Vector3.new(9e8, 9e8, 9e8)
		Vel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
		Vel.Parent = (HRP or Head)

		local function Simulate(BasePart)
			local Start = tick()
			local Duration = 2
			local Angle = 0

			while vu29 and Humanoid and BasePart do
				if BasePart.Velocity.Magnitude > 50 then
					vu29.CFrame = CFrame.new(BasePart.Position) * CFrame.new(0, 1.5, Humanoid.WalkSpeed) * CFrame.Angles(math.rad(90), 0, 0)
					vu27:SetPrimaryPartCFrame(vu29.CFrame)
					task.wait()

					vu29.CFrame = CFrame.new(BasePart.Position) * CFrame.new(0, -1.5, -Humanoid.WalkSpeed)
					vu27:SetPrimaryPartCFrame(vu29.CFrame)
					task.wait()
				else
					Angle = Angle + 200
					local Offset = Humanoid.MoveDirection * (BasePart.Velocity.Magnitude / 1.25)
					vu29.CFrame = CFrame.new(BasePart.Position) + CFrame.new(0, 1.5, 0) + Offset
					vu27:SetPrimaryPartCFrame(vu29.CFrame)
					task.wait()
				end

				if BasePart.Velocity.Magnitude > 500 or
				   (BasePart.Parent ~= Character) or
				   (pu244.Parent ~= vu18) or
				   (not pu244.Character) or
				   (Humanoid.Sit) or
				   (Humanoid.Health <= 0) or
				   (tick() > Start + Duration) then
					break
				end
			end
		end

		if HRP and Head then
			if (HRP.Position - Head.Position).Magnitude <= 5 then
				Simulate(HRP)
			else
				Simulate(Head)
			end
		elseif HRP then
			Simulate(HRP)
		elseif Head then
			Simulate(Head)
		end

		Vel:Destroy()
		if Humanoid then
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		end

		vu13.CurrentCamera.CameraSubject = vu28
		vu13.FallenPartsDestroyHeight = FPDH or 100

		if OldPos then
			repeat
				vu29.CFrame = OldPos * CFrame.new(0, 0.5, 0)
				vu27:SetPrimaryPartCFrame(vu29.CFrame)
				vu28:ChangeState("GettingUp")
				for _, Part in ipairs(vu27:GetDescendants()) do
					if Part:IsA("BasePart") then
						Part.Velocity = Vector3.new()
						Part.RotVelocity = Vector3.new()
					end
				end
				task.wait()
			until (vu29.Position - OldPos.Position).Magnitude < 25
		end
	end)
end

function FlingKill(pu262)
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

-- === 🔄 تحديث Dropdowns داينمك === --
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
	Callback = KillAll
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

-- === 🔪 Knife Silent Aim (بدون أي تعليق) === --
local vu396 = nil
local SilentAimEnabled = false

MurdererTab:AddToggle({
	Name = "Knife Silent Aim",
	Default = false,
	Callback = function(v)
		SilentAimEnabled = v
		if v then
			spawn(function()
				while SilentAimEnabled do
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

-- Hook Namecall للـSilent Aim
local oldNamecall = nil
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
	if not checkcaller() and getnamecallmethod() == "FireServer" and self.Name == "Throw" and self.Parent == vu26 and SilentAimEnabled and vu396 then
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

-- === 🔁 Live Role Detection === --
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

Window:Notify({ Title = "M1", Content = "✅ Murderer + Fling Fully Loaded", Duration = 4 })
