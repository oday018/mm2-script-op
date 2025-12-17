-- Enhanced Smooth Teleport Coin Collector
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- UI
local ui = Instance.new("ScreenGui", game.CoreGui)
local btn = Instance.new("TextButton", ui)

btn.Size = UDim2.new(0, 120, 0, 40)
btn.Position = UDim2.new(0, 20, 0, 100)
btn.Text = "Farm: OFF"
btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
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
-- إعدادات مُحسّنة
------------------------------------------------
local RANGE = 200
local TELEPORT_DELAY = 0.08  -- أسرع قليلاً
local Y_OFFSET = 2           -- ارتفاع أفضل
local SMOOTHNESS = 0.3       -- عامل السلاسة
local MIN_DISTANCE = 3       -- الحد الأدنى للمسافة للانتقال

------------------------------------------------
-- NoClip Function
------------------------------------------------
local function enableNoClip()
    if Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
end

------------------------------------------------
-- البحث الدقيق عن العملات
------------------------------------------------
local function getClosestCoin()
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then 
        return nil 
    end
    
    local root = Player.Character.HumanoidRootPart
    local closestCoin = nil
    local shortestDistance = RANGE
    
    -- البحث في جميع الأماكن المحتملة
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            local objName = obj.Name:lower()
            
            -- تحقق من أسماء العملات الشائعة
            local isCoin = objName:find("coin") or 
                          objName:find("money") or 
                          objName:find("cash") or
                          objName:find("gold") or
                          objName:find("gem") or
                          objName:find("dollar") or
                          objName:find("token") or
                          objName:find("orb") or
                          obj:FindFirstChild("TouchInterest") ~= nil
            
            if isCoin and obj ~= root then
                local distance = (obj.Position - root.Position).Magnitude
                
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestCoin = obj
                end
            end
        end
    end
    
    return closestCoin, shortestDistance
end

------------------------------------------------
-- الانتقال السلس المُحسّن
------------------------------------------------
local function smoothTeleportTo(coin)
    if not Player.Character or not Player.Character.HumanoidRootPart or not coin then 
        return false 
    end
    
    local root = Player.Character.HumanoidRootPart
    local targetPosition = coin.Position + Vector3.new(0, Y_OFFSET, 0)
    local distance = (root.Position - targetPosition).Magnitude
    
    -- إذا كانت المسافة صغيرة جداً، لا حاجة للانتقال
    if distance < MIN_DISTANCE then
        return true
    end
    
    -- تفعيل NoClip
    enableNoClip()
    
    -- الانتقال السلس
    if distance > 50 then
        -- للمسافات البعيدة: انتقال مباشر
        root.CFrame = CFrame.new(targetPosition)
    else
        -- للمسافات القريبة: انتقال تدريجي سلس
        local steps = math.max(3, math.floor(distance / 10))
        
        for i = 1, steps do
            if not FarmCoins then break end
            
            local progress = i / steps
            local lerpPosition = root.Position:Lerp(targetPosition, progress)
            
            root.CFrame = CFrame.new(lerpPosition)
            task.wait(TELEPORT_DELAY / steps)
        end
    end
    
    -- تأكيد الوصول
    root.CFrame = CFrame.new(targetPosition)
    return true
end

------------------------------------------------
-- جمع العملة
------------------------------------------------
local function collectCoin(coin)
    if not coin or not Player.Character or not Player.Character.HumanoidRootPart then 
        return false 
    end
    
    local root = Player.Character.HumanoidRootPart
    
    -- محاولة الجمع بطرق مختلفة
    local success = false
    
    -- الطريقة 1: التلامس المباشر
    firetouchinterest(root, coin, 0)
    task.wait(0.05)
    firetouchinterest(root, coin, 1)
    
    -- الطريقة 2: ClickDetector إذا موجود
    local clickDetector = coin:FindFirstChildOfClass("ClickDetector")
    if clickDetector then
        fireclickdetector(clickDetector)
        success = true
    end
    
    -- الطريقة 3: ProximityPrompt إذا موجود
    local prompt = coin:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
        prompt:InputHoldBegin()
        task.wait(0.1)
        prompt:InputHoldEnd()
        success = true
    end
    
    return success
end

------------------------------------------------
-- اللوب الرئيسي المُحسّن
------------------------------------------------
local function farmLoop()
    local lastCoin = nil
    local consecutiveFails = 0
    
    while true do
        task.wait(TELEPORT_DELAY)
        
        if FarmCoins and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            -- تفعيل NoClip باستمرار
            enableNoClip()
            
            -- البحث عن أقرب عملة
            local coin, distance = getClosestCoin()
            
            if coin and coin ~= lastCoin then
                consecutiveFails = 0
                
                if distance > MIN_DISTANCE then
                    -- الانتقال للعملة
                    local teleported = smoothTeleportTo(coin)
                    
                    if teleported then
                        -- محاولة الجمع
                        local collected = collectCoin(coin)
                        
                        if collected then
                            print("✅ تم جمع العملة:", coin.Name)
                            lastCoin = coin
                        else
                            print("⚠️ لم يتم جمع العملة:", coin.Name)
                        end
                    end
                else
                    -- نحن قريبون بالفعل، حاول الجمع مباشرة
                    collectCoin(coin)
                end
            else
                consecutiveFails = consecutiveFails + 1
                
                -- إذا فشلنا في إيجاد عملة عدة مرات، نبحث في مدى أكبر
                if consecutiveFails > 5 then
                    print("🔍 جاري البحث عن عملات...")
                    task.wait(0.5)
                end
            end
        end
    end
end

------------------------------------------------
-- بدء النظام
------------------------------------------------
-- إيقاف NoClip عند التوقف
game:GetService("UserInputService").WindowFocusReleased:Connect(function()
    if FarmCoins then
        FarmCoins = false
        btn.Text = "Farm: OFF"
    end
end)

-- إعادة التعيين عند الموت
Player.CharacterAdded:Connect(function()
    if FarmCoins then
        task.wait(1)
        FarmCoins = true
    end
end)

-- بدء اللوب
task.spawn(farmLoop)

print("🎮 نظام جمع العملات جاهز!")
print("📌 اضغط على الزر لتفعيل/تعطيل")
