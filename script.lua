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
local RANGE = 200        -- مدى البحث
local Y_OFFSET = 5       -- ارتفاع الشخصية فوق الأرض

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
-- الحصول على ارتفاع الأرض
------------------------------------------------
local function getGroundY(position)
    local ray = Ray.new(position + Vector3.new(0, 50, 0), Vector3.new(0, -500, 0))
    local hit, hitPos = workspace:FindPartOnRay(ray, lp.Character)
    if hit then
        return hitPos.Y
    else
        return position.Y -- إذا لم نجد أرض نترك نفس الارتفاع
    end
end

------------------------------------------------
-- الانتقال الفوري للعملة
------------------------------------------------
local function teleportToCoin(coin)
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart
    local pos = coin.Position
    local groundY = getGroundY(pos)
    root.CFrame = CFrame.new(Vector3.new(pos.X, groundY + Y_OFFSET, pos.Z))
end

------------------------------------------------
-- زر التشغيل
------------------------------------------------
btn.MouseButton1Click:Connect(function()
    FarmCoins = not FarmCoins
    btn.Text = FarmCoins and "Farm: ON" or "Farm: OFF"

    if FarmCoins then
        task.spawn(function()
            while FarmCoins do
                local coin = getClosestCoin()
                if coin then
                    teleportToCoin(coin)
                    task.wait(0.1) -- وقت قصير قبل البحث عن العملة التالية
                else
                    task.wait(0.2)
                end
            end
        end)
    end
end)
