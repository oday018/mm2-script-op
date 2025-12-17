-- مكتبة الواجهة
local function CreateFarmUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FlyFarmUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- الإطار الرئيسي
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 250, 0, 140)
    MainFrame.Position = UDim2.new(0.5, -125, 0.3, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(70, 70, 100)
    UIStroke.Thickness = 2
    UIStroke.Parent = MainFrame
    
    -- شريط العنوان
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = TitleBar
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -10, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "💰 Fly Coin Farm"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    -- زر التفعيل
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.85, 0, 0, 45)
    ToggleButton.Position = UDim2.new(0.075, 0, 0.35, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    ToggleButton.Text = "⏸️ START FARMING"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 16
    ToggleButton.Font = Enum.Font.GothamSemibold
    ToggleButton.Parent = MainFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = ToggleButton
    
    -- مؤشر الحالة
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.85, 0, 0, 25)
    StatusLabel.Position = UDim2.new(0.075, 0, 0.8, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Status: OFF"
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.TextSize = 14
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = MainFrame
    
    -- جعل النافذة قابلة للسحب
    local dragging = false
    local dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- تأثيرات الزر
    ToggleButton.MouseEnter:Connect(function()
        ToggleButton.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    end)
    
    ToggleButton.MouseLeave:Connect(function()
        if ToggleButton.Text == "▶️ STOP FARMING" then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        end
    end)
    
    return ToggleButton, StatusLabel
end

-- ============================================
-- كود المزرعة الحقيقي
-- ============================================

-- إنشاء الواجهة
local ToggleButton, StatusLabel = CreateFarmUI()

-- إعدادات اللاعب
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- إعدادات الطيران
local FLIGHT_SPEED = 25 -- سرعة الطيران (تعدل كما تريد)
local SEARCH_RANGE = 300 -- مدى البحث
local Y_OFFSET = 2 -- ارتفاع فوق العملة
local COLLECT_DISTANCE = 6 -- مسافة التجميع

-- حالة المزرعة
local FarmEnabled = false
local flightConnection

-- تنظيف الطيران
local function CleanupFlight()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local root = lp.Character.HumanoidRootPart
        
        -- إزالة BodyVelocity
        local bv = root:FindFirstChild("FlyVelocity")
        if bv then
            bv:Destroy()
        end
        
        -- إعادة التحكم للاعب
        local humanoid = lp.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

-- البحث عن العملات بطرق متعددة
local function FindNearestCoin()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local root = lp.Character.HumanoidRootPart
    local closestCoin = nil
    local closestDistance = SEARCH_RANGE
    
    -- طريقة 1: البحث عن أي جزء باسم coin
    for _, item in ipairs(workspace:GetDescendants()) do
        if item:IsA("BasePart") or item:IsA("MeshPart") then
            local nameLower = item.Name:lower()
            
            -- كلمات مفتاحية للبحث
            if nameLower:find("coin") or 
               nameLower:find("cash") or 
               nameLower:find("money") or
               nameLower:find("reward") or
               nameLower:find("dollar") or
               nameLower:find("gem") or
               (item.BrickColor == BrickColor.new("Bright yellow") and item.Name == "Part") then
                
                local distance = (item.Position - root.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestCoin = item
                end
            end
        end
    end
    
    -- طريقة 2: إذا لم نجد، نبحث في الفولدرات الخاصة
    if not closestCoin then
        local coinFolders = {
            workspace:FindFirstChild("Coins"),
            workspace:FindFirstChild("Money"),
            workspace:FindFirstChild("Cash"),
            workspace:FindFirstChild("Rewards"),
            workspace:FindFirstChild("Collectables")
        }
        
        for _, folder in ipairs(coinFolders) do
            if folder and folder:IsA("Folder") then
                for _, coin in ipairs(folder:GetChildren()) do
                    if coin:IsA("BasePart") then
                        local distance = (coin.Position - root.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestCoin = coin
                        end
                    end
                end
            end
        end
    end
    
    return closestCoin
end

-- نظام الطيران السلس
local function FlyToCoin(coin)
    if not coin or not coin.Parent then
        return false
    end
    
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local root = lp.Character.HumanoidRootPart
    local humanoid = lp.Character:FindFirstChild("Humanoid")
    
    -- تفعيل وضع الطيران
    if humanoid then
        humanoid.PlatformStand = true
    end
    
    -- حساب الهدف مع ارتفاع إضافي
    local targetPos = coin.Position + Vector3.new(0, Y_OFFSET, 0)
    local direction = (targetPos - root.Position)
    local distance = direction.Magnitude
    
    -- إذا وصلنا للعملة
    if distance < COLLECT_DISTANCE then
        return true
    end
    
    -- تطبيع الاتجاه
    if distance > 0 then
        direction = direction / distance
    end
    
    -- سرعة الطيران
    local velocity = direction * FLIGHT_SPEED
    
    -- BodyVelocity للحركة السلسة
    local bv = root:FindFirstChild("FlyVelocity") or Instance.new("BodyVelocity")
    bv.Name = "FlyVelocity"
    bv.Velocity = velocity
    bv.MaxForce = Vector3.new(10000, 10000, 10000)
    bv.P = 1250
    bv.Parent = root
    
    -- إزالة القوة القديمة بعد وقت قصير
    task.spawn(function()
        task.wait(0.1)
        if bv and bv.Parent then
            bv.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    return false
end

-- زر التفعيل
ToggleButton.MouseButton1Click:Connect(function()
    FarmEnabled = not FarmEnabled
    
    if FarmEnabled then
        -- تشغيل المزرعة
        ToggleButton.Text = "▶️ STOP FARMING"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
        StatusLabel.Text = "Status: FLYING..."
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- إيقاف الاتصال السابق
        if flightConnection then
            flightConnection:Disconnect()
        end
        
        -- بدء نظام الطيران
        flightConnection = RunService.Heartbeat:Connect(function()
            if not FarmEnabled then
                CleanupFlight()
                return
            end
            
            if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
                StatusLabel.Text = "Status: NO CHARACTER"
                return
            end
            
            -- البحث عن عملة
            local coin = FindNearestCoin()
            
            if coin then
                -- تحديث الحالة
                local distance = (coin.Position - lp.Character.HumanoidRootPart.Position).Magnitude
                StatusLabel.Text = string.format("Status: FLYING (%d studs)", math.floor(distance))
                
                -- الطيران نحو العملة
                local reached = FlyToCoin(coin)
                
                if reached then
                    StatusLabel.Text = "Status: COIN COLLECTED!"
                    task.wait(0.1) -- انتظر قليلاً قبل البحث عن التالية
                end
            else
                StatusLabel.Text = "Status: NO COINS FOUND"
                CleanupFlight()
            end
        end)
        
        print("🚀 Fly Farm Started | Speed:", FLIGHT_SPEED)
        
    else
        -- إيقاف المزرعة
        ToggleButton.Text = "⏸️ START FARMING"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        StatusLabel.Text = "Status: OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        if flightConnection then
            flightConnection:Disconnect()
            flightConnection = nil
        end
        
        CleanupFlight()
        print("⏹️ Fly Farm Stopped")
    end
end)

-- تنبيه عند التحميل
print("=======================================")
print("💰 FLY COIN FARM LOADED SUCCESSFULLY!")
print("🎮 Click the button to start flying!")
print("✈️ Flight Speed:", FLIGHT_SPEED)
print("=======================================")
