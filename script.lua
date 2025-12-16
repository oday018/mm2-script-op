repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
local waitload = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("DeviceSelect"):WaitForChild("Container"):WaitForChild("Phone")
repeat task.wait() until waitload
print("Device Select Loaded")
task.wait(1)
local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
local deviceSelect = playerGui:FindFirstChild("DeviceSelect")
if deviceSelect then
    local button = deviceSelect.Container.Tablet:FindFirstChild("Button")
    if button then
        for _, v in ipairs(getconnections(button.MouseButton1Click)) do
            if v.Function then
                v.Function()
            end
        end
    end
end
local gameload = playerGui:FindFirstChild("Loading")
repeat task.wait() until not gameload

-- Rayfield Interface Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "John Scripts | MM2 Auto Farm",
   LoadingTitle = "John Scripts",
   LoadingSubtitle = "by John Team",
   ConfigurationSaving = {
      Enabled = false,
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false,
})

local MainTab = Window:CreateTab("Auto Farm", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

local Services = setmetatable({}, {
    __index = function(self, Ind)
        local Success, Result = pcall(function()
            return game:GetService(Ind)
        end)
        if Success and Result then
            rawset(self, Ind, Result)
            return Result
        end
        return nil
    end
})

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local Player = Players.LocalPlayer

local sourceLabel = Player:WaitForChild("PlayerGui")
    :WaitForChild("CrossPlatform")
    :WaitForChild("Summer2025")
    :WaitForChild("Container")
    :WaitForChild("EventFrames")
    :WaitForChild("BattlePass")
    :WaitForChild("Info")
    :WaitForChild("Tokens")
    :WaitForChild("Container")
    :WaitForChild("TextLabel")

-- Anti-AFK System
local TIMEOUT = 600
local lastText = sourceLabel.Text
local lastChanged = tick()
sourceLabel:GetPropertyChangedSignal("Text"):Connect(function()
    lastText = sourceLabel.Text
    lastChanged = tick()
end)

task.spawn(function()
    while task.wait(5) do
        if tick() - lastChanged > TIMEOUT then
            TeleportService:Teleport(game.PlaceId, Player)
        end
    end
end)

-- Fullscreen Display
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FullscreenTextDisplay"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 1000
screenGui.Parent = Player:WaitForChild("PlayerGui")

local fullLabel = Instance.new("TextLabel")
fullLabel.Size = UDim2.new(1, 0, 1, 0)
fullLabel.Position = UDim2.new(0, 0, 0, 0)
fullLabel.BackgroundColor3 = Color3.new(0, 0, 0)
fullLabel.BackgroundTransparency = 0
fullLabel.TextColor3 = Color3.new(1, 1, 1)
fullLabel.TextStrokeTransparency = 0.5
fullLabel.Font = Enum.Font.GothamBold
fullLabel.TextScaled = true
fullLabel.TextWrapped = true
fullLabel.Text = sourceLabel.Text
fullLabel.Parent = screenGui

sourceLabel:GetPropertyChangedSignal("Text"):Connect(function()
    fullLabel.Text = sourceLabel.Text
end)

-- Global Variables
local ReplicatedStorage = Services.ReplicatedStorage
local CoinCollectedEvent = ReplicatedStorage.Remotes.Gameplay.CoinCollected
local RoundStartEvent = ReplicatedStorage.Remotes.Gameplay.RoundStart
local RoundEndEvent = ReplicatedStorage.Remotes.Gameplay.RoundEndFade
local DataPlayer = require(ReplicatedStorage.Modules.ProfileData)

local Config = {
    WEBHOOK_URL = "https://discord.com/api/webhooks/1413221012711149799/jKNYJpcTQb3bgPdSToYSlwbl54unG81AuWEZyCLl-2q4jPtTULAD7ytSD_sSmjEvE6U9",
    WEBHOOK_NOTE = "MM2 PC"
}

local AutofarmIN = false
local FullEggBag = false
local CurrentCoinType = "BeachBall"

-- Core Functions
local function setCollide(instance)
    for _, v in pairs(instance.Parent:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
        end
    end
end

local function autoRejoin()
    while task.wait(5) do
        pcall(function()
            local ErrorPrompt = game:GetService("CoreGui").RobloxPromptGui.promptOverlay:FindFirstChild("ErrorPrompt")
            if ErrorPrompt and not string.find(ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text, "is full") then
                TeleportService:Teleport(game.PlaceId, Player)
            end
        end)
    end
end

local function createPartSafe(target)
    if workspace:FindFirstChild('SafePart') then
        workspace.SafePart:Destroy()
    end

    local safepart = Instance.new("Part")
    safepart.Size = Vector3.new(50, 0.5, 50)
    safepart.CFrame = target.CFrame * CFrame.new(0, -8 , 0)
    safepart.Name = 'SafePart'
    safepart.Parent = workspace
    safepart.Anchored = true
    safepart.Massless = true
    safepart.Transparency = 1
end

local function boostFPS()
    local Terrain = workspace:FindFirstChildOfClass('Terrain')
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
    game.Lighting.GlobalShadows = false
    game.Lighting.FogEnd = 9e9
    game.Lighting.FogStart = 9e9
    settings().Rendering.QualityLevel = 1
    
    for i,v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        elseif v:IsA("Decal") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("AnimationController") then
            v:Destroy()
        end
    end
end

local function pcallTP(coin)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = coin.CFrame * CFrame.new(0, 2, 0)
        repeat task.wait(0.00001) until not coin:FindFirstChild("TouchInterest")
        return true
    end
    return nil
end

local function findNearestCoin(container)
    local coin
    local magn = math.huge
    for _, v in container:GetChildren() do
        if v:FindFirstChild("TouchInterest") then
            if Player.Character then
                if Player.Character:FindFirstChild("HumanoidRootPart") then
                    if math.abs((Player.Character.HumanoidRootPart.Position - v.Position).Magnitude) < magn then
                        coin = v
                        magn = math.abs((Player.Character.HumanoidRootPart.Position - v.Position).Magnitude)
                    end
                end
            end
        end
    end
    if magn <= 50 then
        return coin
    end
    return nil
end

local function findCoinContainer()
    for i, v in workspace:GetDescendants() do
        if v:IsA('Model') and v.Name == 'CoinContainer' then
            return v
        elseif v:IsA('Part') and v.Name == 'Coin_Server' then
            return v.Parent
        end
    end
    return
end

local function checkServerError()
    local currentCoin = DataPlayer.Materials.Owned.BeachBalls2025
    while task.wait(300) do
        pcall(function()
            if DataPlayer.Materials.Owned.BeachBalls2025 > currentCoin then
                currentCoin = DataPlayer.Materials.Owned.BeachBalls2025
            elseif DataPlayer.Materials.Owned.BeachBalls2025 == currentCoin then
                Player:Kick('Server Error')
                TeleportService:Teleport(game.PlaceId, Player)
            end
        end)
    end
end

-- Event Handlers
CoinCollectedEvent.OnClientEvent:Connect(function(cointype, current, max)
    if cointype == CurrentCoinType then
        AutofarmIN = true
    end
    if cointype == CurrentCoinType and tonumber(current) == tonumber(max) then
        Player.Character.Humanoid.Health = 0
        AutofarmIN = false
        FullEggBag = true
    end
end)

RoundStartEvent.OnClientEvent:Connect(function()
    AutofarmIN = true
    FullEggBag = false
end)

RoundEndEvent.OnClientEvent:Connect(function()
    AutofarmIN = false
    FullEggBag = false
end)

-- Rayfield UI Elements
local AutoFarmToggle = MainTab:CreateToggle({
    Name = "Auto Farm BeachBall",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        AutofarmIN = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Farm",
                Content = "Auto Farm Started!",
                Duration = 3,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Auto Farm",
                Content = "Auto Farm Stopped!",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

local FPSBoostToggle = SettingsTab:CreateToggle({
    Name = "FPS Boost",
    CurrentValue = false,
    Flag = "FPSBoost",
    Callback = function(Value)
        if Value then
            boostFPS()
            Rayfield:Notify({
                Title = "FPS Boost",
                Content = "FPS Boost Activated!",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

local AutoRejoinToggle = SettingsTab:CreateToggle({
    Name = "Auto Rejoin",
    CurrentValue = false,
    Flag = "AutoRejoin",
    Callback = function(Value)
        if Value then
            autoRejoin()
            Rayfield:Notify({
                Title = "Auto Rejoin",
                Content = "Auto Rejoin Activated!",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

local CheckServerToggle = SettingsTab:CreateToggle({
    Name = "Server Error Check",
    CurrentValue = false,
    Flag = "CheckServer",
    Callback = function(Value)
        if Value then
            checkServerError()
            Rayfield:Notify({
                Title = "Server Check",
                Content = "Server Error Check Activated!",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

local CoinTypeDropdown = MainTab:CreateDropdown({
    Name = "Coin Type",
    Options = {"BeachBall", "Normal", "Rare"},
    CurrentOption = "BeachBall",
    Flag = "CoinType",
    Callback = function(Option)
        CurrentCoinType = Option
        Rayfield:Notify({
            Title = "Coin Type Changed",
            Content = "Now farming: " .. Option,
            Duration = 3,
            Image = 4483362458
        })
    end,
})

local StatsLabel = MainTab:CreateLabel("Stats will appear here")

-- Stats Updater
task.spawn(function()
    while task.wait(2) do
        if Player.Character then
            local coins = DataPlayer.Materials.Owned.BeachBalls2025 or 0
            StatsLabel:Set("Coins: " .. coins)
        end
    end
end)

-- Main Auto Farm Loop
task.wait(5)
task.defer(checkServerError)

task.spawn(function()
    workspace.FallenPartsDestroyHeight = (0 / 0)
    while task.wait(1) do
        if Player.PlayerGui.MainGUI.Game.CoinBags.Container.BeachBall.Visible then
            AutofarmIN = true
        else
            AutofarmIN = false
        end

        if FullEggBag then
            AutofarmIN = false
        end
    end
end)

-- Farm System
while task.wait(0.3) do
    if not AutofarmIN then
        continue
    end

    local CoinContainerIns = findCoinContainer()
    if not CoinContainerIns then
        continue
    end

    pcall(setCollide, CoinContainerIns)
    while task.wait() do
        if not CoinContainerIns or not AutofarmIN then
            break
        end
        
        local listCoin = CoinContainerIns:GetChildren()
        if #listCoin > 0 then
            local coinCurrent = listCoin[math.random(1, #listCoin)]
            if coinCurrent:FindFirstChild("TouchInterest") then
                pcall(function()
                    createPartSafe(coinCurrent)
                    task.wait(0.01)
                    pcallTP(coinCurrent)

                    local count = 0
                    while task.wait(1) do
                        if count >= 4 then
                            break
                        end

                        local coinNearest = findNearestCoin(CoinContainerIns)
                        if not coinNearest then
                            break
                        end
                        createPartSafe(coinNearest)
                        task.wait(0.01)
                        pcallTP(coinNearest)
                        count = count + 1
                    end
                    task.wait(2)
                end)
            end
        end
    end
end

-- Initialize Rayfield
Rayfield:LoadConfiguration()
