-- مكتبة بسيطة وجميلة
local function CreateWindow()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FlyFarmUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- الإطار الرئيسي
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 200, 0, 120)
    MainFrame.Position = UDim2.new(0.5, -100, 0.3, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    -- زوايا دائرية
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    -- ظل
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(60, 60, 80)
    UIStroke.Thickness = 2
    UIStroke.Parent = MainFrame
    
    -- شريط العنوان
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -10, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "💰 Coin Fly Farm"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
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
    
    -- زر التفعيل
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
    ToggleButton.Position = UDim2.new(0.1, 0, 0.4, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ToggleButton.Text = "⏸️ Start Farming"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 14
    ToggleButton.Font = Enum.Font.Gotham
    ToggleButton.Parent = MainFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = ToggleButton
    
    -- مؤشر الحالة
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.8, 0, 0, 20)
    StatusLabel.Position = UDim2.new(0.1, 0, 0.8, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Status: OFF"
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = MainFrame
    
    -- تأثيرات الزر
    ToggleButton.MouseEnter:Connect(function()
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    end)
    
    ToggleButton.MouseLeave:Connect(function()
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    end)
    
    return ToggleButton, StatusLabel
end

-- ============================================
-- كود المزرعة
-- ============================================

-- إنشاء الواجهة
local ToggleButton, StatusLabel = CreateWindow()

-- إعدادات المزرعة
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- إعدادات الطيران
local FLIGHT_SPEED = 20 -- السرعة المطلوبة
local SEARCH_RANGE = 300
local Y_OFFSET = -3
local COLLECT_DISTANCE = 5

-- حالة المزرعة
local FarmEnabled = false
local currentTarget = nil
local flightConnection

-- تنظيف الطيران
local function CleanupFlight()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local root = lp.Character.HumanoidRootPart
        
        -- إزالة BodyVelocity القديم
        local oldBV = root:FindFirstChild("FlyBV")
        if oldBV then
            oldBV:Destroy()
        end
        
        -- إعادة تحكم اللاعب
        local humanoid = lp.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

-- البحث عن أقرب عملة
local function FindNearestCoin()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local root = lp.Character.HumanoidRootPart
    local closestCoin = nil
    local closestDistance = SEARCH_RANGE
    
    -- البحث في workspace
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("BasePart") then
            if obj.Name:lower():find("coin") or 
               obj.Name:lower():find("part") or
               obj.Name:lower():find("money") then
                
                local distance = (obj.Position - root.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestCoin = obj
                end
            end
        end
        
        -- البحث في الموديلات
        for _, part in ipairs(obj:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Name:lower():find("coin") or 
                   part.Name:lower():find("part") or
                   part.Name:lower():find("money") then
                    
                    local distance = (part.Position - root.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestCoin = part
                    end
                end
            end
        end
    end
    
    return closestCoin
end

-- نظام الطيران السلس
local function FlyToTarget(coin)
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
    
    -- حساب الاتجاه
    local targetPosition = coin.Position + Vector3.new(0, Y_OFFSET, 0)
    local direction = (targetPosition - root.Position)
    local distance = direction.Magnitude
    
    -- إذا وصلنا للعملة
    if distance < COLLECT_DISTANCE then
        return true -- تم الوصول
    end
    
    -- تطبيع الاتجاه
    if distance > 0 then
        direction = direction / distance
    else
        direction = Vector3.new(0, 0, 0)
    end
    
    -- تطبيق سرعة الطيران
    local velocity = direction * FLIGHT_SPEED
    
    -- إزالة BodyVelocity القديم
    local oldBV = root:FindFirstChild("FlyBV")
    if oldBV then
        oldBV:Destroy()
    end
    
    -- إنشاء BodyVelocity جديد
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "FlyBV"
    bodyVelocity.Velocity = velocity
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.P = 1000
    bodyVelocity.Parent = root
    
    -- إزالة BodyVelocity بعد ثانية (للسلاسة)
    game:GetService("Debris"):AddItem(bodyVelocity, 0.1)
    
    return false -- لم نصل بعد
end

-- بدء/إيقاف المزرعة
ToggleButton.MouseButton1Click:Connect(function()
    FarmEnabled = not FarmEnabled
    
    if FarmEnabled then
        ToggleButton.Text = "▶️ Stop Farming"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
        StatusLabel.Text = "Status: ON - Flying to coins"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- بدء نظام الطيران
        if flightConnection then
            flightConnection:Disconnect()
        end
        
        flightConnection = RunService.Heartbeat:Connect(function()
            if not FarmEnabled then
                CleanupFlight()
                return
            end
            
            if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
                return
            end
            
            -- البحث عن عملة
            local coin = FindNearestCoin()
            
            if coin then
                -- الطيران نحو العملة
                local reached = FlyToTarget(coin)
                
                if reached then
                    -- العملة تم جمعها، ابحث عن التالية
                    currentTarget = nil
                else
                    currentTarget = coin
                end
            else
                CleanupFlight()
                StatusLabel.Text = "Status: ON - No coins found"
            end
        end)
        
        print("✅ Coin Fly Farm Started | Speed:", FLIGHT_SPEED)
        
    else
        ToggleButton.Text = "⏸️ Start Farming"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        StatusLabel.Text = "Status: OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        -- إيقاف النظام
        if flightConnection then
            flightConnection:Disconnect()
            flightConnection = nil
        end
        
        CleanupFlight()
        currentTarget = nil
        
        print("❌ Coin Fly Farm Stopped")
    end
end)

-- تنظيف عند مغادرة اللعبة
game.Players.PlayerRemoving:Connect(function(player)
    if player == lp then
        if flightConnection then
            flightConnection:Disconnect()
        end
        CleanupFlight()
    end
end)

print("🎮 Coin Fly Farm Loaded!")
print("📊 Flight Speed:", FLIGHT_SPEED)
print("📍 Click the button to start!")
