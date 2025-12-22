-- Tiny Anti-Fling UI Library
-- ضع هذا السكربت في StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

--[[======================
     هنا يبدأ الكود الأصلي لنظام Anti-Fling
========================]]
local AntiFling = {
    Enabled = false,
    DetectionThreshold = 100,
    MaxVelocity = 80,
    MaxAngularVelocity = 50,
    AntiFlingForce = 10000
}

local lastValidPosition = nil
local isBeingFlinged = false
local flingDetectionCount = 0
local flingProtectionEnabled = true

local function restorePlayerState()
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if humanoid and rootPart then
        rootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
        rootPart.AssemblyAngularVelocity = Vector3.new(0,0,0)
        for _, force in ipairs(rootPart:GetChildren()) do
            if force:IsA("BodyForce") or force:IsA("BodyVelocity") or force:IsA("BodyAngularVelocity") then
                force:Destroy()
            end
        end
        if lastValidPosition then
            rootPart.CFrame = CFrame.new(lastValidPosition)
        end
        humanoid.PlatformStand = false
        humanoid.AutoRotate = true
        humanoid:ChangeState("GettingUp")
    end
end

local function advancedAntiFling()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return false end
    local rootPart = LocalPlayer.Character.HumanoidRootPart
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return false end

    local currentVelocity = rootPart.AssemblyLinearVelocity.Magnitude
    local currentAngularVelocity = rootPart.AssemblyAngularVelocity.Magnitude

    if currentVelocity < 50 and currentAngularVelocity < 30 then
        lastValidPosition = rootPart.Position
        isBeingFlinged = false
        flingDetectionCount = 0
        return false
    end

    if currentVelocity > AntiFling.DetectionThreshold or currentAngularVelocity > AntiFling.MaxAngularVelocity then
        flingDetectionCount = flingDetectionCount + 1
        isBeingFlinged = true
        if flingDetectionCount > 3 then return true end
    else
        flingDetectionCount = math.max(0, flingDetectionCount -1)
    end
    return false
end

local function applyAntiFlingForce()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = LocalPlayer.Character.HumanoidRootPart
    for _, force in ipairs(rootPart:GetChildren()) do
        if force:IsA("BodyForce") or force:IsA("BodyVelocity") or force:IsA("BodyAngularVelocity") then
            force:Destroy()
        end
    end

    local antiForce = Instance.new("BodyForce")
    antiForce.Name = "AntiFlingForce"
    antiForce.Force = -rootPart.AssemblyLinearVelocity.Unit * AntiFling.AntiFlingForce
    antiForce.Parent = rootPart

    local antiAngular = Instance.new("BodyAngularVelocity")
    antiAngular.Name = "AntiFlingAngular"
    antiAngular.AngularVelocity = -rootPart.AssemblyAngularVelocity
    antiAngular.MaxTorque = Vector3.new(10000,10000,10000)
    antiAngular.P = 10000
    antiAngular.Parent = rootPart

    task.spawn(function()
        for i=1,10 do
            if antiForce and antiForce.Parent then
                antiForce.Force = antiForce.Force * 0.7
                antiAngular.AngularVelocity = antiAngular.AngularVelocity * 0.7
            end
            task.wait(0.05)
        end
        if antiForce then antiForce:Destroy() end
        if antiAngular then antiAngular:Destroy() end
        restorePlayerState()
    end)
end

local function mainAntiFlingLoop()
    while AntiFling.Enabled and flingProtectionEnabled do
        RunService.Heartbeat:Wait()
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then continue end
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        if advancedAntiFling() then
            applyAntiFlingForce()
        end
        -- تقييد السرعات
        if rootPart.AssemblyLinearVelocity.Magnitude > AntiFling.MaxVelocity then
            rootPart.AssemblyLinearVelocity = rootPart.AssemblyLinearVelocity.Unit * AntiFling.MaxVelocity
        end
        if rootPart.AssemblyAngularVelocity.Magnitude > AntiFling.MaxAngularVelocity then
            rootPart.AssemblyAngularVelocity = rootPart.AssemblyAngularVelocity.Unit * AntiFling.MaxAngularVelocity
        end
    end
end

local function enableAntiFling()
    if AntiFling.Enabled then return end
    AntiFling.Enabled = true
    lastValidPosition = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)
    task.spawn(mainAntiFlingLoop)
end

local function disableAntiFling()
    AntiFling.Enabled = false
end

--[[======================
     هنا يبدأ كود الواجهة البسيطة جدًا
========================]]
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TinyAntiFlingUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0,60,0,30)
button.Position = UDim2.new(0,10,0,10)
button.BackgroundColor3 = Color3.fromRGB(35,35,35)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Text = "OFF"
button.Font = Enum.Font.SourceSans
button.TextSize = 18
button.Parent = screenGui

local enabled = false
button.MouseButton1Click:Connect(function()
    if enabled then
        disableAntiFling()
        button.Text = "OFF"
        enabled = false
    else
        enableAntiFling()
        button.Text = "ON"
        enabled = true
    end
end)
