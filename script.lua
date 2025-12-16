-- UI
local ui = Instance.new("ScreenGui", game.CoreGui)  -- إنشاء واجهة جديدة
local btn = Instance.new("TextButton", ui)          -- إنشاء زر على الواجهة

-- إعدادات الزر
btn.Size = UDim2.new(0, 120, 0, 40)
btn.Position = UDim2.new(0, 20, 0, 100)
btn.Text = "Farm: OFF"
btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.TextSize = 20
btn.Draggable = true
btn.Active = true

-- Global toggle
getgenv().FarmCoins = false  -- حالة تشغيل/إيقاف الجمع

------------------------------------------------
-- إعدادات عامة
------------------------------------------------
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RANGE = 400        -- مدى البحث عن العملات
local SPEED = 50         -- سرعة الحركة

------------------------------------------------
-- دالة إيجاد أقرب عملة
------------------------------------------------
local function getClosestCoin()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart
    local closestCoin
    local shortest = RANGE

    -- البحث في كل أجزاء الـ Workspace
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("coin") then
            local dist = (v.Position - root.Position).Magnitude
            if dist <= shortest then
                shortest = dist
                closestCoin = v
            end
        end
    end
    return closestCoin
end

------------------------------------------------
-- دالة الحركة خطوة بخطوة للأمام
------------------------------------------------
local function goToCoinSmooth(coin)
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart

    -- حلقة مستمرة حتى نصل للعملة أو تختفي أو يتوقف الجمع
    while coin and coin.Parent and getgenv().FarmCoins do
        -- تحديث موقع الهدف لكل خطوة
        local targetPos = Vector3.new(coin.Position.X, root.Position.Y, coin.Position.Z)
        local direction = (targetPos - root.Position)
        local distance = direction.Magnitude

        if distance < 1 then break end -- وصلنا تقريباً للعملة

        -- خطوة صغيرة باتجاه العملة
        local step = direction.Unit * math.min(distance, SPEED * task.wait())
        root.CFrame = root.CFrame + step

        -- تحقق إذا العملة لا تزال موجودة
        if not coin or not coin.Parent then break end
    end
end

------------------------------------------------
-- زر التشغيل
------------------------------------------------
btn.MouseButton1Click:Connect(function()
    getgenv().FarmCoins = not getgenv().FarmCoins
    btn.Text = getgenv().FarmCoins and "Farm: ON" or "Farm: OFF"

    if getgenv().FarmCoins then
        task.spawn(function()
            while getgenv().FarmCoins do
                local coin = getClosestCoin()
                if coin then
                    goToCoinSmooth(coin)
                else
                    task.wait(0.1)  -- لا توجد عملة، انتظر قليل قبل البحث مجدداً
                end
            end
        end)
    end
end)



