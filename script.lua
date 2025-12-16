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
local RANGE = 300        -- مدى البحث
local SPEED = 200         -- سرعة الحركة (كلما أكبر أسرع)

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
-- حركة سلسة بدون رفع الشخصية + التحقق من وجود العملة
------------------------------------------------
local function goToCoinSmooth(coin)
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart
    local startPos = root.Position
    local distance = (coin.Position - startPos).Magnitude
    local duration = (distance / SPEED) * 0.5  -- تقصير الوقت للنصف
    local t = 0

    while t < 1 and getgenv().FarmCoins do
        if not coin or not coin.Parent then break end  -- تأكد أن العملة موجودة
        t = t + task.wait() / duration
        if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then break end
        root.CFrame = CFrame.new(startPos:Lerp(Vector3.new(coin.Position.X, root.Position.Y, coin.Position.Z), t))
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
                    task.wait(0.1)
                end
            end
        end)
    end
end)

