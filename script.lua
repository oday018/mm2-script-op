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

-- Teleport مباشر لنص العملة
local function goToCoin(coin)
    local char = game.Players.LocalPlayer.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    root.CFrame = coin.CFrame
    task.wait(0.12)
end

-- Farm Loop
task.spawn(function()
    while true do
        if FarmCoins then
            for _,v in pairs(workspace:GetDescendants()) do
                if not FarmCoins then break end

                if v.Name == "CoinContainer" then
                    for _,coin in pairs(v:GetChildren()) do
                        if not FarmCoins then break end
                        if coin:IsA("BasePart") and coin:IsDescendantOf(workspace) then
                            goToCoin(coin)
                        end
                    end
                end
            end
        end
        task.wait(0.15)
    end
end)
