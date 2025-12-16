-- Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "MM2 Module",
	LoadingTitle = "Murder Mystery 2",
	LoadingSubtitle = "Rayfield UI",
	ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Main")
local ToolsTab = Window:CreateTab("Tools")

-- Vars
local playerESP = false
local coinAutoCollect = false
local autoShooting = false
local shootOffset = 3.5

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PathfindingService = game:GetService("PathfindingService")

-- Functions (نفسها)
local function findMurderer()
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Backpack:FindFirstChild("Knife") or (p.Character and p.Character:FindFirstChild("Knife")) then
			return p
		end
	end
end

local function findSheriff()
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Backpack:FindFirstChild("Gun") or (p.Character and p.Character:FindFirstChild("Gun")) then
			return p
		end
	end
end

-- ================= ESP =================
MainTab:CreateToggle({
	Name = "Player ESP",
	CurrentValue = false,
	Callback = function(v)
		playerESP = v
		if not v then
			for _, h in ipairs(game.CoreGui:GetChildren()) do
				if h.Name == "PlayerESP" then h:Destroy() end
			end
		end
	end
})

task.spawn(function()
	while task.wait(1) do
		if playerESP then
			for _, p in ipairs(Players:GetPlayers()) do
				if p.Character and not game.CoreGui:FindFirstChild(p.Name) then
					local h = Instance.new("Highlight")
					h.Name = "PlayerESP"
					h.Adornee = p.Character
					h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					if p == findMurderer() then
						h.FillColor = Color3.fromRGB(255,0,0)
					elseif p == findSheriff() then
						h.FillColor = Color3.fromRGB(0,150,255)
					else
						h.FillColor = Color3.fromRGB(0,255,0)
					end
					h.Parent = game.CoreGui
				end
			end
		end
	end
end)

-- ================= COINS =================
MainTab:CreateToggle({
	Name = "Coins Magnet",
	CurrentValue = false,
	Callback = function(v)
		coinAutoCollect = v
	end
})

task.spawn(function()
	while task.wait(0.1) do
		if coinAutoCollect and workspace:FindFirstChild("Normal") then
			local cc = workspace.Normal:FindFirstChild("CoinContainer")
			if cc then
				local coin = cc:FindFirstChild("Coin_Server")
				if coin and LocalPlayer.Character then
					LocalPlayer.Character:MoveTo(coin.Position)
				end
			end
		end
	end
end)

-- ================= TOOLS =================
ToolsTab:CreateButton({
	Name = "Shoot Murderer",
	Callback = function()
		if findSheriff() ~= LocalPlayer then return end
		local m = findMurderer()
		if not m then return end

		if not LocalPlayer.Character:FindFirstChild("Gun") then
			LocalPlayer.Character.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild("Gun"))
		end

		local args = {
			[1] = 1,
			[2] = m.Character.HumanoidRootPart.Position + m.Character.Humanoid.MoveDirection * shootOffset,
			[3] = "AH"
		}

		LocalPlayer.Character.Gun.KnifeServer.ShootGun:InvokeServer(unpack(args))
	end
})

ToolsTab:CreateToggle({
	Name = "Auto Shoot Murderer",
	CurrentValue = false,
	Callback = function(v)
		autoShooting = v
	end
})

task.spawn(function()
	while task.wait(0.3) do
		if autoShooting and findSheriff() == LocalPlayer then
			local m = findMurderer()
			if m then
				if not LocalPlayer.Character:FindFirstChild("Gun") then
					LocalPlayer.Character.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild("Gun"))
				end

				local args = {
					[1] = 1,
					[2] = m.Character.HumanoidRootPart.Position + m.Character.Humanoid.MoveDirection * shootOffset,
					[3] = "AH"
				}

				LocalPlayer.Character.Gun.KnifeServer.ShootGun:InvokeServer(unpack(args))
			end
		end
	end
end)

ToolsTab:CreateInput({
	Name = "Shoot Offset",
	PlaceholderText = "3.5",
	Callback = function(v)
		if tonumber(v) then
			shootOffset = tonumber(v)
		end
	end
})

ToolsTab:CreateButton({
	Name = "Fast Move To Dropped Gun",
	Callback = function()
		local gun = workspace:FindFirstChild("GunDrop")
		if not gun then return end

		local path = PathfindingService:CreatePath()
		path:ComputeAsync(LocalPlayer.Character.HumanoidRootPart.Position, gun.Position)

		for _, wp in ipairs(path:GetWaypoints()) do
			LocalPlayer.Character.HumanoidRootPart.CFrame =
				CFrame.new(wp.Position + Vector3.new(0,3,0))
			task.wait(0.05)
		end
	end
})
