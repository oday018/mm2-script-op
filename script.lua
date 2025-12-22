-- 🪄 Wand UI Fling Suite | by ScripterMrbacon (M1)
-- ✨ Integrated with Wand UI (Redz Library V5 Remake)

-- ✅ تحميل Wand UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- ✅ نافذة رئيسية
local Window = Library:MakeWindow({
	Title = "🪄 Fling Suite",
	SubTitle = "Anti-Fling + Fling Utilities",
	ScriptFolder = "FlingSuite_MM2"
})

-- 🔐 إعدادات الحماية
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local detectedFlingers = {}
local antiFlingEnabled = false
local antiFlingLastPos = Vector3.zero

-- 🔄 تحديث موقع آمن
RunService.Heartbeat:Connect(function()
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root and root.AssemblyLinearVelocity.Magnitude < 50 then
		antiFlingLastPos = root.Position
	end
end)

-- 🛡️ تفعيل Anti-Fling
local function EnableAntiFling()
	antiFlingEnabled = true
	Window:Notify({
		Title = "🛡️ Anti-Fling",
		Content = "تم تفعيل الحماية من الـ Fling!",
		Duration = 3,
		Image = "rbxassetid://6895079853"
	})
	
	-- مراقبة الحركة غير الطبيعية
	RunService.Heartbeat:Connect(function()
		local char = LocalPlayer.Character
		local root = char and root or char:FindFirstChild("HumanoidRootPart")
		if not root then return end
		
		-- كشف Fling
		if root.AssemblyLinearVelocity.Magnitude > 250 or root.AssemblyAngularVelocity.Magnitude > 250 then
			Window:Notify({
				Title = "⚠️ Fling Detected!",
				Content = "تم اكتشاف محاولة Fling! تم تحييد الحركة.",
				Duration = 4,
				Image = "rbxassetid://7305444018"
			})
			
			-- إرجاع اللاعب للموقع الآمن
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
			if antiFlingLastPos ~= Vector3.zero then
				root.CFrame = CFrame.new(antiFlingLastPos)
			end
		end
		
		-- إيقاف التصادم مع اللاعبين أثناء الهجوم (لحماية إضافية)
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character then
				for _, part in ipairs(player.Character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end
	end)
	
	-- كشف الـ Flingers الآخرين
	RunService.Heartbeat:Connect(function()
		for _, pl in ipairs(Players:GetPlayers()) do
			if pl ~= LocalPlayer and pl.Character and pl.Character.PrimaryPart then
				local part = pl.Character.PrimaryPart
				if part.AssemblyAngularVelocity.Magnitude > 80 or part.AssemblyLinearVelocity.Magnitude > 150 then
					if not detectedFlingers[pl.Name] then
						detectedFlingers[pl.Name] = true
						Window:Notify({
							Title = "🕵️ Flinger Detected!",
							Content = "اللاعب '" .. pl.Name .. "' يستخدم Fling!",
							Duration = 5,
							Image = "rbxassetid://5043559549"
						})
					end
				end
			end
		end
	end)
end

-- 💥 Fling لاعب معين
local function FlingPlayer(targetPlayer)
	if not targetPlayer or not targetPlayer.Character then return end
	local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end
	
	-- حماية ضد تفعيل Fling أثناء Anti-Fling
	if antiFlingEnabled then
		Window:Notify({
			Title = "❌ Fling Blocked",
			Content = "Anti-Fling مفعل! لا يمكن استخدام Fling الآن.",
			Duration = 3
		})
		return
	end
	
	-- تطبيق Fling
	local flingVelocity = Vector3.new(
		math.random(-200, 200),
		300,
		math.random(-200, 200)
	)
	root.AssemblyLinearVelocity = flingVelocity
	root.AssemblyAngularVelocity = Vector3.new(500, 500, 500)
	
	Window:Notify({
		Title = "🪄 Fling Activated!",
		Content = "تم تطبيق Fling على " .. targetPlayer.Name,
		Duration = 2,
		Image = "rbxassetid://5043559549"
	})
end

-- 🔍 الحصول على دور اللاعب في MM2
local function GetRole(player)
	player = player or LocalPlayer
	local backpack = player:FindFirstChild("Backpack")
	if backpack then
		if backpack:FindFirstChild("Knife") then return "Murderer" end
		if backpack:FindFirstChild("Gun") then return "Sheriff" end
	end
	local char = player.Character
	if char then
		if char:FindFirstChild("Knife") then return "Murderer" end
		if char:FindFirstChild("Gun") then return "Sheriff" end
	end
	return "Innocent"
end

-- 🎯 تبويب Fling Suite
local Tab = Window:MakeTab({ Title = "🪄 Fling Suite", Icon = "Flame" })

-- قسم الحماية
Tab:AddSection("🛡️ Anti-Fling")
Tab:AddToggle({
	Name = "تفعيل Anti-Fling",
	Default = false,
	Callback = function(Value)
		if Value then
			EnableAntiFling()
		else
			antiFlingEnabled = false
			Window:Notify({
				Title = "🛡️ Anti-Fling",
				Content = "تم تعطيل الحماية.",
				Duration = 2
			})
		end
	end
})

-- قسم الهجوم
Tab:AddSection("💥 Fling Utilities")

-- قائمة اللاعبين
local playerNames = {"[اختر لاعب]"}
for _, p in ipairs(Players:GetPlayers()) do
	if p ~= LocalPlayer then table.insert(playerNames, p.Name) end
end

local SelectedPlayerName = "[اختر لاعب]"
local PlayerDropdown = Tab:AddDropdown({
	Name = "اختر لاعب لتطييره",
	Options = playerNames,
	Default = "[اختر لاعب]",
	Callback = function(Value)
		SelectedPlayerName = Value
	end
})

-- تحديث القائمة عند دخول لاعب جديد
Players.PlayerAdded:Connect(function(player)
	if player ~= LocalPlayer then
		PlayerDropdown:Add(player.Name)
	end
end)

Tab:AddButton({
	Name = "Fling اللاعب المحدد",
	Callback = function()
		if SelectedPlayerName == "[اختر لاعب]" then
			Window:Notify({ Title = "❌ خطأ", Content = "اختر لاعب أولًا!", Duration = 2 })
			return
		end
		local target = Players:FindFirstChild(SelectedPlayerName)
		if target then
			FlingPlayer(target)
		else
			Window:Notify({ Title = "❌ خطأ", Content = "اللاعب غير موجود!", Duration = 2 })
		end
	end
})

-- Fling Sheriff/Murderer (لـ MM2 فقط)
if game.PlaceId == 66654135 then
	Tab:AddSection("🔫 MM2 Special Fling")
	
	Tab:AddButton({
		Name = "Fling Sheriff",
		Callback = function()
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LocalPlayer and GetRole(p) == "Sheriff" then
					FlingPlayer(p)
					return
				end
			end
			Window:Notify({ Title = "❌ خطأ", Content = "لا يوجد Sheriff!", Duration = 2 })
		end
	})
	
	Tab:AddButton({
		Name = "Fling Murderer",
		Callback = function()
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LocalPlayer and GetRole(p) == "Murderer" then
					FlingPlayer(p)
					return
				end
			end
			Window:Notify({ Title = "❌ خطأ", Content = "لا يوجد Murderer!", Duration = 2 })
		end
	})
end

-- زر طوارئ: Neutralize Fling Now
Tab:AddButton({
	Name = "🛑 Neutralize Fling Now",
	Debounce = 1,
	Callback = function()
		local char = LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if root then
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
			Window:Notify({
				Title = "✅ تم التحييد!",
				Content = "تم إيقاف أي حركة غير طبيعية فورًا.",
				Duration = 2
			})
		end
	end
})

Window:Notify({
	Title = "🪄 Fling Suite",
	Content = "تم تحميل السكربت بنجاح! ✨\nAnti-Fling + Fling أدوات جاهزة.",
	Duration = 5,
	Image = "rbxassetid://10734953451"
})
