-- Основной GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerActionGUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Фоновый элемент меню (черное квадратно-округленное)
local menuBackground = Instance.new("Frame")
menuBackground.Parent = screenGui
menuBackground.Size = UDim2.new(0, 300, 0, 400) -- Размер меню
menuBackground.Position = UDim2.new(0.5, -150, 0.5, -200) -- Центрирование
menuBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Черный цвет
menuBackground.BorderSizePixel = 0 -- Убираем рамку
menuBackground.BackgroundTransparency = 0 -- Прозрачность фона

-- Кнопка для выбора игроков (белая квадратно-круглая)
local playerListButton = Instance.new("TextButton")
playerListButton.Parent = menuBackground
playerListButton.Size = UDim2.new(0, 200, 0, 50) -- Размер кнопки
playerListButton.Position = UDim2.new(0.5, -100, 0.4, 0) -- Положение кнопки
playerListButton.Text = "Выбрать игрока"
playerListButton.TextSize = 20
playerListButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Белый цвет
playerListButton.TextColor3 = Color3.fromRGB(0, 0, 0) -- Черный текст
playerListButton.AutoButtonColor = false -- Отключаем изменение цвета при наведении
playerListButton.BorderSizePixel = 0 -- Убираем рамку
playerListButton.ClipsDescendants = true -- Обрезка дочерних элементов
local UICorner1 = Instance.new("UICorner") -- Края кнопки
UICorner1.CornerRadius = UDim.new(0.2, 0) -- Радиус округления
UICorner1.Parent = playerListButton

-- Кнопка для флинга (внизу, белая квадратно-круглая)
local flingButton = Instance.new("TextButton")
flingButton.Parent = menuBackground
flingButton.Size = UDim2.new(0, 200, 0, 50) -- Размер кнопки
flingButton.Position = UDim2.new(0.5, -100, 0.6, 0) -- Положение кнопки
flingButton.Text = "Флинг"
flingButton.TextSize = 20
flingButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Белый цвет
flingButton.TextColor3 = Color3.fromRGB(0, 0, 0) -- Черный текст
flingButton.AutoButtonColor = false -- Отключаем изменение цвета при наведении
flingButton.BorderSizePixel = 0 -- Убираем рамку
local UICorner2 = Instance.new("UICorner") -- Края кнопки
UICorner2.CornerRadius = UDim.new(0.2, 0) -- Радиус округления
UICorner2.Parent = flingButton

-- Функция для показа списка игроков
local function showPlayerList()
    -- Удаляем предыдущие кнопки (если есть)
    for _, button in pairs(menuBackground:GetChildren()) do
        if button:IsA("TextButton") and button.Name == "PlayerButton" then
            button:Destroy()
        end
    end
    
    -- Создаём кнопку для каждого игрока
    local yOffset = 0.3
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local playerButton = Instance.new("TextButton")
            playerButton.Parent = menuBackground
            playerButton.Size = UDim2.new(0, 200, 0, 40) -- Размер кнопки
            playerButton.Position = UDim2.new(0.5, -100, yOffset, 0) -- Положение кнопки
            playerButton.Text = player.Name
            playerButton.Name = "PlayerButton"
            playerButton.BackgroundColor3 = Color3.fromRGB(0, 200, 150) -- Цвет кнопки
            playerButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- Белый текст
            playerButton.AutoButtonColor = false -- Отключаем изменение цвета при наведении
            playerButton.BorderSizePixel = 0 -- Убираем рамку
            local UICorner3 = Instance.new("UICorner") -- Края кнопки
            UICorner3.CornerRadius = UDim.new(0.2, 0) -- Радиус округления
            UICorner3.Parent = playerButton

            -- Обработка нажатия на игрока
            playerButton.MouseButton1Click:Connect(function()
                print("Вы выбрали игрока:", player.Name)
                -- Выполняем эффект "флинга"
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

                -- Создаем вращение
                for i = 1, 6 do -- Вращаем 6 раз (примерно 6 секунд)
                    humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(0, math.rad(60), 0) -- Вращение вокруг Y-оси
                    wait(0.1) -- Ожидание между вращениями
                end
                
                -- Возвращаем игрока в исходное положение
                humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position)
            end)
            
            yOffset = yOffset + 0.1 -- Смещение для следующей кнопки
        end
    end
end

-- Перемещение меню
local dragging = false
local dragStart = nil
local startPos = nil

local function onDragStart(input)
    dragging = true
    dragStart = input.Position
    startPos = menuBackground.Position
end

local function onDragMove(input)
    if dragging then
        local delta = input.Position - dragStart
        menuBackground.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

local function onDragEnd()
    dragging = false
end

-- Поддержка сенсорного управления
menuBackground.TouchStarted:Connect(function(touch)
    onDragStart(touch)
end)

menuBackground.TouchMoved:Connect(function(touch)
    onDragMove(touch)
end)

menuBackground.TouchEnded:Connect(function(touch)
    onDragEnd()
end)

-- Связь кнопки для отображения игроков
playerListButton.MouseButton1Click:Connect(showPlayerList)

-- Обработка нажатия на кнопку флинга
flingButton.MouseButton1Click:Connect(function()
    print("Флинг активирован")
    -- Логика для флинга (пока не реализована, можно добавить)
end)
