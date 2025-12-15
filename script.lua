-- ✨ Coin Farming Script with Wand UI ✨
-- Using Wand UI (Redz Library V5 Remake)

-- Load the Wand UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- Create the main window
local Window = Library:MakeWindow({
    Title = "Coin Farming Hub",
    SubTitle = "Smooth Ghost Movement",
    ScriptFolder = "redz-library-V5"
})

-- Create a tab for the farming features
local FarmingTab = Window:MakeTab({
    Title = "Coin Farming",
    Icon = "Coin"
})

-- Add a toggle for coin farming
local coinFarmToggle
coinFarmToggle = FarmingTab:AddToggle({
    Name = "Enable Coin Farming",
    Default = false,
    Callback = function(Value)
        getgenv().coinFarmEnabled = Value
        if Value then
            coinFarm() -- Start the coin farming function
        end
    end
})

-- Add a slider for movement speed
local movementSpeedSlider = FarmingTab:AddSlider({
    Name = "Movement Speed",
    Min = 10,
    Max = 100,
    Increment = 5,
    Default = 50,
    Callback = function(Value)
        getgenv().movementSpeed = Value
    end
})

-- Function to find the nearest coin
local function findNearestCoin()
    local nearestCoin = nil
    local shortestDistance = math.huge
    local playerPosition = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    
    if not playerPosition then return nil end
    
    for _, coin in ipairs(game.Workspace:GetDescendants()) do
        if coin.Name == "Coin_Server" and coin:IsA("BasePart") then
            local distance = (coin.Position - playerPosition).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestCoin = coin
            end
        end
    end
    
    return nearestCoin
end

-- Function to move smoothly to coin (ghost-like movement)
local function moveSmoothlyToCoin(coin)
    if not game.Players.LocalPlayer.Character or not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local characterRoot = game.Players.LocalPlayer.Character.HumanoidRootPart
    local targetPosition = coin.Position
    
    -- Calculate flight path (
