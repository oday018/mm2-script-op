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
    
    -- Enable noclip
    local character = player.Character
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    -- Add BodyVelocity for flight if not exists
    if not character:FindFirstChild("FlightBodyVelocity") then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "FlightBodyVelocity"
        bodyVelocity.Parent = character.HumanoidRootPart
        bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
    
    -- Enable flying
    character.Humanoid.PlatformStand = true
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
    local bodyVelocity = character:FindFirstChild("FlightBodyVelocity")
    if bodyVelocity then
        bodyVelocity:Destroy()
    end
    
    -- Disable flying
    character.Humanoid.PlatformStand = false
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
    local bodyVelocity = character:FindFirstChild("FlightBodyVelocity")
    if bodyVelocity then
        bodyVelocity.Velocity = direction * getgenv().flightSpeed
        
        -- Fly until reached or coin farming disabled
        while distance > 5 and getgenv().coinFarmEnabled do
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
        print("لا توجد عملات في الخريطة!")
        return nil
    end
    
    for _, coin in ipairs(coins) do
        local distance = (coin.Position - playerPos).Magnitude
        if distance < shortestDistance then
            shortestDistance = distance
            nearestCoin = coin
        end
    end
    
    print("أقرب عملة على بعد: " .. math.floor(shortestDistance) .. " متر")
    return nearestCoin
end

-- Function to collect coin
local function collectCoin(coin)
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end
    
    local character = player.Character
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- Move close to coin
    local targetPos = Vector3.new(
        coin.Position.X,
        coin.Position.Y + 2, -- Slightly above coin
        coin.Position.Z
    )
    
    flyToPosition(targetPos)
    task.wait(0.5)
    
    -- Collect coin
    if coin and coin.Parent then
        firetouchinterest(rootPart, coin, 0)
        task.wait(0.1)
        firetouchinterest(rootPart, coin, 1)
        print("تم جمع العملة!")
    end
end

-- Main farming loop
local function coinFarmLoop()
    print("بدء جمع العملات...")
    
    -- Enable flight
    enableFlight()
    
    while getgenv().coinFarmEnabled do
        -- Check if player exists
        local player = game.Players.LocalPlayer
        if not player or not player.Character then
            task.wait(1)
            goto continue
        end
        
        -- Find nearest coin
        local nearestCoin = findNearestCoin()
        
        if nearestCoin then
            print("التوجه إلى أقرب عملة...")
            collectCoin(nearestCoin)
            task.wait(0.5) -- Wait before next coin
        else
            print("جاري البحث عن عملات...")
            task.wait(1)
        end
        
        ::continue::
    end
    
    -- Disable flight when stopping
    disableFlight()
    print("توقف جمع العملات")
end

-- Auto-enable flight when farming starts
game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().coinFarmEnabled then
        enableFlight()
    end
end)

-- Add a notification when script loads
Window:Notify({
    Title = "Coin Farming Hub",
    Content = "تم تحميل السكربت! شغل جمع العملات للبدء.",
    Image = "rbxassetid://10734953451",
    Duration = 5
})

-- Add test button
FarmingTab:AddButton({
    Name = "تجربة الطيران",
    Callback = function()
        enableFlight()
        Window:Notify({
            Title = "تجربة ناجحة",
            Content = "تم تفعيل الطيران! تحرك باستخدام W A S D",
            Duration = 3
        })
    end
})

-- Add stop flight button
FarmingTab:AddButton({
    Name = "إيقاف الطيران",
    Callback = function()
        disableFlight()
        Window:Notify({
            Title = "تم الإيقاف",
            Content = "تم إيقاف وضع الطيران",
            Duration = 3
        })
    end
})

-- Add check coins button
FarmingTab:AddButton({
    Name = "فحص العملات",
    Callback = function()
        local coins = getAllCoins()
        Window:Notify({
            Title = "عدد العملات",
            Content = "تم العثور على " .. #coins .. " عملة",
            Duration = 3
        })
    end
})

-- Auto-stop when player leaves
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    if getgenv().coinFarmEnabled then
        task.wait(2)
        enableFlight()
    end
end)
