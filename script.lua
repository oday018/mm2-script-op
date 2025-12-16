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
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer
local RANGE = 200         -- مدى البحث
local Y_OFFSET = 3        -- ارتفاع الطيران فوق الأرض
local TWEEN_SPEED = 0.2   -- سرعة الانتقال (قيمة أصغر = أسرع)

------------------------------------------------
-- أقرب عملة
------------------------------------------------
local function getClosestCoin()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart
    local closestCoin
    local shortest = RANGE

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
-- انتقال سلس
------------------------------------------------
local function flyToCoin(coin)
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart
    local targetCFrame = CFrame.new(coin.Position + Vector3.new(0, Y_OFFSET, 0))
    local tween = TweenService:Create(root, TweenInfo.new(TWEEN_SPEED, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

------------------------------------------------
-- Farm Loop
------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.05)
        if FarmCoins then
            local coin = getClosestCoin()
            if coin then
                flyToCoin(coin)
            end
        end
    end
end)
