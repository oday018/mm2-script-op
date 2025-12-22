-- 1. تحميل المكتبة
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- 2. إنشاء نافذة
local Window = Library:MakeWindow({
	Title = "M1's Magic Hub",
	SubTitle = "Powered by real_redz ❤️",
	ScriptFolder = "redz-library-V5"
})

-- 3. إنشاء تاب أساسي
local MainTab = Window:MakeTab({ Title = "Main", Icon = "Home" })

-- 4. أضف أدواتك المفضلة!
MainTab:AddButton({
	Name = "Teleport ESP",
	Callback = function()
		print("ESP activated by M1 😈")
	end
})

MainTab:AddToggle({
	Name = "Noclip",
	Flag = "noclip_enabled",
	Default = false,
	Callback = function(Value)
		Window:SetFlag("noclip_enabled", Value)
		-- شغل/أطفئ noclip هنا
	end
})
