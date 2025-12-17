-- UI
local ui = Instance.new("ScreenGui", game.CoreGui)
local btn = Instance.new("TextButton", ui)

btn.Size = UDim2.new(0, 120, 0, 40)
btn.Position = UDim2.new(0, 20, 0, 100)
btn.Text = "Farm: OFF"
btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.TextSize = 20
btn.Draggable = true
btn.Active = true

-- Global toggle
getgenv().FarmCoins = false

btn.MouseButton1Click:Connect(function()
    FarmCoins = not FarmCoins
    btn.Text = FarmCoins and "Farm: ON" or "Farm: OFF"
end)

------------------------------------------------
-- إعدادات
------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local RANGE = 200
local FLIGHT_SPEED = 80 -- سرعة الطيران
local ROTATION_SPEED = 10 -- سرعة الدوران
local Y_OFFSET = -3
local COLLECT_DISTANCE = 5 -- مسافة التجميع

------------------------------------------------
-- أقرب عملة مع تخزين مؤقت للأهداف
------------------------------------------------
local currentTarget = nil
local lastCoinCheck = 0
local COIN_CHECK_INTERVAL = 0.3 -- فحص العملات كل 0.3 ثانية (ليس كل إطار)

local function getClosestCoin()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local root = lp.Character.HumanoidRootPart
    local closestCoin
    local shortest = RANGE

    -- فقط إذا انتهى الوقت بين الفحوصات
    if tick() - lastCoinCheck < COIN_CHECK_INTERVAL and currentTarget and currentTarget.Parent then
        return currentTarget
    end
    
    lastCoinCheck = tick()
    
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("coin") and v.Parent then
            local dist = (v.Position - root.Position).Magnitude
            if dist <= shortest then
                shortest = dist
                closestCoin = v
            end
        end
    end
    
    currentTarget = closestCoin
    return closestCoin
end

------------------------------------------------
-- حركة طيران سلسة نحو الهدف
------------------------------------------------
local function flyToCoin(coin)
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    if not coin or not coin.Parent then return end
    
    local root = lp.Character.HumanoidRootPart
    local humanoid = lp.Character:FindFirstChild("Humanoid")
    
    -- تفعيل الطيران إذا كان هناك Humanoid
    if humanoid then
        humanoid.PlatformStand = true
    end
    
    -- حساب الاتجاه
    local targetPos = coin.Position + Vector3.new(0, Y_OFFSET, 0)
    local direction = (targetPos - root.Position)
    local distance = direction.Magnitude
    
    -- إذا كانت العملة قريبة بما يكفي، اجمعها
    if distance <= COLLECT_DISTANCE then
        currentTarget = nil -- أزل الهدف الحالي لتجنب التعلق به
        return true -- تم الوصول
    end
    
    -- تطبيع الاتجاه والحفاظ على السرعة
    direction = direction.Unit
    
    -- تطبيق الحركة (تأثير طيران)
    local velocity = direction * FLIGHT_SPEED
    
    -- تطبيق الحركة على الـ BodyVelocity لحركة سلسة
    local bv = root:FindFirstChild("FlightVelocity") or Instance.new("BodyVelocity")
    bv.Name = "FlightVelocity"
    bv.P = 10000
    bv.MaxForce = Vector3.new(10000, 10000, 10000)
    bv.Velocity = velocity
    bv.Parent = root
    
    -- تدوير الشخصية نحو الهدف (اختياري)
    local lookAt = CFrame.new(root.Position, targetPos)
    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, lookAt.lookVector.Y * 0.1, 0) * CFrame.Angles(math.rad(-10), 0, 0)
    
    return false -- لم نصل بعد
end

------------------------------------------------
-- تنظيف قوى الحركة عند إيقاف الفارم
------------------------------------------------
local function cleanupFlight()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local root = lp.Character.HumanoidRootPart
        local humanoid = lp.Character:FindFirstChild("Humanoid")
        
        if humanoid then
            humanoid.PlatformStand = false
        end
        
        -- إزالة BodyVelocity
        local bv = root:FindFirstChild("FlightVelocity")
        if bv then
            bv:Destroy()
        end
        
        -- إزالة Gyro إن وجد
        local gyro = root:FindFirstChild("FlightGyro")
        if gyro then
            gyro:Destroy()
        end
    end
end

------------------------------------------------
-- Farm Loop باستخدام RenderStepped لحركة سلسة
------------------------------------------------
local connection
local function startFarming()
    if connection then connection:Disconnect() end
    
    connection = RunService.RenderStepped:Connect(function(deltaTime)
        if not FarmCoins then 
            cleanupFlight()
            return 
        end
        
        if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then 
            cleanupFlight()
            return 
        end
        
        -- الحصول على أقرب عملة
        local coin = getClosestCoin()
        
        if coin then
            local reached = flyToCoin(coin)
            if reached then
                -- العملة تم جمعها، ابحث عن التالية مباشرة
                currentTarget = nil
                lastCoinCheck = 0 -- أجبر فحص جديد
            end
        else
            -- لا توجد عملات، تنظيف
            cleanupFlight()
        end
    end)
end

-- إعادة بدء الفارم عند تغيير الحالة
btn.MouseButton1Click:Connect(function()
    FarmCoins = not FarmCoins
    btn.Text = FarmCoins and "Farm: ON" or "Farm: OFF"
    
    if FarmCoins then
        startFarming()
    else
        if connection then 
            connection:Disconnect() 
            connection = nil
        end
        cleanupFlight()
    end
end)

-- تنظيف عند مغادرة اللعبة
game.Players.PlayerRemoving:Connect(function(player)
    if player == lp then
        if connection then 
            connection:Disconnect() 
        end
        cleanupFlight()
    end
end)

print("Coin Fly Farm loaded! Click button to start.")
