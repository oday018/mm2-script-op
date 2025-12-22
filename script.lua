-- 🪄 Wand Interactive Fling | by ScripterMrbacon (M1)
-- ✨ لا يبدأ أي شيء بدون ضغط زر!

-- ✅ تحميل Wand UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- ✅ نافذة رئيسية
local Window = Library:MakeWindow({
	Title = "🪄 Interactive Fling",
	SubTitle = "Anti-Fling + Fling (Manual Only)",
	ScriptFolder = "InteractiveFling_MM2"
})

-- 🔐 إعدادات الحماية
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- 🧠 متغيرات
local antiFlingLastPos = Vector3.zero
local isFlingActive = false
local isAntiFlingActive = false

-- 🔄 تحديث الموقع الآمن فقط
RunService.Heartbeat:Connect(function()
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root and not isAntiFlingActive then -- فقط لو ما كانش Anti-Fling شغال
		antiFlingLastPos = root.Position
	end
end)

-- 🛡️ وظيفة Anti-Fling يدوية
local function ActivateAntiFling()
	isAntiFlingActive = true
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then
		Window:Notify({ Title = "❌", Content = "موجودش كاراكتر!", Duration = 2 })
		isAntiFlingActive = false
		return
	end

	-- إيقاف الحركة فورًا
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero

	-- الرجوع للموقع الآمن
	if antiFlingLastPos ~= Vector3.zero then
		root.CFrame = CFrame.new(antiFlingLastPos)
	end

	Window:Notify({
		Title = "🛡️ Anti-Fling",
		Content = "تم تحييد Fling!",
		Duration = 3,
		Image = "rbxassetid://6895079853"
	})

	-- إيقاف التفعيل بعد 0.5 ثانية
	task.wait(0.5)
	isAntiFlingActive = false
end

-- 💥 وظيفة Fling يدوية
local function ActivateFling(targetPlayer)
	if not targetPlayer or not targetPlayer.Character then
		Window:Notify({ Title = "❌", Content = "الهدف غير موجود!", Duration = 2 })
		return
	end

	local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root then
		Window:Notify({ Title = "❌", Content = "موجودش HumanoidRootPart!", Duration = 2 })
		return
	end

	-- تطبيق Fling فقط عند الضغط
	local flingVelocity = Vector3.new(
		math.random(-150, 150),
		200,
		math.random(-150, 150)
	)
	root.AssemblyLinearVelocity = flingVelocity
	root.AssemblyAngularVelocity = Vector3.new(400, 400, 400)

	Window:Notify({
		Title = "🪄 Fling!",
		Content = "تم تطبيق Fling على " .. targetPlayer.Name,
		Duration = 2,
		Image = "rbxassetid://5043559549"
	})
end

-- 🔍 دالة إيجاد أقرب لاعب
local function GetClosestPlayer()
	local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not myRoot then return nil end

	local closestPlayer = nil
	local closestDistance = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (myRoot.Position - player.Character.HumanoidRootPart.Position).Magnitude
			if distance < closestDistance then
				closestDistance = distance
				closestPlayer = player
			end
		end
	end

	return closestPlayer
end

-- 🎯 تبويب Fling
local Tab = Window:MakeTab({ Title = "🪄 Interactive Fling", Icon = "Flame" })

-- قسم الأزرار اليدوية
Tab:AddSection("🕹️ أوامر يدوية")

-- زر Anti-Fling
Tab:AddButton({
	Name = "🛡️ Activate Anti-Fling (Z)",
	Callback = function()
		ActivateAntiFling()
	end
})

-- زر Fling للاعب محدد
local SelectedPlayerName = "[اختر لاعب]"
local PlayerDropdown = Tab:AddDropdown({
	Name = "اختر لاعب لـ Fling",
	Options = { "[اختر لاعب]" },
	Callback = function(Value)
		SelectedPlayerName = Value
	end
})

-- تحديث القائمة
for _, p in ipairs(Players:GetPlayers()) do
	if p ~= LocalPlayer then
		PlayerDropdown:Add(p.Name)
	end
end
Players.PlayerAdded:Connect(function(player)
	if player ~= LocalPlayer then
		PlayerDropdown:Add(player.Name)
	end
end)

Tab:AddButton({
	Name = "💥 Fling Player (X)",
	Callback = function()
		if SelectedPlayerName == "[اختر لاعب]" then
			Window:Notify({ Title = "❌", Content = "اختر لاعب أولًا!", Duration = 2 })
			return
		end
		local target = Players:FindFirstChild(SelectedPlayerName)
		if target then
			ActivateFling(target)
		end
	end
})

-- زر Fling أقرب لاعب
Tab:AddButton({
	Name = "💥 Fling Closest Player",
	Callback = function()
		local target = GetClosestPlayer()
		if target then
			ActivateFling(target)
		else
			Window:Notify({ Title = "❌", Content = "ما فيش لاعب قريب!", Duration = 2 })
		end
	end
})

-- 🎮 تفعيل الأزرار من الكيبورد (اختياري)
UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Z then
		ActivateAntiFling()
	elseif input.KeyCode == Enum.KeyCode.X then
		if SelectedPlayerName ~= "[اختر لاعب]" then
			local target = Players:FindFirstChild(SelectedPlayerName)
			if target then
				ActivateFling(target)
			end
		else
			Window:Notify({ Title = "❌", Content = "اختر لاعب من القائمة!", Duration = 2 })
		end
	end
end)

Window:Notify({
	Title = "🪄 Interactive Fling",
	Content = "كل شيء يدوي! اضغط الأزرار أو استخدم Z/X.",
	Duration = 4,
	Image = "rbxassetid://10734953451"
})
