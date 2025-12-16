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

------------------------------------------------
-- إعدادات
------------------------------------------------
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RANGE = 1000   -- مدى البحث كبير لتقريب العملات بسرعة
local SPEED = 1      -- سرعة Lerp (1 = مباشر تقريبًا)

------------------------------------------------
-- أقرب عملة
------------------------------------------------
local function getClosestCoin()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart
    local closestCoin
    local shortest = RANGE

    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("coin") and v.Parent then
            local dist = (v.Position - root.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closestCoin = v
            end
        end
    end
    return closestCoin
end

------------------------------------------------
-- التحرك بسلاسة شديدة
------------------------------------------------
local function goToCoinSmooth(coin)
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart

    while getgenv().FarmCoins do
        local coin = getClosestCoin()
        if coin and coin.Parent then
            -- تحرك بسلاسة لكن سريع جدًا نحو العملة
            local targetPos = Vector3.new(coin.Position.X, coin.Position.Y, coin.Position.Z)
            root.CFrame = root.CFrame:Lerp(CFrame.new(targetPos), SPEED)
        else
            task.wait(0.01) -- قليل جدًا للتحديث
        end
        task.wait()
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
            goToCoinSmooth()
        end)
    end
end)
