-- UI
local ui = Instance.new("ScreenGui", game.CoreGui)
local btn = Instance.new("TextButton", ui)
btn.Size = UDim2.new(0, 100, 0, 40)
btn.Position = UDim2.new(0, 20, 0, 100)
btn.Text = "Farm: OFF"
btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.TextSize = 20
btn.Draggable = true
btn.Active = true

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
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
end)

-- حركة الطيران بسلسلة
local function flyTo(pos)
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum then return end

    -- اجعل الشخصية في وضعية الجلوس
    hum.Sit = true

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9,1e9,1e9)
    bv.Parent = root

    local dir = (pos - root.Position).Unit
    local speed = 25

    while (pos - root.Position).Magnitude > 1 do
        if not getgenv().FarmCoins then break end
        dir = (pos - root.Position).Unit
        bv.Velocity = dir * speed
        task.wait(0.03)
    end

    bv:Destroy()
    hum.Sit = false -- ارجع الشخصية لوضعية طبيعية بعد الوصول
end

-- Loop جمع العملات
task.spawn(function()
    while true do
        if FarmCoins then
            local coins = {}
            for _,v in pairs(workspace:GetDescendants()) do
                if v.Name == "CoinContainer" then
                    for _,coin in pairs(v:GetChildren()) do
                        if coin:IsA("BasePart") then
                            table.insert(coins, coin)
                        end
                    end
                end
            end

            -- اجعل الشخصية تذهب للعملة الأقرب أولًا
            table.sort(coins, function(a,b)
                return (a.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 
                       (b.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            end)

            for _,coin in ipairs(coins) do
                if not getgenv().FarmCoins then break end
                if coin and coin:IsDescendantOf(workspace) then
                    flyTo(coin.Position + Vector3.new(0,3,0))
                end
            end
        else
            task.wait(0.2)
        end
        task.wait(0.2)
    end
end)
