-- واجهة المستخدم العربية للقذف
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerActionGUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- متغيرات
local SelectedPlayer = nil

-- خلفية القائمة
local menuBackground = Instance.new("Frame")
menuBackground.Parent = screenGui
menuBackground.Size = UDim2.new(0, 320, 0, 450)
menuBackground.Position = UDim2.new(0.5, -160, 0.5, -225)
menuBackground.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
menuBackground.BorderSizePixel = 0
menuBackground.BackgroundTransparency = 0.1

-- زوايا مستديرة
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = menuBackground

-- ظل
local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = menuBackground
UIStroke.Color = Color3.fromRGB(60, 60, 60)
UIStroke.Thickness = 2

-- عنوان
local title = Instance.new("TextLabel")
title.Parent = menuBackground
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "🎮 نظام القذف"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.TextSize = 24
title.Font = Enum.Font.GothamBold

-- زر اختيار لاعب
local playerListButton = Instance.new("TextButton")
playerListButton.Parent = menuBackground
playerListButton.Size = UDim2.new(0.8, 0, 0, 50)
playerListButton.Position = UDim2.new(0.1, 0, 0.15, 0)
playerListButton.Text = "👤 اختر لاعب"
playerListButton.TextSize = 18
playerListButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
playerListButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playerListButton.AutoButtonColor = true
playerListButton.BorderSizePixel = 0

local btnCorner1 = Instance.new("UICorner")
btnCorner1.CornerRadius = UDim.new(0, 8)
btnCorner1.Parent = playerListButton

-- زر القذف
local flingButton = Instance.new("TextButton")
flingButton.Parent = menuBackground
flingButton.Size = UDim2.new(0.8, 0, 0, 50)
flingButton.Position = UDim2.new(0.1, 0, 0.3, 0)
flingButton.Text = "💨 قذف الآن"
flingButton.TextSize = 18
flingButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
flingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flingButton.AutoButtonColor = true
flingButton.BorderSizePixel = 0

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 8)
btnCorner2.Parent = flingButton

-- زر التبديل التلقائي
local autoSwitchButton = Instance.new("TextButton")
autoSwitchButton.Parent = menuBackground
autoSwitchButton.Size = UDim2.new(0.8, 0, 0, 50)
autoSwitchButton.Position = UDim2.new(0.1, 0, 0.45, 0)
autoSwitchButton.Text = "🔄 تبديل تلقائي"
autoSwitchButton.TextSize = 18
autoSwitchButton.BackgroundColor3 = Color3.fromRGB(50, 205, 50)
autoSwitchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoSwitchButton.AutoButtonColor = true
autoSwitchButton.BorderSizePixel = 0

local btnCorner3 = Instance.new("UICorner")
btnCorner3.CornerRadius = UDim.new(0, 8)
btnCorner3.Parent = autoSwitchButton

-- زر الرجوع
local returnButton = Instance.new("TextButton")
returnButton.Parent = menuBackground
returnButton.Size = UDim2.new(0.8, 0, 0, 50)
returnButton.Position = UDim2.new(0.1, 0, 0.6, 0)
returnButton.Text = "🏠 العودة"
returnButton.TextSize = 18
returnButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
returnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
returnButton.AutoButtonColor = true
returnButton.BorderSizePixel = 0

local btnCorner4 = Instance.new("UICorner")
btnCorner4.CornerRadius = UDim.new(0, 8)
btnCorner4.Parent = returnButton

-- مؤشر اللاعب المحدد
local selectedLabel = Instance.new("TextLabel")
selectedLabel.Parent = menuBackground
selectedLabel.Size = UDim2.new(0.8, 0, 0, 40)
selectedLabel.Position = UDim2.new(0.1, 0, 0.75, 0)
selectedLabel.Text = "👤 لا يوجد لاعب محدد"
selectedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
selectedLabel.BackgroundTransparency = 1
selectedLabel.TextSize = 16
selectedLabel.Font = Enum.Font.Gotham

-- زر الإغلاق
local closeButton = Instance.new("TextButton")
closeButton.Parent = menuBackground
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(0.9, -15, 0.02, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.BackgroundTransparency = 1
closeButton.TextSize = 20

-- دالة عرض قائمة اللاعبين
local function showPlayerList()
    -- مسح الأزرار القديمة
    for _, child in pairs(menuBackground:GetChildren()) do
        if child.Name == "PlayerOption" then
            child:Destroy()
        end
    end
    
    -- إنشاء قائمة اللاعبين
    local yOffset = 0.15
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
        noPlayers.Size = UDim2.new(0.8, 0, 0, 40)
        noPlayers.Position = UDim2.new(0.1, 0, yOffset, 0)
        noPlayers.Text = "⚠️ لا يوجد لاعبين"
        noPlayers.TextColor3 = Color3.fromRGB(255, 255, 255)
        noPlayers.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        noPlayers.BackgroundTransparency = 0.5
        return
    end
    
    for _, player in pairs(players) do
        local playerButton = Instance.new("TextButton")
        playerButton.Parent = menuBackground
        playerButton.Name = "PlayerOption"
        playerButton.Size = UDim2.new(0.8, 0, 0, 40)
        playerButton.Position = UDim2.new(0.1, 0, yOffset, 0)
        playerButton.Text = "🎮 " .. player.Name
        playerButton.TextSize = 16
        playerButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        playerButton.AutoButtonColor = true
        playerButton.BorderSizePixel = 0
        
        local playerCorner = Instance.new("UICorner")
        playerCorner.CornerRadius = UDim.new(0, 6)
        playerCorner.Parent = playerButton
        
        -- حدث الاختيار
        playerButton.MouseButton1Click:Connect(function()
            SelectedPlayer = player
            selectedLabel.Text = "✅ تم اختيار: " .. player.Name
            selectedLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            -- إغلاق القائمة
            for _, btn in pairs(menuBackground:GetChildren()) do
                if btn.Name == "PlayerOption" then
                    btn:Destroy()
                end
            end
        end)
        
        yOffset = yOffset + 0.12
    end
end

-- دالة القذف باستخدام دالتك الأصلية
local function performFling()
    if not SelectedPlayer then
        selectedLabel.Text = "❌ اختر لاعب أولاً"
        selectedLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    -- استخدام دالة القذف الخاصة بك
    if SHubFling then
        SHubFling(SelectedPlayer)
        selectedLabel.Text = "💨 تم قذف: " .. SelectedPlayer.Name
        selectedLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    else
        selectedLabel.Text = "❌ دالة القذف غير موجودة"
        selectedLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

-- أحداث الأزرار
playerListButton.MouseButton1Click:Connect(showPlayerList)
flingButton.MouseButton1Click:Connect(performFling)

autoSwitchButton.MouseButton1Click:Connect(function()
    -- تفعيل نظام التبديل التلقائي
    if AutoSwitchEnabled ~= nil then
        AutoSwitchEnabled = not AutoSwitchEnabled
        autoSwitchButton.Text = AutoSwitchEnabled and "🛑 أوقف التبديل" or "🔄 تبديل تلقائي"
        autoSwitchButton.BackgroundColor3 = AutoSwitchEnabled and Color3.fromRGB(255, 69, 0) or Color3.fromRGB(50, 205, 50)
    end
end)

returnButton.MouseButton1Click:Connect(function()
    -- الرجوع للمكان الأصلي
    if OriginalPosition and HumanoidRootPart then
        HumanoidRootPart.CFrame = OriginalPosition
        selectedLabel.Text = "🏠 تم الرجوع للمكان الأصلي"
        selectedLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    end
end)

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
selectedLabel.Text = "🎮 GUI للقذف جاهز"
