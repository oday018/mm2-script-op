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
local lp = Players.LocalPlayer
local RANGE = 200        -- مدى البحث
local SPEED = 0.3        -- سرعة الحركة (0.1-1 سلسة جداً)
local Y_OFFSET = -3      -- ارتفاع ثابت

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
-- Farm Loop (سلس جدًا)
------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.03)
        if FarmCoins and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local root = lp.Character.HumanoidRootPart
            local coin = getClosestCoin()
            if coin then
                -- استخدام Lerp للحركة السلسة
                local targetPos = coin.Position + Vector3.new(0, Y_OFFSET, 0)
                root.CFrame = root.CFrame:Lerp(CFrame.new(targetPos), SPEED)
            end
        end
    end
end)
