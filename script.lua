-- واجهة سريعة للقذف فقط
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingGUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- خلفية القائمة
local menuBackground = Instance.new("Frame")
menuBackground.Parent = screenGui
menuBackground.Size = UDim2.new(0, 350, 0, 500)
menuBackground.Position = UDim2.new(0.5, -175, 0.5, -250)
menuBackground.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
menuBackground.BorderSizePixel = 0

-- زوايا مستديرة
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = menuBackground

-- عنوان
local title = Instance.new("TextLabel")
title.Parent = menuBackground
title.Size = UDim2.new(1, 0, 0, 60)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "💥 نظام القذف السريع"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.TextSize = 24
title.Font = Enum.Font.GothamBold

-- زر اختيار لاعب
local playerListButton = Instance.new("TextButton")
playerListButton.Parent = menuBackground
playerListButton.Size = UDim2.new(0.85, 0, 0, 50)
playerListButton.Position = UDim2.new(0.075, 0, 0.15, 0)
playerListButton.Text = "🎯 اختر لاعب للقذف"
playerListButton.TextSize = 18
playerListButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
playerListButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playerListButton.AutoButtonColor = true

local btnCorner1 = Instance.new("UICorner")
btnCorner1.CornerRadius = UDim.new(0, 10)
btnCorner1.Parent = playerListButton

-- زر القذف العادي
local flingButton = Instance.new("TextButton")
flingButton.Parent = menuBackground
flingButton.Size = UDim2.new(0.85, 0, 0, 50)
flingButton.Position = UDim2.new(0.075, 0, 0.28, 0)
flingButton.Text = "💨 قذف عادي"
flingButton.TextSize = 18
flingButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
flingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flingButton.AutoButtonColor = true

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 10)
btnCorner2.Parent = flingButton

-- زر القذف القوي
local strongFlingButton = Instance.new("TextButton")
strongFlingButton.Parent = menuBackground
strongFlingButton.Size = UDim2.new(0.85, 0, 0, 50)
strongFlingButton.Position = UDim2.new(0.075, 0, 0.41, 0)
strongFlingButton.Text = "💥 قذف قوي"
strongFlingButton.TextSize = 18
strongFlingButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
strongFlingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
strongFlingButton.AutoButtonColor = true

local btnCorner3 = Instance.new("UICorner")
btnCorner3.CornerRadius = UDim.new(0, 10)
btnCorner3.Parent = strongFlingButton

-- زر القذف السريع (عدة مرات)
local rapidFlingButton = Instance.new("TextButton")
rapidFlingButton.Parent = menuBackground
rapidFlingButton.Size = UDim2.new(0.85, 0, 0, 50)
rapidFlingButton.Position = UDim2.new(0.075, 0, 0.54, 0)
rapidFlingButton.Text = "⚡ قذف سريع (3 مرات)"
rapidFlingButton.TextSize = 18
rapidFlingButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
rapidFlingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rapidFlingButton.AutoButtonColor = true

local btnCorner4 = Instance.new("UICorner")
btnCorner4.CornerRadius = UDim.new(0, 10)
btnCorner4.Parent = rapidFlingButton

-- زر الرجوع
local returnButton = Instance.new("TextButton")
returnButton.Parent = menuBackground
returnButton.Size = UDim2.new(0.85, 0, 0, 50)
returnButton.Position = UDim2.new(0.075, 0, 0.67, 0)
returnButton.Text = "🏠 العودة لمكاني"
returnButton.TextSize = 18
returnButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
returnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
returnButton.AutoButtonColor = true

local btnCorner5 = Instance.new("UICorner")
btnCorner5.CornerRadius = UDim.new(0, 10)
btnCorner5.Parent = returnButton

-- مؤشر اللاعب المختار
local selectedLabel = Instance.new("TextLabel")
selectedLabel.Parent = menuBackground
selectedLabel.Size = UDim2.new(0.85, 0, 0, 40)
selectedLabel.Position = UDim2.new(0.075, 0, 0.82, 0)
selectedLabel.Text = "👤 لا يوجد لاعب محدد"
selectedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
selectedLabel.BackgroundTransparency = 1
selectedLabel.TextSize = 16

-- زر الإغلاق
local closeButton = Instance.new("TextButton")
closeButton.Parent = menuBackground
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(0.92, -17, 0.02, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.BackgroundTransparency = 1
closeButton.TextSize = 22

-- متغيرات
local SelectedPlayer = nil
local OriginalPosition = nil

-- دالة حفظ المكان
local function savePosition()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        OriginalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        selectedLabel.Text = "📍 تم حفظ مكانك"
        selectedLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    end
end

-- حفظ المكان عند الفتح
task.wait(0.5)
savePosition()

-- دالة عرض قائمة اللاعبين
local function showPlayerList()
    -- تنظيف القائمة القديمة
    for _, child in pairs(menuBackground:GetChildren()) do
        if child.Name == "PlayerOption" then
            child:Destroy()
        end
    end
    
    -- جمع اللاعبين
    local players = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(players, player)
        end
    end
    
    if #players == 0 then
        local noPlayers = Instance.new("TextLabel")
        noPlayers.Parent = menuBackground
        noPlayers.Name = "PlayerOption"
        noPlayers.Size = UDim2.new(0.85, 0, 0, 40)
        noPlayers.Position = UDim2.new(0.075, 0, 0.15, 0)
        noPlayers.Text = "⚠️ لا يوجد لاعبين آخرين"
        noPlayers.TextColor3 = Color3.fromRGB(255, 100, 100)
        noPlayers.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        return
    end
    
    -- عرض اللاعبين
    local yOffset = 0.15
    for _, player in pairs(players) do
        local playerButton = Instance.new("TextButton")
        playerButton.Parent = menuBackground
        playerButton.Name = "PlayerOption"
        playerButton.Size = UDim2.new(0.85, 0, 0, 40)
        playerButton.Position = UDim2.new(0.075, 0, yOffset, 0)
        playerButton.Text = "👤 " .. player.Name
        playerButton.TextSize = 16
        playerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        playerButton.AutoButtonColor = true
        
        local playerCorner = Instance.new("UICorner")
        playerCorner.CornerRadius = UDim.new(0, 8)
        playerCorner.Parent = playerButton
        
        -- حدث الاختيار
        playerButton.MouseButton1Click:Connect(function()
            SelectedPlayer = player
            selectedLabel.Text = "✅ تم اختيار: " .. player.Name
            selectedLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            -- إغلاق القائمة
            for _, btn in pairs(menuBackground:GetChildren()) do
                if btn.Name == "PlayerOption" then
                    task.wait(0.05)
                    btn:Destroy()
                end
            end
        end)
        
        yOffset = yOffset + 0.11
    end
end

-- دالة القذف الأساسية
local function basicFling()
    if not SelectedPlayer then
        selectedLabel.Text = "❌ اختر لاعب أولاً"
        selectedLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    if not SelectedPlayer.Character then
        selectedLabel.Text = "❌ اللاعب غير موجود"
        selectedLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    local targetRoot = SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
        selectedLabel.Text = "❌ لا يمكن قذف هذا اللاعب"
        selectedLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    -- قذف بسيط
    targetRoot.Velocity = Vector3.new(
        math.random(-8000, 8000),
        math.random(12000, 18000),
        math.random(-8000, 8000)
    )
    
    selectedLabel.Text = "💨 تم قذف: " .. SelectedPlayer.Name
    selectedLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
end

-- دالة القذف القوي
local function strongFling()
    if not SelectedPlayer then
        selectedLabel.Text = "❌ اختر لاعب أولاً"
        selectedLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    if not SelectedPlayer.Character then
        selectedLabel.Text = "❌ اللاعب غير موجود"
        selectedLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    local targetRoot = SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
        selectedLabel.Text = "❌ لا يمكن قذف هذا اللاعب"
        selectedLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    -- قذف قوي مع دوران
    for i = 1, 5 do
        targetRoot.Velocity = Vector3.new(
            math.random(-15000, 15000),
            math.random(20000, 30000),
            math.random(-15000, 15000)
        )
        targetRoot.RotVelocity = Vector3.new(
            math.random(-20000, 20000),
            math.random(-20000, 20000),
            math.random(-20000, 20000)
        )
        task.wait(0.1)
    end
    
    selectedLabel.Text = "💥 تم القذف القوي: " .. SelectedPlayer.Name
    selectedLabel.TextColor3 = Color3.fromRGB(255, 69, 0)
end

-- دالة القذف السريع
local function rapidFling()
    if not SelectedPlayer then
        selectedLabel.Text = "❌ اختر لاعب أولاً"
        selectedLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    selectedLabel.Text = "⚡ جاري القذف 3 مرات..."
    selectedLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    
    for i = 1, 3 do
        basicFling()
        task.wait(0.3)
    end
    
    selectedLabel.Text = "✅ تم القذف السريع: " .. SelectedPlayer.Name
    selectedLabel.TextColor3 = Color3.fromRGB(50, 205, 50)
end

-- دالة الرجوع
local function returnToPosition()
    if not OriginalPosition then
        savePosition()
    end
    
    if OriginalPosition and game.Players.LocalPlayer.Character then
        local humanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.CFrame = OriginalPosition
            humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            humanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
            
            selectedLabel.Text = "🏠 عدت لمكاني الأصلي"
            selectedLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
        end
    end
end

-- أحداث الأزرار
playerListButton.MouseButton1Click:Connect(showPlayerList)
flingButton.MouseButton1Click:Connect(basicFling)
strongFlingButton.MouseButton1Click:Connect(strongFling)
rapidFlingButton.MouseButton1Click:Connect(rapidFling)
returnButton.MouseButton1Click:Connect(returnToPosition)
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- إمكانية السحب
local dragging = false
local dragStart, startPos

menuBackground.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = menuBackground.Position
    end
end)

menuBackground.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        menuBackground.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

menuBackground.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- إشعار البدء
selectedLabel.Text = "🎮 واجهة القذف جاهزة"
