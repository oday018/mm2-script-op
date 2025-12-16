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
local PathfindingService = game:GetService("PathfindingService")
local lp = Players.LocalPlayer
local RANGE = 100        -- قلل النطاق لتجنب العملات البعيدة
local SPEED = 200

------------------------------------------------
-- أقرب عملة قابلة للوصول
------------------------------------------------
local function getClosestCoin()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart
    local closestCoin
    local shortest = RANGE

    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("coin") and v.Parent then
            local dist = (v.Position - root.Position).Magnitude
            if dist <= shortest then
                -- تحقق من إمكانية الوصول عبر خط مباشر (تجنب الجدران)
                local ray = Ray.new(root.Position, (v.Position - root.Position).Unit * dist)
                local hit = workspace:FindPartOnRay(ray, lp.Character)
                if not hit or hit == v then
                    shortest = dist
                    closestCoin = v
                end
            end
        end
    end
    return closestCoin
end

------------------------------------------------
-- التحرك نحو العملة باستخدام Pathfinding
------------------------------------------------
local function goToCoin(coin)
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local humanoid = lp.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local path = PathfindingService:CreatePath()
    path:ComputeAsync(lp.Character.HumanoidRootPart.Position, coin.Position)
    local waypoints = path:GetWaypoints()

    for _, waypoint in ipairs(waypoints) do
        if not getgenv().FarmCoins then break end
        humanoid:MoveTo(waypoint.Position)
        local reached = humanoid.MoveToFinished:Wait()
        if not coin or not coin.Parent then break end
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
                    goToCoin(coin)
                else
                    task.wait(0.2)
                end
            end
        end)
    end
end)
