--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--// Player
local player = Players.LocalPlayer

--// Character vars
local character
local humanoidRootPart

--// Anti-Fling vars
local antiFlingEnabled = false
local heartbeatConnection

--// Update Character
local function setCharacter(char)
    character = char
    humanoidRootPart = char:WaitForChild("HumanoidRootPart", 5)
end

--// Start Anti-Fling
local function startAntiFling()
    if antiFlingEnabled or not humanoidRootPart then return end
    antiFlingEnabled = true

    heartbeatConnection = RunService.Heartbeat:Connect(function()
        if humanoidRootPart and humanoidRootPart.Velocity.Magnitude > 100 then
            humanoidRootPart.Velocity = Vector3.zero
        end
    end)
end

--// Stop Anti-Fling
local function stopAntiFling()
    antiFlingEnabled = false

    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
end

--// Character Added
player.CharacterAdded:Connect(function(char)
    setCharacter(char)

    -- لو كانت الميزة مفعلة قبل الموت، ترجع تشتغل
    if antiFlingEnabled then
        stopAntiFling()
        startAntiFling()
    end
end)

--// Initial Character
if player.Character then
    setCharacter(player.Character)
end

--// ================== UI ==================

local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"
))()

local Window = Library:MakeWindow({
    Title = "Example Hub",
    SubTitle = "Anti Fling Fix",
    ScriptFolder = "example-hub"
})

local MainTab = Window:MakeTab({
    Title = "Main",
    Icon = "Shield"
})

MainTab:AddToggle({
    Name = "Anti Fling",
    Default = false,
    Callback = function(Value)
        if Value then
            startAntiFling()
        else
            stopAntiFling()
        end
    end
})
