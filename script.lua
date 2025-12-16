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

-- Global
getgenv().FarmCoins = false

btn.MouseButton1Click:Connect(function()
    FarmCoins = not FarmCoins
    btn.Text = FarmCoins and "Farm: ON" or "Farm: OFF"
end)

-- NoClip
local noclip = true
game:GetService("RunService").Stepped:Connect(function()
    if noclip and game.Players.LocalPlayer.Character then
        for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- Teleport سلس نحو عملة
local function goToCoinSmooth(coin)
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local targetPos = coin.Position
    local startPos = root.Position
    local direction = (targetPos - startPos).Unit
    local distance = (targetPos - startPos).Magnitude
    local step = 3 -- الزخم

    while distance > 1 do
        root.CFrame = CFrame.new(root.Position + direction * step)
        task.wait(0.03)
        startPos = root.Position
        distance = (targetPos - startPos).Magnitude
        direction = (targetPos - startPos).Unit
    end
end

-- Farm Loop: جمع أقرب عملة
task.spawn(function()
    while true do
        if FarmCoins then
            local coins = {}
            -- جمع كل العملات
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "CoinContainer" then
                    for _, coin in pairs(v:GetChildren()) do
                        if coin:IsA("BasePart") and coin:IsDescendantOf(workspace) then
                            table.insert(coins, coin)
                        end
                    end
                end
            end

            -- ترتيب العملات حسب الأقرب
            table.sort(coins, function(a, b)
                local rootPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                return (a.Position - rootPos).Magnitude < (b.Position - rootPos).Magnitude
            end)

            -- الذهاب لكل عملة بالتسلسل
            for _, coin in ipairs(coins) do
                if not FarmCoins then break end
                goToCoinSmooth(coin)
            end
        end
        task.wait(0.15)
    end
end)
