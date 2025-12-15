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

-- Function to find the nearest coin with better error handling
local function findNearestCoin()
    local nearestCoin = nil
    local shortestDistance = math.huge
    local playerPosition = nil
    
    -- Wait for player character to load
    local player = game.Players.LocalPlayer
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    playerPosition = player.Character.HumanoidRootPart.Position
    
    -- Search for coins
    local coinsFound = 0
    for _, coin in ipairs(game.Workspace:GetDescendants()) do
        if coin.Name == "Coin_Server" and coin:IsA("BasePart") then
            coinsFound = coinsFound + 1
            local distance = (coin.Position - playerPosition).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestCoin = coin
            end
        end
    end
    
    if coinsFound > 0 then
        print("Found " .. coinsFound .. " coins, moving to nearest one")
    else
        print("No coins found in workspace")
    end
    
    return nearestCoin
end

-- Function to move smoothly to coin with better error handling
local function moveSmoothlyToCoin(coin)
    local player = game.Players.LocalPlayer
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        print("Error: Player or character not found")
        return
    end
    
    local characterRoot = player.Character.HumanoidRootPart
    local targetPosition = coin.Position
    
    print("Moving to coin at position: " .. tostring(targetPosition))
    
    -- Calculate flight path
    local distance = (targetPosition - characterRoot.Position).Magnitude
    local duration = distance / (getgenv().movementSpeed or 50)
    
    -- Create smooth movement using TweenService
    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out,
        1,
        false,
        0
    )
    
    local goal = {
        CFrame = CFrame.new(targetPosition.X, targetPosition.Y + 8, targetPosition.Z) -- Fly above the coin
    }
    
    -- Create and play the tween
    local tween = game:GetService("TweenService"):Create(characterRoot, tweenInfo, goal)
    tween:Play()
    
    -- Add floating effect
    local floatTween = game:GetService("TweenService"):Create(characterRoot, 
        TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
        {CFrame = characterRoot.CFrame * CFrame.new(0, 3, 0)}
    )
    floatTween:Play()
    
    print("Movement started, waiting for completion...")
end

-- Main coin farming function with better error handling
local function coinFarm()
    while getgenv().coinFarmEnabled do
        -- Wait for player character to be ready
        local player = game.Players.LocalPlayer
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            print("Waiting for character to load...")
            task.wait(1)
            continue
        end
        
        -- Find the nearest coin
        local nearestCoin = findNearestCoin()
        
        if nearestCoin then
            moveSmoothlyToCoin(nearestCoin)
            -- Wait for movement to complete plus extra time
            task.wait(duration or 2)
        else
            -- No coins found, wait and try again
            task.wait(1)
        end
    end
end

-- Add a notification when script loads
Window:Notify({
    Title = "Coin Farming Hub",
    Content = "Script loaded successfully! Enable coin farming to start collecting.",
    Image = "rbxassetid://10734953451",
    Duration = 5
})

-- Add debug button to test movement
FarmingTab:AddButton({
    Name = "Test Movement",
    Callback = function()
        -- Find nearest coin and move to it manually
        local nearestCoin = findNearestCoin()
        if nearestCoin then
            moveSmoothlyToCoin(nearestCoin)
        else
            Window:Notify({
                Title = "Test Failed",
                Content = "No coins found nearby!",
                Duration = 3
            })
        end
    end
})

-- Add a button to check coin detection
FarmingTab:AddButton({
    Name = "Check Coins",
    Callback = function()
        local coinsFound = 0
        for _, coin in ipairs(game.Workspace:GetDescendants()) do
            if coin.Name == "Coin_Server" and coin:IsA("BasePart") then
                coinsFound = coinsFound + 1
            end
        end
        Window:Notify({
            Title = "Coin Check",
            Content = "Found " .. coinsFound .. " coins in workspace",
            Duration = 3
        })
    end
})
