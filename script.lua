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
local RANGE = 200        -- مدى البحث عن العملات

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
-- دالة الحركة باستخدام Humanoid:MoveTo()
------------------------------------------------
local function goToCoin(coin)
    if not lp.Character or not lp.Character:FindFirstChild("Humanoid") then return end
    local humanoid = lp.Character.Humanoid

    while coin and coin.Parent and getgenv().FarmCoins do
        humanoid:MoveTo(Vector3.new(coin.Position.X, lp.Character.HumanoidRootPart.Position.Y, coin.Position.Z))
        local reached = humanoid.MoveToFinished:Wait()  -- ينتظر حتى يصل أو يتوقف

        -- إذا اختفت العملة أثناء الحركة، يخرج
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
                    goToCoin(coin)
                else
                    task.wait(0.1)  -- لا توجد عملة، انتظر قليل قبل البحث مجدداً
                end
            end
        end)
    end
end)
