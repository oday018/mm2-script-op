-- Auto Coin Collector - حركة ثابتة وسلسة
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- انتظار تحميل الشخصية
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- إعدادات الحركة الثابتة
local settings = {
    Enabled = false,
    FlySpeed = 35, -- سرعة ثابتة معتدلة
    FlyHeight = 3, -- ارتفاع ثابت عن الأرض
    Smoothness = 0.2, -- عامل السلاسة (0.1 - 0.3)
    CollectionRange = 30,
    CheckDelay = 0.2,
    AutoAdjustHeight = true
}

-- متغيرات الحركة
local currentVelocity = Vector3.new(0, 0, 0)
local targetVelocity = Vector3.new(0, 0, 0)
local isMoving = false
local flyEnabled = false
local lastCoin = nil

-- واجهة تحكم نظيفة
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CoinCollectorUI"
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 250, 0, 60)
    MainFrame.Position = UDim2.new(0.5, -125, 0, 10)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.9, 0, 0.6, 0)
    ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    ToggleButton.TextColor3 = Color3.white
    ToggleButton.Text = "⏹ إيقاف المجمع"
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 14
    ToggleButton.Parent = MainFrame
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 6)
    UICorner2.Parent = ToggleButton
    
    return ToggleButton
end

-- تهيئة الواجهة
local ToggleButton = createUI()

-- نظام الطيران الثابت
local function setupFlight()
    if not RootPart then return end
    
    -- تعطيل الجاذبية والاحتكاك
    RootPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
    
    -- إزالة القوى السابقة
    for _, v in pairs(RootPart:GetChildren()) do
        if v:IsA("BodyForce") or v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
            v:Destroy()
        end
    end
    
    -- إضافة قوة الطيران
    local BodyForce = Instance.new("BodyForce")
    BodyForce.Force = Vector3.new(0, workspace.Gravity * RootPart:GetMass(), 0)
    BodyForce.Parent = RootPart
    
    -- NoClip بسيط
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    flyEnabled = true
    return BodyForce
end

-- إيقاف الطيران
local function stopFlight()
    if RootPart then
        RootPart.CustomPhysicalProperties = nil
        RootPart.Velocity = Vector3.new(0, 0, 0)
        
        for _, v in pairs(RootPart:GetChildren()) do
            if v:IsA("BodyForce") or v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                v:Destroy()
            end
        end
        
        -- إعادة الكوليجن
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    flyEnabled = false
    isMoving = false
    currentVelocity = Vector3.new(0, 0, 0)
    targetVelocity = Vector3.new(0, 0, 0)
end

-- البحث عن أقرب عملة بشكل دقيق
local function findNearestCoin()
    local nearestCoin = nil
    local shortestDistance = settings.CollectionRange
    
    -- البحث في الأماكن المحتملة للعملات
    local potentialFolders = {
        workspace:FindFirstChild("Coins"),
        workspace:FindFirstChild("Money"),
        workspace:FindFirstChild("Collectables"),
        workspace
    }
    
    for _, folder in pairs(potentialFolders) do
        if folder then
            for _, item in pairs(folder:GetChildren()) do
                -- البحث عن أي شيء يشبه عملة
                if item:IsA("BasePart") and (item.Name:find("Coin") or 
                   item.Name:find("Money") or 
                   item.Name:find("Dollar") or
                   item.Name:find("Gem") or
                   item:FindFirstChild("TouchInterest")) then
                    
                    local distance = (RootPart.Position - item.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearestCoin = item
                    end
                end
            end
        end
    end
    
    return nearestCoin, shortestDistance
end

-- حساب المسار السلس
local function calculateSmoothMovement(targetPosition)
    if not RootPart then return Vector3.new(0, 0, 0) end
    
    local currentPos = RootPart.Position
    local direction = (targetPosition - currentPos).Unit
    local distance = (targetPosition - currentPos).Magnitude
    
    -- سرعة ثابتة مع تعديل للاقتراب النهائي
    local speed = settings.FlySpeed
    if distance < 10 then
        speed = speed * (distance / 10) * 0.8
    end
    
    -- إضافة ارتفاع ثابت
    local verticalOffset = 0
    if settings.AutoAdjustHeight and distance > 5 then
        verticalOffset = settings.FlyHeight
    end
    
    -- اتجاه الحركة النهائي
    local moveVector = (direction * speed) + Vector3.new(0, verticalOffset, 0)
    
    return moveVector
end

-- الحركة السلسة باستخدام Lerp
local function smoothMove()
    if not RootPart or not isMoving then return end
    
    -- تطبيق السلاسة
    currentVelocity = currentVelocity:Lerp(targetVelocity, settings.Smoothness)
    
    -- تطبيق الحركة
    if currentVelocity.Magnitude > 0.1 then
        RootPart.Velocity = currentVelocity
    else
        RootPart.Velocity = Vector3.new(0, 0, 0)
    end
end

-- دورة الجمع الرئيسية
local function collectionLoop()
    while settings.Enabled do
        task.wait(settings.CheckDelay)
        
        if not Character or not RootPart or not flyEnabled then
            break
        end
        
        -- البحث عن عملة
        local coin, distance = findNearestCoin()
        
        if coin and distance < settings.CollectionRange then
            isMoving = true
            
            -- تجنب تكرار نفس العملة
            if lastCoin ~= coin then
                lastCoin = coin
                
                -- حساب السرعة المستهدفة
                targetVelocity = calculateSmoothMovement(coin.Position)
                
                -- جمع العملة عند الاقتراب
                if distance < 5 then
                    -- طريقة الجمع (تختلف حسب اللعبة)
                    firetouchinterest(RootPart, coin, 0)
                    task.wait(0.05)
                    firetouchinterest(RootPart, coin, 1)
                    
                    -- توقف مؤقت بعد الجمع
                    targetVelocity = Vector3.new(0, 0, 0)
                    task.wait(0.1)
                end
            end
        else
            -- لا توجد عملة في المدى
            isMoving = false
            targetVelocity = Vector3.new(0, 0, 0)
            lastCoin = nil
        end
    end
end

-- تحديث الحركة في كل إطار
local movementConnection
local function startMovementUpdate()
    if movementConnection then
        movementConnection:Disconnect()
    end
    
    movementConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if settings.Enabled and flyEnabled then
            smoothMove()
        end
    end)
end

-- التحكم
ToggleButton.MouseButton1Click:Connect(function()
    settings.Enabled = not settings.Enabled
    
    if settings.Enabled then
        -- التشغيل
        ToggleButton.Text = "▶ تشغيل المجمع"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 220, 60)
        
        -- تهيئة الطيران
        setupFlight()
        
        -- بدء التحديثات
        startMovementUpdate()
        
        -- بدء دورة الجمع
        task.spawn(collectionLoop)
        
        -- إشعار
        game.StarterGui:SetCore("SendNotification", {
            Title = "تفعيل المجمع",
            Text = "تم تشغيل جمع العملات بنجاح",
            Duration = 3
        })
    else
        -- الإيقاف
        ToggleButton.Text = "⏹ إيقاف المجمع"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
        
        -- إيقاف آمن
        stopFlight()
        
        if movementConnection then
            movementConnection:Disconnect()
        end
        
        -- إشعار
        game.StarterGui:SetCore("SendNotification", {
            Title = "إيقاف المجمع",
            Text = "تم إيقاف جمع العملات",
            Duration = 3
        })
    end
end)

-- تنظيف عند الخروج
game:GetService("UserInputService").WindowFocusReleased:Connect(function()
    if settings.Enabled then
        settings.Enabled = false
        stopFlight()
        
        if ToggleButton then
            ToggleButton.Text = "⏹ إيقاف المجمع"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
        end
    end
end)

-- إعادة التعيين عند إعادة الظهور
Character:WaitForChild("Humanoid").Died:Connect(function()
    if settings.Enabled then
        settings.Enabled = false
        stopFlight()
        
        if ToggleButton then
            ToggleButton.Text = "⏹ إيقاف المجمع"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
        end
    end
end)

-- رسالة التحميل
print("✅ نظام جمع العملات جاهز")
print("📌 اضغط على الزر في أعلى الشاشة للتحكم")
