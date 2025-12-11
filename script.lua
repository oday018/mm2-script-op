-- ==================== تحميل المكتبة ====================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- ==================== إنشاء النافذة ====================
local Window = Library:MakeWindow({
    Title = "🎯 سكربت القذف الذكي",
    SubTitle = "يعمل مع المتحركين والثابتين",
    ScriptFolder = "Smart-Fling-Script"
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
    
    if not success then return {} end
    return data or {}
end

-- ==================== دالة تعقب الهدف المتحرك ====================
local function TrackMovingTarget(targetPart)
    if not targetPart then return targetPart end
    
    -- حساب سرعة الهدف
    local targetVelocity = targetPart.Velocity
    local speed = targetVelocity.Magnitude
    
    -- إذا كان يتحرك بسرعة، نتنبأ بموقعه
    if speed > 30 then
        -- توقع الموقع بعد 0.15 ثانية
        local predictedPosition = targetPart.Position + (targetVelocity * 0.15)
        
        -- إعادة حساب CFrame مع الاتجاه
        local lookVector = targetPart.CFrame.LookVector
        return CFrame.new(predictedPosition, predictedPosition + lookVector) * targetPart.CFrame.Rotation
    end
    
    return targetPart.CFrame
end

-- ==================== دالة القذف الذكي ====================
local function SmartFling(TargetPlayer)
    if not TargetPlayer or not Character or not HumanoidRootPart then 
        return false 
    end
    
    local TCharacter = TargetPlayer.Character
    if not TCharacter then return false end
    
    local TRootPart = TCharacter:FindFirstChild("HumanoidRootPart")
    if not TRootPart then return false end
    
    -- حفظ موقعنا الأصلي
    local OldPos = HumanoidRootPart.CFrame
    local OldVel = HumanoidRootPart.Velocity
    local OldRot = HumanoidRootPart.RotVelocity
    
    -- 🔥 الطريقة الجديدة: القبض والقذف الفوري
    local function CaptureAndFling()
        -- 1. تعقب الهدف المتحرك
        local targetCF = TrackMovingTarget(TRootPart)
        
        -- 2. الانتقال للموقع المتوقع
        local grabPosition = targetCF.Position + Vector3.new(0, 1.5, -1.5)
        HumanoidRootPart.CFrame = CFrame.new(grabPosition, targetCF.Position)
        
        -- 3. الانتظار القصير للتأكد من القبض
        task.wait(0.08)
        
        -- 4. قذف قوي مع تعويض السرعة
        local targetVelocity = TRootPart.Velocity
        local flingForce = Vector3.new(
            math.random(-100000, 100000) + (targetVelocity.X * 3),
            150000 + math.abs(targetVelocity.Y * 5),  -- تعويض الحركة الرأسية
            math.random(-100000, 100000) + (targetVelocity.Z * 3)
        )
        
        TRootPart.Velocity = flingForce
        
        -- 5. دوران سريع
        TRootPart.RotVelocity = Vector3.new(
            math.random(-12000, 12000),
            math.random(-12000, 12000),
            math.random(-12000, 12000)
        )
        
        -- 6. دفعات إضافية
        for i = 1, 2 do
            task.wait(0.05)
            if TRootPart and TRootPart.Parent then
                TRootPart.Velocity = TRootPart.Velocity + Vector3.new(
                    math.random(-30000, 30000),
                    40000,
                    math.random(-30000, 30000)
                )
            end
        end
    end
    
    -- 🔄 تنفيذ مع معالجة الأخطاء
    local success, err = pcall(CaptureAndFling)
    
    -- العودة السريعة لموقعنا
    task.wait(0.15)
    HumanoidRootPart.CFrame = OldPos
    HumanoidRootPart.Velocity = OldVel
    HumanoidRootPart.RotVelocity = OldRot
    
    -- تنظيف نهائي
    task.wait(0.1)
    HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
    
    return success
end

-- ==================== إنشاء التبويب ====================
local FlingTab = Window:MakeTab({
    Title = "🎯 القذف الذكي",
    Icon = "rbxassetid://4483345998"
})

-- ==================== تبويب القذف ====================
FlingTab:AddSection("🎯 قذف الأدوار")

FlingTab:AddButton({
    Name = "قذف القاتل (ذكي)",
    Callback = function()
        local roles = GetRoles()
        local flingSuccess = false
        
        for playerName, playerData in pairs(roles) do
            if playerData.Role == "Murderer" then
                local murderer = Players:FindFirstChild(playerName)
                if murderer and murderer ~= LocalPlayer then
                    flingSuccess = SmartFling(murderer)
                    
                    Window:Notify({
                        Title = flingSuccess and "💀 تم!" or "❌ مشكلة",
                        Content = flingSuccess and "تم قذف القاتل: " .. murderer.Name or "لم يتمكن من مسك القاتل",
                        Duration = 3
                    })
                    break
                end
            end
        end
        
        if not flingSuccess then
            Window:Notify({
                Title = "⚠️ لم يتم العثور",
                Content = "لا يوجد قاتل في اللعبة",
                Duration = 3
            })
        end
    end
})

FlingTab:AddButton({
    Name = "قذف الشريف/البطل (ذكي)",
    Callback = function()
        local roles = GetRoles()
        local flingSuccess = false
        
        for playerName, playerData in pairs(roles) do
            if playerData.Role == "Sheriff" or playerData.Role == "Hero" then
                local target = Players:FindFirstChild(playerName)
                if target and target ~= LocalPlayer then
                    flingSuccess = SmartFling(target)
                    
                    Window:Notify({
                        Title = flingSuccess and "👮 تم!" or "❌ فشل",
                        Content = flingSuccess and "تم قذف: " .. target.Name or "فشل القذف",
                        Duration = 3
                    })
                    break
                end
            end
        end
        
        if not flingSuccess then
            Window:Notify({
                Title = "⚠️ لم يتم العثور",
                Content = "لا يوجد شريف أو بطل",
                Duration = 3
            })
        end
    end
})

FlingTab:AddSection("🔥 قذف الجميع")

local FlingAllEnabled = false
local FlingAllLoop = nil

FlingTab:AddToggle({
    Name = "قذف جميع اللاعبين (ذكي)",
    Default = false,
    Callback = function(Value)
        FlingAllEnabled = Value
        
        if Value then
            FlingAllLoop = task.spawn(function()
                while FlingAllEnabled do
                    local flingCount = 0
                    
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            local success = SmartFling(player)
                            if success then
                                flingCount = flingCount + 1
                            end
                            task.wait(0.25)  -- وقت بين القذف
                        end
                    end
                    
                    if flingCount > 0 then
                        Window:Notify({
                            Title = "💥 تم قذف " .. flingCount .. " لاعب",
                            Content = "جاري تكرار القذف...",
                            Duration = 2
                        })
                    end
                    
                    task.wait(1.5)  -- انتظار قبل التكرار
                end
            end)
            
            Window:Notify({
                Title = "🔥 تم التفعيل",
                Content = "جاري قذف جميع اللاعبين",
                Duration = 3
            })
        else
            if FlingAllLoop then
                FlingAllLoop:Cancel()
                FlingAllLoop = nil
            end
            
            Window:Notify({
                Title = "🛑 تم الإيقاف",
                Content = "توقف القذف الجماعي",
                Duration = 3
            })
        end
    end
})

FlingTab:AddSection("🎯 قذف محدد")

local PlayerDropdown = FlingTab:AddDropdown({
    Name = "اختر لاعب",
    Default = "",
    Options = {},
    Callback = function(Value)
        -- تخزين اللاعب المحدد
        _G.SelectedPlayer = Value
    end
})

-- تحديث قائمة اللاعبين
local function UpdatePlayerList()
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    PlayerDropdown:NewOptions(playerNames)
end

UpdatePlayerList()
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

FlingTab:AddButton({
    Name = "قذف اللاعب المحدد",
    Callback = function()
        if _G.SelectedPlayer then
            local player = Players:FindFirstChild(_G.SelectedPlayer)
            if player and player ~= LocalPlayer then
                local success = SmartFling(player)
                
                Window:Notify({
                    Title = success and "🎯 تم القذف" or "❌ فشل",
                    Content = success and "تم قذف: " .. player.Name or "لم يتمكن من مسك اللاعب",
                    Duration = 3
                })
            else
                Window:Notify({
                    Title = "⚠️ لاعب غير موجود",
                    Content = "اللاعب غير متوفر حالياً",
                    Duration = 3
                })
            end
        else
            Window:Notify({
                Title = "⚠️ لم تختر لاعب",
                Content = "اختر لاعباً من القائمة أولاً",
                Duration = 3
            })
        end
    end
})

FlingTab:AddSection("⚡ أدوات إضافية")

FlingTab:AddButton({
    Name = "🔄 تحديث الشخصية",
    Callback = function()
        Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
        HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        Window:Notify({
            Title = "✅ تم التحديث",
            Content = "تم تحديث بيانات الشخصية",
            Duration = 3
        })
    end
})

FlingTab:AddButton({
    Name = "🎯 اختبار القذف",
    Callback = function()
        -- اختبار على أول لاعب متاح
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local success = SmartFling(player)
                
                Window:Notify({
                    Title = success and "✅ اختبار ناجح" or "❌ اختبار فاشل",
                    Content = success and "تم قذف " .. player.Name .. " بنجاح" or "فشل اختبار القذف",
                    Duration = 4
                })
                return
            end
        end
        
        Window:Notify({
            Title = "⚠️ لا يوجد لاعبين",
            Content = "لا يوجد لاعبين آخرين للاختبار",
            Duration = 3
        })
    end
})

FlingTab:AddParagraph("ℹ️ معلومات", [[
🎯 القذف الذكي:
• يتعقب اللاعبين المتحركين
• يتنبأ بحركتهم
• يعود لموقعك فوراً
• لا يطيرك ولا يعلقك
• يعمل مع الجميع
]])

-- ==================== تحديث الشخصية تلقائياً ====================
LocalPlayer.CharacterAdded:Connect(function(newChar)
    task.wait(0.5)
    Character = newChar
    Humanoid = Character:FindFirstChildOfClass("Humanoid")
    HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    
    Window:Notify({
        Title = "🔄 تم تحديث الشخصية",
        Content = "جاهز للقذف مرة أخرى",
        Duration = 3
    })
end)

-- ==================== إشعار البدء ====================
task.wait(1)
Window:Notify({
    Title = "🚀 القذف الذكي جاهز",
    Content = "يعمل مع المتحركين والثابتين",
    Duration = 5
})

print("🎯 سكربت القذف الذكي تم تحميله بنجاح!")
