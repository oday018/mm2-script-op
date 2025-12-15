local ui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", ui)
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(0, 30, 0, 120)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Auto Farm Coins"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(0, 120, 0, 30)
label.Position = UDim2.new(0, 10, 0, 50)
label.BackgroundTransparency = 1
label.Text = "Auto Farm:"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 18
label.Font = Enum.Font.Gotham

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0, 60, 0, 25)
toggle.Position = UDim2.new(0, 150, 0, 52)
toggle.Text = ""
toggle.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
toggle.BorderSizePixel = 0
toggle.AutoButtonColor = false

local uicorner = Instance.new("UICorner", toggle)
uicorner.CornerRadius = UDim.new(1, 0)

local circle = Instance.new("Frame", toggle)
circle.Size = UDim2.new(0, 22, 0, 22)
circle.Position = UDim2.new(0, 2, 0, 1.5)
circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
circle.BorderSizePixel = 0

local circleCorner = Instance.new("UICorner", circle)
circleCorner.CornerRadius = UDim.new(1, 0)
circle.Parent = toggle

getgenv().FarmCoins = false

toggle.MouseButton1Click:Connect(function()
	FarmCoins = not FarmCoins
	if FarmCoins then
		toggle.BackgroundColor3 = Color3.fromRGB(30, 180, 30)
		circle:TweenPosition(UDim2.new(1, -24, 0, 1.5), "Out", "Sine", 0.2, true)
	else
		toggle.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
		circle:TweenPosition(UDim2.new(0, 2, 0, 1.5), "Out", "Sine", 0.2, true)
	end
end)

local noclip = true
game:GetService("RunService").Stepped:Connect(function()
	if noclip and game.Players.LocalPlayer.Character then
		for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") and v.CanCollide then
				v.CanCollide = false
			end
		end
	end
end)

local function flyTo(pos)
	local char = game.Players.LocalPlayer.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local bv = Instance.new("BodyVelocity", root)
	bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
	local dir = (pos - root.Position).Unit
	local dist = (pos - root.Position).Magnitude
	local speed = 25
	bv.Velocity = dir * speed
	local time = dist / speed
	task.wait(time)
	bv:Destroy()
end

task.spawn(function()
	while true do
		if FarmCoins then
			local coins = {}
			for _, v in pairs(workspace:GetDescendants()) do
				if v.Name == "CoinContainer" then
					for _, coin in pairs(v:GetChildren()) do
						if coin:IsA("BasePart") then
							table.insert(coins, coin)
						end
					end
				end
			end
			for _, coin in ipairs(coins) do
				if not FarmCoins then break end
				if coin and coin:IsDescendantOf(workspace) then
					flyTo(coin.Position + Vector3.new(0, 3, 0))
				end
			end
		else
			task.wait(0.2)
		end
		task.wait(0.2)
	end
end)
