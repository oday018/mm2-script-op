-- MM2 Coin Auto Farm
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = Library:MakeWindow({
    Title = "MM2 Coin Farmer",
    SubTitle = "Safe & Undetected",
    ScriptFolder = "mm2-farmer"
})

local MainTab = Window:MakeTab({Title = "Farming", Icon = "Coin"})

-- تفعيل/تعطيل الزراعة
local farmEnabled = false
MainTab:AddToggle({
    Name = "Enable Auto Farm",
    Default = false,
    Callback = function(value)
        farmEnabled = value
        if value then
            startMM2Farm()
        end
    end
})

-- إعدادات الأمان
MainTab:AddSlider({
    Name = "Farm Speed",
    Min = 1,
    Max = 5,
    Default = 2,
    Callback = function(value)
        getgenv().farmSpeed = value
    end
})

MainTab:AddToggle({
    Name = "Anti-Kick Mode",
    Default = true,
    Callback = function(value)
        getgenv().antiKick = value
    end
})

local function startMM2Farm()
    spawn(function()
        while farmEnabled do
            -- 1. البحث عن أقرب عملة بطريقة آمنة
            local nearestCoin = nil
            local minDistance = math.huge
            
            for _, item in pairs(workspace:GetChildren()) do
                if string.find(item.Name, "Coin") and item:IsA("BasePart") then
                    local distance = (item.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance < minDistance and distance < 100 then
                        minDistance = distance
                        nearestCoin = item
                    end
                end
            end
            
            -- 2. إذا وجدنا عملة، نتحرك نحوها
            if nearestCoin then
                -- استخدام المشي الطبيعي
                game.Players.LocalPlayer.Character.Humanoid:MoveTo(nearestCoin.Position)
                
                -- انتظار وصول معقول
                for i = 1, 50 do -- 50 محاولة (5 ثواني)
                    if not farmEnabled then break end
                    
                    local currentDistance = (nearestCoin.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    
                    if currentDistance < 10 then
                        -- قريب بما يكفي، نجرب الجمع
                        if nearestCoin and nearestCoin.Parent then
                            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, nearestCoin, 0)
                            task.wait(0.05)
                            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, nearestCoin, 1)
                        end
                        break
                    end
                    task.wait(0.1)
                end
            end
            
            task.wait(0.5) -- فاصل بين الدورات
        end
    end)
end

-- إضافة تحذير أمان
Window:Notify({
    Title = "MM2 Safety Warning",
    Content = "Use with caution! Avoid obvious movement patterns.",
    Duration = 10
})
