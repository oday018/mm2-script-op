-- ✨ Coin Farming Script with Wand UI ✨
-- Using Wand UI (Redz Library V5 Remake)

-- Load the Wand UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- Create the main window
local Window = Library:MakeWindow({
    Title = "Coin Farming Hub",
    SubTitle = "Smooth Ghost Flight",
    ScriptFolder = "redz-library-V5"
})

-- Create a tab for the farming features
local FarmingTab = Window:MakeTab({
    Title = "Coin Farming",
    Icon = "Coin"
})

-- Global variables
getgenv().coinFarmEnabled = false
getgenv().flightSpeed = 20
getgenv().flightHeight = 5

-- Add a toggle for coin farming
local coinFarmToggle
coinFarmToggle = FarmingTab:AddToggle({
    Name = "Enable Coin Farming",
    Default = false,
    Callback = function(Value)
        getgenv().coinFarmEnabled = Value
        
        if Value then
            -- Start farming
            task.spawn(function()
                coinFarmLoop()
            end)
        else
            -- Stop flight when disabling
            disableFlight()
        end
    end
})

-- Add a slider for flight speed
local flightSpeedSlider = FarmingTab:AddSlider({
    Name = "Flight Speed",
    Min = 5,
    Max = 100,
    Increment = 5,
    Default = 20,
    Callback = function(Value)
        getgenv().flightSpeed = Value
    end
})

-- Add a slider for flight height
local flightHeightSlider = FarmingTab:AddSlider({
    Name = "Flight Height",
    Min = 0,
    Max = 20,
    Increment = 1,
    Default = 5,
    Callback = function(Value)
        getgenv().flightHeight = Value
    end
})

-- Function to enable flight (noclip + fly)
local function enableFlight()
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end
    
    local character = player.Character
    
    -- Enable noclip
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    -- Add BodyVelocity for flight if not exists
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local existingBodyVelocity = rootPart:FindFirstChild("FlightBodyVelocity")
        if not existingBodyVelocity then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "FlightBodyVelocity"
            bodyVelocity.Parent = rootPart
            bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end
    
    -- Enable flying
    if character:FindFirstChild("Humanoid") then
        character.Humanoid.PlatformStand = true
    end
end

-- Function to disable flight
local function disableFlight()
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end
    
    local character = player.Character
    
    -- Restore collision
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
    
    -- Remove BodyVelocity
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local bodyVelocity = rootPart:FindFirstChild("FlightBodyVelocity")
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
    end
    
    -- Disable flying
    if character:FindFirstChild("Humanoid") then
        character.Humanoid.PlatformStand = false
    end
end

-- Function to fly to position
local function flyToPosition(targetPosition)
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end
    
    local character = player.Character
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- Calculate direction with flight height
    local targetWithHeight = Vector3.new(
        targetPosition.X,
        targetPosition.Y + getgenv().flightHeight,
        targetPosition.Z
    )
    
    local direction = (targetWithHeight - rootPart.Position).Unit
    local distance = (targetWithHeight - rootPart.Position).Magnitude
    
    -- Set flight velocity
    local bodyVelocity = rootPart:FindFirstChild("FlightBodyVelocity")
    if bodyVelocity then
        bodyVelocity.Velocity = direction * getgenv().flightSpeed
        
        -- Fly until reached or coin farming disabled
        local startTime = tick()
        while distance > 5 and getgenv().coinFarmEnabled and (tick() - startTime) < 10 do
            -- Update distance
            distance = (targetWithHeight - rootPart.Position).Magnitude
            task.wait(0.1)
        end
        
        -- Stop moving
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end

-- Function to find all coins
local function getAllCoins()
    local coins = {}
    for _, item in ipairs(game.Workspace:GetDescendants()) do
        if item.Name == "Coin_Server" and item:IsA("BasePart") then
            table.insert(coins, item)
        end
    end
    return coins
end

-- Function to find nearest coin
local function findNearestCoin()
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return nil end
    
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    
    local playerPos = rootPart.Position
    local nearestCoin = nil
    local shortestDistance = math.huge
    
    local coins = getAllCoins()
    
    if #coins == 0 then
        return nil
    end
    
    for _, coin in ipairs(coins) do
        local distance = (coin.Position - playerPos).Magnitude
        if distance < shortestDistance then
            shortestDistance = distance
            nearestCoin = coin
        end
    end
    
    return nearestCoin, shortestDistance
end

-- Function to collect coin
local function collectCoin(coin)
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end
    
    local character = player.Character
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- Check if coin still exists
    if not coin or not coin.Parent then return end
    
    -- Move close to coin
    local targetPos = Vector3.new(
        coin.Position.X,
        coin.Position.Y + 2,
        coin.Position.Z
    )
    
    flyToPosition(targetPos)
    task.wait(0.5)
    
    -- Collect coin
    if coin and coin.Parent then
        firetouchinterest(rootPart, coin, 0)
        task.wait(0.05)
        firetouchinterest(rootPart, coin, 1)
    end
end

-- Main farming loop
local function coinFarmLoop()
    print("Starting coin farming...")
    
    -- Enable flight
    enableFlight()
    task.wait(1)
    
    while getgenv().coinFarmEnabled do
        -- Check if player exists
        local player = game.Players.LocalPlayer
        if not player or not player.Character then
            task.wait(1)
            continue
        end
        
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if not rootPart then
            task.wait(1)
            continue
        end
        
        -- Find nearest coin
        local nearestCoin, distance = findNearestCoin()
        
        if nearestCoin then
            print("Moving to nearest coin, distance: " .. math.floor(distance))
            collectCoin(nearestCoin)
            task.wait(0.3) -- Wait before next coin
        else
            print("No coins found, searching...")
            task.wait(1)
        end
    end
    
    -- Disable flight when stopping
    disableFlight()
    print("Coin farming stopped")
end

-- Auto-enable noclip when farming
game:GetService("RunService").Stepped:Connect(function()
    if getgenv().coinFarmEnabled then
        local player = game.Players.LocalPlayer
        if player and player.Character then
            -- Keep noclip enabled
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Add a notification when script loads
Window:Notify({
    Title = "Coin Farming Hub",
    Content = "Script loaded! Enable coin farming to start.",
    Image = "rbxassetid://10734953451",
    Duration = 5
})

-- Add test button
FarmingTab:AddButton({
    Name = "Test Flight",
    Callback = function()
        enableFlight()
        Window:Notify({
            Title = "Flight Enabled",
            Content = "Flight mode activated!",
            Duration = 3
        })
    end
})

-- Add stop flight button
FarmingTab:AddButton({
    Name = "Stop Flight",
    Callback = function()
        disableFlight()
        Window:Notify({
            Title = "Flight Disabled",
            Content = "Flight mode deactivated",
            Duration = 3
        })
    end
})

-- Add check coins button
FarmingTab:AddButton({
    Name = "Check Coins",
    Callback = function()
        local coins = getAllCoins()
        Window:Notify({
            Title = "Coins Found",
            Content = "Found " .. #coins .. " coins in workspace",
            Duration = 3
        })
    end
})

-- Auto setup when character spawns
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(2) -- Wait for character to load
    if getgenv().coinFarmEnabled then
        enableFlight()
    end
end)

-- Handle character removal
game.Players.LocalPlayer.CharacterRemoving:Connect(function()
    -- Nothing needed here
end)
