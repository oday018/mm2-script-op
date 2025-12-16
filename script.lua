-- UI
local ui = Instance.new("ScreenGui", game.CoreGui)
local btn = Instance.new("TextButton", ui)

btn.Size = UDim2.new(0, 120, 0, 40)
btn.Position = UDim2.new(0, 20, 0, 100)
btn.Text = "FlyFarm: OFF"
btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.TextSize = 20
btn.Draggable = true
btn.Active = true

-- Global toggle
getgenv().FlyFarm = false

------------------------------------------------
-- إعدادات
------------------------------------------------
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local FLY_HEIGHT = 10      -- ارتفاع الطيران فوق الأرض
local SPEED = 0.2          -- سرعة الطيران (0.1 - 1)

------------------------------------------------
-- أقرب عملة
------------------------------------------------
local function getClosestCoin()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart
    local closestCoin
    local shortest = math.huge

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
-- الطيران نحو العملات
------------------------------------------------
local function flyFarm()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart

    while getgenv().FlyFarm do
        local coin = getClosestCoin()
        if coin and coin.Parent then
            local targetPos = Vector3.new(coin.Position.X, coin.Position.Y + FLY_HEIGHT, coin.Position.Z)
            -- حركة سلسة جدًا نحو العملة في الجو
            root.CFrame = root.CFrame:Lerp(CFrame.new(targetPos), SPEED)
        else
            task.wait(0.01)
        end
        task.wait()
    end
end

------------------------------------------------
-- زر التشغيل
------------------------------------------------
btn.MouseButton1Click:Connect(function()
    getgenv().FlyFarm = not getgenv().FlyFarm
    btn.Text = getgenv().FlyFarm and "FlyFarm: ON" or "FlyFarm: OFF"

    if getgenv().FlyFarm then
        task.spawn(flyFarm)
    end
end)
