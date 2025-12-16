-- UI
local ui = Instance.new("ScreenGui", game.CoreGui)
local btn = Instance.new("TextButton", ui)

btn.Size = UDim2.new(0, 140, 0, 40)
btn.Position = UDim2.new(0, 20, 0, 100)
btn.Text = "FlyFarm: OFF"
btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.TextSize = 18
btn.Draggable = true
btn.Active = true

-- Toggle
getgenv().FlyFarm = false

------------------------------------------------
-- Services & Player
------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

------------------------------------------------
-- إعدادات
------------------------------------------------
local SPEED = 0.25        -- سرعة الطيران (0.15 – 0.4)
local FLY_HEIGHT = 6      -- ارتفاع ثابت (ما يطيح)

------------------------------------------------
-- Noclip + Fly ثابت
------------------------------------------------
local function enableFly(character)
    local humanoid = character:WaitForChild("Humanoid")
    local root = character:WaitForChild("HumanoidRootPart")

    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    humanoid.PlatformStand = true

    -- اختراق كل شيء
    for _,v in ipairs(character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end

    return root
end

------------------------------------------------
-- أقرب عملة
------------------------------------------------
local function getClosestCoin(root)
    local closest, dist = nil, math.huge
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("coin") and v.Parent then
            local d = (v.Position - root.Position).Magnitude
            if d < dist then
                dist = d
                closest = v
            end
        end
    end
    return closest
end

------------------------------------------------
-- Fly Farm (سلس + يخترق + ما يوقف)
------------------------------------------------
local function startFlyFarm()
    local char = lp.Character or lp.CharacterAdded:Wait()
    local root = enableFly(char)

    RunService.RenderStepped:Connect(function()
        if not getgenv().FlyFarm then return end

        local coin = getClosestCoin(root)
        if coin then
            local targetPos = Vector3.new(
                coin.Position.X,
                coin.Position.Y + FLY_HEIGHT,
                coin.Position.Z
            )

            root.CFrame = root.CFrame:Lerp(
                CFrame.new(targetPos),
                SPEED
            )
        end
    end)
end

------------------------------------------------
-- زر التشغيل
------------------------------------------------
btn.MouseButton1Click:Connect(function()
    getgenv().FlyFarm = not getgenv().FlyFarm
    btn.Text = getgenv().FlyFarm and "FlyFarm: ON" or "FlyFarm: OFF"

    if getgenv().FlyFarm then
        startFlyFarm()
    else
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            local h = lp.Character.Humanoid
            h.PlatformStand = false
            h:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end)

