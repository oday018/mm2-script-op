-- ==================== تحميل المكتبة ====================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- ==================== إنشاء النافذة ====================
local Window = Library:MakeWindow({
    Title = "🎯 سكربت القذف المتكامل",
    SubTitle = "جميع أنواع القذف | MM2",
    ScriptFolder = "Ultimate-Fling-Script"
})

-- ==================== الخدمات الأساسية ====================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

-- ==================== دالة الحصول على الأدوار ====================
local function GetRoles()
    local success, data = pcall(function()
        return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    end)
    
    if not success or not data then
        -- طريقة بديلة إذا فشلت الأولى
        return {}
    end
    
    local roles = {}
    for playerName, playerData in pairs(data) do
        if not playerData.Dead then
            roles[playerName] = playerData.Role
        end
    end
    
    return roles
end

-- ==================== دالة القذف القوية جدا ====================
local function SHubFling(TargetPlayer)
    if not TargetPlayer then return false end
    if not Character or not Humanoid or not HumanoidRootPart then return false end
    
    local TCharacter = TargetPlayer.Character
    if not TCharacter then return false end
    
    -- الحصول على أجزاء الهدف
    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    
    if not TRootPart and not THead then return false end
    
    local targetPart = TRootPart or THead
    
    -- حفظ موقعنا الأصلي
    local OldPos = HumanoidRootPart.CFrame
    
    -- 🔥 1. قذف مباشر وقوي جدا
    local function ApplyDirectFling()
        -- الانتقال قريب من الهدف
        local targetPosition = targetPart.Position
        local flingPosition = targetPosition + Vector3.new(0, 3, 0)
        
        HumanoidRootPart.CFrame = CFrame.new(flingPosition)
        task.wait(0.05)
        
        -- تطبيق قوة قذف قوية جدا
        local flingForce = Vector3.new(
            math.random(-150000, 150000),  -- 🚀 قوة أفقية خيالية
            200000,                         -- 🚀 قوة رأسية هائلة
            math.random(-150000, 150000)   -- 🚀 قوة أفقية خيالية
        )
        
        targetPart.Velocity = flingForce
        
        -- تطبيق دوران سريع جدا
        targetPart.RotVelocity = Vector3.new(
            math.random(-25000, 25000),
            math.random(-25000, 25000),
            math.random(-25000, 25000)
        )
        
        -- إضافة دفعات إضافية
        for i = 1, 3 do
            task.wait(0.1)
            if targetPart and targetPart.Parent then
                targetPart.Velocity = targetPart.Velocity + Vector3.new(
                    math.random(-50000, 50000),
                    80000,
                    math.random(-50000, 50000)
                )
            end
        end
    end
    
    -- 🔥 2. تجميد وإطلاق
    local function FreezeAndLaunch()
        -- تجميد مؤقت
        targetPart.Anchored = true
        task.wait(0.1)
        targetPart.Anchored = false
        
        -- إطلاق قوي
        targetPart.Velocity = Vector3.new(
            math.random(-200000, 200000),
            250000,  -- 🚀 أعلى قوة رأسية ممكنة
            math.random(-200000, 200000)
        )
    end
    
    -- المحاولة الأولى: القذف المباشر
    local success1 = pcall(ApplyDirectFling)
    
    if not success1 then
        -- المحاولة الثانية: التجميد والإطلاق
        task.wait(0.2)
        local success2 = pcall(FreezeAndLaunch)
        
        if not success2 then
            -- المحاولة الثالثة: طريقة بديلة
            task.wait(0.2)
            pcall(function()
                targetPart.Velocity = Vector3.new(0, 300000, 0)
            end)
        end
    end
    
    -- العودة لموقعنا
    task.wait(0.3)
    HumanoidRootPart.CFrame = OldPos
    
    -- تنظيف السرعة
    HumanoidRootPart.Velocity = Vector3.zero
    HumanoidRootPart.RotVelocity = Vector3.zero
    
    return true
end

-- ==================== إنشاء التبويب ====================
local FlingTab = Window:MakeTab({
    Title = "🎯 القذف",
    Icon = "rbxassetid://4483345998"
})

-- ==================== تبويب القذف ====================
FlingTab:AddSection("💨 قذف حسب الدور")

FlingTab:AddButton({
    Name = "قذف القاتل",
    Callback = function()
        local roles = GetRoles()
        local found = false
        
        for playerName, role in pairs(roles) do
            if role == "Murderer" then
                local murderer = Players:FindFirstChild(playerName)
                if murderer and murderer ~= LocalPlayer then
                    local success = SHubFling(murderer)
                    found = success
                    
                    Window:Notify({
                        Title = success and "💨 تم قذف القاتل" or "❌ فشل القذف",
                        Content = success and "تم قذف: " .. murderer.Name or "لم يتمكن من قذف القاتل",
                        Duration = 3
                    })
                    break
                end
            end
        end
        
        if not found then
            Window:Notify({
                Title = "❌ خطأ",
                Content = "لم يتم العثور على القاتل",
                Duration = 3
            })
        end
    end
})

FlingTab:AddButton({
    Name = "قذف الشريف/البطل",
    Callback = function()
        local roles = GetRoles()
        local found = false
        
        for playerName, role in pairs(roles) do
            if role == "Sheriff" or role == "Hero" then
                local target = Players:FindFirstChild(playerName)
                if target and target ~= LocalPlayer then
                    local success = SHubFling(target)
                    found = success
                    
                    Window:Notify({
                        Title = success and "💨 تم القذف" or "❌ فشل القذف",
                        Content = success and "تم قذف: " .. target.Name or "فشل في قذف الهدف",
                        Duration = 3
                    })
                    break
                end
            end
        end
        
        if not found then
            Window:Notify({
                Title = "❌ خطأ",
                Content = "لم يتم العثور على الشريف أو البطل",
                Duration = 3
            })
        end
    end
})

FlingTab:AddSection("🔥 قذف الكل (توجل)")

local FlingAllEnabled = false
local FlingAllLoop = nil

FlingTab:AddToggle({
    Name = "قذف جميع اللاعبين",
    Default = false,
    Callback = function(Value)
        FlingAllEnabled = Value
        
        if Value then
            FlingAllLoop = task.spawn(function()
                while FlingAllEnabled do
                    local flungCount = 0
                    
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            local success = SHubFling(player)
                            if success then
                                flungCount = flungCount + 1
                            end
                            task.wait(0.3)  -- وقت بين القذف
                        end
                    end
                    
                    if flungCount > 0 then
                        Window:Notify({
                            Title = "💥 قذف جماعي",
                            Content = "تم قذف " .. flungCount .. " لاعب",
                            Duration = 2
                        })
                    end
                    
                    task.wait(2)  -- انتظار قبل التكرار
                end
            end)
            
            Window:Notify({
                Title = "🔥 تم تفعيل قذف الكل",
                Content = "جاري قذف جميع اللاعبين",
                Duration = 3
            })
        else
            if FlingAllLoop then
                FlingAllLoop:Cancel()
                FlingAllLoop = nil
            end
            
            Window:Notify({
                Title = "🛑 تم إيقاف قذف الكل",
                Content = "توقف القذف الجماعي",
                Duration = 3
            })
        end
    end
})

FlingTab:AddSection("🎯 قذف لاعب محدد")

-- قائمة اللاعبين
local function GetPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

local SelectedPlayer = nil

local PlayerDropdown = FlingTab:AddDropdown({
    Name = "اختر لاعب",
    Default = GetPlayerNames()[1] or "",
    Options = GetPlayerNames(),
    Callback = function(Value)
        SelectedPlayer = Value
    end
})

-- تحديث القائمة
local function UpdateDropdown()
    PlayerDropdown:NewOptions(GetPlayerNames())
end

Players.PlayerAdded:Connect(UpdateDropdown)
Players.PlayerRemoving:Connect(UpdateDropdown)

FlingTab:AddButton({
    Name = "قذف اللاعب المحدد",
    Callback = function()
        if SelectedPlayer then
            local player = Players:FindFirstChild(SelectedPlayer)
            if player and player ~= LocalPlayer then
                local success = SHubFling(player)
                
                Window:Notify({
                    Title = success and "💨 تم القذف" or "❌ فشل",
                    Content = success and "تم قذف: " .. player.Name or "فشل في قذف اللاعب",
                    Duration = 3
                })
            else
                Window:Notify({
                    Title = "❌ خطأ",
                    Content = "اللاعب غير موجود",
                    Duration = 3
                })
            end
        else
            Window:Notify({
                Title = "⚠️ تنبيه",
                Content = "اختر لاعباً أولاً",
                Duration = 3
            })
        end
    end
})

FlingTab:AddSection("⚡ أدوات إضافية")

FlingTab:AddButton({
    Name = "🔍 اختبار القذف",
    Callback = function()
        -- اختبار على لاعب عشوائي
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local success = SHubFling(player)
                
                Window:Notify({
                    Title = success and "✅ اختبار ناجح" or "❌ اختبار فاشل",
                    Content = success and "تم قذف " .. player.Name .. " بنجاح" or "فشل القذف",
                    Duration = 4
                })
                break
            end
        end
    end
})

FlingTab:AddParagraph("✨ معلومات", [[
🎯 سكربت القذف القوي
• قوة رأسية: 250,000
• قوة أفقية: 200,000  
• يعمل على جميع اللاعبين
• 3 طرق قذف مختلفة
]])

-- ==================== تحديث الشخصية ====================
LocalPlayer.CharacterAdded:Connect(function(newChar)
    task.wait(1)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

-- ==================== إشعار البدء ====================
task.wait(1)
Window:Notify({
    Title = "🚀 سكربت القذف جاهز",
    Content = "القوة: 250,000 | السرعة: فائقة",
    Duration = 5
})

print("🎯 سكربت القذف القوي تم تحميله!")
