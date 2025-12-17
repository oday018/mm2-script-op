-- ============================================
-- واجهة المستخدم البسيطة
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CoinFarmUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 100)
MainFrame.Position = UDim2.new(0, 20, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 70)
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.9, 0, 0.5, 0)
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Text = "⏸️ START FARM"
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 4)
ButtonCorner.Parent = ToggleButton

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0.3, 0)
StatusLabel.Position = UDim2.new(0.05, 0, 0.7, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: OFF"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

-- ============================================
-- إعدادات النظام
-- ============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- السرعة والمسافة
local TELEPORT_SPEED = 0.1 -- ثواني بين كل حركة (كلما قل الرقم زادت السرعة)
local SEARCH_RANGE = 1000 -- مدى البحث
local Y_OFFSET = 3 -- ارتفاع فوق العملة

-- الحالة
local FarmEnabled = false
local teleportConnection
local freezeConnection

-- ============================================
-- تجميد الشخصية بالكامل
-- ============================================
local function FreezeCharacter()
    if not lp.Character then return end
    
    -- تجميد الحركة
    local humanoid = lp.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.PlatformStand = true
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
    end
    
    -- إزالة جميع قوى الفيزياء
    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    if root then
        -- إزالة أي قوى حركة موجودة
        for _, force in ipairs(root:GetChildren()) do
            if force:IsA("BodyVelocity") or force:IsA("BodyForce") or 
               force:IsA("BodyAngularVelocity") or force:IsA("BodyThrust") then
                force:Destroy()
            end
        end
        
        -- جعل الشخصية ثابتة في مكانها
        local anchor = Instance.new("BodyPosition")
        anchor.Name = "FreezeAnchor"
        anchor.Position = root.Position
        anchor.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        anchor.P = 10000
        anchor.Parent = root
        
        -- منع الدوران
        local gyro = Instance.new("BodyGyro")
        gyro.Name = "FreezeGyro"
        gyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        gyro.P = 10000
        gyro.CFrame = root.CFrame
        gyro.Parent = root
    end
    
    -- إخفاء الرسوم المتحركة
    local animator = lp.Character:FindFirstChildOfClass("Animator")
    if animator then
        animator:Destroy()
    end
end

-- ============================================
-- إلغاء التجميد
-- ============================================
local function UnfreezeCharacter()
    if not lp.Character then return end
    
    local humanoid = lp.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end
    
    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    if root then
        local anchor = root:FindFirstChild("FreezeAnchor")
        if anchor then anchor:Destroy() end
        
        local gyro = root:FindFirstChild("FreezeGyro")
        if gyro then gyro:Destroy() end
    end
end

-- ============================================
-- البحث عن أقرب عملة
-- ============================================
local function FindNearestCoin()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local root = lp.Character.HumanoidRootPart
    local closestCoin = nil
    local closestDistance = SEARCH_RANGE
    
    -- البحث فقط عن الأجزاء المسماة "coin" (بالحروف الصغيرة أو الكبيرة)
    for _, item in ipairs(workspace:GetDescendants()) do
        if (item:IsA("BasePart") or item:IsA("MeshPart") or item:IsA("Part")) then
            if string.lower(item.Name) == "coin" then
                if item.Parent and item.Parent.Name ~= lp.Character.Name then
                    local distance = (item.Position - root.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestCoin = item
                    end
                end
            end
        end
    end
    
    return closestCoin, closestDistance
end

-- ============================================
-- الانتقال السلس مع تجاوز الجدران
-- ============================================
local function TeleportToCoin(coin)
    if not coin or not coin.Parent then return false end
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return false end
    
    local root = lp.Character.HumanoidRootPart
    local targetPos = coin.Position + Vector3.new(0, Y_OFFSET, 0)
    local distance = (targetPos - root.Position).Magnitude
    
    -- إذا كانت العملة قريبة جداً
    if distance < 5 then
        return true
    end
    
    -- الانتقال المباشر مع تجاوز الجدران
    local newCFrame = CFrame.new(targetPos)
    
    -- إزالة أي قوى قبل الانتقال
    for _, force in ipairs(root:GetChildren()) do
        if force:IsA("BodyVelocity") or force:IsA("BodyPosition") then
            force:Destroy()
        end
    end
    
    -- الانتقال
    root.CFrame = newCFrame
    
    -- تجميد الشخصية في المكان الجديد
    FreezeCharacter()
    
    return false
end

-- ============================================
-- نظام الفارم
-- ============================================
local function StartFarming()
    if teleportConnection then
        teleportConnection:Disconnect()
    end
    
    -- تجميد الشخصية أولاً
    FreezeCharacter()
    
    teleportConnection = RunService.Heartbeat:Connect(function()
        if not FarmEnabled then return end
        if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local coin, distance = FindNearestCoin()
        
        if coin then
            -- تحديث حالة الواجهة
            StatusLabel.Text = string.format("FARMING: %d studs", math.floor(distance))
            
            -- الانتقال للعملة
            local reached = TeleportToCoin(coin)
            
            if reached then
                StatusLabel.Text = "COIN COLLECTED"
                task.wait(0.2) -- انتظار بسيط قبل البحث عن التالية
            end
            
            -- انتظار للتحكم في السرعة
            task.wait(TELEPORT_SPEED)
        else
            StatusLabel.Text = "NO COINS FOUND"
        end
    end)
end

-- ============================================
-- زر التفعيل
-- ============================================
ToggleButton.MouseButton1Click:Connect(function()
    FarmEnabled = not FarmEnabled
    
    if FarmEnabled then
        -- تشغيل النظام
        ToggleButton.Text = "▶️ STOP FARM"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        StatusLabel.Text = "STARTING..."
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- تجميد الشخصية
        FreezeCharacter()
        
        -- بدء الفارم
        task.wait(0.5)
        StartFarming()
        
        print("✅ Coin Farm Started | Instant Teleport")
        
    else
        -- إيقاف النظام
        ToggleButton.Text = "⏸️ START FARM"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        StatusLabel.Text = "Status: OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        if teleportConnection then
            teleportConnection:Disconnect()
            teleportConnection = nil
        end
        
        -- إلغاء التجميد
        UnfreezeCharacter()
        
        print("❌ Coin Farm Stopped")
    end
end)

-- ============================================
-- الحفاظ على التجميد عند إعادة الظهور
-- ============================================
lp.CharacterAdded:Connect(function()
    if FarmEnabled then
        task.wait(1) -- انتظار تحميل الشخصية
        FreezeCharacter()
    end
end)

-- ============================================
-- معلومات عند التحميل
-- ============================================
print("=======================================")
print("🎮 INSTANT COIN FARM LOADED")
print("⚡ Instant teleport to nearest coin")
print("❄️ Character will be frozen")
print("🧱 Can pass through walls")
print("💰 Only collects parts named 'coin'")
print("=======================================")
