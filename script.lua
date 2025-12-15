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

-- Global variables
getgenv().coinFarmEnabled = false
getgenv().movementSpeed = 50
getgenv().coinFarmRunning = false

-- Add a toggle for coin farming
local coinFarmToggle
coinFarmToggle = FarmingTab:AddToggle({
    Name = "Enable Coin Farming",
    Default = false,
    Callback = function(Value)
        getgenv().coinFarmEnabled = Value
        
        if Value and not getgenv().coinFarmRunning then
            -- Start farming in a separate coroutine
            task.spawn(function()
                getgenv().coinFarmRunning = true
                coinFarm()
            end)
        else
            getgenv().coinFarmRunning = false
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
    if not player or not player.Character then
        return nil
    end
    
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return nil
    end
    
    playerPosition = humanoidRootPart.Position
    
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
    
    return nearestCoin, coinsFound
end

-- Function to move smoothly to coin with better error handling
local function moveSmoothlyToCoin(coin)
    local player = game.Players.LocalPlayer
    if not player or not player.Character then
        print("Error: Player or character not found")
        return false
    end
    
    local characterRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not characterRoot then
        return false
    end
    
    local targetPosition = coin.Position
    
    -- Calculate flight path
    local distance = (targetPosition - characterRoot.Position).Magnitude
    if distance < 5 then
        -- Already close to coin, just collect it
        characterRoot.CFrame = CFrame.new(targetPosition.X, targetPosition.Y + 2, targetPosition.Z)
        return true
    end
    
    -- Use simpler movement for reliability
    local direction = (targetPosition - characterRoot.Position).Unit
    local speed = getgenv().movementSpeed or 50
    
    -- Move towards coin in steps
    local steps = math.ceil(distance / (speed / 30))
    for i = 1, steps do
        if not getgenv().coinFarmEnabled then break end
        
        if coin and coin.Parent then
            characterRoot.CFrame = characterRoot.CFrame:Lerp(
                CFrame.new(targetPosition.X, targetPosition.Y + 2, targetPosition.Z),
                0.1
            )
            task.wait(0.03) -- Smooth movement
        else
            -- Coin disappeared or collected
            break
        end
    end
    
    return true
end

-- Main coin farming function with better error handling
local function coinFarm()
    print("Coin farming started!")
    
    while getgenv().coinFarmEnabled do
        -- Wait for player character to be ready
        local player = game.Players.LocalPlayer
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            print("Waiting for character to load...")
            task.wait(1)
            goto continue
        end
        
        -- Find the nearest coin
        local nearestCoin, coinsFound = findNearestCoin()
        
        if nearestCoin then
            print("Moving to coin...")
            moveSmoothlyToCoin(nearestCoin)
            
            -- Wait at coin position briefly
            task.wait(0.5)
            
            -- After reaching, check if coin still exists
            if nearestCoin and nearestCoin.Parent then
                -- Try to collect coin
                firetouchinterest(player.Character.HumanoidRootPart, nearestCoin, 0)
                task.wait(0.1)
                firetouchinterest(player.Character.HumanoidRootPart, nearestCoin, 1)
            end
            
            task.wait(0.5) -- Wait before searching for next coin
        else
            -- No coins found, wait and try again
            task.wait(1)
        end
        
        ::continue::
    end
    
    getgenv().coinFarmRunning = false
    print("Coin farming stopped!")
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
            Window:Notify({
                Title = "Test Successful",
                Content = "Movement test completed!",
                Duration = 3
            })
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
        local _, coinsFound = findNearestCoin()
        Window:Notify({
            Title = "Coin Check",
            Content = "Found " .. coinsFound .. " coins in workspace",
            Duration = 3
        })
    end
})

-- Auto-stop farming when player leaves
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    if getgenv().coinFarmEnabled then
        task.wait(2) -- Wait for character to fully load
    end
end)
