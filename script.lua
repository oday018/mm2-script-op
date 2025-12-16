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
local SPEED = 25         -- سرعة الطيران
local Y_OFFSET = -3      -- الزخم المطلوب

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
-- الانتقال السلس (BodyVelocity)
------------------------------------------------
local function flyTo(pos)
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9,1e9,1e9)
    bv.Parent = root

    while (pos - root.Position).Magnitude > 1 do
        if not getgenv().FarmCoins then break end
        local dir = (pos - root.Position).Unit
        bv.Velocity = dir * SPEED
        task.wait(0.03)
    end

    bv:Destroy()
end

------------------------------------------------
-- Farm Loop
------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.1)
        if getgenv().FarmCoins then
            local coin = getClosestCoin()
            if coin then
                flyTo(coin.Position + Vector3.new(0,Y_OFFSET,0))
            end
        end
    end
end)
