-- ╔══════════════════════════════════════════════════╗
-- ║         COIN FARM WITH WAND UI LIBRARY          ║
-- ║        Using Redz Library V5 Remake             ║
-- ╚══════════════════════════════════════════════════╝

-- تحميل المكتبة
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- إنشاء النافذة
local Window = Library:MakeWindow({
    Title = "🪙 Coin Farm",
    SubTitle = "Auto Farm Coins Script",
    ScriptFolder = "coin-farm"
})

-- إنشاء تبويب
local MainTab = Window:MakeTab({
    Title = "Main",
    Icon = "Home"
})

-- إضافة قسم
MainTab:AddSection("⚙️ Settings")

-- إعدادات الفارم
local FarmEnabled = false
local isTeleporting = false
local lastCoin = nil

-- إعدادات القيم
local RANGE = 200
local TELEPORT_DELAY = 0.3
local Y_OFFSET = -3
local SAFE_DELAY = 0.08

-- المتغيرات الأساسية
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

------------------------------------------------
-- وظيفة البحث عن أقرب عملة
------------------------------------------------
local function getClosestCoin()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then 
        return nil 
    end
    
    local root = lp.Character.HumanoidRootPart
    local closestCoin = nil
    local shortestDistance = RANGE

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("coin") and obj ~= lastCoin then
            local distance = (obj.Position - root.Position).Magnitude
            if distance <= shortestDistance then
                shortestDistance = distance
                closestCoin = obj
            end
        end
    end
    
    return closestCoin
end

------------------------------------------------
-- وظيفة التلييبورت الآمن
------------------------------------------------
local function safeTeleportToCoin(coin)
    -- فحص الشروط
    if not coin or not coin:IsDescendantOf(workspace) then return end
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    if isTeleporting then return end
    
    -- بدء التلييبورت
    isTeleporting = true
    local root = lp.Character.HumanoidRootPart
    
    -- الانتقال للعملة
    root.CFrame = coin.CFrame * CFrame.new(0, Y_OFFSET, 0)
    task.wait(SAFE_DELAY)
    
    -- حركة صغيرة للتأكد من الجمع
    root.CFrame = root.CFrame * CFrame.new(0, 1, 0)
    
    -- حفظ آخر عملة
    lastCoin = coin
    task.wait(0.05)
    isTeleporting = false
end

------------------------------------------------
-- Toggle التشغيل/الإيقاف
------------------------------------------------
local FarmToggle = MainTab:AddToggle({
    Name = "🔄 Enable Auto Farm",
    Default = false,
    Callback = function(Value)
        FarmEnabled = Value
        
        -- إظهار إشعار
        Window:Notify({
            Title = FarmEnabled and "✅ Farm Started" or "⏸️ Farm Stopped",
            Content = FarmEnabled and "Auto farming is now active" or "Auto farming has been stopped",
            Duration = 3
        })
        
        -- تشغيل/إيقاف الفارم
        if FarmEnabled then
            spawn(function()
                while FarmEnabled do
                    if FarmEnabled then
                        local coin = getClosestCoin()
                        if coin then
                            safeTeleportToCoin(coin)
                            task.wait(TELEPORT_DELAY)
                        else
                            lastCoin = nil
                            task.wait(1)
                        end
                    end
                    task.wait()
                end
            end)
        end
    end
})

------------------------------------------------
-- Slider: نطاق البحث
------------------------------------------------
local RangeSlider = MainTab:AddSlider({
    Name = "🔍 Search Range",
    Min = 50,
    Max = 500,
    Default = 200,
    Increment = 10,
    Callback = function(Value)
        RANGE = Value
    end
})

------------------------------------------------
-- Slider: سرعة الفارم
------------------------------------------------
local SpeedSlider = MainTab:AddSlider({
    Name = "⚡ Farm Speed",
    Min = 0.1,
    Max = 1.0,
    Default = 0.3,
    Increment = 0.05,
    Callback = function(Value)
        TELEPORT_DELAY = Value
    end
})

-- إضافة قسم التحكم
MainTab:AddSection("🎮 Controls")

------------------------------------------------
-- Button: زر البحث عن عملة واحدة
------------------------------------------------
MainTab:AddButton({
    Name = "🔎 Find Nearest Coin",
    Callback = function()
        local coin = getClosestCoin()
        if coin then
            safeTeleportToCoin(coin)
            Window:Notify({
                Title = "✅ Coin Found",
                Content = "Teleported to nearest coin",
                Duration = 2
            })
        else
            Window:Notify({
                Title = "⚠️ No Coins",
                Content = "No coins found in range",
                Duration = 2
            })
        end
    end
})

------------------------------------------------
-- Button: إعادة تعيين العملات
------------------------------------------------
MainTab:AddButton({
    Name = "🔄 Reset Last Coin",
    Callback = function()
        lastCoin = nil
        Window:Notify({
            Title = "🔄 Reset Complete",
            Content = "Last coin memory has been cleared",
            Duration = 2
        })
    end
})

-- إضافة قسم المعلومات
MainTab:AddSection("📊 Stats")

------------------------------------------------
-- TextBox: عرض حالة الفارم
------------------------------------------------
MainTab:AddParagraph("Current Status:", FarmEnabled and "🟢 ACTIVE" or "🔴 INACTIVE")
MainTab:AddParagraph("Search Range:", tostring(RANGE) .. " studs")
MainTab:AddParagraph("Farm Speed:", tostring(math.round((1/TELEPORT_DELAY)*10)/10) .. " coins/sec")

------------------------------------------------
-- زر الإغلاق
------------------------------------------------
MainTab:AddButton({
    Name = "❌ Close UI",
    Callback = function()
        -- إيقاف الفارم
        FarmEnabled = false
        
        -- إغلاق النافذة
        Window:Destroy()
        
        -- إشعار الخروج
        Library:Notify({
            Title = "👋 Goodbye",
            Content = "UI has been closed. Farm stopped.",
            Duration = 3
        })
    end
})

-- Dialog تأكيد عند الخروج
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == lp then
        FarmEnabled = false
    end
end)

-- Minimizer (اختياري)
local Minimizer = Window:NewMinimizer({
    KeyCode = Enum.KeyCode.RightControl
})

-- إشعار بدء التشغيل
Window:Notify({
    Title = "🎮 Coin Farm Loaded",
    Content = "Use Right Control to minimize/maximize",
    Duration = 5
})
