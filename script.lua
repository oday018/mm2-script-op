------------------------------------------------
-- Rayfield
------------------------------------------------
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "FlyCoin AI",
    LoadingTitle = "FlyCoin Framework",
    LoadingSubtitle = "by Rayfaid",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FlyCoin",
        FileName = "Config"
    },
    Discord = { Enabled = false },
    KeySystem = false
})

local Tab = Window:CreateTab("Autofarm", 4483362458)

------------------------------------------------
-- Library
------------------------------------------------
local Lib = {}

-- Services (Safe)
Lib.Services = setmetatable({}, {
    __index = function(self, ind)
        local ok, s = pcall(game.GetService, game, ind)
        if ok then rawset(self, ind, s) return s end
    end
})

local Services = Lib.Services
local Players = Services.Players
local ReplicatedStorage = Services.ReplicatedStorage
local TeleportService = Services.TeleportService
local Player = Players.LocalPlayer

------------------------------------------------
-- State
------------------------------------------------
Lib.State = {
    Enabled = false,
    FullBag = false,
    CoinType = "BeachBall"
}

------------------------------------------------
-- Movement
------------------------------------------------
function Lib.SafePart(target)
    if workspace:FindFirstChild("SafePart") then
        workspace.SafePart:Destroy()
    end
    local p = Instance.new("Part")
    p.Name = "SafePart"
    p.Size = Vector3.new(40,1,40)
    p.Anchored = true
    p.Transparency = 1
    p.CFrame = target.CFrame * CFrame.new(0,-8,0)
    p.Parent = workspace
end

function Lib.Teleport(coin)
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = coin.CFrame * CFrame.new(0,2,0)
    repeat task.wait() until not coin:FindFirstChild("TouchInterest")
end

------------------------------------------------
-- Coin Logic
------------------------------------------------
function Lib.GetContainer()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == "CoinContainer" then
            return v
        end
    end
end

function Lib.GetNearest(container)
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local closest, dist = nil, math.huge
    for _, v in ipairs(container:GetChildren()) do
        if v:FindFirstChild("TouchInterest") then
            local d = (hrp.Position - v.Position).Magnitude
            if d < dist then
                dist = d
                closest = v
            end
        end
    end
    return closest
end

------------------------------------------------
-- Events
------------------------------------------------
function Lib.BindEvents()
    local R = ReplicatedStorage.Remotes.Gameplay

    R.CoinCollected.OnClientEvent:Connect(function(t, cur, max)
        if t ~= Lib.State.CoinType then return end
        Lib.State.Enabled = true

        if tonumber(cur) == tonumber(max) then
            Lib.State.FullBag = true
            Lib.State.Enabled = false
            Player.Character.Humanoid.Health = 0
        end
    end)

    R.RoundStart.OnClientEvent:Connect(function()
        Lib.State.Enabled = true
        Lib.State.FullBag = false
    end)

    R.RoundEndFade.OnClientEvent:Connect(function()
        Lib.State.Enabled = false
    end)
end

------------------------------------------------
-- Main Loop
------------------------------------------------
task.spawn(function()
    Lib.BindEvents()
    while task.wait(0.25) do
        if not Lib.State.Enabled then continue end
        local c = Lib.GetContainer()
        if not c then continue end

        local coin = Lib.GetNearest(c)
        if coin then
            Lib.SafePart(coin)
            Lib.Teleport(coin)
        end
    end
end)

------------------------------------------------
-- Rayfield UI
------------------------------------------------
Tab:CreateToggle({
    Name = "Autofarm Coins",
    CurrentValue = false,
    Flag = "Autofarm",
    Callback = function(v)
        Lib.State.Enabled = v
        Rayfield:Notify({
            Title = "FlyCoin",
            Content = v and "Autofarm Enabled" or "Autofarm Disabled",
            Duration = 3
        })
    end
})

Tab:CreateParagraph({
    Title = "Status",
    Content = "AI Coin Farm Active\nRayfield Framework\nStealth Logic"
})
