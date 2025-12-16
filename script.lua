-- Fixed Position Collector - يثبت ولا يتحرك إلا للعملات
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- إعدادات الثبات المطلق
local settings = {
    Enabled = false,
    BaseHeight = 5, -- ارتفاع ثابت عن الأرض
    CollectionRange = 100,
    ScanSpeed = 0.5, -- سرعة المسح (لا تؤثر على الحركة)
    InstantMode = true, -- الانتقال الفوري
    KeepPosition = true -- يبقى ثابتاً في مكانه
}

-- متغيرات النظام
local isCollecting = false
local currentPosition = nil
local ui = nil
local heartbeat = nil

-- إنشاء واجهة التحكم
local function createControlUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FixedCollectorUI"
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    
    local MainButton = Instance.new("TextButton")
    MainButton.Size = UDim2.new(0, 200, 0, 45)
    MainButton.Position = UDim2.new(0.5, -100, 0, 15)
    MainButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainButton.Text = "⭕ إيقاف المجمع"
    MainButton.Font = Enum.Font.GothamBold
    MainButton.TextSize = 16
    MainButton.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = MainButton
    
    return MainButton
end

-- تفعيل وضع التثبيت المطلق
local function enableAbsoluteFreeze()
    if not Character then return end
    
    -- حفظ الموقع الحالي
    currentPosition = RootPart.Position
    
    -- تعطيل كل أنواع الحركة
    RootPart.Anchored = false
    
    -- NoClip كامل
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Massless = true
        end
    end
    
    -- إزالة الجاذبية
    local antiGravity = Instance.new("BodyForce")
    antiGravity.Force = Vector3.new(0, workspace.Gravity * RootPart:GetMass() * 1.5, 0)
    antiGravity.Name = "AntiGravity"
    antiGravity.Parent = RootPart
    
    -- منع الحركة الدورانية
    local antiSpin = Instance.new("BodyAngularVelocity")
    antiSpin.MaxTorque = Vector3.new(0, 0, 0)
    antiSpin.Parent = RootPart
    
    -- منع الحركة الخطية
    local antiMove = Instance.new("BodyVelocity")
    antiMove.Velocity = Vector3.new(0, 0, 0)
    antiMove.MaxForce = Vector3.new(0, 0, 0)
    antiMove.Parent = RootPart
    
    print("❄️ تم تفعيل وضع التثبيت المطلق")
end

-- إيقاف التثبيت
local function disableFreeze()
    -- إعادة الخصائص الطبيعية
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
            part.Massless = false
        end
    end
    
    -- إزالة القوى
    for _, force in pairs(RootPart:GetChildren()) do
        if force:IsA("BodyForce") or force:IsA("BodyVelocity") or force:IsA("BodyAngularVelocity") then
            force:Destroy()
        end
    end
    
    RootPart.Velocity = Vector3.new(0, 0, 0)
    currentPosition = nil
    
    print("🔥 تم إيقاف وضع التثبيت")
end

-- البحث عن أقرب عملة
local function findNearestCoin()
    local closest = nil
    local minDistance = math.huge
    
    -- مسح شامل لكل الأشياء
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            local name = obj.Name:lower()
            
            -- قائمة الكلمات الدالة للعملات
            local isCoin = name:find("coin") or 
                          name:find("money") or 
                          name:find("dollar") or
                          name:find("gem") or
                          name:find("cash") or
                          name:find("gold") or
                          name:find("token") or
                          name:find("point") or
                          obj:FindFirstChild("CoinValue") ~= nil or
                          obj:FindFirstChild("Collect") ~= nil
            
            if isCoin then
                local distance = (RootPart.Position - obj.Position).Magnitude
                if distance < minDistance and distance > 1 then
                    minDistance = distance
                    closest = obj
                end
            end
        end
    end
    
    return closest, minDistance
end

-- الانتقال المباشر للعملة
local function goToCoin(coin)
    if not coin or not RootPart then return false end
    
    isCollecting = true
    
    -- حفظ الموقع قبل الانتقال
    local originalPosition = RootPart.Position
    
    -- الانتقال المباشر للعملة
    local targetPosition = coin.Position + Vector3.new(0, settings.BaseHeight, 0)
    
    if settings.InstantMode then
        -- الانتقال الفوري
        RootPart.CFrame = CFrame.new(targetPosition)
    else
        -- الانتقال السريع
        RootPart.CFrame = CFrame.new(targetPosition)
    end
    
    -- جمع العملة
    task.wait(0.1)
    
    -- محاولة الجمع بطرق متعددة
    local success = false
    
    -- الطريقة 1: التلامس
    firetouchinterest(RootPart, coin, 0)
    task.wait(0.05)
    firetouchinterest(RootPart, coin, 1)
    
    -- الطريقة 2: إذا كان ClickDetector
    local clicker = coin:FindFirstChildOfClass("ClickDetector")
    if clicker then
        fireclickdetector(clicker)
        success = true
    end
    
    -- العودة للموقع الأصلي (إذا كان مفعلاً)
    if settings.KeepPosition and originalPosition then
        task.wait(0.2)
        RootPart.CFrame = CFrame.new(originalPosition)
    end
    
    isCollecting = false
    return success
end

-- دورة الجمع الرئيسية
local function collectionCycle()
    while settings.Enabled do
        task.wait(settings.ScanSpeed)
        
        if not settings.Enabled or isCollecting then
            continue
        end
        
        -- البحث عن أقرب عملة
        local coin, distance = findNearestCoin()
        
        if coin and distance < settings.CollectionRange then
            print("🎯 عثرت على عملة:", coin.Name, "المسافة:", math.floor(distance))
            
            -- الانتقال لجمعها
            local collected = goToCoin(coin)
            
            if collected then
                print("✅ تم جمع العملة")
            end
        else
            -- إذا لم توجد عملة قريبة
            if currentPosition and settings.KeepPosition then
                -- العودة للموقع الثابت
                RootPart.CFrame = CFrame.new(currentPosition)
            end
        end
    end
end

-- تحديث التثبيت في الخلفية
local function setupFreezeLoop()
    if heartbeat then
        heartbeat:Disconnect()
    end
    
    heartbeat = RunService.Heartbeat:Connect(function()
        if not settings.Enabled then return end
        
        -- فرض التثبيت
        enableAbsoluteFreeze()
        
        -- الحفاظ على الموقع الثابت
        if currentPosition and settings.KeepPosition and not isCollecting then
            RootPart.CFrame = CFrame.new(currentPosition)
        end
        
        -- إلغاء أي حركة
        RootPart.Velocity = Vector3.new(0, 0, 0)
        RootPart.RotVelocity = Vector3.new(0, 0, 0)
        
        -- منع الحركة الطبيعية
        Humanoid.PlatformStand = true
    end)
end

-- التحكم الرئيسي
local function toggleSystem()
    settings.Enabled = not settings.Enabled
    
    if settings.Enabled then
        -- التشغيل
        ui.Text = "✅ تشغيل المجمع"
        ui.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        
        -- تفعيل التثبيت
        enableAbsoluteFreeze()
        
        -- بدء دورة التحديث
        setupFreezeLoop()
        
        -- بدء دورة الجمع
        task.spawn(collectionCycle)
        
        -- إشعار
        game.StarterGui:SetCore("SendNotification", {
            Title = "🚀 المجمع مفعل",
            Text = "النظام يبحث عن العملات...",
            Duration = 3
        })
        
        print("========================================")
        print("🎮 نظام جمع العملات المفعل")
        print("📍 الموقع الحالي:", RootPart.Position)
        print("🔍 نطاق البحث:", settings.CollectionRange)
        print("========================================")
        
    else
        -- الإيقاف
        ui.Text = "⭕ إيقاف المجمع"
        ui.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        
        -- إيقاف التثبيت
        disableFreeze()
        
        -- إيقاف التحديثات
        if heartbeat then
            heartbeat:Disconnect()
            heartbeat = nil
        end
        
        -- إعادة الحركة الطبيعية
        Humanoid.PlatformStand = false
        
        -- إشعار
        game.StarterGui:SetCore("SendNotification", {
            Title = "🛑 المجمع متوقف",
            Text = "تم إيقاف النظام",
            Duration = 3
        })
        
        print("🛑 تم إيقاف نظام الجمع")
    end
end

-- إعداد النظام
task.wait(2)
ui = createControlUI()
ui.MouseButton1Click:Connect(toggleSystem)

-- زر الطوارئ للإيقاف الفوري
local emergencyBtn = Instance.new("TextButton")
emergencyBtn.Size = UDim2.new(0, 50, 0, 50)
emergencyBtn.Position = UDim2.new(1, -60, 1, -60)
emergencyBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
emergencyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
emergencyBtn.Text = "🛑"
emergencyBtn.Font = Enum.Font.GothamBold
emergencyBtn.TextSize = 24
emergencyBtn.Visible = false
emergencyBtn.Parent = ui.Parent

emergencyBtn.MouseButton1Click:Connect(function()
    if settings.Enabled then
        toggleSystem()
    end
end)

-- تفعيل زر الطوارئ عند التشغيل
ui.MouseButton1Click:Connect(function()
    emergencyBtn.Visible = settings.Enabled
end)

-- تنظيف تلقائي
game:GetService("UserInputService").WindowFocusReleased:Connect(function()
    if settings.Enabled then
        toggleSystem()
    end
end)

Humanoid.Died:Connect(function()
    if settings.Enabled then
        toggleSystem()
    end
end)

Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    RootPart = newChar:WaitForChild("HumanoidRootPart")
    
    if settings.Enabled then
        task.wait(1)
        toggleSystem()
        task.wait(0.5)
        toggleSystem()
    end
end)

-- رسالة البدء
print([[

╔══════════════════════════════════════╗
║      🎯 نظام جمع العملات الثابت     ║
║      ──────────────────────────     ║
║  • يثبت في مكانه ولا يتحرك          ║
║  • يبحث عن أقرب عملة                ║
║  • ينتقل لها مباشرة                ║
║  • يجمعها ويعود                    ║
║  • يبحث عن التالية                  ║
║                                     ║
║  🔼 اضغط الزر في الأعلى للتحكم     ║
╚══════════════════════════════════════╝

]])
