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
            startCoinFarming()
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
    
    -- Calculate flight path (ghost movement)
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
    
    local tween = game:GetService("TweenService"):Create(characterRoot, tweenInfo, goal)
    tween:Play()
    
    -- Add floating effect
    local floatTween = game:GetService("TweenService"):Create(characterRoot, 
        TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
        {CFrame = characterRoot.CFrame * CFrame.new(0, 3, 0)}
    )
    floatTween:Play()
end

-- Main coin farming function
local function startCoinFarming()
    while getgenv().coinFarmEnabled do
        -- Find the nearest coin
        local nearestCoin = findNearestCoin()
        
        if nearestCoin then
            moveSmoothlyToCoin(nearestCoin)
            -- Wait before moving to next coin
            task.wait(2)
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
